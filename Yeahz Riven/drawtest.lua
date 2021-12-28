local orb = module.internal('orb')
local TS =  module.internal('TS')
local gpred =  module.internal('pred')

local menu = module.load(header.id, 'menu')

local ai = module.load(header.id, 'core/ai')
local push = module.load(header.id, 'pred/push')

local spell = module.load(header.id, 'spell/main')
local pred = module.load(header.id, 'pred/main')

local flee = module.load(header.id, 'flee')

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
        local v = graphics.world_to_screen(obj.pos)
        if dist <= 2000 then
            graphics.draw_line(player.pos, obj.pos, 10, 0x77FF0000)
        end
    end
end



local permashow = function ()
    local SC_W = graphics.width
    local SC_H = graphics.height
    local init_W = SC_W - 700
    local init_H = SC_H - 300
    font_size = 24
    local toggle_list = {
        Farm = {menu.farm_setting.farm:get() or false, menu.farm_setting.farm.key or menu.farm_setting.farm.toggle},
        E_AA = {menu.e_aa:get() or false, menu.e_aa.key or menu.e_aa.toggle},
        Ruse = {menu.r1:get() or false, menu.r1.key or menu.r1.toggle},
        Flee = {menu.flee_setting.flee:get() or false, menu.flee_setting.flee.key or menu.flee_setting.flee.toggle}  
    }
    function pairsByKeys (t, f)
        local a = {}
        for n in pairs(t) do table.insert(a, n) end
        table.sort(a, f)
        local i = 0      -- iterator variable
        local iter = function ()   -- iterator function
          i = i + 1
          if a[i] == nil then return nil
          else return a[i], t[a[i]]
          end
        end
        return iter
      end
    -- local sortkey = {
    --     "Farm","E_AA","Ruse","Flee",
    -- }
    -- for i=1,#sortkey do
    --     print(sortkey[i])
    -- end
    -- print("SC_H",SC_H)
    local v = graphics.world_to_screen(player.pos)
    for key,value in pairsByKeys(toggle_list) do 
        local x, y = graphics.text_area(key.." "..value[2].." :", font_size)
        graphics.draw_text_2D(('%s [%s]:'):format(key,value[2]), font_size, init_W, init_H, COLOR_WHITE)
        graphics.draw_text_2D(('  %s'):format(value[1] and "ON" or "OFF"), font_size, init_W + x, init_H, value[1] and COLOR_GREEN or COLOR_RED)
        init_H = init_H + y
    end
end


return {
    draw_W_range = draw_W_range,
    draw_Q_range = draw_Q_range,
    target_near_range = target_near_range,
    permashow = permashow,
}