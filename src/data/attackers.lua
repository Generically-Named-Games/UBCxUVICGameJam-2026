local attackers = { --holds all the attacker templates
	bug = { --placeholder enemy
		name = "bug",
		health = 100,
		speed = 80,
		sprites = {
			"assets/images/big_bug1.png",
			"assets/images/big_bug2.png",
		},
	},
	small_bug = {
		name = "small_bug",
		health = 50,
		speed = 130,
		sprites = {
			"assets/images/small_bug1.png",
			"assets/images/small_bug2.png",
		},
	},
	flying_bug = {
		name = "flying_bug",
		health = 75,
		speed = 100,
		sprites = {
			"assets/images/flying_bug1.png",
			"assets/images/flying_bug2.png",
		},
	},
}
return attackers
