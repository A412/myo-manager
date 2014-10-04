scriptId = 'com.cmv.alttab'

function onPoseEdge(pose,edge)
	myo.keyboard("left_alt","down")
	myo.keyboard("tab","press")
	myo.keyboard("left_alt","up")
end

function onForegroundWindowChange(app, title)
    if string.match(title, title) then
		return true
	end
end
