local TS =  module.internal('TS')
local gpred =  module.internal('pred')

local menu = module.load(header.id, 'menu')

local ai = module.load(header.id, 'core/ai')
local push = module.load(header.id, 'pred/push')

local spell = module.load(header.id, 'spell/main')
local pred = module.load(header.id, 'pred/main')


local draw_W_range = function ()
    graphics.draw_circle(player.pos, spell.w.radius(), 2, 0xff7ddd6b, 64)
end



return {
    draw_W_range = draw_W_range,
}