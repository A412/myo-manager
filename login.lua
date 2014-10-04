scriptId = 'com.cmv.login'

-- Backend Functions

function keyuse(key,action)
	--performs action on key
	myo.keyboard(key,action)

function keypress(key)
	--performs press on key
	keyaction(key,"press")
end

function keydown(key)
	--performs down on key
	keyaction(key,"down")
end

function keyup(key)
	--performs up on key
	keyaction(key,"up")
end

UNLOCKED_TIMEOUT = 5000

function extendunlock()
	--resets lock time to UNLOCKED_TIMEOUT
	unlockedSince = myo.getTimeMilliseconds()
end

function change_state(pose,edge)
	--sets program state based on pose and edge
	if pose == "fist" then
		if edge == "off" then
	        if unlocked then
	        	return lock()
	        end
	    	return unlock()
	    elseif edge == "on" and not unlocked then
	       	extendunlock()
		end
	end
end

function mouse(edge,pose)
	--sets the mouse's pose down or up based on the edge
	if edge == "on" then
		myo.mouse(pose,"down")
	else
		myo.mouse(pose,"up")
	end
end

function unlock()
	--unlocks the state
	unlocked = true
	extendunlock()
end

function lock()
	--locks the state
	unlocked = false
end

function buzz(num)
	--generates vibrations corresponding to state
	if num == 0 then
		myo.vibrate("long")
	else
		for vibration_num = 1,num,1 do
			myo.vibrate("short")
		end
	end
end

-- Interaction

state = 0

function onPoseEdge(pose,edge)
	extendunlock()
	change_state(pose,edge)
	buzz(state)
	if not state == 2 and myo.mouseControlEnabled() then
		myo.controlMouse(false)
	end
	if not state == 3 and alt_tab = true then
		alt_tab = false
		keyup("left_alt")
	end
	--state 0 is the locked state: no behavior is executed other than that of change_state
	if state == 1 then --main menu
		if edge == "off" then --only toggle on release
	        if pose == "fingersSpread" then
	        	state = 2
        	elseif pose == "waveIn"
        		state = 3
    		elseif pose == "waveOut"
    			state = 4
			else
				state = 5
			end
		end
	elseif state == 2 then --mousemode
       	if not myo.mouseControlEnabled() then --enable mouse iff it is disabled
			myo.controlMouse(true)
		end
		if pose == "waveIn" then
			mouse(edge,"left")
		elseif pose == "waveOut" then
			mouse(edge,"right")
		elseif pose == "fingersSpread" then
			mouse(edge,"center")
		end
	elseif state == 3 then --windows commands
		if pose == "fingersSpread" then
			if edge == "on" then
				alt_tab = true
				keydown("left_alt")
				last_yaw = myo.getYaw()
			else
				alt_tab = false
				keyup("left_alt")
			end
		end
	elseif state == 4 then --power options
    	if pose == "fingersSpread" then
    		keypress("f9")
		elseif pose == "waveIn" then
    		keypress("f10")
		elseif pose == "waveOut" then
    		keypress("f11")
		elseif pose == "thumbToPinky" then
    		keypress("f12")
		end
    elseif state == 5 then --custom binds
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