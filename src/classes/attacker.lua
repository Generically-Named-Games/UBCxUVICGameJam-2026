local enemyData = require("/data/attackers")
local mapFunctions = require("map_functions")

local Attacker = {}
Attacker.__index = Attacker

function Attacker.new(name, spawnPosition, pathData) -- pathdata from map_functions
	local instance = setmetatable({}, Attacker)

	instance.x = spawnPosition.x
	instance.y = spawnPosition.y
	instance.rotation = 0

	instance.stats = enemyData[name]
	instance.health = enemyData[name].health
	instance.maxHealth = enemyData[name].health

	instance.path = pathData
	instance.endPoint = 1

	--for sprite animation
	instance.animTimer = 0
	instance.animFrame = 1
	instance.sprites = {} --lick doesnt like it if i dont preload images
	for i, path in ipairs(enemyData[name].sprites) do
		if type(path) == "string" then
			instance.sprites[i] = love.graphics.newImage(path)
		else
			instance.sprites[i] = path
		end
	end

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

		self.animTimer = self.animTimer + dt
		local frameDuration = 1 / (self.stats.speed / 50) -- faster bug = faster animation

		if self.animTimer >= frameDuration then
			self.animTimer = 0
			if self.animFrame == 1 then
				self.animFrame = 2
			else
				self.animFrame = 1
			end
		end
	else
		if self.endPoint < #self.path then
			self.endPoint = self.endPoint + 1
			local next = self.path[self.endPoint]
			local dx = next.x - self.x
			local dy = next.y - self.y
			local angle = math.atan2(dy, dx)

			self.rotation = math.floor((angle / (math.pi / 2)) + 0.5) * (math.pi / 2) + math.pi / 2
		else
			--base hit logic?
		end
	end
end

function Attacker:draw()
	-- love.graphics.setColor(1, 0, 0) -- Red enemy
	-- love.graphics.circle("fill", self.x, self.y, 10)
	-- love.graphics.setColor(1, 1, 1) -- Reset color
	love.graphics.setColor(1, 1, 1, 1)
	local sprite = self.sprites[self.animFrame]
	if not sprite then
		return
	end
	local w, h = sprite:getDimensions()
	love.graphics.draw(
		sprite,
		self.x,
		self.y,
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

	local hpRatio = self.health / self.maxHealth
	if hpRatio < 0 then
		hpRatio = 0
	end

	love.graphics.setColor(1, 0, 0, 0.5)
	love.graphics.rectangle("fill", self.x - width / 2, self.y + padding, width, height)

	love.graphics.setColor(0, 1, 0)
	love.graphics.rectangle("fill", self.x - width / 2, self.y + padding, width * hpRatio, height)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", self.x - width / 2, self.y + padding, width, height)
end
return Attacker
