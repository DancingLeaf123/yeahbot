local lvxbot = module.load(header.id, 'lvxbot/main')

local input = {
  prediction = {
    type = 'Linear',
    --
    range = 900,
    delay = 0.25,
    speed = 1700,
    width = 60,
    boundingRadiusMod = 1,
  },

  target_selector = {
    type = 'LESS_CAST_AD',
  },

  cast_spell = {
    type = 'pos',
    slot = _W,
    arg1 = function(action)
      local seg = action.ts_result.seg
      local obj = action.ts_result.obj
      return seg.endPos:to3D(obj.y)
    end,
  },

  slot = _W,
  ignore_obj_radius = 2000,
}

local module = lvxbot.expert.create(input)



return module
