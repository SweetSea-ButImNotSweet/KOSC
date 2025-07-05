local insert, remove = table.insert, table.remove

--- RPN (or Reverse Polish notation) is a mathematical notation in which operators
--- follow their operands, in contrast to prefix or Polish notation (PN), in which
--- operators precede their operands. The notation does not need any parentheses
--- for as long as each operator has a fixed number of operands.
--- (https://en.wikipedia.org/wiki/Reverse_Polish_notation)
---
--- This RPN generator is based on Shunting Yard algorithm but there are some
--- changes, mostly to adapt some features that original RPN doesn't have
--- (https://en.wikipedia.org/wiki/Shunting_yard_algorithm)
---
--- RPN format here should be the same with original RPN. But there are some factors
--- you should know:
--- 1. All numbers and functions are in string format before being actually processed
--- 2. There is a item in `number` type, it is function's argument amount, this is
--- only meant for tracking how many arguments we need to pop out from the stack

return function(tokenList)
    -- Based on: https://en.wikipedia.org/wiki/Shunting_yard_algorithm

    local output = {}
    local op_stack = {}

    -- Only count argument when there is a function at the end of the stack<br>
    -- If this equals to 0 = no function!
    local argumentCount_onlyForFunction = 0

    for _, v in pairs(tokenList) do
        if v == '(' then
            if (
                    argumentCount_onlyForFunction == 0 and
                    #op_stack > 0 and
                    MATH_PROPERTY[op_stack[#op_stack]].type == 'function'
                ) then
                argumentCount_onlyForFunction = 1
            end
            insert(op_stack, v)
        elseif v == ')' then
            assert(#op_stack > 0, "WTH there is no opening bracket?")
            while #op_stack > 0 do
                local popped = remove(op_stack)
                if popped == '(' then
                    -- Just make sure that we also insert the argument amount so
                    -- we can pop out from the stack right number of items
                    if argumentCount_onlyForFunction >= 1 then
                        insert(op_stack, argumentCount_onlyForFunction)
                    end
                    argumentCount_onlyForFunction = 0
                    break
                else
                    insert(output, popped)
                end
            end
        elseif v == ',' then
            assert(argumentCount_onlyForFunction >= 1, "SYNTAX ERROR: redudant ','")
            argumentCount_onlyForFunction = argumentCount_onlyForFunction + 1
        elseif MATH_PROPERTY[v].type == 'operator' --[[operators]] then
            local current_operator_priority = MATH_PROPERTY[v].priority
            if #op_stack > 0 then
                while (
                        #op_stack > 0 and
                        MATH_PROPERTY[op_stack[#op_stack]].priority and
                        MATH_PROPERTY[op_stack[#op_stack]].priority >= current_operator_priority
                    ) do
                    insert(output, remove(op_stack))
                end
            end
            insert(op_stack, v)
        elseif MATH_PROPERTY[v].type == 'function' then
            insert(op_stack, v)
        elseif tonumber(v) then          -- number
            insert(output, v)
        else                             -- wtf?!
            error("Looks like I forget the operator " .. v .. " or did you mistype something?")
        end
    end

    -- we always have operators leftovers so we need to append at the end of the list
    -- P/S: Lua does not have last in first out stack so we have to reverse to get that effect.
    TABLE.append(output, TABLE.reverse(op_stack))
    return output
end
