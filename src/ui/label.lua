local RGBA = require("ui/rgba")

---@class Label
---@field Text string
---@field HorizontalAlignment "centre" | "left" | "right"
---@field VerticalAlignment "centre" | "top" | "bottom"
---@field Colour RGBA
local Label = {}
Label.__index = Label

---Creates a new label object
---@param text string
---@param horizontalAlignment string?
---@param verticalAlignment string?
function Label.new(text, horizontalAlignment, verticalAlignment)
	local instance = setmetatable({}, Label)

	instance.Text = text
	instance.HorizontalAlignment = horizontalAlignment or "centre"
	instance.VerticalAlignment = verticalAlignment or "centre"
	instance.Colour = RGBA.new(0, 0, 0)

	assert(
		instance.HorizontalAlignment == "centre"
			or instance.HorizontalAlignment == "left"
			or instance.HorizontalAlignment == "right",
		"invalid horizontal alignment for label! Must be centre, left or right"
	)
	assert(
		instance.VerticalAlignment == "centre"
			or instance.VerticalAlignment == "top"
			or instance.VerticalAlignment == "bottom",
		"invalid vertical alignment for label! Must be centre, top or bottom"
	)

	return instance
end

---Sets the label colour
---@param colour RGBA
function Label:SetColour(colour)
	self.Colour = colour
end

---Draws the content inside the label
function Label:DrawInside(container)
	local font = love.graphics.getFont()
	local fontWidth = font:getWidth(self.Text)
	local fontHeight = font:getHeight()
	local r, g, b, a = love.graphics.getColor()
	local LabelX, LabelY

	love.graphics.setColor(self.Colour:convert())

	if self.HorizontalAlignment == "centre" then
		LabelX = container.Position.X - fontWidth / 2
	end

	if self.VerticalAlignment == "centre" then
		LabelY = container.Position.Y - fontHeight / 2
	end

	love.graphics.print(self.Text, LabelX, LabelY)
	love.graphics.setColor(r, g, b, a)
end

return Label
