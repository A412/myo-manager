scriptId = 'com.cmv.loginlist'
mouse = false
--Backend Functions

function window_lock()
	myo.keyboard("f11","press")
end

function close_window()
	myo.keyboard("f4","press","alt")
end

function change_tab()
	myo.keyboard("tab","press","control")
end

function is_chrome(val)
	if not state_index == 0
		if not state_index == 3
			state = 5
		end
	end
	state = state_list[state_index]
	buzz()
end

function new_tab()
	myo.keyboard("t","press","control")
end

current_tab = 1
tabs = {[1]="1",[2]="2",[3]="3",[4]="4",[5]="5",[6]="6",[7]="7",[8]="8",[9]="9"}

function tab_iterate()
	myo.keyboard(tabs[current_tab],"press","control")
	current_tab = current_tab + 1
	if current_tab > 9 then
		current_tab = 1
	end
end

function close_tab()
	myo.keyboard("w","press","control")
end

function cycle_state()
	state_index=state_index + 1
	if state_index > #state_list then
		state_index=1
	end
	state = state_list[state_index]
	buzz()
end

function mouse_off()
	mouse = false
	myo.controlMouse(mouse)
	cycle_state()
end

function left_click()
	while edge=="on" do
		myo.mouse("left","down")
	end	
	myo.mouse("left","up")
	
end

function right_click()
	if edge=="on" then
		myo.mouse("right","down")
	else
		myo.mouse("right","up")
	end
end

function toggle_mouse()
	mouse = not mouse
	myo.controlMouse(mouse)
end

function change_state(pose,edge) -- sets program state based on pose and edge
	-- returns whether or not the state changed
	if state[pose] then
		if edge == "on" then
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
	unlocked={["fist"]= cycle_state, ["waveIn"]= window_lock, ["waveOut"] = close_window, ["fingersSpread"] = change_tab}
	mouse={["fist"]= mouse_off,["thumbToPinky"]=left_click,["waveOut"]=right_click,["fingersSpread"]=toggle_mouse}
	browser={["fist"]= cycle_state,["waveIn"]= new_tab,["waveOut"]= tab_iterate,["fingersSpread"]=close_tab}
	state_list={locked, unlocked, mouse, browser}
	state=state_list[state_index]
end

states_init()

function onPoseEdge(pose,edge) --fires on gesture
	change_state(pose,edge)
end

function onForegroundWindowChange(app, title)
	if string.match(title, "Google Chrome") then
		is_chrome(true)
	else
		is_chrome(false)
	end
	return true
end
