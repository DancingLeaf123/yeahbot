local orb = module.internal('orb')
local menu = module.load(header.id, 'menu')

local spell = module.load(header.id, 'spell/main')
local TS = module.internal('TS')
local core = module.load(header.id, 'core/main')

local pred = module.load(header.id, 'pred/main')

local items = module.internal('items')

local tick_n = 0
local function on_tick()
    tick_n = tick_n + 1
    if tick_n == 30 then

        -- print("e.slot.cooldown", e.slot.cooldown)
        -- print("e.slot.state", e.slot.state ) 
        -- local e = player:spellSlot(2)
        -- print("spell.startPos", spell.startPos)
        -- print("spell.endPos", spell.endPos)
        -- local a = player.pos:lerp(mousePos, 1)
        -- a:print()
        -- print("network.latency", network.latency)
        -- print("--------------")
        -- print("game.time", game.time)
        -- player.pos:print()
        -- mousePos:print()
        -- print("game.tickID", game.tickID)
        if TS.selected then
            local a = TS.selected.pos:dist(player.pos)
        -- local a = mousePos:distSqr(player.pos)
            print(a)
        end
        local q = pred.q.get_action_state()
        local e = pred.e.get_action_state()
        local e_q = pred.e_q.get_action_state()
        local r1 = pred.r1.get_action_state()
        local w = pred.w.get_action_state()
        -- local e_flash_q = pred.e_flash_q.get_action_state()
        local e_flash_w = pred.e_flash_w.get_action_state()
        local flash_w = pred.flash_w.get_action_state()
        -- print("e_flash_q.obj",e_flash_q.obj)
        -- print("q.obj",q.obj)
        -- print("e_flash_q.obj.ptr",e_flash_q.obj.ptr)
        -- print("q.obj.ptr",q.obj.ptr)

        -- pred.flash_w.invoke_action(true)
        if flash_w then
            print("flash_w.source",flash_w.source)
            print("pos",pos)
            print(core.cur_attack_target)
        end
        -- pred.e_flash_w.invoke_action(true)
        if player.path.isDashing then
            print("player.path.dashSpeed", player.path.dashSpeed)
            local s = 250 / player.path.dashSpeed
            print("s", s)
        end
        -- print("player.path.dashSpeed", player.path.dashSpeed)
        -- print("--------------")
        cb.remove(on_tick)
        tick_n = 0
        cb.add(cb.tick,  on_tick)
    end
end




local function on_process_spell(spell)
    if spell.owner==player and spell.slot == 2 then
        print("Spell.name", spell.name)
        print("Spell.windUpTime", spell.windUpTime)
        print("Spell.animationTime", spell.animationTime)
        for i, buff_name in ipairs(player.buff.keys) do
            print(i ,"buff_name",buff_name, player.buff[buff_name].name)
            print("buff_endTime ",player.buff[buff_name].endTime)
        end
    end
end

cb.add(cb.spell, on_process_spell)

local buff_active = function(name)
    for i = 0, player.buffManager.count - 1 do
      local buff = player.buffManager:get(i)
      if buff and buff.valid and buff.name == name and buff.endTime > game.time then
        return buff
      end
    end
end

local flee = function ()
    if menu.flee:get() then
        local q = pred.q.get_spell_state()
        local e = pred.e.get_spell_state()
        local w = pred.w.get_action_state()
        if w then
            pred.w.invoke_action(true)
        end
        if e then
            player:castSpell('pos', 2, vec3(mousePos.x,mousePos.y,mousePos.z))
        end
        if not e and not player.path.isDashing and q then
            player:castSpell('pos', 0, vec3(mousePos.x,mousePos.y,mousePos.z))
        end
        player:move(mousePos)
    end
end

orb.combat.register_f_pre_tick(function()
    flee()
end)
  

-- cb.add(cb.castspell, on_cast_spell)
cb.add(cb.tick, on_tick)
cb.add(cb.tick, yeahztest2)

return Yeahtest
