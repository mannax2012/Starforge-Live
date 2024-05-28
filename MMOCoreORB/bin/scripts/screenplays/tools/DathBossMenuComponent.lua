local ObjectManager = require("managers.object.object_manager")

DathBossMenuComponent = {
    cooldownDuration = 30,  -- Cooldown duration in seconds (e.g., 5 minutes)
    playerCooldowns = {},  -- Table to track the last interaction time for each player
}

function DathBossMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
    if pSceneObject == nil or pMenuResponse == nil or pPlayer == nil then
        return
    end

    local menuResponse = LuaObjectMenuResponse(pMenuResponse)
    menuResponse:addRadialMenuItem(20, 3, "Activate Alter")
end

function DathBossMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
    if pPlayer == nil or pSceneObject == nil then
        return 0
    end

    if selectedID == 20 then
        if readData("dathBossSpawned") == 2 then
            CreatureObject(pPlayer):sendSystemMessage("The Alter seems to need more time before it can be used again.")
            return 0
        end

        local playerID = SceneObject(pPlayer):getObjectID()
        local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")
        if pInventory ~= nil then
            local pSupplies = getContainerObjectByTemplate(pInventory, "object/tangible/item/dath_disciple_skull.iff", false)
    
            if pSupplies ~= nil then

                if readData("dathBossSpawned") ~= 1 then
                    CreatureObject(pPlayer):sendSystemMessage("You place the skull totem on the altar... Something doesn't feel right...")
                    writeData("dathBossSpawned", 1)

                    -- Spawn the boss
                    dath_discipleScreenplay:spawnBoss(pPlayer)
                    -- Destroy the skull totem from the player's inventory
                    SceneObject(pSupplies):destroyObjectFromWorld(true)
                    SceneObject(pSupplies):destroyObjectFromDatabase(true)

                else
                    CreatureObject(pPlayer):sendSystemMessage("The altar is already occupied by a powerful presence.")
                end
            else
                CreatureObject(pPlayer):sendSystemMessage("You must offer tribute at the altar. Nothing happens.")
            end
        end
    end
    return 0
end