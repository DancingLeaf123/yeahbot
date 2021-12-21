local orb = module.internal('orb')
local TS =  module.internal('TS')
local gpred =  module.internal('pred')

local menu = module.load(header.id, 'menu')

local ai = module.load(header.id, 'core/ai')
local push = module.load(header.id, 'pred/push')

local spell = module.load(header.id, 'spell/main')
local pred = module.load(header.id, 'pred/main')



local draw_Q_range = function ()
    graphics.draw_circle(player.pos, spell.q.radius(), 2, 0xff8fbe93, 64)
end

local draw_W_range = function ()
    graphics.draw_circle(player.pos, spell.w.radius(), 2, 0xff7ddd6b, 64)
end

local VextorExtend =function(a, b, dist) return a + dist * (b-a):norm() end

local target_near_range = function ()

    graphics.draw_circle(VextorExtend(player.pos, mousePos, 225), spell.q.radius(), 2, 0xff8fbe93, 64)
    if orb.core.cur_attack_target then
        graphics.draw_circle(orb.core.cur_attack_target.pos, 150, 2, 0xff8fbe93, 64)
        graphics.draw_circle(orb.core.cur_attack_target.pos, 225, 2, 0xff8fbe93, 64)
    end
end



return {
    draw_W_range = draw_W_range,
    draw_Q_range = draw_Q_range,
    target_near_range = target_near_range,
}