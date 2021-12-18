local orb = module.internal('orb')
local menu = module.load(header.id, 'menu')
local pred = module.load(header.id, 'pred/main')

local last_e = 0

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

local WallJump = function ()
  if menu.flee:get() then
    if navmesh.isWall(player.pos) then
      print("wall", navmesh.isWall(player.pos))
    end
    local qSlot = player:spellSlot(0)
    local q = pred.q.get_spell_state()
    local e = pred.e.get_spell_state()
    if q and qSlot.stacks < 2 then
      player:castSpell('pos', 0, mousePos)
    end

    -- We need to define a new move position since jumping over walls
    -- requires you to be close to the specified wall. Therefore we set the move
    
    local wallCheck = GetFirstWallPoint(player.pos, mousePos, 25)
    
    -- Be more precise
    if (wallCheck ~= nil) then
      wallCheck = GetFirstWallPoint(wallCheck:to3D(), mousePos, 5)
    end
    
    local movePosition = wallCheck ~= nil and q and wallCheck:to3D() or mousePos
    -- var tempGrid = NavMesh.WorldToGrid(movePosition.X, movevPosition.Y);
    -- Program.FleePosition = NavMesh.GridToWorld((short)tempGrid.X, (short)tempGrid.Y);
    local IsJumpPossible = false
    if wallCheck ~= nil then
      local wallPosition = movePosition;
      local direction = (mousePos:to2D() - wallPosition:to2D()):norm()
      local maxAngle = 80
      local step = maxAngle / 20
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
      local wallcheck_bugstartpos = GetFirstWallPoint(wallPosition, Min_bugJump_pos, 25)
      local wallCheck_123 = GetFirstWallPoint(Min_bugJump_pos, Min_bugEnd_pos, 1)
      if wallCheck_123 then
        -- print("wallCheck_123 to startpos", wallCheck_123:dist(Min_bugJump_pos:to2D()))
      end
      local bugjump_direction = (Min_bugJump_pos:to2D() - Min_bugEnd_pos:to2D()):norm()
      -- 138
      -- 172
      local Truestart_pos = wallCheck_123:to3D() + 138 * bugjump_direction:to3D()
      print("Truestart_pos dist",Truestart_pos:dist(wallCheck_123:to3D()))
      if wallPosition:dist(Truestart_pos) < 1000 and not wallcheck_bugstartpos then
        player:move(Truestart_pos)
        for key , value in pairs (bug_wallJumP_pos) do
          if bug_wallJumP_pos[key] == Min_bugJump_pos then
            -- print(key,key:gsub( "start", "end"))
          end
        end
        if qSlot.stacks >= 2 and player.pos2D:dist(Truestart_pos:to2D()) < 2.5  then
          if e then
            print("player.pos2D:dist(Truestart_pos:to2D())",player.pos2D:dist(Truestart_pos:to2D()))
            last_e = game.time
            print("last_e",last_e)
            player:castSpell('pos', 2, Min_bugEnd_pos)
          end
        end
        
        -- local Q3delay = (game.time - last_e) >= 0.090 and (game.time - last_e) <= 0.11

        -- local Q3delay = navmesh.isWall(player.pos)
        -- if player.path.isDashing then
        --   print("Q3delay_time_start",Q3delay_time_start)
        --   if navmesh.isWall(player.pos) and Q3delay_time_start == nil then
        --     local Q3delay_time_start = game.time
        --     print("Q3delay_time_start",Q3delay_time_start)
        --   end
        -- end
            -- if not navmesh.isWall(player.pos) then
            --   local totalwalltime = game.time - Q3delay_time_start
            --   print("totalwalltime", totalwalltime)
            -- end
          -- if navmesh.isWall(player.pos) and player.path.isDashing and then
          --   print("Q3delay",Q3delay)
          --   player:castSpell('pos', 0, Min_bugEnd_pos)
          -- end

        print(player.pos:dist(Min_bugJump_pos))
        if navmesh.isWall(player.pos) and player.path.isDashing then
          -- print("Q3delay",Q3delay)
          -- print("before Q3 Q3delay_time_start",Q3delay_time_start)
          -- print("before Q3 game time",game.time)
          -- print("player.pos:dist(Min_bugJump_pos)",player.pos:dist(Min_bugJump_pos))
          player:castSpell('pos', 0, Min_bugEnd_pos)
          Q3delay_time_start = nil
        end

      end
      do return end
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
            graphics.draw_line(checkPoint, wallPosition, 2, 0xFFFFFFFF)
        if not(navmesh.isWall(checkPoint) or navmesh.isStructure(checkPoint)) then
          wallCheck = GetFirstWallPoint(checkPoint, wallPosition);
          if (wallCheck ~= nil) then
            local firstWallPoint = GetFirstWallPoint(wallCheck:to3D(), wallPosition);
            if (firstWallPoint ~= nil) then
              local wallPositionOpposite = firstWallPoint:to3D();
              local allpath,n = player.path:calcPos(wallPositionOpposite)
              local temptable = {}
              for i = 0, n - 1 do
                -- graphics.draw_circle(allpath[i], 15, 2, 0xffffffff, 3)
                table.insert(temptable, allpath[i])
              end
              local allpathlen = GetPathLength(temptable)
              -- print("allpathlen",allpathlen)
              if (allpathlen - player.pos:dist(wallPositionOpposite) > 220) then
                player:move(movePosition)
                graphics.draw_line(wallPositionOpposite, wallPosition, 2, 0xFF008000)
                if (player.pos:distSqr(wallPositionOpposite) < (480 - player.boundingRadius / 2)^2 and qSlot.stacks >= 2) then
                  graphics.draw_line(wallPositionOpposite, wallPosition, 2, 0xFFFF0000)
                  print("cast E ----------------------",(480 - player.boundingRadius / 2))
                  print("cast E ----------------------",player.pos:dist(wallPositionOpposite))
                  print("cast E ----------------------",(300 - player.boundingRadius / 2)^2)
                  if (e) then
                    player:castSpell('pos', 2, wallPositionOpposite)
                  elseif (q) then
                    player:castSpell('pos', 0, wallPositionOpposite)
                  end
                  jumpTriggered = true
                  print("jumpTriggered",jumpTriggered)
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
end
-- if (not jumpTriggered) then
--   player:move(mousePos)
-- end

orb.combat.register_f_pre_tick(function()
  WallJump()
end)


return wallJump