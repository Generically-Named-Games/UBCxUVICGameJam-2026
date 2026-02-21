local grafts = {
	["basic+basic"] = { result = "long_range" },
	["long_range+basic"] = { result = "long_range", bonus = { attack = 5 } },
	["long_range+long_range"] = { result = "purple" },
	["purple+purple"] = { result = "purple", bonus = { range = 30 } },
}

-- helper to look up a graft result regardless of argument order
local function getResult(typeA, typeB)
	local key1 = typeA .. "+" .. typeB
	local key2 = typeB .. "+" .. typeA
	return grafts[key1] or grafts[key2]
end

return {
	combinations = grafts,
	getResult = getResult,
}
