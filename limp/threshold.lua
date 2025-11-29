function load_input_threshold_fuses (device_name, pin_remap)
    local path = fs.compose_path(re4k, device_name:sub(1,6), device_name, 'threshold.sx')
    local id_to_fuse = {}
    local fuse_to_id = {}
    local parser = sx.parser(get_file_contents(path))

    parser:require_expression(device_name)
    parser:require_expression('input_threshold')

    local root_visitor = {}
    local pin_visitor = {}

    function root_visitor.pin ()
        local id = parser:require_string()
        repeat until nil == parser:property(pin_visitor, id)
        parser:require_close()
    end

    function pin_visitor.fuse (_, _, pin_id)
        local row = parser:require_int()
        local col = parser:require_int()
        parser:require_close();
        local id = pin_id
        if pin_remap then id = pin_remap[id] end
        if id then
            id_to_fuse[id] = { row, col }
            fuse_to_id[row .. '_' .. col] = id
        end
    end

    local function ignore ()
        parser:ignore_remaining_expression()
    end

    pin_visitor.info = ignore
    pin_visitor.glb = ignore
    pin_visitor.mc = ignore
    pin_visitor.clk = ignore
    pin_visitor.oe = ignore
    root_visitor.value = ignore

    repeat until nil == parser:property(root_visitor)

    parser:require_close();
    parser:require_close();
    parser:require_done();

    return id_to_fuse, fuse_to_id
end
