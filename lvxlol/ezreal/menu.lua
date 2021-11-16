local lvxbot = module.load(header.id, 'lvxbot/main')

local menu = menu(lvxbot.menu_id, lvxbot.menu_name)

local icon = graphics.sprite('engel2.png')
print("icon", icon)

menu:header('header_farm', 'Farm')
menu:boolean('q_clear', 'Use Q in lane clear', true)
menu:set('icon', icon)
--menu:boolean('q_assist', 'Enable farm assist', true)
menu:header('header_core', 'Combat')
menu:boolean('q', 'Use Q', true)
menu:boolean('w', 'Use W', true)
menu:boolean('w_only_after_aa', 'Use W only after attacks', true)
menu:header('header_keys', 'Key Bindings')
menu:keybind('auto_q', 'Auto Q', nil, 'T')
menu:keybind('combat', 'Combat', 'Space', nil)

return menu