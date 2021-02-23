param:set("TRIM_ARSPD_CM", 1800)
local flag = 0

airspd = param:get("TRIM_ARSPD_CM")
message = "Lua script is online, airspeed = " .. airspd
gcs:send_text(0, message)

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
				param:set("TRIM_ARSPD_CM", 2000)
			else
				param:set("TRIM_ARSPD_CM", 1700)
			end

		end
	end
	return airspeedStep, 100
end

return airspeedStep(), 100

