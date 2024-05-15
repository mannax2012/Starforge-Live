local ObjectManager = require("managers.object.object_manager")

VendorTokenMenuComponent = {}

function VendorTokenMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
    if pSceneObject == nil or pMenuResponse == nil or pPlayer == nil then
        return
    end

    local menuResponse = LuaObjectMenuResponse(pMenuResponse)
    menuResponse:addRadialMenuItem(20, 3, "Use Token")
end

function VendorTokenMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
    if pPlayer == nil or pSceneObject == nil then
        return 0
    end

    if selectedID == 20 then
        local displayedName = SceneObject(pSceneObject):getDisplayedName()
        if displayedName == nil then
            return 0
        end

        local xpAmount = self:determineXPAward(displayedName)

        if xpAmount == nil then
            return 0
        end

        CreatureObject(pPlayer):sendSystemMessage("The Token disolves in your hand, giving you: " .. tostring(xpAmount) .. " Starforge Currency.")
        CreatureObject(pPlayer):awardExperience("starforge_currency", xpAmount, true)
        CreatureObject(pPlayer):playEffect("clienteffect/medic_heal.cef", "")

        SceneObject(pSceneObject):destroyObjectFromWorld(true)
        SceneObject(pSceneObject):destroyObjectFromDatabase(true)
    end

    return 0
end

function VendorTokenMenuComponent:determineXPAward(displayedName)
    if displayedName == nil then
        return nil
    end

    local multiplier = 2  -- Adding 1 to start the multiplier from 1 instead of 0

    if displayedName == "Starforge Token" then
        return math.random(100, 350) * multiplier
	elseif displayedName == "Starforge Token (Exceptional)" then
        return math.random(100, 350) * multiplier * 2
	elseif displayedName == "Starforge Token (Legendary)" then
        return math.random(100, 350) * multiplier * 3
	elseif displayedName == "Heavy Starforge Token" then
        return math.random(500, 1000) * multiplier	
	elseif displayedName == "Heavy Starforge Token (Exceptional)" then
        return math.random(500, 1000) * multiplier * 2
	elseif displayedName == "Heavy Starforge Token (Legendary)" then
        return math.random(500, 1000) * multiplier * 3
    else
        return 1 * multiplier
    end
end
