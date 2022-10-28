function SCR_GACHA_BOUNS_VALUE(self, pc)
    local aObj = GetAccountObj(pc);
    --반드시 지켜주세요!! tpitem.xml의 Itemdate 수정필요 --
    local cubetype = 2; -- 레티샤는 1/ 여큐는 2 
    local count_reward;
    local next_count, next_bouns = 0, 0;
    local rewardlist = {}
    local rewardtext = ''
	local count;
    local bouns;
		
	if cubetype == 1 then
		count = aObj.STEAM190730_GACHA_TP_COUNT;
		bouns = aObj.STEAM190730_GACHA_TP_BOUNS;
		count_reward = 50;
	elseif cubetype == 2 then
		count = aObj.STEAM190716_GACHA_HAIRACC_COUNT;
		bouns = aObj.STEAM190716_GACHA_HAIRACC_BOUNS;
        count_reward = 25;

    -- 201912 STEAM GABIA CUBE
    elseif cubetype == 3 then
        count = aObj.STEAM191231_GACHA_HAIRACC_COUNT;
		bouns = aObj.STEAM191231_GACHA_HAIRACC_BONUS;
        count_reward = 25;
	else 
		Chat("Error cubetype")
	end

                                    --[         카 운 트          ], [          보너스           ] --
    local bounslist = {
        {count_reward, count_reward*2, count_reward*3, count_reward*4, count_reward*5,      'STEAM190730_GACHA_TP_COUNT',      'STEAM190730_GACHA_TP_BOUNS', count_reward}, -- tp
        {count_reward, count_reward*2, count_reward*3, count_reward*4, count_reward*5, 'STEAM190716_GACHA_HAIRACC_COUNT', 'STEAM190716_GACHA_HAIRACC_BOUNS', count_reward}, -- hairacc
        {count_reward, count_reward*2, count_reward*3, count_reward*4, count_reward*5, 'STEAM191231_GACHA_HAIRACC_COUNT', 'STEAM191231_GACHA_HAIRACC_BONUS', count_reward}  -- 201912 STEAM GABIA CUBE
    }

    -- next count
    if count >= bounslist[cubetype][5] then
        for a = 1, 20 do
            if count < bounslist[cubetype][5] + (bounslist[cubetype][8] * a) then
                next_bouns = bounslist[cubetype][5] + (bounslist[cubetype][8] * a)
                next_count = bounslist[cubetype][5] + (bounslist[cubetype][8] * a) - count
                break;
            end
        end
    else
        for j = 1, 5 do
            if count < bounslist[cubetype][j] then
                next_bouns = bounslist[cubetype][j]
                next_count = bounslist[cubetype][j] - count
                break;
            end
        end
    end

    -- reward
    for i = bouns + 1, bouns + 5 do
        if i <= 5 then
            if count >= bounslist[cubetype][i] then
                table.insert(rewardlist, bounslist[cubetype][i])
                if rewardtext == '' then
                    rewardtext = bounslist[cubetype][i]
                else
                    rewardtext = rewardtext.."/"..bounslist[cubetype][i]
                end
            end
        else
            local bouns_count = bounslist[cubetype][5] + (bounslist[cubetype][8] * (i - 5))
            if count >= bouns_count then
                table.insert(rewardlist, bouns_count)
                if rewardtext == '' then
                    rewardtext = bouns_count
                else
                    rewardtext = rewardtext.."/"..bouns_count
                end
            end
        end
    end

    return count, bouns, cubetype, next_count, next_bouns, rewardlist, rewardtext
end

function SCR_GACHA_BOUNS_DIALOG(self, pc)

    local ridingCompanion = GetRidingCompanion(pc);
    if ridingCompanion ~= nil then
        RideVehicle(pc, ridingCompanion, 0)
    end
    
    local aObj = GetAccountObj(pc);

    if TX_GACHA_BONUS_COUNT_RESET(pc,aObj) == false then
        return;
    end

    local count, bouns, cubetype, next_count, next_bouns, rewardlist, rewardtext = SCR_GACHA_BOUNS_VALUE(self, pc)

    local cube_name = 'Leticia Secret Cube'

    if cubetype == 2 then
        cube_name = 'Goddess Blessed Cube'
    end

    -- 201912 STEAM GABIA CUBE
    if cubetype == 3 then
        cube_name = 'Gabia Cube'
    end

    if rewardtext == '' then
        ShowOkDlg(pc, ScpArgMsg('GACHA_BOUNS_SEL2', "CUBE", cube_name, "SUM", count, "COUNT", next_count, "BOUNS", next_bouns), 1)
        return
    else
        local select = ShowSelDlg(pc, 0, ScpArgMsg('GACHA_BOUNS_SEL1', "CUBE", cube_name,"SUM", count, "COUNT", next_count, "BOUNS", next_bouns, "REWARD", rewardtext), ScpArgMsg("No"), ScpArgMsg("Yes"))

        if select == 1 or select == nil then
            return;

        elseif select == 2 then
            local bounslist = {'GACHA_HAIRACC_BOUNS01', 'GACHA_HAIRACC_BOUNS02', 'GACHA_HAIRACC_BOUNS03', 'GACHA_HAIRACC_BOUNS04', 'GACHA_HAIRACC_BOUNS05'}
            if cubetype == 1 then
                bounslist = {'GACHA_TP_BOUNS01', 'GACHA_TP_BOUNS02', 'GACHA_TP_BOUNS03', 'GACHA_TP_BOUNS04', 'GACHA_TP_BOUNS05'}
            end

            -- 201912 STEAM GABIA CUBE
            if cubetype == 3 then
                bounslist = {'GACHA_GABIA_BONUS01', 'GACHA_GABIA_BONUS02', 'GACHA_GABIA_BONUS03', 'GACHA_GABIA_BONUS04', 'GACHA_GABIA_BONUS05'}
            end

            if bouns >= 4 then
                bouns = 4;
            end

            SCR_ITEM_GACHA_TP(pc, bounslist[bouns + 1], bounslist[bouns + 1], 1, 'Bouns', 'rbox') -- give bouns item
        end
    end
end