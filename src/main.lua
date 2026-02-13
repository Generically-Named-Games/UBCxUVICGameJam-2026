-- MODULES
local window_functions = require("window_functions")
local TM = require("/services/tween_manager").new()

local dimensions = {
	X = 0,
	Y = 400,
}

function love.draw()
	TM:update()
	love.graphics.print("Hello World", dimensions.X, dimensions.Y)
end

local function playMyTween()
	local myTween = TM:Create(dimensions, 500, "X", 500)

	myTween.Completed:Connect(function()
		dimensions.X = 0
		playMyTween()
	end)

	myTween:Play()
end

playMyTween()
