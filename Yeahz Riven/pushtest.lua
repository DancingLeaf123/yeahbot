--this example is based on xerath w
local orb = module.internal('orb')
local ts = module.internal('TS')
local pred = module.internal('pred')

local pred_input = {
    delay = 0.75,
    radius = 300,
    speed = math.huge,
    boundingRadiusMod = 0,
}

local function trace_filter(seg, obj)
  if seg.startPos:dist(seg.endPos) > 400 then return false end

  if pred.trace.circular.hardlock(pred_input, seg, obj) then
    return true
  end
  if pred.trace.circular.hardlockmove(pred_input, seg, obj) then
    return true
  end
  if pred.trace.newpath(obj, 0.033, 0.500) then
    return true
  end
end

local function target_filter(res, obj, dist)
    print(dist)
    if dist > 400 then return false end
    local seg = pred.circular.get_prediction(pred_input, obj)
    print(seg.startPos:dist(seg.endPos),type(seg))

    if not seg then return false end
    if not trace_filter(seg, obj) then return false end

    res.pos = seg.endPos
    return true 
end

local function on_tick()
    if player:spellSlot(1).state~=0 then return end
    local res = ts.get_result(target_filter)
    if res.pos then
        player:castSpell('pos', 1, vec3(res.pos.x, mousePos.y, res.pos.y))
        -- local count_res = 0
        -- for _ in pairs(res) do count_res = count_res + 1 end
        -- print("size of fifth table is ::" , count_res)
        -- print(#res)
        orb.core.set_server_pause()
        return true
    end
end


-- cb.add(cb.tick, on_tick)

return pushtest