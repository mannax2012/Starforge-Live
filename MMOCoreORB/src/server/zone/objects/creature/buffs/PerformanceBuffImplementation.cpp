/*
 * PerformanceBuffImplementation.cpp
 *
 *  Created on: 04/03/2011
 *      Author: Itac
 */

#include "server/zone/objects/creature/buffs/PerformanceBuff.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "templates/params/creature/CreatureAttribute.h"
#include "server/zone/objects/creature/buffs/PerformanceBuffType.h"

void PerformanceBuffImplementation::activate(bool applyModifiers) {

	if(type == PerformanceBuffType::DANCE_MIND) {
		int mindStrength = round(strength * (float)creature.get()->getBaseHAM(CreatureAttribute::ACTION));
		setAttributeModifier(CreatureAttribute::ACTION, mindStrength);
		creature.get()->sendSystemMessage("@healing:performance_enhance_dance_mind_d");

	}
	else if(type == PerformanceBuffType::MUSIC_FOCUS) {
		//int amount = 0.5;
        //setSkillModifier("xp_increase", amount);
		int focusStrength = round(strength * (float)creature.get()->getBaseHAM(CreatureAttribute::ACTION));
		setAttributeModifier(CreatureAttribute::ACTION, focusStrength);
		creature.get()->sendSystemMessage("@healing:performance_enhance_music_focus_d");

	}
	else if(type == PerformanceBuffType::MUSIC_WILLPOWER) {
		int willStrength = round(strength * (float)creature.get()->getBaseHAM(CreatureAttribute::STAMINA));
		setAttributeModifier(CreatureAttribute::STAMINA, willStrength);
		creature.get()->sendSystemMessage("@healing:performance_enhance_music_willpower_d");
	}

	BuffImplementation::activate(true);

}

void PerformanceBuffImplementation::deactivate(bool removeModifiers) {
	BuffImplementation::deactivate(true);
}
