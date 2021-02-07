local baseline = param:get("TRIM_ARSPD_CM")
local flag = 0
 

function airspeedStep()
	current = mission:get_current_nav_index()

	if current > 4 then
		if flag == 0
			prev = current
			flag = 1
		end
		if current ~= prev then
			prev = current
			gain = flag * 0.1 * baseline
			flag = flag + 1
			param:set("TRIM_ARSPD_CM", baseline+gain)
		end
	end
	return airspeedStep, 100
end

return airspeedStep(), 100

