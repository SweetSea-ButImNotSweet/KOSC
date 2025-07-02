local insert = table.insert

local NUMERAL_CHARS = { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}

---@param exp string
return function(exp)
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