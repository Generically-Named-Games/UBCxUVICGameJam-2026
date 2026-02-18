local sti = require("sti")
local map_functions = require("map_functions")
local window_functions = require("window_functions")

-- Table of map objects
local maps = {}

--Load in the map and whether its layers are visible
function love.load()
	window_functions.setFullscreen("desktop")
	maps.map1 = sti("assets/maps/map1.lua")
	maps.map1.layers["Bushes"].visible = false
end

--Draws the map to fit the whole screen
function love.draw()
	if maps.map1 then
		local mapWidth = maps.map1.width * maps.map1.tilewidth
		local mapHeight = maps.map1.height * maps.map1.tileheight

		local screenWidth = love.graphics.getWidth()
		local screenHeight = love.graphics.getHeight()

		local scaleX = screenWidth / mapWidth
		local scaleY = screenHeight / mapHeight

		maps.map1:draw(0, 0, scaleX, scaleY)
	end
end
-- MODULES
local window_functions = require("window_functions")
local TM = require("/services/tween_manager").new()

local dimensions = {
	X = 0,
	Y = 400,
}

function love.draw()
	TM:update()
	love.graphics.print("Hello World", dimensions.X, dimensions.Y)
end

local function playMyTween()
	local myTween = TM:Create(dimensions, 500, "X", 500)

	myTween.Completed:Connect(function()
		dimensions.X = 0
		playMyTween()
	end)

	myTween:Play()
end

playMyTween()
