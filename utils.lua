local U = {}

function U.aabb(a, b)
  return a.x < b.x + b.w and a.x + a.w > b.x and a.y < b.y + b.h and a.y + a.h > b.y
end

local pressed = {}
function U.wasPressed(key)
  if love.keyboard.isDown(key) then
    if not pressed[key] then
      pressed[key] = true
      return true
    end
  else pressed[key] = nil end
end

return U
