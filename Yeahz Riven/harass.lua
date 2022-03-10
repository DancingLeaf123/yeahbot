math.randomseed(os.time())

local TS = module.internal('TS')
local orb =  module.internal('orb')

local menu = module.load(header.id, 'menu')

local spell = module.load(header.id, 'spell/main')
local pred = module.load(header.id, 'pred/main')

local crescent_wrapper = module.load(header.id, 'item/crescent_wrapper')


local on_end_func = nil
local on_end_time = 0
local on_end_start = 0
local f_spell_map = {}

local last_e = 0
local double_cast_timeout = 1.050

local pre_r2 = false

local last_spell = 0

local on_cast_qx = {}
local on_end_qx = {}


local on_end_q1 = function()
  on_end_func = nil
  orb.core.reset()
  orb.core.set_pause(0)
  if pred.r2_dmg.get_action_state() then
    pred.r2_dmg.invoke_action(true)
    return true
  end
  if not orb.combat.target then
    if pred.w.get_action_state() then
      pred.w.invoke_action(true)
    end
  end
end


local on_end_w = function()
  on_end_func = nil
  orb.core.set_pause(0)
  
  if not menu.combat:get() then return end

  if pred.r2_dmg.get_action_state() then
    pred.r2_dmg.invoke_action(true)
    return true
  end

  local q = pred.q.get_action_state()
  local e = pred.e.get_action_state()
  local e_q = pred.e_q.get_action_state()
  local rh = crescent_wrapper.get_action_state()
  local r1 = pred.r1.get_action_state()

  if e_q and q then
    if e_q.obj.ptr ~= q.obj.ptr then
      e_q.invoke_action(true)
      if r1 and menu.r1:get() then
        pred.r1.invoke_action(true)
      end
      return true
    end
  end

  if e and q then
    if e.obj.ptr ~= q.obj.ptr then
      e.invoke_action(true)
      if r1 and menu.r1:get() then
        pred.r1.invoke_action(true)
      end
      return true
    end
  end

  if not orb.core.can_attack() then
    if q then
      pred.q.invoke_action(true)
      return true -- w->q
    end
    if rh then
      crescent_wrapper.invoke_action(true)
      return true -- w->rh
    end
  end
end

local run = function ()
  local q = pred.q.get_action_state()
  local w = pred.w.get_action_state()
  local e = pred.e.get_action_state()
  local e_w = pred.e_w.get_action_state()
  local e_q = pred.e_q.get_action_state()
  local rh = crescent_wrapper.get_action_state()

  local qReady = pred.q.get_spell_state()
  local wReady = pred.w.get_spell_state()
  local eReady = pred.e.get_spell_state()

  if eReady and not player.path.isDashing then
    player:castSpell('pos', 2, mousePos)
  end
  if qReady and not player.path.isDashing then
    player:castSpell('pos', 0, mousePos)
  end
  if orb.core.can_action() then
    player:move(mousePos)
  end
end


local general = function()
  local q = pred.q.get_action_state()
  local w = pred.w.get_action_state()
  local e = pred.e.get_action_state()
  local e_w = pred.e_w.get_action_state()
  local e_q = pred.e_q.get_action_state()
  local rh = crescent_wrapper.get_action_state()

  local qReady = pred.q.get_spell_state()
  local wReady = pred.w.get_spell_state()
  local eReady = pred.e.get_spell_state()
  local qSlot = player:spellSlot(0)
  if not orb.menu.hybrid.key:get() then return end
  -- harass  q + w + AA
  if qReady and qSlot.stacks <= 0 and wReady then
    if q and qSlot.stacks <= 0 and pred.w.get_action_state(q.pos) then
      pred.q.invoke_action(true)
      pred.w.invoke_action(true)
      local obj = w.obj
      player:attack(obj)
      orb.core.set_server_pause()
      orb.combat.set_invoke_after_attack(false)
    end
  elseif rh then
    crescent_wrapper.invoke_action(true)
    orb.combat.set_invoke_after_attack(false)
  elseif w then
    pred.w.invoke_action(true)
    local obj = w.obj
    player:attack(obj)
    orb.core.set_server_pause()
    orb.combat.register_f_after_attack(run)
  end
  
end


-- orb.combat.register_f_after_attack(run)


orb.combat.register_f_pre_tick(general)