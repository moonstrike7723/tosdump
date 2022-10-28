function SCR_EVENT_1809_CHUSEOK_DAY_DIALOG(self, pc)
   if pc.Lv < 50 then
       SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1801_ORB_MSG8","LV",50), 10);
       return
   end
   
   local aObj = GetAccountObj(pc);
   if aObj == nil then
       return
   end
   
   
   local now_time = os.date('*t')
   local year = now_time['year']
   local month = now_time['month']
   local day = now_time['day']
   local nowday = year..'/'..month..'/'..day
   
   if aObj.EVENT_1809_CHUSEOK_DAY_DATE == nowday then
       ShowOkDlg(pc, 'EVENT_1809_CHUSEOK_DAY_DLG2', 1)
       return
   elseif aObj.EVENT_1809_CHUSEOK_DAY_COUNT >= 24 then
       ShowOkDlg(pc, 'EVENT_1809_CHUSEOK_DAY_DLG3', 1)
       return
   end
   
   local itemList = {{'helmet_songpyun2', 1},
                       {'Event_160908_6_14d', 3},
                       {'card_Xpupkit01_500_14d', 3},
                       {'EVENT_1712_SECOND_CHALLENG_14d', 3},
                       {'Adventure_Reward_Seed_14d', 3},
                       {'Premium_awakeningStone14', 3},
                       {'Premium_StatReset14', 1},
                       {'Premium_boostToken_14d', 3},
                       {'Premium_WarpScroll_bundle10', 2},
                       {'misc_gemExpStone_randomQuest4_14d', 3},
                       {'Premium_Enchantchip14', 3},
                       {'Event_Goddess_Statue', 3},
                       {'Event_160714_2', 1},
                       {'Moru_Silver', 2},
                       {'Event_Steam_Wedding_Fire', 3},
                       {'Premium_repairPotion', 5},
                       {'Get_Wet_Card_Book_14d', 3},
                       {'indunReset_1add_14d_NoStack', 3},
                       {'Drug_RedApple100_TA_Event_Team_Trade', 10, 'Drug_BlueApple100_TA_Event_Team_Trade', 10},
                       {'Moru_Gold_14d', 2},
                       {'Mic_bundle50', 1},
                       {'Drug_Event_Looting_Potion_14d', 5},
                       {'RestartCristal', 5},
                       {'wing_inspector_scroll2', 1}
                       }

   local index = aObj.EVENT_1809_CHUSEOK_DAY_COUNT + 1
   
   local selKor = GetClassString('Item', 'Event_160908_5', 'Name')
   for i = 1, #itemList[index]/2 do
       selKor = selKor..', '..GetClassString('Item', itemList[index][i*2-1], 'Name')
   end
   
   selKor = '{#003399}'..selKor..'{/}'
   
   local selKor2
   if month == 10 and day == 31 then
       selKor2 = GetClassString('Item', 'Ability_Point_Stone', 'Name')
--    elseif month == 9 and day == 24 then
--        selKor2 = GetClassString('Item', 'Gacha_HairAcc_001_event14d', 'Name')
--    elseif month == 9 and day == 25 then
--        selKor2 = GetClassString('Item', 'Premium_item_transcendence_Stone', 'Name')
   end
   
   if selKor2 ~= nil then
       selKor = selKor..'{nl}'..ScpArgMsg('EVENT_1809_CHUSEOK_DAY_MSG4')..' : {#003399}'..selKor2..'{/}'
   end
   
   local select = ShowSelDlg(pc, 0, 'EVENT_1809_CHUSEOK_DAY_DLG2\\'..ScpArgMsg('EVENT_1809_CHUSEOK_DAY_MSG1')..'{nl}'..ScpArgMsg('EVENT_1809_CHUSEOK_DAY_MSG3')..' : '..selKor..ScpArgMsg("EVENT_1809_CHUSEOK_MOON_MSG19"), ScpArgMsg("EVENT_1809_CHUSEOK_DAY_MSG2"), ScpArgMsg("Auto_JongLyo"))
   
   if select ~= 1 then
       return
   end
   
   local giveItem = {}
   
   local tx = TxBegin(pc);
	TxEnableInIntegrate(tx);
   TxSetIESProp(tx, aObj, "EVENT_1809_CHUSEOK_DAY_DATE", nowday);
   TxSetIESProp(tx, aObj, "EVENT_1809_CHUSEOK_DAY_COUNT", index);
   
   TxGiveItem(tx,'Event_160908_5', 3, "EVENT_1809_CHUSEOK_DAY")
   if #itemList[index] > 2 then
       for i = 1, #itemList[index]/2 do
           TxGiveItem(tx,itemList[index][i*2-1], itemList[index][i*2], "EVENT_1809_CHUSEOK_DAY")
           giveItem[#giveItem + 1] = {itemList[index][i*2-1],itemList[index][i*2]}
       end
   else
       TxGiveItem(tx,itemList[index][1], itemList[index][2], "EVENT_1809_CHUSEOK_DAY")
       giveItem[#giveItem + 1] = {itemList[index][1],itemList[index][2]}
   end
   
   if month == 10 and day == 31 then
       TxGiveItem(tx,'Ability_Point_Stone', 3, "EVENT_1809_CHUSEOK_DAY")
       giveItem[#giveItem + 1] = {'Ability_Point_Stone',3}
--    elseif month == 9 and day == 24 then
--        TxGiveItem(tx,'Gacha_HairAcc_001_event14d', 1, "EVENT_1809_CHUSEOK_DAY")
--        giveItem[#giveItem + 1] = {'Gacha_HairAcc_001_event14d',1}
--    elseif month == 9 and day == 25 then
--        TxGiveItem(tx,'Premium_item_transcendence_Stone', 2, "EVENT_1809_CHUSEOK_DAY")
--        giveItem[#giveItem + 1] = {'Premium_item_transcendence_Stone',2}
   end
   
	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
	    local msg = ''
       for i = 1, #giveItem do
       	local itemKor = GetClassString('Item', giveItem[i][1], 'Name')
       	if msg == '' then
       	    msg = ScpArgMsg('EV161124_DAYCHECK_MSG6','ITEM',itemKor,'COUNT',giveItem[i][2])
       	else
       	    msg = msg..', '..ScpArgMsg('EV161124_DAYCHECK_MSG6','ITEM',itemKor,'COUNT',giveItem[i][2])
       	end
   	end
   	
   	SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EV161124_DAYCHECK_MSG9")..'{nl}'..msg, 10);
   end
   
end

