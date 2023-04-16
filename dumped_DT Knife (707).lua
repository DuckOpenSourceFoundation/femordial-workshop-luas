local clicked = 0
local dot = nil

local enabled    = menu.add_checkbox("Main", "Enabled")
local knife_bot  = menu.find("aimbot", "general", "misc", "knifebot")

local function get_distance(_start, _end)
    local distance = vec3_t(
        _start.x - _end.x,
        _start.y - _end.y,
        _start.z - _end.z
    ):length()

    if distance < 1.0 then distance = 1 end

    return distance
end

local function setup_cmd( cmd )
    if not enabled:get() then return end
    knife_bot:set(false)

    if clicked == 0 then
        if cmd:has_button(e_cmd_buttons.ATTACK) then
            if exploits.get_charge() < exploits.get_max_charge() then print("not enought") return end
            local lp = entity_list.get_local_player()
            local view = engine.get_view_angles():to_vector()
            local eyepos = lp:get_eye_position()

            dot = vec3_t(eyepos.x + view.x*80, eyepos.y + view.y*80, eyepos.z + view.z*80)

            local trace_result = trace.line(eyepos, dot, lp)
            if not (trace_result.entity ~= nil and trace_result.entity:get_class_id() == 40) then
                return
            end

            exploits.force_uncharge()
            exploits.block_recharge()
            print("uncharged")
            clicked = global_vars.tick_count()
        end
        return
    end

    local interval = global_vars.tick_count() - clicked

    if interval == exploits.get_max_charge() then 
        engine.execute_cmd("+attack")
    elseif interval == exploits.get_max_charge() + (20 - exploits.get_max_charge()) then
        engine.execute_cmd("-attack")
        exploits.allow_recharge()
    -- elseif interval > 17 and interval < 64 then
    --     engine.execute_cmd("+attack2")
    -- elseif interval > 64 then
    --     engine.execute_cmd("-attack2")
        clicked = 0
    end
end

-- local function on_paint()
--     if dot == nil then return end
--     local screen_pos = render.world_to_screen(dot)
--     if screen_pos ~= nil then render.rect(screen_pos, vec2_t(10, 10), color_t(255,0,0)) end
-- end

local function on_shutdown()
    knife_bot:set(true)
end

callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.SETUP_COMMAND, setup_cmd)
callbacks.add(e_callbacks.PAINT, on_paint)