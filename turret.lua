local U = require "utils"

local function newBullet(x, y, dir)
  return { x = x, y = y, w = 8, h = 4, vx = 250 * dir }
end

local Turret   = {}
Turret.__index = Turret

function Turret.new(t)
  return setmetatable({
    x = t.x, y = t.y, w = t.w, h = t.h,
    cooldown = 0,
  }, Turret)
end

function Turret:update(dt, player, bullets)
  self.cooldown = self.cooldown - dt
  if self.cooldown <= 0 then
    local dir             = (player.x < self.x) and -1 or 1
    bullets[#bullets + 1] = newBullet(
        self.x + (dir == 1 and self.w or -8),
        self.y + self.h / 2 - 2,
        dir
    )
    self.cooldown         = 1.2
  end
end

function Turret:draw()
  love.graphics.setColor(0.8, 0.1, 0.1)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  love.graphics.setColor(1, 1, 1)
end

local Bullet = {}

function Bullet.updateAll(dt, bullets)
  for i = #bullets, 1, -1 do
    local b = bullets[i]
    b.x     = b.x + b.vx * dt
    if b.x < -20 or b.x > 900 then
      table.remove(bullets, i)
    end
  end
end

function Bullet.drawAll(bullets)
  love.graphics.setColor(1, 1, 0)
  for _, b in ipairs(bullets) do
    love.graphics.rectangle("fill", b.x, b.y, b.w, b.h)
  end
  love.graphics.setColor(1, 1, 1)
end

function Bullet.checkHit(player, bullets)
  for i = #bullets, 1, -1 do
    local b = bullets[i]
    if U.aabb(player, b) then
      table.remove(bullets, i)
      return true
    end
  end
  return false
end

return {
  Turret = Turret,
  Bullet = Bullet
}
