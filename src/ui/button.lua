local RGBA = require("/ui/rgba")
local Event = require("/classes/event")
local Label = require("/ui/label")
local Vector2 = require("/classes/vector2")

---@class Button
---@field Position Vector2
---@field Size Vector2
---@field Label Label
---@field Colour RGBA
---@field HighlightColour RGBA?
---@field ClickedColour RGBA?
---@field private _enabled boolean
---@field private _hovered boolean
---@field private _clicked boolean
---@field Clicked Event
local Button = {}
Button.__index = Button
--most of this module was taken from here: https://github.com/bncastle/love2d-tutorial/blob/Episode15/lib/ui/Button.lua
function Button.new(x, y, w, h, text)
	local instance = setmetatable({}, Button)
	--public field
	instance.Position = Vector2.new(x or 0, y or 0)
	instance.Size = Vector2.new(w or 0, h or 0)
	instance.Label = Label.new(text)
	instance.Colour = RGBA.new()
	instance.HighlightColour = nil
	instance.ClickedColour = nil
	--private field
	instance._enabled = true
	instance._hovered = false
	instance._clicked = false
	--events
	instance.Clicked = Event.new()
	instance.Unclicked = Event.new()
	--instance.Hovered = Event.new()

	return instance
end

---Sets the button's regular, highlight, and pressed colours
---@param regular RGBA
---@param highlighted RGBA?
---@param pressed RGBA?
function Button:SetColours(regular, highlighted, pressed)
	self.Colour = regular
	if highlighted then
		self.HighlightColour = highlighted
	end
	if pressed then
		self.ClickedColour = pressed
	end
end

-- function Button:enable(enabled)
--     self._enabled = enabled
-- end

---updates the button
---@param dt number
function Button:update(dt)
	if not self._enabled then
		return
	end

	local mX, mY = love.mouse.getPosition()
	local clicking = love.mouse.isDown(1)
	local in_bounds = (
		mX >= self.Position.X - self.Size.X / 2
		and mX <= self.Position.X + self.Size.X / 2
		and mY >= self.Position.Y - self.Size.Y / 2
		and mY <= self.Position.Y + self.Size.Y / 2
	)

	if in_bounds then
		if clicking and not self._clicked then
			self._clicked = true
			self.Clicked:Invoke()
		elseif not clicking and self._clicked then
			self._clicked = false
			self.Unclicked:Invoke()
		else
			print("in bounds! doing nothing! woah!")
			--self.Hovered:Invoke()
		end
	else
		if not clicking and self._clicked then
			self._clicked = false
			self.Unclicked:Invoke()
		end
	end
end

---draws the button
function Button:draw()
	--print(self.Position.X - self.Size.X/2, self.Position.Y - self.Size.Y/2, self.Size.X, self.Size.Y)
	love.graphics.push()

	if self._clicked and self.ClickedColour then
		--apply clicked colour by finishing and using RGB:convert()
		love.graphics.setColor(self.ClickedColour:convert())
	elseif self._hovered and self.HighlightColour then
		love.graphics.setColor(self.HighlightColour:convert())
	else
		love.graphics.setColor(self.Colour:convert())
	end

	love.graphics.rectangle(
		"fill",
		self.Position.X - self.Size.X / 2,
		self.Position.Y - self.Size.Y / 2,
		self.Size.X,
		self.Size.Y
	)
	love.graphics.pop()

	self.Label:DrawInside(self)
end

return Button
