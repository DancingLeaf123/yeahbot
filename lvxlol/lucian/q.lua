local lvxbot = module.load(header.id, 'lvxbot/main')

local input = {
  prediction = {
    type = 'InRange',
    --
    delay = 0,
    radius = 625,
    dashRadius = 0,
    boundingRadiusModSource = 0,
    boundingRadiusModTarget = 0,
  },

  target_selector = {
    type = 'LESS_CAST_AD',
  },

  cast_spell = {
    type = 'obj',
    slot = _Q,
    arg1 = function(action) return action.ts_result.obj end,
  },

  slot = _Q,
  ignore_obj_radius = 2000,
}

local module = lvxbot.expert.create(input)

return module
