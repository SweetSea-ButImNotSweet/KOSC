local MATH_PROPERTY = MATH_PROPERTY
local insert, remove = table.insert, table.remove

---@class AST_node
---@field kind
---| "number": a literal number like 1.23
---| "variable": a variable name like "x" or "y"
---| "unary": a unary operator like "-", "!" (not used for now)
---| "operator": a binary operator like "+", "*", "^"
---| "function": a function call like "sin(x)" or "max(a,b)"
---| "parenthesis"
---@field value?
---| number like 111 222 333
---| string can be function or operator or variable name
---@field children
---|AST_node[]  Other nodes
---|number[]    Number
---|string[]    Variable

---@param token string
---@param token_type string?
---@return AST_node
local function createNewNode(token, token_type)
    if not token_type and not MATH_PROPERTY[token] then error("WTF the token ".. token .." isn't existed in MATH_PROPERTY!") end

    return {
        kind = token_type,
        value = token,
        children = {}
    }
end

---@return AST_node[]?
return function(tokenList)
    local op_stack = {}     ---@type AST_node[]
    local node_stack = {}   ---@type AST_node[]

    for _, token in pairs(tokenList) do
        local token_type --[[or token_kind]] = MATH_PROPERTY[token].kind
        local token_new_node = createNewNode(token, token_type)

        if token_type == 'number' then
            insert(node_stack, token_new_node)
        elseif token_type == 'operator' then
            while #node_stack > 0 do
                --[[
                Bắt đầu check nếu như toán tử hiện tại của mình mạnh hơn,
                thì bắt đầu gom các toán tử lại
                    - Mỗi toán tử sẽ gom 1/2 node trong stack node
                    - Sau khi làm xong thì trở thành node con mới trong
                  node op đang hoàn thành ở chuỗi token
                ]]
                local latest_op_node = op_stack[#op_stack]
                local latest_op = latest_op_node.value ---@cast latest_op string

                if MATH_PROPERTY[latest_op].priority >= MATH_PROPERTY[token].priority then
                    break
                end

                for _ = 1, MATH_PROPERTY[latest_op].args do
                    insert(latest_op_node.children, remove(node_stack))
                end
                insert(latest_op_node, token_new_node)
            end

            insert(op_stack, token_new_node)
        end
    end
end