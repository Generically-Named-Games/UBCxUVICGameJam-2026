local enemyData = require("data/attackers")
local path_func = require("path_functions")
local Vector2 = require("classes/vector2")

---@class Attacker
---@field Position Vector2
---@field Stats table
---@field Health number
---@field MaxHealth number
---@field ReachedEnd boolean
---@field Path table
---@field EndPoint number
---@field AnimTimer number
---@field AnimFrame number
---@field Sprites table
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
	instance.ReachedEnd = false

	instance.Path = pathData
	instance.EndPoint = 1

	--for sprite animation
	instance.AnimTimer = 0
	instance.AnimFrame = 1
	instance.Sprites = {} --lick doesnt like it if i dont preload images
	for i, path in ipairs(enemyData[name].sprites) do
		if type(path) == "string" then
			instance.Sprites[i] = love.graphics.newImage(path)
		else
			instance.Sprites[i] = path
		end
	end

	return instance
end

function Attacker:update(dt)
	if self.EndPoint > #self.Path then
		self.ReachedEnd = true
		return
	end

	local target = Vector2.new(self.Path[self.EndPoint].x, self.Path[self.EndPoint].y)
	local difference = target - self.Position
	local distance = difference:len()

	if distance > 3 then
		self.Position = self.Position + difference * (1 / distance) * self.Stats.speed * dt

		self.AnimTimer = self.AnimTimer + dt
		local frameDuration = 1 / (self.Stats.speed / 50) -- faster bug = faster animation

		if self.AnimTimer >= frameDuration then
			self.AnimTimer = 0
			if self.AnimFrame == 1 then
				self.AnimFrame = 2
			else
				self.AnimFrame = 1
			end
		end
	else
		self.EndPoint = self.EndPoint + 1

		local next = self.Path[self.EndPoint]
		if next then
			local dx = next.x - self.Position.X
			local dy = next.y - self.Position.Y
			local angle = math.atan2(dy, dx)
			self.rotation = math.floor((angle / (math.pi / 2)) + 0.5) * (math.pi / 2) + math.pi / 2
		end
	end
end

function Attacker:draw()
	-- love.graphics.setColor(1, 0, 0) -- Red enemy
	-- love.graphics.circle("fill", self.x, self.y, 10)
	-- love.graphics.setColor(1, 1, 1) -- Reset color
	love.graphics.setColor(1, 1, 1, 1)
	local sprite = self.Sprites[self.AnimFrame]
	if not sprite then
		return
	end
	local w, h = sprite:getDimensions()
	love.graphics.draw(
		sprite,
		path_func.calculatePathPointX(self.Position.X),
		path_func.calculatePathPointY(self.Position.Y),
		self.rotation,
		32 / w,
		32 / h, --scaled to 32x32
		w / 2,
		h / 2 -- center origin
	)
	love.graphics.setColor(1, 1, 1, 1)
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
