local U     = require "utils"
local Box   = {}
Box.__index = Box

local function yOverlap(a, b)
  return a.y < b.y + b.h and a.y + a.h > b.y
end

local boxImage   = love.graphics.newImage("assets/sprites/box.png")
local imgW, imgH = boxImage:getWidth(), boxImage:getHeight()

function Box.new(t)
  return setmetatable({
    x = t.x, y = t.y,
    w = t.w, h = t.h,
    vx = 0
  }, Box)
end

function Box:update(dt, player, platforms)
  if player:has("push") and player.vx ~= 0 then
    if player.vx > 0 then
      local touching = yOverlap(player, self) and math.abs((player.x + player.w) - self.x) < 2
      if touching then self.vx = player.vx end
    elseif player.vx < 0 then
      local touching = yOverlap(player, self) and math.abs(player.x - (self.x + self.w)) < 2
      if touching then self.vx = player.vx end
    end
  end

  self.x = self.x + self.vx * dt
  if self.vx > 0 then
    self.vx = math.max(0, self.vx - 500 * dt)
  elseif self.vx < 0 then
    self.vx = math.min(0, self.vx + 500 * dt)
  end

  for _, p in ipairs(platforms) do
    if U.aabb(self, p) then
      if self.vx > 0 and self.x + self.w > p.x and self.x < p.x then
        self.x, self.vx = p.x - self.w, 0
      elseif self.vx < 0 and self.x < p.x + p.w and self.x + self.w > p.x + p.w then
        self.x, self.vx = p.x + p.w, 0
      end
    end
  end
end

function Box:draw()
  love.graphics.draw(
      boxImage,
      self.x, self.y,
      0,
      self.w / imgW,
      self.h / imgH
  )
  return
end

return Box
