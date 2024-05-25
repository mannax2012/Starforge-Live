--[[
Created on: 08/09, 2021
Author: TheTinyPebble
Modified: Mannax
]]--
VehiclesVendorLogic = ScreenPlay:new {
	scriptName = "VehiclesVendorLogic",
	currencies = {
			{currency = "credits"},
			{currency = "experience", name = "Starforge Currency", experience =  "starforge_currency"},
		        },

		merchandise_vehicles = { -- Displayed name, full template string (without the shared_), cost {} - follow same order as the currencies setup previously
		{name = "Anakin's Podracer Schematic", template = "object/tangible/loot/loot_schematic/vehicle/podracer_anakin_schematic.iff", cost = {0, 10000}},
		{name = "Sebulba's Podracer Schematic", template = "object/tangible/loot/loot_schematic/vehicle/podracer_sebulba_schematic.iff", cost = {0, 10000}},
		{name = "Balta's Podracer Schematic", template = "object/tangible/loot/loot_schematic/vehicle/podracer_balta_schematic.iff", cost = {0, 10000}},
		{name = "IPG Podracer Schematic", template = "object/tangible/loot/loot_schematic/vehicle/podracer_ipg_schematic.iff", cost = {0, 10000}},
		{name = "Gasgano Podracer Schematic", template = "object/tangible/loot/loot_schematic/vehicle/podracer_gasgano_schematic.iff", cost = {0, 10000}},
		{name = "Mawhonical Podracer Schematic", template = "object/tangible/loot/loot_schematic/vehicle/podracer_mawhonical_schematic.iff", cost = {0, 10000}},
	    },
}

registerScreenPlay("VehiclesVendorLogic", false)

--GEN3
function VehiclesVendorLogic:openSUIVehicles(pCreatureObject, pUsingObject)
	local sui = SuiListBox.new(self.scriptName, "defaultCallbackVehicles")

	if (pUsingObject == nil) then
		sui.setTargetNetworkId(0)
	else
		sui.setTargetNetworkId(SceneObject(pUsingObject):getObjectID())
	end

	sui.setForceCloseDistance(16)

	sui.setTitle("Vehicle Schematics")

	local message = "Please select which item you want to buy."
	sui.setPrompt(message)

	for i = 1, #self.merchandise_vehicles, 1 do
		local merchString = self:getMerchandiseStringVehicles(i)
		sui.add(merchString, "")
	end

	sui.sendTo(pCreatureObject)
end

function VehiclesVendorLogic:defaultCallbackVehicles(pPlayer, pSui, eventIndex, args)
	local cancelPressed = (eventIndex == 1)

	if (cancelPressed) then
		return
	end

	if (args == "-1") then
		CreatureObject(pPlayer):sendSystemMessage("No option was selected, please try again.")
		return
	end

	local selectedOption = tonumber(args) + 1

	self:buyItemVehicles(pPlayer, selectedOption)
end

function VehiclesVendorLogic:buyItemVehicles(pPlayer, itemSelected)
	local merch = self.merchandise_vehicles[itemSelected]
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

	local canPurchase = self:hasEnoughCurrencyVehicles(pPlayer, itemSelected)

	if (canPurchase) then
		for i = 1, #merch.cost do
			local currency = self.currencies[i].currency
			local currencyName = self.currencies[i].name
			local ExPname = self.currencies[i].experience
			local cost = merch.cost[i]
			if (cost ~= 0) then
				if (currency == "token") then
					self:payTokensVehicles(pPlayer, itemSelected, i)
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

function VehiclesVendorLogic:getMerchandiseStringVehicles(num)
	local merch = self.merchandise_vehicles[num]
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
function VehiclesVendorLogic:hasEnoughCurrencyVehicles(pPlayer, num)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local containerSize = SceneObject(pInventory):getContainerObjectsSize()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local merch = self.merchandise_vehicles[num]

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
function VehiclesVendorLogic:payTokensVehicles(pPlayer, selectedItem, num)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	local containerSize = SceneObject(pInventory):getContainerObjectsSize()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	
	local merch = self.merchandise_vehicles[selectedItem]
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