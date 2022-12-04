function load_bus_maintenance_fuses (device_name)
    local path = fs.compose_path('..', '..', '..', device_name:sub(1,6), device_name, 'pull.sx')
    local id_to_fuse1 = {}
    local id_to_fuse2 = {}
    local parser = sx.parser(get_file_contents(path))

    parser:require_expression(device_name)
    parser:require_expression('bus_maintenance')

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
        if parser:expression('value') then
            if parser:string('2') then
                id_to_fuse2[pin_id] = { row, col }
            else
                parser:require_string('1')
                id_to_fuse1[pin_id] = { row, col }
            end
            parser:require_close()
        else
            id_to_fuse1[pin_id] = { row, col }
        end
        parser:require_close();
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

    return id_to_fuse1, id_to_fuse2
end
