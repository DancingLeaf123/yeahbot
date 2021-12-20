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
        if TS.selected then
            local a = TS.selected.pos:dist(player.pos)
            print(a)
        end
        local pos, is_grass = navmesh.wall_drop_pos(mousePos2D)
        local notwallpos = vec3(pos.x,mousePos.y,pos.y)
        local slot = player:spellSlot(0)
        -- if player.path.isDashing then
        --     print("player.path.dashSpeed", player.path.dashSpeed)
        --     local s = 250 / player.path.dashSpeed
        --     print("s", s)
        -- end
        -- local pred = module.internal('pred')
        -- local res = pred.core.get_pos_after_time(player, 0.5)
        -- print(('           %.2f-%.2f'):format(res.x, res.y))
        -- print(('player pos %.2f-%.2f'):format(player.pos2D.x, player.pos2D.y))
        -- print("game.tickID", game.tickID)
        -- print("game.time", game.time)
        cb.remove(on_tick)
        tick_n = 0
        cb.add(cb.tick,  on_tick)
    end
end

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



orb.combat.register_f_pre_tick(function()
    -- walljump()
    -- walljumpback()
end)



-- cb.add(cb.castspell, on_cast_spell)
-- cb.add(cb.tick, on_tick)
-- cb.add(cb.tick, yeahztest2)
-- cb.add(cb.draw, on_draw)
-- cb.add(cb.spell, on_process_spell)

return Yeahtest
