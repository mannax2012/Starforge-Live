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


object_tangible_deed_vehicle_deed_speederbike_swoop_deed = object_tangible_deed_vehicle_deed_shared_speederbike_swoop_deed:new {

	templateType = VEHICLEDEED,

	controlDeviceObjectTemplate = "object/intangible/vehicle/speederbike_swoop_pcd.iff",
	generatedObjectTemplate = "object/mobile/vehicle/speederbike_swoop.iff",

	numberExperimentalProperties = {1, 1, 3, 1, 3, 3, 3},
	experimentalProperties = {"XX", "XX", "OQ", "SR", "UT", "XX", "OQ", "DR", "MA", "OQ", "SR", "MA", "OQ", "DR", "SR"},
	experimentalWeights = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	experimentalGroupTitles = {"null", "null", "exp_durability", "null", "exp_speed", "exp_handling", "exp_acceleration"},
	experimentalSubGroupTitles = {"null", "null", "hit_points", "vehicle_resists", "vehicle_speed", "vehicle_handling", "vehicle_acceleration"},
	experimentalMin = {0, 0, 1750, 0, 10.0, 75, 15.0},
	experimentalMax = {0, 0, 3000, 0, 30.0, 80, 40.0},
	experimentalPrecision = {0, 0, 0, 0, 2, 1, 2},
	experimentalCombineType = {0, 0, 1, 1, 1, 1, 1},
}

ObjectTemplates:addTemplate(object_tangible_deed_vehicle_deed_speederbike_swoop_deed, "object/tangible/deed/vehicle_deed/speederbike_swoop_deed.iff")
