object_tangible_loot_loot_schematic_starforge_backpack_schematic = object_tangible_loot_loot_schematic_shared_starforge_backpack_schematic:new {
	templateType = LOOTSCHEMATIC,
	objectMenuComponent = "LootSchematicMenuComponent",
	attributeListComponent = "LootSchematicAttributeListComponent",
	requiredSkill = "crafting_tailor_master",
	targetDraftSchematic = "object/draft_schematic/clothing/custom/starforge_backpack_schematic.iff",
	targetUseCount = 1
}

ObjectTemplates:addTemplate(object_tangible_loot_loot_schematic_starforge_backpack_schematic, "object/tangible/loot/loot_schematic/starforge_backpack_schematic.iff")
