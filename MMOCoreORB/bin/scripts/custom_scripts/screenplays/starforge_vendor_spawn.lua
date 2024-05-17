local ObjectManager = require("managers.object.object_manager")

StarforgeVendorScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "StarforgeVendorScreenPlay",
    tatooine = "tatooine",
	naboo = "naboo",

}

registerScreenPlay("StarforgeVendorScreenPlay", true)

function StarforgeVendorScreenPlay:start()
	if (isZoneEnabled(self.tatooine)) then
		self:spawnMobilesTat()
	end

	if (isZoneEnabled(self.naboo)) then
		self:spawnMobilesNaboo()
	end
end

function StarforgeVendorScreenPlay:spawnSceneObjects()
	--spawnSceneObject(self.planet, "object/tangible/jedi/force_shrine_stone.iff", 7223.6, 68.7, 2340.7, 0, math.rad(89))
end

function StarforgeVendorScreenPlay:spawnMobilesTat()
    --Eisley Vendor
    pMobile = spawnMobile(self.tatooine, "starforge_vendor", 600, 3517.8,5.0,-4799.1,161,0)
    AiAgent(pMobile):addObjectFlag(AI_STATIC)
end

function StarforgeVendorScreenPlay:spawnMobilesNaboo()
	--Theed Vendor
	pMobile = spawnMobile(self.naboo, "starforge_vendor", 600, -4911.1, 6.0, 4094.1, 82,0)
	AiAgent(pMobile):addObjectFlag(AI_STATIC)
end

