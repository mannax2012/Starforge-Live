tusken_king_guard = Creature:new {
	customName = "Tusken Kingsguard",
	socialGroup = "tusken_raider",
	faction = "tusken_raider",
	level = 300,
	chanceHit = 25.0,
	damageMin = 925,
	damageMax = 1325,
	baseXp = 25000,
	baseHAM = 95000,
	baseHAMmax = 105000,
	armor = 1,
	resists = {55,55,55,55,55,55,55,55,25},
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

	templates = {"object/mobile/tusken_raider.iff"},
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
	},

	primaryWeapon = "tusken_ranged",
	secondaryWeapon = "tusken_melee",
	conversationTemplate = "",

	primaryAttacks = merge(marksmanmaster,riflemanmaster),
	secondaryAttacks = merge(brawlermaster,fencermaster)
}

CreatureTemplates:addCreatureTemplate(tusken_king_guard, "tusken_king_guard")