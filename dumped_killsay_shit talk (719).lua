local kill_say = {}
local ui = {}
kill_say.phrases = {}

-- just found all phrases on github
table.insert(kill_say.phrases, {
    name = "shit talk",
    phrases = {
        "shit on by uid 2k on primordial.dev  ",
        "femboy cheat just 1nd you  ",
        "ducarii would be happy his cheat hits  ",
        "neverlose user sit get femboy cheat  ",
        "onetap? didnt that get updated like 2 yrs ago  ",
        "gamesense.pub ego user getting 1nd by primordial.dev like always   ",
        "primordial.dev #1 cheat tappin gamesense paste on daily   ",
        "primordial.dev been tappin all cheats since 2020   ",
        "fuck crack users   ",


    }
})

table.insert(kill_say.phrases, {
    name = "cumming soon",
    phrases = {
   
    }
})

table.insert(kill_say.phrases, {
    name = "cumming soon",
    phrases = {
       
    }
})

table.insert(kill_say.phrases, {
    name = "cumming soon",
    phrases = {
 
    }
})

table.insert(kill_say.phrases, {
    name = "cumming soon",
    phrases = {

    }
})

table.insert(kill_say.phrases, {
    name = "cumming soon",
    phrases = {

    }
})

table.insert(kill_say.phrases, {
    name = "cumming soon",
    phrases = {
 
    }
})

table.insert(kill_say.phrases, {
    name = "cumming soon",
    phrases = {
    
    }
})

table.insert(kill_say.phrases, {
    name = "cumming soon",
    phrases = {
 
    }
})

ui.group_name = "Shit Say"
ui.is_enabled = menu.add_checkbox(ui.group_name, "Shit Say", false)

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