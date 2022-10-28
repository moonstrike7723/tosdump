function ARK_TO_SCROLL_ON_INIT(addon, frame)
end

-- ARK_DECOMPOSITION_SCROLL
function ARK_TO_SCROLL_SELECT_TARGET_ITEM(scrollItem)	
	if session.colonywar.GetIsColonyWarMap() == true then
        ui.SysMsg(ClMsg('CannotUseInPVPZone'));
        return;
    end

	if IsPVPServer() == 1 then	
		ui.SysMsg(ScpArgMsg('CantUseThisInIntegrateServer'));
		return;
	end

	local rankresetFrame = ui.GetFrame("rankreset");
	if 1 == rankresetFrame:IsVisible() then
		ui.SysMsg(ScpArgMsg('CannotDoAction'));
		return;
	end
	
	local frame = ui.GetFrame("ark_to_scroll");
	local scrollObj = GetIES(scrollItem:GetObject());		
	
	local scrollType = TryGetProp(scrollObj, 'StringArg', 'None');
	if scrollType == 'None' then
		return
	end
	local scrollGuid = GetIESGuid(scrollObj);
	frame:SetUserValue("ScrollType", scrollType)
	frame:SetUserValue("ScrollGuid", scrollGuid)
	
	if scrollObj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ScpArgMsg('LessThanItemLifeTime'));
		return;
	end

	ARK_TO_SCROLL_CANCEL();	
	ARK_TO_SCROLL_UI_INIT();
	ARK_TO_SCROLL_UI_RESET();
	frame:ShowWindow(1);
	
	ui.GuideMsg("DropItemPlz");

	local invframe = ui.GetFrame("inventory");
	local gbox = invframe:GetChild("inventoryGbox");
	ui.SetEscapeScp("ARK_TO_SCROLL_CANCEL()");
		
	local tab = gbox:GetChild("inventype_Tab");	
	tolua.cast(tab, "ui::CTabControl");
	tab:SelectTab(1);

	SET_SLOT_APPLY_FUNC(invframe, "ARK_TO_SCROLL_CHECK_TARGET_ITEM", nil, "Equip");
	INVENTORY_SET_CUSTOM_RBTNDOWN("ARK_TO_SCROLL_INV_RBTN");
end

function ARK_TO_SCROLL_TARGET_ITEM_SLOT(slot, invItem, scrollClsID)
	local itemCls = GetClassByType("Item", invItem.type);

	local type = itemCls.ClassID;
	local obj = GetIES(invItem:GetObject());
	local img = GET_ITEM_ICON_IMAGE(obj);
	SET_SLOT_IMG(slot, img)
	SET_SLOT_COUNT(slot, count)
	SET_SLOT_IESID(slot, invItem:GetIESID())
	
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	iconInfo.type = type;

	icon:SetTooltipType('wholeitem');
	icon:SetTooltipArg("", TryGetProp(itemCls, "ClassID", 0), invItem:GetIESID());
	icon:SetTooltipOverlap(1)
end

function ARK_TO_SCROLL_EXEC_ASK_AGAIN(frame, btn)
	local scrollType = frame:GetUserValue("ScrollType")
	local clickable = frame:GetUserValue("EnableTranscendButton")
	if tonumber(clickable) ~= 1 then
		return;
	end

	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		ui.MsgBox(ScpArgMsg("DropItemPlz"));
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_BTN_OVER_SOUND"));
		return;
	end

	local itemObj = GetIES(invItem:GetObject());

	local scrollGuid = frame:GetUserValue("ScrollGuid")
	local scrollInvItem = session.GetInvItemByGuid(scrollGuid);
	if scrollInvItem == nil then		
		return;
	end
	
	local yesscp = 'ARK_TO_SCROLL_EXEC'

	local option = {}
	option.ChangeTitle = "TitleArkToScroll"
	option.CompareTextColor = nil
	option.CompareTextDesc =  ScpArgMsg('ReallyArkToScroll','item', itemObj.Name)

	WARNINGMSGBOX_EX_FRAME_OPEN(frame, nil, 'ReallyArkToScroll2' .. ';ArkExtraction/' .. yesscp, 0, option)
end

function ARK_TO_SCROLL_RESULT(isSuccess)
	local frame = ui.GetFrame("ark_to_scroll");
	if isSuccess == 1 then
		local animpic_bg = GET_CHILD_RECURSIVELY(frame, "animpic_bg");
		animpic_bg:ShowWindow(1);
		animpic_bg:ForcePlayAnimation();
		ReserveScript("ARK_TO_SCROLL_CHANGE_BUTTON()", 0.3);
	else
		ARK_TO_SCROLL_RESULT_UPDATE(frame, 0);
	end
	
	ARK_TO_SCROLL_LOCK_ITEM("None");
	
	local slot = GET_CHILD(frame, "slot");
	local icon = slot:GetIcon();
	icon:SetTooltipType("None");
	icon:SetTooltipArg("", 0, "");
	ReserveScript("ARK_TO_SCROLL_CHANGE_TOOLTIP()", 0.3);
end

function ARK_TO_SCROLL_CHANGE_TOOLTIP()
	local frame = ui.GetFrame("ark_to_scroll");
	local slot = GET_CHILD(frame, "slot");
	local icon = slot:GetIcon();
	local invItem = GET_SLOT_ITEM(slot);
	if invItem ~= nil then
		local obj = GetIES(invItem:GetObject());
		icon:SetTooltipType("wholeitem");
		icon:SetTooltipArg("", 0, invItem:GetIESID());
	end
end

function ARK_TO_SCROLL_CHANGE_BUTTON()
	local frame = ui.GetFrame("ark_to_scroll");
	local button_transcend = frame:GetChild("button_transcend");	
	local button_close = frame:GetChild("button_close");	
	button_transcend:ShowWindow(0);	
	button_close:ShowWindow(1);	
end

function ARK_TO_SCROLL_RESULT_UPDATE(frame, isSuccess)
	local slot = GET_CHILD(frame, "slot");
	
	local timesecond = 0;
	if isSuccess == 1 then
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_SUCCESS_SOUND"));
		slot:StopActiveUIEffect();
		slot:PlayActiveUIEffect();
		timesecond = 2;
	else
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_FAIL_SOUND"));
		local slot_temp = GET_CHILD(frame, "slot_temp");
		slot_temp:ShowWindow(1);
		slot_temp:StopActiveUIEffect();
		slot_temp:PlayActiveUIEffect();
		timesecond = 1;
	end
	
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		slot:ClearIcon();
		return;
	end
	
	frame:StopUpdateScript("TIMEWAIT_STOP_ark_to_scroll");
	frame:RunUpdateScript("TIMEWAIT_STOP_ark_to_scroll", timesecond);
end

function TIMEWAIT_STOP_ark_to_scroll()
	local frame = ui.GetFrame("ark_to_scroll");
	local slot_temp = GET_CHILD(frame, "slot_temp");
	slot_temp:ShowWindow(0);
	slot_temp:StopActiveUIEffect();
	
	frame:StopUpdateScript("TIMEWAIT_STOP_ark_to_scroll");
	return 1;
end

function ARK_TO_SCROLL_BG_ANIM_TICK(ctrl, str, tick)
	if tick == 10 then
		local frame = ctrl:GetTopParentFrame();
		local animpic_slot = GET_CHILD_RECURSIVELY(frame, "animpic_slot");
		animpic_slot:ForcePlayAnimation();	
		ReserveScript("ARK_TO_SCROLL_EFFECT()", 0.3);
	end
end

function ARK_TO_SCROLL_EFFECT()
	local frame = ui.GetFrame("ark_to_scroll");
	ARK_TO_SCROLL_RESULT_UPDATE(frame, 1);	
end

function ARK_TO_SCROLL_EXEC()
	local frame = ui.GetFrame("ark_to_scroll");		
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_EVENT_EXEC"));
	frame:SetUserValue("EnableTranscendButton", 0);
	
	local slot = GET_CHILD(frame, "slot");
	local targetItem = GET_SLOT_ITEM(slot);
	local scrollGuid = frame:GetUserValue("ScrollGuid")
	
	session.ResetItemList();		
	session.AddItemID(targetItem:GetIESID());
	session.AddItemID(scrollGuid);	
	local resultlist = session.GetItemIDList();
	item.DialogTransaction("ITEM_ARK_TO_SCROLL", resultlist);
	
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_CAST"));
end

function ARK_TO_SCROLL_CANCEL()
	ARK_TO_SCROLL_LOCK_ITEM("None");
end

function ARK_TO_SCROLL_CLOSE()
	local frame = ui.GetFrame("ark_to_scroll");
	frame:SetUserValue("ScrollType", "None")
	frame:SetUserValue("ScrollGuid", "None")	
	frame:OpenFrame(0);
	
	ui.RemoveGuideMsg("DropItemPlz");
	ui.SetEscapeScp("");

	ARK_TO_SCROLL_LOCK_ITEM("None")
	ARK_TO_SCROLL_UI_RESET();
	ARK_TO_SCROLL_CANCEL();
	
	local invframe = ui.GetFrame("inventory");
	SET_SLOT_APPLY_FUNC(invframe, "None");
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
end

function ARK_TO_SCROLL_LOCK_ITEM(guid)
	local lockItemGuid = nil;
	local frame = ui.GetFrame("ark_to_scroll");
	if frame ~= nil and guid == "None" then
		local slot = GET_CHILD_RECURSIVELY(frame, "slot");
		if slot ~= nil then
			local icon = slot:GetIcon();
			if icon ~= nil then
				tolua.cast(icon, "ui::CIcon");
				lockItemGuid = icon:GetInfo():GetIESID();
			end
		end
	end

	if lockItemGuid == nil then
		lockItemGuid = guid;
	end

	if lockItemGuid == "None" then
		return;
	end

	local invframe = ui.GetFrame("inventory");
	if invframe == nil then return; end
	invframe:SetUserValue("ITEM_GUID_IN_ark_to_scroll", guid);
end

function ARK_TO_SCROLL_UI_INIT()
	local frame = ui.GetFrame("ark_to_scroll");
	local scrollGuid = frame:GetUserValue("ScrollGuid")	
	local scrollInvItem = session.GetInvItemByGuid(scrollGuid);
	if scrollInvItem == nil then
		return
	end
	local scrollObj = GetIES(scrollInvItem:GetObject());

	local button_close = GET_CHILD(frame, "button_close");	
	button_close:ShowWindow(1);
	
	local transcend_gb = GET_CHILD_RECURSIVELY(frame, "transcend_gb");
	transcend_gb:ShowWindow(1);
	
	local text_desc = GET_CHILD_RECURSIVELY(frame, "text_desc");		
	text_desc:ShowWindow(1);	

	local main_gb = GET_CHILD_RECURSIVELY(frame, "main_gb");
	main_gb:ShowWindow(0);
end

function ARK_TO_SCROLL_UI_RESET()
	local frame = ui.GetFrame("ark_to_scroll");

	local slot = GET_CHILD(frame, "slot");
	slot:ClearIcon();

	local text_name = GET_CHILD(frame, "text_name");
	local text_itemtranscend = frame:GetChild("text_itemtranscend");	
		
	text_name:ShowWindow(0);	
end

function ARK_TO_SCROLL_INV_RBTN(itemObj, slot)	
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());

	local invframe = ui.GetFrame("inventory");
	ARK_TO_SCROLL_SET_TARGET_ITEM(invframe, invItem)
end

function ARK_TO_SCROLL_ITEM_DROP(parent, ctrl)
	local liftIcon = ui.GetLiftIcon();
	local iconInfo = liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());	
	if nil == invItem then
		return;
	end

	local invframe = ui.GetFrame("inventory");
	ARK_TO_SCROLL_SET_TARGET_ITEM(invframe, invItem)
end

function ARK_TO_SCROLL_SET_TARGET_ITEM(invframe, invItem)
	local frame = ui.GetFrame("ark_to_scroll");

	local button_transcend = GET_CHILD(frame, "button_transcend");	
	local button_close = GET_CHILD(frame, "button_close");
	button_close:ShowWindow(0);	
	button_transcend:ShowWindow(1);	
	
	local slot_temp = GET_CHILD(frame, "slot_temp");
	slot_temp:StopActiveUIEffect();
	slot_temp:ShowWindow(0);	

	local scrollGuid = frame:GetUserValue("ScrollGuid")
	local scrollInvItem = session.GetInvItemByGuid(scrollGuid);
	if scrollInvItem == nil then
		return;
	end

	if true == invItem.isLockState or true == scrollInvItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local invframe = ui.GetFrame("inventory");
	if true == IS_TEMP_LOCK(invframe, invItem) or true == IS_TEMP_LOCK(invframe, scrollInvItem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local scrollObj = GetIES(scrollInvItem:GetObject());	
	local itemObj = GetIES(invItem:GetObject());

	local ret, msg = item_goddess_craft.is_able_to_decompose_ark(scrollObj, itemObj)
	if ret == false then
		ui.SysMsg(ClMsg(msg))
		return
	end

	local text_name = GET_CHILD_RECURSIVELY(frame, "text_name")			
	
	local slot = GET_CHILD(frame, "slot");
	
	text_name:SetTextByKey("value", "");
	text_name:SetTextByKey("value", itemObj.Name)
	text_name:ShowWindow(1);

	ARK_TO_SCROLL_CANCEL();
	ARK_TO_SCROLL_TARGET_ITEM_SLOT(slot, invItem, scrollObj.ClassID);
	ARK_TO_SCROLL_LOCK_ITEM(invItem:GetIESID())

	frame:SetUserValue("EnableTranscendButton", 1);	
	frame:OpenFrame(1);
end

function ARK_TO_SCROLL_CHECK_TARGET_ITEM(slot)	
	local frame = ui.GetFrame("ark_to_scroll");	
	local item = GET_SLOT_ITEM(slot);	
	if item ~= nil then
		local obj = GetIES(item:GetObject());		
		local scrollGuid = frame:GetUserValue("ScrollGuid")
    	local scrollInvItem = session.GetInvItemByGuid(scrollGuid);
    	if scrollInvItem == nil then
    		return;
    	end
		local scrollObj = GetIES(scrollInvItem:GetObject());
		local ret, msg = item_goddess_craft.is_able_to_decompose_ark(scrollObj, obj)		
		if ret == true then
			slot:GetIcon():SetGrayStyle(0);
		else			
			slot:GetIcon():SetGrayStyle(1);
		end
	end
end