local lvxbot = module.load(header.id, 'lvxbot/main')

local menu = menu(lvxbot.menu_id, lvxbot.menu_name)

menu:header('header_core', 'Combat')
menu:boolean('q', 'Use Q', true)
--menu:boolean('q_ext', 'Use extended Q', true)
menu:boolean('w', 'Use W for spell weaving', true)
menu:boolean('e', 'Use E to mouse after attacks', true)
menu:boolean('e_over_q', 'Prioritize E over Q', false)
menu:dropdown('e_mod', 'LMB Down Modifier', 2, {'None', 'Short E',})
menu:keybind('combat', 'Combat key', 'Space', nil)

return menu
