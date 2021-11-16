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
    if tick_n == 120 then
        print("e.slot.cooldown", e.slot.cooldown)
        print("e.slot.state", e.slot.state )
        print("player.pos2D", player.pos2D, type(player.pos2D))
        print("mousePos2D", mousePos2D, type(mousePos2D))
        local a = player.pos2D:lerp(mousePos2D, 0.5)
        a:print()
        -- print("network.latency", network.latency)
        cb.remove(on_tick)
        tick_n = 0
        cb.add(cb.tick, on_tick)
    end
end





cb.add(cb.tick, on_tick)
cb.add(cb.tick, yeahztest2)

return Yeahtest
