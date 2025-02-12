pub fn add_signals_from_pt(comptime Device: type, gi_signals: *[Device.num_gis_per_glb]?Device.Signal, pt: lc4k.Product_Term(Device.Signal)) !void {
    for (pt.factors) |factor| switch (factor) {
        .always, .never => {},
        .when_high, .when_low => |grp| {
            for (gi_signals) |*existing_grp| {
                if (existing_grp.* == null) {
                    existing_grp.* = grp;
                    break;
                } else if (existing_grp.* == grp) {
                    break;
                }
            } else {
                return error.TooManySignalsInGLB;
            }
        },
    };
}

pub fn route_generic_inputs(comptime Device: type, gi_signals: *[Device.num_gis_per_glb]?Device.Signal, rnd: std.Random, glb: lc4k.GLB_Index, results: *assembly.Assembly_Results) !void {
    var routed = [_]?Device.Signal { null } ** Device.num_gis_per_glb;

    @setEvalBranchQuota(2000);

    const gi_options_by_grp: std.EnumMap(Device.Signal, []const u8) = Device.gi_options_by_grp;
    for (gi_signals) |maybe_signal| if (maybe_signal) |signal| {
        var signal_to_route = signal;
        var attempts: usize = 0;
        while (attempts < 1000) : (attempts += 1) {
            const options = gi_options_by_grp.get(signal_to_route) orelse return error.Invalid_Signal;
            for (options) |option| {
                if (routed[option] == null) {
                    routed[option] = signal_to_route;
                    //std.debug.print("GI {} is now {}\n", .{ option, signal_to_route });
                    break;
                }
            } else {
                const index_to_replace = options[rnd.intRangeLessThan(usize, 0, options.len)];
                const temp = routed[index_to_replace].?;
                routed[index_to_replace] = signal_to_route;
                //std.debug.print("GI {} is now {}; replaced {}\n", .{ index_to_replace, signal_to_route, temp });
                signal_to_route = temp;
                continue;
            }
            break;
        } else {
            try results.errors.append(.{
                .err = error.GI_Routing_Failed,
                .details = "Could not find available GI for signal",
                .glb = glb,
                .grp_ordinal = @intFromEnum(signal_to_route),
            });
        }
    };

    gi_signals.* = routed;
}

pub const Cluster_Router = struct {
    glb: lc4k.GLB_Index,
    cluster_size: [16]u8,
    sum_size: [16]u8,
    forced_cluster_routing: [16]?Cluster_Routing,
    forced_wide_routing: [16]?Wide_Routing,

    open_heap: std.PriorityQueue(Compact_Routing_Data, *Cluster_Router, compare_priority),
    open_set: std.AutoHashMap(u48, void),
    closed_set: std.AutoHashMap(u48, void),

    pub fn init(allocator: std.mem.Allocator, comptime Device: type, glb: lc4k.GLB_Index, glb_config: lc4k.GLB_Config(Device)) Cluster_Router {
        std.debug.assert(Device.num_mcs_per_glb == 16);

        var self = Cluster_Router {
            .glb = glb,
            .cluster_size = [_]u8 { 0 } ** 16,
            .sum_size = [_]u8 { 0 } ** 16,
            .forced_cluster_routing = [_]?Cluster_Routing { null } ** 16,
            .forced_wide_routing = [_]?Wide_Routing { null } ** 16,
            .open_heap = undefined,
            .open_set = std.AutoHashMap(u48, void).init(allocator),
            .closed_set = std.AutoHashMap(u48, void).init(allocator),
        };
        self.open_heap = std.PriorityQueue(Compact_Routing_Data, *Cluster_Router, compare_priority).init(allocator, &self);

        for (glb_config.mc, 0..) |mc_config, mc| {
            var available: u8 = 0;
            var special_pt: u8 = 0;
            while (special_pt < 5) : (special_pt += 1) {
                if (assembly.get_special_pt(Device, mc_config, special_pt) == null) {
                    available += 1;
                }
            }
            if (Device.family != .zero_power_enhanced) {
                switch (mc_config.output.routing) {
                    .same_as_oe, .self => {},
                    .five_pt_fast_bypass => available = 0,
                }
            }
            if (mc_config.sum_routing) |routing| self.forced_cluster_routing[mc] = routing;
            if (mc_config.wide_sum_routing) |routing| self.forced_wide_routing[mc] = routing;

            self.cluster_size[mc] = available;

            switch (mc_config.logic) {
                .sum => |sp| {
                    if (!lc4k.is_sum_always(sp.sum)) {
                        self.sum_size[mc] = @intCast(sp.sum.len);
                    }
                },
                .sum_xor_pt0 => |sxpt| {
                    if (!lc4k.is_sum_always(sxpt.sum)) {
                        self.sum_size[mc] = @intCast(sxpt.sum.len);
                    }
                },
                .sum_xor_input_buffer => |sum| {
                    if (!lc4k.is_sum_always(sum)) {
                        self.sum_size[mc] = @intCast(sum.len);
                    }
                },
                .input_buffer, .pt0 => {},
            }
        }

        return self;
    }

    pub fn deinit(self: *Cluster_Router) void {
        self.open_heap.deinit();
        self.open_set.deinit();
        self.closed_set.deinit();
    }

    fn compare_priority(self: *Cluster_Router, a: Compact_Routing_Data, b: Compact_Routing_Data) std.math.Order {
        const a_score = a.compute_score(self.cluster_size, self.sum_size).weighted;
        const b_score = b.compute_score(self.cluster_size, self.sum_size).weighted;
        return std.math.order(a_score, b_score); // min heap
    }

    pub fn route(self: *Cluster_Router, results: *assembly.Assembly_Results) !Routing_Data {
        for (self.sum_size, 0..) |sum_size, mc| if (sum_size > 0) {
            try self.mark_forced_wide_routing(mc, .self);
        };
        for (self.sum_size, 0..) |sum_size, mc| if (sum_size > 0) {
            var max_pts = self.compute_max_pts_without_wide_routing(mc);
            var next_ca = get_next_ca(mc);
            while (max_pts < sum_size) : (next_ca = get_next_ca(next_ca)) {
                if (next_ca == mc) {
                    return error.Too_Many_PTs;
                }
                try self.mark_forced_wide_routing(next_ca, .self_plus_four);
                max_pts += self.compute_max_pts_without_wide_routing(next_ca);
            }
        };

        var initial_routing: Compact_Routing_Data = undefined;
        for (self.forced_cluster_routing, 0..) |r, cluster| {
            initial_routing.set_cluster_routing(cluster, r orelse .self);
        }
        for (self.forced_wide_routing, 0..) |r, ca| {
            initial_routing.set_wide_routing(ca, r orelse .self);
        }

        const ordered_cluster_routings = [_]Cluster_Routing {
            .self_minus_two,
            .self_minus_one,
            .self_plus_one,
            .self,
        };

        loop: while (true) {
            const available_pts = initial_routing.get_available_pts(self.cluster_size);

            for (self.forced_cluster_routing, 0..) |forced_routing, cluster| if (forced_routing == null) {
                const target_mc = initial_routing.get_ca_target(get_ca_for_cluster(cluster, initial_routing.get_cluster_routing(cluster)).?);
                const sum_size = self.sum_size[target_mc];
                if (sum_size + self.cluster_size[cluster] <= available_pts[target_mc]) {
                    // We can donate this cluster to another MC without hurting our target MC
                    // After donating it, it may free up another cluster to be eligible for donation,
                    // so we should continue checking all the MCs until none can be donated.
                    inline for (ordered_cluster_routings) |routing| {
                        if (initial_routing.try_donate_cluster(cluster, self.sum_size, self.cluster_size, routing, false)) {
                            continue :loop;
                        }
                    }
                    if (sum_size == 0) {
                        // If our target MC doesn't need any clusters at all, and all nearby clusters
                        // are already satisfied, but do have at least one sum term, donate this cluster
                        // anyway.  This may free up another cluster in an area where there's lots of
                        // contention.
                        inline for (ordered_cluster_routings) |routing| {
                            if (initial_routing.try_donate_cluster(cluster, self.sum_size, self.cluster_size, routing, true)) {
                                continue :loop;
                            }
                        }
                    }
                }
            };


            for (self.forced_wide_routing, 0..) |forced_routing, ca| {
                if (forced_routing == null and initial_routing.try_donate_ca(ca, self.sum_size, self.cluster_size)) {
                    continue :loop;
                }
            }

            break;
        }

        var available_pts = initial_routing.get_available_pts(self.cluster_size);
        // un-donate any superfluous clusters
        for (self.forced_cluster_routing, 0..) |forced_routing, cluster| {
            if (forced_routing == null and initial_routing.get_cluster_routing(cluster) != .self and initial_routing.get_wide_routing(cluster) == .self and self.sum_size[cluster] == 0) {
                const cluster_size = self.cluster_size[cluster];
                const target_mc = initial_routing.get_ca_target(get_ca_for_cluster(cluster, initial_routing.get_cluster_routing(cluster)).?);
                const sum_size = self.sum_size[target_mc];
                if (sum_size + cluster_size <= available_pts[target_mc]) {
                    available_pts[target_mc] -= cluster_size;
                    initial_routing.set_cluster_routing(cluster, .self);
                    available_pts[cluster] += cluster_size;
                }
            }
        }

        try self.open_set.put(@bitCast(initial_routing), {});
        try self.open_heap.add(initial_routing);

        // in case we can't find a successful routing, keep track of the closest we got
        var best_routing: Compact_Routing_Data = undefined;
        var best_weighted_score: usize = std.math.maxInt(usize);

        while (self.open_heap.removeOrNull()) |routing| {
            const score = routing.compute_score(self.cluster_size, self.sum_size);
            if (score.weighted < best_weighted_score) {
                best_routing = routing;
                best_weighted_score = score.weighted;
            }

            if (score.success == 0) {
                return Routing_Data.init(routing);
            }

            for (self.forced_cluster_routing, 0..) |forced_routing, cluster| if (forced_routing == null) {
                inline for (comptime std.enums.values(Cluster_Routing)) |cluster_routing| {
                    if (cluster_routing != routing.get_cluster_routing(cluster)) {
                        if (get_ca_for_cluster(cluster, cluster_routing)) |ca| {
                            const target_mc = routing.get_ca_target(ca);
                            if (self.sum_size[target_mc] > 0) {
                                var new_routing = routing;
                                new_routing.set_cluster_routing(cluster, cluster_routing);
                                const new_score = new_routing.compute_score(self.cluster_size, self.sum_size);
                                if (new_score.success <= score.success and !self.closed_set.contains(@bitCast(new_routing))) {
                                    try self.open_set.put(@bitCast(new_routing), {});
                                    try self.open_heap.add(new_routing);
                                }
                            }
                        }
                    }
                }
            };
            for (self.forced_wide_routing, 0..) |forced_routing, ca| if (forced_routing == null) {
                inline for (comptime std.enums.values(Wide_Routing)) |wide_routing| {
                    if (wide_routing != routing.get_wide_routing(ca)) {
                        const target_mc = routing.get_ca_target(get_ca_destination(ca, wide_routing));
                        if (self.sum_size[target_mc] > 0) {
                            var new_routing = routing;
                            new_routing.set_wide_routing(ca, wide_routing);
                            const new_score = new_routing.compute_score(self.cluster_size, self.sum_size);
                            if (new_score.success <= score.success and !self.closed_set.contains(@bitCast(new_routing))) {
                                try self.open_set.put(@bitCast(new_routing), {});
                                try self.open_heap.add(new_routing);
                            }
                        }
                    }
                }
            };

            try self.closed_set.put(@bitCast(routing), {});
            _ = self.open_set.remove(@bitCast(routing));
        }

        try results.errors.append(.{
            .err = error.Cluster_Routing_Failed,
            .details = "Failed to find a cluster routing that allocates sufficient PTs to all MCs",
            .glb = @intCast(self.glb),
        });
        // We'll report info on the details of MCs that weren't completely routed later in the assembly process
        return Routing_Data.init(best_routing);
    }

    fn get_next_ca(ca: usize) usize {
        var maybe_oob_ca: i32 = @intCast(ca);
        maybe_oob_ca -= 4;
        return @intCast(@mod(maybe_oob_ca, 16));
    }

    fn mark_forced_wide_routing(self: *Cluster_Router, mc: usize, routing: Wide_Routing) !void {
        if (self.forced_wide_routing[mc]) |existing_routing| {
            if (existing_routing != routing) {
                return error.Invalid_Wide_Routing;
            }
        }
        self.forced_wide_routing[mc] = routing;
    }

    fn compute_max_pts_without_wide_routing(self: Cluster_Router, mc: usize) usize {
        var num_pts: usize = self.cluster_size[mc];
        if (mc > 0) {
            num_pts += self.cluster_size[mc - 1];
        }
        if (mc < 15) {
            num_pts += self.cluster_size[mc + 1];
            if (mc < 14) {
                num_pts += self.cluster_size[mc + 2];
            }
        }
        return num_pts;
    }

};


const Routing_Score = struct {
    success: usize,
    weighted: usize,
};

const Compact_Routing_Data = packed struct (u48) {
    c0: Cluster_Routing,
    c1: Cluster_Routing,
    c2: Cluster_Routing,
    c3: Cluster_Routing,
    c4: Cluster_Routing,
    c5: Cluster_Routing,
    c6: Cluster_Routing,
    c7: Cluster_Routing,
    c8: Cluster_Routing,
    c9: Cluster_Routing,
    c10: Cluster_Routing,
    c11: Cluster_Routing,
    c12: Cluster_Routing,
    c13: Cluster_Routing,
    c14: Cluster_Routing,
    c15: Cluster_Routing,
    w0: Wide_Routing,
    w1: Wide_Routing,
    w2: Wide_Routing,
    w3: Wide_Routing,
    w4: Wide_Routing,
    w5: Wide_Routing,
    w6: Wide_Routing,
    w7: Wide_Routing,
    w8: Wide_Routing,
    w9: Wide_Routing,
    w10: Wide_Routing,
    w11: Wide_Routing,
    w12: Wide_Routing,
    w13: Wide_Routing,
    w14: Wide_Routing,
    w15: Wide_Routing,


    pub fn get_cluster_routing(self: Compact_Routing_Data, cluster: usize) Cluster_Routing {
        return switch (cluster) {
            0 => self.c0,
            1 => self.c1,
            2 => self.c2,
            3 => self.c3,
            4 => self.c4,
            5 => self.c5,
            6 => self.c6,
            7 => self.c7,
            8 => self.c8,
            9 => self.c9,
            10 => self.c10,
            11 => self.c11,
            12 => self.c12,
            13 => self.c13,
            14 => self.c14,
            15 => self.c15,
            else => unreachable,
        };
    }
    pub fn set_cluster_routing(self: *Compact_Routing_Data, cluster: usize, routing: Cluster_Routing) void {
        switch (cluster) {
            0 => self.c0 = routing,
            1 => self.c1 = routing,
            2 => self.c2 = routing,
            3 => self.c3 = routing,
            4 => self.c4 = routing,
            5 => self.c5 = routing,
            6 => self.c6 = routing,
            7 => self.c7 = routing,
            8 => self.c8 = routing,
            9 => self.c9 = routing,
            10 => self.c10 = routing,
            11 => self.c11 = routing,
            12 => self.c12 = routing,
            13 => self.c13 = routing,
            14 => self.c14 = routing,
            15 => self.c15 = routing,
            else => unreachable,
        }
    }

    pub fn get_wide_routing(self: Compact_Routing_Data, ca: usize) Wide_Routing {
        return switch (ca) {
            0 => self.w0,
            1 => self.w1,
            2 => self.w2,
            3 => self.w3,
            4 => self.w4,
            5 => self.w5,
            6 => self.w6,
            7 => self.w7,
            8 => self.w8,
            9 => self.w9,
            10 => self.w10,
            11 => self.w11,
            12 => self.w12,
            13 => self.w13,
            14 => self.w14,
            15 => self.w15,
            else => unreachable,
        };
    }

    pub fn set_wide_routing(self: *Compact_Routing_Data, ca: usize, routing: Wide_Routing) void {
        switch (ca) {
            0 => self.w0 = routing,
            1 => self.w1 = routing,
            2 => self.w2 = routing,
            3 => self.w3 = routing,
            4 => self.w4 = routing,
            5 => self.w5 = routing,
            6 => self.w6 = routing,
            7 => self.w7 = routing,
            8 => self.w8 = routing,
            9 => self.w9 = routing,
            10 => self.w10 = routing,
            11 => self.w11 = routing,
            12 => self.w12 = routing,
            13 => self.w13 = routing,
            14 => self.w14 = routing,
            15 => self.w15 = routing,
            else => unreachable,
        }
    }

    pub fn get_available_pts(self: Compact_Routing_Data, cluster_size: [16]u8) [16]u16 {
        var available_pts = [_]u16 { 0 } ** 16;
        for (cluster_size, 0..) |size, cluster| {
            available_pts[get_ca_for_cluster(cluster, self.get_cluster_routing(cluster)).?] += size;
        }
        for (available_pts, 0..) |available, ca| {
            const target = self.get_ca_target(ca);
            if (target != ca) {
                available_pts[target] += available;
                available_pts[ca] = 0;
            }
        }
        return available_pts;
    }

    pub fn compute_score(self: Compact_Routing_Data, cluster_size: [16]u8, sum_size: [16]u8) Routing_Score {
        var score = Routing_Score { .success = 0, .weighted = 0 };
        var available_pts = [_]u16 { 0 } ** 16;
        for (cluster_size, 0..) |size, cluster| {
            const routing = self.get_cluster_routing(cluster);
            available_pts[get_ca_for_cluster(cluster, routing).?] += size;
            if (routing != .self) {
                score.weighted += 1;
            }
        }
        for (available_pts, 0..) |available, ca| {
            const routing = self.get_wide_routing(ca);
            if (routing != .self) {
                available_pts[get_ca_destination(ca, routing)] += available;
                available_pts[ca] = 0;
                score.weighted += 800;
            }
        }

        for (sum_size, 0..) |required_pts, mc| {
            if (required_pts > available_pts[mc]) {
                score.success += @as(usize, 10) + required_pts - available_pts[mc];
            }
        }
        score.weighted += score.success;
        return score;
    }

    pub fn try_donate_cluster(self: *Compact_Routing_Data, cluster: usize, sum_size: [16]u8, cluster_size: [16]u8, donation_routing: Cluster_Routing, relaxed: bool) bool {
        if (self.get_cluster_routing(cluster) == donation_routing) return false;
        const donee = get_ca_for_cluster(cluster, donation_routing) orelse return false;
        const new_target_mc = self.get_ca_target(donee);
        if (relaxed and sum_size[new_target_mc] > 0 or sum_size[new_target_mc] > self.get_available_pts(cluster_size)[new_target_mc]) {
            self.set_cluster_routing(cluster, donation_routing);
            return true;
        } else {
            return false;
        }
    }

    pub fn try_donate_ca(self: *Compact_Routing_Data, ca: usize, sum_size: [16]u8, cluster_size: [16]u8) bool {
        if (self.get_wide_routing(ca) != .self) return false;
        const donee = get_ca_destination(ca, .self_plus_four);
        const target_mc = self.get_ca_target(donee);
        if (sum_size[target_mc] > self.get_available_pts(cluster_size)[target_mc]) {
            self.set_wide_routing(ca, .self_plus_four);
            return true;
        } else {
            return false;
        }
    }

    pub fn get_ca_target(self: Compact_Routing_Data, initial_ca: usize) usize {
        var ca = initial_ca;
        while (true) {
            const new_ca = get_ca_destination(ca, self.get_wide_routing(ca));
            if (new_ca == ca) return ca;
            std.debug.assert(new_ca != initial_ca);
            ca = new_ca;
        }
    }

};

pub const Routing_Data = struct {
    cluster: [16]Cluster_Routing = .{ .self } ** 16,
    wide: [16]Wide_Routing = .{ .self } ** 16,

    fn init(compact: Compact_Routing_Data) Routing_Data {
        var self: Routing_Data = undefined;
        comptime var i = 0;
        inline while (i < 16) : (i += 1) {
            self.cluster[i] = compact.get_cluster_routing(i);
            self.wide[i] = compact.get_wide_routing(i);
        }
        return self;
    }

    const Get_CA_Target_Result = struct {
        macrocell: usize,
        hops: usize,
    };

    fn get_ca_target_limited(self: Routing_Data, initial_ca: usize, max_hops: usize) ?Get_CA_Target_Result {
        var ca = initial_ca;
        var hop: usize = 0;
        while (hop <= max_hops) : (hop += 1) {
            const new_ca = get_ca_destination(ca, self.wide[ca]);
            if (new_ca == ca) return .{
                .macrocell = ca,
                .hops = hop,
            };
            std.debug.assert(new_ca != initial_ca);
            ca = new_ca;
        }
        return null;
    }

    pub fn iterator(self: Routing_Data, comptime Device: type, glb_config: *const lc4k.GLB_Config(Device), mc: usize) PT_Iterator(Device) {
        return .{
            .glb_config = glb_config,
            .data = self,
            .mc = @intCast(mc),
            .cluster = @intCast(@mod(mc + Device.num_mcs_per_glb - 1, Device.num_mcs_per_glb)),
            .next_pt = 5,
            .hops = -1,
            .has_more_hops = true,
        };
    }
};

fn PT_Iterator(comptime Device: type) type {
    return struct {
        glb_config: *const lc4k.GLB_Config(Device),
        data: Routing_Data,
        mc: u8,
        cluster: u8,
        next_pt: u8,
        hops: i8,
        has_more_hops: bool,

        const Self = @This();

        // returns the column offset of a PT (0-79), relative to the GLB Fuse_Range
        // only visits PTs from clusters that are routed to `self.mc`, and aren't
        // reallocated for special usage by a MC/OE/etc.  Wide-routed clusters will
        // be visited after directly routed clusters, such that the PTs will be
        // visited in order of ascending propagation delay.
        pub fn next(self: *Self) ?usize {
            while (true) {
                const pt = self.next_pt;
                if (pt >= 5) {
                    const next_cluster = @mod(self.cluster + 1, Device.num_mcs_per_glb);
                    if (next_cluster == self.mc) {
                        if (self.has_more_hops) {
                            self.has_more_hops = false;
                            self.hops += 1;
                        } else {
                            return null;
                        }
                    }
                    self.cluster = next_cluster;
                    if (get_ca_for_cluster(next_cluster, self.data.cluster[next_cluster])) |ca| {
                        const max_hops = self.hops;
                        if (self.data.get_ca_target_limited(ca, @intCast(max_hops))) |result| {
                            if (result.macrocell != self.mc or result.hops < max_hops) continue;
                        } else {
                            self.has_more_hops = true;
                            continue;
                        }
                    } else {
                        continue;
                    }
                    self.next_pt = 0;
                } else {
                    self.next_pt += 1;
                    const mc_config = &self.glb_config.mc[self.cluster];
                    if (Device.family != .zero_power_enhanced) {
                        switch (mc_config.output.routing) {
                            .same_as_oe, .self => {},
                            .five_pt_fast_bypass => continue,
                        }
                    }
                    if (assembly.get_special_pt(Device, mc_config.*, pt) == null) {
                        return self.cluster * 5 + pt;
                    }
                }
            }
        }
    };
}

pub fn get_ca_for_cluster(source_cluster: usize, routing: Cluster_Routing) ?usize {
    return switch (routing) {
        .self_minus_two => if (source_cluster >= 2) source_cluster - 2 else null,
        .self_minus_one => if (source_cluster >= 1) source_cluster - 1 else null,
        .self => source_cluster,
        .self_plus_one => if (source_cluster < 15) source_cluster + 1 else null,
    };
}

pub fn get_ca_destination(source_ca: usize, routing: Wide_Routing) usize {
    const maybe_oob_ca = switch (routing) {
        .self => source_ca,
        .self_plus_four => source_ca + 4,
    };
    return @mod(maybe_oob_ca, 16);
}

const Cluster_Routing = lc4k.Cluster_Routing;
const Wide_Routing = lc4k.Wide_Routing;
const assembly = @import("assembly.zig");
const lc4k = @import("lc4k.zig");
const std = @import("std");
