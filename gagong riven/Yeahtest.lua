local TS =  module.internal('TS')
local gpred =  module.internal('pred')

local menu = module.load(header.id, 'menu')

local ai = module.load(header.id, 'core/ai')
local push = module.load(header.id, 'pred/push')

local spell = module.load(header.id, 'spell/main')
local pred = module.load(header.id, 'pred/main')

local crescent_wrapper = module.load(header.id, 'item/crescent_wrapper')

local e = module.load(header.id, 'spell/e')



local tick_n = 0
local function on_tick()
    tick_n = tick_n + 1
    if tick_n == 50 then

        -- print("e.slot.cooldown", e.slot.cooldown)
        -- print("e.slot.state", e.slot.state )
        -- local e = player:spellSlot(2)
        -- print("spell.startPos", spell.startPos)
        -- print("spell.endPos", spell.endPos)
        -- local a = player.pos:lerp(mousePos, 1)
        -- a:print()
        -- print("network.latency", network.latency)
        print("--------------")
        print(os.clock())
        player.pos:print()
        mousePos:print()
        print("--------------")
        -- print("v1",v1)
        -- print("a",a)
        cb.remove(on_tick)
        tick_n = 0
        cb.add(cb.tick,  on_tick)
    end
end


local function on_process_spell(spell)
    if spell.owner==player and spell.slot==1 then
        print("Spell.name", spell.name)
        print("Spell.windUpTime", spell.windUpTime)
        print("Spell.animationTime", spell.animationTime)
    end
end



cb.add(cb.spell, on_process_spell)



-- cb.add(cb.castspell, on_cast_spell)
cb.add(cb.tick, on_tick)
cb.add(cb.tick, yeahztest2)

return Yeahtest
