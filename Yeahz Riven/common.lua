local menu = module.load(header.id, 'menu')

local enemy_inrange = function(dist)
  dist = dist or menu.draw_setting.EDR_slider:get()
  for i=0, objManager.enemies_n-1 do
    local obj = objManager.enemies[i]
    -- print("obj.charName",obj.charName)
    -- print("obj.isOnScreen",obj.isOnScreen)
    -- print("obj.isDead",obj.isDead)
    if player.pos2D:dist(obj.pos2D) < dist and not obj.isDead and obj.isTargetable  then
      return true
    end
  end
end

return{
  enemy_inrange = enemy_inrange,

}
