local insert = table.insert
local find = string.find

---@param exp string
return function(exp)
    -- Temprorarily making it simple as first, before going to something more complex
    local output = {}
    local output_stack = ''
    local is_output_stack_a_number = false
    local expStack = STRING.atomize(exp:gsub('%s', ''))

    for _, v in next, expStack do
        if find(v, '[0-9.]') then
            output_stack = output_stack .. v
            is_output_stack_a_number = true
        elseif find(v, '[a-z]') then
            if is_output_stack_a_number then
                insert(output, '**') -- Hidden multiplying
                insert(output, output_stack)
                output_stack = ''
                is_output_stack_a_number = false
            end
            output_stack = output_stack .. v
        else
            if output_stack ~= '' then
                insert(output, output_stack)
                output_stack = ''
            end
            insert(output, v)
        end
    end

    if output_stack ~= '' then insert(output, output_stack) end
    return output
end