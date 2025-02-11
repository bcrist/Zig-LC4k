devices = {}

local function device (name)
    local base_device = name:sub(1, 6)

    local family
    if name:sub(7,7) == 'Z' then
        if name:sub(8,8) == 'C' then
            family = 'zero_power'
        else
            family = 'zero_power_enhanced'
        end
    else
        family = 'low_power'
    end

    local package = name:match('_(.*)')
    local num_glbs = math.tointeger(name:sub(4,6) / 16)
    local num_pins = math.tointeger(package:match('[A-Za-z]*([0-9]*)'))

    local jedec_height = 100
    local gi_mux_size = 0
    local oe_bus_size = 4
    if num_glbs == 2 then
        gi_mux_size = 6
        oe_bus_size = 2
    elseif num_glbs == 4 then
        if family == 'low_power' and (package == 'TQFP44' or package == 'TQFP48') then
            gi_mux_size = 10
            jedec_height = 95
        else
            gi_mux_size = 12
        end
    elseif num_glbs == 8 then
        gi_mux_size = 19
    end

    local jedec_width = math.tointeger((gi_mux_size + 166) * (num_glbs / 2))

    local name_buf_len = num_glbs * 4096 + num_pins * 128;

    devices[name] = {
        device = name,
        base = base_device,
        family = family,
        package = package,
        num_pins = num_pins,
        num_glbs = num_glbs,
        gi_mux_size = gi_mux_size,
        oe_bus_size = oe_bus_size,
        jedec_width = jedec_width,
        jedec_height = jedec_height,
        name_buf_len = name_buf_len,
    }
end

device 'LC4032x_TQFP44'
device 'LC4032x_TQFP48'
device 'LC4032ZC_TQFP48'
device 'LC4032ZC_csBGA56'
device 'LC4032ZE_TQFP48'
device 'LC4032ZE_csBGA64'
device 'LC4064x_TQFP44'
device 'LC4064x_TQFP48'
device 'LC4064x_TQFP100'
device 'LC4064ZC_TQFP48'
device 'LC4064ZC_csBGA56'
device 'LC4064ZC_TQFP100'
device 'LC4064ZC_csBGA132'
device 'LC4064ZE_TQFP48'
device 'LC4064ZE_csBGA64'
device 'LC4064ZE_ucBGA64'
device 'LC4064ZE_TQFP100'
device 'LC4064ZE_csBGA144'
device 'LC4128x_TQFP100'
device 'LC4128x_TQFP128'
device 'LC4128V_TQFP144'
device 'LC4128ZC_TQFP100'
device 'LC4128ZC_csBGA132'
device 'LC4128ZE_TQFP100'
device 'LC4128ZE_TQFP144'
device 'LC4128ZE_ucBGA132'
device 'LC4128ZE_csBGA144'

grp_map = {
    LC4032x_TQFP44    = "LC4032x_TQFP48",
    LC4032ZC_TQFP48   = "LC4032x_TQFP48",
    LC4032ZC_csBGA56  = "LC4032x_TQFP48",
    LC4032ZE_TQFP48   = "LC4032x_TQFP48",
    LC4032ZE_csBGA64  = "LC4032x_TQFP48",
    LC4064x_TQFP44    = "LC4064x_TQFP48",
    LC4064ZC_TQFP48   = "LC4064x_TQFP100",
    LC4064ZC_csBGA56  = "LC4064x_TQFP100",
    LC4064ZC_TQFP100  = "LC4064x_TQFP100",
    LC4064ZC_csBGA132 = "LC4064x_TQFP100",
    LC4064ZE_TQFP48   = "LC4064x_TQFP100",
    LC4064ZE_csBGA64  = "LC4064x_TQFP100",
    LC4064ZE_ucBGA64  = "LC4064x_TQFP100",
    LC4064ZE_TQFP100  = "LC4064x_TQFP100",
    LC4064ZE_csBGA144 = "LC4064x_TQFP100",
    LC4128x_TQFP100   = "LC4128V_TQFP144",
    LC4128x_TQFP128   = "LC4128V_TQFP144",
    LC4128ZC_TQFP100  = "LC4128V_TQFP144",
    LC4128ZC_csBGA132 = "LC4128V_TQFP144",
    LC4128ZE_TQFP100  = "LC4128V_TQFP144",
    LC4128ZE_TQFP144  = "LC4128V_TQFP144",
    LC4128ZE_ucBGA132 = "LC4128V_TQFP144",
    LC4128ZE_csBGA144 = "LC4128V_TQFP144",
}

local which = ...
if not which then return end
if not devices[which] then error "unsupported device" end
local info = devices[which]
local grp_device = grp_map[which]
include 'pins'
include 'threshold'
include 'goes'
include 'zerohold'

info.pins, info.pins_by_type = load_pins(which)
local pin_to_threshold_fuse = load_input_threshold_fuses(which)
local goes = load_goe_fuses(which)
local zerohold = load_zerohold_fuse(which)

compute_grp_names(info.pins_by_type, pin_to_threshold_fuse)

info.grp_pins = info.pins;
info.grp_pins_by_type = info.pins_by_type;

if grp_device then
    info.grp_pins, info.grp_pins_by_type = load_pins(grp_device)
    local grp_pin_to_threshold_fuse, grp_threshold_fuse_to_pin = load_input_threshold_fuses(grp_device)
    compute_grp_names(info.grp_pins_by_type, grp_pin_to_threshold_fuse)

    for _, pin in pairs(info.pins_by_type.input) do
        local threshold_fuse = pin_to_threshold_fuse[pin.id]
        local grp_pin_id = grp_threshold_fuse_to_pin[threshold_fuse[1]..'_'..threshold_fuse[2]]
        pin.grp_name = info.grp_pins[grp_pin_id].grp_name
    end
end

local dedicated_inputs = {}
for _, pin in pairs(info.pins_by_type.clock) do
    dedicated_inputs[pin.grp_name] = pin
end
for _, pin in pairs(info.pins_by_type.input) do
    dedicated_inputs[pin.grp_name] = pin
end

template([[
const std = @import("std");
const lc4k = @import("../lc4k.zig");
const Fuse_Range = @import("../Fuse_Range.zig");
const Fuse = @import("../Fuse.zig");
const naming = @import("../naming.zig");

pub const device_type = lc4k.Device_Type.`device`;

pub const family = lc4k.Device_Family.`family`;
pub const package = lc4k.Device_Package.`package`;

pub const num_glbs = `num_glbs`;
pub const num_mcs = `num_glbs * 16`;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = `gi_mux_size`;
pub const oe_bus_size = `oe_bus_size`;

pub const jedec_dimensions = Fuse_Range.init_from_dimensions(`jedec_width`, `jedec_height`);

pub const Logic_Parser = @import("../logic_parser.zig").Logic_Parser(@This());
pub const F = lc4k.Factor(Signal);
pub const PT = lc4k.Product_Term(Signal);
pub const Pin = lc4k.Pin(Signal);
pub const Names = naming.Names(@This());

var name_buf: [`name_buf_len`]u8 = undefined;
var default_names: ?Names = null;

pub fn get_names() *const Names {
    if (default_names) |*names| return names;
    var fba = std.heap.FixedBufferAllocator.init(&name_buf);
    default_names = Names.init_defaults(fba.allocator(), pins);
    return &default_names.?;
}

]])(info)

if info.family == 'zero_power_enhanced' then
    template([[
pub const osctimer = struct {
    pub const osc_out = Signal.mc_`  ({[2]='A', [4]='A', [8]='A', [16]='C'})[num_glbs]`15;
    pub const osc_disable = osc_out;
    pub const timer_out = Signal.mc_`({[2]='B', [4]='D', [8]='G', [16]='F'})[num_glbs]`15;
    pub const timer_reset = timer_out;
};
]])(info)
end

local grp_names = {}
for _, pin in pairs(info.grp_pins) do
    if pin.grp_name and pin.grp_name ~= '' then
        grp_names[pin.grp_name] = pin
    end
end
for glb = 1, info.num_glbs do
    for mc = 0, 15 do
        grp_names['mc_'..string.char(64 + glb)..mc] = {
            glb = glb,
            mc = mc,
        }
    end
end
write(nl, [[pub const Signal = enum (u16) {]], indent)
do
    local counter = 0
    for grp_name in spairs(grp_names, natural_cmp) do
        write(nl, grp_name, ' = ', counter, ',')
        counter = counter + 1
    end
end
write [[


    pub inline fn kind(self: Signal) lc4k.Signal_Kind {
        return switch (@intFromEnum(self)) {]]
do
    indent(2)
    local last_kind = nil
    local first_grp_name = nil
    local last_grp_name = nil
    for grp_name in spairs(grp_names, natural_cmp) do
        local kind = grp_name:sub(1,2)
        if kind == 'cl' then kind = 'clk' end
        if kind ~= last_kind then
            if last_kind ~= nil then
                write(nl, '@intFromEnum(Signal.', first_grp_name, ')...@intFromEnum(Signal.', last_grp_name, ') => .', last_kind, ',')
            end

            last_kind = kind
            first_grp_name = grp_name
            last_grp_name = grp_name
        else
            last_grp_name = grp_name
        end
    end
    if last_kind ~= nil then
        write(nl, '@intFromEnum(Signal.', first_grp_name, ')...@intFromEnum(Signal.', last_grp_name, ') => .', last_kind, ',')
    end
    unindent(2)
end
write [[

            else => unreachable,
        };
    }

    pub inline fn maybe_mc(self: Signal) ?lc4k.MC_Ref {
        return switch (@intFromEnum(self)) {]]
indent(2)
for glb = 1, info.num_glbs do
    local glb_prefix = string.char(64 + glb)

    local max_mc = 16
    local max_mc_name
    repeat
        max_mc = max_mc - 1
        max_mc_name = 'io_'..glb_prefix..max_mc
    until grp_names[max_mc_name]

    local all_mcs_have_ios = true
    for mc = 0, max_mc do
        if grp_names['io_'..glb_prefix..mc] == nil then
            all_mcs_have_ios = false
            break
        end
    end

    if all_mcs_have_ios then
        write(nl, '@intFromEnum(Signal.io_', glb_prefix, '0)...@intFromEnum(Signal.io_', glb_prefix, max_mc, ') => .{ .glb = ', glb - 1, ', .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.io_', glb_prefix, '0)) },')
    else
        for mc = 0, max_mc do
            if grp_names['io_'..glb_prefix..mc] then
                write(nl, '@intFromEnum(Signal.io_', glb_prefix, mc, ') => .{ .glb = ', glb - 1, ', .mc = ', mc, ' },')
            end
        end
    end
    write(nl, '@intFromEnum(Signal.mc_', glb_prefix, '0)...@intFromEnum(Signal.mc_', glb_prefix, '15) => .{ .glb = ', glb - 1, ', .mc = @intCast(@intFromEnum(self) - @intFromEnum(Signal.mc_', glb_prefix, '0)) },')
end
unindent(2)
write [[

            else => null,
        };
    }
    pub inline fn mc(self: Signal) lc4k.MC_Ref {
        return self.maybe_mc() orelse unreachable;
    }

    pub inline fn maybe_pin(self: Signal) ?Pin {
        return switch (self) {]]
do
    indent(2)
    local my_grp_names = {}
    for _, pin in pairs(info.pins) do
        if pin.grp_name and pin.grp_name ~= '' then
            my_grp_names[pin.grp_name] = pin
        end
    end
    for grp_name, pin in spairs(my_grp_names, natural_cmp) do
        if pin.safe_id then
            write(nl, '.', grp_name, ' => pins.', pin.safe_id, ',')
        end
    end

    unindent(2)
end
unindent()
write [[

            else => null,
        };
    }
    pub inline fn pin(self: Signal) Pin {
        return self.maybe_pin() orelse unreachable;
    }

    pub inline fn when_high(self: Signal) F {
        return .{ .when_high = self };
    }

    pub inline fn when_low(self: Signal) F {
        return .{ .when_low = self };
    }

    pub inline fn maybe_fb(self: Signal) ?Signal {
        const mcref = self.maybe_mc() orelse return null;
        return mc_fb(mcref);
    }

    pub inline fn fb(self: Signal) Signal {
        return mc_fb(self.mc());
    }

    pub inline fn maybe_pad(self: Signal) ?Signal {
        const mcref = self.maybe_mc() orelse return null;
        return mc_pad(mcref);
    }

    pub inline fn pad(self: Signal) Signal {
        return mc_pad(self.mc());
    }

    pub inline fn mc_fb(mcref: lc4k.MC_Ref) Signal {
        return mc_feedback_signals[mcref.glb][mcref.mc];
    }

    pub inline fn maybe_mc_pad(mcref: lc4k.MC_Ref) ?Signal {
        return mc_io_signals[mcref.glb][mcref.mc];
    }

    pub inline fn mc_pad(mcref: lc4k.MC_Ref) Signal {
        return mc_io_signals[mcref.glb][mcref.mc].?;
    }
};
]]
-- write [[
-- pub const IO_Signal = enum (u16) {]]
-- indent()
-- do
--     local counter = 0
--     for grp_name, pin in spairs(grp_names, natural_cmp) do
--         if pin.func == 'io' or pin.func == 'io_oe0' or pin.func == 'io_oe1' then
--             write(nl, grp_name, ' = ', counter, ',')
--             counter = counter + 1
--         end
--     end
-- end
-- unindent()
-- write [[


--     pub fn from_signal(sig: Signal) ?IO_Signal {
--         return switch (sig) {
--             inline else => |s| return if (@hasField(IO_Signal, @tagName(s))) @field(IO_Signal, @tagName(s)) else null,
--         };
--     }

--     pub fn to_signal(self: IO_Signal) Signal {
--         return switch (self) {
--             inline else => |s| return @field(Signal, @tagName(s)),
--         };
--     }

-- };
-- ]]
write [[

pub const mc_feedback_signals = [num_glbs][num_mcs_per_glb]Signal {]]
indent()
for glb = 1, info.num_glbs do
    write(nl, '.{')
    for mc = 0, 15 do
        write(' .mc_', string.char(64 + glb), mc, ',')
    end
    write(' },')
end
write(unindent, nl, [[
};

pub const mc_io_signals = [num_glbs][num_mcs_per_glb]?Signal {]])
    indent()
    for glb = 1, info.num_glbs do
        write(nl, '.{')
        for mc = 0, 15 do
            local name = 'io_'..string.char(64 + glb)..mc
            if grp_names[name] then
                write(' .', name, ',')
            else
                write(' null,')
            end
        end
        write(' },')
    end
    unindent()
    write [[

};

pub const gi_options = [num_gis_per_glb][gi_mux_size]Signal {]]

    indent()
    include 'grp'
    gi_to_grp = load_gi_options(grp_device or which, info.grp_pins)
    for gi = 0,35 do
        local options = gi_to_grp[gi]
        write(nl, '.{')
        for _, grp in spairs(options, natural_cmp) do
            write(' .', grp, ',')
        end
        write ' },'
    end
    unindent()

    write [[

};

pub const gi_options_by_grp = lc4k.invert_gi_mapping(Signal, gi_mux_size, &gi_options);

]]

if grp_device then
    write([[
const base = @import("]], grp_device, [[.zig");
pub const get_glb_range = base.get_glb_range;
pub const get_gi_range = base.get_gi_range;
pub const get_bclock_range = base.get_bclock_range;
]])
else
    
    write [[
pub fn get_glb_range(glb: usize) Fuse_Range {
    std.debug.assert(glb < num_glbs);
    ]]
    if info.gi_mux_size == 19 then
        writeln('var index = num_glbs - glb - 1;', indent)
        writeln('index ^= @as(u1, @truncate(index >> 1));')
        writeln('return jedec_dimensions.sub_columns(83 * index + gi_mux_size * (index / 2 + 1), 83);', unindent)
    else
        local gi_cols = math.tointeger(info.gi_mux_size / 2)
        writeln('const index = num_glbs - glb - 1;', indent)
        writeln('return jedec_dimensions.sub_columns(', 83 + gi_cols, ' * index + ', gi_cols, ', 83);', unindent)
    end
    write [[

}

pub fn get_gi_range(glb: usize, gi: usize) Fuse_Range {
    std.debug.assert(gi < num_gis_per_glb);
    ]]
    if info.gi_mux_size == 19 then
        writeln('var left_glb = glb | 1;', indent);
        writeln('left_glb ^= @as(u1, @truncate(left_glb >> 1)) ^ 1;')
        writeln('const row = gi * 2 + @as(u1, @truncate(glb ^ (glb >> 1)));')
        writeln('return get_glb_range(left_glb).expand_columns(-19).sub_columns(0, 19).sub_rows(row, 1);', unindent)
    else
        local gi_cols = math.tointeger(info.gi_mux_size / 2)
        writeln('return get_glb_range(glb).expand_columns(-',gi_cols,').sub_columns(0, ',gi_cols,').sub_rows(gi * 2, 2);')
    end
    write [[
}

pub fn get_bclock_range(glb: usize) Fuse_Range {
    ]]
    if info.gi_mux_size == 19 then
        writeln('var index = num_glbs - glb - 1;', indent)
        writeln('index = @as(u1, @truncate((index >> 1) ^ index));')
        writeln('return get_glb_range(glb).sub_rows(79, 4).sub_columns(82 * index, 1);', unindent)
    else
        writeln('return get_glb_range(glb).sub_rows(79, 4).sub_columns(0, 1);')
    end
    write [[
}
]]
end
nl()

write [[
pub fn get_goe_polarity_fuse(goe: usize) Fuse {
    return switch (goe) {]]

    indent(2)
    for goe = 0,3 do
        local polarity = goes['goe'..goe..'_polarity']
        if polarity then
            write(nl, goe, ' => Fuse.init(', polarity[1], ', ', polarity[2], '),')
        end
    end
    unindent(2)

    write [[

        else => unreachable,
    };
}

pub fn get_goe_source_fuse(goe: usize) Fuse {
    return switch (goe) {]]

    indent(2)
    for goe = 0,3 do
        local polarity = goes['goe'..goe..'_source']
        if polarity then
            write(nl, goe, ' => Fuse.init(', polarity[1], ', ', polarity[2], '),')
        end
    end
    unindent(2)

    write([[

        else => unreachable,
    };
}

pub fn get_zero_hold_time_fuse() Fuse {
    return Fuse.init(]],zerohold[1],', ',zerohold[2],[[);
}

]])

if info.family == 'zero_power_enhanced' then
    include 'osctimer'
    local osctimer = load_osctimer_fuses(which)

    local min, max
    for _, f in ipairs(osctimer.enables) do
        if min == nil then
            min = { f[1], f[2] }
            max = { f[1], f[2] }
        else
            min[1] = math.min(min[1], f[1])
            min[2] = math.min(min[2], f[2])
            max[1] = math.max(max[1], f[1])
            max[2] = math.max(max[2], f[2])
        end
    end

    write([[
pub fn getOscTimerEnableRange() Fuse_Range {
    return Fuse_Range.between(
        Fuse.init(]],min[1],', ',min[2],[[),
        Fuse.init(]],max[1],', ',max[2],[[),
    );
}

pub fn getOscOutFuse() Fuse {
    return Fuse.init(]],osctimer.osc_out[1],', ',osctimer.osc_out[2],[[);
}

pub fn getTimerOutFuse() Fuse {
    return Fuse.init(]],osctimer.timer_out[1],', ',osctimer.timer_out[2],[[);
}

pub fn getTimerDivRange() Fuse_Range {
    return Fuse.init(]], osctimer.timer_div[1][1], ', ', osctimer.timer_div[1][2], [[)
        .range().expand_to_contain(Fuse.init(]], osctimer.timer_div[2][1], ', ', osctimer.timer_div[2][2], [[));
}

pub fn getInputPower_GuardFuse(input: Signal) Fuse {
    return switch (input) {]])
    include 'power_guard'
    local power_guard_fuses = load_power_guard_fuses(which)
    indent(2)
    for _, pin in spairs(dedicated_inputs, natural_cmp) do
        local fuse = power_guard_fuses[pin.id]
        write(nl, '.', pin.grp_name, ' => Fuse.init(', fuse[1], ', ', fuse[2], '),')
    end
    unindent(2)
    write [[

        else => unreachable,
    };
}

pub fn getInputBus_MaintenanceRange(input: Signal) Fuse_Range {
    return switch (input) {]]
    include 'bus_maintenance'
    local fuse1, fuse2 = load_bus_maintenance_fuses(which)
    indent(2)
    for _, pin in spairs(dedicated_inputs, natural_cmp) do
        write(nl, '.', pin.grp_name, ' => Fuse_Range.between(Fuse.init(', fuse1[pin.id][1], ', ', fuse1[pin.id][2],
                                                         '), Fuse.init(', fuse2[pin.id][1], ', ', fuse2[pin.id][2], ')),')
    end
    unindent(2)
    write [[

        else => unreachable,
    };
}
]]
else
    include 'global_bus_maintenance'
    local f0, f1, extra = load_global_bus_maintenance_fuses(which)
    write([[

pub fn get_global_bus_maintenance_range() Fuse_Range {
    return Fuse.init(]], f0[1], ', ', f0[2], [[).range().expand_to_contain(Fuse.init(]], f1[1], ', ', f1[2], [[));
}
pub fn get_extra_float_input_fuses() []const Fuse {
    return &.{]])
    indent(2)
    for _, f in ipairs(extra) do
        write(nl, 'Fuse.init(', f[1], ', ', f[2], '),')
    end
    unindent(2)
    write [[

    };
}
]]
end
write [[

pub fn get_input_threshold_fuse(input: Signal) Fuse {
    return switch (input) {]]
    indent(2)
    for _, pin in spairs(dedicated_inputs, natural_cmp) do
        local fuse = pin_to_threshold_fuse[pin.id]
        write(nl, '.', pin.grp_name, ' => Fuse.init(', fuse[1], ', ', fuse[2], '),')
    end
    unindent(2)
    write [[

        else => unreachable,
    };
}

pub const pins = struct {]]

local write_pin = template [[

pub const `safe_id` = Pin.init_`init_suffix`("`id`", `...`);]]

indent()
for _, pin in spairs(info.pins, natural_cmp) do
    local t
    if pin.func == 'io' then
        pin.init_suffix = 'io'
        t = { '.', pin.grp_name }
    elseif pin.func == 'io_oe0' or pin.func == 'io_oe1' then
        pin.init_suffix = 'oe'
        t = { '.', pin.grp_name, ', ', pin.func:sub(6) }
    elseif pin.func == 'clock' then
        pin.init_suffix = 'clk'
        t = { '.', pin.grp_name, ', ', pin.clk, ', ', pin.glb }
    elseif pin.func == 'input' then
        pin.init_suffix = 'input'
        t = { '.', pin.grp_name, ', ', pin.glb }
    else
        pin.init_suffix = 'misc'
        t = { '.', pin.func }
    end

    write_pin(pin, table.unpack(t))
end
unindent()

write([[

};

pub const clock_pins = [_]Pin {]])

local function clock_cmp (a, b)
    local pa = info.pins_by_type.clock[a]
    local pb = info.pins_by_type.clock[b]
    return pa.clk < pb.clk
end

indent()
for _, pin in spairs(info.pins_by_type.clock, clock_cmp) do
    write(nl, 'pins.', pin.safe_id, ',')
end
unindent()

write([[

};

pub const oe_pins = [_]Pin {]])

local function oe_cmp (a, b)
    local pa = info.pins[a]
    local pb = info.pins[b]
    return pa.oe < pb.oe
end

indent()
for _, pin in spairs(info.pins_by_type.io_oe0, oe_cmp) do
    write(nl, 'pins.', pin.safe_id, ',')
end
for _, pin in spairs(info.pins_by_type.io_oe1, oe_cmp) do
    write(nl, 'pins.', pin.safe_id, ',')
end
unindent()

write([[

};

pub const input_pins = [_]Pin {]])

local function input_cmp (a, b)
    local pa = info.pins_by_type.input[a]
    local pb = info.pins_by_type.input[b]
    return natural_cmp(pa.grp_name, pb.grp_name)
end

indent()
for _, pin in spairs(info.pins_by_type.input, input_cmp) do
    write(nl, 'pins.', pin.safe_id, ',')
end
unindent()

write([[

};

pub const all_pins = [_]Pin {]])

indent()
for _, pin in spairs(info.pins, natural_cmp) do
    write(nl, 'pins.', pin.safe_id, ',')
end
unindent()

write([[

};
]])
