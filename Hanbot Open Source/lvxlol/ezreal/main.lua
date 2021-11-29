local lvxbot = module.load(header.id, 'lvxbot/main')

local menu = lvxbot.load('menu')
local q = lvxbot.load('q')
local w = lvxbot.load('w')


local debug = module.load(header.id, 'debug')
local orb = module.internal('orb')


local easy_q = function()
 if menu.combat:get() then
    q.easy_execute()
  end
end

local easy_w = function()
 if menu.combat:get() then
    w.easy_execute()
  end
end

orb.on_advanced_after_attack(function()
  if easy_q() then
    return true
  end
  if easy_w() then
    return true
  end
  if orb.core.time_to_next_attack() < 0.1 then
    return true
  end
end)

cb.add(cb.tick, function()
  if not orb.combat.target and orb.core.can_move() then
    easy_q()
    if not menu.w_only_after_aa:get() then
      easy_w()
    end
  end
end)
