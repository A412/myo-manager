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

function cycle_state()
	state_index=state_index + 1
	if state_index > #state_list then
		state_index=1
	end
	state = state_list[state_index]
	buzz()
end

function change_state(pose,edge) -- sets program state based on pose and edge
	-- returns whether or not the state changed
	if state[pose] then
		if edge == "off" then
			state[pose]()
		elseif edge == "on" and state_index>1 then
	       	extendunlock()
	    end
	end
end

function mouse(edge,pose) --sets the mouse's pose down or up based on the edge
	if edge == "on" then
		myo.mouse(pose,"down")
	else
		myo.mouse(pose,"up")
	end
end


function buzz() --generates vibrations corresponding to state
	if state_index== 1 then
		myo.vibrate("long") --one long vibration for state 0
	else
		for _ = 1,state_index,1 do
			myo.vibrate("short") --n short vibrations for state n>0
		end
	end
end

-- Interaction

state_index = 1 --state indicates which state the program is in
--0:lock, 1:menu, 2:mouse, 3:commands, 4: power, 5: custom binds


function states_init()
	locked={["fist"]= cycle_state}
	unlocked={["fist"]= cycle_state, ["waveIn"]= window_lock}
	mouse={["fist"]= cycle_state}
	state_list={locked, unlocked, mouse}
	state=state_list[state_index]
end

states_init()


function onPoseEdge(pose,edge) --fires on gesture
	extendunlock()
	
	change_state(pose,edge)
	
end


function window_lock()
	myo.keyboard("f12", "press")
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
