---@class Vector2
---@field X number
---@field Y number
local Vector2 = {}
Vector2.__index = Vector2

---Creates a new Vector2 object with the given parameters for X, Y (in that order)
---@param x number?
---@param y number?
function Vector2.new(x, y)
	local instance = setmetatable({}, Vector2)

	instance.X = x or 0
	instance.Y = y or 0

	return instance
end

---Adds to Vector2 objects together by adding their corresponding components to each other
---@param other Vector2
function Vector2:add(other)
	return Vector2.new(self.X + other.X, self.Y + other.Y)
end
Vector2.__add = Vector2.add

---Subtracts to Vector2 objects from each other by minusing their corresponding components to each other
---@param other Vector2
function Vector2:sub(other)
	return Vector2.new(self.X - other.X, self.Y - other.Y)
end
Vector2.__sub = Vector2.sub

---Multiplies a Vector2 object by a scalar. Scalar is distributed to both X and Y components
---@param other number
function Vector2:mul(other)
	return Vector2.new(self.X * other, self.Y * other)
end
Vector2.__mul = Vector2.mul

---Stringifies a Vector2 object
function Vector2:__tostring()
	return "(" .. self.X .. ", " .. self.Y .. ")"
end

---Returns the length of the Vector2
function Vector2:len()
	return math.sqrt(self.X * self.X + self.Y * self.Y)
end

return Vector2
