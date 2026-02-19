local Button = require("/ui/button")

---@class Game
---@field ActiveTowers table
---@field ActiveEnemies table
---@field TimeSinceRoundStarted number
---@field RoundStatus "Paused" | "Ongoing" | "Dead"
---@field private _currency number
---@field private _pause Button?
local Game = {}
Game.__index = Game

---Creates a new Game singleton object for tracking active entities and stats
function Game.new()
	local instance = setmetatable({}, Game)
	-- PUBLIC
	instance.ActiveTowers = {}
	instance.ActiveEnemies = {}
	instance.RoundStatus = "Paused"
	instance.TimeSinceRoundStarted = 0
	-- PRIVATE
	instance._currency = 0
	instance._pause = nil

	return instance
end

---Adds number `dc` to the game's current currency stat
---@param dc number
function Game:AddCurrency(dc)
	self._currency = self._currency + dc
end

---@param dt number
function Game:update(dt)
	if self.RoundStatus == "Ongoing" then
		self.TimeSinceRoundStarted = self.TimeSinceRoundStarted + dt

		for _, e in ipairs(self.ActiveEnemies) do
			e:update(dt)
		end
	end
	self._pause:update(dt)
end

function Game:drawInMap()
	for _, e in ipairs(self.ActiveEnemies) do
		e:draw()
	end
end

function Game:draw()
	self._pause:draw()

	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()
	love.graphics.print("Currency: " .. tostring(self._currency), screenWidth - 128 - 50, screenHeight - 128 - 100)
end

function Game:PauseRound()
	self.RoundStatus = "Paused"
end

function Game:EndRound()
	self.RoundStatus = "Paused"
	self.TimeSinceRoundStarted = 0
end

function Game:StartRound()
	self.RoundStatus = "Ongoing"
end

function Game:CreatePauseButton()
	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()
	self._pause = Button.new(screenWidth - 128, screenHeight - 128, 128, 128, "Pause")

	self._pause.Clicked:Connect(function()
		if self.RoundStatus == "Ongoing" then
			self:PauseRound()
		elseif self.RoundStatus == "Paused" then
			self:StartRound()
		end
	end)
end

return Game.new()
