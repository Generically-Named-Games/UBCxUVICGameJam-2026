local Button = require("ui/button")
local TowerData = require("data/towers")

local Shop = {}
Shop.__index = Shop

local PANEL_WIDTH = 80
local BUTTON_SIZE = 80
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

function Shop.new(onSelect)
	local instance = setmetatable({}, Shop)

	local centerY = screenHeight / 2
	instance.OnSelect = onSelect
	instance.SelectedType = nil

	instance.button = Button.new(PANEL_WIDTH / 2 + 30, centerY, BUTTON_SIZE, BUTTON_SIZE, "")
	instance.sprite = love.graphics.newImage("assets/images/basic_plant1.png")

	instance.button.Clicked:Connect(function()
		instance.SelectedType = "basic"
		if instance.OnSelect then
			instance.OnSelect("basic")
		end
	end)
	return instance
end

function Shop:update(dt)
	self.button:update(dt)
end

function Shop:containsPoint(x, y)
	return x >= screenWidth - PANEL_WIDTH and x <= screenWidth and y >= 0 and y <= screenHeight
end

function Shop:deselect()
	self.SelectedType = nil
end

function Shop:draw()
	local btn = self.button

	local active = self.SelectedType == "basic"
	local r = 8

	love.graphics.setColor(active and 0.12 or 0.06, active and 0.23 or 0.1, 0.03)
	love.graphics.rectangle(
		"fill",
		btn.Position.X - btn.Size.X / 2,
		btn.Position.Y - btn.Size.Y / 2,
		btn.Size.X,
		btn.Size.Y,
		r,
		r
	)
	love.graphics.setColor(active and 0.56 or 0.23, active and 0.83 or 0.35, 0.22)
	love.graphics.rectangle(
		"line",
		btn.Position.X - btn.Size.X / 2,
		btn.Position.Y - btn.Size.Y / 2,
		btn.Size.X,
		btn.Size.Y,
		r,
		r
	)

	if self.sprite then
		love.graphics.setColor(1, 1, 1, 1)
		local w, h = self.sprite:getDimensions()
		love.graphics.draw(self.sprite, btn.Position.X, btn.Position.Y, 0, 50 / w, 50 / h, w / 2, h / 2)
	end

	love.graphics.setColor(0.78, 0.85, 0.67)
	love.graphics.print("$" .. TowerData["basic"].cost, btn.Position.X - 12, btn.Position.Y + btn.Size.Y / 2 + 4)

	love.graphics.setColor(1, 1, 1, 1)
end

return Shop
