Flight = Flight or {}

Flight.Keys = {
    forward = false,
    back = false,
    left = false,
    right = false,
    up = false,
    down = false,
    fast = false,
    slow = false
}

Flight.active = false
Flight.speed = 20

function Flight.log(str)
    System.LogAlways(string.format("$5[Flight] " .. str))
end

function Player:OnAction(action, activation, value)
    if action == "flight_toggle_keyboard" then
        Flight.active = not Flight.active

        if Flight.active then
            Flight.log("Flight on")
            player.soul:AddPerk("4cfff8f5-85ad-48d2-b8d1-e03fff06bc05")
            
        else
            Flight.log("Flight off")
        end

    elseif action == "flight_forward_keyboard" then
        if activation == "press" then
            Flight.Keys.forward = true
        else
            Flight.Keys.forward = false
        end

    elseif action == "flight_back_keyboard" then
        if activation == "press" then
            Flight.Keys.back = true
        else
            Flight.Keys.back = false
        end

    elseif action == "flight_left_keyboard" then
        if activation == "press" then
            Flight.Keys.left = true
        else
            Flight.Keys.left = false
        end

    elseif action == "flight_right_keyboard" then
        if activation == "press" then
            Flight.Keys.right = true
        else
            Flight.Keys.right = false
        end

    elseif action == "flight_up_keyboard" then
        if activation == "press" then
            Flight.Keys.up = true
        else
            Flight.Keys.up = false
        end

    elseif action == "flight_down_keyboard" then
        if activation == "press" then
            Flight.Keys.down = true
        else
            Flight.Keys.down = false
        end

    elseif action == "flight_fast_keyboard" then
        if activation == "press" then
            Flight.Keys.fast = true
        else
            Flight.Keys.fast = false
        end

    elseif action == "flight_slow_keyboard" then
        if activation == "press" then
            Flight.Keys.slow = true
        else
            Flight.Keys.slow = false
        end

    end
end

function Flight.Loop()
    if Flight.active then
        local basePos = player:GetPos()
        local dir = System.GetViewCameraDir()
        local move = {x = 0, y = 0, z = 0}
        local speed = Flight.speed * System.GetFrameTime()

        if Flight.Keys.fast then
            speed = speed * 7
        elseif Flight.Keys.slow then
            speed = speed * 0.2
        end

        if Flight.Keys.forward then
            move = VectorUtils.Sum(move, VectorUtils.Scale(dir, speed))
        end

        if Flight.Keys.back then
            move = VectorUtils.Sum(move, VectorUtils.Scale(VectorUtils.Negate(dir), speed))
        end

        if Flight.Keys.left then
            move = VectorUtils.Sum(move, VectorUtils.Scale(VectorUtils.Negate(VectorUtils.Rotate90AroundZ(dir)), speed))
        end

        if Flight.Keys.right then
            move = VectorUtils.Sum(move, VectorUtils.Scale(VectorUtils.Rotate90AroundZ(dir), speed))
        end

        if Flight.Keys.up then
            local up = {x = 0, y = 0, z = 1}
            move = VectorUtils.Sum(move, VectorUtils.Scale(up, speed))
        end

        local finalPos = {x = basePos.x + move.x,
                        y = basePos.y + move.y,
                        z = basePos.z + move.z + 0.00001}

        player:SetPos(finalPos)
        player:SetVelocity({x=0,y=0,z=0})
    end

    Script.SetTimerForFunction(5, "Flight.Loop")
end


function Flight:OnGameplayStarted()
    if ActionMapManager then
        ActionMapManager.EnableActionMap("flight_action", true)
    else
        Flight.log("Failed to load keybinds")
    end

    Flight.log("Ready")

    Flight.Loop()
end


UIAction.RegisterEventSystemListener(Flight, "", "OnGameplayStarted", "OnGameplayStarted")
