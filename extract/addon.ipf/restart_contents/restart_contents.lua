-- restart contents
local cache_command_btn_list = nil;
function RESTART_CONTENTS_ON_INIT(addon, frame)
	addon:RegisterMsg("RESTART_CONTENTS_HERE", "RESTART_CONTENTS_ON_MSG");
	addon:RegisterMsg("RESTARTSELECT_UP", "RESTART_CONTENTS_ON_MSG");
	addon:RegisterMsg("RESTARTSELECT_DOWN", "RESTART_CONTENTS_ON_MSG");
	addon:RegisterMsg("RESTARTSELECT_SELECT", "RESTART_CONTENTS_ON_MSG");
end

function RESTART_CONTENTS_VISIBLE_RESET(frame)
	if frame ~= nil then
		for i = 1, 5 do
			local btn = GET_CHILD_RECURSIVELY(frame, "btn_restart_"..i);
			if btn ~= nil then
				btn:ShowWindow(0);
			end 
		end
		local text_raid_death_count = GET_CHILD_RECURSIVELY(frame, "text_raid_death_count");
		if text_raid_death_count ~= nil then
			text_raid_death_count:ShowWindow(0);
		end
	end
end

function RESTART_CONTENTS_AUTO_RESIZE(frame)
	if frame ~= nil then
		cache_command_btn_list = nil;
		local max_y = 0;
		local ctrl_y = 100;
		local ctrl_height = 0;
		local cnt = frame:GetChildCount();
		for i = 0, cnt - 1 do
			local ctrl = frame:GetChildByIndex(i);
			if ctrl ~= nil and ctrl:IsVisible() == 1 and string.find(ctrl:GetName(), "btn_restart_") ~= nil then
				ctrl:SetOffset(ctrl:GetOffsetX(), ctrl_y);
				ctrl_y = ctrl_y + ctrl:GetHeight() + 5;
				if ctrl_height == 0 then
					ctrl_height = ctrl:GetHeight();
				end
				local y = ctrl:GetOffsetY() + ctrl:GetHeight();
				if y > max_y then
					max_y = y;
				end
			end
		end
		max_y = max_y + ctrl_height;
		if max_y ~= 0 then
			frame:Resize(frame:GetWidth(), max_y);
		end
	end
end

function RESTART_CONTENTS_GET_COMMAND_LIST(frame)
	if cache_command_btn_list == nil then 
		cache_command_btn_list = {};
		local index = 1;
		while 1 do
			local btn_name = "btn_restart_"..index;
			local btn = GET_CHILD_RECURSIVELY(frame, btn_name);
			if btn == nil then break; end
			if btn:IsVisible() == 1 then
				cache_command_btn_list[#cache_command_btn_list + 1] = btn_name;
			end
			index = index + 1;
		end
	end
	return cache_command_btn_list;
end

-- msg
function RESTART_CONTENTS_ON_MSG(frame, msg, arg_str, arg_num)
	if frame == nil then return; end
	if msg == "RESTART_CONTENTS_HERE" then
		RESTART_CONTENTS_ON_HERE(frame, arg_str, arg_num);
	elseif msg == "RESTARTSELECT_UP" then
		RESTART_CONTENTS_INDEX(frame, -1);
		RESTART_CONTENTS_SELECT(frame);
	elseif msg == "RESTARTSELECT_DOWN" then
		RESTART_CONTENTS_INDEX(frame, 1);
		RESTART_CONTENTS_SELECT(frame);
	elseif msg == "RESTARTSELECT_SELECT" then
		RESTART_CONTENTS_ON_SELECT(frame);
	end
end

function RESTART_CONTENTS_ON_HERE(frame, arg_str, arg_num)
	if frame == nil or arg_num == nil then return; end
	if frame:IsVisible() == 1 then return; end
	session.RaidResurrectDialog(arg_num);
	frame:ShowWindow(1);
	local text_raid_death_count = GET_CHILD_RECURSIVELY(frame, "text_raid_death_count");
	if text_raid_death_count ~= nil then
		text_raid_death_count:ShowWindow(0);
	end
	RESTART_CONTENTS_AUTO_RESIZE(frame);
end

function RESTART_CONTENTS_ON_HERE_VISIBLE(num, is_bit)
	local frame = ui.GetFrame("restart_contents");
	if frame ~= nil then
		local btn = GET_CHILD_RECURSIVELY(frame, "btn_restart_"..num);
		if btn ~= nil then
			btn:ShowWindow(is_bit);
		end
	end
end

function RESTART_CONTENTS_INDEX(frame, is_down)
	if frame == nil then return; end
	local list = RESTART_CONTENTS_GET_COMMAND_LIST(frame);
	if list ~= nil and #list > 0 then
		local select_index = frame:GetValue();
		select_index = select_index + is_down;
		local btn_name = list[select_index];
		local btn = GET_CHILD_RECURSIVELY(frame, btn_name);
		if btn == nil then return; end
		frame:SetValue(select_index);
	end
end

function RESTART_CONTENTS_SELECT(frame)
	if frame == nil then return; end
	local list = RESTART_CONTENTS_GET_COMMAND_LIST(frame);
	if list ~= nil and #list > 0 then
		local select_index = frame:GetValue();
		local btn_name = list[select_index];
		local btn = GET_CHILD_RECURSIVELY(frame, btn_name);
		if btn == nil then return; end
		local x, y = GET_SCREEN_XY(btn);
		mouse.SetPos(x, y);
		mouse.SetHidable(0);
	end
end

function RESTART_CONTENTS_ON_SELECT(frame)
	if frame == nil then return; end
	local list = RESTART_CONTENTS_GET_COMMAND_LIST(frame);
	if list ~= nil and #list > 0 then
		local select_index = frame:GetValue();
		local btn_name = list[select_index];
		local btn = GET_CHILD_RECURSIVELY(frame, btn_name);
		if btn ~= nil then
			local scp = btn:GetEventScript(ui.LBUTTONUP);
			local arg_str = btn:GetEventScriptArgString(ui.LBUTTONUP);
			local func = _G[scp];
			func(frame, btn, arg_str);
		end
	end
end