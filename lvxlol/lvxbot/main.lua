local menu_id = 'lvxlol_'..player.charName:lower()
local menu_name = 'LVxLoL Expert '..player.charName

local load = function(name)
  return module.load(header.id, player.charName:lower()..'/'..name)
end

return {
  menu_id = menu_id,
  menu_name = menu_name,
  load = load,
  expert = module.load(header.id, 'lvxbot/expert'),
  combo_tracker = module.load(header.id, 'lvxbot/combo_tracker'),
}