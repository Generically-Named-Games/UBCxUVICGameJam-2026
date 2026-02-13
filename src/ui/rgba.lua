local RGB = {}
RGB.__index = RGB

function RGB.new(r, g, b, a)
	local instance = setmetatable({}, RGB)

	instance.red = r or 255
	instance.green = g or 255
	instance.blue = b or 255
	instance.alpha = a or 1

	return instance
end

function RGB:convert()
	return { self.red / 255, self.green / 255, self.blue / 255, self.alpha }
end

return RGB
