local Vector2 = require("classes/vector2")
local TowerData = require("data/towers")
local Button = require("ui/button")

---@class Tower
---@field ID string
---@field Stats table
---@field Position Vector2
---@field ScreenPosition Vector2
---@field AttackTimer number
---@field TargetMode "first" | "closest" | "strongest" | "weakest" | "last"
---@field Selected boolean
---@field Button Button
---@field AnimTimer number
---@field AnimFrame number
---@field Sprites table
local Tower = {}
Tower.__index = Tower

---Constructor for Tower object
---@param name string
---@param worldPos Vector2
---@param screenPos Vector2
function Tower.new(name, worldPos, screenPos)
	local instance = setmetatable({}, Tower)

	instance.ID = name
	instance.Stats = TowerData[name]
	instance.Position = worldPos
	instance.ScreenPosition = screenPos
	instance.TargetMode = "first"
	instance.AttackTimer = 0

	instance.AnimFrame = 1
	instance.AnimTimer = 0
	instance.Sprites = {} --lick wants me to preload or something idk
	for i, path in ipairs(TowerData[name].sprites) do
		if type(path) == "string" then
			instance.Sprites[i] = love.graphics.newImage(path)
		else
			instance.Sprites[i] = path -- already an Image
		end
	end

	instance.Selected = false

	instance.Button = Button.new(screenPos.X, screenPos.Y, 15, 15, "") --this seems off will change dimensions
	instance.Button.Clicked:Connect(function()
		instance.Selected = true
		print(instance.ID .. " was clicked! Selected: " .. tostring(instance.Selected))
	end)

	instance.Button.Unclicked:Connect(function()
		instance.Selected = false
	end)

	--stuff for potential 2 image animation idk
	--instance.sprites = TowerData[name].sprites
	-- instance.activeFrame = 1
	-- instance.animationTimer = 0
	-- instance.animationSpeed = 0.5

	return instance
end

---Finds the appropiate target to attack
---@param activeEnemies Attacker[]
function Tower:findTarget(activeEnemies) -- modes need to be tested
	local mode = self.TargetMode or "first"
	local bestTarget = nil
	local closestDistance
	local bestDistance = nil
	local worstDistance = nil
	local bestHealth = nil
	local worstHealth = nil

	for _, target in ipairs(activeEnemies) do
		local enemyPosition = target.Position
		local distance = (self.Position - enemyPosition):len()

		local nextEndPoint = target.Path[target.EndPoint + 1]
		local pathDistance = 0

		if nextEndPoint then
			local nextPointPos = Vector2.new(nextEndPoint.x, nextEndPoint.y)
			pathDistance = (enemyPosition - nextPointPos):len() --distance to next point on path
		end

		if distance < self.Stats.range then --implement modes: first, last, closest, strongest, weakest
			if mode == "closest" then
				if not closestDistance or distance < closestDistance then
					closestDistance = distance
					bestTarget = target
				end
			elseif mode == "strongest" then
				if not bestHealth or bestHealth < target.Health then
					bestHealth = target.Health
					bestTarget = target
				end
			elseif mode == "weakest" then
				if not worstHealth or worstHealth > target.Health then
					worstHealth = target.Health
					bestTarget = target
				end
			elseif mode == "first" then
				if not bestDistance or bestDistance > pathDistance then
					bestDistance = pathDistance
					bestTarget = target
				end
			elseif mode == "last" then
				if not worstDistance or worstDistance < pathDistance then
					worstDistance = pathDistance
					bestTarget = target
				end
			end
		end
	end
	return bestTarget
end

---Attacks the given enemy!
---@param enemy Attacker
function Tower:attack(enemy) -- expects enemy death logic
	if enemy.Health <= 0 then
		return
	end
	-- if self.stats.onHit then --no onhits yet but will be useful probably
	-- 	self.stats.onHit(enemy, self)
	enemy.Health = enemy.Health - self.Stats.attack

	self.AnimFrame = 2 --attack state
	self.AnimTimer = 0
end

---Checks if there's any overlap when placing
---@param towerList Tower[]
---@param x number
---@param y number
function Tower.isNotOverlapping(towerList, x, y)
	local padding = 30

	for _, t in ipairs(towerList) do
		local towerDifference = Vector2.new(x - t.Position.X, y - t.Position.Y)
		local distance = towerDifference:len()

		if distance < padding then
			return false
		end
	end
	return true
end

-- function Tower.spawn(name, position)
-- 	if Tower.canPlace(name, position) then --this doesnt exist
-- 		local newTower = Tower.new(name, position)
-- 		--table.insert(list of towers, newTower)

-- 		--add cost logic once thats figured out
-- 	end
-- 	return nil
-- end

---Update loop for tower
---@param dt number
---@param activeEnemies Attacker[]
function Tower:update(dt, activeEnemies, cardActive)
	self.AnimTimer = self.AnimTimer + dt
	if self.AnimTimer >= 0.1 then -- show frame 2 for 0.1s then snap back
		self.AnimFrame = 1
	end

	self.AttackTimer = self.AttackTimer + dt

	local target = self:findTarget(activeEnemies)
	if target and self.AttackTimer > self.Stats.cooldown then
		self:attack(target)
		self.AttackTimer = 0
	end
	if not cardActive then --makes sure you cant click through card
		self.Button:update(dt)
	end
end

function Tower:remove() --just makes a flag so it can be cleaned up in the update loop
	self.isDead = true
end

function Tower:draw() --temporary placeholder
	local sprite = self.Sprites[self.AnimFrame]
	if not sprite then
		return
	end
	local w, h = sprite:getDimensions()

	love.graphics.draw(
		sprite,
		self.ScreenPosition.X,
		self.ScreenPosition.Y,
		0, -- rotation
		32 / w, -- scaled to 32x32
		32 / h,
		w / 2, --center
		h / 2
	)

	--draws the range
	if self.Selected then
		love.graphics.setColor(1, 1, 1, 0.1)
		love.graphics.circle("fill", self.ScreenPosition.X, self.ScreenPosition.Y, self.Stats.range * SCALE_X)

		love.graphics.setColor(1, 1, 1, 0.5)
		love.graphics.circle("line", self.ScreenPosition.X, self.ScreenPosition.Y, self.Stats.range * SCALE_X)
	end

	if GRAFT_MODE and self ~= GRAFTING_TOWER then
		love.graphics.setColor(0.3, 0.8, 0.3, 0.4)
		love.graphics.circle("fill", self.ScreenPosition.X, self.ScreenPosition.Y, 24)
		love.graphics.setColor(0.3, 0.8, 0.3, 0.9)
		love.graphics.circle("line", self.ScreenPosition.X, self.ScreenPosition.Y, 24)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

return Tower
