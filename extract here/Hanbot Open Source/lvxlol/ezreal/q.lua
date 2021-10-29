local lvxbot = module.load(header.id, 'lvxbot/main')

local input = {
  prediction = {
    type = 'Linear',
    --
    range = 1150,
    delay = 0.25,
    speed = 2000,
    width = 60,
    boundingRadiusMod = 1,
    --
    collision = {
      hero = false, --allow to hit other heros :-)
      minion = true,
      wall = false,
    },
    --
    hitchance = 0,
  },

  target_selector = {
    type = 'LESS_CAST_AD',
  },

  cast_spell = {
    type = 'pos',
    slot = _Q,
    arg1 = function(action)
      local seg = action.ts_result.seg
      local obj = action.ts_result.obj
      return seg.endPos:to3D(obj.y)
    end,
  },

  slot = _Q,
  ignore_obj_radius = 2000,

}

return lvxbot.expert.create(input)

