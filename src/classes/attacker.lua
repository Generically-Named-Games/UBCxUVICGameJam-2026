local enemyData = require("/data/attackers")
local path_func = require("path_functions")
local Vector2 = require("/classes/vector2")

---@class Attacker
---@field Position Vector2
---@field Stats table
---@field Health number
---@field MaxHealth number
---@field Path table
---@field EndPoint number
local Attacker = {}
Attacker.__index = Attacker

---Constructor for Attacker object
---@param name string
---@param spawnPosition Vector2
---@param pathData table
function Attacker.new(name, spawnPosition, pathData) -- pathdata from map_functions
	local instance = setmetatable({}, Attacker)

	--add sprite and dimensions once implemented

	instance.Position = spawnPosition

	instance.Stats = enemyData[name]
	instance.Health = enemyData[name].health
	instance.MaxHealth = enemyData[name].health

	instance.Path = pathData
	instance.EndPoint = 1

	return instance
end

function Attacker:update(dt)
	local target = Vector2.new(self.Path[self.EndPoint].x, self.Path[self.EndPoint].y)
	local difference = target - self.Position
	local distance = difference:len()

	if distance > 3 then
		self.Position = self.Position + difference * (1 / distance) * self.Stats.speed * dt
	else
		if self.EndPoint < #self.Path then
			-- once sprites are implemented will need to change sprite direction here
			self.EndPoint = self.EndPoint + 1
		else
			--base hit logic?
		end
	end
end

function Attacker:draw()
	love.graphics.setColor(1, 0, 0) -- Red enemy
	love.graphics.circle(
		"fill",
		path_func.calculatePathPointX(self.Position.X),
		path_func.calculatePathPointY(self.Position.Y),
		10
	)
	love.graphics.setColor(1, 1, 1) -- Reset color

	self:drawHealthBar()
end

function Attacker:drawHealthBar()
	local width = 35
	local height = 5
	local padding = 35

	local hpRatio = self.Health / self.MaxHealth
	if hpRatio < 0 then
		hpRatio = 0
	end

	local screenX = path_func.calculatePathPointX(self.Position.X)
	local screenY = path_func.calculatePathPointY(self.Position.Y)

	local x = screenX - (width / 2)
	local y = screenY + padding

	love.graphics.setColor(1, 0, 0, 0.5)
	love.graphics.rectangle("fill", x, y, width, height)

	love.graphics.setColor(0, 1, 0)
	love.graphics.rectangle("fill", x, y, width * hpRatio, height)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", x, y, width, height)
end
return Attacker
