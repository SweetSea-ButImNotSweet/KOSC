---@type table<string, function>
return {

    -- TODO: will redo this to support big integers

    ['+'] = function(a, b) return a + b end,
    ['-'] = function(a, b) return a - b end,
    ['*'] = function(a, b) return a * b end,
    ['/'] = function(a, b) return a / b end,
    ['^'] = function(a, b) return a ^ b end,

    -- Hidden mutiplier
    ['**'] = function(a, b) return a * b end,
    ['E'] = function(a, b) return 10 ^ b * a end,
    ['neg'] = function(a) return -a end,

    ['sin'] = function(x) return math.sin(x * math.pi / 180) end,
    ['cos'] = function(x) return math.cos(x * math.pi / 180) end,
    ['tan'] = function(x) return math.tan(x * math.pi / 180) end,
    ['sinh'] = function(x) return math.sinh(x * math.pi / 180) end,
    ['cosh'] = function(x) return math.cosh(x * math.pi / 180) end,
    ['tanh'] = function(x) return math.tanh(x * math.pi / 180) end,
    ['asin'] = function(x) return math.asin(x) * math.pi / 180 end,
    ['acos'] = function(x) return math.acos(x) * math.pi / 180 end,
    ['atan'] = function(x) return math.atan(x) * math.pi / 180 end,

    ['min'] = function(...) return math.min(...) end,
    ['max'] = function(...) return math.max(...) end,

    ['abs'] = function(x) return math.abs(x) end,
    -- ['fact'] = function(x) end,

    ['sqrt'] = function(x) return math.sqrt(x) end,
    ['root'] = function(x, n) return x ^ (1 / n) end,

    ['log'] = function(x, base) return math.log(x, base or 10) end,
    ['log10'] = function(x) return math.log(x, 10) end,
    ['ln'] = function(x) return math.log(x) end,

    ['int'] = function(x) return tonumber(tostring(x):gsub('.', '')) end,
    ['floor'] = function(x) return math.floor(x) end,

    ['mod'] = function(d, c) return math.fmod(d, c) end,
    ['fraction'] = function(a, b, c) return c and a + b / c or a / b end,
}
