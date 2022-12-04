function load_power_guard_fuses (device_name)
    local path = fs.compose_path('..', '..', '..', device_name:sub(1,6), device_name, 'power_guard.sx')
    local id_to_fuse = {}
    local parser = sx.parser(get_file_contents(path))

    parser:require_expression(device_name)
    parser:require_expression('power_guard')

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
        id_to_fuse[pin_id] = { row, col }
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

    return id_to_fuse
end
