local sti = require("sti")
local map_functions = require("map_functions")
local TweenManager = require("/services/tween_manager") ---@type TweenManager
local Game = require("/services/game") ---@type Game
local window_functions = require("window_functions")
local Attacker = require("/classes/attacker")
local Tower = require("/classes/tower")
local lick = require("lick")

-- lick config
lick.reset = true -- reload love.load every time you save
lick.updateAllFiles = true -- watch all files
lick.fileExtensions = {} -- watch all file types
lick.clearPackages = true -- clear package cache on reload

-- Table of map objects
local maps = {}
local path = {}
--Load in the map and whether its layers are visible
function love.load()
	window_functions.setFullscreen("desktop")

	Game:CreatePauseButton()

	maps.map1 = sti("assets/maps/map1.lua")
	maps.map1.layers["Bushes"].visible = false

	path = map_functions.getPath(maps.map1, "MainPath", "")

	--dummy plant
	local position = { x = path[2].x - 70, y = path[2].y + 60 }
	local vine = Tower.new("vine", position)
	table.insert(Game.ActiveTowers, vine)

	--dummy bug
	local bug = Attacker.new("bug", path[1], path)
	table.insert(Game.ActiveEnemies, bug)
end

function love.update(dt)
	Game:update(dt)
	for i = #Game.ActiveEnemies, 1, -1 do
		if Game.ActiveEnemies[i].health <= 0 then
			table.remove(Game.ActiveEnemies, i)
		end
	end
end

--Draws the map to fit the whole screen
function love.draw()
	TweenManager:update()

	assert(maps.map1, "map1 was nil!")

	local mapWidth = maps.map1.width * maps.map1.tilewidth
	local mapHeight = maps.map1.height * maps.map1.tileheight

	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()

	local scaleX = screenWidth / mapWidth
	local scaleY = screenHeight / mapHeight

	maps.map1:draw(0, 0, scaleX, scaleY)

	love.graphics.push()
	love.graphics.scale(scaleX, scaleY)

	Game:drawInMap()

	-- why the fuck does dividing by 2 everywhere here work (at least for 1920x1080)? i tried it randomly and now everything is aligned.
	-- i dont get love2d man :sob:
	if path and #path > 0 then
		-- Set color to something bright like Yellow
		love.graphics.setColor(1, 1, 0)

		for i, point in ipairs(path) do
			-- Draw a circle at the path coordinate
			love.graphics.circle("fill", point.x, point.y / 2, 5)

			-- Optional: Label the points so you know the order
			love.graphics.print("Point " .. i, point.x + 10, point.y / 2 - 10)

			-- Draw a line to the next point to show the path segment
			if path[i + 1] then
				love.graphics.line(point.x, point.y / 2, path[i + 1].x, path[i + 1].y / 2)
			end
		end

		-- Always reset color to white so it doesn't tint your map/sprites
		love.graphics.setColor(1, 1, 1)
	end

	love.graphics.pop()

	Game:draw()
end
