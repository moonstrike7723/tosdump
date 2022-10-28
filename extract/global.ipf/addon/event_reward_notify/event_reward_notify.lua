function EVENT_REWARD_NOTIFY_ON_MSG(frame, msg, argStr, argNum) -- box item name error --
	if msg == "EVENT_REWARD_NOTIFY_INIT" then
		frame:ShowWindow(0);
		return;
	elseif msg == "EVENT_REWARD_NOTIFY_ITEM_GET" then        
		local argList = StringSplit(argStr, ';');
		if #argList ~= 3 then
			frame:ShowWindow(0);
			return;
		end
			local template = dic.getTranslatedStr(GetClassString('ClientMessage',  'LVUP_REWARD_MSG1', 'Data'))
			template = string.gsub(template, '{ITEM}', dic.getTranslatedStr(GetClassString('Item',argList[2],'Name')))
			template = string.gsub(template, '{COUNT}', tostring(argList[3]))
			EVENT_REWARD_NOTIFY_SHOW(frame, dic.getTranslatedStr(GetClassString('ClientMessage', 'EVENT_1806_NUMBER_GAMES_MSG2','Data')), template)
		return;
	end
end