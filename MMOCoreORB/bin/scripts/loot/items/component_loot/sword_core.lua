--Automatically generated by SWGEmu Spawn Tool v0.12 loot editor.

sword_core = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/component/weapon/sword_core.iff",
	craftingValues = {
		{"mindamage",10,20,0},
		{"maxdamage",10,20,0},
		{"attackspeed",-0.2,-0.5,2},
		{"woundchance",5,10,0},
		{"hitpoints",50,100,0, true},
		{"midrangemod",5,10,0},
		{"attackhealthcost",0,0,0},
		{"attackactioncost",10,0,0},
		{"attackmindcost",0,0,0},
		{"useCount",1,11,0}
	},
	customizationStringName = {},
	customizationValues = {}
}


addLootItemTemplate("sword_core", sword_core)
