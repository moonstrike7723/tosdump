
function RELIC_EXP_REFINE_ON_INIT(addon, frame)
	addon:RegisterMsg('RELIC_EXP_REFINE_EXECUTE', 'ON_RELIC_EXP_REFINE_EXECUTE')
end

function REQ_RELIC_EXP_REFINE_OPEN()
	local frame = ui.GetFrame('relic_exp_refine')
	frame:ShowWindow(1)
end

function RELIC_EXP_REFINE_OPEN(frame)
	CLEAR_EXP_REFINE_EXECUTE(frame)
end

function RELIC_EXP_REFINE_CLOSE(frame)

end

function CLEAR_EXP_REFINE_EXECUTE()
	local frame = ui.GetFrame('relic_exp_refine')
	if frame == nil then return end

	local clearBtn = GET_CHILD_RECURSIVELY(frame, 'clearBtn')
	clearBtn:ShowWindow(0)

	local refineBtn = GET_CHILD_RECURSIVELY(frame, 'refineBtn')
	refineBtn:ShowWindow(1)

	frame:SetUserValue('DO_REFINE', 0)
	UPDATE_RELIC_EXP_REFINE_UI(frame)
	RELIC_EXP_REFINE_SET_COUNT(frame)
end

function RELIC_EXP_REFINE_SET_COUNT(frame, slot)
	local requireCount = GET_CHILD_RECURSIVELY(frame, 'requireCount')
	local resultCount = GET_CHILD_RECURSIVELY(frame, 'resultCount')
	local refine_count = GET_TOTAL_REFINE_COUNT(frame)
	local max_refine_count = frame:GetUserIValue('MAX_REFINE_COUNT')
	if slot ~= nil and refine_count > max_refine_count then
		local refine_per = slot:GetUserIValue('REFINE_PER')
		local cur_count = slot:GetSelectCount()
		slot:SetSelectCount(cur_count - ((refine_count - max_refine_count) * refine_per))
		slot:SetUserValue('PREV_COUNT', slot:GetSelectCount())
		refine_count = max_refine_count
	end

	requireCount:SetTextByKey('value', refine_count * 10)
	resultCount:SetTextByKey('value', refine_count)

	local refineBtn = GET_CHILD_RECURSIVELY(frame, 'refineBtn')
	if refine_count > 0 then
		refineBtn:SetEnable(1)
	else
		refineBtn:SetEnable(0)
	end

	local cost_per = shared_item_relic.get_require_money_for_refine()
	local total_price = MultForBigNumberInt64(refine_count, cost_per)
	local price = GET_CHILD_RECURSIVELY(frame, 'price')
	price:SetTextByKey('value', GET_COMMAED_STRING(total_price))

	local cur_money_str = GET_TOTAL_MONEY_STR()
	local result_money = SumForBigNumberInt64(cur_money_str, '-' .. total_price)
	local inven_money = GET_CHILD_RECURSIVELY(frame, 'inven_money')
	inven_money:SetTextByKey('value', GET_COMMAED_STRING(result_money))

	SET_MATERIAL_COUNT_INFO_LIST(frame)
end

function GET_TOTAL_REFINE_COUNT(frame)
	local slotSet = GET_CHILD_RECURSIVELY(frame, 'slotlist', 'ui::CSlotSet')
	local count = 0
	for i = 0, slotSet:GetSlotCount() - 1 do
		local slot = slotSet:GetSlotByIndex(i)
		local refine_per = tonumber(slot:GetUserValue('REFINE_PER'))
		if refine_per == nil then
			break
		end
		count = count + math.floor(slot:GetSelectCount() / refine_per)
	end

	return count
end

function SET_MATERIAL_COUNT_INFO_LIST(frame)
	local OFFSET_Y = 10
	local HEIGHT = 65
	local slotSet = GET_CHILD_RECURSIVELY(frame, 'slotlist', 'ui::CSlotSet')
	local gbox = GET_CHILD_RECURSIVELY(frame, 'materialInfoGbox')
	gbox:RemoveAllChild()
	for i = 0, slotSet:GetSlotCount() - 1 do
		local slot = slotSet:GetSlotByIndex(i)
		local refine_per = tonumber(slot:GetUserValue('REFINE_PER'))
		if refine_per == nil then
			break
		end
		local cnt = slot:GetSelectCount()
		if cnt > 0 then
			local info = slot:GetIcon():GetInfo()
			local ctrlSet = gbox:CreateOrGetControlSet('item_point_price', 'PRICE' .. info.type.. i, 10, OFFSET_Y)
			local itemSlot = GET_CHILD(ctrlSet, 'itemSlot')
			local itemCount = GET_CHILD(itemSlot, 'itemCount')
			local icon = CreateIcon(itemSlot)
			icon:SetImage(info:GetImageName())
			local cntText = string.format('{#ffe400}{ds}{ol}{b}{s18}%d', cnt)
			itemCount:SetText(cntText)

			local itemPrice = GET_CHILD(ctrlSet, 'itemPrice')
			local text = string.format('{s18}{ol}{b} ▶{/} {@st204_green}%d{/}{/}{/}', math.floor(cnt / refine_per))
			itemPrice:SetText(text)
			OFFSET_Y = OFFSET_Y + HEIGHT
		end
	end
end

function UPDATE_RELIC_EXP_REFINE_UI(frame)
	local slotSet = GET_CHILD_RECURSIVELY(frame, 'slotlist', 'ui::CSlotSet')
	slotSet:ClearIconAll()

	local item_count = 0
	local req_item = session.GetInvItemByName('Relic_exp_token')
	if req_item ~= nil then
		item_count = req_item.count
	end

	frame:SetUserValue('MAX_REFINE_COUNT', math.floor(item_count / 10))

	local invItemList = session.GetInvItemList()
	local materialItemList = shared_item_relic.get_refine_material_list()
	FOR_EACH_INVENTORY(invItemList, function(invItemList, invItem, slotSet, materialItemList)
		local obj = GetIES(invItem:GetObject())
		local itemName = TryGetProp(obj, 'ClassName', 'None')
		if materialItemList[itemName] ~= nil then
			local slotindex = imcSlot:GetEmptySlotIndex(slotSet)
			if slotindex == 0 and imcSlot:GetFilledSlotCount(slotSet) == slotSet:GetSlotCount() then
				slotSet:ExpandRow()
				slotindex = imcSlot:GetEmptySlotIndex(slotSet)
			end
			
			local slot = slotSet:GetSlotByIndex(slotindex)
			local refine_point = materialItemList[itemName]
			local refine_per = 100 / refine_point
			local top_parent = slotSet:GetTopParentFrame()
			local max_refine_count = top_parent:GetUserIValue('MAX_REFINE_COUNT')
			local max_count = math.min(math.floor(invItem.count / refine_per) * refine_per, max_refine_count * refine_per)
			slot:SetMaxSelectCount(max_count)
			slot:SetUserValue('REFINE_PER', refine_per)
			slot:SetUserValue('PREV_COUNT', 0)
			local icon = CreateIcon(slot)
			icon:Set(obj.Icon, 'Item', invItem.type, slotindex, invItem:GetIESID(), invItem.count)
			local class = GetClassByType('Item', invItem.type)
			SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, obj, invItem.count)
			ICON_SET_INVENTORY_TOOLTIP(icon, invItem, 'poisonpot', class)
		end
	end, false, slotSet, materialItemList)

	local cnt = slotSet:GetRow() - tonumber(frame:GetUserConfig('DEFAULT_ROW'))
	for i = 1, cnt do
		local row_num = slotSet:GetRow()
		slotSet:AutoCheckDecreaseRow()
		if row_num == slotSet:GetRow() then
			break
		end
	end
end

function SCP_LBTDOWN_RELIC_EXP_REFINE(slotset, slot)
	ui.EnableSlotMultiSelect(1)
	local prev_count = slot:GetUserIValue('PREV_COUNT')
	local cur_count = slot:GetSelectCount()
	local refine_per = slot:GetUserIValue('REFINE_PER')
	slot:SetSelectCount(prev_count + ((cur_count - prev_count) * refine_per))
	slot:SetUserValue('PREV_COUNT', slot:GetSelectCount())
	local frame = slotset:GetTopParentFrame()
	RELIC_EXP_REFINE_SET_COUNT(frame, slot)
end

function SCP_RBTDOWN_RELIC_EXP_REFINE(slotset, slot)
	ui.EnableSlotMultiSelect(1)
	slot:SetSelectCount(0)
	slot:SetUserValue('PREV_COUNT', 0)
	local frame = slotset:GetTopParentFrame()
	RELIC_EXP_REFINE_SET_COUNT(frame)
end

function RELIC_EXP_REFINE_EXEC(frame)
	session.ResetItemList()

	local total_count = 0
	local slotSet = GET_CHILD_RECURSIVELY(frame, 'slotlist', 'ui::CSlotSet')
	if slotSet:GetSelectedSlotCount() < 1 then
		ui.MsgBox(ScpArgMsg('SelectSomeItemPlz'))
		return
	end

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon()
		local iconInfo = Icon:GetInfo()
		local cnt = slot:GetSelectCount()
		local refine_per = tonumber(slot:GetUserValue('REFINE_PER'))
		if refine_per == nil then
			break
		end
		total_count = total_count + math.floor(cnt / refine_per)
		session.AddItemID(iconInfo:GetIESID(), cnt)
	end

	local cost_per = shared_item_relic.get_require_money_for_refine()
	local total_money = MultForBigNumberInt64(total_count, cost_per)
	local my_money = GET_TOTAL_MONEY_STR()
    if IsGreaterThanForBigNumber(total_money, my_money) == 1 then
        ui.SysMsg(ClMsg('NotEnoughMoney'))
        return
	end
	
	local msg = ScpArgMsg('REALLY_DO_RELIC_EXP_MAT_REFINE', 'SILVER', GET_COMMAED_STRING(total_money), 'COUNT', total_count * 10, 'RESULT', total_count)
	local yesScp = '_RELIC_EXP_REFINE_EXEC()'
	ui.MsgBox(msg, yesScp, 'None')
end

function _RELIC_EXP_REFINE_EXEC(count)
	local frame = ui.GetFrame('relic_exp_refine')
	if frame == nil then return end

	local do_already = frame:GetUserIValue('DO_REFINE')
	if do_already == 1 then return end

	local resultlist = session.GetItemIDList()
	item.DialogTransaction('RELIC_REFINE_MATERIAL', resultlist, '')

	frame:SetUserValue('DO_REFINE', 1)
end

function ON_RELIC_EXP_REFINE_EXECUTE(frame, msg, argStr, argNum)
	local refineBtn = GET_CHILD_RECURSIVELY(frame, 'refineBtn')
	refineBtn:ShowWindow(0)

	local clearBtn = GET_CHILD_RECURSIVELY(frame, 'clearBtn')
	clearBtn:ShowWindow(1)
end