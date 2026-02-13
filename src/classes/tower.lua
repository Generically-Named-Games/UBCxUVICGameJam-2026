local Vector2 = require("/classes/vector2")
local TowerData = require("/data/towers")

local Tower = {}
--[[
Tower table holds all the active towers(might need a rename) 
towerUnit refers to an object in that table
name refers to the name of each tower template that is used to identify them
]]

function Tower.findTarget(towerUnit, range, mode) -- unfinished, need distance along the path
	mode = mode or "first"
	local bestTarget = nil

	local closestDistance
	local bestDistance = nil
	local worstDistance = nil
	local bestHealth = nil
	local worstHealth = nil

	local attackers --placeholder
	for i, target in ipairs(attackers) do
		local distance = Vector2.sub(towerUnit, target)
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

function Tower.attack(towerUnit, enemy) -- expects enemy death logic
	if enemy.health <= 0 then
		return
	end
	if towerUnit.stats.onHit then --no onhits yet but will be useful probably
		towerUnit.stats.onHit(enemy, towerUnit)
	else
		enemy.health = enemy.health - towerUnit.stats.attack
		if enemy.health <= 0 then
			--enemy death logic
		end
	end
end

function Tower.canPlace(name, position) --wip, dont know how to check map tiles
	local towerSize = TowerData[name].size
	if towerSize then
		--check if tiles are empty and valid for placement
	end
end

function Tower.spawn(name, position)
	if Tower.canPlace(name, position) then
		local stats = TowerData[name]
		if not stats then
			error("unable to find unknown tower: " .. tostring(name))
		end
		local newTower = {
			id = name,
			stats = stats,
			position = position,
			targetMode = "first",
			--maybe add upgrade level or other non-default attributes
		}
		table.insert(Tower, newTower)
	end
end

function Tower.remove(towerUnit)
	local removed = false
	for key, value in pairs(Tower) do
		if value == towerUnit then
			table.remove(Tower, towerUnit)
			removed = true
		end
	end
	if not removed then
		error("unable to remove tower: " .. tostring(towerUnit.id))
	end
end
