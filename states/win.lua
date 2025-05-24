local win = {}

function win:enter(_, fonts)
  self.fonts = fonts
end

function win:keypressed()
  love.event.quit()
end

function win:draw()
  love.graphics.setFont(self.fonts.title)
  love.graphics.printf("Поздравляем! Вы открыли все способности!", 0, 200, love.graphics.getWidth(), "center")
  love.graphics.setFont(self.fonts.main)
  love.graphics.printf("Нажмите любую клавишу, чтобы выйти", 0, 240, love.graphics.getWidth(), "center")
end

return win
