---@class Game
---@field ActiveTowers table
---@field ActiveEnemies table
---@field private _currency number
local Game = {}
Game.__index = Game

---Creates a new Game singleton object for tracking active entities and stats
function Game.new()
	local instance = setmetatable({}, Game)
	-- PUBLIC
	instance.ActiveTowers = {}
	instance.ActiveEnemies = {}
	-- PRIVATE
	instance._currency = 0

	return instance
end

---Adds number `dc` to the game's current currency stat
---@param dc number
function Game:AddCurrency(dc)
	self._currency = self._currency + dc
end

return Game.new()
