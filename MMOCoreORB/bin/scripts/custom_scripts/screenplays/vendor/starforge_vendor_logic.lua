--[[
Created on: 08/09, 2021
Author: TheTinyPebble
Modified: Mannax
]]--
StarforgeVendorLogic = ScreenPlay:new {
	scriptName = "StarforgeVendorLogic",
	--EXAMPLE SETUP
	currencies = {
		--For Tokens: currency = "token", name: displayed name, full template string (without shared_), if applicable: ScreenPlayData string, ScreenPlayData key
			--{currency = "token", name = "Stardust Tokens", template = "object/tangible/item/stardust_pvp_token_generic.iff", ScreenPlayDataString = "vendorToken", ScreenPlayDataKey = "vendor_token"},
			--{currency = "tokentwo", name = "Locked Briefcases", template = "object/tangible/loot/misc/briefcase_s01.iff"}, 
		--For credits: currency = "credits"
			{currency = "credits"},
		--For experience: currency = "experience", displayed name, experience type
			--{currency = "experience", name = "CIS Currency", experience = "gcw_currency_rebel"},
			{currency = "experience", name = "Starforge Currency", experience =  "starforge_currency"},
		--For faction: currency = "faction", name = faction
			--{currency = "faction", name = "afarathu"},
		},

		merchandise_armor_schematics = { -- Displayed name, full template string (without the shared_), cost {} - follow same order as the currencies setup previously
			{name = "Schematic: Katarn Armor Helmet", template = "object/tangible/loot/loot_schematic/armor_clone_trooper_neutral_s01_helmet_schematic.iff", cost = {0, 1000}},
			{name = "Schematic: Katarn Armor Chest Plate", template = "object/tangible/loot/loot_schematic/armor_clone_trooper_neutral_s01_chest_plate_schematic.iff", cost = {0, 1000}},
			{name = "Schematic: Katarn Armor Leggings", template = "object/tangible/loot/loot_schematic/armor_clone_trooper_neutral_s01_leggings_schematic.iff", cost = {0, 1000}},
			{name = "Schematic: Katarn Armor Boots", template = "object/tangible/loot/loot_schematic/armor_clone_trooper_neutral_s01_boots_schematic.iff", cost = {0, 1000}},
			{name = "Schematic: Katarn Armor Belt", template = "object/tangible/loot/loot_schematic/armor_clone_trooper_neutral_s01_belt_schematic.iff", cost = {0, 1000}},
			{name = "Schematic: Katarn Armor Left Bracer", template = "object/tangible/loot/loot_schematic/armor_clone_trooper_neutral_s01_bracer_l_schematic.iff", cost = {0, 1000}},
			{name = "Schematic: Katarn Armor Right Bracer", template = "object/tangible/loot/loot_schematic/armor_clone_trooper_neutral_s01_bracer_r_schematic.iff", cost = {0, 1000}},
			{name = "Schematic: Katarn Armor Left Bicep", template = "object/tangible/loot/loot_schematic/armor_clone_trooper_neutral_s01_bicep_l_schematic.iff", cost = {0, 1000}},
			{name = "Schematic: Katarn Armor Right Bicep", template = "object/tangible/loot/loot_schematic/armor_clone_trooper_neutral_s01_bicep_r_schematic.iff", cost = {0, 1000}},
			{name = "Schematic: Katarn Armor Gloves", template = "object/tangible/loot/loot_schematic/armor_clone_trooper_neutral_s01_gloves_schematic.iff", cost = {0, 1000}},
		},
		merchandise_segments_as = { -- Displayed name, full template string (without the shared_), cost {} - follow same order as the currencies setup previously
		    {name = "Armorsmith Stun Segment", template = "object/tangible/loot/loot_schematic/armor_segment_armor_stun_schematic.iff", cost = {0, 1000}},
	    },
}

registerScreenPlay("StarforgeVendorLogic", false)

function StarforgeVendorLogic:openSUIArmorSchematics(pCreatureObject, pUsingObject)
	local sui = SuiListBox.new(self.scriptName, "defaultCallbackArmorSchematics")

	if (pUsingObject == nil) then
		sui.setTargetNetworkId(0)
	else
		sui.setTargetNetworkId(SceneObject(pUsingObject):getObjectID())
	end

	sui.setForceCloseDistance(16)

	sui.setTitle("Armorsmith Schematics")

	local message = "Please select which item you want to buy."
	sui.setPrompt(message)

	for i = 1, #self.merchandise_armor_schematics, 1 do
		local merchString = self:getMerchandiseStringArmorSchematics(i)
		sui.add(merchString, "")
	end

	sui.sendTo(pCreatureObject)
end

function StarforgeVendorLogic:openSUIArmorsmithSegments(pCreatureObject, pUsingObject)
	local sui = SuiListBox.new(self.scriptName, "defaultCallbackArmorsmithSegments")

	if (pUsingObject == nil) then
		sui.setTargetNetworkId(0)
	else
		sui.setTargetNetworkId(SceneObject(pUsingObject):getObjectID())
	end

	sui.setForceCloseDistance(16)

	sui.setTitle("Armorsmith Merchandise")

	local message = "Please select which item you want to buy."
	sui.setPrompt(message)

	for i = 1, #self.merchandise_segments_as, 1 do
		local merchString = self:getMerchandiseStringArmorsmithSegments(i)
		sui.add(merchString, "")
	end

	sui.sendTo(pCreatureObject)
end

function StarforgeVendorLogic:defaultCallbackArmorSchematics(pPlayer, pSui, eventIndex, args)
	local cancelPressed = (eventIndex == 1)

	if (cancelPressed) then
		return
	end

	if (args == "-1") then
		CreatureObject(pPlayer):sendSystemMessage("No option was selected, please try again.")
		return
	end

	local selectedOption = tonumber(args) + 1

	self:buyItemArmorSchematics(pPlayer, selectedOption)
end

function StarforgeVendorLogic:defaultCallbackArmorsmithSegments(pPlayer, pSui, eventIndex, args)
	local cancelPressed = (eventIndex == 1)

	if (cancelPressed) then
		return
	end

	if (args == "-1") then
		CreatureObject(pPlayer):sendSystemMessage("No option was selected, please try again.")
		return
	end

	local selectedOption = tonumber(args) + 1

	self:buyItemArmorsmithSegments(pPlayer, selectedOption)
end

function StarforgeVendorLogic:buyItemArmorSchematics(pPlayer, itemSelected)
	local merch = self.merchandise_armor_schematics[itemSelected]
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local containerSize = SceneObject(pInventory):getContainerObjectsSize()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end
 
	if (SceneObject(pInventory):isContainerFullRecursive()) then
		CreatureObject(pPlayer):sendSystemMessage("You do not have enough inventory space.")
		return
	end

	local canPurchase = self:hasEnoughCurrencyArmorSchematics(pPlayer, itemSelected)

	if (canPurchase) then
		for i = 1, #merch.cost do
			local currency = self.currencies[i].currency
			local currencyName = self.currencies[i].name
			local ExPname = self.currencies[i].experience
			local cost = merch.cost[i]
			if (cost ~= 0) then
				if (currency == "token") then
					self:payTokensArmorSchematics(pPlayer, itemSelected, i)
				end
				if (currency == "credits") then 
					if (cost <= CreatureObject(pPlayer):getCashCredits()) then
						CreatureObject(pPlayer):subtractCashCredits(cost)
					else
						cost = cost - CreatureObject(pPlayer):getCashCredits()
						CreatureObject(pPlayer):subtractCashCredits(CreatureObject(pPlayer):getCashCredits())
						CreatureObject(pPlayer):setBankCredits(CreatureObject(pPlayer):getBankCredits() - cost)
					end
				end
				if (currency == "experience") then
					CreatureObject(pPlayer):awardExperience(ExPname, cost * -1, true)
				end
				if (currency == "faction") then
					PlayerObject(pGhost):decreaseFactionStanding(currencyName, cost)
				end
			end
		end	
		CreatureObject(pPlayer):sendSystemMessage("You have purchased " .. merch.name)
		local pItem = giveItem(pInventory, merch.template, -1)		
		if (string.match(SceneObject(pItem):getTemplateObjectPath(), "lightsaber_module_force_crystal") and pItem ~= nil) then
			if (merch.color ~= nil) then
				local colorCrystal = LuaLightsaberCrystalComponent(pItem)
				colorCrystal:setColor(merch.color)
				colorCrystal:updateCrystal(merch.color)
			end
		end
	else
		CreatureObject(pPlayer):sendSystemMessage("You can't afford the selected item.")
	end
end

function StarforgeVendorLogic:buyItemArmorsmithSegments(pPlayer, itemSelected)
	local merch = self.merchandise_segments_as[itemSelected]
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local containerSize = SceneObject(pInventory):getContainerObjectsSize()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end
 
	if (SceneObject(pInventory):isContainerFullRecursive()) then
		CreatureObject(pPlayer):sendSystemMessage("You do not have enough inventory space.")
		return
	end

	local canPurchase = self:hasEnoughCurrencyArmorsmithSegments(pPlayer, itemSelected)

	if (canPurchase) then
		for i = 1, #merch.cost do
			local currency = self.currencies[i].currency
			local currencyName = self.currencies[i].name
			local cost = merch.cost[i]
			if (cost ~= 0) then
				if (currency == "token") then
					self:payTokensArmorsmithSegments(pPlayer, itemSelected, i)
				end
				if (currency == "credits") then 
					if (cost <= CreatureObject(pPlayer):getCashCredits()) then
						CreatureObject(pPlayer):subtractCashCredits(cost)
					else
						cost = cost - CreatureObject(pPlayer):getCashCredits()
						CreatureObject(pPlayer):subtractCashCredits(CreatureObject(pPlayer):getCashCredits())
						CreatureObject(pPlayer):setBankCredits(CreatureObject(pPlayer):getBankCredits() - cost)
					end
				end
				if (currency == "experience") then
					CreatureObject(pPlayer):awardExperience(currencyName, cost * -1, true)
				end
				if (currency == "faction") then
					PlayerObject(pGhost):decreaseFactionStanding(currencyName, cost)
				end
			end
		end	
		CreatureObject(pPlayer):sendSystemMessage("You have purchased " .. merch.name)
		local pItem = giveItem(pInventory, merch.template, -1)		
		if (string.match(SceneObject(pItem):getTemplateObjectPath(), "lightsaber_module_force_crystal") and pItem ~= nil) then
			if (merch.color ~= nil) then
				local colorCrystal = LuaLightsaberCrystalComponent(pItem)
				colorCrystal:setColor(merch.color)
				colorCrystal:updateCrystal(merch.color)
			end
		end
	else
		CreatureObject(pPlayer):sendSystemMessage("You can't afford the selected item.")
	end
end

function StarforgeVendorLogic:getMerchandiseStringArmorSchematics(num)
	local merch = self.merchandise_armor_schematics[num]
	local merchString = merch.name .. " ("

	for i = 1, #merch.cost do
		local currency = self.currencies[i].currency
		local currencyName = self.currencies[i].name
		if (merch.cost[i] > 0) then
			if (currency == "token") then
				merchString = merchString .. merch.cost[i] .. " " .. currencyName
			end
			if (currency == "credits") then
				merchString = merchString .. merch.cost[i] .. " Credits"
			end
			if (currency == "experience") then
				merchString = merchString .. merch.cost[i] .. " " .. currencyName
			end
			if (currency == "faction") then
				merchString = merchString .. merch.cost[i] .. " " .. currencyName:gsub("^%l", string.upper) .. " faction"
			end
			merchString = merchString .. ", "
		end
	end

	merchString = merchString .. ")"
	return merchString:gsub(", %)", ")")
end

function StarforgeVendorLogic:getMerchandiseStringArmorsmithSegments(num)
	local merch = self.merchandise_segments_as[num]
	local merchString = merch.name .. " ("

	for i = 1, #merch.cost do
		local currency = self.currencies[i].currency
		local currencyName = self.currencies[i].name
		if (merch.cost[i] > 0) then
			if (currency == "token") then
				merchString = merchString .. merch.cost[i] .. " " .. currencyName
			end
			if (currency == "credits") then
				merchString = merchString .. merch.cost[i] .. " Credits"
			end
			if (currency == "experience") then
				merchString = merchString .. merch.cost[i] .. " " .. currencyName
			end
			if (currency == "faction") then
				merchString = merchString .. merch.cost[i] .. " " .. currencyName:gsub("^%l", string.upper) .. " faction"
			end
			merchString = merchString .. ", "
		end
	end

	merchString = merchString .. ")"
	return merchString:gsub(", %)", ")")
end

function StarforgeVendorLogic:hasEnoughCurrencyArmorSchematics(pPlayer, num)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local containerSize = SceneObject(pInventory):getContainerObjectsSize()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local merch = self.merchandise_armor_schematics[num]

	for i = 1, #merch.cost do
		local currency = self.currencies[i].currency
		local currencyName = self.currencies[i].name
		local cost = merch.cost[i]
		if (cost > 0) then
			if (currency == "token") then
				local tokens = 0
				for j = 0, containerSize - 1, 1 do
					local pInvObj = SceneObject(pInventory):getContainerObject(j)
					local invSceno = LuaSceneObject(pInvObj)
					local invTano = LuaTangibleObject(pInvObj)
					if (invSceno:getTemplateObjectPath() == self.currencies[i].template)  then
						if (invTano:getUseCount() == 0) then
							tokens = tokens + 1
						else
							tokens = tokens + invTano:getUseCount()
						end
					end
				end
				if (self.currencies[i].ScreenPlayDataString ~= nil and self.currencies[i].ScreenPlayDataKey ~= nil) then
					local tokenData = tonumber(readScreenPlayData(pPlayer, self.currencies[i].ScreenPlayDataString, self.currencies[i].ScreenPlayDataKey))
					if (tokenData == "" or tokenData == nil) then
						tokenData = 0
					end
					tokens = tokens + tokenData
				end
				if (tokens < cost) then
					return false
				end
			end
			if (currency == "credits") then
				if (CreatureObject(pPlayer):getCashCredits() + CreatureObject(pPlayer):getBankCredits() < cost) then
					return false
				end
			end
			if (currency == "experience") then
				if (PlayerObject(pGhost):getExperience(self.currencies[i].experience) < cost) then
					return false
				end
			end
			if (currency == "faction") then
				if (PlayerObject(pGhost):getFactionStanding(currencyName) < cost) then
					return false
				end
			end
		end
	end

	return true
end

function StarforgeVendorLogic:hasEnoughCurrencyArmorsmithSegments(pPlayer, num)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local containerSize = SceneObject(pInventory):getContainerObjectsSize()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local merch = self.merchandise_segments_as[num]

	for i = 1, #merch.cost do
		local currency = self.currencies[i].currency
		local currencyName = self.currencies[i].name
		local cost = merch.cost[i]
		if (cost > 0) then
			if (currency == "token") then
				local tokens = 0
				for j = 0, containerSize - 1, 1 do
					local pInvObj = SceneObject(pInventory):getContainerObject(j)
					local invSceno = LuaSceneObject(pInvObj)
					local invTano = LuaTangibleObject(pInvObj)
					if (invSceno:getTemplateObjectPath() == self.currencies[i].template)  then
						if (invTano:getUseCount() == 0) then
							tokens = tokens + 1
						else
							tokens = tokens + invTano:getUseCount()
						end
					end
				end
				if (self.currencies[i].ScreenPlayDataString ~= nil and self.currencies[i].ScreenPlayDataKey ~= nil) then
					local tokenData = tonumber(readScreenPlayData(pPlayer, self.currencies[i].ScreenPlayDataString, self.currencies[i].ScreenPlayDataKey))
					if (tokenData == "" or tokenData == nil) then
						tokenData = 0
					end
					tokens = tokens + tokenData
				end
				if (tokens < cost) then
					return false
				end
			end
			if (currency == "credits") then
				if (CreatureObject(pPlayer):getCashCredits() + CreatureObject(pPlayer):getBankCredits() < cost) then
					return false
				end
			end
			if (currency == "experience") then
				if (PlayerObject(pGhost):getExperience(self.currencies[i].experience) < cost) then
					return false
				end
			end
			if (currency == "faction") then
				if (PlayerObject(pGhost):getFactionStanding(currencyName) < cost) then
					return false
				end
			end
		end
	end

	return true
end

function StarforgeVendorLogic:payTokensArmorSchematics(pPlayer, selectedItem, num)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local containerSize = SceneObject(pInventory):getContainerObjectsSize()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	
	local merch = self.merchandise_armor_schematics[selectedItem]
	local tokenCost = merch.cost[num]
	deleteItems = 0
	tokens = 0
	screenPlayTokenCost = 0

	for i = 0, containerSize - 1, 1 do
		local pInvObj = SceneObject(pInventory):getContainerObject(i)
		local invTano = LuaTangibleObject(pInvObj)
		if (SceneObject(pInvObj):getTemplateObjectPath() == self.currencies[num].template)  then
			if (invTano:getUseCount() == 0) then
				tokens = tokens + 1
			else
				tokens = tokens + invTano:getUseCount()
			end
		end
	end

	if (tokens < tokenCost) then
		deleteItems = tokens
		screenPlayTokenCost = tokenCost - tokens
	else 
		deleteItems = tokenCost
	end

	for i = containerSize - 1 , 0 , -1 do
		pInvObj = SceneObject(pInventory):getContainerObject(i)
		invSceno = LuaSceneObject(pInvObj)
		invTano = LuaTangibleObject(pInvObj)
		if (invSceno:getTemplateObjectPath() == self.currencies[num].template and deleteItems > 0 ) then
			if (invTano:getUseCount() == 0) then
				if (deleteItems - 1 == 0) then
					deleteItems = 0
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
					break
				else
					deleteItems = deleteItems - 1
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
				end
			else
				if (invTano:getUseCount() - deleteItems < 0) then
					deleteItems = deleteItems - invTano:getUseCount()
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
				elseif (invTano:getUseCount() - deleteItems == 0) then
					deleteItems = 0
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
					break
				else 
					deleteItems = 0
					invTano:setUseCount(invTano:getUseCount() - tokenCost)
					break
				end
			end
		end
	end

	if (screenPlayTokenCost > 0) then
		local tokenData = tonumber(readScreenPlayData(pPlayer, self.currencies[i].ScreenPlayDataString, self.currencies[i].ScreenPlayDataKey))
		writeScreenPlayData(pPlayer, self.currencies[i].ScreenPlayDataString, self.currencies[i].ScreenPlayDataKey, tokenData - screenPlayTokenCost)
	end
end

function StarforgeVendorLogic:payTokensArmorsmithSegments(pPlayer, selectedItem, num)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local containerSize = SceneObject(pInventory):getContainerObjectsSize()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	
	local merch = self.merchandise_segments_as[selectedItem]
	local tokenCost = merch.cost[num]
	deleteItems = 0
	tokens = 0
	screenPlayTokenCost = 0

	for i = 0, containerSize - 1, 1 do
		local pInvObj = SceneObject(pInventory):getContainerObject(i)
		local invTano = LuaTangibleObject(pInvObj)
		if (SceneObject(pInvObj):getTemplateObjectPath() == self.currencies[num].template)  then
			if (invTano:getUseCount() == 0) then
				tokens = tokens + 1
			else
				tokens = tokens + invTano:getUseCount()
			end
		end
	end

	if (tokens < tokenCost) then
		deleteItems = tokens
		screenPlayTokenCost = tokenCost - tokens
	else 
		deleteItems = tokenCost
	end

	for i = containerSize - 1 , 0 , -1 do
		pInvObj = SceneObject(pInventory):getContainerObject(i)
		invSceno = LuaSceneObject(pInvObj)
		invTano = LuaTangibleObject(pInvObj)
		if (invSceno:getTemplateObjectPath() == self.currencies[num].template and deleteItems > 0 ) then
			if (invTano:getUseCount() == 0) then
				if (deleteItems - 1 == 0) then
					deleteItems = 0
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
					break
				else
					deleteItems = deleteItems - 1
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
				end
			else
				if (invTano:getUseCount() - deleteItems < 0) then
					deleteItems = deleteItems - invTano:getUseCount()
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
				elseif (invTano:getUseCount() - deleteItems == 0) then
					deleteItems = 0
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
					break
				else 
					deleteItems = 0
					invTano:setUseCount(invTano:getUseCount() - tokenCost)
					break
				end
			end
		end
	end

	if (screenPlayTokenCost > 0) then
		local tokenData = tonumber(readScreenPlayData(pPlayer, self.currencies[i].ScreenPlayDataString, self.currencies[i].ScreenPlayDataKey))
		writeScreenPlayData(pPlayer, self.currencies[i].ScreenPlayDataString, self.currencies[i].ScreenPlayDataKey, tokenData - screenPlayTokenCost)
	end
end

--GEN3
function StarforgeVendorLogic:openSUILightsaberGenThree(pCreatureObject, pUsingObject)
	local sui = SuiListBox.new(self.scriptName, "defaultCallbackLightsaberGenThree")

	if (pUsingObject == nil) then
		sui.setTargetNetworkId(0)
	else
		sui.setTargetNetworkId(SceneObject(pUsingObject):getObjectID())
	end

	sui.setForceCloseDistance(16)

	sui.setTitle("Armorsmith Schematics")

	local message = "Please select which item you want to buy."
	sui.setPrompt(message)

	for i = 1, #self.merchandise_weapon_lightsaber_gen3, 1 do
		local merchString = self:getMerchandiseStringLightsaberGenThree(i)
		sui.add(merchString, "")
	end

	sui.sendTo(pCreatureObject)
end

function StarforgeVendorLogic:defaultCallbackLightsaberGenThree(pPlayer, pSui, eventIndex, args)
	local cancelPressed = (eventIndex == 1)

	if (cancelPressed) then
		return
	end

	if (args == "-1") then
		CreatureObject(pPlayer):sendSystemMessage("No option was selected, please try again.")
		return
	end

	local selectedOption = tonumber(args) + 1

	self:buyItemLightsaberGenThree(pPlayer, selectedOption)
end

function StarforgeVendorLogic:buyItemLightsaberGenThree(pPlayer, itemSelected)
	local merch = self.merchandise_weapon_lightsaber_gen3[itemSelected]
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local containerSize = SceneObject(pInventory):getContainerObjectsSize()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end
 
	if (SceneObject(pInventory):isContainerFullRecursive()) then
		CreatureObject(pPlayer):sendSystemMessage("You do not have enough inventory space.")
		return
	end

	local canPurchase = self:hasEnoughCurrencyLightsaberGenThree(pPlayer, itemSelected)

	if (canPurchase) then
		for i = 1, #merch.cost do
			local currency = self.currencies[i].currency
			local currencyName = self.currencies[i].name
			local ExPname = self.currencies[i].experience
			local cost = merch.cost[i]
			if (cost ~= 0) then
				if (currency == "token") then
					self:payTokensLightsaberGenThree(pPlayer, itemSelected, i)
				end
				if (currency == "credits") then 
					if (cost <= CreatureObject(pPlayer):getCashCredits()) then
						CreatureObject(pPlayer):subtractCashCredits(cost)
					else
						cost = cost - CreatureObject(pPlayer):getCashCredits()
						CreatureObject(pPlayer):subtractCashCredits(CreatureObject(pPlayer):getCashCredits())
						CreatureObject(pPlayer):setBankCredits(CreatureObject(pPlayer):getBankCredits() - cost)
					end
				end
				if (currency == "experience") then
					CreatureObject(pPlayer):awardExperience(ExPname, cost * -1, true)
				end
				if (currency == "faction") then
					PlayerObject(pGhost):decreaseFactionStanding(currencyName, cost)
				end
			end
		end	
		CreatureObject(pPlayer):sendSystemMessage("You have purchased " .. merch.name)
		local pItem = giveItem(pInventory, merch.template, -1)		
		if (string.match(SceneObject(pItem):getTemplateObjectPath(), "lightsaber_module_force_crystal") and pItem ~= nil) then
			if (merch.color ~= nil) then
				local colorCrystal = LuaLightsaberCrystalComponent(pItem)
				colorCrystal:setColor(merch.color)
				colorCrystal:updateCrystal(merch.color)
			end
		end
	else
		CreatureObject(pPlayer):sendSystemMessage("You can't afford the selected item.")
	end
end

function StarforgeVendorLogic:getMerchandiseStringLightsaberGenThree(num)
	local merch = self.merchandise_weapon_lightsaber_gen3[num]
	local merchString = merch.name .. " ("

	for i = 1, #merch.cost do
		local currency = self.currencies[i].currency
		local currencyName = self.currencies[i].name
		if (merch.cost[i] > 0) then
			if (currency == "token") then
				merchString = merchString .. merch.cost[i] .. " " .. currencyName
			end
			if (currency == "credits") then
				merchString = merchString .. merch.cost[i] .. " Credits"
			end
			if (currency == "experience") then
				merchString = merchString .. merch.cost[i] .. " " .. currencyName
			end
			if (currency == "faction") then
				merchString = merchString .. merch.cost[i] .. " " .. currencyName:gsub("^%l", string.upper) .. " faction"
			end
			merchString = merchString .. ", "
		end
	end

	merchString = merchString .. ")"
	return merchString:gsub(", %)", ")")
end
function StarforgeVendorLogic:hasEnoughCurrencyLightsaberGenThree(pPlayer, num)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local containerSize = SceneObject(pInventory):getContainerObjectsSize()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local merch = self.merchandise_weapon_lightsaber_gen3[num]

	for i = 1, #merch.cost do
		local currency = self.currencies[i].currency
		local currencyName = self.currencies[i].name
		local cost = merch.cost[i]
		if (cost > 0) then
			if (currency == "token") then
				local tokens = 0
				for j = 0, containerSize - 1, 1 do
					local pInvObj = SceneObject(pInventory):getContainerObject(j)
					local invSceno = LuaSceneObject(pInvObj)
					local invTano = LuaTangibleObject(pInvObj)
					if (invSceno:getTemplateObjectPath() == self.currencies[i].template)  then
						if (invTano:getUseCount() == 0) then
							tokens = tokens + 1
						else
							tokens = tokens + invTano:getUseCount()
						end
					end
				end
				if (self.currencies[i].ScreenPlayDataString ~= nil and self.currencies[i].ScreenPlayDataKey ~= nil) then
					local tokenData = tonumber(readScreenPlayData(pPlayer, self.currencies[i].ScreenPlayDataString, self.currencies[i].ScreenPlayDataKey))
					if (tokenData == "" or tokenData == nil) then
						tokenData = 0
					end
					tokens = tokens + tokenData
				end
				if (tokens < cost) then
					return false
				end
			end
			if (currency == "credits") then
				if (CreatureObject(pPlayer):getCashCredits() + CreatureObject(pPlayer):getBankCredits() < cost) then
					return false
				end
			end
			if (currency == "experience") then
				if (PlayerObject(pGhost):getExperience(self.currencies[i].experience) < cost) then
					return false
				end
			end
			if (currency == "faction") then
				if (PlayerObject(pGhost):getFactionStanding(currencyName) < cost) then
					return false
				end
			end
		end
	end

	return true
end
function StarforgeVendorLogic:payTokensLightsaberGenThree(pPlayer, selectedItem, num)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local containerSize = SceneObject(pInventory):getContainerObjectsSize()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	
	local merch = self.merchandise_weapon_lightsaber_gen3[selectedItem]
	local tokenCost = merch.cost[num]
	deleteItems = 0
	tokens = 0
	screenPlayTokenCost = 0

	for i = 0, containerSize - 1, 1 do
		local pInvObj = SceneObject(pInventory):getContainerObject(i)
		local invTano = LuaTangibleObject(pInvObj)
		if (SceneObject(pInvObj):getTemplateObjectPath() == self.currencies[num].template)  then
			if (invTano:getUseCount() == 0) then
				tokens = tokens + 1
			else
				tokens = tokens + invTano:getUseCount()
			end
		end
	end

	if (tokens < tokenCost) then
		deleteItems = tokens
		screenPlayTokenCost = tokenCost - tokens
	else 
		deleteItems = tokenCost
	end

	for i = containerSize - 1 , 0 , -1 do
		pInvObj = SceneObject(pInventory):getContainerObject(i)
		invSceno = LuaSceneObject(pInvObj)
		invTano = LuaTangibleObject(pInvObj)
		if (invSceno:getTemplateObjectPath() == self.currencies[num].template and deleteItems > 0 ) then
			if (invTano:getUseCount() == 0) then
				if (deleteItems - 1 == 0) then
					deleteItems = 0
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
					break
				else
					deleteItems = deleteItems - 1
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
				end
			else
				if (invTano:getUseCount() - deleteItems < 0) then
					deleteItems = deleteItems - invTano:getUseCount()
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
				elseif (invTano:getUseCount() - deleteItems == 0) then
					deleteItems = 0
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
					break
				else 
					deleteItems = 0
					invTano:setUseCount(invTano:getUseCount() - tokenCost)
					break
				end
			end
		end
	end

	if (screenPlayTokenCost > 0) then
		local tokenData = tonumber(readScreenPlayData(pPlayer, self.currencies[i].ScreenPlayDataString, self.currencies[i].ScreenPlayDataKey))
		writeScreenPlayData(pPlayer, self.currencies[i].ScreenPlayDataString, self.currencies[i].ScreenPlayDataKey, tokenData - screenPlayTokenCost)
	end
end

--GEN4
function StarforgeVendorLogic:openSUILightsaberGenFour(pCreatureObject, pUsingObject)
	local sui = SuiListBox.new(self.scriptName, "defaultCallbackLightsaberGenFour")

	if (pUsingObject == nil) then
		sui.setTargetNetworkId(0)
	else
		sui.setTargetNetworkId(SceneObject(pUsingObject):getObjectID())
	end

	sui.setForceCloseDistance(16)

	sui.setTitle("Armorsmith Schematics")

	local message = "Please select which item you want to buy."
	sui.setPrompt(message)

	for i = 1, #self.merchandise_weapon_lightsaber_gen3, 1 do
		local merchString = self:getMerchandiseStringLightsaberGenFour(i)
		sui.add(merchString, "")
	end

	sui.sendTo(pCreatureObject)
end

function StarforgeVendorLogic:defaultCallbackLightsaberGenFour(pPlayer, pSui, eventIndex, args)
	local cancelPressed = (eventIndex == 1)

	if (cancelPressed) then
		return
	end

	if (args == "-1") then
		CreatureObject(pPlayer):sendSystemMessage("No option was selected, please try again.")
		return
	end

	local selectedOption = tonumber(args) + 1

	self:buyItemLightsaberGenFour(pPlayer, selectedOption)
end

function StarforgeVendorLogic:buyItemLightsaberGenFour(pPlayer, itemSelected)
	local merch = self.merchandise_weapon_lightsaber_gen3[itemSelected]
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local containerSize = SceneObject(pInventory):getContainerObjectsSize()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end
 
	if (SceneObject(pInventory):isContainerFullRecursive()) then
		CreatureObject(pPlayer):sendSystemMessage("You do not have enough inventory space.")
		return
	end

	local canPurchase = self:hasEnoughCurrencyLightsaberGenFour(pPlayer, itemSelected)

	if (canPurchase) then
		for i = 1, #merch.cost do
			local currency = self.currencies[i].currency
			local currencyName = self.currencies[i].name
			local ExPname = self.currencies[i].experience
			local cost = merch.cost[i]
			if (cost ~= 0) then
				if (currency == "token") then
					self:payTokensLightsaberGenFour(pPlayer, itemSelected, i)
				end
				if (currency == "credits") then 
					if (cost <= CreatureObject(pPlayer):getCashCredits()) then
						CreatureObject(pPlayer):subtractCashCredits(cost)
					else
						cost = cost - CreatureObject(pPlayer):getCashCredits()
						CreatureObject(pPlayer):subtractCashCredits(CreatureObject(pPlayer):getCashCredits())
						CreatureObject(pPlayer):setBankCredits(CreatureObject(pPlayer):getBankCredits() - cost)
					end
				end
				if (currency == "experience") then
					CreatureObject(pPlayer):awardExperience(ExPname, cost * -1, true)
				end
				if (currency == "faction") then
					PlayerObject(pGhost):decreaseFactionStanding(currencyName, cost)
				end
			end
		end	
		CreatureObject(pPlayer):sendSystemMessage("You have purchased " .. merch.name)
		local pItem = giveItem(pInventory, merch.template, -1)		
		if (string.match(SceneObject(pItem):getTemplateObjectPath(), "lightsaber_module_force_crystal") and pItem ~= nil) then
			if (merch.color ~= nil) then
				local colorCrystal = LuaLightsaberCrystalComponent(pItem)
				colorCrystal:setColor(merch.color)
				colorCrystal:updateCrystal(merch.color)
			end
		end
	else
		CreatureObject(pPlayer):sendSystemMessage("You can't afford the selected item.")
	end
end

function StarforgeVendorLogic:getMerchandiseStringLightsaberGenFour(num)
	local merch = self.merchandise_weapon_lightsaber_gen3[num]
	local merchString = merch.name .. " ("

	for i = 1, #merch.cost do
		local currency = self.currencies[i].currency
		local currencyName = self.currencies[i].name
		if (merch.cost[i] > 0) then
			if (currency == "token") then
				merchString = merchString .. merch.cost[i] .. " " .. currencyName
			end
			if (currency == "credits") then
				merchString = merchString .. merch.cost[i] .. " Credits"
			end
			if (currency == "experience") then
				merchString = merchString .. merch.cost[i] .. " " .. currencyName
			end
			if (currency == "faction") then
				merchString = merchString .. merch.cost[i] .. " " .. currencyName:gsub("^%l", string.upper) .. " faction"
			end
			merchString = merchString .. ", "
		end
	end

	merchString = merchString .. ")"
	return merchString:gsub(", %)", ")")
end
function StarforgeVendorLogic:hasEnoughCurrencyLightsaberGenFour(pPlayer, num)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local containerSize = SceneObject(pInventory):getContainerObjectsSize()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local merch = self.merchandise_weapon_lightsaber_gen3[num]

	for i = 1, #merch.cost do
		local currency = self.currencies[i].currency
		local currencyName = self.currencies[i].name
		local cost = merch.cost[i]
		if (cost > 0) then
			if (currency == "token") then
				local tokens = 0
				for j = 0, containerSize - 1, 1 do
					local pInvObj = SceneObject(pInventory):getContainerObject(j)
					local invSceno = LuaSceneObject(pInvObj)
					local invTano = LuaTangibleObject(pInvObj)
					if (invSceno:getTemplateObjectPath() == self.currencies[i].template)  then
						if (invTano:getUseCount() == 0) then
							tokens = tokens + 1
						else
							tokens = tokens + invTano:getUseCount()
						end
					end
				end
				if (self.currencies[i].ScreenPlayDataString ~= nil and self.currencies[i].ScreenPlayDataKey ~= nil) then
					local tokenData = tonumber(readScreenPlayData(pPlayer, self.currencies[i].ScreenPlayDataString, self.currencies[i].ScreenPlayDataKey))
					if (tokenData == "" or tokenData == nil) then
						tokenData = 0
					end
					tokens = tokens + tokenData
				end
				if (tokens < cost) then
					return false
				end
			end
			if (currency == "credits") then
				if (CreatureObject(pPlayer):getCashCredits() + CreatureObject(pPlayer):getBankCredits() < cost) then
					return false
				end
			end
			if (currency == "experience") then
				if (PlayerObject(pGhost):getExperience(self.currencies[i].experience) < cost) then
					return false
				end
			end
			if (currency == "faction") then
				if (PlayerObject(pGhost):getFactionStanding(currencyName) < cost) then
					return false
				end
			end
		end
	end

	return true
end
function StarforgeVendorLogic:payTokensLightsaberGenFour(pPlayer, selectedItem, num)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local containerSize = SceneObject(pInventory):getContainerObjectsSize()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	
	local merch = self.merchandise_weapon_lightsaber_gen3[selectedItem]
	local tokenCost = merch.cost[num]
	deleteItems = 0
	tokens = 0
	screenPlayTokenCost = 0

	for i = 0, containerSize - 1, 1 do
		local pInvObj = SceneObject(pInventory):getContainerObject(i)
		local invTano = LuaTangibleObject(pInvObj)
		if (SceneObject(pInvObj):getTemplateObjectPath() == self.currencies[num].template)  then
			if (invTano:getUseCount() == 0) then
				tokens = tokens + 1
			else
				tokens = tokens + invTano:getUseCount()
			end
		end
	end

	if (tokens < tokenCost) then
		deleteItems = tokens
		screenPlayTokenCost = tokenCost - tokens
	else 
		deleteItems = tokenCost
	end

	for i = containerSize - 1 , 0 , -1 do
		pInvObj = SceneObject(pInventory):getContainerObject(i)
		invSceno = LuaSceneObject(pInvObj)
		invTano = LuaTangibleObject(pInvObj)
		if (invSceno:getTemplateObjectPath() == self.currencies[num].template and deleteItems > 0 ) then
			if (invTano:getUseCount() == 0) then
				if (deleteItems - 1 == 0) then
					deleteItems = 0
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
					break
				else
					deleteItems = deleteItems - 1
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
				end
			else
				if (invTano:getUseCount() - deleteItems < 0) then
					deleteItems = deleteItems - invTano:getUseCount()
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
				elseif (invTano:getUseCount() - deleteItems == 0) then
					deleteItems = 0
					invSceno:destroyObjectFromWorld()
					invSceno:destroyObjectFromDatabase()
					break
				else 
					deleteItems = 0
					invTano:setUseCount(invTano:getUseCount() - tokenCost)
					break
				end
			end
		end
	end

	if (screenPlayTokenCost > 0) then
		local tokenData = tonumber(readScreenPlayData(pPlayer, self.currencies[i].ScreenPlayDataString, self.currencies[i].ScreenPlayDataKey))
		writeScreenPlayData(pPlayer, self.currencies[i].ScreenPlayDataString, self.currencies[i].ScreenPlayDataKey, tokenData - screenPlayTokenCost)
	end
end