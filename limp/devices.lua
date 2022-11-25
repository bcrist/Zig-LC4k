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
    if num_glbs == 2 then
        gi_mux_size = 6
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

info.pins, info.pins_by_type = load_pins(which)
local pin_to_threshold_fuse = load_input_threshold_fuses(which)
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
pub const gi_options = grp_device.gi_options;
pub const gi_options_by_grp = grp_device.gi_options_by_grp;

]]) else
    local grp_names = {}
    for _, pin in pairs(info.pins) do
        if pin.grp_name and pin.grp_name ~= '' then
            grp_names[pin.grp_name] = true
            if pin.grp_name:find('^io_') then
                local feedback = 'mc_' .. pin.grp_name:sub(4)
                grp_names[feedback] = true
            end
        end
    end
    write([[
pub const GRP = enum {]], indent)
    for grp_name in spairs(grp_names, natural_cmp) do
        write(nl, grp_name, ',')
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

    write([[

};

pub const gi_options_by_grp = internal.invertGIMapping(GRP, gi_mux_size, &gi_options);

]])
end
nl()
write 'pub const pins = struct {'

local write_pin = template [[

const `safe_id` = common.PinInfo {
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
