---@type Zenitha.Scene
local scene={}

function scene.load()
end

function scene.gamepadDown(key)
end
function scene.gamepadUp(key)

end
function scene.keyDown(key,isRep)
end
function scene.keyUp(key)
end

function scene.mouseClick(x,y)
end
function scene.mouseDown(x,y,k)
end
function scene.mouseMove(x,y)
end
function scene.mouseUp(x,y,k)
end

function scene.touchClick(x,y)
end
function scene.touchDown(x,y)
end
function scene.touchMove(x,y)
end
function scene.touchUp(x,y)
end
function scene.wheelMove(dx,dy)
end

function scene.fileDrop(file)
end
function scene.folderDrop(path)
end

function scene.update(dt)
end

function scene.draw()
end

scene.widgetList={
    {type='button', x= 42.5, y=515, w=75, h=50, text="7"},
    {type='button', x=122.5, y=515, w=75, h=50, text="8"},
    {type='button', x=202.5, y=515, w=75, h=50, text="9"},
    {type='button', x=282.5, y=515, w=75, h=50, text="DEL"},
    {type='button', x=362.5, y=515, w=75, h=50, text="AC"},

    {type='button', x= 42.5, y=570, w=75, h=50, text="4"},
    {type='button', x=122.5, y=570, w=75, h=50, text="5"},
    {type='button', x=202.5, y=570, w=75, h=50, text="6"},
    {type='button', x=282.5, y=570, w=75, h=50, text="*"},
    {type='button', x=362.5, y=570, w=75, h=50, text="/"},

    {type='button', x= 42.5, y=625, w=75, h=50, text="1"},
    {type='button', x=122.5, y=625, w=75, h=50, text="2"},
    {type='button', x=202.5, y=625, w=75, h=50, text="3"},
    {type='button', x=282.5, y=625, w=75, h=50, text="+"},
    {type='button', x=362.5, y=625, w=75, h=50, text="-"},

    {type='button', x= 42.5, y=680, w=75, h=50, text="0"},
    {type='button', x=122.5, y=680, w=75, h=50, text="."},
    {type='button', x=202.5, y=680, w=75, h=50, text="E"},
    {type='button', x=282.5, y=680, w=75, h=50, text="Ans"},
    {type='button', x=362.5, y=680, w=75, h=50, text="="},
}

return scene