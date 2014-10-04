scriptId = 'com.cmv.login'

--Backend Functions

function window_lock()
	myo.keyboard("f11","press")
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
		end
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
	change_state(pose,edge)
end

function window_

function onForegroundWindowChange(app, title)
    if string.match(title, title) then
		return true
	end
end
