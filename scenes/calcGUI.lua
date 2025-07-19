---@type Zenitha.Scene
local scene = {}
local gc_print, gc_setFont, gc_setColor = GC.print, GC.setFont, GC.setColor

---@type Zenitha.Widget.inputBox
---@diagnostic disable-next-line: assign-type-mismatch
local displayScreen = WIDGET.new { type = 'inputBox', x = 10, y = 30, w = 880, h = 250, fontSize = 45 }

local displaying = ''
---@type table<table<string>>
local exp_history = {}

require 'calc'
local tokenizer_simple = require 'calc.tokenizer_simple'

local shiftalphaStatus = 0 ---@type integer 0 is None, 1 is Shift, 2 is Alpha
local changeShiftAlphaStatus
do
    local keyList = {'shift', 'alpha'}
    local colorList = {'Yellow', 'Red'}

    ---@param status integer
    function changeShiftAlphaStatus(status)
        shiftalphaStatus = (shiftalphaStatus ~= status and status or 0)

        for index, key in ipairs(keyList) do
            local widget = scene.widgetList[key]
            if shiftalphaStatus == index then
                widget.type = 'button_fill'
                widget.textColor = colorList[shiftalphaStatus]
            else
                widget.type = 'button'
                widget.textColor = 'lightGray'
            end
            scene.widgetList[key]:reset()
        end
    end
end


--- Add necessary spacing so the expression looks not so out of breath
local function adding_stylizing_space_into_exp(tokenized_exp)
    for i, v in next, tokenized_exp do
        if MATH_PROPERTY[v] and MATH_PROPERTY[v].type == 'operator' then
            tokenized_exp[i] = ' '..v..' ' -- not important
        end
    end
end

local legitmate_input_table = require 'calc.data.input'
local keyboard_layout = require 'calc.data.keyboard_layout'
local ignored_keys = {[''] = 1, shift = 1, alpha = 1}
---@param key string
---This function will receive all key presses from the calculator
local function pressKey(key)
    if ignored_keys[key] then return end

    if shiftalphaStatus ~= 0 and legitmate_input_table[key] then
        key = keyboard_layout[key][shiftalphaStatus]
    end

    local prevFocused = WIDGET.sel -- There is a little animation bug!
    WIDGET.sel = displayScreen

    if key == 'ac' then
        displaying = ''
    elseif key == 'del' then
        local displaying_tokenized = tokenizer_simple(displaying)
        if (
            displaying_tokenized[#displaying_tokenized] == '(' and
            displaying_tokenized[#displaying_tokenized - 1]:gmatch('^%a+$')
        ) then
            table.remove(displaying_tokenized)
            table.remove(displaying_tokenized) -- Double to remove the function also

            adding_stylizing_space_into_exp(displaying_tokenized)
            displaying = table.concat(displaying_tokenized, '')
        else
            displaying = displaying:sub(1, #displaying - 1)
        end
    elseif key == '=' then
        local success, result = pcall(GoCalculate, displaying)
        MSG(success and "info" or "error", tostring(result or ""))
        if success then table.insert(exp_history, {displaying, result}) end
    elseif legitmate_input_table[key] then
        local displaying_tokenized = tokenizer_simple(displaying..legitmate_input_table[key])
        adding_stylizing_space_into_exp(displaying_tokenized)
        displaying = table.concat(displaying_tokenized, '')
    end

    changeShiftAlphaStatus(0)
    -- There is a little animation bug: if a widget is unfocus before it is released, then animation stuck
    WIDGET.sel = prevFocused
end

scene.keyDown = function(key, isRep)
    if key == 'return' or key == 'kpenter' then
        pressKey('=')
    elseif isRep or WIDGET.sel == displayScreen then
        return
    elseif key:sub(1, 2) and TABLE.find(legitmate_input_table, key:sub(3)) then
        pressKey(key:sub(3))
    end
end

local function getPressKeyFunc(key)
    return function() pressKey(key) end
end

function scene.draw()
    local currentFont = FONT.get(75)
    -- gc_setFont(currentFont)
    gc_print(displaying, currentFont, 900 - currentFont:getWidth(displaying) - 10, 150)

    currentFont = FONT.get(50)
    -- gc_setFont(currentFont)
    gc_setColor(COLOR.darkGray)
    local last_exp_string = #exp_history > 0 and (
        exp_history[#exp_history][1] .. ' = ' .. exp_history[#exp_history][2]
    ) or ''
    gc_print(last_exp_string, currentFont, 900 - currentFont:getWidth(last_exp_string) - 10, 80)

end

scene.widgetList = {
    --[[
    Button layout details:

    Case 1 (6 buttons):
    | 10px | 139px | 10px | 138px | 10px | 138px | 10px | 138px | 10px | 138px | 10px | 139px | 10px |
           ↑       ↑      ↑       ↑      ↑       ↑      ↑       ↑      ↑       ↑      ↑       ↑

    Case 2 (5 buttons):
    | 10px | 168px | 10px | 168px | 10px | 168px | 10px | 168px | 10px | 168px | 10px |
           ↑       ↑      ↑       ↑      ↑       ↑      ↑       ↑      ↑       ↑

    Notes:
    - All buttons are horizontally aligned with consistent spacing.
    - Button positions are specified using the horizontal center (x) of each button.
    - For buttons with only one supplemental function, the label above the button is center-aligned.
    - For buttons with two supplemental functions, the labels above the button are shifted inward
    by 5px relative to the corresponding edge of the button.
    ]]

    --#region
    shift = { type = 'button', x = 79.5,  y = 510, w = 139, h = 50, fontSize = 40, onPress = getPressKeyFunc(''), text = "SHIFT", color = 'Yellow', textColor = 'lightGray', onClick = function() changeShiftAlphaStatus(1) end,},
    alpha = { type = 'button', x = 228.0, y = 510, w = 138, h = 50, fontSize = 40, onPress = getPressKeyFunc(''), text = "ALPHA", color = 'Red'   , textColor = 'lightGray', onClick = function() changeShiftAlphaStatus(2) end,},

    { type = 'text',        x = 672.0, y = 450,  alignX = 'center', alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'SETUP' },
    { type = 'button',      x = 672.0, y = 510,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),            text = "MODE" },
    { type = 'button',      x = 820.5, y = 510,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),            text = "?" },
    --#endregion

    --#region
    -- { type = 'text',        x = 15,    y = 570,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'SOLVE' }, -- OPTN
    -- { type = 'text',        x = 144,   y = 570,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Red',                            text = '=' },
    { type = 'text',        x = 164,   y = 570,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'SOLVE' }, -- CALC
    { type = 'text',        x = 292,   y = 570,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Red',                            text = '=' },
    { type = 'text',        x = 608,   y = 570,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'DERI' }, -- DERI
    { type = 'text',        x = 736,   y = 570,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Red',                            text = ':' },
    -- { type = 'text',        x = 756,   y = 570,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'Σ' }, -- x
    -- { type = 'text',        x = 885,   y = 570,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Red',                            text = 'Π' },
    { type = 'button',      x = 79.5,  y = 630,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),            text = "OPTN" },
    { type = 'button',      x = 228.0, y = 630,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('calc'),        text = "CALC" },
    { type = 'button',      x = 672.0, y = 630,  w = 138,           h = 50,            fontSize = 30, onPress = getPressKeyFunc('antideri'),    text = "AntiDERI" },
    { type = 'button',      x = 820.5, y = 630,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('varX'),        text = "x" },
    --#endregion

    -- { type = 'text',        x = 15 ,   y = 690,  alignX = 'left',   alignY = 'center', fontSize = 20, color = 'Yellow',                         text = 'a+b/c' }, -- []/[]
    { type = 'text',        x = 144,   y = 690,  alignX = 'right',  alignY = 'center', fontSize = 20, color = 'Red',                            text = '/[R]' },
    { type = 'text',        x = 164,   y = 690,  alignX = 'left',   alignY = 'center', fontSize = 20, color = 'Yellow',                         text = '3th\nroot' }, -- SQRT
    -- { type = 'text',        x = 292,   y = 690,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Red',                            text = '(n)' },
    { type = 'text',        x = 312,   y = 690,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'x^3' }, -- x^2
    { type = 'text',        x = 440,   y = 690,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Blue',                           text = 'DEC' },
    { type = 'text',        x = 460,   y = 690,  alignX = 'left',   alignY = 'center', fontSize = 20, color = 'Yellow',                         text = 'nth\nroot' }, -- x^n
    { type = 'text',        x = 588,   y = 690,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Blue',                           text = 'HEX' },
    { type = 'text',        x = 608,   y = 690,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = '10^x' }, -- x^n
    { type = 'text',        x = 736,   y = 690,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Blue',                           text = 'BIN' },
    { type = 'text',        x = 756,   y = 690,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'e^x' }, -- x^n
    { type = 'text',        x = 885,   y = 690,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Blue',                           text = 'OCT' },
    { type = 'button',      x = 79.5,  y = 750,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),            text = "[]/[]" },
    { type = 'button',      x = 228.0, y = 750,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),            text = "SQRT" },
    { type = 'button',      x = 376.0, y = 750,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('^2'),          text = "x^2" },
    { type = 'button',      x = 524.0, y = 750,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('^'),           text = "x^n" },
    { type = 'button',      x = 672.0, y = 750,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('log'),         text = "log" },
    { type = 'button',      x = 820.5, y = 750,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('ln'),          text = "ln" },

    { type = 'text',        x = 15 ,   y = 810,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'log10' }, -- (-)
    { type = 'text',        x = 144,   y = 810,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Sea',                            text = 'A' },
    { type = 'text',        x = 164,   y = 810,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'FACT' }, -- DEG
    { type = 'text',        x = 292,   y = 810,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Sea',                            text = 'B' },
    { type = 'text',        x = 312,   y = 810,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'x!' }, -- x^-1
    { type = 'text',        x = 440,   y = 810,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Sea',                            text = 'C' },
    { type = 'text',        x = 460,   y = 810,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'asin' }, -- sin
    { type = 'text',        x = 588,   y = 810,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Sea',                            text = 'D' },
    { type = 'text',        x = 608,   y = 810,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'acos' }, -- cos
    { type = 'text',        x = 736,   y = 810,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Sea',                            text = 'E' },
    { type = 'text',        x = 756,   y = 810,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'atan' }, -- tan
    { type = 'text',        x = 885,   y = 810,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Sea',                            text = 'F' },
    { type = 'button',      x = 79.5,  y = 870,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('neg'),         text = "(-)" },
    { type = 'button',      x = 228.0, y = 870,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),            text = "DEG" },
    { type = 'button',      x = 376.0, y = 870,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('x^-1'),        text = "x^(-1)" },
    { type = 'button',      x = 524.0, y = 870,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('sin'),         text = "sin" },
    { type = 'button',      x = 672.0, y = 870,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('cos'),         text = "cos" },
    { type = 'button',      x = 820.5, y = 870,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('tan'),         text = "tan" },

    { type = 'text',        x = 312,   y = 930,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'Abs' }, -- x^-1
    { type = 'text',        x = 440,   y = 930,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Sea',                            text = 'x' },
    { type = 'text',        x = 460,   y = 930,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = ',' }, -- sin
    { type = 'text',        x = 588,   y = 930,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Sea',                            text = 'y' },
    -- { type = 'text',        x = 608,   y = 930,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = '' }, -- cos
    { type = 'text',        x = 736,   y = 930,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Sea',                            text = 'z' },
    { type = 'text',        x = 756,   y = 930,  alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'M+' }, -- tan
    { type = 'text',        x = 885,   y = 930,  alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Sea',                            text = 'M' },
    { type = 'button',      x = 79.5,  y = 990,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),            text = "STO" },
    { type = 'button',      x = 228.0, y = 990,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),            text = "ENG" },
    { type = 'button',      x = 376.0, y = 990,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('('),           text = "(" },
    { type = 'button',      x = 524.0, y = 990,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(')'),           text = ")" },
    { type = 'button',      x = 672.0, y = 990,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('sd'),          text = "S<->D" },
    { type = 'button',      x = 820.5, y = 990,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('M+'),          text = "M+" },

    ---[[ LOWER PART ]]------[[ LOWER PART ]]------[[ LOWER PART ]]------[[ LOWER PART ]]------[[ LOWER PART ]]---

    --#region
    { type = 'text',        x = 94,    y = 1050, alignX = 'center', alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'CONST' },   -- 7
    { type = 'text',        x = 272,   y = 1050, alignX = 'center', alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'CONV' },    -- 8
    { type = 'text',        x = 450,   y = 1050, alignX = 'center', alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'RESET' },   -- 9
    { type = 'text',        x = 549,   y = 1050, alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'INS' },     -- DEL
    { type = 'text',        x = 707,   y = 1050, alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Flame',                          text = 'UNDO' },    -- AC
    { type = 'text',        x = 806,   y = 1050, alignX = 'center', alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'EXIT' },
    { type = 'button',      x = 94,    y = 1120, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('7'),           text = "7" },
    { type = 'button',      x = 272,   y = 1120, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('8'),           text = "8" },
    { type = 'button',      x = 450,   y = 1120, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('9'),           text = "9" },
    { type = 'button_fill', x = 628,   y = 1120, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('del'),         text = "DEL",     fillColor = 'Sea' },
    { type = 'button_fill', x = 806,   y = 1120, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('ac'),          text = "AC",      fillColor = 'Sea' },
    --#endregion

    --#region
    -- { type = 'text',        x = 275,   y = 1190, alignX = 'center', alignY = 'center', fontSize = 30, color = 'lightSea',                       text = 'Piano' },   -- 5
    { type = 'text',        x = 549,   y = 1190, alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'nPr' },     -- *
    { type = 'text',        x = 707,   y = 1190, alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Flame',                          text = 'GCD' },
    { type = 'text',        x = 727,   y = 1190, alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'nCr' },     -- /
    { type = 'text',        x = 885,   y = 1190, alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Flame',                          text = 'LCM' },
    { type = 'button',      x = 94,    y = 1260, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('4'),           text = "4" },
    { type = 'button',      x = 272,   y = 1260, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('5'),           text = "5" },
    { type = 'button',      x = 450,   y = 1260, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('6'),           text = "6" },
    { type = 'button',      x = 628,   y = 1260, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('*'),           text = "*" },
    { type = 'button',      x = 806,   y = 1260, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('/'),           text = "/" },
    --#endregion

    --#region
    { type = 'text',        x = 549,   y = 1330, alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'Pol' },     -- +
    { type = 'text',        x = 707,   y = 1330, alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Flame',                          text = 'INT' },
    { type = 'text',        x = 727,   y = 1330, alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'Rec' },     -- -
    { type = 'text',        x = 885,   y = 1330, alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Flame',                          text = 'INT↓' },
    { type = 'button',      x = 94,    y = 1400, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('1'),           text = "1" },
    { type = 'button',      x = 272,   y = 1400, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('2'),           text = "2" },
    { type = 'button',      x = 450,   y = 1400, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('3'),           text = "3" },
    { type = 'button',      x = 628,   y = 1400, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('+'),           text = "+" },
    { type = 'button',      x = 806,   y = 1400, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('-'),           text = "-" },
    --#endregion

    --#region
    { type = 'text',        x = 94,    y = 1470, alignX = 'center', alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'Rnd' },     -- 0
    { type = 'text',        x = 188,   y = 1470, alignX = 'left',   alignY = 'center', fontSize = 25, color = 'Yellow',                         text = 'Ran#' },
    { type = 'text',        x = 356,   y = 1470, alignX = 'right',  alignY = 'center', fontSize = 25, color = 'Flame',                          text = 'RanInt' },
    { type = 'text',        x = 371,   y = 1470, alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                         text = 'π' },       -- .
    { type = 'text',        x = 529,   y = 1470, alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Flame',                          text = 'euler' },
    { type = 'text',        x = 549,   y = 1470, alignX = 'left',   alignY = 'center', fontSize = 25, color = 'Yellow',                         text = 'Ans' },     -- E
    { type = 'text',        x = 707,   y = 1470, alignX = 'right',  alignY = 'center', fontSize = 25, color = 'Flame',                          text = 'PreAns' },
    { type = 'text',        x = 806,   y = 1470, alignX = 'center', alignY = 'center', fontSize = 30, color = 'Yellow',                         text = '≈' },       -- =
    { type = 'button',      x = 94,    y = 1540, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('0'),           text = "0" },
    { type = 'button',      x = 272,   y = 1540, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('.'),           text = "." },
    { type = 'button',      x = 450,   y = 1540, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('E'),           text = "E" },
    { type = 'button',      x = 628,   y = 1540, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('ans'),         text = "Ans" },
    { type = 'button',      x = 806,   y = 1540, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('='),           text = "=" },
    --#endregion
}

return scene
