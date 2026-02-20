local Path = {}

function Path.calculatePathPointX(x)
	return x * SCALE_X - love.graphics.getWidth() / SCALE_X
end

function Path.calculatePathPointY(y)
	return y * SCALE_Y - love.graphics.getHeight()
end

return Path
