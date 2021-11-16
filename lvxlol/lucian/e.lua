local lvxbot = module.load(header.id, 'lvxbot/main')
local menu = lvxbot.load('menu')

local input = {

  cast_spell = {
    type = 'pos',
    slot = _E,
    arg1 = function(action) 
      local pos = mousePos
      if menu.e_mod:get() == 2 and keyboard.isKeyDown(1) then
        local p = player.path.serverPos
        return p:lerp(pos, 50/p:dist(pos))
      end
      return pos
    end,
  },

  slot = _E,
}


local module = lvxbot.expert.create(input)

return module

