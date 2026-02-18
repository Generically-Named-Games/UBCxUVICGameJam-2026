---@class Game
---@field ActiveTowers table
---@field ActiveEnemies table
---@field TimeSinceRoundStarted number
---@field RoundStatus "Paused" | "Ongoing" | "Dead"
---@field private _currency number
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
end

function Game:draw()
	for _, e in ipairs(self.ActiveEnemies) do
		e:draw()
	end
end

function Game:EndRound()
	self.RoundStatus = "Paused"
	self.TimeSinceRoundStarted = 0
end

function Game:StartRound()
	self.RoundStatus = "Ongoing"
end

return Game.new()
