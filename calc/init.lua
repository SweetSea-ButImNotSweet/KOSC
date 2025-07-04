local tokenizer = require "calc.tokenizer"
local PRNgenerator = require "calc.RPNgenerator"
local calcFunctions = require "calc.functions"
local insert, remove = table.insert, table.remove

---@return number|nil
function GoCalculate(exp)
    if exp == '' then return end

    local output = {}
    local RPNlist = PRNgenerator(tokenizer(exp))

    for _, v in pairs(RPNlist) do
        if calcFunctions[v] --[[operator/function]] then
            local argumentList = {}
            local currentMathObj = MATH_PROPERTY[v]
            if (currentMathObj.type == 'operator' and #output >= currentMathObj.args) then
                for _ = 1, currentMathObj.args, 1 do
                    insert(argumentList, tonumber(remove(output)))
                end
            elseif currentMathObj.type == 'function' then
                local argumentAmount = remove(output)
                assert(type(argumentAmount) == 'number', 'PARSER ERROR! Missing argument number for `'..v..'` function.')
                if (
                        argumentAmount >= currentMathObj.min_args and
                        argumentAmount <= currentMathObj.max_args
                    ) then
                    for _ = 1, argumentAmount, 1 do
                        insert(argumentList, tonumber(remove(output)))
                    end
                else
                    error("SYNTAX ERROR! Wrong number of arguments!")
                end
            else
                error("SYNTAX ERROR! Not enough arguments!")
            end
            -- Need to reverse all arguments because they are in reversed order
            -- Btw this code will never reach if there is something wrong
            insert(output, calcFunctions[v](unpack(TABLE.reverse(argumentList))))
        elseif tonumber(v) --[[number / argument amount (not affected)]] then
            insert(output, v)
        else
            error('SYNTAX ERROR! ' .. v ..' is not a right thing for us!')
        end
    end

    assert(#output == 1, "uh something is not right with RPN list?")
    return output[1]
end
