-- 기본정보창 연산식 정보 제공 관련

 -- CRTHR - 치명
 -- CRTDR - 치명 저항
 -- HR - 명중
 -- DR - 회피

 ITEM_POINT_MULTIPLE = 10
 ITEM_ATK_POINT_MULTIPLE = 20

-- 주기별 회복 수치
local max_hp_recovery_ratio = 0.2 -- MHP 의 전체의 비율

function get_log_scale(ret)
    ret = (math.log(ret + 6.01) / math.log(1.06) - 30.8) * 0.8    
    return ret
end

-- CalcProperty_Skill.cpp, float get_hp_recovery_ratio(imcIES::IObject* pc, float value)
-- done , 해당 함수 내용은 cpp로 이전되었습니다. 변경 사항이 있다면 반드시 프로그램팀에 알려주시기 바랍니다.
function get_hp_recovery_ratio(pc, value)
    if pc == nil then
        pc = GetMyPCObject()
    end
    
    if pc == nil then
        return 0
    end
    local mhp = TryGetProp(pc, 'MHP', 1)
    local rhp = 0

    if value == nil then
        rhp = TryGetProp(pc, 'RHP', 0)
    else
        rhp = value
    end
   
    local ratio = rhp / (ITEM_POINT_MULTIPLE * pc.Lv)
    ratio = ratio * max_hp_recovery_ratio    
    ratio = math.min(max_hp_recovery_ratio, ratio)
    ratio = ratio * mhp

    if IsServerSection() == 1 then
        if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
            ratio = ratio * 0.5
        end
    else
        if IsPVPServer() == 1 or IsPVPField() == 1 then
            ratio = ratio * 0.5
        end
    end

    return math.floor(ratio)
end

-- sp 자연회복 가능 여부 (사용하지 않음 cpp로 이전됨), void CComponent_Battle_PC::UpdateRSP()
-- function get_sp_recovery_enable(pc)
--     local buffKeywordList = { "Curse", "Formation", "SpDrain", "UnrecoverableSP", "NoneRecoverableSP" };
--     for i = 1, #buffKeywordList do
--         if GetBuffByProp(pc, 'Keyword', buffKeywordList[i]) ~= nil then
--             return 0
--         end
--     end

--     return 1
-- end

-- 사용하지 않음, cpp로 이전됨, void CComponent_Battle_PC::UpdateRSP()
-- function get_sp_recovery_time(pc)
--     local value = SCR_GET_RSPTIME(pc)
    
--     if IsBuffApplied(pc, 'ManaAmplify_Debuff') == 'YES' then
--         value = 20000
--     end

--     return value
-- end

-- hp 회복력
function get_RHP_ratio_for_status(value)
    local applied_value = get_hp_recovery_ratio(nil, value)
    return value .. '{#00FF00} (' .. applied_value .. ')'
end

-- sp 회복력
function get_RSP_ratio_for_status(value)     
    return value .. '{#66b3ff} (' .. value .. ')'
end

-- 추가 공격력 관련
function get_calc_atk_value_for_status(pc, prop_value)
    local value = prop_value / (pc.Lv * ITEM_ATK_POINT_MULTIPLE * 1.5)
    value = value * 100

    if value > 100 then
        value = 100
    elseif value < 0 then
        value = 0
    end        
    return string.format("%.1f", value)
end

function get_SmallSize_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_MiddleSize_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_LargeSize_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_MiddleSize_Def_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#66b3ff}(' .. ret .. '%)'
end

function get_AllMaterialType_Def_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#66b3ff}(' .. ret .. '%)'
end

function get_AllMaterialType_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_AllSize_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_AllRace_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Cloth_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Leather_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Iron_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Cloth_Def_ratio_for_status(value)    
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#66b3ff}(' .. ret .. '%)'
end

function get_Leather_Def_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#66b3ff}(' .. ret .. '%)'
end

function get_Iron_Def_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#66b3ff}(' .. ret .. '%)'
end

function get_Forester_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Widling_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Klaida_Atk_ratio_for_status(value)
    local ret = 0    
    local pc = GetMyPCObject()
    
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)        
    end
    
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Paramune_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Velnias_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Ghost_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_BOSS_ATK_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_AttackType_value_Cannon(pc)
    local value = 10
    if pc ~= nil then
        --value = value + (TryGetProp(pc, 'STR', 0) / 100)
    end

    return value
end

function get_Aries_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Slash_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Strike_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Arrow_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Cannon_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Gun_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Magic_Melee_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Magic_Fire_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Magic_Ice_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Magic_Lightning_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Magic_Earth_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Magic_Poison_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Magic_Dark_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Magic_Holy_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Magic_Soul_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end