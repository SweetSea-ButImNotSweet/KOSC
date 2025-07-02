local tokenizer = require "calc.tokenizer"
local PRNgenerator = require "calc.RPNgenerator"
local insert, remove = table.insert, table.remove

---@return number|nil
function GoCalculate(exp)
    if exp == '' then return end

    local RPNlist = PRNgenerator(tokenizer(exp))
    return 0
end
