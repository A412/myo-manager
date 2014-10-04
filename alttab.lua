function onPoseEdge(pose,edge)
	myo.keyboard("tab","press")
end

function onForegroundWindowChange(app, title)
    if string.match(title, title) then
    	myo.keyboard("alt","down")
		return true
	end
end
