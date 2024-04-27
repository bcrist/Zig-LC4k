function load_goe_fuses (device_name)
    local path = fs.compose_path(re4k, device_name:sub(1,6), device_name, 'goes.sx')
    local results = {}
    local parser = sx.parser(get_file_contents(path))

    parser:require_expression(device_name)

    local root_visitor = {}
    local goe_polarity_visitor = {}
    local goe_source_visitor = {}

    function root_visitor.goe_polarity ()
        repeat until nil == parser:property(goe_polarity_visitor)
        parser:require_close()
    end
    function root_visitor.goe_source ()
        repeat until nil == parser:property(goe_source_visitor)
        parser:require_close()
    end

    function goe_polarity_visitor.goe0 ()
        parser:require_expression('fuse')
        local row = parser:require_int()
        local col = parser:require_int()
        parser:require_close();
        parser:require_close();
        results.goe0_polarity = { row, col }
    end
    function goe_polarity_visitor.goe1 ()
        parser:require_expression('fuse')
        local row = parser:require_int()
        local col = parser:require_int()
        parser:require_close();
        parser:require_close();
        results.goe1_polarity = { row, col }
    end
    function goe_polarity_visitor.goe2 ()
        parser:require_expression('fuse')
        local row = parser:require_int()
        local col = parser:require_int()
        parser:require_close();
        parser:require_close();
        results.goe2_polarity = { row, col }
    end
    function goe_polarity_visitor.goe3 ()
        parser:require_expression('fuse')
        local row = parser:require_int()
        local col = parser:require_int()
        parser:require_close();
        parser:require_close();
        results.goe3_polarity = { row, col }
    end

    function goe_source_visitor.goe0 ()
        parser:require_expression('fuse')
        local row = parser:require_int()
        local col = parser:require_int()
        parser:require_close();
        parser:require_close();
        results.goe0_source = { row, col }
    end
    function goe_source_visitor.goe1 ()
        parser:require_expression('fuse')
        local row = parser:require_int()
        local col = parser:require_int()
        parser:require_close();
        parser:require_close();
        results.goe1_source = { row, col }
    end
    function goe_source_visitor.goe2 ()
        parser:require_expression('fuse')
        local row = parser:require_int()
        local col = parser:require_int()
        parser:require_close();
        parser:require_close();
        results.goe2_source = { row, col }
    end
    function goe_source_visitor.goe3 ()
        parser:require_expression('fuse')
        local row = parser:require_int()
        local col = parser:require_int()
        parser:require_close();
        parser:require_close();
        results.goe3_source = { row, col }
    end

    local function ignore ()
        parser:ignore_remaining_expression()
    end
    goe_polarity_visitor.value = ignore
    goe_source_visitor.value = ignore
    root_visitor.shared_pt_oe_bus = ignore

    repeat until nil == parser:property(root_visitor)

    parser:require_close();
    parser:require_done();

    return results
end
