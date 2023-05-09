local airstoptoggle = menu.add_checkbox("Accuracy", "Better Airstop")
local autostop = menu.find("aimbot", "scout", "accuracy", "autostop options")
local pos = 0
local lpos = 0

local function are_them_visibles(ent)
    local local_p = entity_list:get_local_player()
    local generic_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
    local left_arm_pos = ent:get_hitbox_pos(e_hitgroups.LEFT_ARM)
    local right_arm_pos = ent:get_hitbox_pos(e_hitgroups.RIGHT_ARM)
    if local_p:is_point_visible(generic_pos) or local_p:is_point_visible(left_arm_pos) or local_p:is_point_visible(right_arm_pos) then return true else return false end
end

local function airstop(cmd)
	local lplr = entity_list.get_local_player()
	local enemies = entity_list.get_players(true)
	local wep = lplr:get_active_weapon()
	if not airstoptoggle:get() then return end
	for i,v in ipairs(enemies) do
    if v == nil then return end
    if not v:is_valid() then return end
    if not v:is_alive() or not v:get_active_weapon() then return end
	pos = v:get_hitbox_pos(e_hitboxes.CHEST)
	lpos = lplr:get_hitbox_pos(e_hitboxes.CHEST)
	if lpos == nil or pos == nil then return end
	local air = lplr:get_prop("m_hGroundEntity") == -1
		if are_them_visibles(v) and pos:dist(lpos) <= 200 and air and wep:get_weapon_inaccuracy() <= 0.6 then
			autostop[3]:set(7, true)
		else
			autostop[3]:set(7, false)
		end
    end
end

callbacks.add(e_callbacks.SETUP_COMMAND, airstop)