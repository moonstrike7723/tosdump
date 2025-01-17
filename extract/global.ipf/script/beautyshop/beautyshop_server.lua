-- beautyshop_server.lua 

local DRT_TYPE =  {
	NONE = 0,
	COSTUME =1,
	HAIR =2
}

local DRT_DELAY = {
	COSTUME = 5000,
	 HAIR = 3000,
}

local DRT_POS = {
--	COSTUME = {x=34.79, y=6.98, z=1098.98}, -- 미사용
	HAIR = {x=-18.381889, y=4.7181091, z=2.6478555},
}

function SCR_TX_BEAUTYSHOP_PURCHASE(pc, idSpaceList, classNameList, colorClassNameList, hairCouponGuid, dyeCouponGuid, skinCouponGuid)
	if #idSpaceList < 1 then
		return;
	end
	if #idSpaceList ~= #classNameList or  #idSpaceList ~= #colorClassNameList then		
		return;
	end

	local retHair, hairCouponItem = CHECK_HAIR_COUPON_ITEM(pc, hairCouponGuid);
	local retDye, dyeCouponItem = CHECK_DYE_COUPON_ITEM(pc, dyeCouponGuid);
		local retSkin, skinCouponItem = CHECK_SKIN_COUPON_ITEM(pc, skinCouponGuid);
	if retHair == false or retDye == false or retSkin == false then
		return;
	end

	-- 넘어온 list 합치기
	local productList = {};
	local index = 1
	for i = 1, #idSpaceList do		
		local colorName = 'None';
		-- idSpace 가 hair이면서 ColorClassName이 'None'일 경우 default다.
		-- 이렇게 default로 바꿔줘야 startHairColorName이 변경되고 캐릭터 설정의 염색 컬러가 제대로 설정된다.		
		if idSpaceList[i] == 'Beauty_Shop_Hair' and colorClassNameList[i] == 'None' then
			colorName = 'default'
		end

		local colorCls = GetClass('Hair_Dye_List', colorClassNameList[i]);
		if colorCls ~= nil then
			colorName = colorCls.DyeName;
		end
	
		-- 미리보기 상점이 아닌 상품만 목록으로 만든다.
		if idSpaceList[i] ~= 'Beauty_Shop_Preview' then
			productList[index] = {
			IDSpace =  idSpaceList[i],
			ClassName = classNameList[i],
			ColorClassName = colorClassNameList[i],
			ColorEngName = colorName,
			Price = 0, -- for log
			HairDiscountValue  = 0, -- for log
			DyeDiscountValue = 0, -- for log
			SkinDiscountValue = 0, -- for log
		};
			index = index +1
		end
	end

	-- 구매할 목록이 없으면 더미 아이템을 착용해제하고 종료
	if #productList == 0 then
		BEAUTYSHOP_EQUIP_DUMMY_ITEM_CLEAR(pc);
		return;
	end
	
	
	-- 구매 제한 검증
	local isLimit = IS_PURCHASE_LIMIT(pc, productList);
	if isLimit == true then
		IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: purchase limit - aid["..GetPcAIDStr(pc).."]");
		return;
	end
	
	-- 기본할인율 + 쿠폰할인율 이중 적용이 되는 아이템이 있는지 확인. (100% 할인인 경우엔 무시)
	local isDuplicateDiscount = IS_PURCHASE_DUPLICATE_DISCOUNT(pc, productList, hairCouponItem, dyeCouponItem, skinCouponItem);
	if isDuplicateDiscount == true then
		SendSysMsg(pc, 'BEAUTY_SHOP_NO_DUPLICATE_DISCOUNT');
		IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: purchase - duplicate discount - aid["..GetPcAIDStr(pc).."]");
		return;
	end
	
	local totalPrice = GET_PRICE_INFO_BY_LIST(pc, productList, hairCouponItem, dyeCouponItem, skinCouponItem);
	if totalPrice < 0 then
		return;
	end

	-- 보유 TP로 구매 할 수 있는지 확인
	if 0 > GetPCTotalTPCount(pc) - totalPrice then
		IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: not enough TP - aid["..GetPcAIDStr(pc).."], have["..GetPCTotalTPCount(pc)..'], totalPrice['..totalPrice..']');
		return
	end
	
	local aobj = GetAccountObj(pc);
	if aobj == nil then
		IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: account obj nil - aid["..GetPcAIDStr(pc).."]");
		return 
	end

	local etc = GetETCObject(pc);
	if etc == nil then
		IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: etc obj nil - aid["..GetPcAIDStr(pc).."]");
		return;
	end

-- 스팀 유저 등급처리
	local isLimitPaymentState = nil;
	local isGlobalServer = GetServerNation() == 'GLOBAL';
	
	--스팀 카드 도용 방지를 위한 월 결제 한도가 걸려있는지 확인하는 함수
	if isGlobalServer == true then
		isLimitPaymentState = CHECK_LIMIT_PAYMENT_STATE(pc);
		if isLimitPaymentState == nil then
			isLimitPaymentState = false;
		end
	end

	if isLimitPaymentState == true then
		local isOver, message = CHECK_SPENT_PAYMENT_VALUE_OVER(pc, totalPrice);
		if isOver == true then
			-- 초과일 경우 사용 가능 TP량을 안내한다.
			local spentPaymentValue = TryGetProp(aobj, "SpentPaymentValue");
			if spentPaymentValue ~= nil then
				local nowUsePaymentValue = tonumber(VALVE_PURCHASESTATUS_ACTIVE_MONTHLY_PREMIUM_TP_SPENDLIMIT) - spentPaymentValue;
				SendAddOnMsg(pc, "BEAUTYSHOP_PURCHASE_FAIL_LIMIT_PAYMENT", ScpArgMsg("LimitPaymentGuidMsg","Value", nowUsePaymentValue), 0); 
			end
			IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: CHECK_SPENT_PAYMENT_VALUE_OVER - aid["..GetPcAIDStr(pc).."]");
			return;
		end
	end

	local freeMedal = aobj.GiftMedal + aobj.Medal

	if isLimitPaymentState == true then
		-- 원간 결제 한도 초과 검사
		if false == PRECHECK_TX_LIMIT_PAYMENT_OVER(pc, totalPrice, freeMedal) then
			IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: PRECHECK_TX_LIMIT_PAYMENT_OVER - aid["..GetPcAIDStr(pc).."]");
			return;
		end
	end
-- 스팀 유저 등급처리 끝

	local stampCnt = GET_TOTAL_STAMP_COUNT(pc, productList);
	if stampCnt < 0 then
		return;
	end

	-- for log T_T	
	local hairCouponName = TryGetProp(hairCouponItem, 'ClassName', 'None');
	local dyeCouponName = TryGetProp(dyeCouponItem, 'ClassName', 'None');
	local skinCouponName = TryGetProp(skinCouponItem, 'ClassName', 'None');
	local appliedHairDiscount = false;
	local appliedDyeDiscount = false;
	local appliedSkinDiscount = false;
	local preHairName = etc.StartHairName;
	local preSkintoneName = etc.SkintoneName;
	local hairEngName = 'None';
	local targetColorEngName = 'None';
	local skintoneName = 'None';
	for i = 1, #productList do
		local info = productList[i];
		if info.HairDiscountValue > 0 then
			appliedHairDiscount = true;
		end
		if info.DyeDiscountValue > 0 then
			appliedDyeDiscount = true;
		end
		if info.SkinDiscountValue > 0 then
			appliedSkinDiscount = true;
		end

		local itemObj = GetClass("Item", info.ClassName)
		if itemObj == nil then
			IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: item Obj nil - aid["..GetPcAIDStr(pc).."]");
			return 
		end
	end

	-- tx 전에 연출을 실행한다. tx전에 모든 조건 검사가 완료 되어야 함.
	local directionName, directionType = GET_BEAUTYSHOP_DIRECTION(pc, productList)
	if directionName ~= "None" then
		if directionType == DRT_TYPE.HAIR then 
			-- 헤어 연출일 경우 가발을 벗겨주세요
			UnEquipItemSpot(pc, 'HAIR')
			sleep(500)   -- 벗겨지는 것 잠시 대기
			-- 헬멧도 벗겨주세요.
			UnEquipItemSpot(pc, 'HELMET') 
			sleep(500)   -- 벗겨지는 것 잠시 대기
		end

		PlayDirection(pc, directionName);
		SendAddOnMsg(pc, "BEAUTYSHOP_DIRECTION_START", "", 0);
		-- 코스튬일 경우 TX 돌기전에 딜레이를 준다.
		if directionType == DRT_TYPE.COSTUME then
			sleep(DRT_DELAY.COSTUME); 
		elseif directionType == DRT_TYPE.HAIR then 
			-- 더미 아이템 벗겨서 양머리 없어짐. 여기도 딜레이를 준다.
			sleep(DRT_DELAY.HAIR); 
		end
	end

	-- 구매 처리 TX
	local success = true;
	local costumeItemGuid = nil;
	for k,v in pairs(productList) do
		local tx = TxBegin(pc);
		local preDyeName = 'None';
		local medalLog = 'BeautyShop';
		local cmdIdx = 0;
		if v.IDSpace == "Beauty_Shop_Hair" then

			-- 쿠폰은 헤어 변경, 염색에만 적용된다.
			if appliedHairDiscount == true and hairCouponItem ~= nil and hairCouponGuid ~= '0' then
				TxTakeItemByObject(tx, hairCouponItem, 1, 'BeautyShop');
			end
	
			if appliedDyeDiscount == true and dyeCouponItem ~= nil and dyeCouponGuid ~= '0' then
				TxTakeItemByObject(tx, dyeCouponItem, 1, 'BeautyShop');
			end
			
			local itemCls = GetClass('Item', v.ClassName);
			hairEngName = itemCls.StringArg;
			if v.ColorClassName ~= 'None' then				
				medalLog = 'HairTotal';
				if itemCls.StringArg == preHairName then
					medalLog = 'HairDye';
				end
				preDyeName = etc.StartHairColorName;
				if preDyeName == 'None' then
					preDyeName = 'default';
				end
				targetColorEngName = v.ColorEngName;
			else				
				medalLog = 'HairChange';
			end

			TxChangeDefaultHair(tx, hairEngName, v.ColorEngName, 1);

			if IS_ALREADY_PURCHASED_HAIR(pc, v.ClassName, v.ColorEngName) == false then				
				TxAddBeuatyshopPurchaseHair(tx, v.ClassName, v.ColorEngName);
			end

			-- 헤어구매의 경우 이벤트 프로퍼티 설정
			TX_SET_BEAUTYSHOP_EVENT_PROPERTY(tx, pc)
		elseif v.IDSpace == "Beauty_Shop_Skin" then -- Skin 구매
			local isChange = false;
			local r = 0; 
			local g = 0;
			local b = 0;

			medalLog = 'ChangeSkinColor'
			local itemCls = GetClass('Item', v.ClassName);
			skintoneName = TryGetProp(itemCls, "StringArg"); 
			if skintoneName ~= nil then
				local skintone = GetClass("SkinTone", skintoneName);
				if skintone ~= nil then
					r = TryGetProp(skintone, "Red");
					g = TryGetProp(skintone, "Green");
					b = TryGetProp(skintone, "Blue");
					if r ~= nil and g ~= nil and b ~= nil then
						isChange = true
					end
				end
			end 

			if appliedSkinDiscount == true and skinCouponItem ~= nil and skinCouponGuid ~= '0' then
				TxTakeItemByObject(tx, skinCouponItem, 1, 'BeautyShop');
			end

			if isChange == true then
				TxChangeSkinColor(tx, r, g, b);
			else
				IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: Change skin color error. Perhaps IES is not loaded. (SkinTone or Item) - aid["..GetPcAIDStr(pc).."]");
			end	
		else
			-- Beauty_Shop_Costume, Beauty_Shop_Lens, Beauty_Shop_Package_Cube Beauty_Shop_Wig
			local itemCls = GetClass('Item', v.ClassName);			
			cmdIdx = TxGiveItem(tx, v.ClassName, 1, "BeautyShop");

			local classType = TryGetProp(itemCls, 'ClassType', 'None');
			local giveItemGuid = TxGetGiveItemID(tx, cmdIdx);
			if classType == 'Outer' then
				costumeItemGuid = giveItemGuid;
			end
			medalLog = medalLog..':'..itemCls.ClassID..':'..giveItemGuid;
		end

		local _productList = {};
		_productList[1] = v;
		local _price = GET_PRICE_INFO_BY_LIST(pc, _productList, hairCouponItem, dyeCouponItem, skinCouponItem);
		
		-- TP깍기
		if v.IDSpace == "Beauty_Shop_Hair" then
			TxAddIESProp(tx, aobj, "Medal", -_price, medalLog, cmdIdx, hairEngName, targetColorEngName);
		elseif v.IDSpace == "Beauty_Shop_Skin" then -- Skin 구매
			TxAddIESProp(tx, aobj, "Medal", -_price, medalLog, cmdIdx, skintoneName, "");
		else
			TxAddIESProp(tx, aobj, "Medal", -_price, medalLog, cmdIdx, "","");
		end

		local _stampCnt = GET_TOTAL_STAMP_COUNT(pc, _productList);
		if _stampCnt > 0 then
			TxAddBeautyShopStamp(tx, _stampCnt);
		end

		--스팀 카드 도용관련 프로퍼티 증가
		if isLimitPaymentState == true then
			TX_LIMIT_PAYMENT_STATE(pc, tx, totalPrice, freeMedal)
		end
		
		local premiumDiff = 0; -- steam event --
		if EVENT_STEAM_POPOSHOP_PRECHECK() == 'YES' then 
			local currentFreeMedal = aobj.GiftMedal + aobj.Medal
			if _price > currentFreeMedal then
				premiumDiff = _price - currentFreeMedal
			end
			TxAddIESProp(tx, aobj, "EVENT_STEAM_BEAUTYSHOP_BUY_PRICE", premiumDiff, "PoPo_Shop_Prop");
		end -- steam event --

		local ret = TxCommit(tx);
		if ret == "SUCCESS" then
			if EVENT_STEAM_POPOSHOP_PRECHECK() == 'YES' then -- steam event --
				local premiumDiff_Popo = premiumDiff * 2 
				CustomMongoLog(pc, "GivePCBangPointShopPoint", "Type", "Try", "ex_point", premiumDiff_Popo)
				local pointResult = GivePCBangPointShopPoint(pc, premiumDiff_Popo, "PoPo_Shop")
				local point_Type = "fail"
				if pointResult == 1 then
					point_Type = 'SUCCESS'
				end
				CustomMongoLog(pc, "GivePCBangPointShopPoint", "Type", point_Type, "point", premiumDiff_Popo)
			end -- steam event --
			
			WRITE_BEAUTY_SHOP_LOG(pc, _productList, _stampCnt, preHairName, preDyeName, hairCouponName, dyeCouponName, preSkintoneName, skintoneName, skinCouponName);
		else
			success = false;
		end
	end

	if success == true then
		InvalidateStates(pc); -- 이거해야 머리바뀜
		AddBuff(pc, pc, 'BEAUTY_HAIR_BUY_BUFF'); -- tx 성공후 버프 걸어줌.

		-- 재생된 연출이 코스튬일 때만 해야함. 동시에 사는경우 헤어 연출인데 중간에 포즈 바껴서 양 머리벗겨짐.
		if directionType == DRT_TYPE.COSTUME and costumeItemGuid ~= nil then
			local poseCls = GetClass('Pose', 'DOUBLEGUNS');			
			EquipItemSpot(pc, costumeItemGuid, 'OUTER');
			sleep(1000); -- Equip 처리도 Request이고 포즈도 리퀘스트라서 바로 하면 씹힘..
			PlayPose(pc, poseCls.ClassID);
		end

        BEAUTYSHOP_EQUIP_DUMMY_ITEM_CLEAR(pc);
        SteamSetAchievement(pc, "TOS_STEAM_ACHIEVEMENT_HAIR_CHANGE");
	end

	-- 구매 후처리. 
	BEAUTYSHOP_PURCHASE_POST_ACTION(pc,directionType )
end