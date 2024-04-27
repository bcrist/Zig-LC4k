function load_osctimer_fuses (device_name)
    local path = fs.compose_path(re4k, device_name:sub(1,6), device_name, 'osctimer.sx')
    local parser = sx.parser(get_file_contents(path))

    local results = {
        enables = {}
    }

    parser:require_expression(device_name)
    parser:require_expression('osctimer')

    local root_visitor = {}
    function root_visitor.enable ()
        parser:require_expression('fuse')
        local row = parser:require_int()
        local col = parser:require_int()
        parser:require_close()
        parser:ignore_remaining_expression()
        results.enables[#results.enables + 1] = { row, col }
    end
    function root_visitor.timer_out ()
        parser:require_expression('fuse')
        local row = parser:require_int()
        local col = parser:require_int()
        parser:require_close()
        parser:ignore_remaining_expression()
        results.timer_out = { row, col }
    end
    function root_visitor.osc_out ()
        parser:require_expression('fuse')
        local row = parser:require_int()
        local col = parser:require_int()
        parser:require_close()
        parser:ignore_remaining_expression()
        results.osc_out = { row, col }
    end
    function root_visitor.timer_div ()
        parser:require_expression('fuse')
        local row1 = parser:require_int()
        local col1 = parser:require_int()
        parser:require_expression('value')
        parser:require_string('1')
        parser:require_close() -- value
        parser:require_close()
        parser:require_expression('fuse')
        local row2 = parser:require_int()
        local col2 = parser:require_int()
        parser:require_expression('value')
        parser:require_string('2')
        parser:require_close() -- value
        parser:require_close()
        parser:ignore_remaining_expression()
        results.timer_div = { { row1, col1 }, { row2, col2 } }
    end

    repeat until nil == parser:property(root_visitor)

    parser:require_close()
    parser:require_close();
    parser:require_done();

    return results
end
