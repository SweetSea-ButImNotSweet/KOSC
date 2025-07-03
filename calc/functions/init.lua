return {

    -- TODO: will redo this to support big integers

    ['+'] = function(a, b) return a + b end,
    ['-'] = function(a, b) return a - b end,
    ['*'] = function(a, b) return a * b end,
    ['/'] = function(a, b) return a / b end,
    ['^'] = function(a, b) return a ^ b end,

    -- Hidden mutiplier
    ['**'] = function(a, b) return a * b end,

    ['E'] = function(a, b) return 10^b*a end,

    ['sin'] = function(x) return math.sin(x) end,

    ['max'] = function(...) return math.max(...) end;
}