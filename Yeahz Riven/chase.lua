local TS = module.internal('TS')
local orb =  module.internal('orb')

local menu = module.load(header.id, 'menu')

local spell = module.load(header.id, 'spell/main')
local pred = module.load(header.id, 'pred/main')


local crescent_wrapper = module.load(header.id, 'item/crescent_wrapper')

local flee = module.load(header.id, 'flee')


local draw_chase = false

local valid_enemy = function(obj)
  return obj.isTargetable and obj.isVisible
end

local get_nearest_enemy_to_mouse = function ()
  local t, min = nil, math.huge
  for i=0, objManager.enemies_n-1 do
    local obj = objManager.enemies[i]
    if valid_enemy(obj) and obj.pos:dist(mousePos) < min then
      t, min = obj, obj.pos:dist(mousePos)
    end
  end
  return t,min
end

local chase = function()
  if orb.menu.combat.key:get() and keyboard.isKeyDown(0x1) and menu.chase:get() == 2 then
    local chase_tar,dist = get_nearest_enemy_to_mouse()
    local final_tar = TS.selected or chase_tar
    
    local q = spell.q.is_ready()
    local e = spell.e.is_ready()
    local pred_e = pred.e.get_action_state()
    local pred_q = pred.q.get_action_state()
    if TS.selected and menu.flash:get() then
      local flash_q = pred.flash_q.get_action_state()
      local flash_w = pred.flash_w.get_action_state()
      local e_flash_w = pred.e_flash_w.get_action_state()
      local e_flash_q = pred.e_flash_q.get_action_state()
      if not(flash_q or flash_w or e_flash_w or e_flash_q) then
        if not flee.GetFirstWallPoint(player.pos, final_tar.pos, 25) then
          if q and not pred_q and not player.path.isDashing  then
            print("chaseing")
            print(final_tar.charName)
            player:castSpell('obj', 0, final_tar)
          end
        end
      end
    elseif final_tar and final_tar.isOnScreen then    
      if not flee.GetFirstWallPoint(player.pos, final_tar.pos, 25) then
        if e and not pred_e and not player.path.isDashing then
          print("chaseing")
          print(final_tar.charName)
          player:castSpell('pos', 2, vec3(final_tar.pos.x, final_tar.pos.y, final_tar.pos.z))
        elseif q and not pred_q and not player.path.isDashing  then
          print("chaseing")
          print(final_tar.charName)
          player:castSpell('obj', 0, final_tar)
        end
      end
    end
  end
end


local draw_2D_chase = function ()
  if orb.menu.combat.key:get() then
    if keyboard.isKeyDown(0x1) and menu.chase:get() == 2 then
      graphics.draw_text_2D('chase', 14, game.cursorPos.x, game.cursorPos.y, 0xFFFFFFFF)
    end
  end
end

-- cb.add(cb.draw, draw_2D_chase)

return {
  chase = chase,
  draw_2D_chase = draw_2D_chase,
}
