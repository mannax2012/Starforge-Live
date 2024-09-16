/*
 * WearableObjectImplementation.cpp
 *
 *  Created on: 02/08/2009
 *      Author: victor
 */

#include "server/zone/objects/tangible/wearables/WearableObject.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/manufactureschematic/craftingvalues/CraftingValues.h"
#include "server/zone/objects/manufactureschematic/ManufactureSchematic.h"
#include "server/zone/objects/draftschematic/DraftSchematic.h"
#include "server/zone/objects/tangible/attachment/Attachment.h"
#include "server/zone/managers/skill/SkillModManager.h"
#include "server/zone/objects/tangible/wearables/ModSortingHelper.h"
#include "server/zone/objects/transaction/TransactionLog.h"
#include "server/zone/managers/skill/SkillManager.h"

void WearableObjectImplementation::initializeTransientMembers() {
	TangibleObjectImplementation::initializeTransientMembers();
	setLoggingName("WearableObject");
}

void WearableObjectImplementation::fillAttributeList(AttributeListMessage* alm, CreatureObject* object) {
	TangibleObjectImplementation::fillAttributeList(alm, object);

for(int i = 0; i < wearableSkillMods.size(); ++i) {
		String key = wearableSkillMods.elementAt(i).getKey();
		String statname = "cat_skill_mod_bonus.@stat_n:" + key;
		int value = wearableSkillMods.get(key);

		if (value > 0 && !key.beginsWith("itemset"))
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

	//Anti Decay Kit
	if (hasAntiDecayKit() && !isArmorObject()){
		alm->insertAttribute("@veteran_new:antidecay_examine_title", "@veteran_new:antidecay_examine_text");
	}

}

void WearableObjectImplementation::updateCraftingValues(CraftingValues* values, bool initialUpdate) {
	/*
	 * Values available:	Range:
	 * sockets				0-0(novice artisan) (Don't use)
	 * hitpoints			1000-1000 (Don't Use)
	 */
	if (initialUpdate) {
		if(values->hasExperimentalAttribute("sockets") && values->getCurrentValue("sockets") >= 0)
			generateSockets(values);
	}
}

void WearableObjectImplementation::generateSockets(CraftingValues* craftingValues) {
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

void WearableObjectImplementation::applyAttachment(CreatureObject* player, Attachment* attachment) {
	if (!isASubChildOf(player))
		return;

	if (getRemainingSockets() > 0 && wearableSkillMods.size() < 6) {
		Locker locker(player);

		if (isEquipped()) {
			removeSkillModsFrom(player);
		}

		HashTable<String, int>* mods = attachment->getSkillMods();
		HashTableIterator<String, int> iterator = mods->iterator();

		String statName;
		int newValue;

		SortedVector< ModSortingHelper > sortedMods;
		for( int i = 0; i < mods->size(); i++){
			iterator.getNextKeyAndValue(statName, newValue);
			sortedMods.put( ModSortingHelper( statName, newValue));
		}

		// Select the next mod in the SEA, sorted high-to-low. If that skill mod is already on the
		// wearable, with higher or equal value, don't apply and continue. Break once one mod
		// is applied.
		for (int i = 0; i < sortedMods.size(); i++ ) {
			String modName = sortedMods.elementAt(i).getKey();
			int modValue = sortedMods.elementAt(i).getValue();

			int existingValue = -26;
			if (wearableSkillMods.contains(modName))
				existingValue = wearableSkillMods.get(modName);

			if (modValue > existingValue) {
				wearableSkillMods.put( modName, modValue );
				break;
			}
		}

		usedSocketCount++;
		addMagicBit(true);
		Locker clocker(attachment, player);
		TransactionLog trx(player, asSceneObject(), attachment, TrxCode::APPLYATTACHMENT);

		if (trx.isVerbose()) {
			// Force a synchronous export because the object will be deleted before we can export it!
			trx.addRelatedObject(attachment, true);
			trx.setExportRelatedObjects(true);
			trx.exportRelated();
		}

		trx.addState("subjectSkillModMap", sortedMods);
		trx.addState("dstSkillModMap", wearableSkillMods);

		attachment->destroyObjectFromWorld(true);
		attachment->destroyObjectFromDatabase(true);

		if (isEquipped()) {
			applySkillModsTo(player);
		}
	}
}

void WearableObjectImplementation::applySkillModsTo(CreatureObject* creature) const {
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

void WearableObjectImplementation::removeSkillModsFrom(CreatureObject* creature) {
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

bool WearableObjectImplementation::isEquipped() {
	ManagedReference<SceneObject*> parent = getParent().get();
	if (parent != nullptr && parent->isPlayerCreature())
		return true;

	return false;
}

String WearableObjectImplementation::repairAttempt(int repairChance) {
	String message = "@error_message:";

	if(repairChance < 25) {
		message += "sys_repair_failed";
		setMaxCondition(1, true);
		setConditionDamage(0, true);
	} else if(repairChance < 50) {
		message += "sys_repair_imperfect";
		setMaxCondition(getMaxCondition() * .65f, true);
		setConditionDamage(0, true);
	} else if(repairChance < 75) {
		setMaxCondition(getMaxCondition() * .80f, true);
		setConditionDamage(0, true);
		message += "sys_repair_slight";
	} else {
		setMaxCondition(getMaxCondition() * .95f, true);
		setConditionDamage(0, true);
		message += "sys_repair_perfect";
	}

	return message;
}

