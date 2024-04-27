function load_gi_options (device_name, pins)
    local path = fs.compose_path(re4k, device_name:sub(1,6), device_name, 'grp.sx')
    local gi_to_grp = {}
    local parser = sx.parser(get_file_contents(path))

    parser:require_expression(device_name)
    parser:require_expression('global_routing_pool')
    parser:require_expression('glb')
    parser:require_int(0)
    if parser:expression('name') then
        parser:ignore_remaining_expression()
    end

    local root_visitor = {}
    local gi_visitor = {}

    function root_visitor.gi ()
        local gi = parser:require_int()
        local fuse_to_grp = {}
        gi_to_grp[gi] = fuse_to_grp
        repeat until nil == parser:property(gi_visitor, fuse_to_grp)
        parser:require_close()
    end

    function gi_visitor.fuse (_, _, fuse_to_grp)
        local row = parser:require_int()
        local col = parser:require_int()
        local grp_name
        if parser:expression('pin') then
            grp_name = pins[parser:require_string()].grp_name
            parser:ignore_remaining_expression()
        elseif parser:expression('glb') then
            local glb = parser:require_int()
            parser:ignore_remaining_expression()
            parser:require_expression('mc')
            local mc = parser:require_int()
            parser:ignore_remaining_expression()
            grp_name = 'mc_'..string.char(glb + 65)..mc
        else
            parser:print_parse_error_context()
            error('Expected (pin ?) or (glb ?) (mc ?)')
        end
        parser:ignore_remaining_expression()

        fuse_to_grp[row..'_'..col] = grp_name
    end

    repeat until nil == parser:property(root_visitor)

    parser:require_close()
    parser:ignore_remaining_expression() -- other GLBs
    parser:require_close()
    parser:require_done()

    return gi_to_grp
end
