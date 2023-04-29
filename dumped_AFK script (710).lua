local calibri = render.create_font("Calibri bold", 29, 600, e_font_flags.ANTIALIAS)
local main_font = render.create_font("Calibri", 12, 400)
local screen_size = render.get_screen_size() -- screen
local ctx = screen_size.x / 2
local cty = screen_size.y / 2
local commandExecuted = false 
local resetCommandExecuted = true 
local afk = menu.add_checkbox("AFK", "go afk!" , false)
local afkbind = afk:add_keybind("AFK", "ME back!")
local shouldtalk = menu.add_checkbox("AFK","Say in Chat")
local checkbox = menu.add_checkbox("Indicator", "Turn On")
local color = checkbox:add_color_picker("color")
local sayExecuted = false
local printExecuted = true 
local function afkgo()
    if afkbind:get() then
        afk:set(true)
    else
        afk:set(false)
    end

    if afk:get() and not commandExecuted then
        engine.execute_cmd("+duck;+forward")
        commandExecuted = true
        resetCommandExecuted = false
    elseif not afk:get() and not resetCommandExecuted then
        engine.execute_cmd("-forward;-duck")
        resetCommandExecuted = true
        commandExecuted = false
    end
end

local function shouldittalk()
    if shouldtalk:get() and afk:get() and not sayExecuted then
        engine.execute_cmd("say_team Afk!")
        sayExecuted = true
    elseif afk:get() == false and shouldtalk:get() == true and sayExecuted then
        sayExecuted = false 
    end

    if shouldtalk:get() and not afk:get() and not printExecuted then
        engine.execute_cmd("say_team Back!")
        printExecuted = true
    elseif afk:get() and printExecuted then
        printExecuted = false 
    end
end
local function on_paint()   
    color_get = color:get()
    local r, g, b, a = color_get.r, color_get.g, color_get.b, color_get.a
    if checkbox:get() then
        if afk:get() then
            render.text(calibri, "AFK", vec2_t(ctx, cty), color_t(r, g, b, a))
        end
    end
end
callbacks.add(e_callbacks.RUN_COMMAND, afkgo)
callbacks.add(e_callbacks.RUN_COMMAND, shouldittalk)
callbacks.add(e_callbacks.PAINT, on_paint)