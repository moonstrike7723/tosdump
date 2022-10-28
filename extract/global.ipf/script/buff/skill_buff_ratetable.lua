function SCR_BUFF_RATETABLE_SteadyAim_Buff(self, from, skill, atk, ret, rateTable, buff)

	if IsBuffApplied(from, 'SteadyAim_Buff') == 'YES' then
	local SteadyAim = GetSkill(from, "Ranger_SteadyAim")
	  if SteadyAim ~= nil then
	     addrate = 0.05 + 0.01 * SteadyAim.Level
	  end
        
        local addDamage = 0
        local Ranger14_abil = GetAbility(from, "Ranger14")
        if Ranger14_abil ~= nil then
            addDamage = addDamage + Ranger14_abil.Level * 2;
        end
        
	    if skill.ClassType == 'Missile' then
	        rateTable.DamageRate = rateTable.DamageRate + addrate
	        rateTable.AddTrueDamage = rateTable.AddTrueDamage + addDamage;
	    end
	end
end