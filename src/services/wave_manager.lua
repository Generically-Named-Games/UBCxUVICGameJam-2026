local WaveData = require("data/waves")
local Attacker = require("classes/attacker")
local Vector2 = require("classes/vector2")

local WaveManager = {}
WaveManager.__index = WaveManager

function WaveManager.new(path, activeEnemies)
	local instance = setmetatable({}, WaveManager)

	instance.Path = path
	instance.ActiveEnemies = activeEnemies

	instance.CurrentWave = 0
	instance.SpawnQueue = {} -- entries left to spawn this wave
	instance.WaveTimer = 0 -- time elapsed since wave started
	instance.WaveActive = false
	instance.WaveComplete = false

	return instance
end

function WaveManager:startWave()
	if self.WaveActive then
		return
	end

	local nextWave = self.CurrentWave + 1
	if nextWave > #WaveData then
		print("All waves complete!")
		return
	end

	self.CurrentWave = nextWave
	self.WaveTimer = 0
	self.WaveActive = true
	self.WaveComplete = false

	-- copy wave data into spawn queue
	self.SpawnQueue = {}
	for _, entry in ipairs(WaveData[self.CurrentWave]) do
		table.insert(self.SpawnQueue, { name = entry.name, delay = entry.delay, spawned = false })
	end

	print("Wave " .. self.CurrentWave .. " started!")
end

---Check if all enemies in the wave have been spawned and killed
function WaveManager:isWaveComplete()
	if not self.WaveActive then
		return false
	end

	-- check all entries have spawned
	for _, entry in ipairs(self.SpawnQueue) do
		if not entry.spawned then
			return false
		end
	end

	-- check no enemies are alive
	if #self.ActiveEnemies > 0 then
		return false
	end

	return true
end

function WaveManager:update(dt)
	if not self.WaveActive then
		if self.WaveComplete or self.CurrentWave == 0 then
			self.AutoTimer = (self.AutoTimer or 0) + dt
			if self.AutoTimer >= 5 then -- 5 second break between waves
				self.AutoTimer = 0
				self:startWave()
			end
		end
		return
	end

	self.WaveTimer = self.WaveTimer + dt

	-- spawn enemies whose delay has been reached
	for _, entry in ipairs(self.SpawnQueue) do
		if not entry.spawned and self.WaveTimer >= entry.delay then
			local spawnPos = Vector2.new(self.Path[1].x, self.Path[1].y)
			local enemy = Attacker.new(entry.name, spawnPos, self.Path)
			table.insert(self.ActiveEnemies, enemy)
			entry.spawned = true
			print("Spawned " .. entry.name .. " at t=" .. string.format("%.1f", self.WaveTimer))
		end
	end

	-- check if wave is done
	if self:isWaveComplete() then
		self.WaveActive = false
		self.WaveComplete = true
		print("Wave " .. self.CurrentWave .. " complete!")
	end
end

---Optional HUD showing wave number and status
function WaveManager:draw()
	local sw = love.graphics.getWidth()
	love.graphics.setColor(0.78, 0.85, 0.67)

	if self.WaveActive then
		love.graphics.print("Wave " .. self.CurrentWave .. " / " .. #WaveData, sw / 2 - 30, 10)
	elseif self.CurrentWave >= #WaveData then
		love.graphics.print("All waves complete! You win!", sw / 2 - 80, 10)
	else
		local countdown = math.ceil(5 - (self.AutoTimer or 0))
		love.graphics.print("Next wave in " .. countdown .. "...", sw / 2 - 50, 10)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

return WaveManager
