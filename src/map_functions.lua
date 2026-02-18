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

--[[3. ## GETS COORDINATES FROM A POLYLINE PATH
## INPUT: mapFile (The STI map), layerName (The Object Layer name), pathName (The name of the Polyline)
## RETURNS: A table of {x, y} points
]]
function map_functions.getPath(mapFile, layerName, pathName)
	local points = {}

	-- Ensure the layer exists and is an Object Layer
	if mapFile.layers[layerName] and mapFile.layers[layerName].objects then
		-- Loop through all objects in that layer
		for _, obj in pairs(mapFile.layers[layerName].objects) do
			-- Look for the specific name you typed in Tiled
			if obj.name == pathName and obj.polyline then
				-- Polyline points are relative to the object's X/Y position
				for _, p in ipairs(obj.polyline) do
					table.insert(points, {
						x = obj.x + p.x,
						y = obj.y + p.y,
					})
				end
			end
		end
	end

	return points
end

return map_functions
