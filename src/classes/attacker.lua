local enemyData = require("/data/attackers")
local mapFunctions = require("map_functions")

local Attacker = {}
Attacker.__index = Attacker

function Attacker.new(name, spawnPosition, pathData) -- pathdata from map_functions
	local instance = setmetatable({}, Attacker)

	--add sprite and dimensions once implemented

	instance.x = spawnPosition.x
	instance.y = spawnPosition.y
	instance.stats = enemyData[name]
	instance.path = pathData
	instance.endPoint = 1

	return instance
end

function Attacker:update(dt)
	local target = self.path[self.endPoint]
	local dx = target.x - self.x
	local dy = target.y - self.y
	local distance = math.sqrt(dx ^ 2 + dy ^ 2)

	if distance > 3 then
		self.x = self.x + (dx / distance) * self.stats.speed * dt
		self.y = self.y + (dy / distance) * self.stats.speed * dt
	else
		if self.endPoint < #self.path then
			-- once sprites are implemented will need to change sprite direction here
			self.endPoint = self.endPoint + 1
		else
			--base hit logic?
		end
	end
end

function Attacker:draw()
	love.graphics.setColor(1, 0, 0) -- Red enemy
	love.graphics.circle("fill", self.x, self.y, 10)
	love.graphics.setColor(1, 1, 1) -- Reset color
end

return Attacker
