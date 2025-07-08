---@type Zenitha.Scene
local scene = {}
---@type Zenitha.Widget.inputBox
---@diagnostic disable-next-line: assign-type-mismatch
local displayScreen = WIDGET.new { type = 'inputBox', x = 10, y = 30, w = 880, h = 250, fontSize = 45 }

require 'calc'

local singleCharKey = {
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '.', 'E',
    '+', '-', '*', '/', '^',
    '(', ')',
}
---@param key string
---This function will receive all key presses from the calculator
local function pressKey(key)
    if key == '' then return end

    local prevFocused = WIDGET.sel -- There is a little animation bug!
    WIDGET.sel = displayScreen

    if key == 'AC' then
        displayScreen:setText('') -- Clear all
    elseif key == 'DEL' then
        love.keypressed('backspace', 'backspace', false)
    elseif key == '=' then
        local success, result = pcall(GoCalculate, displayScreen:getText())
        MSG(success and "info" or "error", tostring(result or ""))
    elseif TABLE.find(singleCharKey, key) then
        love.textinput(key)
    end

    -- There is a little animation bug: if a widget is unfocus before it is released, then animation stuck
    WIDGET.sel = prevFocused
end

scene.keyDown = function(key, isRep)
    if key == 'return' or key == 'kpenter' then
        pressKey('=')
    elseif isRep or WIDGET.sel == displayScreen then
        return
    elseif key:sub(1, 2) and TABLE.find(singleCharKey, key:sub(3)) then
        pressKey(key:sub(3))
    end
end

local function getPressKeyFunc(key)
    return function() pressKey(key) end
end

scene.widgetList = {
    displayScreen,

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


    { type = 'button_fill', x = 79.5,  y = 510,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "SHIFT",   fillColor = 'Yellow', textColor = 'Black', },
    { type = 'button_fill', x = 228.0, y = 510,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "ALPHA",   fillColor = 'Red',    textColor = 'Black', },
    { type = 'button',      x = 672.0, y = 510,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "MODE" },
    { type = 'button',      x = 820.5, y = 510,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "?" },

    { type = 'button',      x = 79.5,  y = 630,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "OPTN" },
    { type = 'button',      x = 228.0, y = 630,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "CALC" },
    { type = 'button',      x = 672.0, y = 630,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "DERI" },
    { type = 'button',      x = 820.5, y = 630,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "x" },

    { type = 'button',      x = 79.5,  y = 750,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "[]/[]" },
    { type = 'button',      x = 228.0, y = 750,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "SQRT" },
    { type = 'button',      x = 376.0, y = 750,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "x^2" },
    { type = 'button',      x = 524.0, y = 750,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "x^n" },
    { type = 'button',      x = 672.0, y = 750,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "log" },
    { type = 'button',      x = 820.5, y = 750,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "ln" },

    { type = 'button',      x = 79.5,  y = 870,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "(-)" },
    { type = 'button',      x = 228.0, y = 870,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "DEG" },
    { type = 'button',      x = 376.0, y = 870,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "x^(-1)" },
    { type = 'button',      x = 524.0, y = 870,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "sin" },
    { type = 'button',      x = 672.0, y = 870,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "cos" },
    { type = 'button',      x = 820.5, y = 870,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "tan" },

    { type = 'button',      x = 79.5,  y = 990,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "STO" },
    { type = 'button',      x = 228.0, y = 990,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "ENG" },
    { type = 'button',      x = 376.0, y = 990,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc('('),   text = "(" },
    { type = 'button',      x = 524.0, y = 990,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(')'),   text = ")" },
    { type = 'button',      x = 672.0, y = 990,  w = 138,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "S<->D" },
    { type = 'button',      x = 820.5, y = 990,  w = 139,           h = 50,            fontSize = 40, onPress = getPressKeyFunc(''),    text = "M+" },

    ---[[ LOWER PART ]]------[[ LOWER PART ]]------[[ LOWER PART ]]------[[ LOWER PART ]]------[[ LOWER PART ]]---

    { type = 'text',        x = 94,    y = 1050, alignX = 'center', alignY = 'center', fontSize = 30, color = 'Yellow',                 text = 'CONST' },
    { type = 'button',      x = 94,    y = 1120, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('7'),   text = "7" },
    { type = 'text',        x = 272,   y = 1050, alignX = 'center', alignY = 'center', fontSize = 30, color = 'Yellow',                 text = 'CONV' },
    { type = 'button',      x = 272,   y = 1120, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('8'),   text = "8" },
    { type = 'text',        x = 450,   y = 1050, alignX = 'center', alignY = 'center', fontSize = 30, color = 'Yellow',                 text = 'RESET' },
    { type = 'button',      x = 450,   y = 1120, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('9'),   text = "9" },
    { type = 'text',        x = 549,   y = 1050, alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                 text = 'INS' },
    { type = 'text',        x = 707,   y = 1050, alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Flame',                  text = 'UNDO' },
    { type = 'button_fill', x = 628,   y = 1120, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('DEL'), text = "DEL",     fillColor = 'Sea' },
    { type = 'text',        x = 806,   y = 1050, alignX = 'center', alignY = 'center', fontSize = 30, color = 'Yellow',                 text = 'EXIT' },
    { type = 'button_fill', x = 806,   y = 1120, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('AC'),  text = "AC",      fillColor = 'Sea' },

    { type = 'button',      x = 94,    y = 1260, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('4'),   text = "4" },
    { type = 'text',        x = 275,   y = 1190, alignX = 'center', alignY = 'center', fontSize = 30, color = 'lightSea',               text = 'Piano' },
    { type = 'button',      x = 272,   y = 1260, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('5'),   text = "5" },
    { type = 'button',      x = 450,   y = 1260, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('6'),   text = "6" },
    { type = 'text',        x = 549,   y = 1190, alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                 text = 'nPr' },
    { type = 'text',        x = 707,   y = 1190, alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Flame',                  text = 'GCD' },
    { type = 'button',      x = 628,   y = 1260, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('*'),   text = "*" },
    { type = 'text',        x = 727,   y = 1190, alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                 text = 'nCr' },
    { type = 'text',        x = 885,   y = 1190, alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Flame',                  text = 'LCM' },
    { type = 'button',      x = 806,   y = 1260, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('/'),   text = "/" },

    { type = 'button',      x = 94,    y = 1400, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('1'),   text = "1" },
    { type = 'button',      x = 272,   y = 1400, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('2'),   text = "2" },
    { type = 'button',      x = 450,   y = 1400, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('3'),   text = "3" },
    { type = 'text',        x = 549,   y = 1330, alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                 text = 'Pol' },
    { type = 'text',        x = 707,   y = 1330, alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Flame',                  text = 'INT' },
    { type = 'button',      x = 628,   y = 1400, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('+'),   text = "+" },
    { type = 'text',        x = 727,   y = 1330, alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                 text = 'Rec' },
    { type = 'text',        x = 885,   y = 1330, alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Flame',                  text = 'INT↓' },
    { type = 'button',      x = 806,   y = 1400, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('-'),   text = "-" },

    { type = 'text',        x = 94,    y = 1470, alignX = 'center', alignY = 'center', fontSize = 30, color = 'Yellow',                 text = 'Rnd' },
    { type = 'button',      x = 94,    y = 1540, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('0'),   text = "0" },
    { type = 'text',        x = 188,   y = 1470, alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                 text = 'Ran#' },
    { type = 'text',        x = 356,   y = 1470, alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Flame',                  text = 'RanInt' },
    { type = 'button',      x = 272,   y = 1540, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('.'),   text = "." },
    { type = 'text',        x = 371,   y = 1470, alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                 text = 'π' },
    { type = 'text',        x = 529,   y = 1470, alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Flame',                  text = 'euler' },
    { type = 'button',      x = 450,   y = 1540, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('E'),   text = "E" },
    { type = 'text',        x = 549,   y = 1470, alignX = 'left',   alignY = 'center', fontSize = 30, color = 'Yellow',                 text = 'Ans' },
    { type = 'text',        x = 707,   y = 1470, alignX = 'right',  alignY = 'center', fontSize = 30, color = 'Flame',                  text = 'PreAns' },
    { type = 'button',      x = 628,   y = 1540, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('Ans'), text = "Ans" },
    { type = 'text',        x = 806,   y = 1470, alignX = 'center', alignY = 'center', fontSize = 30, color = 'Yellow',                 text = '≈' },
    { type = 'button',      x = 806,   y = 1540, w = 168,           h = 70,            fontSize = 50, onPress = getPressKeyFunc('='),   text = "=" },
}

return scene
