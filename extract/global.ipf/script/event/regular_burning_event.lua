function REGULAR_BURNING_EVENT_TRIGGER_CHECK(self)
    local angle = {}
	local x, y, z = GetPos(self)
    local daytime = os.date("*t")
	local year, month, day, hour, minute, second, weekday = daytime['year'], daytime['month'], daytime['day'], daytime['hour'], daytime['min'], daytime['sec'], daytime['wday']
    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
	
    if month < 10 then
        month = "0"..tostring(month)
    end

    if day < 10 then
        day = "0"..tostring(day)
    end
    
    if hour < 10 then
        hour = "0"..tostring(hour)
    end

    if minute < 10 then
        minute = "0"..tostring(minute)
    end

    if second < 10 then
        second = "0"..tostring(second)
    end
	
    local npc = GetScpObjectList(self, "WEEKEND_REGULAR_EVENT")
    if #npc == 0 then
        if weekday == 1 or weekday == 6 or weekday == 7 then --일, 금, 토
            if tonumber(hour..minute..second) > 0 then
                local countResetNPC = CREATE_MONSTER_EX(self, 'NPC_GM2', x, y, z, GetDirectionByAngle(self), "Neutral", 1, WEEKEND_REGULAR_BURNING_EVENT_NPC_INFORMATION)
    			AddScpObjectList(self, "WEEKEND_REGULAR_EVENT", countResetNPC)
    		end
		end
	end
end

function REGULAR_BURNING_EVENT_SUPPORTER_AI(self)
	local x, y, z = GetPos(self)
    local daytime = os.date("*t")
    local year, month, day, hour, minute, second, weekday = daytime['year'], daytime['month'], daytime['day'], daytime['hour'], daytime['min'], daytime['sec'], daytime['wday'] 
    if month < 10 then
        month = "0"..tostring(month)
    end

    if day < 10 then
        day = "0"..tostring(day)
    end

	if GetServerGroupID() == 10001 or GetServerGroupID() == 10003 or GetServerGroupID() == 10004 or GetServerGroupID() == 10005 then
		Kill(self);
		return;
	end
	
     if weekday > 1 and weekday < 6 then --월~목
        Kill(self)
		return;
    end
	
end


function SCR_REGULAR_BURNING_EVENT_SUPPORTER_DIALOG(self, pc)
    local aObj = GetAccountObj(pc)
    local daytime = os.date("*t")
	local year, month, day, hour, minute, second, weekday = daytime['year'], daytime['month'], daytime['day'], daytime['hour'], daytime['min'], daytime['sec'], daytime['wday']
    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
	
	local buffList = {{'모루 강화 비용 50% 할인','Event_Reinforce_Discount_50'}
                     ,{'루팅 찬스 1,000 증가','Event_LootingChance_Add_1000'}
					 ,{'아이템 옵션 재감정 비용 50% 할인','Event_Reappraisal_Discount_50'}
					 ,{'시약병 경험치 증가량 2배','Event_Reagent_Bottle_Expup_100'}
					 ,{'클래스 변경 포인트 지급량 500% 증가','Event_Class_Change_Pointup_500'}
					 ,{'짝수 단계 초월 비용 50% 할인','Event_Even_Transcend_Discount_50'}
					 ,{'경험치 100% 증가','Event_Expup_100'}
					 ,{'젬 강화에 젬 사용 시, 경험치 페널티 면제','Event_Penalty_Clear_Gem_Reinforce'}
					 ,{'유니크 레이드 입장 아이템 소모량 고정 + 유니크 레이드 보상 2배 지급','Event_Unique_Raid_Bonus'}
					 ,{'10초마다 HP 및 SP+500 회복, 이동 속도 +2','Event_healHSP_Speedup'}
					 ,{'레전드레이드/업힐 디펜스 팀당 1회 초기화','Event_Legend_Uphill_Count_Reset'}
					 ,{'탁본 1위 동상 경배 효과 10배 증가','Event_Worship_Affect_10fold'}
					 }
    
    local daycheckbuff = 
	{{'3','6',{'Event_Class_Change_Pointup_500'}}
	,{'3','7',{'Event_Legend_Uphill_Count_Reset'}}
	,{'3','8',{'Event_Reinforce_Discount_50'}}
	,{'3','13',{'Event_Reappraisal_Discount_50'}}
	,{'3','14',{'Event_healHSP_Speedup','Event_LootingChance_Add_1000'}}
	,{'3','15',{'Event_Even_Transcend_Discount_50'}}
	,{'3','20',{'Event_Worship_Affect_10fold'}}
	,{'3','21',{'Event_Legend_Uphill_Count_Reset'}}
	,{'3','22',{'Event_Reinforce_Discount_50'}}
	,{'3','27',{'Event_Reappraisal_Discount_50'}}
	,{'3','28',{'Event_healHSP_Speedup','Event_LootingChance_Add_1000'}}
	,{'3','29',{'Event_Even_Transcend_Discount_50'}}
		}
	
	-- 기본 적용 버프
	local dayBuffList = {buffList[7][2]}
	--날짜별 버프
	for i = 1, #daycheckbuff do
		if (tostring(month) == daycheckbuff[i][1]) and (tostring(day) == daycheckbuff[i][2])then
			for j = 1,#daycheckbuff[i][3] do
				table.insert(dayBuffList,daycheckbuff[i][3][j])
			end
		end
	end
		
	local distractor;
	if table.find(dayBuffList,'Event_Legend_Uphill_Count_Reset') ~= 0 then --레전드 레이드 날짜 수정 필요
		distractor = ShowSelDlg(pc, 0, "REGULAR_BURNING_EVENT_COUNT_RESET_CHECK", ScpArgMsg("NPC_EVENT_MAGAZINE_NUM1_SEL2"), ScpArgMsg("Auto_SeonTaegChoKiHwa"), ScpArgMsg("Cancel"))
	else
		distractor = ShowSelDlg(pc, 0, 'FLASHMOB_EVENT_REWARD_SUCCESS', ScpArgMsg("NPC_EVENT_MAGAZINE_NUM1_SEL2"), ScpArgMsg("Cancel"))
	end
    
	
    if distractor == 1 then 
		PlaySound(pc, "item_drop_hp_1");
		PlayEffect(pc, 'F_sys_expcard_normal', 2.5, 1, "BOT", 1);
		for i = 1,#dayBuffList do
			AddBuff(pc, pc, dayBuffList[i], 1, 0, 3600*6*1000, 1);
		end
			
		if aObj.STEAM_TREASURE_EVENT_1902_WEEKEND ~= day then --보상 지급
			local tx = TxBegin(pc);
			TxGiveItem(tx, 'EVENT_1712_SECOND_CHALLENG_14d_Team', 5, 'STEAM_TREASURE_EVENT_1912_WEEKEND'); 
			TxGiveItem(tx, 'Event_190110_ChallengeModeReset_14d', 5, 'STEAM_TREASURE_EVENT_1912_WEEKEND'); 
			TxGiveItem(tx, 'Adventure_Reward_Seed_14d_Team', 10, 'STEAM_TREASURE_EVENT_1912_WEEKEND'); 
			TxGiveItem(tx, 'Event_Goddess_Statue', 5, 'STEAM_TREASURE_EVENT_1912_WEEKEND'); 
			TxSetIESProp(tx, aObj, 'STEAM_TREASURE_EVENT_1902_WEEKEND', day);
			local ret = TxCommit(tx);
		end
	
		SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("GM_BUFF_MSG1","BUFF",#dayBuffList), 5);
	end

	if table.find(dayBuffList,'Event_Legend_Uphill_Count_Reset') ~= 0 then --레전드 레이드 날짜 수정 필요
		if distractor == 2 then
			if TryGetProp(aObj, "REGULAR_BURNING_EVENT_COUNT_RESET") ~= 0 then
				ShowOkDlg(pc, "REGULAR_BURNING_EVENT_COUNT_ALREADY_DOING") --초기화를 이미 한 경우
				return
			end
			
			if IsBuffApplied(pc, "Event_Legend_Uphill_Count_Reset") == "YES" then
				if TryGetProp(aObj, "REGULAR_BURNING_EVENT_COUNT_RESET") == 0 then

					local tx = TxBegin(pc)
					TxSetIESProp(tx, aObj, "IndunWeeklyEnteredCount_400", 0)
					TxSetIESProp(tx, aObj, "IndunWeeklyEnteredCount_500", 0)
					TxSetIESProp(tx, aObj, "IndunWeeklyEnteredCount_800", 0)
					TxSetIESProp(tx, aObj, "IndunWeeklyEnteredCount_801", 0)
					TxSetIESProp(tx, aObj, "IndunWeeklyEnteredCount_802", 0)
					TxSetIESProp(tx, aObj, "REGULAR_BURNING_EVENT_COUNT_RESET", 1)
					local ret = TxCommit(tx)

					if ret == "SUCCESS" then
						SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("REGULAR_BURNING_EVENT_COUNT_RESET_SUCCESS"), 5)
						ShowOkDlg(pc, "REGULAR_BURNING_EVENT_COUNT_RESET_SUCCESS")
						CustomMongoLog(pc, "REGULAR_BURNING_EVENT", "Type", "Event_Legend_Uphill_Count_Reset", "Result", "Success")
					elseif ret == "FAIL" then
						SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("REGULAR_BURNING_EVENT_COUNT_RESET_FAIL"), 5)
						ShowOkDlg(pc, "REGULAR_BURNING_EVENT_COUNT_RESET_FAIL")
						CustomMongoLog(pc, "REGULAR_BURNING_EVENT", "Type", "Event_Legend_Uphill_Count_Reset", "Result", "Fail", "Reason", "TxError")
					end
				end
			else
				buff = GetClass('Buff', 'Event_Legend_Uphill_Count_Reset')
				SendAddOnMsg(pc, "NOTICE_Dm_!", buff.Name..ScpArgMsg("Need_Item"), 5)
			end
		end
    end
end
