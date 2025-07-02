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
        if calcFunctions[v] and #output >= 2 then
            local b, a = remove(output), remove(output) -- To get 2 values we need to pop 2 times
            insert(output, calcFunctions[v](a, b))
        elseif tonumber(v) --[[number]] then
            insert(output, v)
        else --[[operator/function]]
            error('WTF why are you trying to use operator/function ' .. v ..
            ' which is not existed???')
        end
    end

    assert(#output == 1, "uh something is not right with RPN list?")
    return output[1]
end
