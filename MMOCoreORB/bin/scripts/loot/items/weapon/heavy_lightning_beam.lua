heavy_lightning_beam = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/weapon/ranged/heavy/heavy_lightning_beam.iff",
	craftingValues = {
		{"mindamage",936,1340,0},
		{"maxdamage",1550,3400,0},
		{"attackspeed",9.6,5.4,1},
		{"woundchance",13,23,1},
		{"roundsused",30,65,0},
		{"hitpoints",1000,1000,0},
		{"zerorange",0,0,0},
		{"zerorangemod",-45,-45,0},
		{"midrange",32,32,0},
		{"midrangemod",0,0,0},
		{"maxrange",64,64,0},
		{"maxrangemod",-125,-125,0},
		{"charges",25,50,0},
		{"attackhealthcost",0,0,0},
		{"attackactioncost",300,300,0},
		{"attackmindcost",0,0,0},
	},

	-- randomDotChance: The chance of this weapon object dropping with a random dot on it. Higher number means less chance. Set to 0 to always have a random dot.
	randomDotChance = 750,
	junkDealerTypeNeeded = JUNKARMS,
	junkMinValue = 30,
	junkMaxValue = 55
}

addLootItemTemplate("heavy_lightning_beam", heavy_lightning_beam)
