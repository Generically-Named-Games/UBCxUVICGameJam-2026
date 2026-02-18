-- MODULES
local sti = require("sti")
local map_functions = require("map_functions")
local TM = require("/services/tween_manager").new()
local window_functions = require("window_functions")
local Attacker = require("/classes/attacker")

-- Table of map objects
local maps = {}
local enemies = {}
local path = {}
--Load in the map and whether its layers are visible
function love.load()
	window_functions.setFullscreen("desktop")
	maps.map1 = sti("assets/maps/map1.lua")
	maps.map1.layers["Bushes"].visible = false
	local attackPath = map_functions.getPath(maps.map1, "MainPath", "")
	path = attackPath
	local bug = Attacker.new("bug", attackPath[1], attackPath)
	table.insert(enemies, bug)
end

function love.update(dt)
	for _, e in ipairs(enemies) do
		e:update(dt)
	end
end

--Draws the map to fit the whole screen
function love.draw()
	TM:update()

	if maps.map1 then
		local mapWidth = maps.map1.width * maps.map1.tilewidth
		local mapHeight = maps.map1.height * maps.map1.tileheight

		local screenWidth = love.graphics.getWidth()
		local screenHeight = love.graphics.getHeight()

		local scaleX = screenWidth / mapWidth
		local scaleY = screenHeight / mapHeight

		maps.map1:draw(0, 0, scaleX, scaleY)
	end
	if not path or #path == 0 then
		return
	end

	-- Set color to something bright like Yellow
	love.graphics.setColor(1, 1, 0)

	for i, point in ipairs(path) do
		-- Draw a circle at the path coordinate
		love.graphics.circle("fill", point.x, point.y, 5)

		-- Optional: Label the points so you know the order
		love.graphics.print("Point " .. i, point.x + 10, point.y - 10)

		-- Draw a line to the next point to show the path segment
		if path[i + 1] then
			love.graphics.line(point.x, point.y, path[i + 1].x, path[i + 1].y)
		end
	end

	-- Always reset color to white so it doesn't tint your map/sprites
	love.graphics.setColor(1, 1, 1)

	for _, e in ipairs(enemies) do
		e:draw()
	end
end
