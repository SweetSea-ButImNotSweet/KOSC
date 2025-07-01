local system=love._os
if system=='OS X' then system='macOS' end
MOBILE=system=='Android' or system=='iOS'
FNNS=system:find'\79\83' -- What does FNSF stand for? IDK so don't ask me lol

if system=='Web' then
    local oldRead=love.filesystem.read

    function love.filesystem.read(name,size)
        if love.filesystem.getInfo(name) then
            return oldRead(name,size)
        end
    end
end

function love.conf(t)
    local identity='KOSC'
    local msaa=0

    local fs=love.filesystem
    fs.setIdentity(identity)

    t.identity=identity -- Saving folder
    t.version="11.5"
    t.gammacorrect=false
    t.appendidentity=true         -- Search files in source then in save directory
    t.accelerometerjoystick=false -- Accelerometer=joystick on ios/android
    if t.audio then
        t.audio.mic=false
        t.audio.mixwithsystem=true
    end

    t.modules = {
        window    = true,
        system    = true,
        event     = true,
        thread    = true,
        timer     = true,
        math      = true,
        data      = true,
        video     = true,
        audio     = false,
        sound     = false,
        graphics  = true,
        font      = true,
        image     = true,
        mouse     = true,
        touch     = true,
        keyboard  = true,
        joystick  = true,
        physics   = false,
    }

    local W=t.window
    W.vsync=0              -- Unlimited FPS
    W.msaa=msaa            -- Multi-sampled antialiasing
    W.depth=0              -- Bits/samp of depth buffer
    W.stencil=1            -- Bits/samp of stencil buffer
    W.display=1            -- Monitor ID
    W.highdpi=true         -- High-dpi mode for the window on a Retina display
    W.x,W.y=nil,nil        -- Position of the window
    W.borderless=MOBILE    -- Display window frame
    W.resizable=not MOBILE -- Whether window is resizable

    W.fullscreentype=MOBILE and "exclusive" or "desktop" -- Fullscreen type

    W.width   ,W.height   =405,720
    W.minwidth,W.minheight=405,720

    -- W.title="Techmino "..require"version".string -- Window title
    -- if system=='Linux' and fs.getInfo('media/image/icon.png') then
    --     W.icon='media/image/icon.png'
    -- end
end