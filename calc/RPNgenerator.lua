local insert, remove = table.insert, table.remove

local OPERATOR_PRIORITY = { -- This can be used as OPERATOR_LIST
    ['*'] = 2,
    ['/'] = 2,
    ['+'] = 1,
    ['-'] = 1,
}

return function(tokenList)
    -- Based on: https://en.wikipedia.org/wiki/Shunting_yard_algorithm
    -- op here short for operator

    local output = {}
    local op_stack = {}

    for _, op in pairs(tokenList) do
        if OPERATOR_PRIORITY[op] then
            if #op_stack > 0 then
                while (
                        -- op_stack[#op_stack] ~= '(' and --[[TODO]]
                        #op_stack > 0 and
                        OPERATOR_PRIORITY[op_stack[#op_stack]] >= OPERATOR_PRIORITY[op]
                    ) do
                    insert(output, remove(op_stack))
                end
            end
            insert(op_stack, op)
        else -- number
            insert(output, op)
        end
    end

    -- we always have operators leftovers so we need to append at the end of the list
    TABLE.append(output, op_stack)
    return output
end