local insert = table.insert
local find = string.find

---@param exp string
---@return string[]
---This is a simpler version of [tokenizer](calc/data/tokenizer.lua)
---used in tokenize the expression before evaluating. It is only meant
---to use in processing the editing input (such as delete)
return function(exp)
    local output = {}
    local output_stack = ''
    local output_stack_type = nil -- 'function' | 'number'

    -- Loại bỏ khoảng trắng và tách từng ký tự
    local expStack = exp:gsub('%s', ''):atomize()

    for _, v in next, expStack do
        if find(v, '[0-9.]') then
            output_stack = output_stack .. v
            output_stack_type = 'number'
        elseif find(v, '[a-z]') then
            if output_stack_type == 'number' then
                insert(output, output_stack)
                output_stack = ''
            end
            output_stack = output_stack .. v
            output_stack_type = 'function'
        else
            if output_stack ~= '' then
                insert(output, output_stack)
                output_stack = ''
            end
            insert(output, v)
            output_stack_type = nil
        end
    end

    if output_stack ~= '' then
        insert(output, output_stack)
    end

    return output
end
