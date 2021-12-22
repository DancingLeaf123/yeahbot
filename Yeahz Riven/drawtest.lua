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

    if orb.core.cur_attack_target then
        local q = pred.q.get_action_state()
        local truepos = orb.core.cur_attack_target.pos2D:dist(player.pos2D) < 225 and orb.core.cur_attack_target.pos:dist(player.pos) or 225
        local min = orb.core.cur_attack_target.pos2D:dist(player.pos2D) - orb.core.cur_attack_target.boundingRadius
        local startdis = 
        print(orb.core.cur_attack_target.boundingRadius)
        print(player.boundingRadius)
        print("at r",player.attackRange)
        print(orb.core.cur_attack_target.pos2D:dist(player.pos2D))
        print("-", orb.core.cur_attack_target.pos2D:dist(player.pos2D) - orb.core.cur_attack_target.boundingRadius)
        -- graphics.draw_circle(orb.core.cur_attack_target.pos, 150, 2, 0xff8fbe93, 64)
        if TS.selected then
            print("ts.selected", TS.selected.pos2D:dist(player.pos2D))
        end
        graphics.draw_circle(VextorExtend(player.pos, mousePos, 225), 225, 2, 0xff8fbe93, 64)
    end
    -- hero.direction2D
    -- graphics.draw_circle(player.pos, 190, 2, 0xff8fbe93, 64)
    
end

-- 什么东西是一个定值？  是player离目标的距离-
-- 攻击距离的公式是 player.boundingRadius + player.attackRange + target.boundingRadius 这个东西的后两者是会变的
-- 但有个东西是不变的。  player-target的距离 - 目标的bounding是不变的，且这个不随我攻击距离而改变。
-- 如果说在攻击范围你，这个距离大于150照样突进的话， 我想问的问题是，在哪个范围是这种模式， 就是会收缩到105，说白了就是离攻击表面105
-- q的突进是225 攻击距离自带的是190， 理论上说，415的距离能a到，试一试。
-- 离攻击表面的距离大于105的时候，若目标是一个obj，则突进到离目标表面105处。
-- 而另一方面， 因为突然距离是固定的，225，所以何种情况下不会是这样呢？225+105=330 当这样的时候，看看情况。
-- 190+225 = 415
--  265+225 = 490 - 30 = 460
-- 357
-- 378 157
-- 407 -225  183
-- 公式是这样的，离表面的距离若大于105，但小于415

-- 所以公式我感觉已经懂了
-- 如果说无目标，就是kiri那个范围
-- 如果说离攻击表面 >105 但是<105+225 就必然是突进到离该点105.
-- 再大的话，如果大过了攻击距离+225则不行， 若小于，会平移平A

-- 总结一下就是说， 如果说<100之后，必然是每次朝着中心位置10个单位  
    -- >105，<330,则肯定是105

return {
    draw_W_range = draw_W_range,
    draw_Q_range = draw_Q_range,
    target_near_range = target_near_range,
}