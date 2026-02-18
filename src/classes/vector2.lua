local Vector2 = {}
Vector2.__index = Vector2

function Vector2.new(x, y)
	local instance = setmetatable({}, Vector2)

	instance.X = x or 0
	instance.Y = y or 0

	return instance
end

function Vector2:add(other)
	return Vector2.new(self.X + other.X, self.Y + other.Y)
end
Vector2.__add = Vector2.add

function Vector2:sub(other)
	return Vector2.new(self.X - other.X, self.Y - other.Y)
end
Vector2.__sub = Vector2.sub

function Vector2:mul(other)
	return Vector2.new(self.X * other, self.Y * other)
end
Vector2.__mul = Vector2.mul

function Vector2:__tostring()
	return "(" .. self.X .. ", " .. self.Y .. ")"
end

-- The length of the Vector2
function Vector2:len()
	return math.sqrt(self.X * self.X + self.Y * self.Y)
end

return Vector2
