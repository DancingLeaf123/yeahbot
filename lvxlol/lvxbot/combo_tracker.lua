local wait_for_slot = nil
local wait_for_order = nil

local last_combo_time = nil

local add_combo = function(name)

  
end

cb.add(cb.issueorder, function(order)
  if order == 3 then
    add_combo('Order Attack')
    wait_for_slot = 3
  end
end)