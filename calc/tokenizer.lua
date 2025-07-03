local insert = table.insert
local find = string.find

---@param exp string
return function(exp)
    -- Temprorarily making it simple as first, before going to something more complex
    local output = {}
    local output_stack = ''
    local output_stack_type = nil ---@type 'function'|'number'|nil
    local expStack = STRING.atomize(exp:gsub('%s', ''))

    for _, v in next, expStack do
        if find(v, '[0-9.]') then
            assert(output_stack_type ~= 'function', "SYNTAX ERROR: number can't go after a function")
            output_stack = output_stack .. v
            output_stack_type = 'number'
        elseif find(v, '[a-z]') then
            if output_stack_type == 'number' then
                insert(output, '**') -- Hidden multiplying
                insert(output, output_stack)
                output_stack = ''
                output_stack_type = nil
            end
            output_stack = output_stack .. v
            output_stack_type = 'function'
        else
            if output_stack ~= '' then
                insert(output, output_stack)
                output_stack = ''
                output_stack_type = nil
            end
            insert(output, v)
        end
    end

    if output_stack ~= '' then insert(output, output_stack) end
    return output
end