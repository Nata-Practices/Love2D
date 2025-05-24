local G = {}
local current

function G.switch(state, ...)
  assert(type(state) == "table", "state must be table")
  if current and current.leave then current:leave() end
  current = state
  if current.enter then current:enter(...) end
end

function G.registerEvents()
  function love.update(dt) if current and current.update then current:update(dt) end end
  function love.draw() if current and current.draw then current:draw() end end
  function love.keypressed(k, sc) if current and current.keypressed then current:keypressed(k, sc) end end
end

return G
