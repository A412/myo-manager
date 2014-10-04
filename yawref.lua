scriptId = 'com.cmv.yawTest'

function onPeriodic()
	myo.debug(myo.getYaw())
end

function onPoseEdge(pose,edge)
	if pose =="fist" then
		if edge == "on" then
			yawRef = myo.getYaw()
			monitorYaw = true
		else
			yawFinish = myo.getYaw()
			monitorYaw = false
			if (yawFinish - yawRef) > 0 then
				myo.debug("Yaw went up!")
			end
		end
	end
end

function onForegroundWindowChange(app, title)
    return true
end
