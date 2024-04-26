function load_pins (device_name)
    local path = fs.compose_path('..', 'pins', device_name .. '.csv')

    local pins = {}
    local pins_by_type = {
        io = {},
        io_oe0 = {},
        io_oe1 = {},
        input = {},
        clock = {},
        no_connect = {},
        gnd = {},
        vcc_core = {},
        vcco = {},
        tck = {},
        tms = {},
        tdi = {},
        tdo = {},
        oe = {},
    }

    local special_dedup = {}
    local id_dedup = {}
    local dedup = function (special_id, id)
        if special_dedup[special_id] == nil then
            special_dedup[special_id] = id
        else
            error(which .. ": Multiple pins for " .. special_id .. " (was " .. special_dedup[special_id] .. " now " .. id .. ")")
        end
    end

    local first = true
    for line in io.lines(path) do
        if first then
            -- Ignore header row
            first = false
        else
            local id, pin_type, bank, glb, mc, oe, clk
            id, pin_type, bank, glb, mc, oe, clk = line:match("^([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*)$")
            local safe_id = id
            if not safe_id:find('^%a') then
                safe_id = '_' .. safe_id
            end
            if pin_type == 'io' then
                if oe == '0' then
                    pin_type = 'io_oe0'
                elseif oe == '1' then
                    pin_type = 'io_oe1'
                end
            end
            if clk ~= '' and pin_type ~= 'clock' then
                error("Pins with a clock index must have type 'clock'!")
            end
            if clk == '' and pin_type == 'clock' then
                error("Pins of type 'clock' must have an index!")
            end

            local pin = {
                id = id,
                safe_id = safe_id,
                grp_name = '',
                func = pin_type,
                bank = bank,
                glb = glb,
                mc = mc,
                oe = oe,
                clk = clk,
            }

            pins[id] = pin
            pins_by_type[pin_type][id] = pin

            if id_dedup[id] == nil then
                id_dedup[id] = true
            else
                error(device .. ": Duplicate pin id: " .. id)
            end

            if oe ~= "" then
                dedup('oe'..oe, id)
                pins_by_type.oe[id] = pin
            end

            if clk ~= "" then
                dedup('clk'..clk, id)
            end

            if pin_type == "io" then
                dedup('glb'..glb..'_mc'..mc, id)
            end
        end
    end

    return pins, pins_by_type
end

function compute_grp_names (pins_by_type, pin_to_threshold_fuse)
    for _, pin in pairs(pins_by_type.io) do
        pin.grp_name = 'io_'..string.char(pin.glb + 65)..pin.mc
    end
    for _, pin in pairs(pins_by_type.io_oe0) do
        pin.grp_name = 'io_'..string.char(pin.glb + 65)..pin.mc
    end
    for _, pin in pairs(pins_by_type.io_oe1) do
        pin.grp_name = 'io_'..string.char(pin.glb + 65)..pin.mc
    end

    for _, pin in pairs(pins_by_type.clock) do
        pin.grp_name = 'clk'..pin.clk
    end

    local threshold_fuse_to_input_pin = {}
    for _, pin in pairs(pins_by_type.input) do
        local fuse = pin_to_threshold_fuse[pin.id]
        if fuse == nil then error(pin.id .. ' not found in threshold fuse list') end
        threshold_fuse_to_input_pin[fuse[1]..'_'..fuse[2]] = pin
    end
    local n = 0
    for _, pin in spairs(threshold_fuse_to_input_pin, natural_cmp) do
        pin.grp_name = 'in'..n
        n = n + 1
    end
end
