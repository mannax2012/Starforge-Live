local ObjectManager = require("managers.object.object_manager")

StarforgeVendorScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "StarforgeVendorScreenPlay",
    planet = "tatooine",

}

registerScreenPlay("StarforgeVendorScreenPlay", true)

function StarforgeVendorScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
		--self:spawnSceneObjects()
	end
end

function StarforgeVendorScreenPlay:spawnSceneObjects()
	--spawnSceneObject(self.planet, "object/tangible/jedi/force_shrine_stone.iff", 7223.6, 68.7, 2340.7, 0, math.rad(89))
end

function StarforgeVendorScreenPlay:spawnMobiles()

        --Eisley Vendor
        pMobile = spawnMobile(self.planet, "starforge_vendor", 600,3517.8,5.0,-4799.1,161,0)
        AiAgent(pMobile):addObjectFlag(AI_STATIC)

end

