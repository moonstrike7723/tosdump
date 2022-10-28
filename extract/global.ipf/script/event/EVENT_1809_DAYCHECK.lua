--
--function SCR_EVENT_1809_DAYCHECK_TIME_CHECK()
--    local now_time = os.date('*t')
--    local year = now_time['year']
--    local month = now_time['month']
--    local day = now_time['day']
--    
--    local EVENT_1809_DAYCHECK = {{{2018,8,30},{2018,9,11}}}
--    for i = 1, #EVENT_1809_DAYCHECK do
--        if SCR_DATE_TO_YDAY_BASIC_2000(EVENT_1809_DAYCHECK[i][1][1],EVENT_1809_DAYCHECK[i][1][2],EVENT_1809_DAYCHECK[i][1][3]) <= SCR_DATE_TO_YDAY_BASIC_2000(year,month,day) and SCR_DATE_TO_YDAY_BASIC_2000(year,month,day) <= SCR_DATE_TO_YDAY_BASIC_2000(EVENT_1809_DAYCHECK[i][2][1],EVENT_1809_DAYCHECK[i][2][2],EVENT_1809_DAYCHECK[i][2][3]) then
--            return i
--        end
--    end
--    
--    return 0
--end
--
--function SCR_EVENT_1809_DAYCHECK_REWARD_LIST()
--    local itemList = {'RestartCristal', 'Premium_WarpScroll_bundle10', 'Premium_indunReset_14d', 'Premium_boostToken_14d', 'Premium_awakeningStone14', 'Premium_Enchantchip14', 'Ability_Point_Stone_500', 'Mic_bundle10', 'ChallengeModeReset_14d', 'misc_gemExpStone_randomQuest4_14d'}
--    local itemCountList = {3,1,1,1,1,1,1,1,1,1}
--    local itemPercentList = {10,10,10,10,10,10,10,10,10,10}
--    return itemList, itemCountList, itemPercentList
--end
--
--function SCR_EVENT_1809_DAYCHECK_DIALOG(self, pc)
--    if GetServerNation() ~= 'KOR' then
--        return
--    end
--    
--    local aObj = GetAccountObj(pc);
--    if aObj == nil then
--        return
--    end
--    
--    if pc.Lv < 50 then
--        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1801_ORB_MSG8","LV",50), 10);
--        return
--    end
--    
--    local now_time = os.date('*t')
--    local year = now_time['year']
--    local month = now_time['month']
--    local yday = now_time['yday']
--    local wday = now_time['wday']
--    local day = now_time['day']
--    local hour = now_time['hour']
--    local nowDate = year..'/'..month..'/'..day
--    
--    local seid = SCR_EVENT_1809_DAYCHECK_TIME_CHECK()
--    
--    if seid == 0 then
--        ShowOkDlg(pc, 'EV161124_DAYCHECK_DLG6', 1)
--        return
--    end
--    
--    local lastDate = aObj.EVENT_1809_DAYCHECK_DATE
--    local itemList, itemCountList, itemPercentList = SCR_EVENT_1809_DAYCHECK_REWARD_LIST()
--    local lastReward = aObj.EVENT_1809_DAYCHECK_REWARDLIST
--    if lastReward == nil then
--        return
--    end
--    local lastRewardList = SCR_STRING_CUT(lastReward)
--    local selectNum = aObj.EVENT_1809_DAYCHECK_SELECTLIST
--    local selectNumList = SCR_STRING_CUT(selectNum)
--    
--    local rewardIndex = {}
--    local removeList = {}
--    
--    for i = 1, #itemList do
--        if table.find(lastRewardList, i) == 0 then
--            rewardIndex[#rewardIndex + 1] = i
----            print('SSSSSSSSSS', i)
--        else
----            print('XXXXXXX',i, lastRewardList[table.find(lastRewardList, i)])
--            removeList[#removeList + 1] = i
--        end
--    end
--    
--    local playCount = #removeList
--    
--    if #rewardIndex == 0 then
--        if aObj.EVENT_1809_DAYCHECK_ADDREWARD == 0 then
--            local select = ShowSelDlg(pc, 0, 'EV161124_DAYCHECK_DLG7', ScpArgMsg('Yes'), ScpArgMsg('No'))
--            if select == 1 then
--                local tx = TxBegin(pc);
--            	TxEnableInIntegrate(tx);
--            	TxSetIESProp(tx, aObj, "EVENT_1809_DAYCHECK_ADDREWARD", 1);
--                TxGiveItem(tx,'Premium_SkillReset_14d', 1, "EVENT_1809_DAYCHECK")
--            	local ret = TxCommit(tx);
--            end
--        else
--            ShowOkDlg(pc, 'EV161124_DAYCHECK_DLG1', 1)
--        end
--        return
--    end
--    
--    if aObj.EVENT_1809_DAYCHECK_DATE == nowDate then
--        if (wday == 1 or wday == 7) and aObj.EVENT_1809_DAYCHECK_DAYCOUNT < 2 then
--        else
--            ShowOkDlg(pc, 'EV161124_DAYCHECK_DLG2', 1)
--            return
--        end
--    end
--    
--    ShowOkDlg(pc, 'EV161124_DAYCHECK_DLG3', 1)
--    local input
--    if #removeList == 0 then
--        input = ShowTextInputDlg(pc, 0, 'EV161124_DAYCHECK_DLG3\\'..ScpArgMsg('EV161124_DAYCHECK_MSG2'))
--    else
--        local msg = string.gsub(selectNum, '/',', ')
--        ShowOkDlg(pc, 'EV161124_DAYCHECK_DLG3\\'..ScpArgMsg('EV161124_DAYCHECK_MSG1','NUMLIST',msg), 1)
--        input = ShowTextInputDlg(pc, 0, 'EV161124_DAYCHECK_DLG4')
--    end
--    
--    input = tonumber(input)
--    if input == nil or input%1 ~= 0 or input < 1 or input > 10 then
--        ShowOkDlg(pc, 'EV161124_DAYCHECK_DLG4', 1)
--        return
--    end
--    
--    if table.find(selectNumList, input) > 0 then
--        ShowOkDlg(pc, 'EV161124_DAYCHECK_DLG5', 1)
--        return
--    end
--    
--    
--    local percentMax = 0
--    for i = 1, #rewardIndex do
--        percentMax = percentMax + itemPercentList[rewardIndex[i]]
--    end
--    local percentRand = IMCRandom(1, percentMax)
--    
--    local rand
--    local percentAdd = 0
--    for i = 1, #rewardIndex do
--        percentAdd = percentAdd + itemPercentList[rewardIndex[i]]
--        if percentRand <= percentAdd then
--            rand = i
--            break
--        end
--    end
--    
--    local randIndex = rewardIndex[rand]
--    local saveReward = lastReward
--    if saveReward == 'None' then
--        saveReward = tostring(randIndex)
--    else
--        saveReward = saveReward..'/'..randIndex
--    end
--    local saveSelect = selectNum
--    if saveSelect == 'None' then
--        saveSelect =  tostring(input)
--    else
--        saveSelect = saveSelect..'/'..input
--    end
----    print('QQQQQQQ',#rewardIndex,rand,randIndex,saveReward)
--    
--    
--    local giveItem = {}
--    
--    if aObj.EVENT_1809_DAYCHECK_DATE == nowDate then
--        if (wday == 1 or wday == 7) and aObj.EVENT_1809_DAYCHECK_DAYCOUNT < 2 then
--        else
--            return
--        end
--    end
--    
--    local tx = TxBegin(pc);
--	TxEnableInIntegrate(tx);
--	
--	if aObj.EVENT_1809_DAYCHECK_DATE ~= nowDate then
--        TxSetIESProp(tx, aObj, "EVENT_1809_DAYCHECK_DATE", nowDate);
--        TxSetIESProp(tx, aObj, "EVENT_1809_DAYCHECK_DAYCOUNT", 1);
--    else
--        TxSetIESProp(tx, aObj, "EVENT_1809_DAYCHECK_DAYCOUNT", aObj.EVENT_1809_DAYCHECK_DAYCOUNT + 1);
--    end
--    TxSetIESProp(tx, aObj, "EVENT_1809_DAYCHECK_REWARDLIST", saveReward);
--    TxSetIESProp(tx, aObj, "EVENT_1809_DAYCHECK_SELECTLIST", saveSelect);
--    TxGiveItem(tx,itemList[randIndex], itemCountList[randIndex], "EVENT_1809_DAYCHECK")
--    giveItem[#giveItem + 1] = {itemList[randIndex],itemCountList[randIndex]}
--    
--	local ret = TxCommit(tx);
--	if ret == 'SUCCESS' then
--        CustomMongoLog(pc, "EVENT_1809_DAYCHECK","PlayCount",playCount+1,"RewardIndex",randIndex,"Item", itemList[randIndex], "ItemCount", itemCountList[randIndex], "NowDate", nowDate, "LastDate", lastDate)
--    	local msg = ''
--    	for i = 1, #giveItem do
--        	local itemKor = GetClassString('Item', giveItem[i][1], 'Name')
--        	if msg == '' then
--        	    msg = ScpArgMsg('EV161124_DAYCHECK_MSG6','ITEM',itemKor,'COUNT',giveItem[i][2])
--        	else
--        	    msg = msg..', '..ScpArgMsg('EV161124_DAYCHECK_MSG6','ITEM',itemKor,'COUNT',giveItem[i][2])
--        	end
--    	end
--    	
----        SCR_SEND_NOTIFY_REWARD(pc, ScpArgMsg('EV161124_DAYCHECK_MSG9'), msg)
--    	SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EV161124_DAYCHECK_MSG3","NUM",input)..msg, 10);
--    end
--    
--end
--