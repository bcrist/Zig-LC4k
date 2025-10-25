function load_pins (device_name)
    local path = fs.compose_path(re4k, device_name:sub(1,6), device_name, 'pins.csv')

    local pins = {}
    local pins_by_type = {
        io = {},
        io_oe0 = {},
        io_oe1 = {},
        input = {},
        clock = {},
        no_connect = {},
        gnd = {},
        gndo = {},
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

            if id == nil then
                error("Found invalid line in " .. path .. ": " .. line)
            end

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
                error("Pins with a clock index must have type 'clock'! (found " .. clk .. ")")
            end
            if clk == '' and pin_type == 'clock' then
                error("Pins of type 'clock' must have an index!")
            end

            if bank == '' then
                bank = 'null'
            end

            local pin = {
                id = id,
                safe_id = safe_id,
                signal_name = '',
                func = pin_type,
                bank = bank,
                glb = glb,
                mc = mc,
                oe = oe,
                clk = clk,
            }

            if pins[id] then
                error(device_name .. ": Multiple pins with id " .. id)
            end

            if pins_by_type[pin_type] == nil then
                error(device_name .. ": Invalid pin type: " .. pin_type)
            end

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

            ::continue::
        end
    end

    return pins, pins_by_type
end

function compute_signal_names (pins_by_type, pin_to_threshold_fuse)
    for _, pin in pairs(pins_by_type.io) do
        pin.signal_name = 'io_'..string.char(pin.glb + 65)..pin.mc
    end
    for _, pin in pairs(pins_by_type.io_oe0) do
        pin.signal_name = 'io_'..string.char(pin.glb + 65)..pin.mc
    end
    for _, pin in pairs(pins_by_type.io_oe1) do
        pin.signal_name = 'io_'..string.char(pin.glb + 65)..pin.mc
    end

    for _, pin in pairs(pins_by_type.clock) do
        pin.signal_name = 'clk'..pin.clk
    end

    local threshold_fuse_to_input_pin = {}
    for _, pin in pairs(pins_by_type.input) do
        local fuse = pin_to_threshold_fuse[pin.id]
        if fuse == nil then error(pin.id .. ' not found in threshold fuse list') end
        threshold_fuse_to_input_pin[fuse[1]..'_'..fuse[2]] = pin
    end
    local n = 0
    for _, pin in spairs(threshold_fuse_to_input_pin, natural_cmp) do
        pin.signal_name = 'in'..n
        n = n + 1
    end
end

function compute_pin_remap (lookup_pins, result_pins)
    local map = {}
    for _, lp in pairs(lookup_pins) do
        for _, rp in pairs(result_pins) do
            if (lp.func == rp.func and lp.glb == rp.glb and lp.mc == rp.mc and lp.oe == rp.oe and lp.clk == rp.clk) then
                map[lp.id] = rp.id
            end
        end
    end
    return map
end
