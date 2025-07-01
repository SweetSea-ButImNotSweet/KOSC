if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

require "Zenitha"
STRING.install()

SCR.setSize(900, 1600)

WIDGET.setDefaultOption{
    button={type='button',cornerR=0},
}

for _, v in next,love.filesystem.getDirectoryItems("scenes/") do
    local name=v:sub(1,-5)
    SCN.add(name, require("scenes."..name))
end
ZENITHA.setFirstScene('calcGUI')