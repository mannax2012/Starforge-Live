VendorConvoHandler = conv_handler:new {
	--Vendor Setup
	vendorLogicType = VendorLogic,
	--Vendor Greeting
	initialDialog = "Test initial",
	--Player selection to start buying, vendor spatial.
	buyWindow = "Show me what segments you have for sale.",
	openSUItext = "",
	saleOption = "Test Sale Option",
	saleDialog = "Test Sale Dialog",
	saleOption_as = "Test Sale Dialog2",
	--Player selection to get vendor information, vendor dialog.
	informationFirstOption = "",
	informationFirstDialog = "",
	--Player selection to get more vendor information, vendor dialog.
	informationSecondOption = "",
	informationSecondDialog = "",
	--Set faction restriction (FACTIONIMPERIAL or FACTIONREBEL)
	factionRestriction = "",

}

function VendorConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	
	if (self.factionRestriction ~= "") then
		if (self.factionRestriction == FACTIONIMPERIAL and not CreatureObject(pPlayer):getFaction() == FACTIONIMPERIAL) or 
		(self.factionRestriction == FACTIONREBEL and not CreatureObject(pPlayer):getFaction() == FACTIONREBEL) or
		(CreatureObject(pPlayer):getFactionStanding(self.factionRestriction) < 200) then
			return convoTemplate:getScreen("factionRestriction")
		end
	end
	
	return convoTemplate:getInitialScreen()
end


function VendorConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pConvScreen = screen:cloneScreen()
	local clonedScreen = LuaConversationScreen(pConvScreen)
	
	if (screenID == "initial") then
		clonedScreen:setCustomDialogText(self.initialDialog)
		clonedScreen:addOption(self.buyWindow, "buy_window")
		if (self.informationFirstOption ~= "") then
			clonedScreen:addOption(self.informationFirstOption, "information_first")
		end
		if (self.informationSecondOption ~= "") then
			clonedScreen:addOption(self.informationSecondOption, "information_second")
		end
	end
	if (screenID == "buy_window") then
		clonedScreen:setCustomDialogText(self.saleDialog)
		clonedScreen:addOption(self.buyArmor, "buy_armor")
		clonedScreen:addOption(self.buyWeapons, "buy_weapons")
		clonedScreen:addOption(self.buyBackpacks, "buy_backpacks")
		clonedScreen:addOption(self.buyVehicles, "buy_vehicles")
	end

	if (screenID == "buy_armor") then
		clonedScreen:setCustomDialogText(self.buyArmorDialog)
		--clonedScreen:addOption(self.saleOption_buy_armor_aw, "buy_armor_aw")
		clonedScreen:addOption(self.saleOption_buy_armor_as, "buy_armor_as")
	end

	if (screenID == "buy_armor_aw") then
		clonedScreen:setCustomDialogText(self.buyArmorAWDialog)
		clonedScreen:addOption(self.saleOption_segment_aw, "start_sale_segment_aw")
		clonedScreen:addOption(self.saleOption_schematic_aw, "start_sale_schematic_aw")
	end

	if (screenID == "buy_armor_as") then
		clonedScreen:setCustomDialogText(self.buyArmorASDialog)
		--clonedScreen:addOption(self.saleOption_segment_as, "start_sale_segment_as")
		clonedScreen:addOption(self.saleOption_schematic_as, "start_sale_schematic_as")
	end

	if (screenID == "start_sale_segment_aw") then
		clonedScreen:setCustomDialogText(self.openSUItext)
		self.vendorLogicType:openSUIArmorweaveSegments(pPlayer)
	end

	if (screenID == "start_sale_schematic_aw") then
		clonedScreen:setCustomDialogText(self.underConstruction)
		--self.vendorLogicType:openSUIArmorweaveSchematics(pPlayer)
	end

	if (screenID == "start_sale_segment_as") then
		clonedScreen:setCustomDialogText(self.openSUItext)
		self.vendorLogicType:openSUIArmorsmithSegments(pPlayer)
	end

	if (screenID == "start_sale_schematic_as") then
		clonedScreen:setCustomDialogText(self.openSUItext)
		self.vendorLogicType:openSUIArmorSchematics(pPlayer)
	end

	if (screenID == "buy_weapons") then
		clonedScreen:setCustomDialogText(self.weaponsMenu)
		clonedScreen:addOption(self.saleOption_weapon_lightsaber, "buy_lightsaber")
	end

	if (screenID == "buy_lightsaber") then
		clonedScreen:setCustomDialogText(self.buyLightSaber)
		clonedScreen:addOption(self.saleOption_weapon_lightsaber_gen3, "buy_lightsaber_gen3")
		clonedScreen:addOption(self.saleOption_weapon_lightsaber_gen4, "buy_lightsaber_gen4")
		--self.vendorLogicType:openSUIArmorweaveSchematics(pPlayer)
	end

	if (screenID == "buy_lightsaber_gen3") then
		clonedScreen:setCustomDialogText(self.openSUItext)
		self.weaponsSabersLogic:openSUILightsaberGenThree(pPlayer)
	end

	if (screenID == "buy_lightsaber_gen4") then
		clonedScreen:setCustomDialogText(self.openSUItext)
		self.weaponsSabersLogic:openSUILightsaberGenFour(pPlayer)
	end

	if (screenID == "buy_vehicles") then
		clonedScreen:setCustomDialogText(self.openSUItext)
		self.vehiclesLogic:openSUIVehicles(pPlayer)
	end

	if (screenID == "buy_backpacks") then
		clonedScreen:setCustomDialogText(self.openSUItext)
		self.backpacksLogic:openSUIBackpacks(pPlayer)
	end

	if (screenID == "information_first") then
		clonedScreen:setCustomDialogText(self.informationFirstDialog)
		clonedScreen:addOption(self.buyWindow, "buy_window")
		if (self.informationSecondOption ~= "") then
			clonedScreen:addOption(self.informationSecondOption, "information_second")
		end
	end
	
	if (screenID == "information_second") then
		clonedScreen:setCustomDialogText(self.informationSecondDialog)
		clonedScreen:addOption(self.buyWindow, "buy_window")
		if (self.informationFirstOption ~= "") then
			clonedScreen:addOption(self.informationFirstOption, "information_first")
		end
	end
	return pConvScreen
end

StarforgeVendorConvoHandler = VendorConvoHandler:new {
	--Vendor Setup
	vendorLogicType = StarforgeVendorLogic,
	weaponsSabersLogic = WeaponsLightsaberVendorLogic,
	backpacksLogic = BackpacksVendorLogic,
	vehiclesLogic = VehiclesVendorLogic,
	--Vendor Greeting
	initialDialog = "Ya-hoo, name is Busten Cyder, I travel da world sellen items per Starforge Currency. Do you want to be buyin something?",
	--Player selection to start buying, vendor spatial.
	buyWindow = "Show me what you have for sale.",
	buyArmorDialog = "I have a few thing available for armor, take a look.",
	buyArmor = "I am interested in improving my armor.",
	buyWeapons = "I am interested in improving my weapons.",
	buyBackpacks = "I am interested in improving my backpack look.",
	buyVehicles = "I am interested in improving my ride.",
	buyArmorAWDialog = "This is what I have available for Armorweaving.",
	buyArmorASDialog = "This is what I have available for Armorsmithing.",
	saleOption_buy_armor_as = "I am interested in Armorsmithing Schematics",
	saleOption_buy_armor_aw =  "I am interested in Armorweaving Schematics",
    saleOption_segment_aw = "Armorweaving Segment Schematics",
	saleOption_schematic_aw = "Armorweaving Clothing Schematics",
	saleOption_segment_as = "Armorsmithing Segment Schematics",
	saleOption_weapon_lightsaber = "Lightsabers",
	saleOption_weapon_lightsaber_gen3 = "Show me what you have for Generation Three Lightsabers.",
	saleOption_weapon_lightsaber_gen4 = "Show me what you have for Generation Four Lightsabers.",
	saleOption_schematic_as = "Armorsmithing Schematics",
	openSUItext = "Take your time and stay close.",
	saleDialog = "Okay, here's what I have for sale.",
	--Player selection to get vendor information, vendor dialog.
	informationFirstOption = "What sort of items do you sell?",
	informationFirstDialog = "Lots of stuff, make sure to come back every now and again as I get updated stock with new items.",
	--Player selection to get vendor more information, vendor dialog.
	informationSecondOption = "How do I get Starforge tokens?",
    informationSecondDialog = "Participaten in kill'n things on Starforge. When you get some tokens, make sure to use them right away to store the currency. Then come back to me and trade your currency for items.",
	underConstruction = "This shop is under construction. Check back after a few weeks...",
	weaponsMenu = "I have a few different types of weapons...",
	buyLightSaber = "Lightsabers come in different generations, which are you certified to use?"

}