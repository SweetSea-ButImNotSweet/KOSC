local insert = table.insert
local find = string.find

---@param exp string
return function(exp)
    -- Temprorarily making it simple as first, before going to something more complex
    local output = {}
    local output_stack = ''
    local output_stack_type = nil ---@type 'function'|'number'|nil
    local expStack = (exp:gsub('%s', '')):atomize()
    -- `STRING.atomize` is actually 10-50x faster than `string.gmatch`
    -- Check the code I put at the end of this file for more info

    for _, v in next, expStack do
        if find(v, '[0-9.]') then
            assert(
                not (
                    output_stack_type == 'function' and MATH_PROPERTY[output_stack] and
                    (
                        MATH_PROPERTY[output_stack].type == 'operator' or
                        MATH_PROPERTY[output_stack].type == 'constant'
                    )
                ),
                "SYNTAX ERROR: number can't go after a function"
            )
            output_stack = output_stack .. v
            output_stack_type = 'number'
        elseif find(v, '[a-z]') then
            if output_stack_type == 'number' then
                insert(output, '**') -- Hidden multiplying
                insert(output, output_stack)
                output_stack = ''
                output_stack_type = nil
            end
            output_stack = output_stack .. v
            output_stack_type = 'function'
        else
            if output_stack ~= '' then
                insert(output, output_stack)
                output_stack = ''
                output_stack_type = nil
            end
            insert(output, v)
        end
    end

    if output_stack ~= '' then insert(output, output_stack) end

    -- Check for missing closed bracket
    local opening_bracket = TABLE.count(output, "(")
    local closing_bracket = TABLE.count(output, ")")
    assert(opening_bracket >= closing_bracket, "SYNTAX ERROR: missing opening bracket!")
    TABLE.append(output, STRING.rep(")", opening_bracket - closing_bracket):atomize())

    return output
end

--[[
local sub, gmatch = string.sub, string.gmatch

local function bench_sub()
    local str = "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz"
    local total = 0
    for n = 1, 1e5 do
        for i = 1, #str do
            local c = sub(str, i, i)
            total = total + (#c) -- chống tối ưu hoá
        end
    end
    return total
end

local function bench_gmatch()
    local str = "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz"
    local total = 0
    for n = 1, 1e5 do
        for c in gmatch(str, ".") do
            total = total + (#c) -- chống tối ưu hoá
        end
    end
    return total
end

collectgarbage()

-- Đo thời gian:
local t1 = os.clock()
local result1 = bench_sub()
local t2 = os.clock()
print("sub():    ", t2 - t1, "sec")

collectgarbage()

local t3 = os.clock()
local result2 = bench_gmatch()
local t4 = os.clock()
print("gmatch(): ", t4 - t3, "sec")

-- Output check
assert(result1 == result2, "Mismatch!!")

----------------------------------------
Result:
sub():          0.01    sec
gmatch():       0.474   sec
]]