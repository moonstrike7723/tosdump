﻿function SCR_Get_SteadyAim_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 5 + skill.Level

    return math.floor(value)

end

function SCR_Get_HangmansKnot_Bufftime(skill)
    return 1 + skill.Level * 0.2;
end
