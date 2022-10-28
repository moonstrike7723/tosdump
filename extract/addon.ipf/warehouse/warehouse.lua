function WAREHOUSE_ON_INIT(addon, frame)

	REGISTER_WAREHOUSE_MSG(addon, frame);
	print('1');
end

function WAREHOUSE_OPEN(frame)
	packet.RequestItemList(IT_WAREHOUSE);
	ui.OpenFrame("inventory");
	INVENTORY_SET_CUSTOM_RBTNDOWN("WAREHOUSE_INV_RBTN")	
	local gbox = frame:GetChild("gbox");

	local t_useprice = frame:GetChild("t_useprice");
	t_useprice:SetTextByKey("value", WAREHOUSE_PRICE);
	
end
   
function WAREHOUSE_CLOSE(frame)
	ui.CloseFrame("inventory");
	TRADE_DIALOG_CLOSE();
	INVENTORY_SET_CUSTOM_RBTNDOWN("None")
end


function PUT_ITEM_TO_WAREHOUSE(parent, slot)

	local frame = parent:GetTopParentFrame();
	
	local liftIcon 			= ui.GetLiftIcon();
	local iconInfo			= liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());

	if invItem == nil then
		return;
	end
	local obj = GetIES(invItem:GetObject());
	
	if CHECK_EMPTYSLOT(frame, obj) == 1 then
		return
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	local itemCls = GetClassByType("Item", invItem.type);
	if itemCls.ItemType == 'Quest' then
		ui.MsgBox(ScpArgMsg("IT_ISNT_REINFORCEABLE_ITEM"));
		return;
	end
	
	if itemCls.LifeTime > 0 then
		ui.MsgBox(ScpArgMsg("IsItemLifeTime"));
		return;
	end

	
	AUTO_CAST(slot);

	local fromFrame = liftIcon:GetTopParentFrame();

	if fromFrame:GetName() == "inventory" then
		if invItem.count > 1 then
			INPUT_NUMBER_BOX(frame, ScpArgMsg("InputCount"), "EXEC_PUT_ITEM_TO_WAREHOUSE", invItem.count, 1, invItem.count, nil, tostring(invItem:GetIESID()));
		else
			item.PutItemToWarehouse(IT_WAREHOUSE, invItem:GetIESID(), invItem.count, frame:GetUserIValue("HANDLE"));
		end
	else
		local iconSlot = liftIcon:GetParent();
		AUTO_CAST(iconSlot);
		item.SwapSlotIndex(IT_WAREHOUSE, slot:GetSlotIndex(), iconSlot:GetSlotIndex());
		ON_WAREHOUSE_ITEM_LIST(frame);
	end

end

function EXEC_PUT_ITEM_TO_WAREHOUSE(frame, count, inputframe)
	inputframe:ShowWindow(0);
	local iesid = inputframe:GetUserValue("ArgString");
	item.PutItemToWarehouse(IT_WAREHOUSE, iesid, tonumber(count), frame:GetUserIValue("HANDLE"));
end

function ON_WAREHOUSE_ITEM_LIST(frame)

	if frame:IsVisible() == 0 then
		return;
	end

	local gbox = frame:GetChild("gbox");
	local slotset = gbox:GetChild("slotset");
	if slotset == nil then
		local gbox_warehouse = gbox:GetChild("gbox_warehouse");
			slotset = gbox_warehouse:GetChild("slotset");
		end

	AUTO_CAST(slotset);
	local etc = GetMyEtcObject();
	local slotCount = slotset:GetSlotCount();
	slotset:SetSlotCount(etc.MaxWarehouseCount);
	
	while slotCount < etc.MaxWarehouseCount  do 
		slotset:ExpandRow()
		slotCount = slotset:GetSlotCount();
	end
	UPDATE_ETC_ITEM_SLOTSET(slotset, IT_WAREHOUSE, "warehouse");
	
	if gbox_warehouse ~= nil then
		gbox_warehouse:UpdateData();
		gbox_warehouse:SetCurLine(0);	
		gbox_warehouse:InvalidateScrollBar();
		frame:Invalidate();
	end

end

function WAREHOUSE_INV_RBTN(itemObj, slot)
	
	local frame = ui.GetFrame("warehouse");
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	local obj = GetIES(invItem:GetObject());
	if CHECK_EMPTYSLOT(frame, obj) == 1 then
		return
	end


	local fromFrame = slot:GetTopParentFrame()
	
	if fromFrame:GetName() == "inventory" then
		if invItem.count > 1 then
			INPUT_NUMBER_BOX(frame, ScpArgMsg("InputCount"), "EXEC_PUT_ITEM_TO_WAREHOUSE", invItem.count, 1, invItem.count, nil, tostring(invItem:GetIESID()), 1);
		else
			item.PutItemToWarehouse(IT_WAREHOUSE, invItem:GetIESID(), invItem.count, frame:GetUserIValue("HANDLE"));
		end
	end
end

function PUT_ITEM_TO_INV(slotSet, slot)

	local fromFrame = slot:GetTopParentFrame();
	local toFrame = ui.GetFrame("inventory");

	local icon = slot:GetIcon()
	if icon == nil then
		return
	end
	local iconInfo = icon:GetInfo();
	local iesID = iconInfo:GetIESID();

	if iconInfo.count > 1 then	
		INPUT_NUMBER_BOX(toFrame, ScpArgMsg("InputCount"), "EXEC_TAKE_ITEM_FROM_WAREHOUSE", iconInfo.count, 1, iconInfo.count, nil, iesID, 1);
	else
		item.TakeItemFromWarehouse(IT_WAREHOUSE, iesID, iconInfo.count, fromFrame:GetUserIValue("HANDLE"));
	end
end

function WAREHOUSE_SORT()
	local context = ui.CreateContextMenu("CONTEXT_INV_SORT", "", 0, 0, 170, 100);
	local scpScp = string.format("REQ_INV_SORT(%d, %d)", IT_WAREHOUSE, BY_PRICE);
	ui.AddContextMenuItem(context, ScpArgMsg("SortByPrice"), scpScp);	
	scpScp = string.format("REQ_INV_SORT(%d, %d)", IT_WAREHOUSE, BY_LEVEL);
	ui.AddContextMenuItem(context, ScpArgMsg("SortByLevel"), scpScp);	
	scpScp = string.format("REQ_INV_SORT(%d, %d)",IT_WAREHOUSE, BY_WEIGHT);
	ui.AddContextMenuItem(context, ScpArgMsg("SortByWeight"), scpScp);	
	scpScp = string.format("REQ_INV_SORT(%d, %d)",IT_WAREHOUSE, BY_NAME);
	ui.AddContextMenuItem(context, ScpArgMsg("SortByName"), scpScp);	
	ui.OpenContextMenu(context);
end

function WAREHOUSE_EXTEND(frame, slot)
	
	local aObj = GetMyAccountObj();
	local etcObj = GetMyEtcObject();
	if nil == etcObj or nil == aObj then
		return;
	end

	local baseSlot = 60;
	local slotDiff = etcObj.MaxWarehouseCount - baseSlot;
	local extendCnt = 0;
	local price = WAREHOUSE_EXTEND_PRICE;
	if slotDiff > 0 then
		extendCnt = slotDiff / 10;
		if extendCnt >= tonumber(WAREHOUSE_MAX_COUNT) then
			ui.SysMsg(ScpArgMsg("WareHouseMax"))
			return;
		end
		price = GetPow(price/10, (extendCnt + 1));
		price = price * 10;
	end

	local str = ScpArgMsg("ExtendWarehouseSlot{TP}{SLOT}", "TP", price, "SLOT", tostring(WAREHOUSE_EXTEND_SLOT_COUNT));

	local yesScp = string.format("CHECK_USER_MEDAL_FOR_EXTEND_WAREHOUSE(%d)", price) 
	ui.MsgBox(str, yesScp, "None");

	DISABLE_BUTTON_DOUBLECLICK("warehouse","extend")

	end
	
function CHECK_USER_MEDAL_FOR_EXTEND_WAREHOUSE(price)
	if 0 > GET_CASH_TOTAL_POINT_C() - price then
		ui.SysMsg(ScpArgMsg("Auto_MeDali_BuJogHapNiDa."))
		return;
	end

	item.ExtendWareHouse(IT_WAREHOUSE);
end

function CHECK_EMPTYSLOT(frame, obj)

	local gbox = frame:GetChild("gbox");
	local slotset = gbox:GetChild("slotset");
	
	if slotset == nil then
		local gbox_warehouse = gbox:GetChild("gbox_warehouse");
		if gbox_warehouse ~= nil then
			slotset = gbox_warehouse:GetChild("slotset");
		end
	end

	AUTO_CAST(slotset);

	local wareItem = session.GetWarehouseItemByType(obj.ClassID);
	if wareItem ~= nil then
		if obj.MaxStack > 1 then
			return 0;
		end
	end

	local warehouseSlot = GET_EMPTY_SLOT(slotset);
	if warehouseSlot == nil then
		ui.SysMsg(ScpArgMsg("NoEmptySlot"))
		return 1;
	end

	return 0;
end