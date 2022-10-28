function CHATMACRO_ON_INIT(addon, frame)
	addon:RegisterMsg('SET_CHAT_MACRO_DEFAULT', 'SET_CHAT_MACRO_DEFAULT');
	addon:RegisterOpenOnlyMsg('TOKEN_STATE', 'CHATMACRO_UPDATE_TOKEN_STATE');
	
end

MAX_MACRO_CNT = 10;

function CHATMACRO_OPEN(frame)
		
	SHOW_CHAT_MACRO(frame);	
end

function UI_TOGGLE_POSE_MACRO()
	if app.IsBarrackMode() == true then
		return;
	end
	
	ui.ToggleFrame('chatmacro');
end

function CHATMACRO_CLOSE(frame)
	local questInfoSetFrame = ui.GetFrame('questinfoset_2');
	if questInfoSetFrame:IsVisible() == 0 and ui.IsVisibleFramePIPType('CHATMACRO') == false then
		questInfoSetFrame:ShowWindow(1);
	end
	ui.CloseFrame('skilltree');
end

function ROLLBACK_MACRO_LIST(frame)

	ui.CloseFrame('chatmacro')
end

function SAVE_MACRO_LIST(frame)

	local gbox = frame:GetChild('macroGroupbox');

	SAVE_CHAT_MACRO(gbox, 1);
end

function ROLLBACK_CHAT_MACRO(frame)
	LOAD_SESSION_CHAT_MACRO(frame);
end

function SHOW_CHAT_MACRO(frame)

	frame:GetChild("posetext"):SetText(ScpArgMsg("Auto_{@st41}JeSeuChyeoList"));
	frame:GetChild("exetext"):SetText(ScpArgMsg("Auto_{@st41}DanChugKi"));
	frame:GetChild("infotext"):SetText(ScpArgMsg("Auto_{@st41}JeSeuChyeo"));
	frame:GetChild("edittext"):SetText(ScpArgMsg("Auto_{@st41}DaeHwa_MunKu"));	
	UPDATE_CHAT_MACRO(frame);
end

function CHATMACRO_UPDATE_TOKEN_STATE(frame)

	UPDATE_CHAT_MACRO(frame);

end

function MACRO_POSE_VIEW(poseGbox)	

	local csetwidth =  ui.GetControlSetAttribute("pose_icon", 'width');
	local csetheight =  ui.GetControlSetAttribute("pose_icon", 'height');
	
	local xmargin = 5;
	local ymargin = 20;
	local x = xmargin;
	local y = ymargin;


	local clslist = GetClassList("Pose");
	local index = 0;
	local controlIndex = 0;

	local isPremiumTokenState = session.loginInfo.IsPremiumState(ITEM_TOKEN);
	
	while 1 do
		local cls = GetClassByIndexFromList(clslist, index);
		if cls == nil then
			break;
		end

		if cls.Premium == "NO" or isPremiumTokenState == true then
			local eachcontrol = poseGbox:CreateOrGetControlSet('pose_icon','pose_icon'..cls.ClassName, x, y)

			local each_pose_name = GET_CHILD(eachcontrol, 'pose_name','ui::CRichText');
			local each_pose_slot = GET_CHILD(eachcontrol, 'pose_slot','ui::CSlot');

			each_pose_slot:SetEventScript(ui.LBUTTONDOWN, 'SOCIAL_POSE')
			each_pose_slot:SetEventScriptArgNumber(ui.LBUTTONDOWN, cls.ClassID);

			SET_SLOT_IMG(each_pose_slot, cls.Icon);

			each_pose_name:SetTextByKey('posename',cls.Name);
			each_pose_slot:SetTextByKey('posename',cls.Name);

			local icon = each_pose_slot:GetIcon();
		
			icon:SetUserValue('POSEID', cls.ClassID);			
		
			controlIndex = controlIndex + 1;

			x = xmargin + (controlIndex % 6) * csetwidth
			y = ymargin + math.floor(controlIndex / 6) * csetheight
		end

		index = index + 1;
	end
end

function UPDATE_CHAT_MACRO(frame)    
	-- pose
	local poseGbox = frame:GetChild('poseGroupbox');
	MACRO_POSE_VIEW(poseGbox);
	

	-- chat macro
	local macroGbox = frame:GetChild('macroGroupbox');	
	local height = 30;
	local posy = height + 40;
	for i = 1 , MAX_MACRO_CNT do

		local img1 = macroGbox:CreateOrGetControl("picture", "CHAT_MACRO_PIC1_" .. i, 5, posy, 40, 40);
		local img2 = macroGbox:CreateOrGetControl("picture", "CHAT_MACRO_PIC2_" .. i, 42, posy - 10, 54, 54);
		local img3 = macroGbox:CreateOrGetControl("picture", "CHAT_MACRO_PIC3_" .. i, 92, posy, 40, 40);
		tolua.cast(img1, "ui::CPicture");
		tolua.cast(img2, "ui::CPicture");
		tolua.cast(img3, "ui::CPicture");
		img1:SetImage("Alt");
		img1:SetEnableStretch(1);
		img2:SetImage("Shift");
		img2:SetEnableStretch(1);
		img3:SetEnableStretch(1);
		local keyNum = i%10;
		img3:SetImage('key'..keyNum);

		local slot = macroGbox:CreateOrGetControl("slot", "CHAT_MACRO_SLOT_" .. i, 146, posy, 40, 40);
		tolua.cast(slot, "ui::CSlot");
		slot:SetEventScript(ui.RBUTTONUP, "SCR_GESTURE_DELETE");
		slot:SetEventScriptArgNumber(ui.RBUTTONUP, i);
		slot:SetEventScript(ui.DROP, "SCR_GESTURE_DROP");
		slot:SetEventScriptArgNumber(ui.DROP, i);		
		slot:EnableDrop(1);
		slot:SetUserValue('POSEID', 0);
		local icon = slot:GetIcon();
		if icon == nil then
			icon = CreateIcon(slot);
		end
		icon:SetImage('icon_item_none');
		icon:SetColorTone("FF666666");		

local edit = macroGbox:CreateOrGetControl("edit", "CHAT_MACRO_" .. i, 205, posy, 400, 36);
		tolua.cast(edit, "ui::CEditControl");
		edit:MakeTextPack();
		edit:Resize(330, 36);
		edit:SetTextAlign("center", "center");
		edit:SetFontName("white_18_ol");
		edit:SetOffsetXForDraw(20);
		edit:SetOffsetYForDraw(0);
		edit:SetSkinName("test_weight_skin");
			
		posy = posy + 40;	
	end
	
	SHOW_CHILD_BYNAME(macroGbox, "CHAT_MACRO_", 1);
	LOAD_SESSION_CHAT_MACRO(frame);
end

function LOAD_SESSION_CHAT_MACRO(frame)

	local macroGbox = frame:GetChild('macroGroupbox');
	local clslist = GetClassList("Pose");
	local list = session.GetChatMacroList();
	local cnt = list:Count();
	
	for i = 0 , cnt - 1 do
		local info = list:PtrAt(i);
		local ctrl = macroGbox:GetChild("CHAT_MACRO_" .. info.index);
		ctrl:SetText(info.macro);
		ctrl:ShowWindow(1);

		local slot = macroGbox:GetChild("CHAT_MACRO_SLOT_" .. info.index);
		tolua.cast(slot, "ui::CSlot");		
		slot:SetUserValue('POSEID', info.poseID);
		
		local cls = GetClassByTypeFromList(clslist, info.poseID);
		if cls ~= nil then			
			local icon = slot:GetIcon();
			icon:SetImage(cls.Icon);
			icon:SetColorTone("FFFFFFFF");
		end		
	end
end

function SAVE_CHAT_MACRO(macroGbox, isclose)   
	for i = 1 , MAX_MACRO_CNT do
		local ctrl = macroGbox:GetChild("CHAT_MACRO_" .. i);
		local text = ctrl:GetText();
        local badword = IsBadString(text);
	    if badword ~= nil then
		    ui.MsgBox(ScpArgMsg('{Word}_FobiddenWord','Word',badword, "None", "None"));
		    return
	    end        
		local slot = macroGbox:GetChild("CHAT_MACRO_SLOT_" .. i);		
		local poseID = tonumber( slot:GetUserValue('POSEID') );
		packet.ReqSaveChatMacro(i, poseID, text);
	end

	if isclose == 1 then
		ui.CloseFrame('chatmacro');
	end
end

function SET_CHAT_MACRO_DEFAULT(frame, msg, argStr, argNum)
	local cls, cnt = GetClassList('Chatmacro_Default');
	local test = GetClassByIndexFromList(cls, 0);
	if cls == nil then
		return;
	end

	local poseID = 0;
	local text = "";
	for i = 0, cnt do
		if i > MAX_MACRO_CNT then
			return;
		end	
		local obj = GetClassByIndexFromList(cls, i);
		if obj ~= nil then		
			if obj.Text == "None" then
				text = "";
			else
				text = obj.Text
			end
			poseID = obj.PoseID
			packet.ReqSaveChatMacro(i+1, poseID, text);
		end
	end
end

function SCR_GESTURE_DELETE(macroGbox, icon, argStr, argNum)

	local slot = macroGbox:GetChild("CHAT_MACRO_SLOT_" .. argNum);
	tolua.cast(slot, "ui::CSlot");
	slot:SetUserValue('POSEID', 0);
	local icon = slot:GetIcon();
	icon:SetImage('icon_item_none');
	icon:SetColorTone("FF666666");

end

function SCR_GESTURE_DROP(frame, icon, argStr, argNum)

	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();
	if FromFrame:GetName() == 'chatmacro' then
		local macroGbox = toFrame:GetChild('macroGroupbox');
		local slot = macroGbox:GetChild("CHAT_MACRO_SLOT_" .. argNum);
		tolua.cast(slot, "ui::CSlot");
		local iconInfo = liftIcon:GetInfo();
		local poseID = liftIcon:GetUserValue('POSEID');
		slot:SetUserValue('POSEID', poseID);
		local icon = slot:GetIcon();
		local cls = GetClassByType("Pose", poseID);
		if cls ~= nil then
			icon:SetImage(cls.Icon);
			icon:SetColorTone("FFFFFFFF");
		end
	end

end

function SOCIAL_POSE(frame, ctrl, strarg, poseClsID)

	local poseCls = GetClassByType('Pose', poseClsID);
	if poseCls ~= nil then
		control.Pose(poseCls.ClassName);
	end
end


