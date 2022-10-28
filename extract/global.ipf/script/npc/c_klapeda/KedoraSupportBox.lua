function SCR_KEDORA_SUPPORT_BOX_LIST()
   
    local RewardsList = {
                        {1, "KEDORA_40LV_WEAPON_BOX/2", "KEDORA_40LV_ARMOR_BOX/4", "Lv40", 40, "expCard3_x5/55", 0},
                        {2, "KEDORA_75LV_WEAPON_BOX/2", "KEDORA_75LV_ARMOR_BOX/4", "Lv75", 75, "expCard3_x5/19", 0},
                        {3, "KEDORA_120LV_WEAPON_BOX/2", "KEDORA_120LV_ARMOR_BOX/4", "Lv120", 120, "expCard8_x5/34", 0},
                        {4, "KEDORA_170LV_WEAPON_BOX/2", "KEDORA_170LV_ARMOR_BOX/4", "Lv170", 170, "expCard8_x5/23", 1},
                        {5, "KEDORA_220LV_WEAPON_BOX/2", "KEDORA_220LV_ARMOR_BOX/4", "Lv220", 220, "expCard12_x10/10", 2},
                        {6, "KEDORA_270LV_WEAPON_BOX/2", "KEDORA_270LV_ARMOR_BOX/4", "Lv270", 270, "expCard12_x10/17", 2},
                        {7, "KEDORA_315LV_WEAPON_BOX/2", "KEDORA_315LV_ARMOR_BOX/4", "Lv315", 315, "expCard15_x5/17", 2},
                        {8, "KEDORA_350LV_WEAPON_BOX/2", "KEDORA_350LV_ARMOR_BOX/4", "Lv350", 350, "expCard16_x3/23", 2},
                        {9, "KEDORA_380LV_WEAPON_BOX/2", "KEDORA_380LV_ARMOR_BOX/4", "Lv380", 380, "expCard16_x3/56", 2}
                        }
                        
    return RewardsList
end

function KEDORA_SUPPORT_BOX_COMMON(self, pc)
    local customDlg_init = "RENA_GET_KEDORA_SUPPORT_BOX_DLG_1"
    local selLst_Dlg = "RENA_GET_KEDORA_SUPPORT_BOX_DLG_2"
    local npc = TryGetProp(self, 'ClassName', 'None')
    if npc == 'npc_racia' then
        customDlg_init = 'RACIA_GET_KEDORA_SUPPORT_BOX_DLG_1'
        selLst_Dlg = "RACIA_GET_KEDORA_SUPPORT_BOX_DLG_2"
    end

--    ShowOkDlg(pc, customDlg_init, 1)
    
--    local notYetList = ISGET_KEDORA_SUPPORT_BOX_RESULT(pc)
    local GiveBoxList, sObj = SCR_KEDORA_SUPPORT_BOX_RESULT(pc)
    local final_Give = {}
    local sel_List = {}

    if #GiveBoxList > 0 then
        sel_List[#sel_List+1] = ScpArgMsg("GET_KEDORA_SUPPORT_BOX_MSG_3")
        for i = 1, #GiveBoxList do
--            for j = 1, #notYetList do
--                if GiveBoxList[i][1] == notYetList[j] then
                    final_Give[#final_Give+1] = GiveBoxList[i]
                    sel_List[#sel_List+1] = GiveBoxList[i][4]..ScpArgMsg("GET_KEDORA_SUPPORT_BOX_MSG_2")
--                end
--            end
        end
    end

    if #final_Give == 0 or #final_Give == nil then
        return
    end
    
    
    local select = SCR_SEL_LIST(pc, sel_List, selLst_Dlg, 1)

    if select == nil or select == 0 then return end
    if select == 1 then
        local tx = TxBegin(pc)
        for i = 1, #final_Give do
            local z = final_Give[i][1]
            local ChecksObj = TryGetProp(sObj, "KedoraSupportBox_"..z, 0)
            if ChecksObj == 0 then
                local WeaponBox_str = SCR_STRING_CUT(final_Give[i][2], "/")
                local ArmorBox_str = SCR_STRING_CUT(final_Give[i][3], "/")
                local xp_Card_str = SCR_STRING_CUT(final_Give[i][6], "/")
                local Ability_PointCount = final_Give[i][7]
                local WeaponBox_cls = WeaponBox_str[1]
                local WeaponBox_cnt = WeaponBox_str[2]
                local xp_Card_cls = xp_Card_str[1]
                local xp_Card_cnt = xp_Card_str[2]
                local ArmorBox_cls = ArmorBox_str[1]
                local ArmorBox_cnt = ArmorBox_str[2]

                TxSetIESProp(tx, sObj, "KedoraSupportBox_"..z, 1)
                if WeaponBox_cls ~= "None" and WeaponBox_cls ~= nil then
                    TxGiveItem(tx, WeaponBox_cls, WeaponBox_cnt, 'KedoraSupportBox')
                end
                if ArmorBox_cls ~= "None" and ArmorBox_cls ~= nil then
                    TxGiveItem(tx, ArmorBox_cls, ArmorBox_cnt, 'KedoraSupportBox')
                end
                if xp_Card_cls ~= "None" and xp_Card_cls ~= nil then
                    if i >= 10 then
                        local IsKor = GetServerNation()
                        if IsKor == "KOR" then
                            TxGiveItem(tx, xp_Card_cls, xp_Card_cnt, 'KedoraSupportBox')
                        end
                    else
                        TxGiveItem(tx, xp_Card_cls, xp_Card_cnt, 'KedoraSupportBox')
                    end
                    
                end
                if Ability_PointCount > 0 and Ability_PointCount ~= nil then
                    TxGiveItem(tx, 'Event_Ability_Point_Stone_1000', Ability_PointCount, 'KedoraSupportBox')
                end
            end
        end
        
        local ret = TxCommit(tx)
        if ret == 'SUCCESS' then
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("GET_KEDORA_SUPPORT_BOX_MSG_1"), 10)
            
            if npc == "npc_rena" then
                RunScript("TUTORIALNOTE_CHECK_PROP_CHANGE", pc, "mission_2_4", 1);
            end
        end
        return
    elseif final_Give[select-1][1] == 1 then
        RunScript("_TX_GET_KEDORA_SUPPORT", pc, npc, sObj, 1, "KEDORA_40LV_WEAPON_BOX/2", "KEDORA_40LV_ARMOR_BOX/4", "expCard3_x5/55", final_Give[select-1][7])
        return
    elseif final_Give[select-1][1] == 2 then
        RunScript("_TX_GET_KEDORA_SUPPORT", pc, npc, sObj, 2, "KEDORA_75LV_WEAPON_BOX/2", "KEDORA_75LV_ARMOR_BOX/4", "expCard3_x5/19", final_Give[select-1][7])
        return
    elseif final_Give[select-1][1] == 3 then
        RunScript("_TX_GET_KEDORA_SUPPORT", pc, npc, sObj, 3, "KEDORA_120LV_WEAPON_BOX/2", "KEDORA_120LV_ARMOR_BOX/4", "expCard8_x5/34", final_Give[select-1][7])
        return
    elseif final_Give[select-1][1] == 4 then
        RunScript("_TX_GET_KEDORA_SUPPORT", pc, npc, sObj, 4, "KEDORA_170LV_WEAPON_BOX/2", "KEDORA_170LV_ARMOR_BOX/4", "expCard8_x5/23", final_Give[select-1][7])
        return
    elseif final_Give[select-1][1] == 5 then
        RunScript("_TX_GET_KEDORA_SUPPORT", pc, npc, sObj, 5, "KEDORA_220LV_WEAPON_BOX/2", "KEDORA_220LV_ARMOR_BOX/4", "expCard12_x10/10", final_Give[select-1][7])
        return
    elseif final_Give[select-1][1] == 6 then
        RunScript("_TX_GET_KEDORA_SUPPORT", pc, npc, sObj, 6, "KEDORA_270LV_WEAPON_BOX/2", "KEDORA_270LV_ARMOR_BOX/4", "expCard12_x10/17", final_Give[select-1][7])
        return
    elseif final_Give[select-1][1] == 7 then
        RunScript("_TX_GET_KEDORA_SUPPORT", pc, npc, sObj, 7, "KEDORA_315LV_WEAPON_BOX/2", "KEDORA_315LV_ARMOR_BOX/4", "expCard15_x5/17", final_Give[select-1][7])
        return
    elseif final_Give[select-1][1] == 8 then
        RunScript("_TX_GET_KEDORA_SUPPORT", pc, npc, sObj, 8, "KEDORA_350LV_WEAPON_BOX/2", "KEDORA_350LV_ARMOR_BOX/4", "expCard16_x3/23", final_Give[select-1][7])
        return
    elseif final_Give[select-1][1] == 9 then
        RunScript("_TX_GET_KEDORA_SUPPORT", pc, npc, sObj, 9, "KEDORA_380LV_WEAPON_BOX/2", "KEDORA_380LV_ARMOR_BOX/4", "expCard16_x3/56", final_Give[select-1][7])
        return
    else
        return
    end
    
end