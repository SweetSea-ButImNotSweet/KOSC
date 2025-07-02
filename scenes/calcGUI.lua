---@type Zenitha.Scene
local scene = {}
---@type Zenitha.Widget.inputBox
---@diagnostic disable-next-line: assign-type-mismatch
local displayScreen = WIDGET.new { type = 'inputBox', x = 10, y = 30, w = 880, h = 250, fontSize = 45 }

require 'calc'

local singleCharKey = { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '+', '-', '*', '/', '.', 'E' }
---@param key string
---This function will receive all key presses from the calculator
local function pressKey(key)
    local prevFocused = WIDGET.sel -- There is a little animation bug!
    WIDGET.sel = displayScreen

    if key == 'AC' then
        displayScreen:setText('') -- Clear all
    elseif key == 'DEL' then
        love.keypressed('backspace', 'backspace', false)
    elseif key == '=' then
        local result = GoCalculate(displayScreen:getText())
        if result then MSG("info", tostring(result)) end
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

    { type = 'button', x = 94, y = 975, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('7'), text = "7" },
    { type = 'button', x = 272, y = 975, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('8'), text = "8" },
    { type = 'button', x = 450, y = 975, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('9'), text = "9" },
    { type = 'button', x = 628, y = 975, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('DEL'), text = "DEL" },
    { type = 'button', x = 806, y = 975, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('AC'), text = "AC" },

    { type = 'button', x = 94, y = 1150, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('4'), text = "4" },
    { type = 'button', x = 272, y = 1150, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('5'), text = "5" },
    { type = 'button', x = 450, y = 1150, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('6'), text = "6" },
    { type = 'button', x = 628, y = 1150, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('*'), text = "*" },
    { type = 'button', x = 806, y = 1150, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('/'), text = "/" },

    { type = 'button', x = 94, y = 1325, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('1'), text = "1" },
    { type = 'button', x = 272, y = 1325, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('2'), text = "2" },
    { type = 'button', x = 450, y = 1325, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('3'), text = "3" },
    { type = 'button', x = 628, y = 1325, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('+'), text = "+" },
    { type = 'button', x = 806, y = 1325, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('-'), text = "-" },

    { type = 'button', x = 94, y = 1500, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('0'), text = "0" },
    { type = 'button', x = 272, y = 1500, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('.'), text = "." },
    { type = 'button', x = 450, y = 1500, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('E'), text = "E" },
    { type = 'button', x = 628, y = 1500, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('Ans'), text = "Ans" },
    { type = 'button', x = 806, y = 1500, w = 168, h = 100, fontSize = 50, onPress = getPressKeyFunc('='), text = "=" },
}

return scene