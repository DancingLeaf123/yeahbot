local orb = module.internal('orb')
local TS =  module.internal('TS')
local gpred =  module.internal('pred')

local menu = module.load(header.id, 'menu')

local ai = module.load(header.id, 'core/ai')
local push = module.load(header.id, 'pred/push')

local spell = module.load(header.id, 'spell/main')
local pred = module.load(header.id, 'pred/main')



local draw_Q_range = function ()
    if spell.q.is_ready() then
    end
    graphics.draw_circle(player.pos, pred.q.get_total_radius(), 2, 0xff8fbe93, 64)
end

local draw_W_range = function ()
    if spell.w.is_ready() then
    end
    graphics.draw_circle(player.pos, pred.w.get_total_radius(), 2, 0xff7ddd6b, 64)
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
        
    end

    if TS.selected then
        -- print("ts.selected", TS.selected.pos2D:dist(player.pos2D))
    end
    -- for key, value in pairs(menu.farm_setting.lane_clear.push_w_count) do
    --     print(key,value)
    -- end
    -- if game.hoveredTarget then
    --     print("high value",game.hoveredTarget.highValue)
    -- end
    if orb.core.cur_attack_target then
        local q = pred.q.get_action_state()
        if orb.core.cur_attack_target then 

        end
    end
    if player.path.isDashing then
        local qdash = player.path.point2D[0]:dist(player.path.point2D[1])
        -- graphics.draw_circle(VextorExtend(player.pos, mousePos, qdash), 225, 2, 0xff8fbe93, 64)
    end
    
    
    
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