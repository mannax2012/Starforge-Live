--Copyright (C) 2010 <SWGEmu>


--This File is part of Core3.

--This program is free software; you can redistribute 
--it and/or modify it under the terms of the GNU Lesser 
--General Public License as published by the Free Software
--Foundation; either version 2 of the License, 
--or (at your option) any later version.

--This program is distributed in the hope that it will be useful, 
--but WITHOUT ANY WARRANTY; without even the implied warranty of 
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Lesser General Public License for
--more details.

--You should have received a copy of the GNU Lesser General 
--Public License along with this program; if not, write to
--the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

--Linking Engine3 statically or dynamically with other modules 
--is making a combined work based on Engine3. 
--Thus, the terms and conditions of the GNU Lesser General Public License 
--cover the whole combination.

--In addition, as a special exception, the copyright holders of Engine3 
--give you permission to combine Engine3 program with free software 
--programs or libraries that are released under the GNU LGPL and with 
--code included in the standard release of Core3 under the GNU LGPL 
--license (or modified versions of such code, with unchanged license). 
--You may copy and distribute such a system following the terms of the 
--GNU LGPL for Engine3 and the licenses of the other code concerned, 
--provided that you include the source code of that other code when 
--and as the GNU LGPL requires distribution of source code.

--Note that people who make modified versions of Engine3 are not obligated 
--to grant this special exception for their modified versions; 
--it is their choice whether to do so. The GNU Lesser General Public License 
--gives permission to release a modified version without this exception; 
--this exception also makes it possible to release a modified version 


object_ship_player_player_blacksun_medium_s01 = object_ship_player_shared_player_blacksun_medium_s01:new {

	name = "player_blacksun_medium_s01",
	slideFactor = 1.81,
	chassisHitpoints = 519,
	chassisMass = 95000,

	containerComponent = "ShipContainerComponent",

	-- FIGHTERSHIP
	gameObjectType = 536870913,
	category = "mediumfighter",
	level = 3,

	attributes = {
		{"speedRotationFactorMin", 0.2},
		{"speedRotationFactorOptimal", 0.4},
		{"speedRotationFactorMax", 0.5},
		{"slideDamp", 1.3},
		{"engineAccel", 25},
		{"engineDecel", 30},
		{"engineYawAccel", 200},
		{"enginePitchAccel", 200},
		{"engineRollAccel", 100},
		{"maxSpeed", 0.95},
	},

	reactor = { name = "rct_generic", hitpoints = 285.9048, armor = 296.7009,},
	engine = { name = "eng_incom_fusialthrust", hitpoints = 97.55859, armor = 97.22115, speed = 52.7882, pitch = 33.30356, roll = 32.81654, yaw = 32.62107, acceleration = 16.17783, rollRate = 60.15535, pitchRate = 60.08889, deceleration = 8.137613, yawRate = 58.67763,},
	shield_0 = { name = "shd_generic", hitpoints = 391.3619, armor = 499.9176, regen = 4.790445, front = 294.0981, back = 477.6539,},
	armor_0 = { name = "arm_generic", hitpoints = 285.2036, armor = 286.6887,},
	armor_1 = { name = "arm_generic", hitpoints = 286.6339, armor = 295.6417,},
	capacitor = { name = "cap_generic", hitpoints = 0, armor = 0, rechargeRate = 34.94089, energy = 556.6486,},
	booster = { name = "bst_xwing_booster_s01", hitpoints = 19.84061, armor = 19.13522, energy = 0, acceleration = 0, speed = 0, energyUsage = 0, rechargeRate = 0,},
	weapon_0 = { name = "wpn_incom_disruptor", hitpoints = 194.7392, armor = 191.4498, rate = 0.3381855, drain = 22.9746, maxDamage = 242.9811, shieldEfficiency = 0, minDamage = 115.7708, ammo = 0, ammo_type = 0, armorEfficiency = 0,},
	weapon_1 = { name = "wpn_incom_disruptor", hitpoints = 190.8013, armor = 196.7648, rate = 0.3378254, drain = 23.14337, maxDamage = 240.4889, shieldEfficiency = 0, minDamage = 114.2796, ammo = 0, ammo_type = 0, armorEfficiency = 0,},
}

ObjectTemplates:addTemplate(object_ship_player_player_blacksun_medium_s01, "object/ship/player/player_blacksun_medium_s01.iff")
