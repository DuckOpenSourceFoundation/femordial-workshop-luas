local slider_item = menu.add_slider("Primordial warning", "distance", 1, 200, 1)

function math.lerp(name, value, speed)
    return name + (value - name) * globals.frame_time() * speed
end

local screen_size = render.get_screen_size()
local default_font = render.get_default_font()

local anim = {}

callbacks.add(e_callbacks.PAINT, function()
    local button, color, color2 = unpack(menu.find("visuals", "esp", "items", "danger warning"))
    
    if not engine.is_in_game() then return end

    local grenades = {}
    local entities = {
        entity_list.get_entities_by_classid(9),
        entity_list.get_entities_by_classid(114),
        entity_list.get_entities_by_classid(100)
    }

    for i = 1, #entities do
        for j = 1, #entities[i] do
            table.insert(grenades, entities[i][j])
        end
    end

    for i = 1, #grenades do
        local entity = grenades[i]

        local thrower = entity:get_prop("m_hOwnerEntity")
        --local vec_origin = entity:get_prop("m_vecOrigin")
        local vec_origin = entity:get_render_origin(entity)
        local molotov_time = 0

        if entity:get_class_id() == 100 then
            local molotov_tick = entity:get_prop("m_nFireEffectTickBegin")
            molotov_time = 7.03125 - globals.interval_per_tick() * (globals.tick_count() - molotov_tick)
        end
        
        local local_player = entity_list.get_local_player()
        local origin = local_player:get_render_origin()

        local screen_pos = render.world_to_screen(vec3_t(vec_origin.x, vec_origin.y, vec_origin.z))
        if screen_pos == nil then return end

        local distance = math.floor(vec_origin:dist(origin) / 12)

        if distance > slider_item:get() then
            alpha = 0
        else 
            alpha = 255 / 255
        end

        render.push_alpha_modifier(alpha)

        render.rect_filled(vec2_t(screen_pos.x - 30, screen_pos.y - 30), vec2_t(60, 60), color_t(0, 0, 0, 70), 10)

        if entity:get_class_id() == 100 then
            render.push_clip(vec2_t(0, screen_pos.y - 30 + (60 * ((7.03125 - molotov_time) / 7.03125))), vec2_t(screen_size.x, screen_size.y))
        end
        render.rect(vec2_t(screen_pos.x - 30, screen_pos.y - 30), vec2_t(60, 60), color:get(), 10)
        render.pop_clip()

        if entity:get_class_id() == 100 then
            render.weapon_icon(e_items.WEAPON_MOLOTOV, vec2_t(screen_pos.x, screen_pos.y - 10), color:get(), true)
        end
        if entity:get_class_id() == 114 then
            render.weapon_icon(e_items.WEAPON_MOLOTOV, vec2_t(screen_pos.x, screen_pos.y - 10), color:get(), true)
        end
        if entity:get_class_id() == 9 then
            render.weapon_icon(e_items.WEAPON_HEGRENADE, vec2_t(screen_pos.x, screen_pos.y - 10), color:get(), true)
        end
        render.text(default_font, distance .. "ft", vec2_t(screen_pos.x, screen_pos.y + 16), color_t(255, 255, 255), true)

        render.pop_alpha_modifier()
    end
end)