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

    -- Enable love's modules
    -- Better to keep like this in order to keep Zenitha can work stably
    t.modules={
        system=true,event=true,window=true,
        thread=true,math=true,data=true,

        -- WARNING: Disable timer module will lead to delta time is 0 in love.update()
        timer=true,

        video=false,  audio=false,sound=false,
        graphics=true,image=true ,font=true,

        mouse   =true,
        keyboard=true,
        touch   =true,
        joystick=false,

        physics =false,
    }

    t.gammacorrect=false
    t.appendidentity=true         -- Search files in source then in save directory
    t.accelerometerjoystick=false -- Accelerometer=joystick on ios/android
    if t.audio then
        t.audio.mic=false
        t.audio.mixwithsystem=true
    end

    t.window={
        title         ='KOSC',
        icon          =nil,

        display       =1,           -- Monitor ID
        vsync         =0,           -- 0 = Unlimited FPS, otherwise limit to x FPS
        msaa          =msaa,        -- Multi-sampled antialiasing
        highdpi       =true,        -- High-dpi mode for the window on a Retina display

        x             =nil,         -- Position of the window (set to nil so...
        y             =nil,         -- ...love2d will align the window to the center of the screen)

        width         =405,
        height        =720,
        minwidth      =405,
        minheight     =720,

        depth         =0,           -- Bits/samp of depth buffer
        stencil       =1,           -- Bits/samp of stencil buffer

        borderless    =MOBILE,
        resizable     =not MOBILE,
        fullscreentype=MOBILE and "exclusive" or "desktop", -- Fullscreen type
    }


    -- W.title="Techmino "..require"version".string -- Window title
    -- if system=='Linux' and fs.getInfo('media/image/icon.png') then
    --     W.icon='media/image/icon.png'
    -- end
end