--Made By ! Reload#0001

local pixel = render.create_font("Smallest Pixel-7", 10, 20, e_font_flags.OUTLINE)

--binds
local isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable") -- get doubletap
local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") -- get hideshots
local isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable") -- get autopeek
local isSW = menu.find("misc","main","movement","slow walk", "enable") -- get Slow Walk

local AutoO = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local ScoutO = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local DeagleO = menu.find("aimbot", "deagle", "target overrides", "force min. damage")
local RevolverO = menu.find("aimbot", "revolver", "target overrides", "force min. damage")
local PistolO = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local AwpO = menu.find("aimbot", "awp", "target overrides", "force min. damage")
local Auto = menu.find("aimbot", "auto", "targeting","min. damage")
local Scout = menu.find("aimbot", "scout", "targeting","min. damage")
local Deagle = menu.find("aimbot", "deagle", "targeting","min. damage")
local Revolver = menu.find("aimbot", "revolver", "targeting","min. damage")
local Pistol = menu.find("aimbot", "pistols", "targeting","min. damage")
local Awp = menu.find("aimbot", "awp", "targeting","min. damage")

local AutoFO = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local ScoutFO = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local DeagleFO = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage"))
local RevolverFO = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local PistolFO = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))
local AwpFO = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))

local isBA = menu.find("aimbot", "scout", "target overrides", "force hitbox") -- get froce baim
local isSP = menu.find("aimbot", "scout", "target overrides", "force safepoint") -- get safe point
local isAA = menu.find("antiaim", "main", "angles", "yaw base") -- get yaw base

local function getweapon()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end

    local weapon_name = nil

    if local_player:get_prop("m_iHealth") > 0 then
    
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end

        weapon_name = active_weapon:get_name()


    else return end

    return weapon_name

end

--indicators
local fake = antiaim.get_fake_angle()
local currentTime = global_vars.cur_time
local function indicators2()
    if not engine.is_connected() then
        return
    end

    if not engine.is_in_game() then
        return
    end

    local local_player = entity_list.get_local_player()

    if not local_player:get_prop("m_iHealth") then
        return
    end
    --screen size
    local x = render.get_screen_size().x
    local y = render.get_screen_size().y

    --invert state
    if antiaim.is_inverting_desync() == false then
        invert ="R"
    else
        invert ="L"
    end

    --screen size
    local ay = 40
    local alpha = math.min(math.floor(math.sin((global_vars.real_time()%3) * 4) * 175 + 50), 255)
    if local_player:is_alive() then -- check if player is alive
    --render
    local eternal_ts = render.get_text_size(pixel, "ACATEL ")
    render.text(pixel, "ACATEL", vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
    render.text(pixel, "BETA", vec2_t(x/2+eternal_ts.x-2, y/2+ay), color_t(255, 130, 130, alpha), 10, true)
    ay = ay + 10.5
    
    local text_ =""
    local clr0 = color_t(0, 0, 0, 0)
    if isSW[2]:get() then
        text_ ="DANGEROUS+ "
        clr0 = color_t(255, 50, 50, 255)
    else
        text_ ="DYNAMIC- "
        clr0 = color_t(255, 117, 107, 255)
    end

    local d_ts = render.get_text_size(pixel, text_)
    render.text(pixel, text_, vec2_t(x/2, y/2+ay), clr0, 10, true)
    render.text(pixel, math.floor(fake).."", vec2_t(x/2+d_ts.x, y/2+ay), color_t(255, 255, 255, 255), 10, true)
    ay = ay + 10.5
    
    local fake_ts = render.get_text_size(pixel, "FAKE YAW: ")
    render.text(pixel, "FAKE YAW:", vec2_t(x/2, y/2+ay), color_t(130, 130, 255, 255), 10, true)
    render.text(pixel, invert, vec2_t(x/2+fake_ts.x, y/2+ay), color_t(255, 255, 255, 255), 10, true)
    ay = ay + 10.5

    local asadsa = math.min(math.floor(math.sin((exploits.get_charge()%2) * 1) * 122), 100)
    if isAP[2]:get() and isDT[2]:get() then 
        local ts_tick = render.get_text_size(pixel, "IDEALTICK ")
        render.text(pixel, "IDEALTICK", vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
        render.text(pixel, "x"..asadsa, vec2_t(x/2+ts_tick.x, y/2+ay), exploits.get_charge() == 1 and color_t(0, 255, 0, 255) or color_t(255, 0, 0, 255), 10, true)
        ay = ay + 10.5
    else
        if isAP[2]:get() then
            render.text(pixel, "PEEK", vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
        if isDT[2]:get() then
        if exploits.get_charge() >= 1 then
            render.text(pixel, "DT", vec2_t(x/2, y/2+ay), color_t(0, 255, 0, 255), 10, true)
            ay = ay + 10.5
        end
        if exploits.get_charge() < 1 then
            render.text(pixel, "DT", vec2_t(x/2, y/2+ay), color_t(255, 0, 0, 255), 10, true)
            ay = ay + 10.5
        end
    end
    end
    --render.text(pixel, "MD: "..tostring(amount_awp:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
    if getweapon() == "ssg08" then
        if ScoutO[2]:get() then
            render.text(pixel, "MD: "..tostring(ScoutFO:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "deagle" then
        if DeagleO[2]:get() then
            render.text(pixel, "MD: "..tostring(DeagleFO:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "revolver" then
        if RevolverO[2]:get() then
            render.text(pixel, "MD: "..tostring(RevolverFO:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "awp" then
        if AwpO[2]:get() then
            render.text(pixel, "MD: "..tostring(AwpFO:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
        if AutoO[2]:get() then
            render.text(pixel, "MD: "..tostring(AutoFO:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
    elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
        if PistolO[2]:get() then
            render.text(pixel, "MD: "..tostring(PistolFO:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
    end

    local ax = 0
    if isHS[2]:get() then
        render.text(pixel, "ONSHOT", vec2_t(x/2, y/2+ay), color_t(250, 173, 181, 255), 10, true)
        ay = ay + 10.5
    end

    render.text(pixel, "BAIM", vec2_t(x/2, y/2+ay), isBA[2]:get() == 2 and color_t(255, 255, 255, 255) or color_t(255, 255, 255, 128), 10, true)
    ax = ax + render.get_text_size(pixel, "BAIM ").x

    render.text(pixel, "FS", vec2_t(x/2+ax, y/2+ay), isAA:get() == 5 and color_t(255, 255, 255, 255) or color_t(255, 255, 255, 128), 10, true)
end
end

--callback
callbacks.add(e_callbacks.PAINT,indicators2)