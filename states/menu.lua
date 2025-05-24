local G    = require "gamestate"

local menu = {}

function menu:enter(images, fonts, tiles)
  self.images = images or {}
  self.fonts  = fonts
  self.tiles  = tiles
end

function menu:keypressed(k)
  if k == "return" then
    G.switch(require("states.game"), 1, self.images, self.fonts, self.tiles)
  elseif k == "escape" then
    love.event.quit()
  end
end

function menu:draw()
  love.graphics.setFont(self.fonts.title)
  love.graphics.printf("Нажмите Enter, чтобы начать", 0, 200, love.graphics.getWidth(), "center")
  love.graphics.setFont(self.fonts.main)
end

return menu
