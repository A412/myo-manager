scriptId = 'com.cmv.login'

function keypress(key)
	myo.keyboard(key,"press")
end

function lockwindows()
	--myo.keyboard("left_win","down")
	--myo.keyboard("win","down")
	--myo.keyb oard("l","press")
	--myo.keyboard("win","up")
	myo.keyboard("f11", "press")
	--myo.keyboard("left_win","up")
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
	if unlocked == true then
		if pose == "waveOut" then
			lockwindows()
		end
		if pose == "fist" then
			myo.keyboard("space","press")
		end
	end
	if unlocked == false and pose == "fist" then
		unlock()
	end
end

function onForegroundWindowChange(app, title)
    if string.match(title, title) then
		return true
	end
end
