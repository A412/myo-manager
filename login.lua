scriptId = 'com.cmv.login'

function keypress(key)
	myo.keyboard(key,"press")
end

function lockwindows()
	myo.keyboard("f11", "press")
end

UNLOCKED_TIMEOUT = 5000

function extendunlock()
	unlockedSince = myo.getTimeMilliseconds()
end

function unlock()
	unlocked = true
	myo.vibrate("short")
	myo.vibrate("short")
	extendunlock()
end

function lock()
	unlocked = false
	myo.vibrate("long")
end

function onPoseEdge(pose,edge)
	extendunlock()
	if pose == "fist" then
        if edge == "off" then
            unlock()
        elseif edge == "on" and not unlocked then
        	myo.vibrate("short")
           	myo.vibrate("short")
           	extendunlock()
        end
    end
	if pose == "waveIn" or pose == "waveOut" then
        local now = myo.getTimeMilliseconds()
        if unlocked and edge == "on" then
            lockwindows()
        end
    end
end

function onForegroundWindowChange(app, title)
    if string.match(title, title) then
		return true
	end
end
