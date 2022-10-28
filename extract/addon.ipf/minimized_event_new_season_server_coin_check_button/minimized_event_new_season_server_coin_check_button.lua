function MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_ON_INIT(addon, frame)
	-- addon:RegisterMsg('GAME_START', 'MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_OPEN_CHECK');
	addon:RegisterMsg("GAME_START", "GODDESS_ROULETTE_COIN_BUTTON_OPEN_CHECK");
end

function MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_OPEN_CHECK(frame)
	local ctrl = GET_CHILD(frame, "openBtn");
	ctrl:SetEventScript(ui.LBUTTONUP, "MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_CLICK");
	frame:ShowWindow(1);
end

function MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_CLICK()
	local accObj = GetMyAccountObj();
	if TryGetProp(accObj,"REGULAR_EVENT_STAMP_TOUR",0) == 1 then
		ON_EVENT_STAMP_TOUR_UI_OPEN_COMMAND()
	else
		ui.SysMsg(ClMsg('STAMP_TOUR_NOT_OPEN'));
	end
end

function GODDESS_ROULETTE_COIN_BUTTON_OPEN_CHECK(frame)
	-- local ctrl = GET_CHILD(frame, "openBtn");
	-- ctrl:SetEventScript(ui.LBUTTONUP, "MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_CLICK");

	frame:ShowWindow(0);
end

function GODDESS_ROULETTE_COIN_BUTTON_OPEN_CHECK_CLICK()
	local accObj = GetMyAccountObj();
	if TryGetProp(accObj,"REGULAR_EVENT_STAMP_TOUR") == 0 then
		ui.SysMsg(ScpArgMsg("STAMP_TOUR_NOT_OPEN"));
	end
	local frame = ui.GetFrame("goddess_roulette_coin");
	frame:ShowWindow(1);
end
