function SCR_SSN_KLAPEDA_KillMonster_PARTY(self, party_pc, sObj, msg, argObj, argStr, argNum)
    if SHARE_QUEST_PROP(self, party_pc) == true then
        if GetLayer(self) ~= 0 then
            if GetLayer(self) == GetLayer(party_pc) then
                SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
            end
        else
            SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
        end
    end
    
---- ALPHABET_EVENT
--    if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
--        SCR_ALPHABET_EVENT(self, sObj, msg, argObj, argStr, argNum, "YES")
--    end
end

function SCR_SSN_KLAPEDA_KillMonster(self, sObj, msg, argObj, argStr, argNum)
	PC_WIKI_KILLMON(self, argObj, true);
	CHECK_SUPER_DROP(self);
	SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
---- ALPHABET_EVENT
--	SCR_ALPHABET_EVENT(self, sObj, msg, argObj, argStr, argNum)
    SCR_STEAM_OBSERVER_EVENT(self, sObj, msg, argObj, argStr, argNum)
end