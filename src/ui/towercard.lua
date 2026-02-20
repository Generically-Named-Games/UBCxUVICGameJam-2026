local Button = require("/ui/button")

local TowerCard = {}
TowerCard.__index = TowerCard

local CARD_HEIGHT = 120
local MODES = { "first", "last", "closest", "strongest", "weakest" }

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local cardPositionY = screenHeight - CARD_HEIGHT

local STATS_X = 120
local MODES_X = 400
local SELL_X = 700

function TowerCard.new()
	local instance = setmetatable({}, TowerCard)

	instance.tower = nil --currently selected tower
	instance.visible = false

	instance.modeButtons = {}
	for i, mode in ipairs(MODES) do
		local column = (i - 1) % 2
		local row = math.floor((i - 1) / 2)
		local buttonX = MODES_X + column * 80 + 37
		local buttonY = cardPositionY + 20 + row * 30 + 12
		local newButton = Button.new(buttonX, buttonY, 74, 24, "")
		local capturedMode = mode
		newButton.Clicked:Connect(function()
			if instance.tower then
				instance.tower.targetMode = capturedMode
			end
		end)
		instance.modeButtons[i] = { button = newButton, mode = mode }
	end
	instance.sellButton = Button.new(SELL_X + 40, screenHeight - CARD_HEIGHT + 55, 80, 30, "")
	instance.sellButton.Clicked:Connect(function()
		if instance.tower then
			instance.tower:remove()
			instance.tower = nil
		end
	end)
	return instance
end

function TowerCard:update(dt, activeTowers)
	self.tower = nil
	for _, t in ipairs(activeTowers) do
		if t.selected then
			self.tower = t
			break
		end
	end

	if not self.tower then
		return
	end

	for _, mode in ipairs(self.modeButtons) do
		mode.button:update(dt)
	end
	self.sellButton:update(dt)
end

function TowerCard:draw()
	if not self.tower then
		return
	end
	local stats = self.tower.stats

	-- background and border
	love.graphics.setColor(0.1, 0.1, 0.06, 0.95)
	love.graphics.rectangle("fill", 0, cardPositionY, screenWidth, CARD_HEIGHT)
	love.graphics.setColor(0.35, 0.62, 0.22)
	love.graphics.rectangle("fill", 0, cardPositionY, screenWidth, 2)

	-- stats and name
	love.graphics.setColor(0.56, 0.83, 0.35)
	love.graphics.print(self.tower.id:upper(), STATS_X, cardPositionY + 14)
	love.graphics.setColor(0.78, 0.85, 0.67)
	love.graphics.print("DMG:    " .. (stats.attack or "?"), STATS_X, cardPositionY + 36)
	love.graphics.print("SPEED:  " .. string.format("%.1fs", stats.cooldown or 0), STATS_X, cardPositionY + 54)

	-- Mode buttons
	love.graphics.setColor(0.29, 0.42, 0.18)
	love.graphics.print("TARGET MODE", MODES_X, cardPositionY + 4)
	for _, entry in ipairs(self.modeButtons) do
		local btn = entry.button
		local active = self.tower.targetMode == entry.mode

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
	local sb = self.sellButton
	love.graphics.setColor(0.16, 0.06, 0.06)
	love.graphics.rectangle("fill", sb.Position.X - sb.Size.X / 2, sb.Position.Y - sb.Size.Y / 2, sb.Size.X, sb.Size.Y)
	love.graphics.setColor(0.47, 0.16, 0.1)
	love.graphics.rectangle("line", sb.Position.X - sb.Size.X / 2, sb.Position.Y - sb.Size.Y / 2, sb.Size.X, sb.Size.Y)
	love.graphics.setColor(0.75, 0.35, 0.22)
	love.graphics.print("SELL", sb.Position.X - 10, sb.Position.Y - 6)

	love.graphics.setColor(1, 1, 1, 1)
end
return TowerCard
