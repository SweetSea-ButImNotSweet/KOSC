local insert, remove = table.insert, table.remove

local OPERATOR_PRIORITY = { -- This can be used as OPERATOR_LIST
    ['*'] = 2,
    ['/'] = 2,
    ['+'] = 1,
    ['-'] = 1,
}
local NUMERAL_CHARS = { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' }

---@param exp string
local function Tokenizer(exp)
    local output = {}
    local output_stack = ''
    -- Temprorarily making it simple as first, before going to something more complex
    local expStack = STRING.atomize(exp)

    for _, v in next, expStack do
        if TABLE.find(NUMERAL_CHARS, v) then
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

local function PRNgenerator(tokenList)
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

---@return number|nil
function GoCalculate(exp)
    if exp == '' then return end
    PRNgenerator(Tokenizer(exp))
    return 0
end
