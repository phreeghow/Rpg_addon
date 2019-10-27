death_passive = class({})
LinkLuaModifier( "modifier_death_passive", "modifiers/modifier_death_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_death_passive_thinker", "modifiers/modifier_death_passive_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function death_passive:GetIntrinsicModifierName()
	return "modifier_death_passive"
end

--------------------------------------------------------------------------------
