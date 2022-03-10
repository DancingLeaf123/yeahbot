local Mymenu = menu('Yeahz_riven', 'Yeahz Riven')

-- if menu.farm_setting.lane_clear.push_q:get()
-- if menu.farm_setting.lane_clear.push_w:get()
-- if menu.farm_setting.lane_clear.push_e:get()

-- Mymenu.farm_setting:keybind('farm', 'Farm toggle', 'nil', "L")


Mymenu:header('header_push', 'Panic clear')
Mymenu:menu('farm_setting', 'Farm setting')
Mymenu.farm_setting:keybind('farm', 'Farm toggle', nil, "L")
Mymenu.farm_setting:menu('lane_clear', 'Lane_clear')
Mymenu.farm_setting.lane_clear:header('f_header_Q', '~~Q~~')
Mymenu.farm_setting.lane_clear:boolean('push_q', 'Use Q', true)
Mymenu.farm_setting.lane_clear:boolean('push_q_NE', '   ^== only when No enemy nearby', true)
Mymenu.farm_setting.lane_clear:slider('push_q_count', '   ^== Use Q minions >=', 1, 1, 6, 1)

Mymenu.farm_setting.lane_clear:header('f_header_W', '~~W~~')
Mymenu.farm_setting.lane_clear:boolean('push_w', 'Use W', true)
Mymenu.farm_setting.lane_clear:boolean('push_w_NE', '   ^== only when No enemy nearby', true)
Mymenu.farm_setting.lane_clear:slider('push_w_count', '   ^== Use W minions >=', 1, 1, 6, 1)

Mymenu.farm_setting.lane_clear:header('f_header_E', '~~E~~')
Mymenu.farm_setting.lane_clear:boolean('push_e', 'Use E', true)
Mymenu.farm_setting.lane_clear:boolean('push_e_NE', '   ^== only when No enemy nearby', true)
Mymenu.farm_setting:menu('jungle_clear', 'Jungle_clear')
Mymenu.farm_setting.jungle_clear:boolean('push_q', 'Use Q', true)
Mymenu.farm_setting.jungle_clear:slider('push_q_count', '   ^== Use Q minions >=', 1, 1, 6, 1)
Mymenu.farm_setting.jungle_clear:boolean('push_w', 'Use W', true)
Mymenu.farm_setting.jungle_clear:slider('push_w_count', '   ^== Use W minions >=', 1, 1, 6, 1)
Mymenu.farm_setting.jungle_clear:boolean('push_e', 'Use E', true)
Mymenu:keybind('push', 'Panic clear key', 'V', nil)

--Mymenu:header('header_harass', 'Harass')
--Mymenu:dropdown('harass_mode', 'Retreat Spell', 1, {'Q', 'E'})
--Mymenu:keybind('harass', 'Harass Key', 'T', nil)

--Mymenu:header('header_misc', 'Misc')
--Mymenu:boolean('cancel_q', 'Cancel Qs issued by yourself', true)

Mymenu:header('header_flash', 'Flash combo')
Mymenu:boolean('flash', 'Use flash combo on selected target', true)
Mymenu:boolean('reset_ts', 'Reset selected target after flash', true)
Mymenu:boolean('flash_only_r', 'Use flash only for r1/r2 combos', false)
Mymenu:slider('r2_flash', 'Flash after r2 missiles weight', 100, 0, 100, 1)

Mymenu:header('header_gap', 'Closing the first gap')
Mymenu:boolean('gap_e_w', 'E[+?]->[?[+W]]', true)
Mymenu:boolean('gap_e_q', 'E[+?]->[?[+Q]]', true)
Mymenu:boolean('gap_e_aa', 'E[+?]->[AA]', true)
Mymenu:boolean('gap_q', 'Q->[?]', true)
Mymenu:header('header_combat', 'Combat')
--Mymenu:boolean('auto_cancel', 'Silently cancel manual Q', true)
--Mymenu:menu('e_gapclose', 'Initial Gapclose')
--menu.e_gapclose:boolean('e_w', 'Use E->W[+Q]', true)
--menu.e_gapclose:boolean('e_q', 'Use E->Q', true)
--menu.e_gapclose:boolean('e_aa', 'Use E->AA', true)
--menu.e_gapclose:boolean('q_aa', 'Use Q->AA', true)
Mymenu:slider('e_double_cast_weight', 'Close combat double cast weight', 100, 0, 100, 1)
Mymenu:keybind('e_aa', 'Consider E[+?]->[AA->[?]]', nil, 'T')
Mymenu:keybind('r1', 'Use R1 in next combo', nil, 'C')
Mymenu:keybind('combat', 'Combat key', 'Space', nil)
Mymenu:menu('flee_setting', 'Flee setting')
Mymenu.flee_setting:keybind('flee', 'Flee key', 'Z', nil)
Mymenu.flee_setting.flee:set('tooltip', 'Walljump towards the mouse')
Mymenu.flee_setting:dropdown('quickrun', 'Save Q3,E Modifier', 2, {'None', 'LBM Down', 'Hotkey',})
Mymenu.flee_setting.quickrun:set('tooltip', 'when active or enemy in range, not delay using Q and not save E,Q3 to walljump')

-- Mymenu:dropdown('chase', 'chase target with Q and E', 2, {'None', 'LBM Down', 'Hotkey',})

-- Drawing
Mymenu:menu('draw_setting', 'Drawing')
Mymenu.draw_setting:header('d_header_common', 'Common')
Mymenu.draw_setting:boolean('draw_ER', 'Draw enemy detect range', true)
Mymenu.draw_setting:slider('EDR_slider', 'enemy detect range', 1200, 300, 2000, 100)

Mymenu.draw_setting:header('d_header_Q', '~~Q~~')
Mymenu.draw_setting:boolean('draw_Q', 'Draw Q range', true)
Mymenu.draw_setting:color('Q_color', 'Q Color', 143, 190, 147,255)

Mymenu.draw_setting:header('d_header_W', '~~W~~')
Mymenu.draw_setting:boolean('draw_W', 'Draw W range', true)
Mymenu.draw_setting:color('W_color', 'W Color', 125, 221, 107,255)

Mymenu.draw_setting:header('d_header_E', '~~E~~')
Mymenu.draw_setting:boolean('draw_E', 'Draw E range', true)
Mymenu.draw_setting:color('E_color', 'E Color', 255, 0, 0, 255)

return Mymenu