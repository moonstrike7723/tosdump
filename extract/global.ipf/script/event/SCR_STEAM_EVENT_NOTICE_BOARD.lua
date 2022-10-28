function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)
    local serverID = GetServerGroupID()
    local select = 0;

    if IsBuffApplied(pc, 'Event_Steam_Secret_Market') == 'YES' then
        RemoveBuff(pc, 'Event_Steam_Secret_Market')
    end

	local name = self.Name.."*@*"
	-- ShowOkDlg(pc, name..ScpArgMsg('EventNotExist'), 1);
	-- local select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL'
	-- , ScpArgMsg("EVENT_2006_SUMMER_SEL_MSG1_GLOBAL")
	-- , ScpArgMsg("Cancel"))
	-- if select == 1 then
	-- 	SCR_EVENT_2006_SUMMER_BOARD_DIALOG(self, pc)
	-- end
	local select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', 
	               ScpArgMsg("Event_STM_YOUR_MASTER_SEL"),
	               ScpArgMsg("Cancel")) 
   
    if select == 1 then
		SCR_EVENT_YOUR_MASTER_NPC_DIALOG(self,pc)
   end
end

function SCR_STEAM_2018_TREASURE_EVENT_DIALOG(self,pc) -- 국내 수확 이벤트 함수명 바꿔서 사용 --
      -- SCR_STEAM_TREASURE_EVENT_DIALOG -- 검색 로그 남김 --
    if pc.Lv < 50 then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1801_ORB_MSG8","LV",50), 10);
        return
    end
    local select = ShowSelDlg(pc,0, 'EV_DAILYBOX_SEL', ScpArgMsg("Get_RedSeed"), ScpArgMsg("Cancel"))

    if select == 1 then
        local aobj = GetAccountObj(pc);
        local now_time = os.date('*t')
        local yday = now_time['yday']
        local hour = now_time['hour']
        local min = now_time['min']
        
        if aobj.THANKSGIVINGDAY_DAY ~= yday then
            local tx = TxBegin(pc);
            TxSetIESProp(tx, aobj, 'THANKSGIVINGDAY_DAY', yday)
            TxGiveItem(tx, 'Event_Seed_ThanksgivingDay', 1, "EVENT_THANKSGIVINGDAY_DAY")
            
            if aobj.Event_HiddenReward ~= 2 then
                TxGiveItem(tx, 'NECK99_102_team', 1, "EVENT_THANKSGIVINGDAY_DAY")
                TxSetIESProp(tx, aobj, 'Event_HiddenReward', 2)
            end
            local ret = TxCommit(tx);
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg('EVENT_1705_CORSAIR_MSG4'),10)
        end
    end
end

function SCR_STEAM_TREASURE_EVENT_FEDIMIAN_DIALOG(self,pc)
    local select = ShowSelDlg(pc,0, 'EV_DAILYBOX_SEL', ScpArgMsg("Event_Fedimian_1"), ScpArgMsg("Cancel"))   
    if select == 1 then
        SCR_EVENT171018_FEDIMIAN_RAID_DIALOG(self,pc)
    end
end

-- function SCR_STEAM_TREASURE_EVENT_1902_WEEKEND_DIALOG(self, pc) -- 버전업 기년 특별 접속 보상 이벤트 해외 전용 보상용 NPC -- 
--     local aObj = GetAccountObj(pc);
--     local now_time = os.date('*t')
--     local month = now_time['month']
--     local year = now_time['year']
--     local day = now_time['day']
--     local wday = now_time['wday']
-- 	local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
--     local dayCheckReward = {
--         {14, 'Ability_Point_Stone_1000_14d_Team', 5},
--         {15, 'EVENT_190124_RankReset_Point_Lv2', 1},
--         {16, 'Moru_Gold_14d_Team', 2},
--         {17, 'Ability_Point_Stone_1000_14d_Team', 5},
--         {18, 'EVENT_190124_RankReset_Point_Lv2', 1}
--         --{4, 'Moru_Gold_14d_Team', 2},
--         --{10, 'Ability_Point_Stone_1000_14d_Team', 5},
--         --{11, 'EVENT_190124_RankReset_Point_Lv2', 1}
--     }
--     --print(day)

--     if pc.Lv < 50 then
--         SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1801_ORB_MSG8","LV",50), 10);
--         return
--     end
    
--     --if nowbasicyday <= SCR_DATE_TO_YDAY_BASIC_2000(2019, 8, 20) then
--         if (day >= 14 and day <= 18)  then
--             local select = ShowSelDlg(pc,0, 'STEAM_TREASURE_EVENT_1902_WEEKEND_NPC_DLG1', ScpArgMsg("Receieve"), ScpArgMsg("Cancel"))
--             --ShowOkDlg(pc, 'STEAM_TREASURE_EVENT_1902_WEEKEND_NPC_DLG1', 1)
--             if select == 1 then 
--                 if aObj.STEAM_TREASURE_EVENT_1902_WEEKEND ~= day then
--                     for i = 1, #dayCheckReward do
--                         local tx = TxBegin(pc);
--                         local result = i
--                         --print(result)
--                         if dayCheckReward[result][1] == day then
--                             for j = 2, #dayCheckReward[result], 2 do
--                                 --print(j)
--                                 --print(dayCheckReward[result][j]..'/'..dayCheckReward[result][j+1])
--                                 TxSetIESProp(tx, aObj, 'STEAM_TREASURE_EVENT_1902_WEEKEND', day)
--                                 TxGiveItem(tx, dayCheckReward[result][j], dayCheckReward[result][j+1], "STEAM_TREASURE_EVENT_1902_WEEKEND")
--                             end
--                         --else
--                             --SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_STEAM_1903_CHOCO_REWARD_SEL2"), 5);
--                         end
--                         local ret = TxCommit(tx);
--                         --print(aObj.STEAM_TREASURE_EVENT_1902_WEEKEND)
--                     end
--                 else
--                     SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("UNDER301_EVENT1_REWARD_TAKE"), 5); -- 이미 보상을 받았습니다. -- 
--                 end
--             end
--         else
--             SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_STEAM_1903_CHOCO_REWARD_SEL2"), 5);        
--         end
--     -- else
--     --     SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_STEAM_1903_CHOCO_REWARD_SEL2"), 5);
--     -- end
-- end

function SCR_STEAM_TREASURE_EVENT_1912_WEEKEND_DIALOG(self, pc) -- 버프 이벤트 npc -- 
	-- if GetServerGroupID() == 10001 or GetServerGroupID() == 10003 or GetServerGroupID() == 10004 or GetServerGroupID() == 10005 then
	-- 	SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("SeasonServerCannotUse"), 3);
	-- 	return;
	-- end
    -- local aObj = GetAccountObj(pc);
    -- local now_time = os.date('*t')
    -- local month = now_time['month']
    -- local year = now_time['year']
    -- local day = now_time['day']
    -- local wday = now_time['wday']
    -- local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
	-- local weekday = now_time['wday']
	
    -- local buffList = {{'모루 강화 비용 50% 할인','Event_Reinforce_Discount_50'}
    --                  ,{'루팅 찬스 1,000 증가','Event_LootingChance_Add_1000'}
	-- 				 ,{'아이템 옵션 재감정 비용 50% 할인','Event_Reappraisal_Discount_50'}
	-- 				 ,{'시약병 경험치 증가량 2배','Event_Reagent_Bottle_Expup_100'}
	-- 				 ,{'클래스 변경 포인트 지급량 500% 증가','Event_Class_Change_Pointup_500'}
	-- 				 ,{'짝수 단계 초월 비용 50% 할인','Event_Even_Transcend_Discount_50'}
	-- 				 ,{'경험치 100% 증가','Event_Expup_100'}
	-- 				 ,{'젬 강화에 젬 사용 시, 경험치 페널티 면제','Event_Penalty_Clear_Gem_Reinforce'}
	-- 				 ,{'유니크 레이드 입장 아이템 소모량 고정 + 유니크 레이드 보상 2배 지급','Event_Unique_Raid_Bonus'}
	-- 				 ,{'10초마다 HP 및 SP+500 회복, 이동 속도 +2','Event_healHSP_Speedup'}
	-- 				 ,{'레전드레이드/업힐 디펜스 팀당 1회 초기화','Event_Legend_Uphill_Count_Reset'}
	-- 				 ,{'탁본 1위 동상 경배 효과 10배 증가','Event_Worship_Affect_10fold'}
	-- 				 }
    
    -- local daycheckbuff = 
	-- {{'3','6',{'Event_Class_Change_Pointup_500'}}
	-- ,{'3','7',{'Event_Legend_Uphill_Count_Reset'}}
	-- ,{'3','8',{'Event_Reinforce_Discount_50'}}
	-- ,{'3','13',{'Event_Reappraisal_Discount_50'}}
	-- ,{'3','14',{'Event_healHSP_Speedup','Event_LootingChance_Add_1000'}}
	-- ,{'3','15',{'Event_Even_Transcend_Discount_50'}}
	-- ,{'3','20',{'Event_Worship_Affect_10fold'}}
	-- ,{'3','21',{'Event_Legend_Uphill_Count_Reset'}}
	-- ,{'3','22',{'Event_Reinforce_Discount_50'}}
	-- ,{'3','27',{'Event_Reappraisal_Discount_50'}}
	-- ,{'3','28',{'Event_healHSP_Speedup','Event_LootingChance_Add_1000'}}
	-- ,{'3','29',{'Event_Even_Transcend_Discount_50'}}
	-- 	}
		
	-- -- if pc.Lv < 50 then
    -- --    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1801_ORB_MSG8","LV",50), 10);
    -- --    return
    -- -- end
	-- if weekday > 1 and weekday < 6 then --월~목
	-- 	SendSysMsg(pc,"EVENT_STEAM_1912_FORTUNE"); --보상은 금,토,일에만 지급됩니다.
	-- 	return;
	-- end
	
    -- local select = ShowSelDlg(pc, 0, 'FLASHMOB_EVENT_REWARD_SUCCESS', ScpArgMsg("Receieve"), ScpArgMsg("Cancel"))
    -- --sysTime.wDayOfWeek

    -- if select == 1 then 
	-- 	local buffcount = 0;
	-- 	PlaySound(pc, "item_drop_hp_1");
	-- 	PlayEffect(pc, 'F_sys_expcard_normal', 2.5, 1, "BOT", 1);
	-- 	AddBuff(pc, pc, buffList[7][2], 1, 0, 3600*6*1000, 1); --경험치 100% 증가
	-- 	buffcount= buffcount+1;

	-- 		-- if weekday == 7 then --토요일
	-- 		-- 	AddBuff(pc, pc, buffList[9][2], 1, 0, 3600*6*1000, 1); --유니크 레이드 보상 2배
	-- 		-- 	buffcount= buffcount+1;
	-- 		-- end
	-- 		-- if weekday == 1 then --일요일
	-- 		-- 	AddBuff(pc, pc, buffList[2][2], 1, 0, 3600*6*1000, 1); --루팅찬스
	-- 		-- 	buffcount= buffcount+1;
	-- 		-- end
			
	-- 		for i = 1, #daycheckbuff do
	-- 			if (tostring(month) == daycheckbuff[i][1]) and (tostring(day) == daycheckbuff[i][2])then
	-- 				for j = 1,#daycheckbuff[i][3] do
	-- 					AddBuff(pc, pc, daycheckbuff[i][3][j], 1, 0, 3600*6*1000, 1);
	-- 					buffcount= buffcount+1;
	-- 				end
	-- 			end
	-- 		end
			
	-- 		if aObj.STEAM_TREASURE_EVENT_1902_WEEKEND ~= day then --보상 지급
	-- 		    local tx = TxBegin(pc);
	-- 			TxGiveItem(tx, 'EVENT_1712_SECOND_CHALLENG_14d_Team', 5, 'STEAM_TREASURE_EVENT_1912_WEEKEND'); 
	-- 			TxGiveItem(tx, 'Event_190110_ChallengeModeReset_14d', 5, 'STEAM_TREASURE_EVENT_1912_WEEKEND'); 
	-- 			TxGiveItem(tx, 'Adventure_Reward_Seed_14d_Team', 10, 'STEAM_TREASURE_EVENT_1912_WEEKEND'); 
	-- 			TxGiveItem(tx, 'Event_Goddess_Statue', 5, 'STEAM_TREASURE_EVENT_1912_WEEKEND'); 
	-- 			TxSetIESProp(tx, aObj, 'STEAM_TREASURE_EVENT_1902_WEEKEND', day);
	-- 			local ret = TxCommit(tx);
	-- 		end
		
	-- 		SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("GM_BUFF_MSG1","BUFF",buffcount), 5);
	-- end

	
end