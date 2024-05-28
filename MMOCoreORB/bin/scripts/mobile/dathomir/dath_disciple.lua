--Created By: Voxxy
dath_disciple = Creature:new {
	customName = "Mana Das (a Disciple of Rakata)",
	socialGroup = "mercenary",
	faction = "",
	mobType = MOB_NPC,
	level = 350,
	chanceHit = 4.75,
	damageMin = 1045,
	damageMax = 2500,
	baseXp = 25167,
	baseHAM = 961000,
	baseHAMmax = 1020000,
	armor = 2,
	resists = {65,70,55,70,60,55,70,55,75},
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
	scale = 1.4,	

	templates = {"object/mobile/wod_third_sister.iff"},
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
			{group = "tailor_components", chance = 500000}
		},
		lootChance = 10000000,
		},

		{
		groups = {
			{group = "unstable_crystal_pack", chance = 10000000}
		},
		lootChance = 1500000,
		},

		{
		groups = {
			{group = "experimental_spider", chance = 10000000}
		},
		lootChance = 1500000,
		},
	},

	primaryWeapon = "light_jedi_weapons",
	secondaryWeapon = "light_jedi_weapons",
	conversationTemplate = "",

	primaryAttacks = merge(lightsabermaster,forcepowermaster),
	secondaryAttacks = merge(lightsabermaster,forcepowermaster)
}

CreatureTemplates:addCreatureTemplate(dath_disciple, "dath_disciple")
