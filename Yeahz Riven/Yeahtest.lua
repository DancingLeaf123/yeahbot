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
    if tick_n == 200 then

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
        local pos, is_grass = navmesh.wall_drop_pos(mousePos2D)
        -- print(mousePos2D.x,mousePos2D.y)
        -- print(pos.x,pos.y)
        local notwallpos = vec3(pos.x,mousePos.y,pos.y)
        print("mousePos",mousePos.x,mousePos.y,mousePos.z)
        print("player.pos",player.pos.x,player.pos.y,player.pos.z)
        local a = mousePos:dist(player.pos)
        local b = notwallpos:dist(player.pos)
        print(a)
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
-- [08:39] spell.startPos  10622.56640625  35.513870239258
-- 3475.2634277344
-- [08:39] spell.endPos    10104.634765625 -71.2406005859384047.8559570313
-- [08:39] mousePos        10078.6640625   -71.2404785156254054.9067382813
-- [08:39] player.pos      10549.985351563 41.717750549316
-- 3555.3498535156
-- [08:39] notwallpos      10048.895507813 -71.2404785156254032.755859375
-- [08:39] mouse to player dist    696.03189593133
-- [08:39] notwallpos to player dist       701.26106939819
-- [08:39] 3
-- [08:39] player.path.dashSpeed   1199.4805908203
-- [08:39] s       0.20842354758657
-- [08:42] mousePos        10129.559570313 -71.24072265625
-- 4024.4765625
-- [08:42] player.pos      10652.224609375 35.130912780762
-- 3499.001953125
-- [08:42] notwallpos      10098.895507813 -71.24072265625
-- 3982.755859375
-- [08:42] mouse to player dist    748.74376991168
-- [08:42] notwallpos to player dist       742.63440620109
-- [08:42] 3
-- [08:42] spell.startPos  10623.758789063 35.631958007813
-- 3499.5078125
-- [08:42] spell.endPos    10110.14453125  -71.2406005859384024.4760742188



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



 
-- [56:48] spell.startPos  8625.93359375, -71.240600585938, 6568.5268554688
-- [56:48] spell.endPos    8956.9736328125 53.059989929199
-- 6943.0625



-- [33:27] spell.startPos  10019.404296875 -71.240600585938 4044.154296875
-- [33:27] spell.endPos    10675.758789063 29.564165115356

-- [33:31] spell.startPos  9971.3828125    -71.240600585938 4058.9038085938
-- [33:31] spell.endPos    10618.94921875  34.361785888672
-- 3457.1430664063
 
local walljumpback = function ()
    if menu.flee:get() then
        local slot = player:spellSlot(0)
        -- local pp = player.pos + (player.direction - player.pos):norm() * 850
        -- local pp = vec3(10110.14453125,-71.240600585938,4024.4760742188)
        local pp = vec3(10618.94921875,34.361785888672,3457.1430664063)
        local ppp = (player.direction):norm() * 350
        local q = pred.q.get_spell_state()
        local e = pred.e.get_spell_state()
        -- local pos = vec3(10623.758789063, 35.631958007813, 3499.5078125) 
        local pos = vec3(9971.3828125,-71.240600585938, 4058.9038085938)
        graphics.draw_circle(pos, 3, 1, 0xFFFFFFFF, 16)
        if player.pos ~= pos then
            player:move(pos)
        end 
        print("player.pos",player.pos.x,player.pos.y,player.pos.z)
        print("player.pos:dist(pos)",player.pos:dist(pos))
        if slot.stacks == 2 and player.pos:dist(pos) < 2  then
            print("dist good")
            if e then
                player:castSpell('pos', 2, pp)
                -- DelayAction(function() player:castSpell('pos', 2, pp) end,0.01)
            end
        end
        if not e and slot.stacks == 2 then
            -- graphics.draw_circle(player.pos, 3, 1, 0xFFFFFFFF, 16)
            -- player:castSpell('pos', 0, pp)
            DelayAction(function() player:castSpell('pos', 0, pp) end,0.1) 
        end  
    end
end

-- [08:42] spell.startPos  10623.758789063 35.631958007813
-- 3499.5078125
-- [08:42] spell.endPos    10110.14453125,  -71.240600585938,4024.4760742188

orb.combat.register_f_pre_tick(function()
    -- walljump()
    -- walljumpback()
end)



local walldrumppos = {
    vec3(9190.0234375,53.026031494141,7198.9057617188),
    vec3(8977.4853515625,53.056053161621,6953.486328125),

    vec3(10623.758789063, 35.631958007813, 3499.5078125),
    vec3(10110.14453125,-71.240600585938,4024.4760742188),

    vec3(9971.3828125,-71.240600585938, 4058.9038085938),
    vec3(10618.94921875,34.361785888672,3457.1430664063),
}

local function on_draw()
    for i= 1, #walldrumppos do
        graphics.draw_circle(walldrumppos[i], 3, 1, 0xFFFFFFFF, 16)
    end
end
-- cb.add(cb.castspell, on_cast_spell)
cb.add(cb.tick, on_tick)
cb.add(cb.tick, yeahztest2)
cb.add(cb.draw, on_draw)

return Yeahtest
