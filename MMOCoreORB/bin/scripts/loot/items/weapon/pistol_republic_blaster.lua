--Automatically generated by SWGEmu Spawn Tool v0.12 loot editor.

pistol_republic_blaster = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/weapon/ranged/pistol/pistol_republic_blaster.iff",
	craftingValues = {
		{"mindamage",17,37,0},
		{"maxdamage",79,170,0},
		{"attackspeed",5.1,3.7,1},
		{"woundchance",8,18,1},
		{"hitpoints",750,750,0},
		{"zerorange",0,0,0},
		{"zerorangemod",0,0,0},
		{"midrange",10,10,0},
		{"midrangemod",-40,-40,0},
		{"maxrange",64,64,0},
		{"maxrangemod",-70,-70,0},
		{"attackhealthcost",0,0,0},
		{"attackactioncost",300,300,0},
		{"attackmindcost",0,0,0},
	},
	customizationStringNames = {},
	customizationValues = {},

	-- randomDotChance: The chance of this weapon object dropping with a random dot on it. Higher number means less chance. Set to 0 to always have a random dot.
	randomDotChance = 625,
	junkDealerTypeNeeded = JUNKARMS,
	junkMinValue = 30,
	junkMaxValue = 55

}

addLootItemTemplate("pistol_republic_blaster", pistol_republic_blaster)
