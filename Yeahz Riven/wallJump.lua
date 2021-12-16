local orb = module.internal('orb')
local menu = module.load(header.id, 'menu')
local pred = module.load(header.id, 'pred/main')


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

local WallJump = function ()
  if menu.flee:get() then
    local qSlot = player:spellSlot(0)
    local q = pred.q.get_spell_state()
    local e = pred.e.get_spell_state()
    if q and qSlot.stacks ~= 2 then
      player:castSpell('pos', 0, mousePos)
    end

    -- We need to define a new move position since jumping over walls
    -- requires you to be close to the specified wall. Therefore we set the move
    local wallCheck = GetFirstWallPoint(player.pos, mousePos, 25)
    
    -- Be more precise
    if (wallCheck ~= nil) then
      wallCheck = GetFirstWallPoint(wallCheck:to3D(), mousePos, 5)
    end
    
    local movePosition = wallCheck ~= nil and wallCheck:to3D() or mousePos
    player:move(movePosition)
    -- var tempGrid = NavMesh.WorldToGrid(movePosition.X, movevPosition.Y);
    -- Program.FleePosition = NavMesh.GridToWorld((short)tempGrid.X, (short)tempGrid.Y);
    
    if wallCheck ~= nil then
      local wallPosition = movePosition;
      local direction = (mousePos:to2D() - wallPosition:to2D()):norm()
      local maxAngle = 80
      local step = maxAngle / 20
      local currentAngle = 0;
      local currentStep = 0;
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
            checkPoint = wallPosition + 500 * direction:to3D();
        else
            checkPoint = wallPosition + 467.5 * direction:rotate(currentAngle):to3D();
        end
            graphics.draw_line(checkPoint, player.pos, 2, 0xFFFFFFFF)
        if not(navmesh.isWall(checkPoint) or navmesh.isStructure(checkPoint)) then
          wallCheck = GetFirstWallPoint(checkPoint, wallPosition);
          if (wallCheck ~= nil) then
            local firstWallPoint = GetFirstWallPoint(wallCheck:to3D(), wallPosition);
            if (firstWallPoint ~= nil) then
              local wallPositionOpposite = firstWallPoint:to3D();
              graphics.draw_line(wallPositionOpposite, player.pos, 2, 0xFFFF0000)
              local allpath,n = player.path:calcPos(wallPositionOpposite)
              local temptable = {}
              for i = 0, n - 1 do
                -- graphics.draw_circle(allpath[i], 15, 2, 0xffffffff, 3)
                table.insert(temptable, allpath[i])
              end
              local allpathlen = GetPathLength(temptable)
              print("allpathlen",allpathlen)
              if (allpathlen - player.pos:dist(wallPositionOpposite) > 200) then
                print(">200")
                print("player.boundingRadius / 2",player.boundingRadius / 2)
                print("player.pos:dist(wallPositionOpposite)",player.pos:dist(wallPositionOpposite))
                print("player.pos:distSqr(wallPositionOpposite)",player.pos:distSqr(wallPositionOpposite))
                if (player.pos:distSqr(wallPositionOpposite) < (510 - player.boundingRadius / 2)^2 and qSlot.stacks == 2) then
                  print("cast E ----------------------")
                  print("cast E ----------------------",player.pos:distSqr(wallPositionOpposite))
                  print("cast E ----------------------",(300 - player.boundingRadius / 2)^2)
                  if (e) then
                    player:castSpell('pos', 2, wallPositionOpposite)
                  elseif (q) then
                    player:castSpell('pos', 0, wallPositionOpposite)
                  end
                  break;
                end
              end
            end
          end
        end
      end
    end
  end
end

orb.combat.register_f_pre_tick(function()
  WallJump()
end)


return wallJump