local sti = require("sti")
local map_functions = require("map_functions")
local TweenManager = require("services/tween_manager") ---@type TweenManager
local Game = require("services/game") ---@type Game
local path_func = require("path_functions")
local Vector2 = require("classes/vector2")
local Tower = require("classes/tower")
local lick = require("lick")
local TowerCard = require("ui/towercard")
local Shop = require("ui/shop")
local WaveManager = require("services/wave_manager")
local TowerData = require("data/towers")
local GraftData = require("data/grafts")

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
local isPlacing = false
local placementType = "basic"
local card = TowerCard.new()

local waveManager = nil

local function onTowerSelected(towerType)
	placementType = towerType
	isPlacing = true
end
local shop = Shop.new(onTowerSelected)

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

	waveManager = WaveManager.new(path, Game.ActiveEnemies)

	--dummy bug
	--local bug = Attacker.new("bug", SPAWN_LOC, path)
	--table.insert(Game.ActiveEnemies, bug)
end

function love.update(dt)
	CARD_ACTIVE = card.Tower ~= nil
	GRAFT_MODE = card.IsGrafting
	GRAFTING_TOWER = card.Tower

	Game:update(dt)
	card:update(dt, Game.ActiveTowers)
	shop:update(dt)
	if Game.RoundStatus == "Ongoing" then
		waveManager:update(dt)
	end
	for i = #Game.ActiveEnemies, 1, -1 do
		if Game.ActiveEnemies[i].ReachedEnd then
			Game:Damage(25)
			table.remove(Game.ActiveEnemies, i)
		elseif Game.ActiveEnemies[i].Health <= 0 then
			Game:AddCurrency(20)
			table.remove(Game.ActiveEnemies, i)
		end
	end
	for i = #Game.ActiveTowers, 1, -1 do
		if Game.ActiveTowers[i].isDead then
			Game:AddCurrency(Game.ActiveTowers[i].Stats.cost * 0.7)
			table.remove(Game.ActiveTowers, i)
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
	waveManager:draw()

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
	card:draw()
	shop:draw()
	Game:draw()
end

function love.mousepressed(x, y, button)
	local worldX = (x + (love.graphics.getWidth() / SCALE_X)) / SCALE_X
	local worldY = (y + love.graphics.getHeight()) / SCALE_Y

	local worldPos = Vector2.new(worldX, worldY)
	local screenPos = Vector2.new(x, y)

	if shop:containsPoint(x, y) then
		return
	end
	if card:containsPoint(x, y) then
		return
	end

	if button == 1 and card.IsGrafting and card.Tower then
		for _, t in ipairs(Game.ActiveTowers) do
			if t ~= card.Tower then
				local dx = x - t.ScreenPosition.X
				local dy = y - t.ScreenPosition.Y
				if math.sqrt(dx * dx + dy * dy) < 20 then
					local graft = GraftData.getResult(card.Tower.ID, t.ID)
					if graft then
						card.Tower.ID = graft.result

						-- copy stats so we don't modify shared TowerData
						card.Tower.Stats = {}
						for k, v in pairs(TowerData[graft.result]) do
							card.Tower.Stats[k] = v
						end

						-- apply bonuses
						if graft.bonus then
							for stat, value in pairs(graft.bonus) do
								card.Tower.Stats[stat] = card.Tower.Stats[stat] + value
							end
						end

						-- swap sprites
						card.Tower.Sprites = {}
						for i, path in ipairs(TowerData[graft.result].sprites) do
							card.Tower.Sprites[i] = love.graphics.newImage(path)
						end

						t:remove()
						print("Grafted into:", graft.result)
					else
						print("No graft recipe for", card.Tower.ID, "+", t.ID)
					end
					card.IsGrafting = false
					return
				end
			end
		end
		return
	end
	if button == 1 and card.Tower then
		card.Tower.Selected = false
		card.Tower = nil
	end
	if button == 1 and isPlacing then
		local clear = Tower.isNotOverlapping(Game.ActiveTowers, worldX, worldY)
		local cost = TowerData[placementType].cost
		if clear and cost <= Game:GetCurrency() then
			Game:AddCurrency(-cost)
			local newTower = Tower.new(placementType, worldPos, screenPos)
			table.insert(Game.ActiveTowers, newTower)
			isPlacing = false
			shop:deselect()
		end
	elseif button == 2 then
		isPlacing = false
		shop:deselect()
	end
end
