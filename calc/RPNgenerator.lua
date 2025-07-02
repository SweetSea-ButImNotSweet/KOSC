local insert, remove = table.insert, table.remove

local OPERATOR_PRIORITY = { -- This can be used as OPERATOR_LIST
    ['E'] = 4,
    ['^'] = 3,
    ['*'] = 2,
    ['/'] = 2,
    ['+'] = 1,
    ['-'] = 1,
}

return function(tokenList)
    -- Based on: https://en.wikipedia.org/wiki/Shunting_yard_algorithm

    local output = {}
    local op_stack = {}

    for _, v in pairs(tokenList) do
        if v == '(' then
            insert(op_stack, v)
        elseif v == ')' then
            assert(#op_stack > 0, "WTH there is no opening bracket?")
            while (
                #op_stack > 0 and
                output[#output] ~= '('
            ) do
                local popped = remove(op_stack)
                if popped == '(' then
                    break
                else
                    insert(output, popped)
                end
            end
        elseif OPERATOR_PRIORITY[v] --[[operators]] then
            if #op_stack > 0 then
                local last_thing_in_op_stack = op_stack[#op_stack]
                while (
                        #op_stack > 0 and
                        OPERATOR_PRIORITY[last_thing_in_op_stack] and
                        OPERATOR_PRIORITY[last_thing_in_op_stack] >= OPERATOR_PRIORITY[v]
                    ) do
                    insert(output, remove(op_stack))
                end
            end
            insert(op_stack, v)
        elseif tonumber(v) then -- number
            insert(output, v)
        else                    -- wtf?!
            error("Looks like I forget the operator " .. v .. " or did you mistype something?")
        end
    end

    -- we always have operators leftovers so we need to append at the end of the list
    -- P/S: Lua does not have last in first out stack so we have to reverse to get that effect.
    TABLE.append(output, TABLE.reverse(op_stack))
    return output
end
