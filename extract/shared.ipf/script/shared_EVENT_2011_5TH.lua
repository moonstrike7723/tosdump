local event_level_table = 
{
    [1] = 499; 
    [2] = 999;
    [3] = 1499;
    [4] = 1999;
    [5] = 2000;
}

function GET_EVENT_2011_5TH_EVENT_LEVEL(point)
    for k, v in pairs(event_level_table) do
        if tonumber(point) <= tonumber(v)then
            return k;
        end
    end

    return 0;
end

function GET_EVENT_2011_5TH_SPECIAL_SHOP_UPDATE_NEED_COIN_COUNT()
    return 100;
end

function GET_EVENT_2011_5TH_TOS_COIN_MAX_COUNT()
    return 1000
end

function GET_EVENT_2011_5TH_COIN_FIELD_MAX_COUNT()
    return 100;
end

function GET_EVENT_2011_5TH_POINT_MAX_COUNT()
    return 2000;
end

function GET_EVENT_2011_5TH_OFFLINE_POINT_MAX_HOUR()
    return 20;
end

function GET_EVENT_2011_5TH_VIBORA_COMPOSITE_MAX_COUNT()
    return 3;
end

function GET_EVENT_2011_5TH_SPECIAL_VIBORA_NEED_COIN_TOS_COUNT()
    return 1000;
end

function GET_EVENT_2011_5TH_SPECIAL_VIBORA_NEED_COIN_COUNT()
    return 50;
end

function GET_EVENT_2011_5TH_FIREWORK_MAX_COUNT()
    return 3;
end