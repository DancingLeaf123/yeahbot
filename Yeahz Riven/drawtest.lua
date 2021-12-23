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
    if spell.w.is_ready() then
        graphics.draw_circle(player.pos, spell.w.radius(), 2, 0xff7ddd6b, 64)
    end
end

local VextorExtend =function(a, b, dist) return a + dist * (b-a):norm() end

local target_near_range = function ()
    for i=0, objManager.enemies_n-1 do
        local obj = objManager.enemies[i]
        local dist = player.pos:dist(obj.pos)
        local bdist = player.pos:dist(obj.pos) - obj.boundingRadius
        graphics.draw_line(player.pos, obj.pos, 10, 0x77FF0000)
        if player.pos:dist(obj.pos) <= 120 then
            graphics.draw_line(player.pos, obj.pos, 4, 0xFF00FF00)
        end
        local v = graphics.world_to_screen(obj.pos)
        graphics.draw_text_2D(tostring(("%.2f"):format(bdist)), 24, v.x, v.y - 100, 0xFF00FF00)
        graphics.draw_text_2D(tostring(("%.2f"):format(dist)), 24, v.x, v.y - 50, 0xFFFFFFFF)
        
        if player.path.isDashing then
            print("kiri",player.path.point2D[0]:dist(player.path.point2D[1]))
        end
    end
    -- if spell.q.slot.stacks <= 0 and TS.selected then
    --     if pred.q.get_push_state() then
    --         pred.q.invoke_action(true)
    --         orb.combat.set_invoke_after_attack(false)
    --         return true
    --     end
    --     if pred.q.get_action_state() then
    --         pred.q.invoke_action(true)
    --         orb.combat.set_invoke_after_attack(false)
    --         player:stop()
    --         print(player.path.isActive)
    --         if not player.path.isActive then
    --             print("ts.selected", TS.selected.pos2D:dist(player.pos2D))
    --         end
    --         return true
    --     end
    -- end
    if TS.selected then
        -- print("ts.selected", TS.selected.pos2D:dist(player.pos2D))
    end
    if orb.core.cur_attack_target then
        local q = pred.q.get_action_state()
        -- print(orb.core.cur_attack_target.boundingRadius)
        -- print(player.boundingRadius)
        -- print(orb.core.cur_attack_target.pos2D:dist(player.pos2D))
        -- print("-", orb.core.cur_attack_target.pos2D:dist(player.pos2D) - orb.core.cur_attack_target.boundingRadius)
        -- graphics.draw_circle(orb.core.cur_attack_target.pos, 150, 2, 0xff8fbe93, 64)
        -- graphics.draw_circle(VextorExtend(player.pos, mousePos, 15), 270, 2, 0xff8fbe93, 64)
    end
    -- hero.direction2D
    graphics.draw_circle(player.pos, 150, 2, 0xff8fbe93, 64)
    graphics.draw_circle(VextorExtend(player.pos, mousePos, 225), 225, 2, 0xff8fbe93, 64)
    
end

-- local function on_issue_order(order, pos, obj)
--     if order==2 then
--         print(('move order issued at %.2f - %.2f'):format(pos.x, pos.z))
--     end
--     if order==3 then
--         print(('attack order issued to %u'):format(obj))
--     end
-- end

-- cb.add(cb.issueorder, on_issue_order)


return {
    draw_W_range = draw_W_range,
    draw_Q_range = draw_Q_range,
    target_near_range = target_near_range,
}