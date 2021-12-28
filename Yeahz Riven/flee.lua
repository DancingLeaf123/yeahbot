local orb = module.internal('orb')
local menu = module.load(header.id, 'menu')
local pred = module.load(header.id, 'pred/main')

local last_e = 0
local last_q = 0

local bug_wallJumP_pos = {
  start_1 = vec3(9190.0234375,53.026031494141,7198.9057617188),
  end_1 = vec3(8977.4853515625,53.056053161621,6953.486328125),

  start_2 = vec3(10623.758789063, 35.631958007813, 3499.5078125),
  end_2 = vec3(10110.14453125,-71.240600585938,4024.4760742188),

  start_3 = vec3(9971.3828125,-71.240600585938, 4058.9038085938),
  end_3 = vec3(10618.94921875,34.361785888672,3457.1430664063),
}

local GetPathLength = function(path)
  local dist = 0
  for i = 1, #path - 1 do
    dist = dist + vec3(path[i]):dist(vec3(path[i + 1]))
  end
  return dist
end 

local GetFirstWallPoint = function (from,to,step)
    from = from:to2D()
    to = to:to2D()
    step = step or 25
    local direction  = (to - from):norm()
    for d=0, from:dist(to), step do
      local testPoint = from + d * direction
      if navmesh.isWall(testPoint) or navmesh.isStructure(testPoint) then
        return from + (d - step) * direction;
      end
    end
    return nil
end

local Orthant_2D = function(d)
  if d.x > 0 and d.y > 0 then
    return 1
  elseif d.x < 0 and d.y > 0 then
    return 2
  elseif d.x < 0 and d.y < 0 then
    return 3
  elseif d.x > 0 and d.y < 0 then
    return 4
  end
end

local WallJump = function ()
  if (wallCheck ~= nil) then
    wallCheck = GetFirstWallPoint(wallCheck:to3D(), mousePos, 5)
  end
  
  local movePosition = wallCheck ~= nil and q and wallCheck:to3D() or mousePos
  local IsJumpPossible = false
  if wallCheck ~= nil then
    local wallPosition = movePosition;
    local direction = (mousePos:to2D() - wallPosition:to2D()):norm()
    local maxAngle = 20
    local step = maxAngle / 10
    local currentAngle = 0;
    local currentStep = 0;
    local jumpTriggered = false
    local Min_bugJump_pos = bug_wallJumP_pos["start_1"]
    local Min_bugEnd_pos = bug_wallJumP_pos["end_1"]

    for key , value in pairs (bug_wallJumP_pos) do
      if string.find(key, "start") then
        if wallPosition:dist(value) <= wallPosition:dist(Min_bugJump_pos) then
          Min_bugJump_pos = value
          Min_bugEnd_pos = bug_wallJumP_pos[key:gsub( "start", "end")]
        end
      end
    end
    local wallCheck_123 = GetFirstWallPoint(Min_bugJump_pos, Min_bugEnd_pos, 1)
    local wallcheck_bugstartpos = GetFirstWallPoint(wallPosition, Min_bugJump_pos, 50)
    local bugjump_direction = (Min_bugEnd_pos:to2D() - Min_bugJump_pos:to2D()):norm()
    local bugjump_direction_rev = (Min_bugJump_pos:to2D() - Min_bugEnd_pos:to2D()):norm()
    local Truestart_pos = wallCheck_123:to3D() + 170 * bugjump_direction_rev:to3D()
    
    if wallPosition:dist(Truestart_pos) < 500 and not wallcheck_bugstartpos then
      player:move(Truestart_pos)
      graphics.draw_line(Truestart_pos, Min_bugEnd_pos, 2, 0xFF008000)
      graphics.draw_circle(Truestart_pos, 50, 2, 0xFF008000, 24)
      if qSlot.stacks >= 2 and player.pos2D:dist(Truestart_pos:to2D()) < 2.5 and Orthant_2D(mouse_direction) == Orthant_2D(bugjump_direction)  then
        if e then
          -- print("player.pos2D:dist(Truestart_pos:to2D())",player.pos2D:dist(Truestart_pos:to2D()))
          last_e = game.time
          player:castSpell('pos', 2, Min_bugEnd_pos)
        end
      end
      if navmesh.isWall(player.pos) and player.path.isDashing then
        player:castSpell('pos', 0, Min_bugEnd_pos)
      end
      do return end
    end

    -- normal jump
    while(true)
    do
      if (currentStep > maxAngle and currentAngle < 0) then
          break;
      end
      if ((currentAngle == 0 or currentAngle < 0) and currentStep ~= 0) then
          currentAngle = (currentStep) * mathf.PI / 180;
          currentStep = currentStep + step;
      elseif (currentAngle > 0) then
        currentAngle = -currentAngle
      end
      local checkPoint = vec3(0, 0, 0)
      if (currentStep == 0) then
          currentStep = step;
          checkPoint = wallPosition + 435 * direction:to3D();
      else
          checkPoint = wallPosition + 435 * direction:rotate(currentAngle):to3D();
      end
      if not(navmesh.isWall(checkPoint) or navmesh.isStructure(checkPoint)) then
        wallCheck = GetFirstWallPoint(checkPoint, wallPosition);
        if (wallCheck ~= nil) then 
          local firstWallPoint = GetFirstWallPoint(wallCheck:to3D(), wallPosition);
          if (firstWallPoint ~= nil) then
            local wallPositionOpposite = firstWallPoint:to3D();
            local allpath,n = player.path:calcPos(wallPositionOpposite)
            local temptable = {}
            for i = 0, n - 1 do
              table.insert(temptable, allpath[i])
            end
            local allpathlen = GetPathLength(temptable)
            if (allpathlen - player.pos:dist(wallPositionOpposite) > 200) then
              player:move(movePosition)
              graphics.draw_line(wallPositionOpposite, wallPosition, 2, 0xFFFFFFFF)
              graphics.draw_circle(wallPosition, 50, 2, 0xFF008000, 24)
              if (player.pos:distSqr(wallPositionOpposite) < (480 - player.boundingRadius / 2)^2 and qSlot.stacks >= 2) then
                graphics.draw_line(wallPositionOpposite, wallPosition, 2, 0xFF008000)
                if (e) then
                  player:castSpell('pos', 2, wallPositionOpposite)
                elseif (q) then
                  player:castSpell('pos', 0, wallPositionOpposite)
                end
                jumpTriggered = true
                break;
              end
              IsJumpPossible = true
            else
              player:move(mousePos)
            end
          end
        end
      end
    end
  else
    player:move(mousePos)
  end
end


local enemy_range = 1200
local enemy_inrange = function (dist)
  for i=0, objManager.enemies_n-1 do
    local obj = objManager.enemies[i]
    -- print("obj.charName",obj.charName)
    -- print("obj.isOnScreen",obj.isOnScreen)
    -- print("obj.isDead",obj.isDead)
    if player.pos2D:dist(obj.pos2D) < dist and not obj.isDead then
      return true
    end
  end
end

local flee = function ()
  if menu.flee_setting.flee:get() then

    qSlot = player:spellSlot(0)
    q = pred.q.get_spell_state()
    e = pred.e.get_spell_state()
    w = pred.w.get_action_state()
    wallCheck = GetFirstWallPoint(player.pos, mousePos, 25)
    mouse_direction = (mousePos2D - player.pos2D):norm()
    -- print("player.direction2D",player.direction2D.x,player.direction2D.y)
    -- print("mouse_direction",mouse_direction.x,mouse_direction.y)
    if w then
      pred.w.invoke_action(true)
    end
    if not q and not e then
      player:move(mousePos)
    end
    print(enemy_inrange(enemy_range) and not wallCheck)
    if enemy_inrange(enemy_range) and not wallCheck then
      if q and qSlot.stacks < 2 and not player.path.isDashingthen then
        player:castSpell('pos', 0, mousePos)
      elseif e and not player.path.isDashingthen then
        player:castSpell('pos', 2, mousePos)
      elseif q and not e and not player.path.isDashingthen then
        player:castSpell('pos', 0, mousePos)
      end
    end
    if keyboard.isKeyDown(0x1) and menu.flee_setting.quickrun:get() == 2 then
      if q and qSlot.stacks < 2 and not player.path.isDashingthen then
        player:castSpell('pos', 0, mousePos)
      elseif e and not player.path.isDashingthen then
        player:castSpell('pos', 2, mousePos)
      elseif q and not e and not player.path.isDashingthen then
        player:castSpell('pos', 0, mousePos)
      end
    end
    -- and qSlot.stacks < 2
    if q and (wallCheck or Orthant_2D(mouse_direction) == Orthant_2D(player.direction2D)) then
      if wallCheck then
        if qSlot.stacks < 2 then
          player:castSpell('pos', 0, mousePos)
          last_q = game.time
        end
      elseif game.time - last_q > 3.5 and not player.path.isDashingthen then
        player:castSpell('pos', 0, mousePos)
        last_q = game.time
      end
    elseif (not q or qSlot.stacks >=2) and not wallCheck and not player.path.isDashingthen then
      player:castSpell('pos', 2, mousePos)
      -- print("player.path.isDashingthen",player.path.isDashingthen)
      -- print("game.time - last_q",game.time - last_q)
      -- print("qSlot.stacks",qSlot.stacks)
    end
    WallJump()
  end
end

local draw_2D = function ()
  if menu.flee_setting.flee:get() then
    if keyboard.isKeyDown(0x1) and menu.flee_setting.quickrun:get() == 2 then
      graphics.draw_text_2D('quick cast flee', 14, game.cursorPos.x, game.cursorPos.y, 0xFFFFFFFF)
    end
  end
  graphics.draw_circle(player.pos, enemy_range, 2, 0xFFFFFFFF, 24)
end


local function on_key_down(k)
  if k==keyboard.stringToKeyCode(menu.flee_setting.flee.key) then
      -- game.setCameraLock(1)
  end
end

local function on_key_up(k)
  if k==keyboard.stringToKeyCode(menu.flee_setting.flee.key) then
    game.setCameraLock(0)
end
end

cb.add(cb.keydown, on_key_down)
cb.add(cb.keyup, on_key_up)

cb.add(cb.draw, draw_2D)

orb.combat.register_f_pre_tick(function()
  flee()
end)

return {
  IsJumpPossible = IsJumpPossible,
  WallJump = WallJump,
}