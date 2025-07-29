function load_gi_options (device_name, pins)
    local path = fs.compose_path(re4k, device_name:sub(1,6), device_name, 'grp.sx')
    local gi_to_signal = {}
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
        local fuse_to_signal = {}
        gi_to_signal[gi] = fuse_to_signal
        repeat until nil == parser:property(gi_visitor, fuse_to_signal)
        parser:require_close()
    end

    function gi_visitor.fuse (_, _, fuse_to_signal)
        local row = parser:require_int()
        local col = parser:require_int()
        local signal_name
        if parser:expression('pin') then
            signal_name = pins[parser:require_string()].signal_name
            parser:ignore_remaining_expression()
        elseif parser:expression('glb') then
            local glb = parser:require_int()
            parser:ignore_remaining_expression()
            parser:require_expression('mc')
            local mc = parser:require_int()
            parser:ignore_remaining_expression()
            signal_name = 'mc_'..string.char(glb + 65)..mc
        else
            parser:print_parse_error_context()
            error('Expected (pin ?) or (glb ?) (mc ?)')
        end
        parser:ignore_remaining_expression()

        fuse_to_signal[row..'_'..col] = signal_name
    end

    repeat until nil == parser:property(root_visitor)

    parser:require_close()
    parser:ignore_remaining_expression() -- other GLBs
    parser:require_close()
    parser:require_done()

    return gi_to_signal
end
