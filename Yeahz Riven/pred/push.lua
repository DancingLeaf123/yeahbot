local pred = module.internal('pred')
local menu = module.load(header.id, 'menu')

local obj = nil
local tickID = 0

local get_last_push_object = function()
  return obj
end

local valid_minion = function(obj)
  return obj.isTargetable and obj.isVisible
end

local get_nearest_minion_to_mouse = function()
  local t, min = nil, math.huge
  for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
    local obj = objManager.minions[TEAM_ENEMY][i]
    if valid_minion(obj) and obj.pos:distSqr(mousePos) < min then
      t, min = obj, obj.pos:distSqr(mousePos)
    end
  end
  for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
    local obj = objManager.minions[TEAM_NEUTRAL][i]
    if valid_minion(obj) and obj.pos:distSqr(mousePos) < min then
      t, min = obj, obj.pos:distSqr(mousePos)
    end
  end
  return t
end


local get_minion_count_inrange = function(pos,radius)
  if pos == nil then pos = player.pos end
  local minion_count = 0
  for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
    local obj = objManager.minions[TEAM_ENEMY][i]
    if valid_minion(obj) and obj.pos:dist(pos) < radius then
      minion_count = minion_count + 1
    end
  end
  for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
    local obj = objManager.minions[TEAM_NEUTRAL][i]
    if valid_minion(obj) and obj.pos:dist(pos) < radius then
      minion_count = minion_count + 1
    end
  end
  return minion_count
end

local get_prediction = function(delay, radius, bbox)
  if game.tickID ~= tickID then
    -- seems game.tickID ~= tickID use this way reduce the call time
    obj = get_nearest_minion_to_mouse()
    tickID = game.tickID
  end
  if obj then
    local p1 = player.path.serverPos2D
    local p2 = pred.core.get_pos_after_time(obj, delay)
    if p1:dist(p2) < (bbox and radius+obj.boundingRadius or radius) then
      return obj, p2
    end
  end
end

return {
  get_prediction = get_prediction,
  get_nearest_minion_to_mouse = get_nearest_minion_to_mouse,
  get_last_push_object = get_last_push_object,
  get_minion_count_inrange = get_minion_count_inrange,
}