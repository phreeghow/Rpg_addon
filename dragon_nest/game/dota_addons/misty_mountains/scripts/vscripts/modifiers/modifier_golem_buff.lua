modifier_golem_buff = class({})

-----------------------------------------------------------------------------

function modifier_golem_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_golem_buff:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_golem_buff:GetEffectName()
	return "particles/neutral_fx/golem_buff.vpcf"
end

-----------------------------------------------------------------------------

function modifier_golem_buff:OnCreated( kv )
	if not self:GetAbility() then
		return
	end
	
	self.modelscale = self:GetAbility():GetSpecialValueFor( "modelscale" )
	
end

-----------------------------------------------------------------------------

function modifier_golem_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

	}	
	return funcs
end

function modifier_golem_buff:GetModifierPhysicalArmorBonus( params )
	return self.modelscale
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
function modifier_golem_buff:GetModifierModelScale( params )
	return self.modelscale
end
-----------------------------------------------------------------------------
