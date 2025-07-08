if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

require "Zenitha"
STRING.install()

SCR.setSize(900, 1600)
love.mouse.setVisible(false)

FONT.load {
    regular = 'fonts/VictorMono-Regular.otf',
    bold = 'fonts/VictorMono-Bold.otf',
}
FONT.setDefaultFont('bold')

WIDGET.setDefaultOption {
    button = { type = 'button', cornerR = 0, lineWidth = 1 },
}
do
    WIDGET.newClass('button_fill', 'button')
    local gc_scale, gc_push, gc_translate = GC.scale, GC.push, GC.translate
    local gc_setColor, gc_mRect, gc_pop = GC.setColor, GC.mRect, GC.pop
    local gc_setLineWidth = GC.setLineWidth
    local alignDraw = WIDGET._alignDraw

    ---@class Zenitha.Widget.button_fill: Zenitha.Widget.button
    function WIDGET._prototype.button_fill:draw()
        gc_push('transform')
        gc_translate(self._x, self._y)

        if self._pressTime > 0 then
            gc_scale(1 - self._pressTime / self._pressTimeMax * .0626)
        end

        local w, h = self.w, self.h
        local HOV = self._hoverTime / self._hoverTimeMax

        local fillC = self.fillColor
        local frameC=self.frameColor
        local r, g, b = fillC[1], fillC[2], fillC[3]

        -- Rectangle
        gc_setColor(.15 + r * .7 * (1 - HOV * .26), .15 + g * .7 * (1 - HOV * .26), .15 + b * .7 * (1 - HOV * .26), .9)
        gc_mRect('fill', 0, 0, w, h, self.cornerR)

        -- Frame
        gc_setLineWidth(self.lineWidth)
        gc_setColor(.2+frameC[1]*.8,.2+frameC[2]*.8,.2+frameC[3]*.8,.95)
        gc_mRect('line',0,0,w,h,self.cornerR)

        -- Drawable
        if self._image then
            gc_setColor(1, 1, 1)
            alignDraw(self, self._image)
        end
        if self._text then
            gc_setColor(self.textColor)
            alignDraw(self, self._text)
        end
        gc_pop()
    end
end

for _, v in next, love.filesystem.getDirectoryItems("scenes/") do
    local name = v:sub(1, -5)
    SCN.add(name, require("scenes." .. name))
end
ZENITHA.setFirstScene('calcGUI')

local ZENITHA_original_keyDown = ZENITHA.globalEvent.keyDown
function ZENITHA.globalEvent.keyDown(key,isRep)
    if ZENITHA_original_keyDown(key,isRep) then return true end
    if key=='f11' then
        love.window.setFullscreen(not love.window.getFullscreen())
        return true
    end
end

require('calc.data.math_property') -- Initialize all constants required
