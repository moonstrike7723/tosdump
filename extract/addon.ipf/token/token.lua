function TOKEN_ON_INIT(addon, frame)
end

function BEFORE_APPLIED_TOKEN_OPEN(invItem)
	local frame = ui.GetFrame("token");
	if invItem.isLockState then 
		frame:ShowWindow(0)
		return;
	end

	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end
	local token_middle = GET_CHILD(frame, "token_middle", "ui::CPicture");
	token_middle:SetImage("token_middle");

	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	for i = 0 , 3 do
		local str, value = GetCashInfo(ITEM_TOKEN, i);
		if str ~= 'abilityMax' then
			local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);		
			local prop = ctrlSet:GetChild("prop");

			local normal = GetCashValue(0, str) 
			local txt = "None"
			if str == "marketSellCom" then
				normal = normal + 0.01;
				value = value + 0.01;
				local img = string.format("{img 67percent_image %d %d}",55, 45) 
				prop:SetTextByKey("value", img..ClMsg(str)); 
				txt = string.format("{img 67percent_image2 %d %d}", 100, 45) 
			elseif str == "speedUp"then
				local img = string.format("{img 3plus_image %d %d}", 55, 45) 
				prop:SetTextByKey("value",img.. ClMsg(str)); 
				txt = string.format("{img 3plus_image2 %d %d}", 100, 45) 
			else
				local img = string.format("{img 9plus_image %d %d}", 55, 45) 
				prop:SetTextByKey("value", img..ClMsg(str)); 
				txt = string.format("{img 9plus_image2 %d %d}", 100, 45) 
			end

			local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
			value:SetTextByKey("value", txt); 
		end
	end

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 4,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	local imag = string.format(TOKEN_GET_IMGNAME1(), 55, 45) 
	prop:SetTextByKey("value", imag.. ScpArgMsg("Token_ExpUp{PER}", "PER", " ")); 
	local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
	imag = string.format(TOKEN_GET_IMGNAME2(), 100, 45) 
	value:SetTextByKey("value", imag); 
	
	local itemobj = GetIES(invItem:GetObject());
	if itemobj.NumberArg2 > 0 then
		local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_TOKEN_TRADECOUNT",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local prop = GET_CHILD(ctrlSet, "prop");
		local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
		local img = string.format("{img dealok_image %d %d}", 55, 45) 
		prop:SetTextByKey("value", img .. ScpArgMsg("AllowTradeByCount"));
		value:SetTextByKey("value", '');
	else
		gBox:RemoveChild("CTRLSET_TOKEN_TRADECOUNT");	
	end	

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 5,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img paid_pose_image %d %d}", 55, 45) 
    prop:SetTextByKey("value", imag..ClMsg("AllowPremiumPose")); 
    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
    value:ShowWindow(0);

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 6,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img Immediately_image %d %d}", 55, 45)
    prop:SetTextByKey("value", imag..ClMsg("CanGetMoneyByMarketImmediately")); 
    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
    value:ShowWindow(0);

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 7,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img MarketLimitedRM_image %d %d}", 55, 45)
    prop:SetTextByKey("value", imag..ClMsg("CanRegisterMarketRegradlessOfLimit")); 
    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
    value:ShowWindow(0);

    local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 8,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img teamcabinet_image %d %d}", 55, 45)
    prop:SetTextByKey("value", imag..ClMsg("TeamWarehouseEnable")); 
    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
	value:ShowWindow(0);
	
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 9,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	local imag = string.format("{img dealok_image %d %d}", 55, 45)
	prop:SetTextByKey("value", imag..ClMsg("CanUseIcorMultiple"));
	local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
	value:ShowWindow(0);

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 10,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	local imag = string.format("{img worldmaptoken_image %d %d}", 55, 45)
	prop:SetTextByKey("value", imag..ClMsg("CanUseWorldMapToken"));
	local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
	value:ShowWindow(0);

--    local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 9,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
--    local prop = ctrlSet:GetChild("prop");
--    local imag = string.format("{img 1plus_image %d %d}", 55, 45)
--    prop:SetTextByKey("value", imag..ClMsg("Mission_Reward")); 
--    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
--    value:ShowWindow(0);

--    local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 10,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
--    local prop = ctrlSet:GetChild("prop");
--    local imag = string.format("{img 2minus_image %d %d}", 55, 45)
--    prop:SetTextByKey("value", imag..ClMsg("RaidStance")); 
--    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
--    value:ShowWindow(0);

	ADD_2PLUS_IMAGE(gBox)

	GBOX_AUTO_ALIGN(gBox, 0, 2, 0, true, false);
  -- 혹시나 저처럼 고생하시는 분이 생길가 적습니다. 해당 부분은 토큰의 실제 적용 시간에 여유분을 두기 때문에 UI 상 출력시간을 보정하는 곳입니다.
  -- 여기 작성 안하면 계속 시간이 이상하게 나올거에요
	local arg1 = itemobj.NumberArg1;
	if itemobj.ClassName == "PremiumToken" or itemobj.ClassName == "PremiumToken_event" or itemobj.ClassName == "PremiumToken_New_Return" then
		arg1 = 2592000 --30일
	elseif itemobj.ClassName == "PremiumToken_5d" or itemobj.ClassName == "PremiumToken_5d_Steam" or itemobj.ClassName == "PremiumToken_5d_event" then
		arg1 = 432000 -- 5일
	elseif itemobj.ClassName == "PremiumToken_1d" or itemobj.ClassName == "PremiumToken_7d_Steam" then
		arg1 = 604800 -- 7일
	elseif itemobj.ClassName == "PremiumToken_24h" then
		arg1 = 86400 -- 1일
	elseif itemobj.ClassName == "PremiumToken_3d" or itemobj.ClassName == "PremiumToken_3d_Steam" or itemobj.ClassName == "PremiumToken_3d_event" then
		arg1 = 259200 -- 3일
	elseif itemobj.ClassName == "PremiumToken_12h" then
		arg1 = 43200 -- 12시간
	elseif itemobj.ClassName == "PremiumToken_6h" then
		arg1 = 21600 -- 6시간
	elseif itemobj.ClassName == "PremiumToken_3h" or itemobj.ClassName == "PremiumToken_3h_event" then
		arg1 = 10800 -- 3시간
	elseif itemobj.ClassName == "PremiumToken_15d" or itemobj.ClassName == "PremiumToken_15d_Steam" or itemobj.ClassName == "PremiumToken_15d_vk" then
		arg1 = 1296000 -- 15일
	elseif itemobj.ClassName == "PremiumToken_14d_event" then
		arg1 = 1209600 -- 14일
	elseif itemobj.ClassName == "PremiumToken_30d" then
		arg1 = 2592000 -- 30O
	elseif itemobj.ClassName == "PremiumToken_60d" then
		arg1 = 5184000 -- 60O
	elseif itemobj.ClassName == "steam_PremiumToken_30day" then
		arg1 = 2592000 -- 30O
	elseif itemobj.ClassName == "steam_PremiumToken_60d" then
		arg1 = 5184000 -- 60O
	elseif itemobj.ClassName == "steam_PremiumToken_7d" then
		arg1 = 604800 -- 70
	end
	local endTime = GET_TIME_TXT(arg1, 1)
	local endTxt = frame:GetChild("endTime");
	endTxt:SetTextByKey("value", endTime); 

	local strTxt = frame:GetChild("richtext_1");
	strTxt:SetTextByKey("value", ClMsg(itemobj.ClassName)); 

	local bg2 = frame:GetChild("bg2");

	local strTxt = bg2:GetChild("str");
	strTxt:SetTextByKey("value", ClMsg(itemobj.ClassName)); 

	local endTxt2 = bg2:GetChild("endTime2");
	endTxt2:SetTextByKey("value2", endTime); 
	endTxt2:SetTextByKey("value", ClMsg(itemobj.ClassName)..ScpArgMsg("Premium_itemEun")); 
    endTxt2:SetTextByKey("value3", ScpArgMsg("Premium_team")); 
    endTxt2:ShowWindow(1);

	local indunStr = bg2:GetChild("indunStr");
	indunStr:ShowWindow(0);

	local forToken = bg2:GetChild("forToken");
	forToken:ShowWindow(1);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
	GBOX_AUTO_ALIGN(bg2, 10, 3, 10, true, true);
	bg2:Resize(bg2:GetWidth(), 800);
	frame:Resize(frame:GetWidth(), 830);
end

function ADD_2PLUS_IMAGE(gBox)
	--do nothing : for override
end

function TOKEN_GET_IMGNAME1()
	return "{img 50percent_image_1 %d %d}"
end

function TOKEN_GET_IMGNAME2()
	return "{img 50percent_image3 %d %d}"
end

function BEFORE_APPLIED_BOOST_TOKEN_OPEN(invItem)
	local obj = GetIES(invItem:GetObject());
	
	if obj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ScpArgMsg('LessThanItemLifeTime'));
		return;
	end
	
	local frame = ui.GetFrame("token");
	if invItem.isLockState then 
		frame:ShowWindow(0)
		return;
	end

	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end

	local token_middle = GET_CHILD(frame, "token_middle", "ui::CPicture");
	token_middle:SetImage("expup_middle");
	local itemobj = GetIES(invItem:GetObject());
	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	
	local exp_rate = TryGetProp(itemobj, 'NumberArg2', 0)
	local string_arg = TryGetProp(itemobj, 'StringArg', 'None')
	local stamina_multiply = TryGetProp(itemobj, 'NumberArg3', 0)

    -- 1번 컨트롤셋
    local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_0",  ui.CENTER_HORZ, ui.TOP, 10, 0, 0, 0);    
	local prop = ctrlSet:GetChild("prop");
	local imag = string.format("{img 30percent_image %d %d}", 55, 45);
	
	if string_arg ~= 'None' and string.find(string_arg, 'Premium_boostToken') ~= nil and exp_rate > 0 then
		imag = string.format("{img %dpercent_image %d %d}", exp_rate, 55, 45);		
    else
        imag = string.format("{img 30percent_image %d %d}", 55, 45);
    end
    prop:SetTextByKey("value", imag .. ClMsg("token_expup"));
    
	local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");	
	if string_arg ~= 'None' and string.find(string_arg, 'Premium_boostToken') ~= nil and exp_rate > 0 then
		value:SetTextByKey("value", string.format("{img %dpercent_image2 %d %d}", exp_rate, 100, 45) );
	else
    	value:SetTextByKey("value", string.format("{img 30percent_image2 %d %d}", 100, 45) );
    end

    -- 2번 컨트롤셋
    local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_1",  ui.CENTER_HORZ, ui.TOP, 10, 0, 0, 0);    
	local prop = ctrlSet:GetChild("prop");
	if string_arg ~= 'None' and string.find(string_arg, 'Premium_boostToken') ~= nil and stamina_multiply > 0 then
		imag = string.format("{img %dmultiply_image %d %d}", stamina_multiply, 55, 45);
	else
    	imag = string.format("{img 2multiply_image %d %d}", 55, 45) 
    end	
    prop:SetTextByKey("value",imag .. ClMsg("token_staup"));
    
	local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
	local itemobj = GetIES(invItem:GetObject());
	
	if string_arg ~= 'None' and string.find(string_arg, 'Premium_boostToken') ~= nil and stamina_multiply > 0 then
		value:SetTextByKey("value", string.format("{img %dmultiply_image2 %d %d}", stamina_multiply, 100, 45) );
	else
    	value:SetTextByKey("value", string.format("{img 2plus_image2 %d %d}", 100, 45) );
    end

	GBOX_AUTO_ALIGN(gBox, 0, 2, 0, true, false);
	local itemobj = GetIES(invItem:GetObject());
	local arg1 = itemobj.NumberArg1 / 1000;
	local endTime = GET_TIME_TXT(arg1, 1);
	local endTxt = frame:GetChild("endTime");
	endTxt:SetTextByKey("value", endTime);

	local strTxt = frame:GetChild("richtext_1");
	strTxt:SetTextByKey("value", ClMsg(itemobj.ClassName)); 
	
	local bg2 = frame:GetChild("bg2");
	local strTxt = bg2:GetChild("str");
    strTxt:SetTextByKey("value", "["..ClMsg(itemobj.ClassName).."]");
	
		-- 제작재료인지 확인
    if IS_VALID_RECIPE_MATERIAL_FOR_BOOSTTOKEN("Premium_boostToken", itemobj) == true then
        local margin = strTxt:GetMargin()
        strTxt:SetTextByKey("value", ClMsg("MaterialOfBoostToken1").."{nl}".."["..ClMsg(itemobj.ClassName).."]");
	elseif IS_VALID_RECIPE_MATERIAL_FOR_BOOSTTOKEN("Premium_boostToken02", itemobj) == true then
        local margin = strTxt:GetMargin()
		strTxt:SetTextByKey("value", ClMsg("MaterialOfBoostToken2").."{nl}".."["..ClMsg(itemobj.ClassName).."]");
	else
		local target_item = GET_PREMIUM_BOOSTTOKEN_TARGET(string_arg)
		if target_item ~= nil then
			strTxt:SetTextByKey("value", ScpArgMsg("MaterialOf{name}BoostToken", 'name', ClMsg(target_item)).."{nl}".."["..ClMsg(itemobj.ClassName).."]");
		end
    end

	local endTxt2 = bg2:GetChild("endTime2");
	endTxt2:SetTextByKey("value2", endTime); 
	endTxt2:SetTextByKey("value", ClMsg(itemobj.ClassName)..ScpArgMsg("Premium_itemEun"));
	endTxt2:SetTextByKey("value3", ScpArgMsg("Premium_character")); 
	endTxt2:ShowWindow(1);

	local indunStr = bg2:GetChild("indunStr");
	indunStr:ShowWindow(0);

	local forToken = bg2:GetChild("forToken");
	forToken:ShowWindow(0);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
	
	bg2:Resize(bg2:GetWidth(), 500);
	frame:Resize(frame:GetWidth(), 550);
end

function BEFORE_APPLIED_INDUNRESET_OPEN(invItem)
	local frame = ui.GetFrame("token");
	if invItem.isLockState then 
		frame:ShowWindow(0)
		return;
	end

	local obj = GetIES(invItem:GetObject());
	
	if obj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ScpArgMsg('LessThanItemLifeTime'));
		return;
	end

	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end

	local token_middle = GET_CHILD(frame, "token_middle", "ui::CPicture");
	token_middle:SetImage("indunFreeEnter_middle");

	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_INDUNFREE",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");

	if obj.ClassName == 'Premium_indunReset_1add' or obj.ClassName == 'Premium_indunReset_1add_14d' or obj.ClassName == 'indunReset_1add_14d_NoStack' or obj.ClassName == 'Event_1704_Premium_indunReset_1add' or obj.ClassName == 'indunReset_1add_14d_NoStack_Team' then
	    prop:SetTextByKey("value", ClMsg('Indun1AddText'));
	else
	    prop:SetTextByKey("value", ClMsg('IndunRestText'));
	end
	
	local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
	value:ShowWindow(0);
	

	GBOX_AUTO_ALIGN(gBox, 0, 2, 0, true, false);
	local itemobj = GetIES(invItem:GetObject());
	local endTxt = frame:GetChild("endTime");
	endTxt:ShowWindow(0);
	
	local strTxt = frame:GetChild("richtext_1");
	strTxt:SetTextByKey("value", GetClassString('Item', itemobj.ClassName, 'Name')); 

	local bg2 = frame:GetChild("bg2");
	local indunStr = bg2:GetChild("indunStr");
	indunStr:SetTextByKey("value", GetClassString('Item', itemobj.ClassName, 'Name')..ScpArgMsg("Premium_itemEun")); 
    indunStr:SetTextByKey("value2", ScpArgMsg("Premium_character")); 
    indunStr:ShowWindow(1);

	local endTime2 = bg2:GetChild("endTime2");
	endTime2:ShowWindow(0);

	local strTxt = bg2:GetChild("str");
	strTxt:SetTextByKey("value", GetClassString('Item', itemobj.ClassName, 'Name')); 

	local forToken = bg2:GetChild("forToken");
	forToken:ShowWindow(1);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
	bg2:Resize(bg2:GetWidth(), 440);
	frame:Resize(frame:GetWidth(), 500);
end

function BEFORE_APPLIED_INDUNFREE_OPEN(invItem)
	local frame = ui.GetFrame("token");
	if invItem.isLockState then 
		frame:ShowWindow(0)
		return;
	end

	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end
	local token_middle = GET_CHILD(frame, "token_middle", "ui::CPicture");
	token_middle:SetImage("token_middle");

	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_INDUNFREE",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	prop:SetTextByKey("value", ClMsg('IndunFreeTImeText'));
	local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
	value:ShowWindow(0);
	

	GBOX_AUTO_ALIGN(gBox, 0, 3, 0, true, false);
	local itemobj = GetIES(invItem:GetObject());
	local arg1 = 259200 -- 3일
	local endTime = GET_TIME_TXT(arg1, 1)
	local endTxt = frame:GetChild("endTime");
	endTxt:SetTextByKey("value", endTime); 

	local endTxt2 = frame:GetChild("endTime2");

	endTxt2:SetTextByKey("value2", endTime); 
	endTxt2:SetTextByKey("value", ClMsg(itemobj.ClassName)..ScpArgMsg("Premium_itemEun")); 
    endTxt2:SetTextByKey("value3", ScpArgMsg("Premium_character")); 
    
	local strTxt = frame:GetChild("str");
	strTxt:SetTextByKey("value", ClMsg(itemobj.ClassName)); 

	local strTxt = frame:GetChild("richtext_1");
	strTxt:SetTextByKey("value", ClMsg(itemobj.ClassName)); 

	local forToken = frame:GetChild("forToken");
	forToken:ShowWindow(1);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
	local bg2 = frame:GetChild("bg2");
	bg2:Resize(bg2:GetWidth(), 440);
	frame:Resize(frame:GetWidth(), 500);
end

function REQ_TOKEN_ITEM(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	TOKEN_SELEC_CANCLE(frame);
	
	local itemIES = frame:GetUserValue("itemIES");
	local argList = string.format("%s", frame:GetUserValue("ClassName"));
	local itemName = ClMsg(argList);
	
	if argList == 'Premium_indunFreeEnter' then
		local etcObj = GetMyEtcObject();
		if etcObj.IndunFreeTime ~= 'None' then
			ui.MsgBox(ScpArgMsg("IsAppliedIndunFreeEnter"));
			return;
		end

		pc.ReqExecuteTx_Item("SCR_USE_ITEM_INDUN_FREE", itemIES, argList);
		return;
	end
	local indunResetItemList = {'Premium_indunReset','Premium_indunReset_14d','Premium_indunReset_14d_test','Premium_indunReset_1add','Premium_indunReset_1h',
								'Premium_indunReset_1add_14d','Premium_indunReset_TA','indunReset_1add_14d_NoStack','Event_1704_Premium_indunReset_1add','Event_1704_Premium_indunReset',
								'indunReset_1add_14d_NoStack_Team','Event_indunReset_Team_14d',
								'Event_indunReset_Team_1','Event_indunReset_Team_2','Event_indunReset_Team_3','Event_indunReset_Team_4',
								'Event_indunReset_Team_5','Event_indunReset_Team_6','Event_indunReset_Team_7','Event_indunReset_Team_8','Event_indunReset_Team_9','Event_indunReset_Team_10',
								'Event_indunReset_Team_11', 'Tuto_indunReset_Team', 'Event_indunReset_Team_12', 'Event_indunReset_Team_13', 'Event_indunReset_Team_14','Event_indunReset_Team_15',
								'Event_indunReset_Team_16','Event_indunReset_Team_17','Event_indunReset_Team_18','Event_indunReset_Team_18','Event_indunReset_Team_19','Event_indunReset_Team_205',
								'Event_indunReset_Team_25','Event_indunReset_Team_30','Event_indunReset_Team_31','Event_indunReset_Team_32','Event_indunReset_Team_33','Event_indunReset_Team_34',
								'Event_indunReset_Team_37','Event_indunReset_Team_38','Event_indunReset_Team_39','Event_indunReset_Team_41','Event_indunReset_limit',
								'Event_indunReset_limit_1','Event_indunReset_limit_2','SEASONLETICIA_Premium_indunReset_TA'}
	if table.find(indunResetItemList,argList) ~= 0 then
		local etcObj = GetMyEtcObject();
		-- 2개뿐이여서 고정으로 넣어둠
		local countType1 = "InDunCountType_100";
		local countType2 = "InDunCountType_200";
		if etcObj[countType1] == 0 and etcObj[countType2] == 0 then
			ui.MsgBox(ScpArgMsg("IsApplied_indunReset"));
			return;
		end
		
		pc.ReqExecuteTx_Item("SCR_USE_ITEM_INDUN_RESET", itemIES, argList);
		return;
	end
	
	local find = string.find(argList, "PremiumToken");
	if find ~= nil then
		if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
			local str = ScpArgMsg("IsAppliedToken");
			local yesScp = string.format("pc.ReqExecuteTx_Item(\"%s\",\"%s\",\"%s\")", "SCR_USE_ITEM_TOKEN", itemIES, argList);
			ui.MsgBox(str, yesScp, "None");
			return;
		end
	else
		find = string.find(argList, 'Premium_boostToken') -- 경험의 서라면
		if find ~= nil then			
			local cls = GetClass('Item', argList)
			local myHandle = session.GetMyHandle();
			local buff = info.GetBuffByName(myHandle, 'Premium_boostToken');
			if buff ~= nil then
				ui.MsgBox(ScpArgMsg("IsAppliedPremiumBoostToken"));
				return;
			end

			for i = 1, 20 do
				local myHandle = session.GetMyHandle();
						local check_buff_name = string.format('Premium_boostToken%02d', i)
						local buff = info.GetBuffByName(myHandle, check_buff_name);
				if buff ~= nil then
					ui.MsgBox(ScpArgMsg("IsAppliedPremiumBoostToken"));
					return;
				end
			end
		end
    end
	
	pc.ReqExecuteTx_Item("SCR_USE_ITEM_TOKEN", itemIES, argList);
end


function TOKEN_SELEC_CANCLE(parent, ctrl)
	local frame				= parent:GetTopParentFrame();
	frame:ShowWindow(0);
end