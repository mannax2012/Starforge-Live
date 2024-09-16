tusken_king_boss = Creature:new {
	customName = "The Tusken King",
	socialGroup = "tusken_raider",
	faction = "tusken_raider",
	level = 300,
	chanceHit = 80.0,
	damageMin = 1645,
	damageMax = 3000,
	baseXp = 25167,
	baseHAM = 761000,
	baseHAMmax = 820000,
	armor = 1,
	resists = {80,45,70,45,80,70,45,70,45},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1.6,	

	templates = {"object/mobile/tusken_king_boss.iff"},
	lootGroups = {
		{
			groups = {
				{group = "power_crystals", chance = 1000000},
				{group = "pistols", chance = 1500000},
				{group = "rifles", chance = 1500000},
				{group = "carbines", chance = 1000000},
				{group = "melee_weapons", chance = 1000000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000}
			},
				lootChance = 10000000,
		},
		
		{
			groups = {
				{group = "power_crystals", chance = 1000000},
				{group = "pistols", chance = 1500000},
				{group = "rifles", chance = 1500000},
				{group = "carbines", chance = 1000000},
				{group = "melee_weapons", chance = 1000000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000}
			},
				lootChance = 8000000,
		},
		
		{
			groups = {
				{group = "power_crystals", chance = 1000000},
				{group = "pistols", chance = 1500000},
				{group = "rifles", chance = 1500000},
				{group = "carbines", chance = 1000000},
				{group = "melee_weapons", chance = 1000000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000}
			},
				lootChance = 6000000,
		},
		
		{
			groups = {
				{group = "power_crystals", chance = 1000000},
				{group = "pistols", chance = 1500000},
				{group = "rifles", chance = 1500000},
				{group = "carbines", chance = 1000000},
				{group = "melee_weapons", chance = 1000000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000}
			},
				lootChance = 6000000,
		},
		{
			groups = {
				{group = "tusken_king_rare", chance = 10000000}
			},
				lootChance = 1500000,
		},
	},
	primaryWeapon = "tusken_ranged",
	secondaryWeapon = "tusken_melee",
	conversationTemplate = "",
	
	primaryAttacks = merge(marksmanmaster,riflemanmaster),
	secondaryAttacks = merge(brawlermaster,fencermaster)
}

CreatureTemplates:addCreatureTemplate(tusken_king_boss, "tusken_king_boss")