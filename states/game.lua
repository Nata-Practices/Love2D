local G           = require "gamestate"
local L           = require "levels"
local Player      = require "player"
local Box         = require "box"
local T           = require "turret"

local abilityInfo = {
  doubleJump = "Новая способность: ДВОЙНОЙ ПРЫЖОК - Space ещё раз в воздухе",
  dash = "Новая способность: РЫВОК - Left Shift",
  wallJump = "Новая способность: СТЕНОПРЫЖОК - прыгните, касаясь стены",
  glide = "Новая способность: ПЛАНИРОВАНИЕ - держите Space при падении",
  push = "Новая способность: ТОЛЧОК - упирайтесь и идите",
  shield = "Новая способность: ЩИТ (2 с) - клавиша S",
  teleport = "Новая способность: ТЕЛЕПОРТ к курсору - клавиша T",
  speed = "Новая способность: СКОРОСТЬ +50 %",
  groundPound = "Новая способность: УДАР О ЗЕМЛЮ - удерживайте ↓ в воздухе",
}

local game        = {}
local levelColors = {
  { 0.95, 0.20, 0.20 }, -- 1  ярко-красный
  { 0.99, 0.55, 0.00 }, -- 2  оранжевый
  { 0.98, 0.85, 0.05 }, -- 3  жёлтый
  { 0.35, 0.30, 0.20 }, -- 4  насыщенный зелёный
  { 0.10, 0.75, 0.80 }, -- 5  бирюзовый
  { 0.20, 0.45, 0.95 }, -- 6  чистый голубой
  { 0.35, 0.25, 0.90 }, -- 7  индиго
  { 0.70, 0.25, 0.90 }, -- 8  фиолетовый
  { 0.90, 0.20, 0.60 }, -- 9  ярко-розовый
  { 0.60, 0.60, 0.60 }, -- 10 нейтральный светло-серый (финал)
}
function game:enter(idx, images, fonts, tiles)
  -- страховка: если fonts не передали, берём текущий шрифт
  if fonts then self.fonts = fonts
  else
    local f    = love.graphics.getFont()
    self.fonts = { main = f, title = f }
  end

  self.images     = images or {}
  self.tiles      = tiles
  self.levelIndex = idx
  self.level      = L[idx]

  -- игрок + способности
  self.player     = Player.new(50, 400, self.images)
  for i = 1, idx do self.player:addAbility(L[i].ability) end

  -- ящики
  self.boxes = {}
  for _, b in ipairs(self.level.boxes or {}) do
    self.boxes[#self.boxes + 1] = Box.new(b)
  end

  -- турели + пули
  self.turrets = {}
  for _, t in ipairs(self.level.turrets or {}) do
    self.turrets[#self.turrets + 1] = T.Turret.new(t)
  end
  self.bullets    = {}

  -- флеш-текст
  local newAb     = (idx > 1) and L[idx].ability or nil
  self.flashText  = newAb and abilityInfo[newAb] or nil
  self.flashTimer = newAb and 3 or 0
  self.flashAlpha = 1
end

function game:update(dt)
  -- игрок
  self.player:update(dt, self.level, self.boxes)

  -- ящики
  for _, b in ipairs(self.boxes) do
    b:update(dt, self.player, self.level.platforms)
  end

  -- турели и пули
  for _, t in ipairs(self.turrets) do
    t:update(dt, self.player, self.bullets)
  end
  T.Bullet.updateAll(dt, self.bullets)

  -- попадание пули
  if T.Bullet.checkHit(self.player, self.bullets) then
    if self.player.shieldT <= 0 then
      G.switch(require("states.game"), self.levelIndex, self.images, self.fonts, self.tiles)
      return
    end
  end

  -- финиш
  local f       = self.level.flag
  local p       = self.player

  local overlap = p.x < f.x + f.w and p.x + p.w > f.x and p.y < f.y + f.h and p.y + p.h > f.y

  if overlap then
    if self.levelIndex < 10 then
      G.switch(require("states.game"), self.levelIndex + 1, self.images, self.fonts, self.tiles)
    else
      G.switch(require("states.win"), nil, self.fonts)
    end
  end

  -- таймер флеш-текста
  if self.flashTimer > 0 then
    self.flashTimer = self.flashTimer - dt
    if self.flashTimer <= 0 then self.flashTimer = 0 end
    self.flashAlpha = math.min(1, self.flashTimer / 0.5)
  end
end

function game:keypressed(k)
  if k == "escape" then
    G.switch(require("states.menu"), self.images, self.fonts, self.tiles)
    return
  end

  if k:match("^[1-9]$") or k == "0" then
    local target = (k == "0") and 10 or tonumber(k)
    G.switch(require("states.game"), target, self.images, self.fonts, self.tiles)
    return
  end
end

function game:draw()
  local c = levelColors[self.levelIndex] or { 0, 0, 0 }
  love.graphics.clear(c[1], c[2], c[3])

  for _, p in ipairs(self.level.platforms) do
    if p.y == 500 then
      local tileW = self.tiles.grass:getWidth()
      for x = p.x, p.x + p.w - 1, tileW do
        love.graphics.draw(self.tiles.grass, x, p.y)
      end
    else
      love.graphics.setColor(0.3, 0.8, 0.3)
      love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
      love.graphics.setColor(1, 1, 1)
    end
  end

  local f       = self.level.flag
  local flagImg = self.images.flag
  local scal    = f.h / flagImg:getHeight()
  love.graphics.draw(
      flagImg,
      f.x, f.y,
      0,
      scal, scal
  )

  for _, b in ipairs(self.boxes) do b:draw() end

  for _, t in ipairs(self.turrets) do t:draw() end
  T.Bullet.drawAll(self.bullets)

  self.player:draw()

  love.graphics.setFont(self.fonts.main)
  love.graphics.print("Уровень: " .. self.levelIndex, 10, 10)

  if self.flashText and self.flashTimer > 0 then
    love.graphics.setFont(self.fonts.title)
    love.graphics.setColor(1, 1, 1, self.flashAlpha)
    love.graphics.printf(self.flashText, 0, 150, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(self.fonts.main)
  end
end

return game