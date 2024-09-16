--Created By: Voxxy
nightsister_ascendant = Creature:new {
	customName = "a Nightsister Ascendant",
	socialGroup = "mercenary",
	faction = "",
	mobType = MOB_NPC,
	level = 323,
	chanceHit = 25.0,
	damageMin = 1225,
	damageMax = 1925,
	baseXp = 25000,
	baseHAM = 134000,
	baseHAMmax = 170000,
	armor = 1,
	resists = {165,145,165,45,65,45,65,45,165},
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
	scale = 1.1,

	templates = {"object/mobile/dressed_dathomir_nightsister_protector.iff"},
	lootGroups = {
		{
			groups = {
				{group = "power_crystals", chance = 500000},
				{group = "color_crystals", chance = 500000},
				{group = "nightsister_common", chance = 2300000},
				{group = "armor_attachments", chance = 350000},
				{group = "clothing_attachments", chance = 350000},
				{group = "melee_weapons", chance = 2000000},
				{group = "rifles", chance = 1000000},
				{group = "pistols", chance = 1000000},
				{group = "carbines", chance = 1000000},
				{group = "wearables_common", chance = 500000},
				{group = "color_crystals_bw", chance = 500000}
			},
			lootChance = 10000000,
		},

		{
			groups = {
				{group = "rakata_skull_totem", chance = 10000000}
			},
			lootChance = 50000,
		},
	},

	primaryWeapon = "light_jedi_weapons",
	secondaryWeapon = "light_jedi_weapons",
	conversationTemplate = "",

	primaryAttacks = merge(lightsabermaster,forcepowermaster),
	secondaryAttacks = merge(lightsabermaster,forcepowermaster)
}

CreatureTemplates:addCreatureTemplate(nightsister_ascendant, "nightsister_ascendant")