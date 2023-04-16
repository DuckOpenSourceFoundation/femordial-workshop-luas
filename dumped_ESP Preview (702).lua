-- Define variables for menu position and button size
local esp_names = render.create_font("Verdanab", 5, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local main_font = render.create_font("Verdanab", 11, 600, e_font_flags.ANTIALIAS,  e_font_flags.DROPSHADOW)
local health_esp = menu.add_checkbox("esp", "Health")
local health_color = health_esp:add_color_picker("healthcolor", color_t(123,255,123,255))
local box_esp = menu.add_checkbox("esp", "Boxes")
local box_color = box_esp:add_color_picker("box color")

local name_esp = menu.add_checkbox("esp", "names")
local name_color = name_esp:add_color_picker("name color")
local menuX, menuY = 240, 400
local buttonWidth, buttonHeight = 50,30
local buttonHWidth, buttonHHeight = 15,15
local newposx =  0
local newposy = 0
local esphealth = false
local espName = false
local espNamepos = 0
local esphealthpos = 0
-- Define a function to check if the mouse is hovering over a button
local function isMouseOverButton(x, y)
  local mousepos = input.get_mouse_pos()
  return mousepos.x >= x and mousepos.x <= x + buttonWidth and
    mousepos.y >= y and mousepos.y <= y + buttonHeight
end

-- Define a table to hold the button labels and corresponding functions
local buttons = {
  { label = "Health", func = function() esphealth = true espName = false end },
  { label = "Name", func = function() espName = true esphealth = false end },
  { label = "SOON", func = function() print("wait pls, more things will be added") end },
}
local buttonsname = {
  { label = "+", func = function() espNamepos = 0 espName = false end , pos = vec2_t(10,100) },
  { label = "+", func = function() espNamepos = 1 espName = false end,pos = vec2_t(100,75) },
  { label = "+", func = function() espNamepos = 2 espName = false end ,pos = vec2_t(190,100)},
}
local buttonshealth = {
  { label = "+", func = function() esphealthpos = 0 esphealth = false end , pos = vec2_t(10,190) },
  { label = "+", func = function() esphealthpos = 1 esphealth = false end,pos = vec2_t(100,75) },
  { label = "+", func = function() esphealthpos = 2 esphealth = false end ,pos = vec2_t(190,190)},
  { label = "+", func = function() esphealthpos = 3 esphealth = false end ,pos = vec2_t(100,340)},
}
-- Define a function to render the menu and buttons
local function renderMenu()
  -- Render the menu background
  local menupos = menu.get_pos()
  local menusize = menu.get_size()
  render.rect_filled(vec2_t(menupos.x +menusize.x +48 ,menupos.y + 98), vec2_t(menuX+2,menuY+2), color_t(24,24,24, 255),4)
  render.rect_filled(vec2_t(menupos.x +menusize.x +49 ,menupos.y + 99), vec2_t(menuX,menuY), color_t(40,40,40, 255),4)
  render.rect_filled(vec2_t(menupos.x +menusize.x +50 ,menupos.y + 100), vec2_t(menuX-2,menuY-2), color_t(34,34,34, 255),4)
  render.rect_filled(vec2_t(menupos.x +menusize.x +50 ,menupos.y + 100), vec2_t(menuX-2,50), color_t(41,41,41, 255),4)
  render.rect_filled(vec2_t(menupos.x +menusize.x +50 ,menupos.y + 148), vec2_t(menuX-2,2), color_t(41,41,41, 255))
  render.rect_filled(vec2_t(menupos.x +menusize.x +50 ,menupos.y + 150), vec2_t(menuX-2,1), color_t(155,126,133, 255))
 -- Define some constants for the button size and spacing

local buttonSpacing = 10



-- Render the buttons
for i, button in ipairs(buttons) do
  local buttonX, buttonY = menupos.x +menusize.x + 60+ (i-1) * (buttonWidth + buttonSpacing) ,menupos.y + 100+ 10 
  
  local color = input.is_mouse_in_bounds(vec2_t(buttonX,buttonY),vec2_t(buttonWidth, buttonHeight )) and color_t(52,52,52) or color_t(21,21,21 )
  render.rect_filled(vec2_t(buttonX, buttonY), vec2_t(buttonWidth, buttonHeight), color,3)
  render.rect_filled(vec2_t(buttonX+1, buttonY+1), vec2_t(buttonWidth-2, buttonHeight-2), color_t(29,29,29,255),3)
    -- Render button label
    local text_size = render.get_text_size(main_font, button.label)


    local labelX, labelY = buttonX + buttonWidth/2 - text_size.x/2, buttonY + buttonHeight/2 - text_size.y/2
    render.text(main_font, button.label, vec2_t(labelX, labelY), color_t(132,132,132))
  if input.is_mouse_in_bounds(vec2_t(buttonX,buttonY),vec2_t(buttonWidth, buttonHeight )) and input.is_key_pressed(e_keys.MOUSE_LEFT) then
        button.func()
  end
 

end
-- If the left mouse button is released, stop dragging any button

end

local function switch(value)
  return function(cases)
    local f = cases[value]
    if (f) then
      f()
    end
  end
end

local function renderesp()
  -- Render the menu background
  local menupos = menu.get_pos()
  local menusize = menu.get_size()
  render.rect(vec2_t(menupos.x +menusize.x +100 ,menupos.y + 200), vec2_t(menuX-102,menuY-170), box_color:get())

  if esphealth then 

    for i, button in ipairs(buttonshealth) do
      local buttonX, buttonY =menupos.x +menusize.x + 60+button.pos.x,menupos.y + 100+ button.pos.y
      
      local color = input.is_mouse_in_bounds(vec2_t(buttonX,buttonY),vec2_t(buttonHWidth, buttonHHeight )) and color_t(52,52,52) or color_t(39,39,39 )
      render.rect_filled(vec2_t(buttonX, buttonY), vec2_t(buttonHWidth, buttonHHeight), color,3)
      render.rect_filled(vec2_t(buttonX+1, buttonY+1), vec2_t(buttonHWidth-2, buttonHHeight-2), color_t(29,29,29,255),3)
        -- Render button label
        local text_size = render.get_text_size(main_font, button.label)
    
    
        local labelX, labelY = buttonX + buttonHWidth/2 - text_size.x/2, buttonY + buttonHHeight/2 - text_size.y/2
        render.text(main_font, button.label, vec2_t(labelX, labelY), color_t(132,132,132))
      if input.is_mouse_in_bounds(vec2_t(buttonX,buttonY),vec2_t(buttonHWidth, buttonHHeight )) and input.is_key_pressed(e_keys.MOUSE_LEFT) then
            button.func()
      end
    end
  elseif not espName then
      switch (esphealthpos) {
    [0] = function()	-- for case 1
      render.rect(vec2_t(menupos.x +menusize.x +90 ,menupos.y + 200), vec2_t(1,menuY-169), health_color:get())
   
    end,
    [1] = function()	-- for case 2
      render.rect(vec2_t(menupos.x +menusize.x +100 ,menupos.y + 190), vec2_t(139,1), health_color:get())
   
    end,
    [2] = function()	-- for case 3
      render.rect(vec2_t(menupos.x +menusize.x +248 ,menupos.y + 200), vec2_t(1,menuY-169),health_color:get())
    end,
    [3] = function()	-- for case 2
    	render.rect(vec2_t(menupos.x +menusize.x +100 ,menupos.y + 438), vec2_t(139,1), health_color:get())
    end
  }
  end

  if  espName then 

    for i, button in ipairs(buttonsname) do
      local buttonX, buttonY =menupos.x +menusize.x + 60+button.pos.x,menupos.y + 100+ button.pos.y
      
      local color = input.is_mouse_in_bounds(vec2_t(buttonX,buttonY),vec2_t(buttonHWidth, buttonHHeight )) and color_t(52,52,52) or color_t(39,39,39 )
      render.rect_filled(vec2_t(buttonX, buttonY), vec2_t(buttonHWidth, buttonHHeight), color,3)
      render.rect_filled(vec2_t(buttonX+1, buttonY+1), vec2_t(buttonHWidth-2, buttonHHeight-2), color_t(29,29,29,255),3)
        -- Render button label
        local text_size = render.get_text_size(main_font, button.label)
    
    
        local labelX, labelY = buttonX + buttonHWidth/2 - text_size.x/2, buttonY + buttonHHeight/2 - text_size.y/2
        render.text(main_font, button.label, vec2_t(labelX, labelY), color_t(132,132,132))
      if input.is_mouse_in_bounds(vec2_t(buttonX,buttonY),vec2_t(buttonHWidth, buttonHHeight )) and input.is_key_pressed(e_keys.MOUSE_LEFT) then
            button.func()
      end
    end
  elseif not  esphealth then
      switch (espNamepos) {
    [0] = function()	-- for case 1

      render.text(esp_names, "name", vec2_t(menupos.x +menusize.x +70 ,menupos.y + 205), name_color:get(), true)
    end,
    [1] = function()	-- for case 2

      render.text(esp_names, "name", vec2_t(menupos.x +menusize.x +168 ,menupos.y + 180), name_color:get(), true)
    end,
    [2] = function()	-- for case 3

      render.text(esp_names, "name", vec2_t(menupos.x +menusize.x +268 ,menupos.y + 205), name_color:get(), true)
    end
  }
  end

end

----------- thx for the usage .....
local function get_pos(player)
  local min = player:get_prop("m_vecMins")
  local max = player:get_prop("m_vecMaxs")
  local pos = player:get_render_origin() --collideable + pos

  if min == nil or max == nil or pos == nil then return end

  local mpoints = {
  vec3_t(min.x, min.y, min.z),
  vec3_t(min.x, max.y, min.z),
  vec3_t(max.x, max.y, min.z),
  vec3_t(max.x, min.y, min.z),
  vec3_t(max.x, max.y, max.z),
  vec3_t(min.x, max.y, max.z),
  vec3_t(min.x, min.y, max.z),
  vec3_t(max.x, min.y, max.z)
}

  local points = {
      pos + mpoints[1],
      pos + mpoints[2],
      pos + mpoints[3],
      pos + mpoints[4],
      pos + mpoints[5],
      pos + mpoints[6],
      pos + mpoints[7],
      pos + mpoints[8]
  }

  local screen_points = {}
  
  for i = 1, 8, 1 do
      --debug_overlay.add_sphere(points[i], 4, 10, 10, color_t(255,255,255,255), 0.1)
      screen_points[i] = render.world_to_screen(points[i])
  end
  if screen_points[1] == nil then return end
  local left = screen_points[1].x
  local bot = screen_points[1].y
  for i = 1, 8, 1 do
  if screen_points[i] == nil then return end
      
      if left > screen_points[i].x then
      left = screen_points[i].x end
      if bot < screen_points[i].y then
      bot= screen_points[i].y end
  end
  return vec2_t(left, bot)
end
local function get_size(player)
  local min = player:get_prop("m_vecMins")
  local max = player:get_prop("m_vecMaxs")
  local pos = player:get_render_origin() --collideable + pos

  if min == nil or max == nil or pos == nil then return end

  local mpoints = {
  vec3_t(min.x, min.y, min.z),
  vec3_t(min.x, max.y, min.z),
  vec3_t(max.x, max.y, min.z),
  vec3_t(max.x, min.y, min.z),
  vec3_t(max.x, max.y, max.z),
  vec3_t(min.x, max.y, max.z),
  vec3_t(min.x, min.y, max.z),
  vec3_t(max.x, min.y, max.z)
}

  local points = {
      pos + mpoints[1],
      pos + mpoints[2],
      pos + mpoints[3],
      pos + mpoints[4],
      pos + mpoints[5],
      pos + mpoints[6],
      pos + mpoints[7],
      pos + mpoints[8]
  }

  local screen_points = {}
  
  for i = 1, 8, 1 do
      --debug_overlay.add_sphere(points[i], 4, 10, 10, color_t(255,255,255,255), 0.1)
      screen_points[i] = render.world_to_screen(points[i])
  end
  if screen_points[1] == nil then return end
  local left = screen_points[1].x
  local bot = screen_points[1].y
  local right = screen_points[1].x 
  local top = screen_points[1].y
  for i = 1, 8, 1 do
  if screen_points[i] == nil then return end
      
      if left > screen_points[i].x then
      left = screen_points[i].x end
      if bot < screen_points[i].y then
      bot= screen_points[i].y end
      if right < screen_points[i].x then
      right = screen_points[i].x end
      if top > screen_points[i].y then
      top = screen_points[i].y end
  end
  return vec2_t(right - left, bot - top)
end
--------------------------




local function esprender()
   -- get a table of enemies only 
   local enemies_only = entity_list.get_players(true) 
   if enemies_only == nil then return end
   local screen_size = render.get_screen_size()
   local local_player = entity_list.get_local_player()
   -- iterate through the enemies table
   for _, enemy in pairs(enemies_only) do 
       -- check if they are alive
       
       if enemy:is_alive() then 
       
        local ok = get_pos(enemy)
        local size = get_size(enemy)
        if size == nil then return end
        local hp_height = (size.y * enemy:get_prop("m_iHealth")) / 100
        local hp_w = (size.x * enemy:get_prop("m_iHealth")) / 100
        local name_size = render.get_text_size(esp_names, enemy:get_name())
            if box_esp:get() then
              render.rect(vec2_t(ok.x, ok.y - size.y), size, box_color:get(), 1)
              render.rect(vec2_t(ok.x + 1, ok.y - size.y + 1), vec2_t(size.x - 2, size.y -2), color_t(0,0,0,255), 1)
              render.rect(vec2_t(ok.x - 1, ok.y - size.y - 1), vec2_t(size.x + 2, size.y + 2), color_t(0,0,0,255), 1)
            end
            if health_esp:get() then
            switch (esphealthpos) {
            [0] = function()	-- for case 1
             
              render.rect_filled(vec2_t(ok.x - 6, ok.y - size.y - 1), vec2_t(4, size.y + 2), color_t(10,10,10,255))
              render.rect_filled(vec2_t(ok.x - 5, ok.y - hp_height), vec2_t(2, hp_height), health_color:get())
          
            end,
            [1] = function()	-- for case 2
       
              render.rect_filled(vec2_t(ok.x , ok.y -size.y -8), vec2_t(size.x , 4 ), color_t(10,10,10,255))
              render.rect_filled(vec2_t(ok.x +1, ok.y -size.y-7), vec2_t(hp_w-2, 2), health_color:get())
            end,
            [2] = function()	-- for case 3
             
              render.rect_filled(vec2_t(ok.x + size.x +1, ok.y - size.y - 1), vec2_t(4, size.y + 2), color_t(10,10,10,255))
              render.rect_filled(vec2_t(ok.x + size.x+2, ok.y - hp_height), vec2_t(2, hp_height), health_color:get())
            end,
            [3] = function()	-- for case 2
                    
              render.rect_filled(vec2_t(ok.x , ok.y +4), vec2_t(size.x , 4 ), color_t(10,10,10,255))
              render.rect_filled(vec2_t(ok.x +1, ok.y+5 ), vec2_t(hp_w-2, 2), health_color:get())
            end
            }
          end
          if name_esp:get() then
          switch (espNamepos) {
            [0] = function()	-- for case 1
             

           render.text(esp_names, enemy:get_name(), vec2_t(ok.x -20, ok.y - size.y - name_size.y / 2 +10), name_color:get(), true)
            end,
            [1] = function()	-- for case 2
       
              render.text(esp_names, enemy:get_name(), vec2_t(ok.x + size.x / 2, ok.y - size.y -20 ), name_color:get(), true)
            end,
            [2] = function()	-- for case 3
             
              render.text(esp_names, enemy:get_name(), vec2_t(ok.x + size.x +20, ok.y - size.y - name_size.y / 2+10), name_color:get(), true)
            end
            }
          end
       end
   end


end
-- Call the renderMenu function in your main loop or hook
function on_render()
  if menu.is_open() then  renderMenu()renderesp()  end
  esprender()
end
callbacks.add(e_callbacks.PAINT, on_render)