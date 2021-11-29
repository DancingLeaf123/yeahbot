local menu = module.load(header.id, 'menu')

local spell = module.load(header.id, 'spell/main')

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
        print("--------------")
        print("game.time", game.time)
        -- player.pos:print()
        -- mousePos:print()
        print("game.tickID", game.tickID)
        print("player.path.serverPos2D", player.path.serverPos2D)
        print("--------------")
 
        -- print("v1",v1)
        -- print("a",a)
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

-- cb.add(cb.castspell, on_cast_spell)
cb.add(cb.tick, on_tick)
cb.add(cb.tick, yeahztest2)

return Yeahtest
