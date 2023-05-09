local ffi = require("ffi")
local json = require("primordial/JSON Library.97")
local httpFactory = require("primordial/Lightweight HTTP Library.46")
local kill_say = {}
local ui = {}
kill_say.phrases = {}
local pitch = menu.find("antiaim","main", "angles","pitch")
local lib = require("primordial/Player state library.641")
local enable = menu.add_checkbox("Pitch and Spin Exploit", "Enable")
local selection = menu.add_multi_selection("Pitch and Spin Exploit", "Exploit When", {"Standing", "Running", "Slowwalk", "Crouch", "Jump", "Jump-Crouch"})
local slider = menu.add_slider("Pitch and Spin Exploit", "Speed", 1, 100)
--yaw set changes
local lib = require("primordial/Player state library.641")
menu.add_text("Pitch and Spin Exploit", "SPIN EXPLOIT BELOW")
local enable2 = menu.add_checkbox("Pitch and Spin Exploit", "Enable")
local enable3 = menu.add_checkbox("Pitch and Spin Exploit", "only when vis - Buggy")
local selection2 = menu.add_multi_selection("Pitch and Spin Exploit", "Def Spin When", {"Standing", "Running", "Slowwalk", "Crouch", "Jump", "Jump-Crouch"})
local slider2 = menu.add_slider("Pitch and Spin Exploit", "Spin Speed", 1, 100)
local slider3 = menu.add_slider("Pitch and Spin Exploit", "Velocity threshold", 0, 1000)


--[[
    Filesystem Library
--]]

local filesystem = {} filesystem.__index = filesystem filesystem.char_buffer = ffi.typeof("char[?]")
filesystem.table = ffi.cast(ffi.typeof("void***"), memory.create_interface("filesystem_stdio.dll", "VBaseFileSystem011"))

filesystem.v_funcs = {
	file_read = ffi.cast(ffi.typeof("int(__thiscall*)(void*, void*, int, void*)"), filesystem.table[0][0]),
    file_open = ffi.cast(ffi.typeof("void*(__thiscall*)(void*, const char*, const char*, const char*)"), filesystem.table[0][2]),
    file_close = ffi.cast(ffi.typeof("void*(__thiscall*)(void*, void*)"), filesystem.table[0][3]),
    file_size = ffi.cast(ffi.typeof("unsigned int(__thiscall*)(void*, void*)"), filesystem.table[0][7]),
}

function filesystem.read_file(path)
	local handle = filesystem.v_funcs.file_open(filesystem.table, path, "r", "MOD")
	if (handle == nil) then return end

	local filesize = filesystem.v_funcs.file_size(filesystem.table, handle)
	if (filesize == nil or filesize < 0) then return end

	local buffer = filesystem.char_buffer(filesize + 1)
	if (buffer == nil) then return end

	if (not filesystem.v_funcs.file_read(filesystem.table, buffer, filesize, handle)) then return end

	filesystem.v_funcs.file_close(filesystem.table, handle)

	return ffi.string(buffer, filesize)
end

local file_text = filesystem.read_file("../primordial/scripts/token.txt") -- Engine Read File

local http = httpFactory.new({
    task_interval = 0.3, -- polling intervals
    enable_debug = false, -- print http requests to the console
    timeout = 10 -- request expiration time
})

local c_hud_chat =
    ffi.cast("unsigned long(__thiscall*)(void*, const char*)", memory.find_pattern("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28"))(
    ffi.cast("unsigned long**", ffi.cast("uintptr_t", memory.find_pattern("client.dll", "B9 ?? ?? ?? ?? E8 ?? ?? ?? ?? 8B 5D 08")) + 1)[0],
    "CHudChat"
)

local ffi_print_chat = ffi.cast("void(__cdecl*)(int, int, int, const char*, ...)", ffi.cast("void***", c_hud_chat)[0][27])

local function PrintChat(msg)
    ffi_print_chat(c_hud_chat, 0, 0, " \x06[spotify.lua] ♫ \x01" .. msg)
end

local refreshkey = nil
local apikey = nil
local SetClanTag = ffi.cast("int(__fastcall*)(const char*)", memory.find_pattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15"));
local isNowPlaying = nil
local deviceid = ""
local ShuffleState = false
local RealVolume = 0
local CacheVolume = 0
local artist = nil
local trackname = nil
local lasttrack = nil
local IsTag = false
local lastupdate = 0
local tagtoset = nil
local tagsize = nil
local ApiTokenRequest = 0

if (file_text) then
	refreshkey = file_text
end

--[[ menu ]]--
local clantagCheckbox = menu.add_checkbox("Spotify", "Clantag", false)
local volumeSlider = menu.add_slider("Spotify", "Volume", 0, 100, 1, 0, "%")
local text = menu.add_text("idiots", "Spotify.lua Fixed by Zxre")
menu.add_text("idiots", "if you cant read instructions here's how you get it to work with spotify")
menu.add_text("idiots", "when you get your token make sure")
menu.add_text("idiots", "to put it here /primordial/scripts/token.txt")
menu.add_text("idiots", "MAKE SURE THERE IS A NAMED token.txt ALL LOWER CASE")
menu.add_button("Spotify", "Refresh", function()
	apikey = nil
    refreshkey = filesystem.read_file("../primordial/scripts/token.txt")
	ApiTokenRequest = 0
end)

	http:request("put", "https://api.spotify.com/v1/me/player/shuffle?device_id=" .. deviceid .. "&state=" .. tostring(ShuffleState), options, function(s, r)
		PrintChat("Shuffle: " .. tostring(ShuffleState))
	end)

local function getAPItoken()
	if refreshkey == nil then return end

	if ApiTokenRequest == 0 then
		ApiTokenRequest = 1
		http:get("https://spotify.stbrouwers.cc/refresh_token?refresh_token=" .. refreshkey, function(data)
			if (data:success()) then
				local parsed = json.parse(data.body)
				apikey = parsed.access_token
				print("Logged in")
				PrintChat("Logged in")
			else
				print("WRONGKEY")
			end
		end)
	end
end

local function updateVariables()
    lastupdate = math.floor(global_vars.real_time())

	http:get("https://api.spotify.com/v1/me/player?access_token=" .. apikey, function(data)
		if (data:success()) then
			local currentpaska = json.parse(data.body)
			if currentpaska == nil then return end
			deviceid = currentpaska.device.id
			isNowPlaying = currentpaska.is_playing
			ShuffleState = currentpaska.shuffle_state
			RepeatState = currentpaska.repeat_state
			RealVolume = currentpaska.device.volume_percent

			if CacheVolume ~= RealVolume then
				CacheVolume = RealVolume
				volumeSlider:set(RealVolume)
			elseif volumeSlider:get() ~= RealVolume then
				local options = {
					headers = {
						["Accept"] = "application/json",
						["Content-Type"] = "application/json",
						["Authorization"] = "Bearer " .. apikey,
						["Content-length"] = 0
					}
				}
	
				http:request("put", "https://api.spotify.com/v1/me/player/volume?volume_percent=" .. volumeSlider:get() .. "&device_id=" .. deviceid, options, function(s, r)
					print(apikey)
					print(deviceid)
					print(options)
				end)
				CacheVolume = volumeSlider:get()
				RealVolume = volumeSlider:get()
			end
	
			if isNowPlaying then
				artist = currentpaska.item.artists[1].name;
				trackname = currentpaska.item.name;
				tagtoset = " " .. artist .. " - " .. trackname;
				tagsize = string.len(tagtoset.." | ");
			end
		else
			print("Failed getting new values")
        end
	end)
end

local function spotifyTag()
    if apikey == nil then
		getAPItoken();
    return end
    --if testi1 == false then
    --    updateVariables();
    --return end
	if (math.floor(global_vars.real_time()) % 1 == 0 and not(math.floor(global_vars.real_time()) == lastupdate)) then
		updateVariables();
	end

	local connected = not(entity_list.get_local_player() == nil);
	if not connected then return end

	if lasttrack ~= trackname then
		PrintChat("Changed song to " .. trackname .. " by " .. artist)
		lasttrack = trackname
	end

	if not clantagCheckbox:get() then
		if IsTag == true then
			SetClanTag("")
			IsTag = false
		end
	end

	if connected and clantagCheckbox:get() then
		if global_vars.tick_count() % 32 == 0 then
			if isNowPlaying then
				local curClantag = "";
				for i=0,tagsize
				do
					local curLetter = i + (global_vars.tick_count() / 32);
					curClantag = curClantag .. string.sub(tagtoset.." | ",(curLetter % tagsize),(curLetter % tagsize));
				end
				SetClanTag("" .. curClantag);
			else
				SetClanTag("⌛ spotify.lua");
			end
			IsTag = true
		end
	end
end

callbacks.add(e_callbacks.PAINT, on_paint)

callbacks.add(e_callbacks.PAINT, spotifyTag)

callbacks.add(e_callbacks.SHUTDOWN, function()
	SetClanTag("")
end)

-- just found all phrases on github
table.insert(kill_say.phrases, {
    name = "spotify say FR",
    phrases = {
        "lol 1nd by a music lua?  ",
        "get spotify.lua fixed by uid 2665 on primoridal.dev  ",
        "bro prob not listening to music thats why he got 1nd  ",
        "bro uses cracked cheats :skull:  ",
        "id love to listen to music w you but YOU DONT HAVE PREMIUM HAHAH  ",
        "timehack with spotify.lua makes you tap more   ",
        "pro lua paster frrrrrr   ",
        "MUSIC = LIFE   ",
        "MUSIC > EVERYTHING   ",


    }
})

ui.group_name = "killsay"
ui.is_enabled = menu.add_checkbox(ui.group_name, "killsay", false)

ui.current_list = menu.add_selection(ui.group_name, "Phrase List", (function()
    local tbl = {}
    for k, v in pairs(kill_say.phrases) do
        table.insert(tbl, ("%d. %s"):format(k, v.name))
    end

    return tbl
end)())

kill_say.player_death = function(event)

    if event.attacker == event.userid or not ui.is_enabled:get() then
        return
    end

    local attacker = entity_list.get_player_from_userid(event.attacker)
    local localplayer = entity_list.get_local_player()

    if attacker ~= localplayer then
        return
    end

    local current_killsay_list = kill_say.phrases[ui.current_list:get()].phrases
    local current_phrase = current_killsay_list[client.random_int(1, #current_killsay_list)]:gsub('\"', '')
    
    engine.execute_cmd(('say "%s"'):format(current_phrase))
end

callbacks.add(e_callbacks.EVENT, kill_say.player_death, "player_death")

local local_player = entity_list.get_local_player()

local function pitch1(ctx)
    local player_state = lib.get_state()
  if enable:get() then
    if player_state == 1 then
        if selection:get(1)then
            if not local_player then
                return
            end
            if globals.tick_count() % slider:get() * 2 == 0 or globals.tick_count() % slider:get() == 0 then
                ctx:set_pitch(-89)
            end
        else
            return
        end
    elseif player_state == 2 then
        if selection:get(2)then
            if not local_player then
                return
            end
            if globals.tick_count() % slider:get() * 2 == 0 or globals.tick_count() % slider:get() == 0 then
                ctx:set_pitch(-89)
            end
        else
            return
        end
    elseif player_state == 3 then
        if selection:get(3)then
            if not local_player then
                return
            end
            if globals.tick_count() % slider:get() * 2 == 0 or globals.tick_count() % slider:get() == 0 then
                ctx:set_pitch(-89)
            end
        else
            return
        end
    elseif player_state == 4 then
        if selection:get(4)then
            if not local_player then
                return
            end
            if globals.tick_count() % slider:get() * 2 == 0 or globals.tick_count() % slider:get() == 0 then
                ctx:set_pitch(-89)
            end
        else
            return
        end
    elseif player_state == 5 then
        if selection:get(5)then
            if not local_player then
                return
            end
            if globals.tick_count() % slider:get() * 2 == 0 or globals.tick_count() % slider:get() == 0 then
                ctx:set_pitch(-89)
            end
        else
            return
        end
    elseif player_state == 6 then
        if selection:get(6)then
        if not local_player then
            return
        end
        if globals.tick_count() % slider:get() * 2 == 0 or globals.tick_count() % slider:get() == 0 then
            ctx:set_pitch(-89)
        end
    else
        return
    end
    end
end
end
callbacks.add(e_callbacks.ANTIAIM, pitch1)

local yaw_value = 180
local local_player = entity_list.get_local_player()
local velocity_history = {}
local last_velocity = 0
local yaw = menu.find("antiaim","main", "angles","yaw add")

local function are_have_weapon(ent)
    if not ent:is_alive() or not ent:get_active_weapon() then return end
    local t_cur_wep = ent:get_active_weapon():get_class_name()
    return t_cur_wep ~= "CKnife" and t_cur_wep ~= "CC4" and t_cur_wep ~= "CMolotovGrenade" and t_cur_wep ~= "CSmokeGrenade" and t_cur_wep ~= "CHEGrenade" and t_cur_wep ~= "CWeaponTaser"
end
local function are_them_visibles(ent)
    local local_p = entity_list:get_local_player()
    local generic_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
    local left_arm_pos = ent:get_hitbox_pos(e_hitgroups.LEFT_ARM)
    local right_arm_pos = ent:get_hitbox_pos(e_hitgroups.RIGHT_ARM)
    if local_p:is_point_visible(generic_pos) or local_p:is_point_visible(left_arm_pos) or local_p:is_point_visible(right_arm_pos) then return true else return false end
end



local function on_setup_command()
    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    local velocity = local_player:get_prop("m_vecVelocity"):length()
    velocity = math.floor(velocity + 0.5)

    table.insert(velocity_history, 1, velocity)
    if #velocity_history > 50 then
        table.remove(velocity_history, #velocity_history)
    end
end

local function spin()
    if globals.frame_count() % 2 * 1 == 0 or globals.frame_count() % 2 == 0 then
        yaw_value = yaw_value - slider2:get()
        if yaw_value < -180 then
            yaw_value = 180
        end
        
    end
end

function on_antiaim(ctx)
    local max_charge = exploits.get_max_charge()
    local cur_charge = exploits.get_charge()
    local last_velocity = velocity_history[1] or 0
    local last_delta = last_velocity - (velocity_history[2] or 0)
    local player_state = lib.get_state()
    if enable2:get() then
        if player_state == 1 then
            if selection2:get(1)then
                if enable3:get()then
                    if ragebot.get_autopeek_pos() then return end
                    local enemies = entity_list.get_players(true)
                    if cur_charge > 12 and last_velocity > slider3:get()then
                        for i,v in ipairs(enemies) do
                            if are_them_visibles(v) and are_have_weapon(v) then
                                ctx:set_yaw(yaw_value)
                                ctx:set_pitch(0)
                            end
                        end
                    end
                else
                    if cur_charge > 12 and last_velocity > slider3:get() then
                        ctx:set_yaw(yaw_value)
                        ctx:set_pitch(0)
                    end
                end
            end
        elseif player_state == 2 then
            if selection2:get(2)then
                if enable3:get()then
                    if ragebot.get_autopeek_pos() then return end
                    local enemies = entity_list.get_players(true)
                    if cur_charge > 12 and last_velocity > slider3:get()then
                        for i,v in ipairs(enemies) do
                            if are_them_visibles(v) and are_have_weapon(v) then
                                ctx:set_yaw(yaw_value)
                                ctx:set_pitch(0)
                            end
                        end
                    end
                else
                    if cur_charge > 12 and last_velocity > slider3:get() then
                        ctx:set_yaw(yaw_value)
                        ctx:set_pitch(0)
                    end
                end
            end
        elseif player_state == 3 then
            if selection2:get(3)then
                if enable3:get()then
                    if ragebot.get_autopeek_pos() then return end
                    local enemies = entity_list.get_players(true)
                    if cur_charge > 12 and last_velocity > slider3:get()then
                        for i,v in ipairs(enemies) do
                            if are_them_visibles(v) and are_have_weapon(v) then
                                ctx:set_yaw(yaw_value)
                                ctx:set_pitch(0)
                            end
                        end
                    end
                else
                    if cur_charge > 12 and last_velocity > slider3:get() then
                        ctx:set_yaw(yaw_value)
                        ctx:set_pitch(0)
                    end
                end
            end
        elseif player_state == 4 then
            if selection2:get(4)then
                if enable3:get()then
                    if ragebot.get_autopeek_pos() then return end
                    local enemies = entity_list.get_players(true)
                    if cur_charge > 12 and last_velocity > slider3:get()then
                        for i,v in ipairs(enemies) do
                            if are_them_visibles(v) and are_have_weapon(v) then
                                ctx:set_yaw(yaw_value)
                                ctx:set_pitch(0)

                            end
                        end
                    end
                else
                    if cur_charge > 12 and last_velocity > slider3:get() then
                        ctx:set_yaw(yaw_value)
                        ctx:set_pitch(0)
                    end
                end
            end
        elseif player_state == 5 then
            if selection2:get(5)then
                if enable3:get()then
                    if ragebot.get_autopeek_pos() then return end 
                    local enemies = entity_list.get_players(true)
                    if cur_charge > 12 and last_velocity > slider3:get()then
                        for i,v in ipairs(enemies) do
                            if are_them_visibles(v) and are_have_weapon(v) then
                                ctx:set_yaw(yaw_value)
                                ctx:set_pitch(0)
                            end
                        end
                    end
                else
                    if cur_charge > 12 and last_velocity > slider3:get() then
                        ctx:set_yaw(yaw_value)
                        ctx:set_pitch(0)
                    end
                end
            end
        elseif player_state == 6 then
            if enable3:get()then
                if ragebot.get_autopeek_pos() then return end
                local enemies = entity_list.get_players(true)
                if cur_charge > 12 and last_velocity > slider3:get()then
                    for i,v in ipairs(enemies) do
                        if are_them_visibles(v) and are_have_weapon(v) then
                            ctx:set_yaw(yaw_value)
                            ctx:set_pitch(0)
                        end
                    end
                end
            else
                if cur_charge > 12 and last_velocity > slider3:get() then
                    ctx:set_yaw(yaw_value)
                    ctx:set_pitch(0)
                end
            end
        end
    end
end

callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)
callbacks.add(e_callbacks.PAINT, function()
    spin()
end)

indicators = menu.add_multi_selection("skeet.cc", "indicators", {"DoubleTap", "Lethal","Min DMG", "Hide Shots", "FakeDuck","Ping","Safe Point","Hitbox OVR", "Hitchance OVR"})
local screen_size = render.get_screen_size()
local font = render.create_font("Calibri Bold", 27, 670, e_font_flags.ANTIALIAS)
local color2 = color_t(255, 255, 255, 255)
local color3 = color_t(255, 0, 0, 255)
local col_1 = color_t(0, 0, 0, 150)
local col_2 = color_t(0, 0, 0, 0)
local fontsigma = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS)

local groups = {
    auto = {0},
    scout = {1},
    awp = {2},
    deagle = {3},
    revolver = {4},
    pistols = {5},
    other = {6}
}

local math_funcs = { -- Thanks to LosKitten1 https://primordial.dev/resources/another-indicator-lua.107/

    get_min_dmg = function(wpn_type) -- // thnx classy.
        local menu_ref = menu.find("aimbot", wpn_type, "target overrides", "force min. damage")
        local force_lethal = menu.find("aimbot", wpn_type, "target overrides", "force lethal shot")
        local hitbox_ovr = menu.find("aimbot", wpn_type, "target overrides", "force hitbox")
        local force_sp = menu.find("aimbot", wpn_type, "target overrides", "force safepoint")
        local force_hc = menu.find("aimbot", wpn_type, "target overrides", "force hitchance")
        return {menu_ref[1]:get(), menu_ref[2]:get(), force_lethal[2]:get(), hitbox_ovr[2]:get(), force_sp[2]:get(),
                force_hc[2]:get()}
    end,
    vars = {
        angle = 0
    }
}

local function calcs()
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end
    if not local_player:is_alive() then
        math_funcs.vars.angle = 0

    else
        math_funcs.vars.angle = antiaim.get_max_desync_range()
    end
end

callbacks.add(e_callbacks.ANTIAIM, calcs)

local groups = {
    ['auto'] = 0,
    ['scout'] = 1,
    ['awp'] = 2,
    ['deagle'] = 3,
    ['revolver'] = 4,
    ['pistols'] = 5,
    ['other'] = 6,

}
local current_min = nil
local key_active = nil
local force_lethal = nil
local hitbox_ovr = nil
local force_sp = nil
local force_hc = nil

local function get_weapon_group() -- // Classy also did a func like this, might be better not sure.
    for key, value in pairs(groups) do
        if value == ragebot.get_active_cfg() then
			local states = math_funcs.get_min_dmg(key)
		
            current_min = states[1]
            key_active = states[2]
            force_lethal = states[3]
            hitbox_ovr = states[4]
            force_sp = states[5]
            force_hc = states[6]
        end
    end

    return {tostring(current_min), key_active, force_lethal, hitbox_ovr, force_sp, force_hc}
end

local dt_ref = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable")
local fakeping_ref = menu.find("aimbot", "general", "fake ping", "enable")

local function gradient(x, y, w, h, col1, col2)
    render.rect_fade(vec2_t(x, y - 4), vec2_t(w / 4, h), col2, col1, true)
    render.rect_fade(vec2_t(x + (w / 4), y - 4), vec2_t(w / 4, h), col1, col2, true)
end

local function dnn()
    local maxdes = math_funcs.vars.angle
    local local_player = entity_list.get_local_player()
	
    if not local_player or not local_player:is_alive() then
        return
    end
    
    local pos = vec2_t(0, 0)
    local addpos = vec2_t(0, 32)
    local startpos = vec2_t(screen_size.x * 0.00741666666, screen_size.y * 0.67777777777)
	
	local wpn = get_weapon_group()

	local function default(str, color)
		local text_size = render.get_text_size(font, str)
		gradient(9, pos.y + 4, 70, 28, col_1, col_2)
		render.text(font, str, pos, color)
		pos = pos - addpos
	end

	local function circle(str, color, percent)
		local text_size = render.get_text_size(font, str)
		gradient(9, pos.y + 4, 70, 28, col_1, col_2)
		render.text(font, str, pos, color)
		render.progress_circle(pos + vec2_t(text_size.x * 1.3, text_size.y / 1.9), 5, color_t(0, 0, 0, 155), 3, 1)
		render.progress_circle(pos + vec2_t(text_size.x * 1.3, text_size.y / 1.9), 5, color, 3, percent)
		pos = pos - addpos
	end

    pos = startpos
	
    if indicators:get('Min DMG') and wpn[2] then
        default("DMG: " .. wpn[1], color2)
    end

    if indicators:get("Lethal") and wpn[3] then
        default("LETHAL", color2)
    end

    if indicators:get('Hitbox OVR') and wpn[4] then
        default("HITBOX OVR", color2)
    end
    
    if indicators:get('Hitchance OVR') and wpn[6] then
        default("HITCHANCE OVR", color2)
    end

    if indicators:get('Safe Point') and wpn[5] then
        default("SAFE", color2)
    end

    if indicators:get('FakeDuck') and antiaim.is_fakeducking() then
        default("DUCK", color2)
    end

    if indicators:get("Hide Shots") and hideshots[2]:get() then
        default("ONSHOT", color_t(150, 200, 60, 255))
    end
    
	if indicators:get("Ping") and fakeping_ref[2]:get() then
		default("PING", color_t(170, 237, 78, 255))
	end

    if dt_ref[2]:get() and indicators:get('DoubleTap') then
        if exploits.get_charge() == 14 then
            default("DT", color2)
        else
            default("DT", color3)
        end
    end
end

callbacks.add(e_callbacks.PAINT, dnn)

local calibri = render.create_font("Calibri", 29, 700, e_font_flags.ANTIALIAS)
local main_font = render.create_font("Calibri", 12, 400)
local screen_size = render.get_screen_size() -- screen
local ctx = screen_size.x / 2
local cty = screen_size.y / 2
local x = screen_size.x / 2
local y = screen_size.y / 2

local dt_ref = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable")
local force_baim = menu.find("aimbot", "scout", "target overrides", "force hitbox")
local min_damage = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local lethal = menu.find("aimbot", "revolver", "target overrides", "force lethal shot")

local enabled = true

-- weapon damages

local min_damage_a = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local min_damage_s = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local min_damage_r = menu.find("aimbot", "revolver", "target overrides", "force min. damage")
local min_damage_d = menu.find("aimbot", "deagle", "target overrides", "force min. damage")
local min_damage_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local min_damage_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage")

local amount_auto = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local amount_scout = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local amount_awp = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))
local amount_revolver = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local amount_deagle = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage"))
local amount_pistol = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))

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