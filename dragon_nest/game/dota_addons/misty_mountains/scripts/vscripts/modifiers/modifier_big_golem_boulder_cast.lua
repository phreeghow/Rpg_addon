modifier_big_golem_boulder_cast = class ({})

--------------------------------------------------------------------------------

function modifier_big_golem_boulder_cast:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_big_golem_boulder_cast:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_big_golem_boulder_cast:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_DISABLE_TURNING,
		--MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
	return funcs
end

-------------------------------------------------------------------------------
function modifier_big_golem_boulder_cast:CheckState()
	local state =
	{
		[ MODIFIER_STATE_DISARMED ] = true,
	}

	return state
end


--------------------------------------------------------------------------------

-- function modifier_big_golem_boulder_cast:GetModifierProvidesFOWVision( params )
-- 	return 1
-- end
-------------------------------------------------------------------------------



--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_big_golem_boulder_cast:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 0.03 )
	end
end

--------------------------------------------------------------------------------

function modifier_big_golem_boulder_cast:OnIntervalThink()
	if IsServer() then
			local szParticleName = "particles/neutral_fx/mud_golem_hurl_boulder_explode_flash_b.vpcf"
			local nFXIndex2 = ParticleManager:CreateParticle( szParticleName, PATTACH_CUSTOMORIGIN, self:GetParent() )
			ParticleManager:SetParticleControlEnt( nFXIndex2, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex2 )
	end
end

--------------------------------------------------------------------------------

