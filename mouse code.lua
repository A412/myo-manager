function onPoseEdge(pose, edge)
    pose=conditionallySwapWave(pose) 
    local now = myo.getTimeMilliseconds()

    --Other shortcut control 
    if edge == "on" then
        if pose == "thumbToPinky" then
            myo.centerMousePosition()
        elseif pose == "fingersSpread" then
            myo.keyboard("space","down")
            myo.mouse("right","down")
        elseif pose == "fist"  then
            myo.mouse("left","down")
        elseif pose == "waveIn" then
            myo.mouse("right","down")
        elseif pose == "waveOut" then 
            --unused
        end
    elseif edge=="off" then
    --Unlatch holding
        myo.mouse("left","up")
        myo.mouse("right","up")
        myo.keyboard("space","up")
    end
end

-- onPeriodic runs every ~10ms
function onPeriodic()
    
end
function onActiveChange(isActive)
    if isActive then
        enabled = true
        myo.controlMouse(true)
    else
        enabled = false
        myo.controlMouse(false)
    end 
end
