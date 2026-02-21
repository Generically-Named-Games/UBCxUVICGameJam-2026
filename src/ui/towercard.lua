local Button = require("/ui/button")

---@class TowerCard
---@field Tower Tower?
---@field Visible boolean
---@field ModeButtons table
---@field SellButton Button
---@field GraftButton Button
---@field IsGrafting boolean
local TowerCard = {}
TowerCard.__index = TowerCard

local CARD_HEIGHT = 120
local CARD_WIDTH = 400
local MODES = { "first", "last", "close", "strong", "weak" }

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local cardPositionY = screenHeight - CARD_HEIGHT

local STATS_X = 10
local MODES_X = 130
local SELL_X = 310

function TowerCard.new()
	local instance = setmetatable({}, TowerCard)

	instance.Tower = nil --currently selected tower
	instance.Visible = false

	instance.ModeButtons = {}
	for i, mode in ipairs(MODES) do
		local column = (i - 1) % 2
		local row = math.floor((i - 1) / 2)
		local buttonX = MODES_X + column * 80 + 37
		local buttonY = cardPositionY + 20 + row * 30 + 12
		local newButton = Button.new(buttonX, buttonY, 74, 24, "")
		local capturedMode = mode
		newButton.Clicked:Connect(function()
			if instance.Tower then
				instance.Tower.TargetMode = capturedMode
			end
		end)
		instance.ModeButtons[i] = { button = newButton, mode = mode }
	end
	instance.SellButton = Button.new(SELL_X + 40, screenHeight - CARD_HEIGHT + 55, 80, 30, "")
	instance.SellButton.Clicked:Connect(function()
		if instance.Tower then
			instance.Tower:remove()
			instance.Tower = nil
		end
	end)

	instance.IsGrafting = false
	instance.GraftButton = Button.new(SELL_X + 40, screenHeight - CARD_HEIGHT + 25, 80, 24, "")
	instance.GraftButton.Clicked:Connect(function()
		if instance.Tower then
			instance.IsGrafting = not instance.IsGrafting -- toggle graft mode
			print("Graft mode:", instance.IsGrafting)
		end
	end)

	return instance
end

---Update loop for Tower Card
---@param dt number
---@param activeTowers Tower[]
function TowerCard:update(dt, activeTowers)
	self.Tower = nil
	for _, t in ipairs(activeTowers) do
		if t.Selected then
			self.Tower = t
			break
		end
	end

	if not self.Tower then
		return
	end

	for _, mode in ipairs(self.ModeButtons) do
		mode.button:update(dt)
	end
	self.SellButton:update(dt)
	self.GraftButton:update(dt)
end

function TowerCard:containsPoint(x, y)
	if not self.Tower then
		return false
	end

	return x >= 0 and x <= CARD_WIDTH and y >= screenHeight - CARD_HEIGHT and y <= screenHeight
end
function TowerCard:draw()
	if not self.Tower then
		return
	end
	local stats = self.Tower.Stats

	-- background and border
	love.graphics.setColor(0.1, 0.1, 0.06, 0.95)
	love.graphics.rectangle("fill", 0, cardPositionY, CARD_WIDTH, CARD_HEIGHT)
	love.graphics.setColor(0.35, 0.62, 0.22)
	love.graphics.rectangle("fill", 0, cardPositionY, CARD_WIDTH, 2)

	-- stats and name
	love.graphics.setColor(0.56, 0.83, 0.35)
	love.graphics.print(self.Tower.ID:upper(), STATS_X, cardPositionY + 14)
	love.graphics.setColor(0.78, 0.85, 0.67)
	love.graphics.print("DMG:    " .. (stats.attack or "?"), STATS_X, cardPositionY + 36)
	love.graphics.print("SPEED:  " .. string.format("%.1fs", stats.cooldown or 0), STATS_X, cardPositionY + 54)

	-- Mode buttons
	love.graphics.setColor(0.29, 0.42, 0.18)
	love.graphics.print("TARGET MODE", MODES_X, cardPositionY + 4)
	for _, entry in ipairs(self.ModeButtons) do
		local btn = entry.button
		local active = self.Tower.TargetMode == entry.mode

		love.graphics.setColor(active and 0.12 or 0.06, active and 0.23 or 0.1, 0.03)
		love.graphics.rectangle(
			"fill",
			btn.Position.X - btn.Size.X / 2,
			btn.Position.Y - btn.Size.Y / 2,
			btn.Size.X,
			btn.Size.Y
		)
		love.graphics.setColor(active and 0.56 or 0.23, active and 0.83 or 0.35, 0.22)
		love.graphics.rectangle(
			"line",
			btn.Position.X - btn.Size.X / 2,
			btn.Position.Y - btn.Size.Y / 2,
			btn.Size.X,
			btn.Size.Y
		)
		love.graphics.setColor(active and 0.56 or 0.35, active and 0.83 or 0.47, 0.22)
		love.graphics.print(entry.mode:upper(), btn.Position.X - btn.Size.X / 2 + 6, btn.Position.Y - 6)
	end

	--sell button
	local sb = self.SellButton
	love.graphics.setColor(0.16, 0.06, 0.06)
	love.graphics.rectangle("fill", sb.Position.X - sb.Size.X / 2, sb.Position.Y - sb.Size.Y / 2, sb.Size.X, sb.Size.Y)
	love.graphics.setColor(0.47, 0.16, 0.1)
	love.graphics.rectangle("line", sb.Position.X - sb.Size.X / 2, sb.Position.Y - sb.Size.Y / 2, sb.Size.X, sb.Size.Y)
	love.graphics.setColor(0.75, 0.35, 0.22)
	love.graphics.print("SELL", sb.Position.X - 10, sb.Position.Y - 6)

	local gb = self.GraftButton
	local graftActive = self.IsGrafting
	love.graphics.setColor(graftActive and 0.06 or 0.04, graftActive and 0.18 or 0.08, graftActive and 0.06 or 0.04)
	love.graphics.rectangle(
		"fill",
		gb.Position.X - gb.Size.X / 2,
		gb.Position.Y - gb.Size.Y / 2,
		gb.Size.X,
		gb.Size.Y,
		4,
		4
	)
	love.graphics.setColor(graftActive and 0.56 or 0.23, graftActive and 0.83 or 0.45, 0.22)
	love.graphics.rectangle(
		"line",
		gb.Position.X - gb.Size.X / 2,
		gb.Position.Y - gb.Size.Y / 2,
		gb.Size.X,
		gb.Size.Y,
		4,
		4
	)
	love.graphics.setColor(graftActive and 0.56 or 0.45, graftActive and 0.83 or 0.65, 0.22)
	love.graphics.print("GRAFT", gb.Position.X - 12, gb.Position.Y - 6)

	love.graphics.setColor(1, 1, 1, 1)
end
return TowerCard
