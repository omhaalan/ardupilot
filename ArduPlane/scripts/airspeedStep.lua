local baseline = param:get("TRIM_ARSPD_CM")
local flag = 0
 

function airspeedStep()
	current = mission:get_current_nav_index()

	if current > 4 then
		if flag == 0 then
			prev = current
			flag = 1
		end
		if current ~= prev then
			prev = current
			flag = flag + 1
			message = "New speed has been set"
			gcs:send_text(0, message)
			if current % 2 == 0 then
				gain = flag * 0.1 * baseline
				param:set("TRIM_ARSPD_CM", baseline+gain)
			else
				param:set("TRIM_ARSPD_CM", baseline)
			end

		end
	end
	return airspeedStep, 100
end

return airspeedStep(), 100

