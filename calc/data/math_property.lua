---@class MATH_FUNCTION
---@field type 'function'
---@field priority integer
---@field min_args integer
---@field max_args integer

---@class MATH_OPERATOR
---@field type 'operator'
---@field priority integer
---@field args integer
---@field right_associative? boolean

---@class MATH_VARIABLE
---@field type 'variable'
---@field priority integer

---@class MATH_CONSOTANT
---@field type 'constoant'
---@field priority integer

---@alias MATH_OBJECT MATH_FUNCTION | MATH_OPERATOR | MATH_VARIABLE | MATH_CONSOTANT


---@type table<string, MATH_OBJECT>
MATH_PROPERTY = {
    -- FUNCTIONS -- FUNCTIONS -- FUNCTIONS -- FUNCTIONS -- FUNCTIONS --
    ['sin']   = { type = 'function', priority = 5, min_args = 1, max_args = 1 },
    ['cos']   = { type = 'function', priority = 5, min_args = 1, max_args = 1 },
    ['tan']   = { type = 'function', priority = 5, min_args = 1, max_args = 1 },
    ['sinh']  = { type = 'function', priority = 5, min_args = 1, max_args = 1 },
    ['cosh']  = { type = 'function', priority = 5, min_args = 1, max_args = 1 },
    ['tanh']  = { type = 'function', priority = 5, min_args = 1, max_args = 1 },
    ['asin']  = { type = 'function', priority = 5, min_args = 1, max_args = 1 },
    ['acos']  = { type = 'function', priority = 5, min_args = 1, max_args = 1 },
    ['atan']  = { type = 'function', priority = 5, min_args = 1, max_args = 1 },

    ['min']   = { type = 'function', priority = 5, min_args = 2, max_args = 1e99, },
    ['max']   = { type = 'function', priority = 5, min_args = 2, max_args = 1e99, },

    ['abs']   = { type = 'function', priority = 5, min_args = 1, max_args = 1, },
    ['fact']  = { type = 'function', priority = 5, min_args = 1, max_args = 1, },

    ['sqrt']  = { type = 'function', priority = 5, min_args = 1, max_args = 1 },
    ['root']  = { type = 'function', priority = 5, min_args = 2, max_args = 2 },

    ['log']   = { type = 'function', priority = 5, min_args = 1, max_args = 2, },
    ['ln']    = { type = 'function', priority = 5, min_args = 1, max_args = 1, },

    ['int']   = { type = 'function', priority = 5, min_args = 1, max_args = 1 },
    ['floor'] = { type = 'function', priority = 5, min_args = 1, max_args = 1 },

    ['frac']  = { type = 'function', priority = 4, min_args = 2, max_args = 3 },
    ['mod']   = { type = 'function', priority = 4, min_args = 2, max_args = 2 },

    -- OPERATORS -- OPERATORS -- OPERATORS -- OPERATORS -- OPERATORS --
    ['neg']   = { type = 'operator', priority = 7, args = 1 },
    ['E']     = { type = 'operator', priority = 6, args = 2, right_associative = true },
    ['**']    = { type = 'operator', priority = 4, args = 2, }, --[[Hidden multiply]]
    ['^']     = { type = 'operator', priority = 3, args = 2, },
    ['*']     = { type = 'operator', priority = 2, args = 2, },
    ['/']     = { type = 'operator', priority = 2, args = 2, },
    ['+']     = { type = 'operator', priority = 1, args = 2, },
    ['-']     = { type = 'operator', priority = 1, args = 2, },
}
