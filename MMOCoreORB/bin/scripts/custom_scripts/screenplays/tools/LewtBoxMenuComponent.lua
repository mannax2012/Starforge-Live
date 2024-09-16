local ObjectManager = require("managers.object.object_manager")

LewtBoxMenuComponent = {
    cooldownDuration = 30,  -- Cooldown duration in seconds (e.g., 5 minutes)
    playerCooldowns = {},  -- Table to track the last interaction time for each player
}

function LewtBoxMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
    if pSceneObject == nil or pMenuResponse == nil or pPlayer == nil then
        return
    end

    local menuResponse = LuaObjectMenuResponse(pMenuResponse)
    menuResponse:addRadialMenuItem(220, 3, "Open Box")
end

function LewtBoxMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
    if pPlayer == nil or pSceneObject == nil then
        return 0
    end

    if selectedID == 220 then
        local displayedName = SceneObject(pSceneObject):getDisplayedName()
        if displayedName == nil then
            return 0
        end

    local inventory = SceneObject(pPlayer):getSlottedObject("inventory")
    local LewtChest = getContainerObjectByTemplate(inventory, "object/tangible/loot/lewt_chests/lewt_chest.iff", false)
    
    if (inventory ~= nil) then

        if displayedName == nil then
            return nil
        end
    
        if displayedName == "Small Lewt Chest" then
            createLoot(inventory, "lewt_chest_common", 350, true)
            createLoot(inventory, "lewt_chest_rare", 400, true)
        elseif displayedName == "Medium Lewt Chest" then
            createLoot(inventory, "lewt_chest_common", 350, true)
            createLoot(inventory, "lewt_chest_rare", 400, true)
            createLoot(inventory, "lewt_chest_rare", 400, true)
        elseif displayedName == "Large Lewt Chest" then
            createLoot(inventory, "lewt_chest_common", 350, true)
            createLoot(inventory, "lewt_chest_rare", 400, true)
            createLoot(inventory, "lewt_chest_rare", 400, true)
            createLoot(inventory, "lewt_chest_rare", 400, true)
        else
            createLoot(inventory, "lewt_chest_common", 350, true)
        end

        CreatureObject(pPlayer):sendSystemMessage("Lewt Chest Opened.")
        CreatureObject(pPlayer):playEffect("clienteffect/medic_heal.cef", "")
        SceneObject(LewtChest):destroyObjectFromWorld(true)
        SceneObject(LewtChest):destroyObjectFromDatabase(true)
	end
end
end