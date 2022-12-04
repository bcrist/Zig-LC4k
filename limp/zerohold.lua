function load_zerohold_fuse (device_name)
    local path = fs.compose_path('..', '..', '..', device_name:sub(1,6), device_name, 'zerohold.sx')
    local parser = sx.parser(get_file_contents(path))

    parser:require_expression(device_name)
    parser:require_expression('zero_hold_time')
    parser:require_expression('fuse')
    local row = parser:require_int()
    local col = parser:require_int()
    parser:require_close()
    parser:ignore_remaining_expression()
    parser:require_close();
    parser:require_done();

    return { row, col }
end
