local tokenizer = require "calc.tokenizer"
local PRNgenerator = require "calc.RPNgenerator"
local calcFunctions = require "calc.functions"
local insert, remove = table.insert, table.remove

local OPERATOR_ARGUMENT_REQUIREMENT = {
    ['+'] = 2,
    ['-'] = 2,
    ['*'] = 2,
    ['/'] = 2,
    ['^'] = 2,
    ['E'] = 2
}
local FUNCTION_ARGUMENT_MINIMAL_REQUIREMENT = {
    ['sin'] = 1,
    ['max'] = 2,
}
local FUNCTION_ARGUMENT_MAXIMUM_REQUIREMENT = {
    ['sin'] = 1,
    ['max'] = 1e99,
}

---@return number|nil
function GoCalculate(exp)
    if exp == '' then return end

    local output = {}
    local RPNlist = PRNgenerator(tokenizer(exp))

    for _, v in pairs(RPNlist) do
        if calcFunctions[v] then
            local argumentList = {}
            if (OPERATOR_ARGUMENT_REQUIREMENT[v] and #output >= OPERATOR_ARGUMENT_REQUIREMENT[v]) then
                for _ = 1, OPERATOR_ARGUMENT_REQUIREMENT[v], 1 do
                    insert(argumentList, tonumber(remove(output)))
                end
            elseif FUNCTION_ARGUMENT_MAXIMUM_REQUIREMENT[v] then
                local argumentAmount = remove(output)
                assert(type(argumentAmount) == 'number', 'PARSER ERROR! Missing argument number for `'..v..'` function.')
                if (
                        argumentAmount >= FUNCTION_ARGUMENT_MINIMAL_REQUIREMENT[v] and
                        argumentAmount <= FUNCTION_ARGUMENT_MAXIMUM_REQUIREMENT[v]
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
        else --[[operator/function]]
            error('SYNTAX ERROR! ' .. v ..' is not a right thing for us!')
        end
    end

    assert(#output == 1, "uh something is not right with RPN list?")
    return output[1]
end
