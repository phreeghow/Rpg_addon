modifier_death_passive = class({})

------------------------------------------------------------------

function modifier_death_passive:OnCreated( kv )
	if IsServer() then
		if self:GetAbility() ~= nil then
			self.spawn_delay = self:GetAbility():GetSpecialValueFor( "spawn_delay" )
			self.nPreviewFX = ParticleManager:CreateParticle( "particles/creeps/golem/golem_sparks_parent.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
			ParticleManager:SetParticleControlEnt( self.nPreviewFX, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( self.nPreviewFX )

			local nFXIndex = ParticleManager:CreateParticle( "particles/creeps/golem/golem_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end	
	end
end

------------------------------------------------------------------

function modifier_death_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_death_passive:OnDeath( params )
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		local hUnit = params.unit
		if hUnit == self:GetParent() then
			local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_death_passive_thinker", { duration = self.spawn_delay }, self:GetParent():GetOrigin(), self:GetParent():GetTeamNumber(), false )
			local caster = self:GetCaster()
		    local sound = "tutorial_rockslide"

		    local nFXIndex = ParticleManager:CreateParticle( "particles/creeps/golem/golem_destruction.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn(sound, caster)
		end
	end
end

--------------------------------------------------------------------------------

function modifier_death_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_death_passive:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_NO_HEALTH_BAR] = false
	end
	
	return state
end

--------------------------------------------------------------------------------
