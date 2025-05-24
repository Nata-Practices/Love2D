local U        = require "utils"
local Player   = {};
Player.__index = Player

function Player.new(x, y, sprites)
  local self = setmetatable({
    x = x, y = y, w = 30, h = 50,

    vx = 0, vy = 0, dir = 1,
    onGround = false, jumpsLeft = 1,

    dashCD = 0, dashT = 0,
    shieldT = 0,

    groundPounding = false,
    abilities = {},
    sprite = sprites.player,
  }, Player)

  self.spawnX, self.spawnY = x, y

  return self
end

function Player:has(a) return self.abilities[a] end
function Player:addAbility(a) if a then self.abilities[a] = true end end

function Player:resetToSpawn()
  self.x, self.y = self.spawnX, self.spawnY
  self.vx, self.vy = 0, 0
  self.dashT, self.groundPounding = 0, false
end

local function safeTeleport(self, newX, newY, level)
  local maxX = love.graphics.getWidth() - self.w
  local maxY = love.graphics.getHeight() - self.h
  newX       = math.max(0, math.min(newX, maxX))
  newY       = math.max(0, math.min(newY, maxY))

  for _, p in ipairs(level.platforms) do
    if newX + self.w > p.x and newX < p.x + p.w and
        newY + self.h > p.y and newY < p.y + p.h then
      newY = p.y - self.h
    end
  end

  return newX, newY
end

function Player:update(dt, level, boxes)
  local speed   = self:has("speed") and 300 or 200
  local gravity = 800
  local left    = love.keyboard.isDown("left") or love.keyboard.isDown("a")
  local right   = love.keyboard.isDown("right") or love.keyboard.isDown("d")

  self.vx       = 0
  if left then
    self.vx  = -speed;
    self.dir = -1
  end
  if right then
    self.vx  = speed;
    self.dir = 1
  end

  if U.wasPressed("space") then
    if self.onGround then
      self.vy = -350
      if self:has("doubleJump") then self.jumpsLeft = 1 end
    elseif self:has("doubleJump") and self.jumpsLeft > 0 then
      self.vy        = -350;
      self.jumpsLeft = 0
    elseif self:has("wallJump") and self.wallSide then
      self.vy = -350;
      self.vx = 250 * (-self.wallSide)
    end
  end

  self.dashCD = math.max(0, self.dashCD - dt)
  if self:has("dash") and U.wasPressed("lshift") and self.dashCD == 0 then
    self.vx     = 500 * self.dir;
    self.dashT  = 0.35;
    self.dashCD = 1
  end
  if self.dashT > 0 then self.dashT = self.dashT - dt end

  if self:has("teleport") and U.wasPressed("t") then
    local mx, my   = love.mouse.getPosition()
    local tx       = mx - self.w / 2
    local ty       = my - self.h / 2

    tx, ty         = safeTeleport(self, tx, ty, level)

    self.x, self.y = tx, ty
  end

  if self:has("shield") and U.wasPressed("s") then self.shieldT = 2 end
  self.shieldT = math.max(0, self.shieldT - dt)

  if self:has("groundPound") and not self.onGround
      and love.keyboard.isDown("down") then
    self.vy             = 900
    self.groundPounding = true
  end

  if self:has("glide") and self.vy > 0 and love.keyboard.isDown("space") then
    self.vy = self.vy * 0.4
  end

  local dx = (self.dashT > 0 and 1.5 or 1) * self.vx * dt
  self.x   = self.x + dx

  do
    local screenW = love.graphics.getWidth()
    if self.x < 0 then
      self.x = 0
    elseif self.x + self.w > screenW then
      self.x = screenW - self.w
    end
  end

  for _, p in ipairs(level.platforms) do
    if U.aabb(self, p) then
      if dx > 0 and self.x + self.w > p.x and self.x < p.x then
        self.x = p.x - self.w
      elseif dx < 0 and self.x < p.x + p.w
          and self.x + self.w > p.x + p.w then
        self.x = p.x + p.w
      end
    end
  end

  self.vy       = self.vy + gravity * dt
  self.y        = self.y + self.vy * dt

  self.onGround = false
  self.wallSide = nil

  for _, p in ipairs(level.platforms) do
    if U.aabb(self, p) then
      if self.vy > 0 and self.y + self.h - 5 < p.y then
        self.y         = p.y - self.h;
        self.vy        = 0;
        self.onGround  = true
        self.jumpsLeft = self:has("doubleJump") and 1 or 0

        if self.groundPounding then
          for _, b in ipairs(boxes) do
            if math.abs((b.y + b.h) - (self.y + self.h)) < 5 then
              local centerP = self.x + self.w / 2
              local centerB = b.x + b.w / 2
              if math.abs(centerB - centerP) <= 120 then
                local dir = (centerB < centerP) and -1 or 1
                b.vx      = 300 * dir
              end
            end
          end
        end
        self.groundPounding = false
      elseif self.vy < 0 and self.y > p.y + p.h - 5 then
        self.y  = p.y + p.h;
        self.vy = 0
      end
    end

    if self:has("wallJump") and
        self.y + self.h > p.y + 10 and self.y < p.y + p.h - 10 then
      if self.x + self.w <= p.x + 5 and self.x + self.w >= p.x then
        self.wallSide = 1
      end
      if self.x >= p.x + p.w - 5 and self.x <= p.x + p.w then
        self.wallSide = -1
      end
    end
  end

  for _, b in ipairs(boxes) do
    if U.aabb(self, b) then
      if self.vx > 0 then self.x = b.x - self.w
      elseif self.vx < 0 then self.x = b.x + b.w end
    end
  end

  local sw, sh = love.graphics.getDimensions()
  if self.y > sh then self:resetToSpawn() end
end

function Player:draw()
  if self.shieldT > 0 then
    love.graphics.setColor(0, 0.7, 1, 0.3)
    love.graphics.circle("fill", self.x + self.w / 2, self.y + self.h / 2, 35)
    love.graphics.setColor(1, 1, 1)
  end

  local sx = (self.dir == 1 and 1 or -1) * (self.w / self.sprite:getWidth())
  local sy = self.h / self.sprite:getHeight()
  local ox = (self.dir == 1 and 0 or self.sprite:getWidth())

  love.graphics.draw(
      self.sprite,
      self.x, self.y,
      0,
      sx, sy,
      ox, 0
  )
end

return Player
