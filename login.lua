scriptId = 'com.cmv.login'

-- Backend Functions

function keyuse(key,action)
	myo.keyboard(key,action)

function keypress(key)
	keyaction(key,"press")
end

function keydown(key)
	keyaction(key,"down")
end

function keyup(key)
	keyaction(key,"up")
end

UNLOCKED_TIMEOUT = 5000

function extendunlock()
	unlockedSince = myo.getTimeMilliseconds()
end

function change_state()
	if unlocked then
		return lock()
	return unlock()
	end
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

-- Interaction

function onPoseEdge(pose,edge)
	extendunlock()
	if pose == "fist" then
        if edge == "off" then
            change_state()
        elseif edge == "on" and not unlocked then
        	myo.vibrate("short")
           	myo.vibrate("short")
           	extendunlock()
        end
    elseif not myo.mouseControlEnabled() then
		if pose == "thumbToPinky" then
	        if unlocked and edge == "on" then
	            keypress("f11")
	        end
	    elseif pose == "waveIn" then
	    	if unlocked then
	    		if edge == "on" then
	    			alt_tab = true
	    			keydown("left_alt")
	    			last_yaw = myo.getYaw()
				else
					alt_tab = false
					keyup("left_alt")
				end
			end
		elseif pose == "waveOut" and unlocked and edge == "on" then
			myo.controlMouse(true)
			myo.vibrate("short")
		end
	else
		if pose == "waveOut" and unlocked and edge == "on" then
			myo.controlMouse(false)
			myo.vibrate("short")
			myo.vibrate("short")
		elseif pose == "waveIn" and unlocked then
			if edge = "on" then
				myo.mouse("left","down")
			else
				myo.mouse("left","up")
			end
		elseif pose == "thumbToPinky" and unlocked then
			if edge = "on" then
				myo.mouse("right","down")
			else
				myo.mouse("right","up")
			end
		elseif pose == "fingersSpread" and unlocked then
			if edge = "on" then
				myo.mouse("center","down")
			else
				myo.mouse("center","up")
			end
		end
	end
end

function onPeriodic()
	alt_tab()
	if myo.mouseControlEnabled() then
		extendunlock()
	end
	if unlocked then
        if myo.getTimeMilliseconds() - unlockedSince > UNLOCKED_TIMEOUT then
            unlocked = false
        end
    end
end

function alt_tab()
	if alt_tab then
		extendunlock()
		new_yaw = myo.getYaw()
		if new_yaw - last_yaw >= 0.2 then
			keypress("tab")
			last_yaw = new_yaw
		end
	end
end

function onForegroundWindowChange(app, title)
    if string.match(title, title) then
		return true
	end
end
