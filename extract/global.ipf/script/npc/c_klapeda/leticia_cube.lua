function SCR_LETICIA_CUBE_DIALOG(self, pc)
	local select = ShowSelDlg(pc, 0, CLMSG_DIALOG_CONVERT(self,ScpArgMsg("GLOBAL_LETICIA_GACHA1")),
								ScpArgMsg("BuyCube"), ScpArgMsg("GetBonusReward"), ScpArgMsg("Cancel"))
	if select == 1 then
		SetExArgObject(pc, "CUBE_OBJET", self)
		ExecClientScp(pc, 'LETICIA_CUBE_OPEN()');
	elseif select == 2 then
		SCR_GACHA_BOUNS_DIALOG(self, pc)
	end
end

function SCR_LETICIA_CUBE_AI_BORN(self)
	local nowtime = SCR_PRECHECK_LETICIA_Time()
	if nowtime == "YES" then
		if IS_SEASON_SERVER() == "YES" then
			return
		end
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
	local nowtime = SCR_PRECHECK_LETICIA_Time()
	if creMon ~= nil then
		if IS_SEASON_SERVER() == "YES" then
			Kill(creMon)
		elseif nowtime == "YES" then
			return
		elseif nowtime == "NO" then
			Kill(creMon)
		end
	else
		if nowtime == "YES" then
			if IS_SEASON_SERVER() == "YES" then
				return
			end
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