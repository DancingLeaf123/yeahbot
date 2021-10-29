local TS = module.internal('TS')
local orb = module.internal('orb')
local pred = module.internal('pred')

local create = function(input)
  local module = {
    input = input,
  }

  local pred_func
  local is_in_range_check

  if input.prediction then
    if input.prediction.type == 'Linear' then
      pred_func = pred.linear
    elseif input.prediction.type == 'InRange' then
      pred_func = pred.present
      is_in_range_check = true
    end
  end

  local ts_filter
  if input.target_selector then
    if input.target_selector then
      ts_filter = TS.filter_set[input.target_selector.type]
    end
  end

  local STATE_OK = 0
  local STATE_NONE = 1
  local STATE_CAN_NOT_ACTION = 2
  local STATE_NO_TS_RESULT = 3

  module.STATE_OK = STATE_OK
  module.STATE_NONE = STATE_NONE
  module.STATE_CAN_NOT_ACTION = STATE_CAN_NOT_ACTION
  module.STATE_NO_TS_RESULT = STATE_NO_TS_RESULT

  module.can_action = function()
    return orb.core.can_cast_spell(input.slot)
  end

  module.get_prediction = function(obj)
    if not input.prediction then
      return false
    end
    local src = input.prediction.source
    local seg = pred_func.get_prediction(input.prediction, obj, src)
    if not seg then
      return false
    end
    if is_in_range_check then
      return true
    end
    if seg:length() < input.prediction.range then
      return seg
    end
  end

  module.get_collision = function(seg, obj)
    if not input.prediction.collision then
      return false
    end
    return pred.collision.get_prediction(input.prediction, seg, obj)
  end

  module.ts_loop = function(res, obj, dist)
    if dist > input.ignore_obj_radius then
     return false
    end
    local seg = module.get_prediction(obj)
    if not seg then
      return false
    end
    local col = module.get_collision(seg, obj)
    if col then
      res.col = {
        obj = obj,
        seg = seg,
        objects = col,
      }
      return false
    end
    res.ok = true
    res.obj = obj
    res.seg = seg
    return true
  end

  module.get_ts_result = function()
    local ts_result = TS.get_result(module.ts_loop, ts_filter)
    if not ts_result then
      return
    end
    if ts_result.ok then
      return ts_result
    end
    if ts_result.col then
      return nil, ts_result.col
    end
  end

  module.get_action = function()
    local action = {
      state = STATE_NONE,
    }
    if not module.can_action() then
      action.state = STATE_NOT_READY
      return nil, action
    end
    local ts_result
    if input.target_selector then
      ts_result = module.get_ts_result()
      if not ts_result then
        action.state = STATE_NO_TS_RESULT
        return nil, action
      end
    end
    action.ts_result = ts_result
    action.state = STATE_OK
    return action
  end

  module.invoke_action = function(action)
    if action.state == STATE_OK then
      local type = input.cast_spell.type
      local slot = input.cast_spell.slot
      local arg1 = input.cast_spell.arg1
      local arg2 = input.cast_spell.arg2
      arg1 = arg1 and arg1(action)
      arg2 = arg2 and arg2(action)
      player:castSpell(type, slot, arg1, arg2)
      return true
    end
  end

  module.easy_execute = function()
    local action = module.get_action()
    if action and action.state == STATE_OK then
      module.invoke_action(action)
      return true
    end
  end

  if input.visualize then

  end

  return module
end

return {
  create = create,
}