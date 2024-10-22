
knife_vibroblade = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/weapon/melee/knife/knife_vibroblade.iff",
	craftingValues = {
		{"mindamage",11,20,0},
		{"maxdamage",60,111,0},
		{"attackspeed",4.2,2.9,1},
		{"woundchance",6,12,1},
		{"hitpoints",750,1500,0},
		{"zerorange",0,0,0},
		{"zerorangemod",3,3,0},
		{"midrange",3,3,0},
		{"midrangemod",3,3,0},
		{"maxrange",4,4,0},
		{"maxrangemod",3,3,0},
		{"attackhealthcost",0,0,0},
		{"attackactioncost",300,300,0},
		{"attackmindcost",0,0,0},
	},
	customizationStringNames = {},
	customizationValues = {},

	-- randomDotChance: The chance of this weapon object dropping with a random dot on it. Higher number means less chance. Set to 0 to always have a random dot.
	randomDotChance = 625,
	junkDealerTypeNeeded = JUNKARMS,
	junkMinValue = 25,
	junkMaxValue = 45

}

addLootItemTemplate("knife_vibroblade", knife_vibroblade)
