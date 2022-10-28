
function TRY_CECK_BARRACK_SLOT_BY_COMPANION_EXCHANGE(select)
	local petCnt = session.pet.GetPetTotalCount();
	local availableSlotCnt = GET_MY_AVAILABLE_CHARACTER_SLOT();
	if petCnt >= availableSlotCnt then
		local frame = ui.GetFrame("companionhire");
		frame:SetUserValue("EXCHANGE_TIKET", select);
		EXEC_BUY_CHARACTER_SLOT();
		return;
	end

	local itemIES = "None"
	local itemCls = nil;
	
	if 1 == select then
		itemCls = GetClass('Item', 'JOB_VELHIDER_COUPON')
		local item = session.GetInvItemByName("JOB_VELHIDER_COUPON");
		if nil == item then
			return;
		end
		itemIES = item:GetIESID();
	elseif 2 == select then
		itemCls = GetClass('Item', 'JOB_HAWK_COUPON')
		local item = session.GetInvItemByName("JOB_HAWK_COUPON");
		if nil == item then
			return;
		end
		itemIES = item:GetIESID();
	elseif 3 == select then
		itemCls = GetClass('Item', 'steam_JOB_HOGLAN_COUPON')
		local item = session.GetInvItemByName("steam_JOB_HOGLAN_COUPON");
		if nil == item then
			return;
		end
		itemIES = item:GetIESID();
	end

	if nil == itemCls then
		return;
	end

	local monCls =	GetClass("Monster", itemCls.StringArg);
	local argList = string.format("%d", monCls.ClassID);
	pc.ReqExecuteTx_Item("SCR_USE_ITEM_COMPANION", itemIES, argList);
end
