modifier_golem_boulder_thinker = class({})

----------------------------------------------------------------------------------------

function modifier_golem_boulder_thinker:OnCreated( kv )
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.area_duration = self:GetAbility():GetSpecialValueFor( "area_duration" )
		self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
		self.bImpact = false
		self.bShapeshift = self:GetCaster():FindModifierByName( "modifier_death_passive" ) ~= nil
	end
end

----------------------------------------------------------------------------------------

function modifier_golem_boulder_thinker:OnImpact()
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/creeps/golem/boulder_debris.vpcf", PATTACH_WORLDORIGIN, nil );
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		EmitSoundOn( "Ability.TossImpact", self:GetParent() )
		
		self:SetDuration( self.area_duration, true )
		self.bImpact = true

		self:StartIntervalThink( 0.25 )
	end
end

----------------------------------------------------------------------------------------

function modifier_golem_boulder_thinker:OnIntervalThink()
	if IsServer() then
		if self.bImpact == false then
			self:OnImpact()
			return
		end

		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil then
				if self.bShapeshift then
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.duration } )

					local damageInfo =
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.radius,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						ability = self,
					}
				
					ApplyDamage( damageInfo )

				else
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.duration / 2 } )

					local damageInfo =
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.radius / 2,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						ability = self,
					}
				
					ApplyDamage( damageInfo )

				end


			end
		end
	end
end

----------------------------------------------------------------------------------------