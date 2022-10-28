function SCR_BEAUTY_SHOP_FASHION_DIALOG(self,pc)
    local Package_clsList,Package_cnt = GetClassList('Beauty_Shop_Package_Cube');
    local genderChk = pc.Gender;

	local text = {}
	local dlg = 'BEAUTY_SHOP_FASHION'
	local select, msg;
	
    if genderChk == 1 then --성별 체크
		text[#text+1] =  {'FASHION_1', ScpArgMsg('BEAUTY_SHOP_FASHION_1')}
		text[#text+1] =  {'FASHION_2', ScpArgMsg('BEAUTY_SHOP_FASHION_2')}
    else
		text[#text+1] =  {'FASHION_2', ScpArgMsg('BEAUTY_SHOP_FASHION_2')}
		text[#text+1] =  {'FASHION_1', ScpArgMsg('BEAUTY_SHOP_FASHION_1')}
	end
	
	if Package_cnt ~= 0 then --패키지 데이터가 있을 경우
		text[#text+1] =  {'FASHION_3', ScpArgMsg('BEAUTY_SHOP_FASHION_3')}
		text[#text+1] =  {'Close', ScpArgMsg('Close')}
		select = ShowSelDlg(pc, 0, dlg, text[1][2], text[2][2], text[3][2], text[4][2])
	else
		text[#text+1] =  {'Close', ScpArgMsg('Close')}
		select = ShowSelDlg(pc, 0, dlg, text[1][2], text[2][2], text[3][2])
	end
	
	if select ~= nil then
        if select == 1 then        
			if genderChk == 1 then
				SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "COSTUME", 1);
			else
				SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "COSTUME", 2)
			end
        elseif select == 2 then
			if genderChk == 1 then
				SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "COSTUME", 2);
			else 
				SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "COSTUME", 1);
			end
        elseif select == 3 and Package_cnt ~= 0 then
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "PACKAGE", 0);
		-- elseif select == 4 then --Global 
        --     SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "PREVIEW", 0);
        --elseif select == 5 then
        --    SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "PREVIEW_LETICIA", 0);
        -- elseif select == 6 then
        --    SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "PREVIEW_SILVERGACHA", 0);
        end
    end
end