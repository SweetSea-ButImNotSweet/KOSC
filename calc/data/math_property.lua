---@class MATH_FUNCTION
---@field kind 'function'   Such as sin, cos, tan
---@field priority integer
---@field min_args integer
---@field max_args integer
---@field execute function  Function need to be executed to get the result
---@field input string      If press that button, which value need to be inserted into the input box
---@field alt_keys? table   Is that key have extra function? Only applied to base keys

---@class MATH_OPERATOR
---@field kind 'operator'   Such as +, -, *, /
---@field priority integer
---@field args integer
---@field right_associative? boolean
---@field execute function  Function need to be executed to get the result
---@field input string      If press that button, which value need to be inserted into the input box
---@field alt_keys? table   Is that key have extra function? Only applied to base keys

---@class MATH_VARIABLE
---@field kind 'variable'   Including: A, B, C, D, E, F, x, y, z and M
---@field priority integer
---@field input string      If press that button, which value need to be inserted into
---@field alt_keys? table   Is that key have extra function? Only applied to base keys

---@class MATH_CONSTANT
---@field kind 'constant'   Such as pi, e
---@field priority integer
---@field input string      If press that button, which value need to be inserted into
---@field alt_keys? table   Is that key have extra function? Only applied to base keys

---@class MATH_PARENTHESIS
---@field kind 'parenthesis'
---@field input string      If press that button, which value need to be inserted into
---@field alt_keys? table   Is that key have extra function? Only applied to base keys

---@class MATH_NUMBER
---@field kind 'number'     Including 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, `.`
---@field input string      If press that button, which value need to be inserted into
---@field alt_keys? table   Is that key have extra function? Only applied to base keys

---@alias MATH_OBJECT MATH_FUNCTION | MATH_OPERATOR | MATH_VARIABLE | MATH_CONSTANT | MATH_PARENTHESIS | MATH_NUMBER

---@type table<string, MATH_OBJECT>
MATH_PROPERTY = {
    ----------------------------------------------------------------------
    -- FUNCTIONS (from math_property.lua, functions.lua, input.lua, keyboard_layout.lua)
    ----------------------------------------------------------------------
    ['sin']   = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 1,
        input = "sin(",
        alt_keys = { 'asin', 'varD' },
        execute = function(x) return math.sin(x * math.pi / 180) end
    },
    ['cos']   = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 1,
        input = "cos(",
        alt_keys = { 'acos', 'varE' },
        execute = function(x) return math.cos(x * math.pi / 180) end
    },
    ['tan']   = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 1,
        input = "tan(",
        alt_keys = { 'atan', 'varF' },
        execute = function(x) return math.tan(x * math.pi / 180) end
    },
    ['sinh']  = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 1,
        input = "sinh(",
        execute = function(x) return math.sinh(x * math.pi / 180) end
    },
    ['cosh']  = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 1,
        input = "cosh(",
        execute = function(x) return math.cosh(x * math.pi / 180) end
    },
    ['tanh']  = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 1,
        input = "tanh(",
        execute = function(x) return math.tanh(x * math.pi / 180) end
    },
    ['asin']  = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 1,
        input = "asin(",
        execute = function(x) return math.asin(x) * math.pi / 180 end
    },
    ['acos']  = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 1,
        input = "acos(",
        execute = function(x) return math.acos(x) * math.pi / 180 end
    },
    ['atan']  = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 1,
        input = "atan(",
        execute = function(x) return math.atan(x) * math.pi / 180 end
    },

    ['min']   = {
        kind = 'function',
        priority = 5,
        min_args = 2,
        max_args = 1e99,
        input = "min(",
        execute = function(...) return math.min(...) end
    },
    ['max']   = {
        kind = 'function',
        priority = 5,
        min_args = 2,
        max_args = 1e99,
        input = "max(",
        execute = function(...) return math.max(...) end
    },

    ['abs']   = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 1,
        input = "abs(",
        execute = function(x) return math.abs(x) end
    },
    -- ['fact'] = { type = 'function', priority = 5, min_args = 1, max_args = 1, input = "fact(" }, -- execute function not provided

    ['sqrt']  = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 1,
        input = "sqrt(",
        alt_keys = { '3thrt', '' },
        execute = function(x) return math.sqrt(x) end
    },
    ['root']  = {
        kind = 'function',
        priority = 5,
        min_args = 2,
        max_args = 2,
        input = "root(",
        execute = function(x, n) return x ^ (1 / n) end
    },

    ['log']   = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 2,
        input = "log(",
        alt_keys = { '10^', '' },
        execute = function(x, base) return math.log(x, base or 10) end
    },
    ['ln']    = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 1,
        input = "ln(",
        alt_keys = { 'e^', '' },
        execute = function(x) return math.log(x) end
    },

    ['int']   = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 1,
        input = "int(",
        execute = function(x) return tonumber(tostring(x):gsub('.', '')) end
    },
    ['floor'] = {
        kind = 'function',
        priority = 5,
        min_args = 1,
        max_args = 1,
        input = "floor(",
        execute = function(x) return math.floor(x) end
    },

    ['frac']  = {
        kind = 'function',
        priority = 4,
        min_args = 2,
        max_args = 3,
        input = "frac(",
        execute = function(a, b, c) return c and a + b / c or a / b end
    },
    ['mod']   = {
        kind = 'function',
        priority = 4,
        min_args = 2,
        max_args = 2,
        input = "mod(",
        alt_keys = { '', 'mod' },
        execute = function(d, c) return math.fmod(d, c) end
    },


    -- sigma and Pi are special, might need more logic
    ['sigma'] = { kind = 'function', priority = 5, min_args = 4, max_args = 4, input = "sigma(", alt_keys = { 'Sigma', 'Pi' } },
    ['Pi']    = { kind = 'function', priority = 5, min_args = 4, max_args = 4, input = "Pi(" },

    -------------------------------------------------------------------
    -- OPERATORS
    -------------------------------------------------------------------
    ['neg']   = { kind = 'operator', priority = 7, args = 1, execute = function(a) return -a end, input = "-", alt_keys = { 'log', 'varA' } }, -- Unary minus
    ['E']     = { kind = 'operator', priority = 6, args = 2, execute = function(a, b) return 10 ^ b * a end, input = "E", alt_keys = { 'pi', 'e' } },
    ['**']    = { kind = 'operator', priority = 4, args = 2, execute = function(a, b) return a * b end, input = "" },                          -- Hidden multiply
    ['^']     = { kind = 'operator', priority = 3, args = 2, execute = function(a, b) return a ^ b end, input = "^" },
    ['*']     = { kind = 'operator', priority = 2, args = 2, execute = function(a, b) return a * b end, input = "*", alt_keys = { 'ins', 'undo' } },
    ['/']     = { kind = 'operator', priority = 2, args = 2, execute = function(a, b) return a / b end, input = "/", alt_keys = { 'gcd', 'lcm' } },
    ['+']     = { kind = 'operator', priority = 1, args = 2, execute = function(a, b) return a + b end, input = "+", alt_keys = { 'pol', 'int' } },
    ['-']     = { kind = 'operator', priority = 1, args = 2, execute = function(a, b) return a - b end, input = "-", alt_keys = { 'rec', 'floor' } }, -- Binary minus

    -------------------------------------------------------------------
    -- SPECIAL POWER OPERATORS
    -------------------------------------------------------------------
    ['^2']    = { kind = 'operator', priority = 3, args = 1, input = "^2" }, -- Needs custom logic
    ['^3']    = { kind = 'operator', priority = 3, args = 1, input = "^3" }, -- Needs custom logic

    -------------------------------------------------------------------
    -- VARIABLES
    -------------------------------------------------------------------
    ['varA']  = { kind = 'variable', priority = 8, input = "varA" },
    ['varB']  = { kind = 'variable', priority = 8, input = "varB" },
    ['varC']  = { kind = 'variable', priority = 8, input = "varC" },
    ['varD']  = { kind = 'variable', priority = 8, input = "varD" },
    ['varE']  = { kind = 'variable', priority = 8, input = "varE" },
    ['varF']  = { kind = 'variable', priority = 8, input = "varF" },
    ['varX']  = { kind = 'variable', priority = 8, input = "varX" },
    ['varY']  = { kind = 'variable', priority = 8, input = "varY" },
    ['varZ']  = { kind = 'variable', priority = 8, input = "varZ" },
    ['varM']  = { kind = 'variable', priority = 8, input = "varM" },

    -------------------------------------------------------------------
    -- PARENTHESES
    -------------------------------------------------------------------
    ['(']     = { kind = 'parenthesis', input = "(", alt_keys = { 'abs', 'varX' } },
    [')']     = { kind = 'parenthesis', input = ")", alt_keys = { 'abs', 'varY' } },

    -------------------------------------------------------------------
    -- NUMBERS & SYMBOLS
    -------------------------------------------------------------------
    ['1']     = { kind = 'number', input = "1" },
    ['2']     = { kind = 'number', input = "2" },
    ['3']     = { kind = 'number', input = "3" },
    ['4']     = { kind = 'number', input = "4" },
    ['5']     = { kind = 'number', input = "5" },
    ['6']     = { kind = 'number', input = "6" },
    ['7']     = { kind = 'number', input = "7" },
    ['8']     = { kind = 'number', input = "8" },
    ['9']     = { kind = 'number', input = "9" },
    ['0']     = { kind = 'number', input = "0", alt_keys = { 'rnd', '' } },
    ['.']     = { kind = 'number', input = ".", alt_keys = { 'ran', '' } },
}
