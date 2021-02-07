

local stage = 0 
local baseline = param:get("TRIM_ARSPD_CM")
local time = 0

local omega_1 = 1.2
local omega_2 = 0.5
local omega_3 = 0.05
local amplitude = 0.1 * baseline
local amplitude2 = 0.3 * baseline


local step = 0.01
local maxError = math.sin(omega_1 * step)
local flag = 0


function change_airspeed()
    if mission:get_current_nav_index() >=  10 then --Set to 2 to activate program

        if math.sin(omega_2 * time) > 0 and (math.cos(omega_2 * time) > 0) then -- and (math.cos(omega_2 * time + 0.4) > 0)  then  -- best so far 0.4
            sign = 1
        else
            if sign == 1 then
                message = "The new baseline will now be " .. (baseline - sign * amplitude2)
                gcs:send_text(0, message)
            end
            sign = -1
        end

        if math.sin(omega_1*time) > 0 and math.cos(omega_1*time) > 0 then
            sign2 = 1
        else
            sign2 = 0
        end

        
        -- *math.sin(omega_1 * (time))

        oscillator = amplitude * sign2  + sign * amplitude2 -- * math.sin(omega_2 * time)--   + amplitude * math.sin(omega_3 * time) Using minus - sign ... gave a very nice signal and hig PE

        -- current best: omega_2 = 0.3, amp2 = 0.4 base, second omega shift 0.4
        
        signal = baseline + oscillator
        param:set("TRIM_ARSPD_CM", signal)

        --if omega_1 * (time + step) >= (2 * math.pi) then
        --    if math.abs(oscillator) <= maxError then
        --        omega_1 = omega_1 + 0.2
        --        time = 0
        --        maxError = math.sin(omega_1 * step)
        --        -- Todo: print out some usefull updates
        --        message = "New omega_1 is given by " .. omega_1 .. "and current signal is " .. signal
        --        gcs:send_text(0, message)
        --    end
        --else
        time = time + step
    elseif mission:get_current_nav_index() == 1 and stage == 0 then
        -- param:set("TRIM_ARSPD_CM", baseline)
        stage = 1
        message = "The baseline is " .. baseline
        gcs:send_text(0, message)
        message = "The amplitude is " .. amplitude .. " and om " .. omega_1
        gcs:send_text(0, message)
    end
    return change_airspeed, 10
end

return change_airspeed(), 10
