local Vector2 = require("/classes/vector2")
local TowerData = require("/data/towers")
local Button = require("/ui/button")
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

	instance.selected = false

	instance.button = Button.new(position.x, position.y, 15, 15, "") --this seems off will change dimensions
	instance.button.Clicked:Connect(function()
		instance.selected = true
		print(instance.id .. " was clicked! Selected: " .. tostring(instance.selected))
	end)

	instance.button.Unclicked:Connect(function()
		instance.selected = false
	end)

	--stuff for potential 2 image animation idk
	--instance.sprites = TowerData[name].sprites
	-- instance.activeFrame = 1
	-- instance.animationTimer = 0
	-- instance.animationSpeed = 0.5

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
	if enemy.health <= 0 then
		return
	end
	-- if self.stats.onHit then --no onhits yet but will be useful probably
	-- 	self.stats.onHit(enemy, self)
	enemy.health = enemy.health - self.stats.attack
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

function Tower.spawn(name, position)
	if Tower.canPlace(name, position) then
		local newTower = Tower.new(name, position)
		--table.insert(list of towers, newTower)

		--add cost logic once thats figured out
	end
	return nil
end

function Tower:remove() --just makes a flag so it can be cleaned up in the update loop
	self.isDead = true
end

function Tower:update(dt, activeEnemies)
	--will be used for animations with multiple sprites
	--self.animationTimer = self.animationTimer + dt

	-- if self.animationTimer > self.animationSpeed then
	-- 	if self.activeFrame == 1 then
	--         self.activeFrame = 2
	--     else
	--         self.activeFrame = 1
	--     end
	-- end
	self.attackTimer = self.attackTimer + dt

	local target = self:findTarget(activeEnemies)
	if target and self.attackTimer > self.stats.cooldown then
		self:attack(target)
		self.attackTimer = 0
	end

	self.button:update(dt)
end

function Tower:draw() --temporary placeholder
	--draws the "tower"
	love.graphics.setColor(1, 0, 0.1)
	love.graphics.rectangle("fill", self.position.x - 7.5, self.position.y - 7.5, 15, 15) -- need to subtract by half the size!

	--draws the range
	if self.selected then
		love.graphics.setColor(1, 1, 1, 0.1)
		love.graphics.circle("fill", self.position.x, self.position.y, self.stats.range)

		love.graphics.setColor(1, 1, 1, 0.5)
		love.graphics.circle("line", self.position.x, self.position.y, self.stats.range)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

return Tower
