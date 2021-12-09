local orb = module.internal('orb')
local menu = module.load(header.id, 'menu')

local spell = module.load(header.id, 'spell/main')
local TS = module.internal('TS')
local core = module.load(header.id, 'core/main')

local pred = module.load(header.id, 'pred/main')


local GetFirstWallPoint = function (from,to,step)
    from = from:to2D()
    to = to:to2D() 
    step = step or 25
    local direction  = (to - from).norm();
    for d=0, from.dist(to), step do
      local testPoint = from + d * direction
      if navmesh.isWall(testPoint.X, testPoint.Y) or navmesh.isStructure(testPoint.X, testPoint.Y) then
        return from + (d - step) * direction;
      end
    end
    return nil
end

local WallJump = function ()
  local qSlot = player:spellSlot(0)
  local q = pred.q.get_spell_state()
  if q and slot.stacks ~= 2 then
    player:castSpell('pos', 0, mousePos)
  end

  local wallCheck = GetFirstWallPoint(player.pos,mousePos)
  print

end