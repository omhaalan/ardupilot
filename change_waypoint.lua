local stage = 0
sendNumb = 1

function change_waypoint()
    if mission:get_current_nav_index() < 2 then -- reset state when disarmed
        stage = 0
        if sendNumb == 1 then
            gcs:send_text(0, "At stage 0")
            sendNumb = 0
        end
    else
        if stage == 0 then
            sendNumb = 1
            stage = 1
        end
        if stage == 1 then
            gcs:send_text(0, "At stage 1")
            local wp_num = mission:num_commands()-1

            --Original number of waypoints
            message = "The number of original commands is " .. wp_num
            gcs:send_text(0, message)

            --Create modified mission
            m = mission:get_item(wp_num) -- Would be usefull to print out some info on this variable
            m2 = mission:get_item(wp_num-1)
            gcs:send_text(0, "The last way point has coordinates x:" .. m:x() .. ", y:" .. m:y() .. ", z:" .. m:z())

            m:y(2 * m:y() - m2:y())
            m:x(2 * m:x() - m2:x())
            m:z(m:z()+150)
            mission:set_item(wp_num+1,m)

            --The new number
            local wp_num = mission:num_commands()-1
            message = "The new number of commands is " .. wp_num
            gcs:send_text(0, message)
            
            --Study the last mission 
            m = mission:get_item(wp_num)
            gcs:send_text(0, "The last way point has coordinates x:" .. m:x() .. ", y:" .. m:y() .. ", z:" .. m:z())



            stage = 2
        end
    end
    return change_waypoint, 1000
end

return change_waypoint()
