
pub fn Chip_Util(comptime Chip: type) type {
    return struct {
        pub const Add1_Options = struct {
            a: Chip.Signal,
            b: Chip.Signal,
            ci: ?Chip.Signal = null,
            sum: Chip.Signal,
            co: ?Chip.Signal = null,
            p: ?Chip.Signal = null,
            g: ?Chip.Signal = null,
            k: ?Chip.Signal = null,
        };
        /// 1-bit full adder with optional carry signals (any combination of in, out, generate, propagate, kill)
        /// Minimally uses 1 macrocell and 1 PT cluster
        /// carry out/propagate/generate/kill outputs add +1 MC, +1 PTC for each used
        pub fn add1(chip: *Chip, comptime options: Add1_Options) void {
            const a = options.a;
            const b = options.b;

            if (options.ci) |ci| {
                chip.mc(options.sum.mc()).logic = comptime .{
                    .sum_xor_pt0 = .{
                        .sum = &.{
                            ci.when_high().pt().and_factor(b.when_low()),
                            ci.when_low().pt().and_factor(b.when_high()),
                        },
                        .pt0 = a.when_high().pt(),
                        .polarity = .positive,
                    },
                };
                if (options.co) |co| {
                    chip.mc(co.mc()).logic = comptime .{ .sum = .{
                        .sum = &.{
                            a.when_high().pt().and_factor(b.when_high()),
                            a.when_high().pt().and_factor(ci.when_high()),
                            b.when_high().pt().and_factor(ci.when_high()),
                        },
                        .polarity = .positive,
                    }};
                }
            } else {
                chip.mc(options.sum.mc()).logic = comptime .{
                    .sum_xor_pt0 = .{
                        .sum = &.{ b.when_high().pt() },
                        .pt0 = a.when_high().pt(),
                        .polarity = .positive,
                    },
                };
                if (options.co) |co| {
                    chip.mc(co.mc()).logic = comptime .{ .sum = .{
                        .sum = &.{
                            a.when_high().pt().and_factor(b.when_high()),
                        },
                        .polarity = .positive,
                    }};
                }
            }

            if (options.g) |g| {
                chip.mc(g.mc()).logic = comptime .{ .sum = .{
                    .sum = &.{
                        a.when_high().pt().and_factor(b.when_high()),
                    },
                    .polarity = .positive,
                }};
            }

            if (options.p) |p| {
                chip.mc(p.mc()).logic = comptime .{ .sum = .{
                    .sum = &.{
                        a.when_high().pt(),
                        b.when_high().pt(),
                    },
                    .polarity = .positive,
                }};
            }

            if (options.k) |k| {
                chip.mc(k.mc()).logic = comptime .{ .sum = .{
                    .sum = &.{
                        a.when_low().pt().and_factor(b.when_low()),
                    },
                    .polarity = .positive,
                }};
            }
        }

        pub const Add2_Options = struct {
            a: *const [2]Chip.Signal,
            b: *const [2]Chip.Signal,
            ci: ?Chip.Signal = null,
            sum: *const [2]Chip.Signal,
            co: ?Chip.Signal = null,
            p: ?Chip.Signal = null,
            g: ?Chip.Signal = null,
            k: ?Chip.Signal = null,
        };
        /// 2-bit adder with optional carry signals (any combination of in, out, generate, propagate, kill)
        /// This level of flattening represents a good balance between PT cluster/MC usage and propagation delay.
        /// Without carry in, uses 2 macrocells and 2 PT clusters (+1 MC, +1 PTC if carry out is used)
        /// With carry in, uses 2 macrocells and 3 PT clusters (+1 MC, +2 PTC if carry out is used)
        /// propagate/generate/kill outputs always add +1 MC, +1 PTC for each used (not affected by carry in/out)
        /// So for a typical CLA usage (using ci/p/g, but not co/k) usage is 4 MCs and 5 PTCs
        pub fn add2(chip: *Chip, comptime options: Add2_Options) void {
            const a = options.a;
            const b = options.b;

            if (options.ci) |ci| {
                chip.mc(options.sum[0].mc()).logic = comptime .{
                    .sum_xor_pt0 = .{
                        .sum = &.{
                            ci.when_high().pt().and_factor(b[0].when_low()),
                            ci.when_low().pt().and_factor(b[0].when_high()),
                        },
                        .pt0 = a[0].when_high().pt(),
                        .polarity = .positive,
                    },
                };
                // carry0 = a[0] & b[0]
                //        | a[0] & ci
                //        | b[0] & ci
                chip.mc(options.sum[1].mc()).logic = comptime .{
                    .sum_xor_pt0 = .{
                        .sum = &.{ // b[1] xor carry0
                            b[1].when_high().pt().and_factor(a[0].when_low()).and_factor(b[0].when_low()),
                            b[1].when_high().pt().and_factor(a[0].when_low()).and_factor(ci.when_low()),
                            b[1].when_high().pt().and_factor(b[0].when_low()).and_factor(ci.when_low()),
                            b[1].when_low().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                            b[1].when_low().pt().and_factor(a[0].when_high()).and_factor(ci.when_high()),
                            b[1].when_low().pt().and_factor(b[0].when_high()).and_factor(ci.when_high()),
                        },
                        .pt0 = a[1].when_high().pt(),
                        .polarity = .positive,
                    },
                };
                if (options.co) |co| {
                    chip.mc(co.mc()).logic = comptime .{ .sum = .{
                        .sum = &.{
                            a[1].when_high().pt().and_factor(b[1].when_high()),
                            a[1].when_high().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                            b[1].when_high().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                            a[1].when_high().pt().and_factor(a[0].when_high()).and_factor(ci.when_high()),
                            b[1].when_high().pt().and_factor(a[0].when_high()).and_factor(ci.when_high()),
                            a[1].when_high().pt().and_factor(b[0].when_high()).and_factor(ci.when_high()),
                            b[1].when_high().pt().and_factor(b[0].when_high()).and_factor(ci.when_high()),
                        },
                        .polarity = .positive,
                    }};
                }
            } else {
                chip.mc(options.sum[0].mc()).logic = comptime .{
                    .sum_xor_pt0 = .{
                        .sum = &.{ b[0].when_high().pt() },
                        .pt0 = a[0].when_high().pt(),
                        .polarity = .positive,
                    },
                };
                // carry0 = a[0] & b[0]
                chip.mc(options.sum[1].mc()).logic = comptime .{
                    .sum_xor_pt0 = .{
                        .sum = &.{ // b[1] xor carry0
                            b[1].when_high().pt().and_factor(a[0].when_low()),
                            b[1].when_high().pt().and_factor(b[0].when_low()),
                            b[1].when_low().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                        },
                        .pt0 = a[1].when_high().pt(),
                        .polarity = .positive,
                    },
                };
                if (options.co) |co| {
                    chip.mc(co.mc()).logic = comptime .{ .sum = .{
                        .sum = &.{
                            a[1].when_high().pt().and_factor(b[1].when_high()),
                            a[1].when_high().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                            b[1].when_high().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                        },
                        .polarity = .positive,
                    }};
                }
            }

            // p[i] = a[i] | b[i]
            // g[i] = a[i] & b[i]
            // k[i] = ~a[i] & ~b[i]

            if (options.g) |g| {
                // g = g[1] | p[1] & g[0]
                chip.mc(g.mc()).logic = comptime .{ .sum = .{
                    .sum = &.{
                        a[1].when_high().pt().and_factor(b[1].when_high()),
                        a[1].when_high().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                        b[1].when_high().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                    },
                    .polarity = .positive,
                }};
            }

            if (options.p) |p| {
                // p = p[1] & p[0]
                chip.mc(p.mc()).logic = comptime .{ .sum = .{
                    .sum = &.{
                        a[1].when_high().pt().and_factor(a[0].when_high()),
                        a[1].when_high().pt().and_factor(b[0].when_high()),
                        b[1].when_high().pt().and_factor(a[0].when_high()),
                        b[1].when_high().pt().and_factor(b[0].when_high()),
                    },
                    .polarity = .positive,
                }};
            }

            if (options.k) |k| {
                // k = k[1] | ~g[1] & k[0]
                chip.mc(k.mc()).logic = comptime .{ .sum = .{
                    .sum = &.{
                        a[1].when_low().pt().and_factor(b[1].when_low()),
                        a[1].when_low().pt().and_factor(a[0].when_low()).and_factor(b[0].when_low()),
                        b[1].when_low().pt().and_factor(a[0].when_low()).and_factor(b[0].when_low()),
                    },
                    .polarity = .positive,
                }};
            }
        }

        pub const Add3_Options = struct {
            a: *const [3]Chip.Signal,
            b: *const [3]Chip.Signal,
            sum: *const [3]Chip.Signal,
            co: ?Chip.Signal = null,
        };
        /// 3-bit adder without carry in and with optional carry out.
        /// Useful as the LSB adder when overall cin is always going to be 0.
        /// Note there's no point in P/G/K outputs in this case since the final carry out can be calculated just as quickly.
        /// Uses 3 macrocells and 4 PT clusters (without carry out)
        /// Uses 4 macrocells and 6 PT clusters (with carry out)
        pub fn add3(chip: *Chip, comptime options: Add3_Options) void {
            const a = options.a;
            const b = options.b;
            
            chip.mc(options.sum[0].mc()).logic = comptime .{
                .sum_xor_pt0 = .{
                    .sum = &.{ b[0].when_high().pt() },
                    .pt0 = a[0].when_high().pt(),
                    .polarity = .positive,
                },
            };
            // carry0 = a[0] & b[0]
            chip.mc(options.sum[1].mc()).logic = comptime .{
                .sum_xor_pt0 = .{
                    .sum = &.{ // b[1] xor carry0
                        b[1].when_high().pt().and_factor(a[0].when_low()),
                        b[1].when_high().pt().and_factor(b[0].when_low()),
                        b[1].when_low().pt().and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                    },
                    .pt0 = a[1].when_high().pt(),
                    .polarity = .positive,
                },
            };
            // carry1 = a[1] & b[1] | a[1] & a[0] & b[0] | b[1] & a[0] & b[0]
            // ~carry1 = ~a[1] & ~b[1] | ~a[1] & ~a[0] | ~a[1] & ~b[0] | ~b[1] & ~a[0] | ~b[1] & ~b[0]
            chip.mc(options.sum[2].mc()).logic = comptime .{
                .sum_xor_pt0 = .{
                    .sum = &.{ // b[2] xor carry1
                        b[2].when_low().pt().and_factor(a[1].when_high()).and_factor(b[1].when_high()),
                        b[2].when_low().pt().and_factor(a[1].when_high()).and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                        b[2].when_low().pt().and_factor(b[1].when_high()).and_factor(a[0].when_high()).and_factor(b[0].when_high()),
                        b[2].when_high().pt().and_factor(a[1].when_low()).and_factor(b[1].when_low()),
                        b[2].when_high().pt().and_factor(a[1].when_low()).and_factor(a[0].when_low()),
                        b[2].when_high().pt().and_factor(a[1].when_low()).and_factor(b[0].when_low()),
                        b[2].when_high().pt().and_factor(b[1].when_low()).and_factor(a[0].when_low()),
                        b[2].when_high().pt().and_factor(b[1].when_low()).and_factor(b[0].when_low()),
                    },
                    .pt0 = a[2].when_high().pt(),
                    .polarity = .positive,
                },
            };

            if (options.co) |co| {
                chip.mc(co.mc()).logic = comptime .{ .sum = .{
                    .sum = &.{
                        a[2].when_high().pt().and_factor(b[2].when_high()),
                        a[1].when_high().pt().and_factor(b[1].when_high()).and_factor(a[2].when_high()),
                        a[1].when_high().pt().and_factor(b[1].when_high()).and_factor(b[2].when_high()),
                        a[0].when_high().pt().and_factor(b[0].when_high()).and_factor(a[1].when_high()).and_factor(a[2].when_high()),
                        a[0].when_high().pt().and_factor(b[0].when_high()).and_factor(a[1].when_high()).and_factor(b[2].when_high()),
                        a[0].when_high().pt().and_factor(b[0].when_high()).and_factor(b[1].when_high()).and_factor(a[2].when_high()),
                        a[0].when_high().pt().and_factor(b[0].when_high()).and_factor(b[1].when_high()).and_factor(b[2].when_high()),
                    },
                    .polarity = .positive,
                }};
            }
        }
    };
}
