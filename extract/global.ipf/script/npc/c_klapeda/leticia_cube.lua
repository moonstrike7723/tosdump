function SCR_LETICIA_CUBE_AI_BORN(self)
	--회차보상때문에 npc는 항상 띄워두도록 수정. 여큡/레티샤 모두 진행하지 않을때는 NO로 바꿔주어야함
	local nowtime = "NO"
	if nowtime == "YES" then
		local zoneInstID = GetZoneInstID(self);
		local x, y, z = GetPos(self)
		if IsValidPos(zoneInstID, x, y, z) == 'YES' then
			local mon = CREATE_NPC(self, 'gacha_cube1', x, y, z, 0, 'Neutral', 0, ScpArgMsg("Leticia_Cube"), 'LETICIA_CUBE')
			if mon ~= nil then
				SetTacticsArgObject(self, mon)
				EnableAIOutOfPC(mon)
			end
		end
	end
 end
 
 
 function SCR_LETICIA_CUBE_AI_UPDATE(self)
	local creMon = GetTacticsArgObject(self)
	--회차보상때문에 npc는 항상 띄워두도록 수정. 여큡/레티샤 모두 진행하지 않을때는 NO로 바꿔주어야함
	local nowtime = "NO"
	if creMon ~= nil then
		if nowtime == "YES" then
			return
		elseif nowtime == "NO" then
			Kill(creMon)
		end
	else
		if nowtime == "YES" then
			local zoneInstID = GetZoneInstID(self);
			local x, y, z = GetPos(self)
			if IsValidPos(zoneInstID, x, y, z) == 'YES' then
				local mon = CREATE_NPC(self, 'gacha_cube1', x, y, z, 0, 'Neutral', 0, ScpArgMsg("Leticia_Cube"), 'LETICIA_CUBE')
				if mon ~= nil then
					SetTacticsArgObject(self, mon)
					EnableAIOutOfPC(mon)
				end
			end
		end
	end
 end
 
 function SCR_LETICIA_CUBE_AI_AI_LEAVE(self)
 end