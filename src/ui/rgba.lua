---@class RGBA
---@field red number
---@field green number
---@field blue number
---@field alpha number
local RGB = {}
RGB.__index = RGB

---Creates a new RGBA object
---@param r number?
---@param g number?
---@param b number?
---@param a number?
function RGB.new(r, g, b, a)
	local instance = setmetatable({}, RGB)

	instance.red = r or 255
	instance.green = g or 255
	instance.blue = b or 255
	instance.alpha = a or 1

	return instance
end

---Converts the RGBA to a table to be in format (1.0, 1.0, 1.0, 0.0)
---@return table
function RGB:convert()
	return { self.red / 255, self.green / 255, self.blue / 255, self.alpha }
end

return RGB
