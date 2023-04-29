-- Define variables for menu position and button size
local esp_names = render.create_font("Verdanab", 5, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local main_font = render.create_font("Verdanab", 11, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local menu_font = render.create_font("Courierr", 16, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local accent_color = menu.find("misc", "main", "Personalization", "accent color")
--
local sub_font = render.create_font("Verdana", 10, 200, e_font_flags.DROPSHADOW)
local health_esp = menu.add_checkbox("esp", "Health")
local health_color = health_esp:add_color_picker("healthcolor", color_t(123, 255, 123, 255))
local box_esp = menu.add_checkbox("esp", "Boxes")
local box_color = box_esp:add_color_picker("box color")
local ammo_esp = menu.add_checkbox("esp", "ammo")
local ammo_color = ammo_esp:add_color_picker("ammo color", color_t(123, 123, 255, 255))
local name_esp = menu.add_checkbox("esp", "names")
local name_color = name_esp:add_color_picker("name color")
local menuszi = vec2_t(600, 500)
local mainDCpos = vec2_t(0, 0)
local espDCpos = vec2_t(0, 0)
local health_selec_pos = 5
local name_selec_pos = 4
local ammo_selec_pos = 5
local flags_selec_pos = 4
local drop_positions = {{
      pos = vec2_t(0, 45),
      size = vec2_t(46, 235)
  }, {
      pos = vec2_t(50, 0),
      size = vec2_t(106, 42)
  }, {
      pos = vec2_t(160, 45),
      size = vec2_t(45, 235)
  }, {
      pos = vec2_t(50, 284),
      size = vec2_t(106, 40)
  }, {
      pos = vec2_t(338, 195),
      size = vec2_t(120, 100)
  }}
local p_c = 0
local first_color = color_t(0, 0, 0, 0)
local last_color = color_t(0, 0, 0, 0)
local side = false
local stable_ammo = {
  textsize = render.get_text_size(main_font, "ammo"),
  positions = {
    {
      pos = vec2_t(45, 45),
      size = vec2_t(3, 237)
    },
    {
      pos = vec2_t(50, 40),
      size = vec2_t(110, 3)
    },
    {
      pos = vec2_t(162, 45),
      size = vec2_t(3, 237)
    },
    {
      pos = vec2_t(50, 285),
      size = vec2_t(110, 3)
    },
    {
      pos = vec2_t(340, 200),
      size = vec2_t(render.get_text_size(main_font, "ammo").x, 8)
    }
  },
  drop_positions = {
    {
      pos = vec2_t(5, 40),
      size = vec2_t(45, 250)
    },
    {
      pos = vec2_t(50, 5),
      size = vec2_t(110, 40)
    },
    {
      pos = vec2_t(160, 40),
      size = vec2_t(45, 250)
    },
    {
      pos = vec2_t(50, 285),
      size = vec2_t(110, 40)
    },
    {
      pos = vec2_t(338, 195),
      size = vec2_t(120, 100)
    }
  },

  held = false,
  hovered_position = 0,
  drag_offset = 0,
  pressed = false,
  off_set = vec2_t(0, 0),
  off_set_negative = false,
  inside_cond = 0 
}
local ammo_pos = stable_ammo.positions[1].pos
local ammo_size_pos = stable_ammo.positions[1].size
local stable_health = {
  textsize = render.get_text_size(main_font, "health"),
  positions = {
    {
      pos = vec2_t(45, 45),
      size = vec2_t(3, 237)
    },
    {
      pos = vec2_t(50, 40),
      size = vec2_t(110, 3)
    },
    {
      pos = vec2_t(162, 45),
      size = vec2_t(3, 237)
    },
    {
      pos = vec2_t(50, 285),
      size = vec2_t(110, 3)
    },
    {
      pos = vec2_t(340, 200),
      size = vec2_t(render.get_text_size(main_font, "health").x, 8)
    }
  },
  drop_positions = {
    {
      pos = vec2_t(5, 40),
      size = vec2_t(45, 250)
    },
    {
      pos = vec2_t(50, 5),
      size = vec2_t(110, 40)
    },
    {
      pos = vec2_t(160, 40),
      size = vec2_t(45, 250)
    },
    {
      pos = vec2_t(50, 285),
      size = vec2_t(110, 40)
    },
    {
      pos = vec2_t(338, 195),
      size = vec2_t(120, 100)
    }
  },

  held = false,
  hovered_position = 0,
  drag_offset = 0,
  pressed = false,
  off_set = vec2_t(0, 0),
  off_set_negative = false,
}
local health_pos = stable_health.positions[1].pos
local health_size_pos = stable_health.positions[1].size
local stable_name = {
  textsize = render.get_text_size(main_font, "name"),
  positions = {
    {
      pos = vec2_t(20, 50),
      size = vec2_t(render.get_text_size(main_font, "name").x, 8)
    },
    {
        pos = vec2_t(90, 35),
      size = vec2_t(render.get_text_size(main_font, "name").x, 8)
    },
    {
        pos = vec2_t(160, 50),
      size = vec2_t(render.get_text_size(main_font, "name").x, 8)
    },
    {
      pos = vec2_t(340, 200),
      size = vec2_t(render.get_text_size(main_font, "name").x, 8)
    }
  },
  drop_positions = {
    {
      pos = vec2_t(5, 40),
      size = vec2_t(45, 250)
    },
    {
      pos = vec2_t(50, 5),
      size = vec2_t(110, 40)
    },
    {
      pos = vec2_t(160, 40),
      size = vec2_t(45, 250)
    },
    {
      pos = vec2_t(338, 195),
      size = vec2_t(120, 100)
    }
  },

  held = false,
  hovered_position = 0,
  drag_offset = 0,
  pressed = false,
  off_set = vec2_t(0, 0),
  off_set_negative = false,
  inside_cond = 0
}
local name_pos = stable_name.positions[1].pos
local name_size_pos = stable_name.positions[1].size
local stable_flags = {
  textsize = render.get_text_size(main_font, "flags"),
  positions = {
    {
      pos = vec2_t(20, 50),
      size = vec2_t(render.get_text_size(main_font, "flags").x, 8)
    },
    {
      pos = vec2_t(160, 50),
      size = vec2_t(render.get_text_size(main_font, "flags").x, 8)
    },
    {
      pos = vec2_t(90, 285),
      size = vec2_t(render.get_text_size(main_font, "flags").x, 8)
    },
    {
      pos = vec2_t(340, 200),
      size = vec2_t(render.get_text_size(main_font, "flags").x, 8)
    }
  },
  drop_positions = {
    {
      pos = vec2_t(0, 45),
      size = vec2_t(46, 235)
    },
    {
      pos = vec2_t(160, 45),
      size = vec2_t(45, 235)
    },
    {
      pos = vec2_t(50, 284),
      size = vec2_t(106, 40)
    },
    {
      pos = vec2_t(338, 195),
      size = vec2_t(120, 100)
    }
  },

  held = false,
  hovered_position = 0,
  drag_offset = 0,
  pressed = false,
  off_set = vec2_t(0, 0),
  off_set_negative = false,
  side_offset =  false
}
local flags_pos = stable_flags.positions[1].pos
local flags_size_pos = stable_flags.positions[1].size
local last_positions = {}
local list_flags =  {"armor", "scoped", "money", "flashed", "shot", "distance", "defusing"}
local selected_indices = {}
local function switch(value)
    return function(cases)
        local f = cases[value]
        if (f) then
            f()
        end
    end
end
local function contains(table, element)
  for _, value in pairs(table) do
      if value == element then
          return true
      end
  end
  return false
end
local function index_of(table, element)
  for index, value in pairs(table) do
      if value == element then
          return index
      end
  end
  return nil
end
local function listbox(pos, size, items)
 
  for i, item in ipairs(items) do
      local item_pos = vec2_t(pos.x, pos.y + (i - 1) * 20)
      local item_size = vec2_t(size.x, 20)
      local is_selected = contains(selected_indices, i)
      local item_color = color_t(150, 150, 150)
      local item_text_color = is_selected and accent_color[2]:get() or input.is_mouse_in_bounds(item_pos, item_size) and color_t(255, 255, 255) or color_t(132, 132, 132)
     
      
      render.text(main_font, item, item_pos + vec2_t(3, 3), item_text_color)
      if input.is_mouse_in_bounds(item_pos, item_size) and input.is_key_released(e_keys.MOUSE_LEFT) then
          if is_selected then
              table.remove(selected_indices, index_of(selected_indices, i))
          else
              table.insert(selected_indices, i)
          end
      end
  end

  return selected_indices
end

local function checkbox(label, pos, size, cfg)
    local posx = pos + vec2_t(8, 8)
    local sizex = size - vec2_t(8, 8)
    local color = input.is_mouse_in_bounds(posx, sizex) and color_t(52, 52, 52) or color_t(40, 40, 40)
    local colors = input.is_mouse_in_bounds(posx, sizex) and color_t(170, 170, 170) or color_t(132, 132, 132)
    render.rect_filled(posx - vec2_t(1, 1), sizex + vec2_t(2, 2), color, 3)

    render.rect_filled(posx, sizex, color_t(29, 29, 29), 3)

    if cfg then
        render.rect_filled(posx + vec2_t(1, 1), sizex - vec2_t(2, 2), color_t(250, 189, 255, 255), 3)
    end

    local text_size = render.get_text_size(main_font, label)
    render.text(main_font, label, vec2_t(pos.x + size.x + 5, pos.y + size.y / 2 - text_size.y / 2 + 3), colors)

    if input.is_mouse_in_bounds(pos, size) and input.is_key_released(e_keys.MOUSE_LEFT) then
        cfg = not cfg
        return cfg
    end

    return cfg
end
local function get_alpha(selected)
    if selected then
        return 80
    else
      local  p = math.sin(math.abs(-math.pi + (global_vars.real_time() * (1 / 1)) % (math.pi * 2))) * 20;
      p_c = math.floor(p)
        return p_c
    end

end
local function bounds(number,name,flags)

    local anim_value = math.sin(math.abs(-math.pi + (global_vars.real_time() * (1 / 0.5)) % (math.pi * 2))) * 150;
    local love = math.floor(anim_value)
    local animated_color = color_t(love, love, love, 80)
    -- draw the four rectangles
    for i = 1, 5 do
        local is_selected = i == number
        local alpha = get_alpha(is_selected)
        if name and i == 4 then 
          i = 5
        end


            
        if i == 1 or i == 3 then
            side = true
        else
            side = false
        end

        if i == 1 or i == 2 then
            first_color = color_t(0, 0, 0, 0)
            last_color = color_t(255, 255, 255, alpha)
        else
            first_color = color_t(255, 255, 255, alpha)
            last_color = color_t(0, 0, 0, 0)
        end
        if flags then 
          if i == 5 then 
            i = 4
          end
          if i == 1 or  i == 2 then
            side = true
        else
            side = false
        end
        if  i == 2 then
          first_color = color_t(255, 255, 255, alpha)
          last_color = color_t(0, 0, 0, 0)
        end
  
          render.rect_fade(espDCpos + stable_flags.drop_positions[i].pos, stable_flags.drop_positions[i].size + vec2_t(4, 4), first_color,
          last_color, side)
        else
          render.rect_fade(espDCpos + drop_positions[i].pos, drop_positions[i].size + vec2_t(4, 4), first_color,
          last_color, side)
        end

    end

    render.rect(espDCpos + vec2_t(50, 45), vec2_t(110, 239), color_t(255, 255, 255, 255))
end
local function button(pos, active)
  if active then
      return
  end
  if input.is_mouse_in_bounds(pos, vec2_t(20, 10)) and input.is_key_held(e_keys.MOUSE_LEFT) and isheld == false then
      pos = input.get_mouse_pos()
      isheld = true
  end

  if isheld and input.is_key_held(e_keys.MOUSE_LEFT) then
      pos = input.get_mouse_pos()
  else
      isheld = false
  end

  render.rect_filled(pos, vec2_t(30, 20), health_color:get(), 3)
end
---------- thx for the usage .....
local function get_pos(player)
  local min = player:get_prop("m_vecMins")
  local max = player:get_prop("m_vecMaxs")
  local pos = player:get_render_origin() -- collideable + pos

  if min == nil or max == nil or pos == nil then
      return
  end

  local mpoints = {vec3_t(min.x, min.y, min.z), vec3_t(min.x, max.y, min.z), vec3_t(max.x, max.y, min.z),
                   vec3_t(max.x, min.y, min.z), vec3_t(max.x, max.y, max.z), vec3_t(min.x, max.y, max.z),
                   vec3_t(min.x, min.y, max.z), vec3_t(max.x, min.y, max.z)}

  local points = {pos + mpoints[1], pos + mpoints[2], pos + mpoints[3], pos + mpoints[4], pos + mpoints[5],
                  pos + mpoints[6], pos + mpoints[7], pos + mpoints[8]}

  local screen_points = {}

  for i = 1, 8, 1 do
      -- debug_overlay.add_sphere(points[i], 4, 10, 10, color_t(255,255,255,255), 0.1)
      screen_points[i] = render.world_to_screen(points[i])
  end
  if screen_points[1] == nil then
      return
  end
  local left = screen_points[1].x
  local bot = screen_points[1].y
  for i = 1, 8, 1 do
      if screen_points[i] == nil then
          return
      end

      if left > screen_points[i].x then
          left = screen_points[i].x
      end
      if bot < screen_points[i].y then
          bot = screen_points[i].y
      end
  end
  return vec2_t(left, bot)
end
local function get_size(player)
  local min = player:get_prop("m_vecMins")
  local max = player:get_prop("m_vecMaxs")
  local pos = player:get_render_origin() -- collideable + pos

  if min == nil or max == nil or pos == nil then
      return
  end

  local mpoints = {vec3_t(min.x, min.y, min.z), vec3_t(min.x, max.y, min.z), vec3_t(max.x, max.y, min.z),
                   vec3_t(max.x, min.y, min.z), vec3_t(max.x, max.y, max.z), vec3_t(min.x, max.y, max.z),
                   vec3_t(min.x, min.y, max.z), vec3_t(max.x, min.y, max.z)}

  local points = {pos + mpoints[1], pos + mpoints[2], pos + mpoints[3], pos + mpoints[4], pos + mpoints[5],
                  pos + mpoints[6], pos + mpoints[7], pos + mpoints[8]}

  local screen_points = {}

  for i = 1, 8, 1 do
      -- debug_overlay.add_sphere(points[i], 4, 10, 10, color_t(255,255,255,255), 0.1)
      screen_points[i] = render.world_to_screen(points[i])
  end
  if screen_points[1] == nil then
      return
  end
  local left = screen_points[1].x
  local bot = screen_points[1].y
  local right = screen_points[1].x
  local top = screen_points[1].y
  for i = 1, 8, 1 do
      if screen_points[i] == nil then
          return
      end

      if left > screen_points[i].x then
          left = screen_points[i].x
      end
      if bot < screen_points[i].y then
          bot = screen_points[i].y
      end
      if right < screen_points[i].x then
          right = screen_points[i].x
      end
      if top > screen_points[i].y then
          top = screen_points[i].y
      end
  end

  return vec2_t(right - left, bot - top)
end
--------------------------
local function ammo()

  if ammo_selec_pos == 5 then 
    ammo_pos = stable_ammo.positions[5].pos
    ammo_size_pos = stable_ammo.positions[5].size

  end
    if health_selec_pos == 1 and health_selec_pos == ammo_selec_pos  then
      stable_ammo.inside_cond = 1
      stable_ammo.off_set_negative = false
      stable_ammo.off_set = vec2_t(10, 0)
    elseif health_selec_pos == 2 and health_selec_pos == ammo_selec_pos  then
      stable_ammo.inside_cond = 1
      stable_ammo.off_set_negative = false
      stable_ammo.off_set = vec2_t(0, 10)
    elseif health_selec_pos == 3 and health_selec_pos == ammo_selec_pos  then
      stable_ammo.inside_cond = 1
      stable_ammo.off_set_negative = true
      stable_ammo.off_set = vec2_t(10, 0)
    elseif health_selec_pos == 4 and health_selec_pos == ammo_selec_pos  then
      stable_ammo.inside_cond = 1
      stable_ammo.off_set_negative = true
      stable_ammo.off_set = vec2_t(0, 10)
    elseif health_selec_pos == 5 and health_selec_pos == ammo_selec_pos  then
      stable_ammo.off_set_negative = true
      stable_ammo.off_set = vec2_t(stable_ammo.textsize.x * 2 /1.2 +1, 0)
   
    else
      stable_ammo.inside_cond = 0
      stable_ammo.off_set = vec2_t(0, 0)
    end

    local p = math.sin(math.abs(-math.pi + (global_vars.real_time() * (1 / 0.5)) % (math.pi * 2))) * 255;
    local p_c = math.floor(p)
    local side_ammo = math.sin(math.abs(-math.pi + (global_vars.real_time() * (1 / 1.5)) % (math.pi * 2))) * 110;
    local side_ammo_px = math.floor(side_ammo)
    local vertical_ammo = math.sin(math.abs(-math.pi + (global_vars.real_time() * (1 / 1.5)) % (math.pi * 2))) * 237;
    local vertical_ammo_px = math.floor(vertical_ammo)
    -- Check if the mouse button was pressed inside the bounds

    if not stable_ammo.off_set_negative and input.is_mouse_in_bounds(espDCpos + ammo_pos - stable_ammo.off_set, ammo_size_pos) and
        input.is_key_pressed(e_keys.MOUSE_LEFT) then
          stable_ammo.pressed = true
    elseif stable_ammo.off_set_negative and input.is_mouse_in_bounds(espDCpos + ammo_pos + stable_ammo.off_set, ammo_size_pos) and
        input.is_key_pressed(e_keys.MOUSE_LEFT) then
          stable_ammo.pressed = true
    elseif stable_ammo.off_set_negative and input.is_key_pressed(e_keys.MOUSE_LEFT) and
        not input.is_mouse_in_bounds(espDCpos + ammo_pos + stable_ammo.off_set, ammo_size_pos) then
          stable_ammo.pressed = false
    elseif not stable_ammo.off_set_negative and input.is_key_pressed(e_keys.MOUSE_LEFT) and
        not input.is_mouse_in_bounds(espDCpos + ammo_pos - stable_ammo.off_set, ammo_size_pos) then
          stable_ammo.pressed = false
    elseif input.is_key_released(e_keys.MOUSE_LEFT) then
      stable_ammo.pressed = false
    end

    for i, p in ipairs(stable_ammo.drop_positions) do
        if stable_ammo.off_set_negative then
            if input.is_mouse_in_bounds(espDCpos + p.pos , p.size) then
              stable_ammo.hovered_position = i
                break
            end
        else
            if input.is_mouse_in_bounds(espDCpos + p.pos , p.size) then
              stable_ammo.hovered_position = i
                break
            end
        end
    end

    ---checar se foi 
    if stable_ammo.hovered_position > 0 and input.is_key_released(e_keys.MOUSE_LEFT) and stable_ammo.held then
        ammo_selec_pos = stable_ammo.hovered_position
        ammo_pos = stable_ammo.positions[stable_ammo.hovered_position].pos
        ammo_size_pos = stable_ammo.positions[stable_ammo.hovered_position].size
        stable_ammo.held = false
    elseif stable_ammo.held == false and stable_ammo.pressed then
      stable_ammo.held = true
        if stable_ammo.hovered_position == 2 then
          stable_ammo.drag_offset = input.get_mouse_pos().x - (espDCpos + ammo_pos).x
        elseif stable_ammo.hovered_position == 4 then
          stable_ammo.drag_offset = input.get_mouse_pos().x - (espDCpos + ammo_pos).x
        else

          stable_ammo.drag_offset = input.get_mouse_pos().y - (espDCpos + ammo_pos).y
        end

    end

    if stable_ammo.held then
        ammo_size_pos =  stable_ammo.positions[stable_ammo.hovered_position].size
    end

    if  stable_ammo.held and input.is_key_held(e_keys.MOUSE_LEFT) then
        -- for i, p in ipairs(ammo_drop_positions) do
        --  render.rect_filled(espDCpos + p.pos -vec2_t(2,2), p.size +vec2_t(4,4), color_t(100,100,100, p_c),3)
        --  end
        bounds( stable_ammo.hovered_position)

        local x_ammo_drag_offset = stable_ammo.drag_offset

        if  stable_ammo.hovered_position == 2 or  stable_ammo.hovered_position == 4 or  stable_ammo.hovered_position == 5 then
            ammo_pos = input.get_mouse_pos() - vec2_t(x_ammo_drag_offset / 2.2, ammo_size_pos.y / 2)
        else
            ammo_pos = input.get_mouse_pos() - vec2_t(ammo_size_pos.x / 2, x_ammo_drag_offset)
        end

        if  stable_ammo.hovered_position < 5 then
          render.rect_filled(ammo_pos - vec2_t(1, 1), ammo_size_pos + vec2_t(2, 2), color_t(0, 0, 0, 100))
          render.rect(ammo_pos - vec2_t(1, 1), ammo_size_pos + vec2_t(2, 2), color_t(0, 0, 0, 200))
      end

      if  stable_ammo.hovered_position == 2 or  stable_ammo.hovered_position == 4 then
        render.rect_filled(ammo_pos, vec2_t(side_ammo_px, ammo_size_pos.y), ammo_color:get())
      elseif  stable_ammo.hovered_position == 5 then

        render.text(esp_names, "ammo",  ammo_pos , name_color:get(),
        true)

        render.rect(ammo_pos - vec2_t( stable_ammo.textsize.x / 2 + 2, 5), ammo_size_pos + vec2_t(3, 3), color_t(255, 255, 255, p_c))
      else
        render.rect_filled(ammo_pos, vec2_t(ammo_size_pos.x, vertical_ammo_px), ammo_color:get())
      end

    else--- not held 




      stable_ammo.held = false



        if  stable_ammo.off_set_negative then
          if ammo_selec_pos < 5 then 
            render.rect_filled(espDCpos + ammo_pos - vec2_t(1, 1) +  stable_ammo.off_set, ammo_size_pos + vec2_t(2, 2),
                color_t(0, 0, 0, 100))
                render.rect(espDCpos + ammo_pos - vec2_t(1, 1) +  stable_ammo.off_set, ammo_size_pos + vec2_t(2, 2),
                color_t(0, 0, 0, 200))
          end
            if ammo_selec_pos == 2 or ammo_selec_pos == 4 then
                render.rect_filled(espDCpos + ammo_pos +  stable_ammo.off_set, vec2_t(side_ammo_px, ammo_size_pos.y),
                    ammo_color:get())
            elseif ammo_selec_pos == 5 then

                    render.text(esp_names, "ammo", espDCpos + ammo_pos +  stable_ammo.off_set+ vec2_t(stable_ammo.textsize.x / 2, 3), name_color:get(),
                        true)
                        
                
            else

                render.rect_filled(espDCpos + ammo_pos +  stable_ammo.off_set, vec2_t(ammo_size_pos.x, vertical_ammo_px),
                    ammo_color:get())
            end
 

        else 



          if ammo_selec_pos < 5 then 
            render.rect_filled(espDCpos + ammo_pos - vec2_t(1, 1) -  stable_ammo.off_set, ammo_size_pos + vec2_t(2, 2),
            color_t(0, 0, 0, 100))
            render.rect(espDCpos + ammo_pos - vec2_t(1, 1) -  stable_ammo.off_set, ammo_size_pos + vec2_t(2, 2),
            color_t(0, 0, 0, 200))
          end

            if ammo_selec_pos == 2 or ammo_selec_pos == 4 then
                render.rect_filled(espDCpos + ammo_pos -  stable_ammo.off_set, vec2_t(side_ammo_px, ammo_size_pos.y),
                    ammo_color:get())
            elseif ammo_selec_pos == 5 then

                    render.text(esp_names, "ammo", espDCpos + ammo_pos + vec2_t(stable_ammo.textsize.x / 2, 3), name_color:get(),
                        true)
                
            else

                render.rect_filled(espDCpos + ammo_pos -  stable_ammo.off_set, vec2_t(ammo_size_pos.x, vertical_ammo_px),
                    ammo_color:get())
            end
 

        end

    end

end
local function health()
    local p = math.sin(math.abs(-math.pi + (global_vars.real_time() * (1 / 0.5)) % (math.pi * 2))) * 255;
    local p_c = math.floor(p)
    local side_health = math.sin(math.abs(-math.pi + (global_vars.real_time() * (1 / 1.5)) % (math.pi * 2))) * 110;
    local side_health_px = math.floor(side_health)
    local vertical_health = math.sin(math.abs(-math.pi + (global_vars.real_time() * (1 / 1.5)) % (math.pi * 2))) * 237;
    local vertical_health_px = math.floor(vertical_health)
    -- Check if the mouse button was pressed inside the bounds

    if health_selec_pos == 5 then 
      health_pos = stable_health.positions[5].pos
      health_size_pos = stable_health.positions[5].size

    end

    if input.is_mouse_in_bounds(espDCpos + health_pos, health_size_pos) and input.is_key_pressed(e_keys.MOUSE_LEFT) then
      stable_health.pressed = true
    elseif input.is_key_pressed(e_keys.MOUSE_LEFT) and
        not input.is_mouse_in_bounds(espDCpos + health_pos, health_size_pos) then

          stable_health.pressed = false
    elseif input.is_key_released(e_keys.MOUSE_LEFT) then
      stable_health.pressed = false
    end

    for i, p in ipairs(stable_health.drop_positions) do
        if input.is_mouse_in_bounds(espDCpos + p.pos, p.size) then
          stable_health.hovered_position = i
            break
        end
    end

    ---checar se foi 
    if stable_health.hovered_position > 0 and input.is_key_released(e_keys.MOUSE_LEFT) and stable_health.held then
        health_selec_pos = stable_health.hovered_position
        health_pos = stable_health.positions[stable_health.hovered_position].pos
        health_size_pos = stable_health.positions[stable_health.hovered_position].size
        stable_health.held = false
    elseif stable_health.held == false and stable_health.pressed then
      stable_health.held = true
        if stable_health.hovered_position == 2 then
          stable_health.offset = input.get_mouse_pos().x - (espDCpos + health_pos).x
        elseif stable_health.hovered_position == 4 then
          stable_health.drag_offset = input.get_mouse_pos().x - (espDCpos + health_pos).x
        else

          stable_health.drag_offset = input.get_mouse_pos().y - (espDCpos + health_pos).y
        end

    end

    if stable_health.held then
        health_size_pos = stable_health.positions[stable_health.hovered_position].size
    end

    if stable_health.held and input.is_key_held(e_keys.MOUSE_LEFT) then
        bounds(stable_health.hovered_position)

        local x_drag_offset = stable_health.drag_offset

        if stable_health.hovered_position == 2 or stable_health.hovered_position == 4 or stable_health.hovered_position == 5 then
            health_pos = input.get_mouse_pos() - vec2_t(x_drag_offset / 2.2, health_size_pos.y / 2)
        else
            health_pos = input.get_mouse_pos() - vec2_t(health_size_pos.x / 2, x_drag_offset)
        end

        if stable_health.hovered_position < 5 then
            render.rect_filled(health_pos - vec2_t(1, 1), health_size_pos + vec2_t(2, 2), color_t(0, 0, 0, 100))
            render.rect(health_pos - vec2_t(1, 1), health_size_pos + vec2_t(2, 2), color_t(0, 0, 0, 200))
        end

        if stable_health.hovered_position == 2 or stable_health.hovered_position == 4 then
            render.rect_filled(health_pos, vec2_t(side_health_px, health_size_pos.y), health_color:get())
        elseif stable_health.hovered_position == 5 then

            render.text(esp_names, "health", health_pos,
                name_color:get(), true)
                render.rect(health_pos - vec2_t(stable_health.textsize.x / 2 + 2, 5), health_size_pos + vec2_t(3, 3), color_t(255, 255, 255, p_c))

        else
            render.rect_filled(health_pos, vec2_t(health_size_pos.x, vertical_health_px), health_color:get())
        end

    else
        stable_health.held = false

        if health_selec_pos < 5 then
            render.rect_filled(espDCpos + health_pos - vec2_t(1, 1), health_size_pos + vec2_t(2, 2),
                color_t(0, 0, 0, 100))

            render.rect(espDCpos + health_pos - vec2_t(1, 1), health_size_pos + vec2_t(2, 2), color_t(0, 0, 0, 200))
        end

        if health_selec_pos == 2 or health_selec_pos == 4 then
            render.rect_filled(espDCpos + health_pos, vec2_t(side_health_px, health_size_pos.y), health_color:get())
        elseif health_selec_pos == 5 then

            render.text(esp_names, "health", espDCpos + health_pos + vec2_t(stable_health.textsize.x / 2, 3), name_color:get(),
                true)
        else

            render.rect_filled(espDCpos + health_pos, vec2_t(health_size_pos.x, vertical_health_px), health_color:get())
        end

    end

end
local function name()
    -------------- cond
    if health_selec_pos == 1 and health_selec_pos == name_selec_pos  or ammo_selec_pos == 1 and ammo_selec_pos == name_selec_pos then

        if ammo_selec_pos == health_selec_pos  and name_selec_pos == 1 then
          stable_name.inside_cond = 2
          stable_name.off_set_negative = false
          stable_name.off_set = vec2_t(20, 0)
        else
          stable_name.inside_cond = 1
          stable_name.off_set_negative = false
          stable_name.off_set = vec2_t(10, 0)
        end

    elseif health_selec_pos == 2 and health_selec_pos == name_selec_pos  or ammo_selec_pos == 2 and
        ammo_selec_pos == name_selec_pos  then
        if ammo_selec_pos == health_selec_pos and name_selec_pos == 2 then
            -- print("tier 2 ammo")
            stable_name.inside_cond = 2
            stable_name.off_set_negative = false
            stable_name.off_set = vec2_t(0, 15)
        else
          stable_name.inside_cond = 1
            -- print("tier 2 non ammo")
            stable_name.off_set_negative = false
            stable_name.off_set = vec2_t(0, 5)
        end

    elseif health_selec_pos == 3 and health_selec_pos == name_selec_pos  or ammo_selec_pos == 3 and
        ammo_selec_pos == name_selec_pos  then
        if ammo_selec_pos == health_selec_pos and name_selec_pos == 3 then
          stable_name.inside_cond = 2
          stable_name.off_set_negative = true
          stable_name.off_set = vec2_t(20, 0)
        else
          stable_name.inside_cond = 1
          stable_name.off_set_negative = true
          stable_name.off_set = vec2_t(10, 0)
        end
    elseif health_selec_pos == 5 and health_selec_pos == name_selec_pos + 1  or ammo_selec_pos == 5 and ammo_selec_pos == name_selec_pos + 1  then
        if ammo_selec_pos == 5 and health_selec_pos == 5   and name_selec_pos == 4 then
          stable_name.off_set_negative = true
          stable_name.off_set = vec2_t(stable_name.textsize.x * 3.5 /1.2, 0)
        elseif  health_selec_pos == 5 and name_selec_pos == 4 then 
       
          stable_name.off_set_negative = true
          stable_name.off_set = vec2_t(stable_name.textsize.x * 2 /1.2 +1, 0)
        else
          stable_name.off_set_negative = true
          stable_name.off_set = vec2_t(stable_name.textsize.x * 2 /1.8 +1, 0)
        end

    else
      stable_name.off_set = vec2_t(0, 0)
      stable_name.inside_cond = 0
    end

    if name_selec_pos == 4 then 
      name_pos = stable_name.positions[4].pos
      name_size_pos = stable_name.positions[4].size

    end
  -------------- cond 

    if not stable_name.off_set_negative and input.is_mouse_in_bounds(espDCpos + name_pos - stable_name.off_set, name_size_pos) and
        input.is_key_pressed(e_keys.MOUSE_LEFT) then
          stable_name.pressed = true
    elseif stable_name.off_set_negative and input.is_mouse_in_bounds(espDCpos + name_pos + stable_name.off_set, name_size_pos) and
        input.is_key_pressed(e_keys.MOUSE_LEFT) then
          stable_name.pressed = true
    elseif stable_name.off_set_negative and input.is_key_pressed(e_keys.MOUSE_LEFT) and
        not input.is_mouse_in_bounds(espDCpos + name_pos + stable_name.off_set, name_size_pos) then
          stable_name.pressed = false
    elseif not stable_name.off_set_negative and input.is_key_pressed(e_keys.MOUSE_LEFT) and
        not input.is_mouse_in_bounds(espDCpos + name_pos - stable_name.off_set, name_size_pos) then
          stable_name.pressed = false
    elseif input.is_key_released(e_keys.MOUSE_LEFT) then
      stable_name.pressed = false
    end

    local p = math.sin(math.abs(-math.pi + (global_vars.real_time() * (1 / 0.5)) % (math.pi * 2))) * 255;
    local p_c = math.floor(p)
    for i, p in ipairs(stable_name.drop_positions) do
        if stable_name.off_set_negative then
            if input.is_mouse_in_bounds(espDCpos + p.pos , p.size) then
              stable_name.hovered_position = i
                break
            end
        else
            if input.is_mouse_in_bounds(espDCpos + p.pos , p.size) then
              stable_name.hovered_position = i
                break
            end
        end

    end

    ---checar se foi 
    if stable_name.hovered_position > 0 and input.is_key_released(e_keys.MOUSE_LEFT) and stable_name.held then
        name_selec_pos = stable_name.hovered_position
        name_pos = stable_name.positions[stable_name.hovered_position].pos
        name_size_pos = stable_name.positions[stable_name.hovered_position].size
        stable_name.held = false
    elseif stable_name.held == false and stable_name.pressed then
      stable_name.held = true
    end

    if stable_name.pressed then
        name_size_pos = stable_name.positions[stable_name.hovered_position].size
    end

    if stable_name.held and input.is_key_held(e_keys.MOUSE_LEFT) then
        name_pos = input.get_mouse_pos()
        stable_name.off_set = vec2_t(0, 0)
        bounds(stable_name.hovered_position,true )
        
        render.text(esp_names, "name", name_pos, name_color:get(), true)
        render.rect(name_pos - vec2_t(stable_name.textsize.x / 2 + 2, 5), name_size_pos + vec2_t(3, 3), color_t(255, 255, 255, p_c))

    else
      stable_name.name_held = false
        if stable_name.off_set_negative then
            render.text(esp_names, "name", espDCpos + name_pos + vec2_t(stable_name.textsize.x / 2, 3) + stable_name.off_set, name_color:get(),
                true)
        else
            render.text(esp_names, "name", espDCpos + name_pos + vec2_t(stable_name.textsize.x / 2, 3) - stable_name.off_set, name_color:get(),
                true)
        end

    end

end
local function flags()
    -------------- cond
 
    switch(flags_selec_pos) {
      [1] = function() -- for case 1
          if flags_selec_pos == health_selec_pos and flags_selec_pos ~= ammo_selec_pos  and flags_selec_pos ~= name_selec_pos then

            stable_flags.off_set_negative = true
            stable_flags.side_offset = true
            stable_flags.off_set = vec2_t(13, 0)
          elseif flags_selec_pos == health_selec_pos and health_selec_pos == ammo_selec_pos and flags_selec_pos ~= name_selec_pos then
            stable_flags.off_set_negative = true
            stable_flags.side_offset = true
            stable_flags.off_set = vec2_t(23, 0)
          elseif flags_selec_pos == ammo_selec_pos and flags_selec_pos ~= health_selec_pos  and flags_selec_pos ~= name_selec_pos then
            stable_flags.off_set_negative = true
            stable_flags.side_offset = true
            stable_flags.off_set = vec2_t(13, 0)
          elseif flags_selec_pos == health_selec_pos and flags_selec_pos ~= ammo_selec_pos  and flags_selec_pos == name_selec_pos then
            stable_flags.off_set_negative = true
            stable_flags.side_offset = true
            stable_flags.off_set = vec2_t(13, 15)
          elseif flags_selec_pos == health_selec_pos and health_selec_pos == ammo_selec_pos and flags_selec_pos == name_selec_pos then
            stable_flags.off_set_negative = true
            stable_flags.side_offset = true
            stable_flags.off_set = vec2_t(23, 15)
          elseif flags_selec_pos ~= health_selec_pos and flags_selec_pos == ammo_selec_pos  and flags_selec_pos == name_selec_pos then
            stable_flags.off_set_negative = true
            stable_flags.ide_offset = true
            stable_flags.off_set = vec2_t(13, 15)
          elseif flags_selec_pos ~= health_selec_pos and flags_selec_pos ~= ammo_selec_pos  and flags_selec_pos == name_selec_pos then
            stable_flags.off_set_negative = true
            stable_flags.side_offset = true
            stable_flags.off_set = vec2_t(3, 15)
          else
            stable_flags.off_set_negative = true
            stable_flags.side_offset = true
            stable_flags.off_set = vec2_t(3, 0)
          end
      
      end,
      [2] = function() -- for case 2
       
        if flags_selec_pos == health_selec_pos-1 and flags_selec_pos ~= ammo_selec_pos-1  and flags_selec_pos ~= name_selec_pos-1 then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
          stable_flags.off_set = vec2_t(10, 0)
        elseif flags_selec_pos == health_selec_pos-1  and health_selec_pos == ammo_selec_pos   and flags_selec_pos ~= name_selec_pos-1  then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
          stable_flags.off_set = vec2_t(20, 0)
        elseif flags_selec_pos == ammo_selec_pos-1  and flags_selec_pos ~= health_selec_pos -1  and flags_selec_pos ~= name_selec_pos -1 then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
          stable_flags.off_set = vec2_t(10, 0)
        elseif flags_selec_pos == health_selec_pos-1  and flags_selec_pos ~= ammo_selec_pos-1   and flags_selec_pos == name_selec_pos-1 then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
          stable_flags.off_set = vec2_t(10, 15)
        elseif flags_selec_pos == health_selec_pos-1  and health_selec_pos == ammo_selec_pos  and flags_selec_pos == name_selec_pos -1 then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
          stable_flags.off_set = vec2_t(20, 15)
        elseif flags_selec_pos ~= health_selec_pos-1  and flags_selec_pos == ammo_selec_pos-1   and flags_selec_pos == name_selec_pos-1 then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
          stable_flags.off_set = vec2_t(10, 15)
        elseif flags_selec_pos ~= health_selec_pos-1  and flags_selec_pos ~= ammo_selec_pos-1   and flags_selec_pos == name_selec_pos-1 then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
          stable_flags.off_set = vec2_t(0, 15)
        else
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
          stable_flags.off_set = vec2_t(0, 0)
        end
      end,
      [3] = function() -- for case 3

        if flags_selec_pos == health_selec_pos-1 and flags_selec_pos ~= ammo_selec_pos-1 or flags_selec_pos ~= health_selec_pos-1 and flags_selec_pos == ammo_selec_pos-1 then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
      
          stable_flags.off_set = vec2_t(0,10)
        elseif flags_selec_pos == health_selec_pos-1 and health_selec_pos == ammo_selec_pos then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
      
          stable_flags.off_set = vec2_t(0, 20)
        else
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
      
          stable_flags.off_set = vec2_t(0, 0)
        end
      end,
      [4] = function() -- for case 2

        if flags_selec_pos == health_selec_pos-1  and flags_selec_pos == ammo_selec_pos-1 and flags_selec_pos == name_selec_pos and not flags_selec_pos ~= name_selec_pos then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
      
          stable_flags.off_set = vec2_t(3, 15)
        elseif flags_selec_pos == health_selec_pos-1  and ammo_selec_pos < 5  and flags_selec_pos == name_selec_pos then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
      
          stable_flags.off_set = vec2_t(83, 0)
        elseif flags_selec_pos == health_selec_pos-1  and flags_selec_pos == ammo_selec_pos-1 and flags_selec_pos ~= name_selec_pos then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
      
          stable_flags.off_set = vec2_t(83, 0)
        elseif flags_selec_pos == ammo_selec_pos-1  and health_selec_pos < 5  and flags_selec_pos ~= name_selec_pos then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
      
          stable_flags.off_set = vec2_t(38, 0)
        elseif flags_selec_pos == health_selec_pos-1  and ammo_selec_pos < 5  and flags_selec_pos ~= name_selec_pos then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
      
          stable_flags.off_set = vec2_t(48, 0)
        elseif flags_selec_pos == ammo_selec_pos-1 and health_selec_pos < 5 then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
      
          stable_flags.off_set = vec2_t(67, 0)
        elseif flags_selec_pos == name_selec_pos and health_selec_pos < 5 and ammo_selec_pos < 5 then
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
      
          stable_flags.off_set = vec2_t(37, 0)
        else
          stable_flags.off_set_negative = true
          stable_flags.side_offset = false
          stable_flags.off_set = vec2_t(3, 0)
        end

      end
  }


    if flags_selec_pos == 4 then 
      flags_pos = stable_flags.positions[4].pos
      flags_size_pos = stable_flags.positions[4].size

    end
  -------------- cond 

    if not stable_flags.off_set_negative and input.is_mouse_in_bounds(espDCpos + flags_pos - stable_flags.off_set, flags_size_pos) and input.is_key_pressed(e_keys.MOUSE_LEFT) and not stable_flags.side_offset then
      stable_flags.pressed = true
    elseif stable_flags.off_set_negative and input.is_mouse_in_bounds(espDCpos + flags_pos + stable_flags.off_set, flags_size_pos) and input.is_key_pressed(e_keys.MOUSE_LEFT) and not stable_flags.side_offset then
      stable_flags.pressed = true
    elseif stable_flags.side_offset and input.is_mouse_in_bounds(espDCpos + flags_pos + vec2_t(0,stable_flags.off_set.y)-vec2_t(stable_flags.off_set.x,0), flags_size_pos) and input.is_key_pressed(e_keys.MOUSE_LEFT) then
      stable_flags.pressed = true
    elseif stable_flags.off_set_negative and input.is_key_pressed(e_keys.MOUSE_LEFT) and not input.is_mouse_in_bounds(espDCpos + flags_pos + stable_flags.off_set, flags_size_pos) and not stable_flags.side_offset then 
      stable_flags.pressed = false
    elseif not stable_flags.off_set_negative and input.is_key_pressed(e_keys.MOUSE_LEFT) and not input.is_mouse_in_bounds(espDCpos + flags_pos - stable_flags.off_set, flags_size_pos) and not stable_flags.side_offset then
      stable_flags.pressed = false
    elseif input.is_key_released(e_keys.MOUSE_LEFT) then
      stable_flags.pressed = false
    end

    local p = math.sin(math.abs(-math.pi + (global_vars.real_time() * (1 / 0.5)) % (math.pi * 2))) * 255;
    local p_c = math.floor(p)
    for i, p in ipairs(stable_flags.drop_positions) do
        if stable_flags.off_set_negative then
            if input.is_mouse_in_bounds(espDCpos + p.pos, p.size) then
            
              stable_flags.hovered_position = i
                break
            end
        else
            if input.is_mouse_in_bounds(espDCpos + p.pos , p.size) then
              stable_flags.hovered_position = i
                break
            end
        end

    end

    ---checar se foi 
    if stable_flags.hovered_position > 0 and input.is_key_released(e_keys.MOUSE_LEFT) and stable_flags.held then
        flags_selec_pos = stable_flags.hovered_position
        flags_pos = stable_flags.positions[stable_flags.hovered_position].pos
        flags_size_pos = stable_flags.positions[stable_flags.hovered_position].size
        stable_flags.held = false
    elseif stable_flags.held == false and stable_flags.pressed then
      stable_flags.held = true
    end

    if stable_flags.pressed then
        flags_size_pos = stable_flags.positions[stable_flags.hovered_position].size
    end

    if stable_flags.held and input.is_key_held(e_keys.MOUSE_LEFT) then
        flags_pos = input.get_mouse_pos()
        stable_flags.off_set = vec2_t(0, 0)
        bounds(stable_flags.hovered_position,false, true )
        
        render.text(esp_names, "flags", flags_pos, name_color:get(), true)
        render.rect(flags_pos - vec2_t(stable_flags.textsize.x / 2 +1, 5), flags_size_pos + vec2_t(0, 3), color_t(255, 255, 255, p_c))

    else
      stable_flags.held = false
        if stable_flags.off_set_negative then
          if stable_flags.side_offset then
            render.text(esp_names, "flags", espDCpos + flags_pos + vec2_t(stable_flags.textsize.x / 2, 3) + vec2_t(0,stable_flags.off_set.y)-vec2_t(stable_flags.off_set.x,0), name_color:get(),
            true)
          else
            render.text(esp_names, "flags", espDCpos + flags_pos + vec2_t(stable_flags.textsize.x / 2, 3) + stable_flags.off_set, name_color:get(),
            true)
          end
     
        else
            render.text(esp_names, "flags", espDCpos + flags_pos + vec2_t(stable_flags.textsize.x / 2, 3) - stable_flags.off_set, name_color:get(),
                true)
        end

    end

end
local function renderMenu()
    -- Render the menu background
    local menupos = menu.get_pos()
    local menusize = menu.get_size()
    render.rect_filled(vec2_t(menupos.x + menusize.x + 39, menupos.y + 149), menuszi + vec2_t(2, 2)- vec2_t(0, 52),
        color_t(23,23,23, 255), 4)
    render.rect_filled(vec2_t(menupos.x + menusize.x + 40, menupos.y + 150), menuszi- vec2_t(0, 53), color_t(29, 29, 29, 255), 4)


    
    render.rect_filled(vec2_t(menupos.x + menusize.x + 40 + menuszi.x - 142, menupos.y + 158),vec2_t(menuszi.x - menuszi.x + 140, menuszi.y - 90), color_t(23,23,23, 255))-- side tab
    render.rect_filled(vec2_t(menupos.x + menusize.x + 40 + menuszi.x - 141, menupos.y + 158),vec2_t(menuszi.x - menuszi.x + 141, menuszi.y - 90), color_t(41,41,41, 255))-- side tab
    render.rect_filled(vec2_t(menupos.x + menusize.x + 40 + menuszi.x - 140, menupos.y + 158),vec2_t(menuszi.x - menuszi.x + 139, menuszi.y - 90), color_t(34,34,34, 255))-- side tab





    render.text(main_font, "FLAGS", vec2_t(menupos.x + menusize.x + 40 + menuszi.x - 90, menupos.y + 200),color_t(132, 132, 132))-- side tab
    render.rect_filled(vec2_t(menupos.x + menusize.x + 40 + menuszi.x - 135, menupos.y + 215), vec2_t(129, 149),color_t(38, 38, 38, 255), 3) -- side tab
    render.rect_filled(vec2_t(menupos.x + menusize.x + 40 + menuszi.x - 134, menupos.y + 216), vec2_t(127, 147),color_t(29, 29, 29, 255), 3) -- side tab

    render.rect_filled(vec2_t(menupos.x + menusize.x + 40 + menuszi.x - 140, menupos.y + 379),vec2_t(menuszi.x - menuszi.x + 140, 1),accent_color[2]:get())-- side tab
    render.text(main_font, "ITEMS", vec2_t(menupos.x + menusize.x + 40 + menuszi.x - 90, menupos.y + 395),color_t(132, 132, 132))-- side tab
    render.rect_filled(vec2_t(menupos.x + menusize.x + 40 + menuszi.x - 135, menupos.y + 410), vec2_t(129, 149),color_t(38, 38, 38, 255), 3) -- side tab
    render.rect_filled(vec2_t(menupos.x + menusize.x + 40 + menuszi.x - 134, menupos.y + 411), vec2_t(127, 147),color_t(29, 29, 29, 255), 3) -- side tab




  --- superior
    render.rect_filled(vec2_t(menupos.x + menusize.x + 40, menupos.y + 150), vec2_t(menuszi.x, 45),color_t(41,41,41, 255), 4)
    render.rect_filled(vec2_t(menupos.x + menusize.x + 40, menupos.y + 193), vec2_t(menuszi.x, 2),color_t(41,41,41, 255))
    render.rect_filled(vec2_t(menupos.x + menusize.x + 40, menupos.y + 195), vec2_t(menuszi.x, 1),accent_color[2]:get())
 --- superior




    render.rect_filled(vec2_t(menupos.x + menusize.x + 40, menupos.y + menuszi.y + 68),vec2_t(menuszi.x, menuszi.y - menuszi.y + 3), color_t(40, 40, 40, 255))
    render.rect_filled(vec2_t(menupos.x + menusize.x + 40, menupos.y + menuszi.y + 68),vec2_t(menuszi.x, menuszi.y - menuszi.y + 30), color_t(40, 40, 40, 255), 4)
    render.rect_filled(vec2_t(menupos.x + menusize.x + 40, menupos.y + menuszi.y + 68), vec2_t(menuszi.x, 1),accent_color[2]:get())

    render.text(menu_font, "xanax.club", vec2_t(menupos.x + menusize.x + 45, menupos.y + menuszi.y + 75),accent_color[2]:get())
    mainDCpos = vec2_t(menupos.x + menusize.x + menuszi.x - 110, menupos.y + 190)


    render.rect_filled(vec2_t(menupos.x + menusize.x + 59, menupos.y + 215), vec2_t(menuszi.x - 181, 334),
        color_t(23,23,23, 255), 3)

    render.rect_filled(vec2_t(menupos.x + menusize.x + 60, menupos.y + 216), vec2_t(menuszi.x - 183, 332),
        color_t(34,34,34, 255), 3)
    render.rect(vec2_t(menupos.x + menusize.x + 60, menupos.y + 216), vec2_t(menuszi.x - 183, 332),
        color_t(41,41,41, 255), 3)

    espDCpos = vec2_t(menupos.x + menusize.x + 169, menupos.y + 217)
end
local function esp_render()
    -- get a table of enemies only 
    local enemies_only = entity_list.get_players(true)
    if enemies_only == nil then
        return
    end
    local screen_size = render.get_screen_size()
    local local_player = entity_list.get_local_player()
    -- iterate through the enemies table
    for _, enemy in pairs(enemies_only) do
        -- check if they are alive

        if enemy:is_alive() and not enemy:is_dormant() then

            local ok = get_pos(enemy)
            local size = get_size(enemy)

            if size == nil then
                return
            end
            local hp_height = (size.y * enemy:get_prop("m_iHealth")) / 100
            local hp_w = (size.x * enemy:get_prop("m_iHealth")) / 100
            local name_size = render.get_text_size(esp_names, enemy:get_name())
           -- render.rect(vec2_t(ok.x, ok.y - size.y), size, box_color:get(), 1)
            --render.rect(vec2_t(ok.x + 1, ok.y - size.y + 1), vec2_t(size.x - 2, size.y - 2), color_t(0, 0, 0, 50), 1)
           -- render.rect(vec2_t(ok.x - 1, ok.y - size.y - 1), vec2_t(size.x + 2, size.y + 2), color_t(0, 0, 0, 50), 1)

            local name_size = render.get_text_size(esp_names, enemy:get_name())
            switch(name_selec_pos) {
                [1] = function() -- for case 1
                    if stable_name.inside_cond == 1 then
                        render.text(esp_names, enemy:get_name(),
                            vec2_t(ok.x - 7 - name_size.x / 2, ok.y - size.y - name_size.y / 2 + 12), name_color:get(),
                            true)
                    elseif stable_name.inside_cond == 2 then 
                      render.text(esp_names, enemy:get_name(),
                      vec2_t(ok.x - 12 - name_size.x / 2, ok.y - size.y - name_size.y / 2 + 12), name_color:get(),
                      true)
                    else
                        render.text(esp_names, enemy:get_name(),
                            vec2_t(ok.x - 2 - name_size.x / 2, ok.y - size.y - name_size.y / 2 + 12), name_color:get(),
                            true)
                    end

                end,
                [2] = function() -- for case 2


                  if stable_name.inside_cond == 1 then
                    render.text(esp_names, enemy:get_name(), vec2_t(ok.x + size.x / 2, ok.y - size.y - 12),
                    name_color:get(), true)
                elseif stable_name.inside_cond == 2 then 
                  render.text(esp_names, enemy:get_name(), vec2_t(ok.x + size.x / 2, ok.y - size.y - 18),
                  name_color:get(), true)
                else
                  render.text(esp_names, enemy:get_name(), vec2_t(ok.x + size.x / 2, ok.y - size.y - 6),
                  name_color:get(), true)
                end




                end,
                [3] = function() -- for case 3


                  if stable_name.inside_cond == 1 then
                    render.text(esp_names, enemy:get_name(),
                    vec2_t(ok.x + size.x + 7 + name_size.x / 2, ok.y - size.y - name_size.y / 2 + 12),
                    name_color:get(), true)
                elseif stable_name.inside_cond == 2 then 
                  render.text(esp_names, enemy:get_name(),
                  vec2_t(ok.x + size.x + 12 + name_size.x / 2, ok.y - size.y - name_size.y / 2 + 12),
                  name_color:get(), true)
                else
                  render.text(esp_names, enemy:get_name(),
                  vec2_t(ok.x + size.x + 2 + name_size.x / 2, ok.y - size.y - name_size.y / 2 + 12),
                  name_color:get(), true)
                end


                end
            }
            local health_text_size = render.get_text_size(sub_font, tostring(enemy:get_prop("m_iHealth")))
            local hp_height = (size.y * enemy:get_prop("m_iHealth")) / 100
      
                switch(health_selec_pos) {
                    [1] = function() -- for case 1

                        render.rect_filled(vec2_t(ok.x - 6, ok.y - size.y - 1), vec2_t(4, size.y + 2),
                            color_t(10, 10, 10, 125))
                        render.rect_filled(vec2_t(ok.x - 5, ok.y   ), vec2_t(2,  0 - hp_height), health_color:get())

                    end,
                    [2] = function() -- for case 2
                        local hp_heightx = (size.x * enemy:get_prop("m_iHealth")) / 100
                        render.rect_filled(vec2_t(ok.x - 1, ok.y - size.y - 6), vec2_t(size.x + 2, 4),
                            color_t(10, 10, 10, 125))
                        render.rect_filled(vec2_t(ok.x, ok.y - size.y - 5), vec2_t(hp_heightx, 2), health_color:get())

                    end,
                    [3] = function() -- for case 3

                        render.rect_filled(vec2_t(ok.x + size.x + 2, ok.y - size.y - 1), vec2_t(4, size.y + 2),
                            color_t(10, 10, 10, 125))
                        render.rect_filled(vec2_t(ok.x + size.x + 3, ok.y ), vec2_t(2, 0 -hp_height),
                            health_color:get())
                    end,
                    [4] = function() -- for case 2
                        local hp_heightx = (size.x * enemy:get_prop("m_iHealth")) / 100
                        render.rect_filled(vec2_t(ok.x - 1, ok.y + 3), vec2_t(size.x + 2, 4), color_t(10, 10, 10, 125))
                        render.rect_filled(vec2_t(ok.x, ok.y + 4), vec2_t(hp_heightx, 2), health_color:get())

                    end
                }

            if enemy:get_active_weapon() == nil or enemy:get_active_weapon():get_prop("m_iClip1") then goto continue end
            if enemy:get_active_weapon():get_weapon_data().max_clip < 0 then goto continue end
            local clip =  enemy:get_active_weapon():get_prop("m_iClip1") 
            local max_clip = enemy:get_active_weapon():get_weapon_data().max_clip
            
            local ammo_h = (size.y * clip / max_clip)
            local ammo_w = (size.x * clip / max_clip)
            switch(ammo_selec_pos) {
              [1] = function() -- for case 1
                  if stable_ammo.inside_cond == 1 then
                    render.rect_filled(vec2_t(ok.x - 6 - 5, ok.y - size.y - 1), vec2_t(4, size.y + 2),color_t(10, 10, 10, 125))
                    render.rect_filled(vec2_t(ok.x - 5 - 5, ok.y   ), vec2_t(2,  0 - ammo_h), ammo_color:get())
                  else
                    render.rect_filled(vec2_t(ok.x - 6, ok.y - size.y - 1), vec2_t(4, size.y + 2),color_t(10, 10, 10, 125))
                    render.rect_filled(vec2_t(ok.x - 5, ok.y   ), vec2_t(2,  0 - ammo_h), ammo_color:get())
                  end
      

              end,
              [2] = function() -- for case 2
                if stable_ammo.inside_cond == 1 then
                  render.rect_filled(vec2_t(ok.x - 1, ok.y - size.y - 6- 5), vec2_t(size.x + 2, 4),color_t(10, 10, 10, 125))
                  render.rect_filled(vec2_t(ok.x, ok.y - size.y - 5 - 5), vec2_t(ammo_w, 2), ammo_color:get())
                else
                  render.rect_filled(vec2_t(ok.x - 1, ok.y - size.y - 6), vec2_t(size.x + 2, 4),color_t(10, 10, 10, 125))
                  render.rect_filled(vec2_t(ok.x, ok.y - size.y - 5), vec2_t(ammo_w, 2), ammo_color:get())
                end

              end,
              [3] = function() -- for case 3
                if stable_ammo.inside_cond == 1 then
                  render.rect_filled(vec2_t(ok.x + size.x + 2+5, ok.y - size.y - 1), vec2_t(4, size.y + 2),color_t(10, 10, 10, 125))
                  render.rect_filled(vec2_t(ok.x + size.x + 3 +5, ok.y ), vec2_t(2, 0 -ammo_h),ammo_color:get())
                else
                  render.rect_filled(vec2_t(ok.x + size.x + 2, ok.y - size.y - 1), vec2_t(4, size.y + 2),color_t(10, 10, 10, 125))
                  render.rect_filled(vec2_t(ok.x + size.x + 3, ok.y ), vec2_t(2, 0 -ammo_h),ammo_color:get())
                end

              end,
              [4] = function() -- for case 2
                if stable_ammo.inside_cond == 1 then
                  render.rect_filled(vec2_t(ok.x - 1, ok.y + 3 +5), vec2_t(size.x + 2, 4), color_t(10, 10, 10, 125))
                  render.rect_filled(vec2_t(ok.x, ok.y + 4+5), vec2_t(ammo_w, 2), ammo_color:get())
                else
                  render.rect_filled(vec2_t(ok.x - 1, ok.y + 3), vec2_t(size.x + 2, 4), color_t(10, 10, 10, 125))
                  render.rect_filled(vec2_t(ok.x, ok.y + 4), vec2_t(ammo_w, 2), ammo_color:get())
                end


              end
          }
         
         
        end
        ::continue::
    end

end


callbacks.add(e_callbacks.PAINT, function()
  for _, index in ipairs(selected_indices) do
    --print(list_flags[index])
  end
    esp_render()

    if menu.is_open() then
      renderMenu()
      ammo()
      name()
      health()
      flags()
      selected_indices = listbox(espDCpos +vec2_t(350,0), vec2_t(100,100), list_flags)
    end


end)