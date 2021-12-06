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
    if tick_n == 300 then

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
        -- print("isWall", navmesh.isWall(mousePos))
        -- print("isStructure", navmesh.isStructure(mousePos))
        -- local pos, is_grass = navmesh.wall_drop_pos(mousePos2D)
        -- print(mousePos2D.x,mousePos2D.y)
        -- print(pos.x,pos.y)
        print(mousePos.x,mousePos.y,mousePos.z)
        -- print(player.pos .x,mousePos.y,mousePos.z)
        -- print("player.direction",player.direction.x,player.direction.y,player.direction.z)
        -- print("player.direction2D",player.direction2D)

        -- pred.flash_w.invoke_action(true)
        -- if flash_w then
        --     print("flash_w.source",flash_w.source)
        --     print("pos",pos)
        --     print(core.cur_attack_target)
        -- end
        -- pred.e_flash_w.invoke_action(true)
        local slot = player:spellSlot(0)
        print(slot.stacks)
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


-- [09:20] spell.startPos  9190.0234375    53.026031494141
-- 7198.9057617188
-- [09:20] spell.startPos  9190.0234375    7198.9057617188
-- nil
-- [09:22] player.path.dashSpeed   783.8037109375
-- [09:22] s       0.31895740797269

-- [06:27] spell.startPos  9190    53.026031494141 7200
-- [06:27] spell.endPos    8977.4853515625 53.056053161621
-- 6953.486328125

local function on_process_spell(spell)
    if spell.owner==player and spell.slot==2 then
        print("spell.startPos",spell.startPos.x,spell.startPos.y,spell.startPos.z)
        print("spell.endPos",spell.endPos.x,spell.endPos.y,spell.endPos.z)
        if player.path.isDashing then
            print("player.path.dashSpeed", player.path.dashSpeed)
            local s = 250 / player.path.dashSpeed
            print("s", s)
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
        local move_endposition = mousePos
        if(navmesh.isWall(mousePos))
        then
            local notwallpos = navmesh.wall_drop_pos(mousePos2D)
            local move_endposition = vec3(notwallpos.x,notwallpos.y,mousePos.z)
        end
        if w then
            pred.w.invoke_action(true)
        end
        if not TS.selected then
            if e then
                player:castSpell('pos', 2, vec3(mousePos.x,mousePos.y,mousePos.z))
            end
        end
        if not player.path.isDashing and q then
            player:castSpell('pos', 0, vec3(mousePos.x,mousePos.y,mousePos.z))
        end
        -- player:move(move_endposition)
        player:move(move_endposition)
    end
end

local delayedActions, delayedActionsExecuter = {}, nil

local function DelayAction(func, delay, args)
    if not delayedActionsExecuter then
        function delayedActionsExecuter()
            for t, funcs in pairs(delayedActions) do
                if t <= game.time then
                    for i = 1, #funcs do
                        local f = funcs[i]
                        if f and f.func then
                            f.func(unpack(f.args or {}))
                        end
                    end
                    delayedActions[t] = nil
                end
            end
        end
        cb.add(cb.tick, delayedActionsExecuter)
    end
    local t = game.time + (delay or 0)
    if delayedActions[t] then
        delayedActions[t][#delayedActions[t] + 1] = {func = func, args = args}
    else
        delayedActions[t] = {{func = func, args = args}}
    end
end



local walljump = function ()
    if menu.flee:get() then
        local slot = player:spellSlot(0)
        -- local pp = player.pos + (player.direction - player.pos):norm() * 850
        local pp = vec3(8977.4853515625,53.056053161621,6953.486328125)
        local ppp = (player.direction):norm() * 350
        print(slot.stacks)
        print("pp",pp.x,pp.y,pp.z)
        print("ppp",ppp.x,ppp.y,ppp.z)
        local q = pred.q.get_spell_state()
        local e = pred.e.get_spell_state()
        local pos = vec3(9190.0234375,53.026031494141,7198.9057617188)
        if player.pos ~= pos then
            player:move(pos)
        end 
        print("player.pos",player.pos.x,player.pos.y,player.pos.z)
        print("player.pos:dist(pos)",player.pos:dist(pos))
        graphics.draw_circle(pos, 3, 1, 0xFFFFFFFF, 16) 
        graphics.draw_circle(pp, 3, 1, 0xFFFFFFFF, 16)
        if slot.stacks == 2 and player.pos:dist(pos) < 1.1 then
            if e then
                player:castSpell('pos', 2, pp)
                -- DelayAction(function() player:castSpell('pos', 2, pp) end,0.01)
            end
        end
        if not e and slot.stacks == 2 then
            -- graphics.draw_circle(player.pos, 3, 1, 0xFFFFFFFF, 16)
            DelayAction(function() player:castSpell('pos', 0, pp) end,0.1)
        end  
    end
end

orb.combat.register_f_pre_tick(function()
    walljump()
end)


-- cb.add(cb.castspell, on_cast_spell)
cb.add(cb.tick, on_tick)
cb.add(cb.tick, yeahztest2)

return Yeahtest
