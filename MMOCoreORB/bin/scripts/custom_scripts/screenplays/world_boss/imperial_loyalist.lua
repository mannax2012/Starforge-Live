imperialLoyalistScreenplay = ScreenPlay:new {
	numberOfActs = 1,
  	planet = "rori",
}
registerScreenPlay("imperialLoyalistScreenplay", true)

function imperialLoyalistScreenplay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
		print("Imperial Loyalist Loaded")
	end
end


function imperialLoyalistScreenplay:spawnMobiles()
		local pBoss = spawnMobile(self.planet, "imperial_loyalist", -1, 37.2, 22.9, 19.7, 165, 1189182)
		local creature = CreatureObject(pBoss)
		print("Imperial Loyalist Spawned")
		createObserver(DAMAGERECEIVED, "imperialLoyalistScreenplay", "npcDamageObserver", pBoss)    
		createObserver(OBJECTDESTRUCTION, "imperialLoyalistScreenplay", "bossDead", pBoss)
end

function imperialLoyalistScreenplay:npcDamageObserver(bossObject, playerObject, damage)

	local player = LuaCreatureObject(playerObject)
	local boss = LuaCreatureObject(bossObject)

	health = boss:getHAM(0)
	action = boss:getHAM(3)
	mind = boss:getHAM(6)

	maxHealth = boss:getMaxHAM(0)
	maxAction = boss:getMaxHAM(3)
	maxMind = boss:getMaxHAM(6)

	if (((health <= (maxHealth * 0.9))) and readData("imperialLoyalistScreenplay:spawnState") == 0) then
      			writeData("imperialLoyalistScreenplay:spawnState",1)
			createEvent(0 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
 			createEvent(5 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
			createEvent(10 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
			createEvent(15 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
			createEvent(20 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")       
      			CreatureObject(bossObject):playEffect("clienteffect/attacker_berserk.cef", "")
	end

	if (((health <= (maxHealth * 0.7))) and readData("imperialLoyalistScreenplay:spawnState") == 1) then
      			writeData("imperialLoyalistScreenplay:spawnState",2)
			createEvent(0 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
 			createEvent(5 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
			createEvent(10 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
			createEvent(15 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
			createEvent(20 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")        
			self:spawnSupport(playerObject)
      			CreatureObject(playerObject):sendSystemMessage("You hear footsteps approaching!")
      			CreatureObject(bossObject):playEffect("clienteffect/attacker_berserk.cef", "")
	end

	if (((health <= (maxHealth * 0.5))) and readData("imperialLoyalistScreenplay:spawnState") == 2) then
      			writeData("imperialLoyalistScreenplay:spawnState",3)
			createEvent(0 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
 			createEvent(5 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
			createEvent(10 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
			createEvent(15 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
			createEvent(20 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")     
			self:spawnSupport(playerObject)
      			CreatureObject(playerObject):sendSystemMessage("You hear more footsteps approaching!")
      			CreatureObject(bossObject):playEffect("clienteffect/attacker_berserk.cef", "")
	end

	if (((health <= (maxHealth * 0.3))) and readData("imperialLoyalistScreenplay:spawnState") == 3) then
      			writeData("imperialLoyalistScreenplay:spawnState",4)
			createEvent(0 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
 			createEvent(5 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
			createEvent(10 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
			createEvent(15 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")
			createEvent(20 * 1000, "imperialLoyalistScreenplay", "poisonbomb", playerObject, "")      
			self:spawnSupport(playerObject)
      			CreatureObject(playerObject):sendSystemMessage("More footsteps echo in the tunnels")
      			CreatureObject(bossObject):playEffect("clienteffect/attacker_berserk.cef", "")
	end

	if (((health <= (maxHealth * 0.1))) and readData("imperialLoyalistScreenplay:spawnState") == 4) then
      			writeData("imperialLoyalistScreenplay:spawnState",5)
			createEvent(0 * 1000, "imperialLoyalistScreenplay", "bossFinisher", playerObject, "")  
				CreatureObject(playerObject):sendSystemMessage("The Imperial Loyalist throws a thermal detenator. Big Boom...")			
      			CreatureObject(bossObject):playEffect("clienteffect/attacker_berserk.cef", "")
		end
	return 0

end

function imperialLoyalistScreenplay:poisonBomb(playerObject)
if (CreatureObject(playerObject):isGrouped()) then
	local groupSize = CreatureObject(playerObject):getGroupSize()
	for i = 0, groupSize - 1, 1 do
		local pMember = CreatureObject(playerObject):getGroupMember(i)
		if pMember ~= nil and SceneObject(pMember):isInRangeWithObject(playerObject, 200) then
		local trapDmg = getRandomNumber(400, 500)
		CreatureObject(pMember):inflictDamage(pMember, 0, trapDmg, 1)
      		CreatureObject(pMember):playEffect("clienteffect/e3_explode_lair_large.cef", "")
		end
	end
else
	local trapDmg = getRandomNumber(400, 500)
	CreatureObject(playerObject):inflictDamage(playerObject, 0, trapDmg, 1)
      	CreatureObject(playerObject):playEffect("clienteffect/e3_explode_lair_large.cef", "")
	end
end

function imperialLoyalistScreenplay:bossFinisher(playerObject)
if (CreatureObject(playerObject):isGrouped()) then
	local groupSize = CreatureObject(playerObject):getGroupSize()
	for i = 0, groupSize - 1, 1 do
		local pMember = CreatureObject(playerObject):getGroupMember(i)
		if pMember ~= nil and SceneObject(pMember):isInRangeWithObject(playerObject, 200) then
		local trapDmg = getRandomNumber(2800, 4200)
		CreatureObject(pMember):inflictDamage(pMember, 0, trapDmg, 1)
      		CreatureObject(pMember):playEffect("clienteffect/e3_explode_lair_large.cef", "")
		end
	end
else
	local trapDmg = getRandomNumber(2800, 4200)
	CreatureObject(playerObject):inflictDamage(playerObject, 0, trapDmg, 1)
      	CreatureObject(playerObject):playEffect("clienteffect/e3_explode_lair_large.cef", "")
	end
end

function imperialLoyalistScreenplay:spawnSupport(playerObject)
	local pGuard1 = spawnMobile(self.planet, "tusken_king_guard", -1, 43.3, 21.6, 6.6, -40, 1189182) 
	CreatureObject(pGuard1):engageCombat(playerObject)
      	CreatureObject(pGuard1):playEffect("clienteffect/ui_missile_aquiring.cef", "")
	local pGuard2 = spawnMobile(self.planet, "tusken_king_guard", -1, 36.2, 21.7, 4.0, 12, 1189182) 
	CreatureObject(pGuard2):engageCombat(playerObject)
	local pGuard3 = spawnMobile(self.planet, "tusken_king_guard", -1, 35.5, 22.4, 9.2, 12, 1189182) 
	CreatureObject(pGuard3):engageCombat(playerObject)

end  

function imperialLoyalistScreenplay:bossDead(pBoss)
	print("Imperial Loyalist has been killed.")
	local creature = CreatureObject(pBoss)
	local respawn = math.random(7200,10800)
	createEvent(120 * 1000, "imperialLoyalistScreenplay", "KillBoss", pBoss, "") -- Corpse Despawn
	createEvent(respawn * 1000, "imperialLoyalistScreenplay", "KillSpawn", pBoss, "") -- Respawn
	return 0
end

function imperialLoyalistScreenplay:KillSpawn()
		local pBoss = spawnMobile(self.planet, "imperial_loyalist", -1, 37.2, 22.9, 19.7, 165, 1189182)
		print("Imperial Loyalist Respawned")
		createObserver(DAMAGERECEIVED, "imperialLoyalistScreenplay", "npcDamageObserver", pBoss)
		createObserver(OBJECTDESTRUCTION, "imperialLoyalistScreenplay", "bossDead", pBoss)
end

function imperialLoyalistScreenplay:KillBoss(pBoss)
      	writeData("imperialLoyalistScreenplay:spawnState",0)  
	dropObserver(pBoss, OBJECTDESTRUCTION)
	if SceneObject(pBoss) then
		SceneObject(pBoss):destroyObjectFromWorld()
	end
	return 0
end