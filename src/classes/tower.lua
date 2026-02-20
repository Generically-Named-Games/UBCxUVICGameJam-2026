local Vector2 = require("/classes/vector2")
local TowerData = require("/data/towers")
local Button = require("/ui/button")

local Tower = {}

Tower.__index = Tower

function Tower.new(name, position)
	local instance = setmetatable({}, Tower)

	instance.id = name
	instance.stats = TowerData[name]
	instance.position = position
	instance.targetMode = "first"
	instance.attackTimer = 0

	instance.animFrame = 1
	instance.animTimer = 0
	instance.sprites = {} --lick wants me to preload or something idk
	for i, path in ipairs(TowerData[name].sprites) do
		if type(path) == "string" then
			instance.sprites[i] = love.graphics.newImage(path)
		else
			instance.sprites[i] = path -- already an Image
		end
	end

	instance.selected = false

	instance.button = Button.new(position.x * SCALE_X, position.y * SCALE_Y, 15, 15, "") --this seems off will change dimensions
	instance.button.Clicked:Connect(function()
		instance.selected = true
		print(instance.id .. " was clicked! Selected: " .. tostring(instance.selected))
	end)

	instance.button.Unclicked:Connect(function()
		instance.selected = false
	end)

	return instance
end

function Tower:findTarget(activeEnemies) -- modes need to be tested
	local mode = self.targetMode or "first"
	local bestTarget = nil
	local closestDistance
	local bestDistance = nil
	local worstDistance = nil
	local bestHealth = nil
	local worstHealth = nil
	local towerVector = Vector2.new(self.position.x, self.position.y)

	for _, target in ipairs(activeEnemies) do
		local enemyVector = Vector2.new(target.x, target.y)
		local distance = (towerVector - enemyVector):len()

		local nextEndPoint = target.path[target.endPoint + 1]
		local pathDistance = 0

		if nextEndPoint then
			local nexPointVector = Vector2.new(nextEndPoint.x, nextEndPoint.y)
			pathDistance = (enemyVector - nexPointVector):len() --distance to next point on path
		end

		if distance < self.stats.range then --implement modes: first, last, closest, strongest, weakest
			if mode == "closest" then
				if not closestDistance or distance < closestDistance then
					closestDistance = distance
					bestTarget = target
				end
			elseif mode == "strongest" then
				if not bestHealth or bestHealth < target.health then
					bestHealth = target.health
					bestTarget = target
				end
			elseif mode == "weakest" then
				if not worstHealth or worstHealth > target.health then
					worstHealth = target.health
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

function Tower:attack(enemy) -- expects enemy death logic
	-- if self.stats.onHit then --no onhits yet but will be useful probably
	-- 	self.stats.onHit(enemy, self)
	if enemy.health <= 0 then
		return
	end

	enemy.health = enemy.health - self.stats.attack
	self.animFrame = 2 --attack state
	self.animTimer = 0
end

function Tower.isNotOverlapping(towerList, x, y)
	local padding = 30

	for _, t in ipairs(towerList) do
		local towerDifference = Vector2.new(x - t.position.x, y - t.position.y)
		local distance = towerDifference:len()

		if distance < padding then
			return false
		end
	end
	return true
end

function Tower:remove() --just makes a flag so it can be cleaned up in the update loop
	self.isDead = true
end

function Tower:update(dt, activeEnemies)
	self.animTimer = self.animTimer + dt
	if self.animTimer >= 0.1 then -- show frame 2 for 0.1s then snap back
		self.animFrame = 1
	end
	self.attackTimer = self.attackTimer + dt

	local target = self:findTarget(activeEnemies)
	if target and self.attackTimer > self.stats.cooldown then
		self:attack(target)
		self.attackTimer = 0
	end

	self.button:update(dt)
end

function Tower:draw()
	--placeholder
	--draws the "tower"
	-- love.graphics.setColor(1, 0, 0.1)
	-- love.graphics.rectangle("fill", self.position.x - 7.5, self.position.y - 7.5, 15, 15) -- need to subtract by half the size!

	--draws the range

	-- love.graphics.setColor(1, 1, 1, 1)
	local sprite = self.sprites[self.animFrame]
	if not sprite then
		return
	end
	local w, h = sprite:getDimensions()
	love.graphics.draw(
		sprite,
		self.position.x,
		self.position.y,
		0, -- rotation
		32 / w, -- scaled to 32x32
		32 / h,
		w / 2, --center
		h / 2
	)
	if self.selected then
		love.graphics.setColor(1, 1, 1, 0.1)
		love.graphics.circle("fill", self.position.x, self.position.y, self.stats.range)

		love.graphics.setColor(1, 1, 1, 0.5)
		love.graphics.circle("line", self.position.x, self.position.y, self.stats.range)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

return Tower
