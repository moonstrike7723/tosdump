function SCR_PETSHOP_KLAIPE_DIALOG(self,pc)
	local ShowTutorialnote = GetConfig(pc, "ShowTutorialnote");
	if ShowTutorialnote == 0 then
    AddHelpByName(pc, 'TUTO_PETSHOP')
	end
    
    TUTO_PIP_CLOSE_QUEST(pc)
    local vel, hawk, hoglan;
    if GetInvItemCount(pc, 'JOB_VELHIDER_COUPON') > 0 then
        local itemLangName = GetClassString('Item', 'JOB_VELHIDER_COUPON', 'Name')
        vel = itemLangName..ScpArgMsg('PetCouponExchange1')
    end
    if GetInvItemCount(pc, 'steam_JOB_HOGLAN_COUPON') > 0 then
        local itemLangName = GetClassString('Item', 'steam_JOB_HOGLAN_COUPON', 'Name')
        hoglan = itemLangName..ScpArgMsg('PetCouponExchange1')
    end
    if GetInvItemCount(pc, 'JOB_HAWK_COUPON') > 0 then
        local itemIES = GetClass('Item', 'JOB_HAWK_COUPON')
        if itemIES ~= nil then
            local cls = GetClass("Companion", itemIES.StringArg);
        	if nil == cls then
        		return;
        	end
        
        	if cls.JobID ~= 0 then 
        		local jobCls = GetClassByType("Job", cls.JobID);
        		if 0 < GetJobGradeByName(pc, jobCls.ClassName) then
        		    local itemLangName = GetClassString('Item', 'JOB_HAWK_COUPON', 'Name')
                    hawk = itemLangName..ScpArgMsg('PetCouponExchange1')
        		end
        	end
        end
    end
    
    local jobClassName, companionClassName = SCR_FREE_COMPANION_CHECK(self, pc)
    local jobFreeCompanionMsg = {}
    for i = 1, #jobClassName do
        jobFreeCompanionMsg[#jobFreeCompanionMsg + 1] = ScpArgMsg('FREE_COMPANION_MSG1','JOB', GetClassString('Job',jobClassName[i], 'Name'),'COMPANION',GetClassString('Monster',companionClassName[i], 'Name'))
    end
    
    local select = ShowSelDlg(pc, 0, 'PETSHOP_KLAIPE_basic1', vel, hawk, hoglan, ScpArgMsg('shop_companion'), ScpArgMsg('shop_companion_learnabil'), ScpArgMsg('shop_companion_info'), jobFreeCompanionMsg[1], jobFreeCompanionMsg[2], ScpArgMsg('Auto_DaeHwa_JongLyo'));
--    local select = ShowSelDlg(pc, 0, 'PETSHOP_KLAIPE_basic1', vel, hawk, hoglan, ScpArgMsg('shop_companion'), ScpArgMsg('shop_companion_learnabil'), ScpArgMsg('shop_companion_info'), ScpArgMsg('Auto_DaeHwa_JongLyo'));
    if select == 1 or select == 2 or select == 3 then
		local scp = string.format("TRY_CECK_BARRACK_SLOT_BY_COMPANION_EXCHANGE(%d)", select);
		ExecClientScp(pc, scp);
	elseif select == 4 then -- 분양, 아이템 구입
        ShowTradeDlg(pc, 'Klapeda_Companion', 5);
    elseif select == 5 then -- 훈련
		SetExProp(pc, 'PET_TRAIN_SHOP', 1);
        SendAddOnMsg(pc, "COMPANION_UI_OPEN", "", 0);
    elseif select == 6 then -- 좋은 점에 대하여
        ShowOkDlg(pc, 'PETSHOP_KLAIPE_basic2', 1)
    elseif select == 7 then
        SCR_FREE_COMPANION_CREATE(pc, companionClassName[1])
    elseif select == 8 then
        SCR_FREE_COMPANION_CREATE(pc, companionClassName[2])
    end
    
end