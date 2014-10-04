scriptId = 'com.cmv.login'

--Backend Functions

function keyuse(key,action) --performs action on key
	myo.keyboard(key,action)
end

function keyusemod(key,action,mod) --performs action of key with mod
	myo.keyboard(key,action,mod)
end

function keypress(key) --performs press on key
	keyaction(key,"press")
end

function keypressmod(key,mod) --performs press on key with mod
	keyaction(key,"press",mod)
end

function keydown(key) --performs down on key
	keyaction(key,"down")
end
  
function keydownmod(key,mod) --performs down on key with mod
	keyaction(key,"down", mod)
end

function keyup(key) --performs up on key
	keyaction(key,"up")
end

function keyupmod(key,mod) --performs up on key
	keyaction(key,"up", mod)
end

UNLOCKED_TIMEOUT = 5000 --time in ms before lock

function extendunlock() --resets lock time to UNLOCKED_TIMEOUT
	unlockedSince = myo.getTimeMilliseconds()
end

function change_state(pose,edge) -- sets program state based on pose and edge
	-- returns whether or not the state changed
	if pose == "fist" then
		if edge == "off" then
	        if unlocked then
	        	lock()
	        	return true
	        end
	    	unlock()
	    	return true
	    elseif edge == "on" and not unlocked then
	       	extendunlock()
		end
	end
	return false
end

function mouse(edge,pose) --sets the mouse's pose down or up based on the edge
	if edge == "on" then
		myo.mouse(pose,"down")
	else
		myo.mouse(pose,"up")
	end
end

function unlock() --unlocks the state
	state = 1
	extendunlock()
end

function lock() --locks the state
	state = 0
end

function buzz(num) --generates vibrations corresponding to state
	if num == 0 then
		myo.vibrate("long") --one long vibration for state 0
	else
		for vibration_num = 1,num,1 do
			myo.vibrate("short") --n short vibrations for state n>0
		end
	end
end

-- Interaction

state = 0 --state indicates which state the program is in
--0:lock, 1:menu, 2:mouse, 3:commands, 4: power, 5: custom binds

function onPoseEdge(pose,edge) --fires on gesture
	extendunlock()
	if change_state(pose,edge) then --FIST TOGGLES LOCK
		buzz(state) --only executes if state changes
	end
	if not state == 2 and myo.mouseControlEnabled() then --Turns mousemode off if state 2 exits
		myo.controlMouse(false)
	end
	--state 0 is the locked state: no behavior is executed other than that of change_state
	if state == 1 then --main menu
		if edge == "off" then --only toggle on release
	        if pose == "fingersSpread" then
	        	state = 2
        	elseif pose == "waveIn" then
        		state = 3
    		elseif pose == "waveOut" then
    			state = 4
			else
				state = 5
			end
		end
	elseif state == 2 then --mousemode
       	if not myo.mouseControlEnabled() then --enable mouse iff it is disabled
			myo.controlMouse(true)
		end
		if pose == "fingersSpread" then
			mouse(edge,"center") --MMB
		elseif pose == "waveIn" then
			mouse(edge,"left") --LMB
		elseif pose == "waveOut" then
			mouse(edge,"right") --RMB
		else
			myo.centerMousePosition() --mouse to screen center
		end
	elseif state == 3 then --windows commands
		if pose == "fingersSpread" then --alt-tab mode: holds down alt and stores yaw in last_yaw (this is really awkward)
			if edge == "on" then
				alt_tab = true
				keydown("left_alt")
				last_yaw = myo.getYaw()
			else
				alt_tab = false
				keyup("left_alt")
				state = 0
			end
		else
			if pose == "waveOut" then
				keypress("left_win") --hits windows key
			elseif pose == "waveIn" then
				keypressmod(d,"win") --hits windows+d to show desktop
			else
				keypressmod(f4,"alt") --closes window with alt+f4
			end
			state = 0
		end
	elseif state == 4 then --power options
    	if pose == "fingersSpread" then
    		keypress("f9") --hibernate (this is really awkward)
		elseif pose == "waveIn" then
    		keypress("f10") --shutdown
		elseif pose == "waveOut" then
    		keypress("f11") --restart
		else
    		keypress("f12") --lock
		end
		state = 0
    elseif state == 5 then --custom binds
    	if pose == "fingersSpread" then
    		keypress("f13")
		elseif pose == "waveIn" then
    		keypress("f14")
		elseif pose == "waveOut" then
    		keypress("f15")
		else
    		keypress("f16")
		end
		state = 0
    end
end

function onPeriodic()
	alt_tab()
	if myo.mouseControlEnabled() then --extends time before lock if in mousemode
		extendunlock()
	end
	if unlocked then
        if myo.getTimeMilliseconds() - unlockedSince > UNLOCKED_TIMEOUT then --locks if more than UNLOCKED_TIMEOUT passes
            state = 0
        end
    end
end

function alt_tab() --fires if in alt-tab mode
	if alt_tab then
		extendunlock()
		new_yaw = myo.getYaw()
		if new_yaw - last_yaw >= 0.2 then --number in radians is the angle change in yaw required to tab
			keypress("tab")
			last_yaw = new_yaw --updates the yaw value
		end
	end
end

function onForegroundWindowChange(app, title)
    if string.match(title, title) then
		return true
	end
end