local map_functions = {}

--[[
FILE_NAME = "map_functions"
PURPOSE: FUNCTIONS FOR TILE MAPS
FUNCTIONS: [map_functions.loadMap,
            map_functions.toggleLayer]
]]

--[[1. ## DRAWS THE MAP TO SCREEN
## INPUT: mapFile (The STI map object)
EXAMPLE: map_functions.loadMap(maps.map01)
]]
function map_functions.loadMap(mapFile)
	if mapFile then
		mapFile:draw()
	end
end

--[[2. ## SHOWS/HIDES SPECIFIC LAYER
## INPUT: mapFile (map object), layer (string name), bool (visibility)
EXAMPLE: map_functions.toggleLayer(maps.map01, "Bushes", false)
]]
function map_functions.toggleLayer(mapFile, layer, bool)
	if mapFile and mapFile.layers[layer] then
		mapFile.layers[layer].visible = bool
	else
		print("Error: Could not find layer '" .. tostring(layer) .. "'")
	end
end

return map_functions
