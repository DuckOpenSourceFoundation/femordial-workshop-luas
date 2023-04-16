local hook = require("primordial/hooking library.174");

ffi.cdef([[
    typedef struct {
        float x;
        float y;
        float z;
    } vec3_t;
]]);

local SetAbsAngles = ffi.cast("void(__thiscall*)(void*, const vec3_t*)",  memory.find_pattern("client.dll", "55 8B EC 83 E4 F8 83 EC 64 53 56 57 8B F1"));

local pLocal = nil;
local viewmodel_vec = ffi.new("vec3_t");
local time = 0;
local viewmodel_roll = menu.find("visuals", "view", "general", "viewmodel offsets", "roll add");

local override_viewmodel_angles = {
    [true] = function()
        for _, ent in pairs(entity_list.get_entities_by_classid(140)) do
            if ent:is_valid() then
                local ptr = ffi.cast("int*", ent:get_address());

                if not ptr then return end

                SetAbsAngles(ptr, viewmodel_vec)
            end
        end
    end;

    [false] = function() end;
};

callbacks.add(e_callbacks.AIMBOT_SHOOT, function(ctx)
    if not pLocal then return end

    local ang = ctx.shoot_pos:calc_angle_to(ctx.hitpoint_pos);

    viewmodel_vec.x = ang.x;
    viewmodel_vec.y = ang.y;
    viewmodel_vec.z = -viewmodel_roll:get();

    time = globals.cur_time();
end)


callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
    pLocal = entity_list.get_local_player();
end)

callbacks.add(e_callbacks.PAINT, function()
    if not engine.is_in_game() then pLocal, time = nil, 0; return end
    if not pLocal then return end

    if globals.cur_time() - time > 2 and time ~= 0 then time = 0; end
end)

client.delay_call(function()
    local IClient = hook.vmt.new(memory.create_interface("client.dll","VClient018"))
    IClient.hookMethod("void(__thiscall*)(void*, void*)", function(oFunc)
        return function(this, view_setup)
            override_viewmodel_angles[time ~= 0]()
    
            return oFunc(this, view_setup)
        end
    end, 27)

    callbacks.add(e_callbacks.SHUTDOWN, IClient.unHookAll)
end, 10.0)