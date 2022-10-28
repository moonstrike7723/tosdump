
function SCR_PRE_161215EVENT_SEED(pc)
    if GetZoneName(pc) == "c_request_1" then
        SendAddOnMsg(pc, 'NOTICE_Dm_scroll', ScpArgMsg('DO_NOT_USE_HERE'), 5)
        return 0 
    end

    --if GetServerNation() ~= 'KOR' then
    --    return 0
    --end
    if IsPVPServer(pc) == 1 then
        SysMsg(pc, "Instant", ScpArgMsg("EV161215_SEED_MSG1"));
        return 0
    end
    
    if IsJoinColonyWarMap(pc) == 1 then
        SendAddOnMsg(pc, 'NOTICE_Dm_scroll', ScpArgMsg('COLLECT_FAIL_MSG1'), 3)
        return 0
    end
    
    local objList, objCnt = GetWorldObjectList(pc, "MON", 100)
    if objCnt > 0 then
        for i = 1, objCnt do
--            print('BBBBBBBBBBBBB',objList[i].ClassName)
            if objList[i].ClassName == 'Default_Sprout' then
                SysMsg(pc, "Instant", ScpArgMsg("EV161215_SEED_MSG2"));
                return 0
            end
        end
    end

    if GetZoneName(pc) == "guild_agit_1" or GetZoneName(pc) == "guild_agit_extension" then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("DontUseItemThisArea"), 5);
        return 0
    end

    local layer = GetLayer(pc)
    if layer > 0 then
        SysMsg(pc, "Instant", ScpArgMsg("EV161215_SEED_MSG3"));
        return 0
    end
    
    return 1
end

function SCR_USE_161215EVENT_SEED(pc,argObj,BuffName,arg1,arg2)
    -- if GetServerNation() ~= 'KOR' then
    --     return 0
    -- end
    local x,y,z = GetPos(pc)
    local npc = CREATE_MONSTER(pc, 'Default_Sprout', x, y, z, 0, 'Peaceful', 0, 1, '161215EVENT_SEED', ScpArgMsg("EV161215_SEED_MSG4"), nil, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1000)
--    local npc = CREATE_NPC(pc, 'Default_Sprout', x, y, z, 0, 'Peaceful', 0, ScpArgMsg("EV161215_SEED_MSG4"), nil, nil, nil, 1, nil, '161215EVENT_SEED', nil, nil, nil, nil, nil)
    if npc ~= nil then
        EnableAIOutOfPC(npc)
        npc.StrArg1 = GetPcCIDStr(pc)
        local nowSec = math.floor(os.clock())
        SetExArgObject(npc, 'EV161215_PC', pc)
        SetExProp(npc,'EV161215_NEXT_BUFF',nowSec + SCR_PRE_161215EVENT_SEED_NEXT_TIME())
        SetExProp(npc,'EV161215_STEP',1)
        SetLifeTime(npc, 330)
        AttachEffect(npc, 'F_light081_ground_orange_loop', 8, 'BOT', 0, 0, 0, 0)
		ChangeScale(npc, 2.5, 0, 1, 0, 0, 1)
		SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("EVENT_STEAM_SEED_MS01"), 3)
--        AttachEffect(npc, 'F_pattern013_ground_white', 1.9, 'BOT')
    end
end

function SCR_161215EVENT_SEED_TS_BORN_UPDATE(self)
    if IsPVPServer(self) == 1 then
        Kill(self)
    end
    local layer = GetLayer(self)
    if layer > 0 then
        Kill(self)
    end
    
    local mhp = self.MHP
    local nowhp = self.HP
    
    if mhp * 0.8 > nowhp then
        Heal(self, mhp, 0)
    end
    
    local step = GetExProp(self,'EV161215_STEP')
    local nextTime = GetExProp(self,'EV161215_NEXT_BUFF')
    local nowSec = math.floor(os.clock())
    local buffList = {'Event_161215_1','Event_161215_2','Event_161215_3','Event_161215_4','Event_161215_5'}
    
    if nextTime - 10 <= nowSec and nextTime - nowSec > 0 then
        local ownerOutSec = GetExProp(self,'EV161215_OWNER_OUT')
        if ownerOutSec < nowSec then
            local flag = 0
            local objList, objCnt = GetWorldObjectList(self, "PC", 40)
            local flag = 0
            if objCnt > 0 then
                for i = 1, objCnt do
                    if self.StrArg1 == GetPcCIDStr(objList[i]) then
                        flag = 1
                        break
                    end
                end
            end
            
            if flag == 0 then
                SetExProp(self,'EV161215_OWNER_OUT',nowSec)
                local owner = GetExArgObject(self, 'EV161215_PC')
                if owner ~= nil then
                    SendAddOnMsg(owner, "NOTICE_Dm_!", ScpArgMsg("EV161215_SEED_MSG5","SEC",nextTime - nowSec), 1);
                else
                    local objList2, objCnt2 = GetWorldObjectList(self, "PC", 300)
                    if objCnt2 > 0 then
                        for i = 1, objCnt2 do
                            if self.StrArg1 == GetPcCIDStr(objList2[i]) then
                                SetExArgObject(self, 'EV161215_PC', objList2[i])
                                SendAddOnMsg(objList2[i], "NOTICE_Dm_!", ScpArgMsg("EV161215_SEED_MSG5","SEC",nextTime - nowSec), 1);
                            end
                        end
                    end
                end
            end
        end
    end
    
    if step <= 5 and nextTime < nowSec then
--        print('AAA')
        SetExProp(self,'EV161215_NEXT_BUFF',nowSec + SCR_PRE_161215EVENT_SEED_NEXT_TIME())
        SetExProp(self,'EV161215_STEP',step+1)
        
        local objList, objCnt = GetWorldObjectList(self, "PC", 40)
        local flag = 0
        if objCnt > 0 then
            for i = 1, objCnt do
                if self.StrArg1 == GetPcCIDStr(objList[i]) then
                    flag = 1
                    break
                end
            end
            
            if flag == 1 then
                for i = 1, objCnt do
                    local flag2 = 0
                    if step < #buffList then
                        for index = step + 1, #buffList do
                            if IsBuffApplied(objList[i], buffList[index]) == 'YES' then
                                flag2 = 1
                                break
                            end
                        end
                    end
                    if flag2 == 0 then
                        if step > 1 then
                            for index = 1, step - 1 do
                                if IsBuffApplied(objList[i], buffList[index]) == 'YES' then
                                    RemoveBuff(objList[i], buffList[index])
                                end
                            end
                        end
                        AddBuff(objList[i], objList[i], buffList[step], 1, 0, 1800000, 1)
--        print('FFFF',step)
                        PlayEffect(objList[i], 'I_light013_spark_blue_2', 1,1,'TOP')
                        SendAddOnMsg(objList[i], "NOTICE_Dm_GetItem", ScpArgMsg("EV161215_SEED_MSG6","STEP",step), 10);
                    end
                    --RunScript("SCR_EVENT_STEAM_TS_CALL", objList[i]) --event closed
                end
            end
        end
        
        if step == 5 then
--        print('CCC')
            PlayEffect(self, 'F_circle020_light', 1,1,'BOT')
            PlayEffect(self, 'F_circle020_light', 1.5,1,'BOT')
            SetLifeTime(self, 1)
        end
    end
end
