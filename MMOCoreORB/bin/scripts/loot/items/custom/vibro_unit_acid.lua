vibro_unit_acid = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Acid-Coated Vibro Unit",
	directObjectTemplate = "object/tangible/component/weapon/vibro_unit_advanced.iff",
	craftingValues = {
		{"mindamage",34,75,0},
		{"maxdamage",43,125,0},
		{"attackspeed",1,0,1},
		{"woundchance",10,25,0},
		{"hitpoints",100,500,0},
		{"zerorangemod",0,20,0},
		{"maxrangemod",0,20,0},
		{"midrangemod",0,20,0},
		{"attackhealthcost",0,0,0},
		{"attackactioncost",50,70,0},
		{"attackmindcost",0,0,0},
		{"useCount",1,5,0},
	},
	customizationStringNames = {},
	customizationValues = {}
}


addLootItemTemplate("vibro_unit_acid", vibro_unit_acid)