local visual_recoil = menu.find("visuals", "view", "removals", "visual recoil");

callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
    if globals.tick_count() % 64 == 0 then
        visual_recoil:set(false)
        cvars.weapon_recoil_view_punch_extra:set_float(0)
        cvars.view_recoil_tracking:set_float(1)
    end
end)


callbacks.add(e_callbacks.SHUTDOWN, function()
    cvars.weapon_recoil_view_punch_extra:set_float(0.055)
    cvars.view_recoil_tracking:set_float(0.45)
end)