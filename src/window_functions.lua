local window_functions = {}

--[[
FILE_NAME = "window_functions"
PURPOSE: FUNCTION TO MODIFY WINDOW BEHAVIOUR
FUNCTIONS: [window_functions.setFullscreen,
			window_functions.setTitle,
			window_functions.setIcon,
			window_functions.maximize,]
]]

--[[1. ## Sets window into fullscreen
## INPUT ftype fullscreenType: type of fullscreen you want (desktop.)
EXAMPLE: window_functions.setFullscreen("desktop" (reccomended))
]]
function window_functions.setFullscreen(fullscreenType)
	love.window.setFullscreen(true, fullscreenType)
end

--[[2. ## Sets title of window
## INPUT string: Sets title of the window 
EXAMPLE: window_functions.setTitle("GENERIC GAME NAME")
]]
function window_functions.setTitle(title)
	love.window.setTitle(title)
end

--[[3. ## Sets the icon of the window/program
## INPUT imageData: image data 
EXAMPLE: window_functions.setIcon(DATA HERE)
]]
function window_functions.setIcon(imageData)
	love.window.setIcon(imageData)
end

--[[4. ## Makes the window as large as possible
## NONE
Example:window_functions.maximize()
]]
function window_functions.maximize()
	love.window.maximize()
end

return window_functions
