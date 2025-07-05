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

    ['sin'] = function(x) return math.sin(x * math.pi / 180) end,
    ['cos'] = function(x) return math.cos(x * math.pi / 180) end,
    ['tan'] = function(x) return math.tan(x * math.pi / 180) end,

    ['min'] = function(...) return math.min(...) end,
    ['max'] = function(...) return math.max(...) end,

    ['sqrt'] = function(x) return math.sqrt(x) end,
    ['root'] = function(x, n) return x^(1/n) end,
}
