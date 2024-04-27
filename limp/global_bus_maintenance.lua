function load_global_bus_maintenance_fuses (device_name)
    local path = fs.compose_path(re4k, device_name:sub(1,6), device_name, 'bus_maintenance.sx')
    local parser = sx.parser(get_file_contents(path))

    parser:require_expression(device_name)
    parser:require_expression('bus_maintenance')

    parser:require_expression('fuse')
    local row0 = parser:require_int()
    local col0 = parser:require_int()

    parser:require_expression('value')
    parser:require_string('1')
    parser:require_close()

    parser:require_close() -- fuse

    parser:require_expression('fuse')
    local row1 = parser:require_int()
    local col1 = parser:require_int()

    parser:require_expression('value')
    parser:require_string('2')
    parser:require_close()

    parser:require_close() -- fuse

    while parser:expression('value') do
        parser:ignore_remaining_expression()
    end

    parser:require_close() -- bus_maintenance

    local extra = {}

    if parser:expression('bus_maintenance_extra') then
        while parser:expression('fuse') do
            local row = parser:require_int()
            local col = parser:require_int()
            extra[#extra+1] = { row, col }
            parser:require_close()
        end
        while parser:expression('value') do
            parser:ignore_remaining_expression()
        end
        parser:require_close()
    end

    parser:require_close();
    parser:require_done();

    return { row0, col0 }, { row1, col1 }, extra
end
