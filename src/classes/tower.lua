local Vector2 = require("/classes/vector2")
local TowerData = require("/data/towers")

local Tower = {}

Tower.__index = Tower

function Tower.new(name, position)
	local instance = setmetatable({}, Tower)

	instance.id = name
	instance.stats = TowerData[name]
	instance.position = position
	instance.targetMode = "first"

	return instance
end

function Tower:findTarget(range) -- unfinished, need distance along the path
	local mode = self.mode or "first"
	local bestTarget = nil

	local closestDistance
	local bestDistance = nil
	local worstDistance = nil
	local bestHealth = nil
	local worstHealth = nil

	local attackers --placeholder
	for i, target in ipairs(attackers) do
		local distance = Vector2.sub(self.position, target.position) --need magnitude maybe make vector2 func
		--local pathDistance = [target position along map path], best/worst distance should be based on this

		if distance < range then --implement modes: first, last, closest, strongest, weakest
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
	if enemy.health <= 0 then
		--enemy death logic
	end
end

function Tower.canPlace(name, position) --wip, dont know how to check map tiles
	local towerSize = TowerData[name].size
	if towerSize then
		--check if tiles are empty and valid for placement
		--check if player can afford/ other restrictions on placement
	end
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
