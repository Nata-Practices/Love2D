local Gamestate = require "gamestate"

local images    = {}
local fonts     = {}
local tiles     = {}

local function loadTiles()
  tiles.grass = love.graphics.newImage("assets/tiles/grass.jpg")
  tiles.grass:setFilter("nearest", "nearest")
end

local function loadFonts()
  fonts.main  = love.graphics.newFont("assets/fonts/DejaVuSans.ttf", 16)
  fonts.title = love.graphics.newFont("assets/fonts/DejaVuSans.ttf", 24)
  love.graphics.setFont(fonts.main)
end

local function loadSprites()
  images.player = love.graphics.newImage("assets/sprites/player.png")
  images.flag   = love.graphics.newImage("assets/sprites/flag.png")
  images.player:setFilter("nearest", "nearest")
  images.flag:setFilter("nearest", "nearest")
end

function love.load()
  love.window.setTitle("10-Level Ability Game")
  loadFonts()
  loadTiles()
  loadSprites()
  Gamestate.registerEvents()
  Gamestate.switch(require("states.menu"), images, fonts, tiles)
end
