function SCR_BEAUTY_SHOP_FASHION_DIALOG(self,pc) --
--    -- EVENT_1805_BEAUTY_NPC
--    EVENT_1805_BEAUTY_NPC_PROPERTY_CHECK(pc, 1)
	local clsList,cnt = GetClassList('Beauty_Shop_Package_Cube');
	local genderChk = pc.Gender;
	local select;
	local selectChk = 0; --1일경우 3선택지 띄움
	if cnt ~= 0 then 
		if genderChk == 1 then --남
			select = ShowSelDlg(pc, 0, "BEAUTY_SHOP_FASHION", ScpArgMsg('BEAUTY_SHOP_FASHION_1'), ScpArgMsg('BEAUTY_SHOP_FASHION_2'), ScpArgMsg('BEAUTY_SHOP_FASHION_3'), ScpArgMsg('Close'));
		else --여
			select = ShowSelDlg(pc, 0, "BEAUTY_SHOP_FASHION", ScpArgMsg('BEAUTY_SHOP_FASHION_2'), ScpArgMsg('BEAUTY_SHOP_FASHION_1'), ScpArgMsg('BEAUTY_SHOP_FASHION_3'), ScpArgMsg('Close'));
		end
	else --데이터가 없는 경우
		selectChk = 1;
		if genderChk == 1 then --남
			select = ShowSelDlg(pc, 0, "BEAUTY_SHOP_FASHION", ScpArgMsg('BEAUTY_SHOP_FASHION_1'), ScpArgMsg('BEAUTY_SHOP_FASHION_2'), ScpArgMsg('Close'));
		else --여
			select = ShowSelDlg(pc, 0, "BEAUTY_SHOP_FASHION", ScpArgMsg('BEAUTY_SHOP_FASHION_2'), ScpArgMsg('BEAUTY_SHOP_FASHION_1'), ScpArgMsg('Close'));
		end
	end
	
	if genderChk == 1 then --남 
		if select == 1 then        
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "COSTUME", 1);
        elseif select == 2 then
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "COSTUME", 2);
		end
	else --여
		if select == 1 then        
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "COSTUME", 2);
        elseif select == 2 then
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "COSTUME", 1);
		end
	end
	
    if selectChk == 0 then
		if select == 3 then
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "PACKAGE", 0);
        --elseif select == 4 then
        --     SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "PREVIEW", 0);
		end
	else
		--캔슬
    end

end
