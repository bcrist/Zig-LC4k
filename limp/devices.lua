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

    devices[name] = {
        device = name,
        base = base_device,
        family = family,
        package = package,
        num_glbs = num_glbs,
        gi_mux_size = gi_mux_size,
        oe_bus_size = oe_bus_size,
        jedec_width = jedec_width,
        jedec_height = jedec_height,
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

if grp_device then
    local grp_pins, grp_pins_by_type = load_pins(grp_device)
    local grp_pin_to_threshold_fuse, grp_threshold_fuse_to_pin = load_input_threshold_fuses(grp_device)
    compute_grp_names(grp_pins_by_type, grp_pin_to_threshold_fuse)

    for _, pin in pairs(info.pins_by_type.input) do
        local threshold_fuse = pin_to_threshold_fuse[pin.id]
        local grp_pin_id = grp_threshold_fuse_to_pin[threshold_fuse[1]..'_'..threshold_fuse[2]]
        pin.grp_name = grp_pins[grp_pin_id].grp_name
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
const common = @import("common.zig");
const internal = @import("internal.zig");
const jedec = @import("jedec.zig");

pub const device_type = common.DeviceType.`device`;

pub const family = common.DeviceFamily.`family`;
pub const package = common.DevicePackage.`package`;

pub const num_glbs = `num_glbs`;
pub const num_mcs = `num_glbs * 16`;
pub const num_mcs_per_glb = 16;
pub const num_gis_per_glb = 36;
pub const gi_mux_size = `gi_mux_size`;
pub const oe_bus_size = `oe_bus_size`;

pub const jedec_dimensions = jedec.FuseRange.init(`jedec_width`, `jedec_height`);

]])(info)

if info.family == 'zero_power_enhanced' then
    template([[
pub const osctimer = struct {
    pub const osc_out = GRP.mc_`  ({[2]='A', [4]='A', [8]='A', [16]='C'})[num_glbs]`15;
    pub const osc_disable = osc_out;
    pub const timer_out = GRP.mc_`({[2]='B', [4]='D', [8]='G', [16]='F'})[num_glbs]`15;
    pub const timer_reset = timer_out;
};

]])(info)
end

if grp_device then write([[
const grp_device = @import("]], grp_device, [[.zig");

pub const GRP = grp_device.GRP;
pub const mc_signals = grp_device.mc_signals;
pub const mc_output_signals = grp_device.mc_output_signals;
pub const gi_options = grp_device.gi_options;
pub const gi_options_by_grp = grp_device.gi_options_by_grp;
pub const getGlbRange = grp_device.getGlbRange;
pub const getGiRange = grp_device.getGiRange;
pub const getBClockRange = grp_device.getBClockRange;

]]) else
    local grp_names = {}
    for _, pin in pairs(info.pins) do
        if pin.grp_name and pin.grp_name ~= '' then
            grp_names[pin.grp_name] = true
        end
    end
    for glb = 1, info.num_glbs do
        for mc = 0, 15 do
            grp_names['mc_'..string.char(64 + glb)..mc] = true
        end
    end
    write([[
pub const GRP = enum {]], indent)
    for grp_name in spairs(grp_names, natural_cmp) do
        write(nl, grp_name, ',')
    end
    write(unindent, nl, [[
};

pub const mc_signals = [num_glbs][num_mcs_per_glb]GRP {]])
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

pub const mc_output_signals = [num_glbs][num_mcs_per_glb]?GRP {]])
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
    write(unindent, nl, [[
};

pub const gi_options = [num_gis_per_glb][gi_mux_size]GRP {]])

    indent()
    include 'grp'
    gi_to_grp = load_gi_options(which, info.pins)
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

pub const gi_options_by_grp = internal.invertGIMapping(GRP, gi_mux_size, &gi_options);

pub fn getGlbRange(glb: usize) jedec.FuseRange {
    std.debug.assert(glb < num_glbs);
    ]]
    if info.gi_mux_size == 19 then
        writeln('var index = num_glbs - glb - 1;', indent)
        writeln('index ^= @truncate(u1, index >> 1);')
        writeln('return jedec_dimensions.subColumns(83 * index + gi_mux_size * (index / 2 + 1), 83);', unindent)
    else
        local gi_cols = math.tointeger(info.gi_mux_size / 2)
        writeln('const index = num_glbs - glb - 1;', indent)
        writeln('return jedec_dimensions.subColumns(', 83 + gi_cols, ' * index + ', gi_cols, ', 83);', unindent)
    end
    write [[
}

pub fn getGiRange(glb: usize, gi: usize) jedec.FuseRange {
    std.debug.assert(gi < num_gis_per_glb);
    ]]
    if info.gi_mux_size == 19 then
        writeln('var left_glb = glb | 1;', indent);
        writeln('left_glb ^= @truncate(u1, left_glb >> 1) ^ 1;')
        writeln('const row = gi * 2 + @truncate(u1, glb ^ (glb >> 1));')
        writeln('return getGlbRange(left_glb).expandColumns(-19).subColumns(0, 19).subRows(row, 1);', unindent)
    else
        local gi_cols = math.tointeger(info.gi_mux_size / 2)
        writeln('return getGlbRange(glb).expandColumns(-',gi_cols,').subColumns(0, ',gi_cols,').subRows(gi * 2, 2);')
    end
    write [[
}

pub fn getBClockRange(glb: usize) jedec.FuseRange {
    ]]
    if info.gi_mux_size == 19 then
        writeln('var index = num_glbs - glb - 1;', indent)
        writeln('index = @truncate(u1, (index >> 1) ^ index);')
        writeln('return getGlbRange(glb).subRows(79, 4).subColumns(82 * index, 1);', unindent)
    else
        writeln('return getGlbRange(glb).subRows(79, 4).subColumns(0, 1);')
    end
    write [[
}
]]
end
nl()

write [[
pub fn getGOEPolarityFuse(goe: usize) jedec.Fuse {
    return switch (goe) {]]

    indent(2)
    for goe = 0,3 do
        local polarity = goes['goe'..goe..'_polarity']
        if polarity then
            write(nl, goe, ' => jedec.Fuse.init(', polarity[1], ', ', polarity[2], '),')
        end
    end
    unindent(2)

    write [[

        else => unreachable,
    };
}

pub fn getGOESourceFuse(goe: usize) jedec.Fuse {
    return switch (goe) {]]

    indent(2)
    for goe = 0,3 do
        local polarity = goes['goe'..goe..'_source']
        if polarity then
            write(nl, goe, ' => jedec.Fuse.init(', polarity[1], ', ', polarity[2], '),')
        end
    end
    unindent(2)

    write([[

        else => unreachable,
    };
}

pub fn getZeroHoldTimeFuse() jedec.Fuse {
    return jedec.Fuse.init(]],zerohold[1],', ',zerohold[2],[[);
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
pub fn getOscTimerEnableRange() jedec.FuseRange {
    return jedec.FuseRange.between(
        jedec.Fuse.init(]],min[1],', ',min[2],[[),
        jedec.Fuse.init(]],max[1],', ',max[2],[[),
    );
}

pub fn getOscOutFuse() jedec.Fuse {
    return jedec.Fuse.init(]],osctimer.osc_out[1],', ',osctimer.osc_out[2],[[);
}

pub fn getTimerOutFuse() jedec.Fuse {
    return jedec.Fuse.init(]],osctimer.timer_out[1],', ',osctimer.timer_out[2],[[);
}

pub fn getTimerDivRange() jedec.FuseRange {
    return jedec.FuseRange.fromFuse(
        jedec.Fuse.init(]], osctimer.timer_div[1][1], ', ', osctimer.timer_div[1][2], [[)
    ).expandToContain(
        jedec.Fuse.init(]], osctimer.timer_div[2][1], ', ', osctimer.timer_div[2][2], [[)
    );
}

pub fn getInputPowerGuardFuse(input: GRP) jedec.Fuse {
    return switch (input) {]])
    include 'power_guard'
    local power_guard_fuses = load_power_guard_fuses(which)
    indent(2)
    for _, pin in spairs(dedicated_inputs, natural_cmp) do
        local fuse = power_guard_fuses[pin.id]
        write(nl, '.', pin.grp_name, ' => jedec.Fuse.init(', fuse[1], ', ', fuse[2], '),')
    end
    unindent(2)
    write [[

        else => unreachable,
    };
}

pub fn getInputBusMaintenanceRange(input: GRP) jedec.FuseRange {
    return switch (input) {]]
    include 'bus_maintenance'
    local fuse1, fuse2 = load_bus_maintenance_fuses(which)
    indent(2)
    for _, pin in spairs(dedicated_inputs, natural_cmp) do
        write(nl, '.', pin.grp_name, ' => jedec.FuseRange.between(jedec.Fuse.init(', fuse1[pin.id][1], ', ', fuse1[pin.id][2],
                                                              '), jedec.Fuse.init(', fuse2[pin.id][1], ', ', fuse2[pin.id][2], ')),')
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

pub fn getGlobalBusMaintenanceRange() jedec.FuseRange {
    return jedec.FuseRange.fromFuse(
        jedec.Fuse.init(]], f0[1], ', ', f0[2], [[)
    ).expandToContain(
        jedec.Fuse.init(]], f1[1], ', ', f1[2], [[)
    );
}
pub fn getExtraFloatInputFuses() []jedec.Fuse {
    return &.{]])
    indent(2)
    for _, f in ipairs(extra) do
        write(nl, 'jedec.Fuse.init(', f[1], ', ', f[2], '),')
    end
    unindent(2)
    write [[

    };
}
]]
end
write [[

pub fn getInputThresholdFuse(input: GRP) jedec.Fuse {
    return switch (input) {]]
    indent(2)
    for _, pin in spairs(dedicated_inputs, natural_cmp) do
        local fuse = pin_to_threshold_fuse[pin.id]
        write(nl, '.', pin.grp_name, ' => jedec.Fuse.init(', fuse[1], ', ', fuse[2], '),')
    end
    unindent(2)
    write [[

        else => unreachable,
    };
}

pub fn getMacrocellRef(comptime which: anytype) common.MacrocellRef {
    return internal.getMacrocellRef(GRP, which);
}

pub fn getGlbIndex(comptime which: anytype) common.GlbIndex {
    return internal.getGlbIndex(@This(), which);
}

pub fn getGrp(comptime which: anytype) GRP {
    return internal.getGrp(GRP, which);
}

pub fn getGrpInput(comptime which: anytype) GRP {
    return internal.getGrpInput(GRP, which);
}

pub fn getGrpFeedback(comptime which: anytype) GRP {
    return internal.getGrpFeedback(GRP, which);
}

pub fn getPin(comptime which: anytype) common.PinInfo {
    return internal.getPin(@This(), which);
}

pub const pins = struct {]]

local write_pin = template [[

pub const `safe_id` = common.PinInfo {
    .id = "`id`",
`...`};]]

indent()
for _, pin in spairs(info.pins, natural_cmp) do
    local t = {}

    t[1] = '    .func = .{ .'..pin.func
    if pin.func == 'io' or pin.func == 'io_oe0' or pin.func == 'io_oe1' then
        t[#t+1] = ' = '..pin.mc
    elseif pin.func == 'clock' then
        t[#t+1] = ' = '..pin.clk
    else
        t[#t+1] = ' = {}'
    end

    t[#t+1] = ' },'
    t[#t+1] = nl

    if pin.glb ~= '' then
        t[#t+1] = '    .glb = '..pin.glb..','
        t[#t+1] = nl
    end

    if pin.grp_name ~= '' then
        t[#t+1] = '    .grp_ordinal = @enumToInt(GRP.'..pin.grp_name..'),'
        t[#t+1] = nl
    end

    write_pin(pin, table.unpack(t))
end
unindent()

write([[

};

pub const clock_pins = [_]common.PinInfo {]])

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

pub const oe_pins = [_]common.PinInfo {]])

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

pub const input_pins = [_]common.PinInfo {]])

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

pub const all_pins = [_]common.PinInfo {]])

indent()
for _, pin in spairs(info.pins, natural_cmp) do
    write(nl, 'pins.', pin.safe_id, ',')
end
unindent()

write([[

};
]])
