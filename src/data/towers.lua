local towers = { --holds all the tower templates and probably the upgrade stats as well
	vine = { --placeholder tower
		name = "vine",
		cost = 100,
		range = 100,
		attack = 10,
		cooldown = 0.5,
		sprites = {
			"assets/images/basic_plant1.png",
			"assets/images/basic_plant2.png",
		},
	},
	long_range = {
		name = "long_range",
		cost = 150,
		range = 200,
		attack = 8,
		cooldown = 0.8,
		sprites = {
			"assets/images/long_range_plant1.png",
			"assets/images/long_range_plant2.png",
		},
	},
	purple = { --maybe a graft
		name = "purple",
		cost = 175,
		range = 120,
		attack = 15, --maybe add a dot
		cooldown = 1.0,
		sprites = {
			"assets/images/purple_plant1.png",
			"assets/images/purple_plant2.png",
		},
	},
}
return towers
