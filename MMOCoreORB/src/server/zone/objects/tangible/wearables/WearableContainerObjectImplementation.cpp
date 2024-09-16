/*
 * WearableContainerObjectImplementation.cpp
 *
 *  Created on: Oct 27, 2012
 *      Author: loshult
 */

#include "server/zone/objects/tangible/wearables/WearableContainerObject.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/managers/skill/SkillModManager.h"
#include "server/zone/packets/scene/AttributeListMessage.h"
#include "server/zone/objects/manufactureschematic/craftingvalues/CraftingValues.h"
#include "server/zone/objects/manufactureschematic/ManufactureSchematic.h"
#include "server/zone/objects/draftschematic/DraftSchematic.h"
#include "server/zone/objects/tangible/attachment/Attachment.h"
#include "server/zone/objects/tangible/wearables/ModSortingHelper.h"
#include "server/zone/managers/skill/SkillManager.h"

void WearableContainerObjectImplementation::initializeTransientMembers() {
	ContainerImplementation::initializeTransientMembers();
	setLoggingName("WearableContainerObject");
}

void WearableContainerObjectImplementation::fillAttributeList(AttributeListMessage* alm, CreatureObject* object) {
	TangibleObjectImplementation::fillAttributeList(alm, object);

	for(int i = 0; i < wearableSkillMods.size(); ++i) {
		String key = wearableSkillMods.elementAt(i).getKey();
		String statname = "cat_skill_mod_bonus.@stat_n:" + key;
		int value = wearableSkillMods.get(key);

		if (value > 0)
			alm->insertAttribute(statname, value);
				//update attributelist for set items
		if (key.beginsWith("itemset")) {
			if (object != nullptr) {
				//add set name to attributelist
				alm->insertAttribute("item_set_name", "stat_n:" + key);
				//add stats and abilities from set bonuses
				int maxSetItems = 8;
				SkillManager* skillManager = SkillManager::instance();
				String boxName;
				String setBonusMods;
				String setBonusAbilities;
				if (skillManager != nullptr) {
					for (int i = 0; i <= maxSetItems; i++) {
						boxName = key + i;
						Reference<Skill*> skill = skillManager->getSkill(boxName);
						if (skill != nullptr) {
							setBonusMods = "set_bonus_skill_mods_" + String::valueOf(i) + ".@stat_n:";
							auto skillMods = skill->getSkillModifiers();
							for (int j = 0; j < skillMods->size(); j++) {
								alm->insertAttribute(setBonusMods + skillMods->elementAt(j).getKey(), skillMods->elementAt(j).getValue());
							}
							setBonusAbilities = "set_bonus_abilities_" + String::valueOf(i) + ".@cmd_n:";
							auto skillAbilities = skill->getAbilities();
							if (skillAbilities->size() > 0) {
								for (int k = 0; k < skillAbilities->size(); k++) { 
									alm->insertAttribute(setBonusAbilities + skillAbilities->elementAt(k), "!");
								}
							}
						}
					}
				}
			}
		}
	}

	//update attributelist for set items: template skill mods
	SharedTangibleObjectTemplate* tano = dynamic_cast<SharedTangibleObjectTemplate*>(templateObject.get());
	if (tano != nullptr) {
		auto mods = tano->getSkillMods();
		for(int i = 0; i < mods->size(); ++i) {
			String key = mods->elementAt(i).getKey();
			if (key.beginsWith("itemset")) {
				if (object != nullptr) {
					//add set name to attributelist
					alm->insertAttribute("item_set_name", "stat_n:" + key);
					//add stats and abilities from set bonuses
					int maxSetItems = 8;
					SkillManager* skillManager = SkillManager::instance();
					String boxName;
					String setBonusMods;
					String setBonusAbilities;
					if (skillManager != nullptr) {
						for (int i = 0; i <= maxSetItems; i++) {
							boxName = key + i;
							Reference<Skill*> skill = skillManager->getSkill(boxName);
							if (skill != nullptr) {
								setBonusMods = "set_bonus_skill_mods_" + String::valueOf(i) + ".@stat_n:";
								auto skillMods = skill->getSkillModifiers();
								for (int j = 0; j < skillMods->size(); j++) {
									alm->insertAttribute(setBonusMods + skillMods->elementAt(j).getKey(), skillMods->elementAt(j).getValue());
								}
								setBonusAbilities = "set_bonus_abilities_" + String::valueOf(i) + ".@cmd_n:";
								auto skillAbilities = skill->getAbilities();
								if (skillAbilities->size() > 0) {
									for (int k = 0; k < skillAbilities->size(); k++) { 
										alm->insertAttribute(setBonusAbilities + skillAbilities->elementAt(k), "!");
									}
								}
							}
						}
					}
				}
			}
		}	
	}
}


void WearableContainerObjectImplementation::updateCraftingValues(CraftingValues* values, bool initialUpdate) {
	if (initialUpdate) {
		if(values->hasExperimentalAttribute("sockets") && values->getCurrentValue("sockets") >= 0)
			generateSockets(values);
	}
}

void WearableContainerObjectImplementation::generateSockets(CraftingValues* craftingValues) {
	if (socketsGenerated) {
		return;
	}

	int skill = 0;
	int luck = 0;

	if (craftingValues != nullptr) {
		ManagedReference<ManufactureSchematic*> manuSchematic = craftingValues->getManufactureSchematic();

		if (manuSchematic != nullptr) {
			ManagedReference<DraftSchematic*> draftSchematic = manuSchematic->getDraftSchematic();
			ManagedReference<CreatureObject*> player = manuSchematic->getCrafter().get();

			if (player != nullptr && draftSchematic != nullptr) {
				String assemblySkill = draftSchematic->getAssemblySkill();

				skill = player->getSkillMod(assemblySkill);

				if (MIN_SOCKET_MOD > skill)
					return;

				luck = System::random(player->getSkillMod("luck") + player->getSkillMod("force_luck"));
			}
		}
	}

	skill -= MIN_SOCKET_MOD;
	int bonusMod = 65 - skill;

	if (bonusMod <= 0) {
		bonusMod = 0;
	} else {
		bonusMod = System::random(bonusMod);
	}

	int skillAdjust = skill + System::random(luck) + bonusMod;
	int maxMod = 65 + System::random(skill);

	float randomSkill = System::random(skillAdjust) * 10;
	float roll = randomSkill / (400.f + maxMod);

	float generatedCount = roll * MAXSOCKETS;

	if (generatedCount > MAXSOCKETS)
		generatedCount = MAXSOCKETS;
	else if (generatedCount > 3 && generatedCount <= 3.75f)
		generatedCount = floor(generatedCount);

	usedSocketCount = 0;
	socketCount = (int)generatedCount;

	socketsGenerated = true;

	return;
}

void WearableContainerObjectImplementation::applySkillModsTo(CreatureObject* creature) const {
	if (creature == nullptr) {
		return;
	}

	for (int i = 0; i < wearableSkillMods.size(); ++i) {
		String name = wearableSkillMods.elementAt(i).getKey();
		int value = wearableSkillMods.get(name);

		if (!SkillModManager::instance()->isWearableModDisabled(name))
		{
			creature->addSkillMod(SkillModManager::WEARABLE, name, value, true);
			creature->updateSpeedAndAccelerationMods();
		}
	}

	SkillModManager::instance()->verifyWearableSkillMods(creature);
}

void WearableContainerObjectImplementation::removeSkillModsFrom(CreatureObject* creature) {
	if (creature == nullptr) {
		return;
	}

	for (int i = 0; i < wearableSkillMods.size(); ++i) {
		String name = wearableSkillMods.elementAt(i).getKey();
		int value = wearableSkillMods.get(name);

		if (!SkillModManager::instance()->isWearableModDisabled(name))
		{
			creature->removeSkillMod(SkillModManager::WEARABLE, name, value, true);
			creature->updateSpeedAndAccelerationMods();
		}
	}

	SkillModManager::instance()->verifyWearableSkillMods(creature);
}

bool WearableContainerObjectImplementation::isEquipped() {
	ManagedReference<SceneObject*> parent = getParent().get();
	if (parent != nullptr && parent->isPlayerCreature())
		return true;

	return false;
}
