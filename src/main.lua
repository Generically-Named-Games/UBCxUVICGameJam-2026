local sti = require("sti")
local map_functions = require("map_functions")
local TweenManager = require("services/tween_manager") ---@type TweenManager
local Game = require("services/game") ---@type Game
local path_func = require("path_functions")
local Attacker = require("classes/attacker")
local Vector2 = require("classes/vector2")
local Tower = require("classes/tower")
local lick = require("lick")

-- lick config
lick.reset = true -- reload love.load every time you save
lick.updateAllFiles = true -- watch all files
lick.fileExtensions = {} -- watch all file types
lick.clearPackages = true -- clear package cache on reload

SCALE_X = 1
SCALE_Y = 1
SPAWN_LOC = Vector2.new(0, 0)

-- Table of map objects
local maps = {}
local path = {}
local isPlacing = true
local placementType = "vine"
--Load in the map and whether its layers are visible
function love.load()
	love.window.setMode(960, 640)

	Game:CreatePauseButton()

	maps.map1 = sti("assets/maps/map1.lua")
	--used to make map right size and allow mouse and map to interact normally
	SCALE_X = love.graphics.getWidth() / (maps.map1.width * maps.map1.tilewidth)
	SCALE_Y = love.graphics.getHeight() / (maps.map1.height * maps.map1.tileheight)

	path = map_functions.getPath(maps.map1, "MainPath", "")

	SPAWN_LOC = Vector2.new(path[1].x, path[1].y)

	--dummy bug
	local bug = Attacker.new("bug", SPAWN_LOC, path)
	table.insert(Game.ActiveEnemies, bug)
end

function love.update(dt)
	Game:update(dt)
	for i = #Game.ActiveEnemies, 1, -1 do
		if Game.ActiveEnemies[i] and Game.ActiveEnemies[i].Health <= 0 then
			table.remove(Game.ActiveEnemies, i)
		end
	end
end

--Draws the map to fit the whole screen
function love.draw()
	TweenManager:update()

	assert(maps.map1, "map1 was nil!")

	maps.map1:draw(0, 0, SCALE_X, SCALE_Y) --ignores the graphics.scale function, seems intentional

	--standardizes the scale for the following drawings

	Game:drawEntities() --draws towers and enemies seperate from stationary buttons

	if path and #path > 0 then
		-- Set color to something bright like Yellow
		love.graphics.setColor(1, 1, 0)

		for i, point in ipairs(path) do
			-- Draw a circle at the path coordinate
			local px = path_func.calculatePathPointX(point.x)
			local py = path_func.calculatePathPointY(point.y)
			love.graphics.circle("fill", px, py, 5)

			-- Optional: Label the points so you know the order
			love.graphics.print("Point " .. i, px + 10, py - 10)

			-- Draw a line to the next point to show the path segment
			if path[i + 1] then
				local nx = path_func.calculatePathPointX(path[i + 1].x)
				local ny = path_func.calculatePathPointY(path[i + 1].y)
				love.graphics.line(px, py, nx, ny)
			end
		end

		-- Always reset color to white so it doesn't tint your map/sprites
		love.graphics.setColor(1, 1, 1)
	end

	Game:draw()
end

function love.mousepressed(x, y, button)
	local worldX = (x + (love.graphics.getWidth() / SCALE_X)) / SCALE_X
	local worldY = (y + love.graphics.getHeight()) / SCALE_Y

	local worldPos = Vector2.new(worldX, worldY)
	local screenPos = Vector2.new(x, y)

	if button == 1 and isPlacing then
		local clear = Tower.isNotOverlapping(Game.ActiveTowers, worldX, worldY)

		if clear then
			local newTower = Tower.new(placementType, worldPos, screenPos)
			table.insert(Game.ActiveTowers, newTower)
			isPlacing = false
		end
	elseif button == 2 then
		isPlacing = false
	end
end
