golem_boulder = class ({})
LinkLuaModifier( "modifier_golem_boulder_thinker", "modifiers/modifier_golem_boulder_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_big_golem_boulder_cast", "modifiers/modifier_big_golem_boulder_cast", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------
function golem_boulder:OnAbilityPhaseStart()
	if IsServer() then
		self.animation_time = self:GetSpecialValueFor( "animation_time" )
		self.shapeshift_animation_time = self:GetSpecialValueFor( "shapeshift_animation_time" )
		self.bShapeshift = self:GetCaster():FindModifierByName( "modifier_death_passive" ) ~= nil
		self.hSpeed = self:GetSpecialValueFor( "projectile_speed" )
		
		local kv = {}
		if self.bShapeshift then
			kv["duration"] = self.shapeshift_animation_time
			self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_CAST_ABILITY_1, 1 )
		else
			kv["duration"] = self.animation_time
			self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_CAST_ABILITY_2, 1 )
		end
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_big_golem_boulder_cast", kv )

	end
	return true
end

function golem_boulder:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_big_golem_boulder_cast" )
		
	end
end

function golem_boulder:OnSpellStart()
	if IsServer() then
		if self.bShapeshift then
			self.hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_golem_boulder_thinker", { duration = -1 }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
			if self.hThinker ~= nil then
				local projectile =
				{
					Target = self.hThinker,
					Source = self:GetCaster(),
					Ability = self,
					EffectName = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf",
					iMoveSpeed = self.hSpeed,
					vSourceLoc = self:GetCaster():GetOrigin(),
					bDodgeable = false,
					bProvidesVision = true,
				}

				ProjectileManager:CreateTrackingProjectile( projectile )
				EmitSoundOn( "Ability.TossThrow", self:GetCaster() )
			end
		else
			self.hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_golem_boulder_thinker", { duration = -1 }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
			if self.hThinker ~= nil then
				local projectile =
				{
					Target = self.hThinker,
					Source = self:GetCaster(),
					Ability = self,
					EffectName = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf",
					iMoveSpeed = self.hSpeed*0.75,
					vSourceLoc = self:GetCaster():GetOrigin(),
					bDodgeable = false,
					bProvidesVision = false,
				}

				ProjectileManager:CreateTrackingProjectile( projectile )
				EmitSoundOn( "Ability.TossThrow", self:GetCaster() )
			end
		end
	end
end

----------------------------------------------------------------------------------------

function golem_boulder:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if self.hThinker ~= nil then
			local hBuff = self.hThinker:FindModifierByName( "modifier_golem_boulder_thinker" )
			if hBuff ~= nil then
				hBuff:OnIntervalThink()
			end
			self.hThinker = nil;
		end
	end

	return true
end

----------------------------------------------------------------------------------------