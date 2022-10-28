function REGULAR_BURNING_EVENT_TRIGGER_CHECK(self)
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

     if weekday > 1 and weekday < 6 then --월~목
        Kill(self)
		return;
    end
	
end


function SCR_REGULAR_BURNING_EVENT_SUPPORTER_DIALOG(self, pc)
    local accountObject = GetAccountObj(pc)
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
					 ,{'유니크 레이드 입장 아이템 소모량 고정 + 유니크 레이드 보상 2배 지급 (계정별 10회 제한)','Event_Unique_Raid_Bonus_Limit'}
					 ,{'10초마다 HP 및 SP+500 회복, 이동 속도 +2','Event_healHSP_Speedup'}
					 ,{'레전드레이드/업힐 디펜스 팀당 1회 초기화','Event_Legend_Uphill_Count_Reset'}
					 ,{'탁본 1위 동상 경배 효과 10배 증가','Event_Worship_Affect_10fold'}
					 ,{'챌린지 모드 횟수 초기화 (하루 3회 제한)','Event_Challenge_Count_Reset'}					 
					 ,{'스킬 쿨타임, SP 소모량 90% 감소 (지역 제한)','Event_Cooldown_SPamount_Decrease'}	
					 ,{'물리 및 마법 공격력 +500, 물리 및 마법 방어력 +3,000','Event_ATK_and_DEF_UP_BUFF'}
					 ,{'나무뿌리 수정 파괴 시, 이동 속도 5 증가','Event_RootCrystal_Check_Buff'}
					 ,{'경험치 50% 증가','Event_Expup_50'}
					 ,{'통합 포인트 획득량 2배 증가 ','EVENT_CONTENTS_TOTAL_POINT_BOOST'}
					 ,{'필드 드롭율 50% 증가','GET_FIELD_DROPRATIO_BOOST_WEEKEND'}
					 ,{'[주말 앤 버닝] 성물 레이드 : 자동 매칭 (Normal) 입장 횟수 초기화','Event_Mythic_Auto_Count_Reset'}					 
					 }
    
    local daycheckbuff = 
	{{'10','1',{'Event_Expup_50','Event_Class_Change_Pointup_500'}}
	,{'10','2',{'Event_Expup_50','Event_Worship_Affect_10fold'}}
	,{'10','3',{'Event_Expup_50','Event_Challenge_Count_Reset'}}
	,{'10','8',{'Event_LootingChance_Add_1000','Event_Cooldown_SPamount_Decrease'}}
	,{'10','9',{'Event_LootingChance_Add_1000','Event_Reagent_Bottle_Expup_100'}}
	,{'10','10',{'Event_LootingChance_Add_1000','Event_Worship_Affect_10fold'}}
	,{'10','15',{'Event_Expup_50','Event_Legend_Uphill_Count_Reset'}}
	,{'10','16',{'Event_Expup_50','Event_Reagent_Bottle_Expup_100'}}
	,{'10','17',{'Event_Expup_50','Event_Cooldown_SPamount_Decrease'}}
	,{'10','22',{'Event_LootingChance_Add_1000','Event_Worship_Affect_10fold'}}
	,{'10','23',{'Event_LootingChance_Add_1000','Event_Reagent_Bottle_Expup_100'}}
	,{'10','24',{'Event_LootingChance_Add_1000','Event_Class_Change_Pointup_500'}}
	,{'10','29',{'Event_Expup_50','EVENT_CONTENTS_TOTAL_POINT_BOOST'}}
	,{'10','30',{'Event_Expup_50','Event_Reagent_Bottle_Expup_100'}}
	,{'10','31',{'Event_Expup_50','Event_Cooldown_SPamount_Decrease'}}
		}
	
	-- 기본 적용 버프
	local dayBuffList = {'Event_RootCrystal_Check_Buff'}
	--날짜별 버프
	for i = 1, #daycheckbuff do
		if (tostring(month) == daycheckbuff[i][1]) and (tostring(day) == daycheckbuff[i][2])then
			for j = 1,#daycheckbuff[i][3] do
				table.insert(dayBuffList,daycheckbuff[i][3][j])
			end
		end
	end
		
	local distractor;
	if table.find(dayBuffList,'Event_Legend_Uphill_Count_Reset') ~= 0 then
		distractor = ShowSelDlg(pc, 0, "REGULAR_BURNING_EVENT_COUNT_RESET_CHECK", ScpArgMsg("NPC_EVENT_MAGAZINE_NUM1_SEL2"), ScpArgMsg("Auto_SeonTaegChoKiHwa"), ScpArgMsg("Cancel"))
	elseif table.find(dayBuffList,'Event_Challenge_Count_Reset') ~= 0 then
		distractor = ShowSelDlg(pc, 0, 'REGULAR_BURNING_EVENT_CHALLENGE_RESET_CHECK', ScpArgMsg("NPC_EVENT_MAGAZINE_NUM1_SEL2"),ScpArgMsg("BURNING_EVENT_COUNT_RESET_SEL1"), ScpArgMsg("Cancel"))
	elseif table.find(dayBuffList,'Event_Mythic_Auto_Count_Reset') ~= 0 then
		distractor = ShowSelDlg(pc, 0, 'REGULAR_BURNING_MYTHIC_AUTO_RESET_CHECK', ScpArgMsg("NPC_EVENT_MAGAZINE_NUM1_SEL2"),ScpArgMsg("BURNING_EVENT_COUNT_RESET_SEL2"), ScpArgMsg("Cancel"))
	else
		distractor = ShowSelDlg(pc, 0, 'FLASHMOB_EVENT_REWARD_SUCCESS', ScpArgMsg("NPC_EVENT_MAGAZINE_NUM1_SEL2"), ScpArgMsg("Cancel"))
	end
    
	
	if distractor == 1 then 
		--이벤트 버프는 당일 지급하는 버프와 다음날 받는 버프가 다를 경우 중첩되지 아니한다.
		for i = 1,#buffList do
			RemoveBuff(pc, buffList[i][2]);
		end
		PlaySound(pc, "item_drop_hp_1");
		PlayEffect(pc, 'F_sys_expcard_normal', 2.5, 1, "BOT", 1);
		for i = 1,#dayBuffList do
			AddBuff(pc, pc, dayBuffList[i], 1, 0, 3600*6*1000, 1);
		end
			
		if accountObject.STEAM_TREASURE_EVENT_1902_WEEKEND ~= day then --보상 지급
			local tx = TxBegin(pc);
			TxGiveItem(tx, 'Adventure_Reward_Seed_14d_Team', 10, 'STEAM_TREASURE_EVENT_1912_WEEKEND'); 
			TxGiveItem(tx, 'Event_Goddess_Statue', 5, 'STEAM_TREASURE_EVENT_1912_WEEKEND'); 
			TxSetIESProp(tx, accountObject, 'STEAM_TREASURE_EVENT_1902_WEEKEND', day);
			local ret = TxCommit(tx);
		end
	
		SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("GM_BUFF_MSG1","BUFF",#dayBuffList), 5);
		--루아 버전업 전이라서인지 table.unpack을 쓸 수 없어서 이 방식을 이용
		for i = 1,#dayBuffList do
			CustomMongoLog(pc,"Buff","Type",'BurningAddBuff','Buff'..i,dayBuffList[i])
		end
	end

	if table.find(dayBuffList,'Event_Legend_Uphill_Count_Reset') ~= 0 then --레전드 레이드
	    
		if distractor == 2 then
			if TryGetProp(accountObject, "REGULAR_BURNING_EVENT_COUNT_RESET") ~= 0 then
				ShowOkDlg(pc, "REGULAR_BURNING_EVENT_COUNT_ALREADY_DOING") --초기화를 이미 한 경우
				return
			end
			
			if IsBuffApplied(pc, "Event_Legend_Uphill_Count_Reset") == "YES" then
				if TryGetProp(accountObject, "REGULAR_BURNING_EVENT_COUNT_RESET") == 0 then
                        local tx = TxBegin(pc)
                        TxSetIESProp(tx, accountObject, "IndunWeeklyEnteredCount_400", 0)
                        TxSetIESProp(tx, accountObject, "IndunWeeklyEnteredCount_500", 0)
                        TxSetIESProp(tx, accountObject, "IndunWeeklyEnteredCount_800", 0)
                        TxSetIESProp(tx, accountObject, "IndunWeeklyEnteredCount_801", 0)
                        TxSetIESProp(tx, accountObject, "IndunWeeklyEnteredCount_802", 0)
                        TxSetIESProp(tx, accountObject, "IndunWeeklyEnteredCount_803", 0)
                        TxSetIESProp(tx, accountObject, "IndunWeeklyEnteredCount_805", 0)
						TxSetIESProp(tx, accountObject, "IndunWeeklyEnteredCount_806", 0)
						-- TxSetIESProp(tx, accountObject, "Giltine_Raid_EnableEntryCount", 0)
                        TxSetIESProp(tx, accountObject, "IndunWeeklyEnteredCount_808", 0)
                        TxSetIESProp(tx, accountObject, "IndunWeeklyEnteredCount_810", 0)
						TxSetIESProp(tx, accountObject, "IndunWeeklyEnteredCount_811", 0)
						TxSetIESProp(tx, accountObject, "IndunWeeklyEnteredCount_814", 0)
                        TxSetIESProp(tx, accountObject, "REGULAR_BURNING_EVENT_COUNT_RESET", 1)
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
			else --steam msg
				buff = GetClass('Buff', 'Event_Legend_Uphill_Count_Reset')
				SendAddOnMsg(pc, "NOTICE_Dm_!", buff.Name..ScpArgMsg("Need_Item"), 5) 
			end
		end
		
	--CHALLENGE MODE RESET
	elseif table.find(dayBuffList,'Event_Challenge_Count_Reset') ~= 0 then 
        if distractor == 2 then
		
			if TryGetProp(accountObject, "REGULAR_BURNING_EVENT_CHALLENGE_RESET") >= 3 then
				ShowOkDlg(pc, "REGULAR_BURNING_EVENT_COUNT_ALREADY_DOING")
				return
			end
			
			if IsBuffApplied(pc, "Event_Challenge_Count_Reset") == "YES" then
				local challengeCount = TryGetProp(accountObject, "REGULAR_BURNING_EVENT_CHALLENGE_RESET")
				if challengeCount < 3 then
					local etcObj = GetETCObject(pc)
					if etcObj ~= nil then
						local count = TryGetProp(etcObj, 'ChallengeModeCompleteCount', 0)
						if count > 0 then
							local aid = GetPcAIDStr(pc)
							local cid = GetPcCIDStr(pc)
							IMC_LOG("INFO_CHALLENGE_MODE", "step:RemoveCount; aid:" .. tostring(aid) .. "; cid:" .. tostring(cid) .. ";")
							if IsRunningScript(pc, '_SCR_USE_ChallengeModeReset') ~= 1 then
								RunScript('_SCR_USE_ChallengeModeReset', pc)
							end
							local tx = TxBegin(pc)
							TxSetIESProp(tx, accountObject, "REGULAR_BURNING_EVENT_CHALLENGE_RESET", challengeCount+1)
							local ret = TxCommit(tx)

							if ret == "SUCCESS" then
								SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("REGULAR_BURNING_EVENT_CHALLENGE_RESET_SUCCESS"), 5)
								ShowOkDlg(pc, "REGULAR_BURNING_EVENT_COUNT_RESET_SUCCESS")
								CustomMongoLog(pc, "REGULAR_BURNING_EVENT", "Type", "Event_Challenge_Count_Reset", "Result", "Success")
							elseif ret == "FAIL" then
								SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("REGULAR_BURNING_EVENT_COUNT_RESET_FAIL"), 5)
								ShowOkDlg(pc, "REGULAR_BURNING_EVENT_COUNT_RESET_FAIL")
								CustomMongoLog(pc, "REGULAR_BURNING_EVENT", "Type", "Event_Challenge_Count_Reset", "Result", "Fail", "Reason", "TxError")
							end
						elseif count <= 0 then
							ShowOkDlg(pc, "REGULAR_BURNING_EVENT_CHALLENGE_COUNT_NOT_USE")
						end
					end
				else
					ShowOkDlg(pc, "REGULAR_BURNING_EVENT_CHALLENGE_COUNT_NOT_USE")
				end
			end
		end
	        --MYTHIC_AUTO_RESET
	elseif  REGULAR_BURNING_EVENT_SERVER_TIME_CHECK(self) == 20210917 then -- before active select dialog
		local mythicrecheck = TryGetProp(accountObject,"REGULAR_BURNING_EVENT_MYTHIC_AUTO_RESET",0)
		
		if distractor == 2 then


		    if mythicrecheck >= 1 then
			    ShowOkDlg(pc, "EVENT_BURINING_NPC_DLG_1")
                return
            end
		end

		local now = TryGetProp(accountObject, 'IndunWeeklyEnteredCount_812', 0)
		if now <= 0 then
			ShowOkDlg(pc, "EVENT_BURINING_NPC_DLG_5")
			return
		end


		local buffCheck = GetExProp(pc,"REGULAR_BURNING_EVENT_MYTHIC_AUTO_RESET")
		if buffCheck == 1 then
			if mythicrecheck < 1 then
				if IsRunningScript(pc, 'SCR_USE_Mythic_Auto_2d') == 1 then
					SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("REGULAR_BURNING_EVENT_MYTHIC_AUTO_RESET_FAIL"), 5)
					ShowOkDlg(pc, "EVENT_BURINING_NPC_DLG_4")
					return
				end
					local tx = TxBegin(pc)
					TxSetIESProp(tx, accountObject, "REGULAR_BURNING_EVENT_MYTHIC_AUTO_RESET", 1)
					TxSetIESProp(tx, accountObject, 'IndunWeeklyEnteredCount_812', 0)
					local ret = TxCommit(tx)

					if ret == "SUCCESS" then
						SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("REGULAR_BURNING_EVENT_MYTHIC_AUTO_RESET_SUCCESS"), 5)
						ShowOkDlg(pc, "EVENT_BURINING_NPC_DLG_3")
					elseif ret == "FAIL" then
						SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("REGULAR_BURNING_EVENT_MYTHIC_AUTO_RESET_FAIL"), 5)
						ShowOkDlg(pc, "EVENT_BURINING_NPC_DLG_4")
					end
				CustomMongoLog(pc, "REGULAR_BURNING_EVENT","TX", tx, "EVCOUNT",mythicrecheck,"EVBUFF",buffCheck)
			end
		end
	end	

end
