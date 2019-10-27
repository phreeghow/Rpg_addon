golem_waves = class({})
LinkLuaModifier( "modifier_big_golem_waves", "modifiers/modifier_big_golem_waves", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_golem_buff", "modifiers/modifier_golem_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function golem_waves:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function golem_waves:OnAbilityPhaseStart()
	if IsServer() then
		self.nChannelFX = ParticleManager:CreateParticle( "particles/neutral_fx/golem_waves_channel_powertrails.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		--EmitSoundOn( "SandKingBoss.Epicenter.spell", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function golem_waves:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
	end
end

--------------------------------------------------------------------------------

function golem_waves:GetChannelAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end

--------------------------------------------------------------------------------

function golem_waves:OnSpellStart()
	if IsServer() then
		self.projectile_radius = self:GetSpecialValueFor( "projectile_radius" )
		self.Projectiles = {}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_big_golem_waves", {} )
	end
end

-------------------------------------------------------------------------------

function golem_waves:OnChannelFinish( bInterrupted )
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_big_golem_waves" )
		ParticleManager:DestroyParticle( self.nChannelFX, false )
	end
end

-------------------------------------------------------------------------------

function golem_waves:OnProjectileThinkHandle( nProjectileHandle )
	if IsServer() then
		local projectile = nil
		for _, proj in pairs( self.Projectiles ) do
			if proj ~= nil and proj.handle == nProjectileHandle then
				projectile = proj
			end
		end
	end
end

--------------------------------------------------------------------------------

function golem_waves:OnProjectileHitHandle( hTarget, vLocation, nProjectileHandle )
	if IsServer() then
		if hTarget ~= nil and hTarget ~= self:GetCaster() then

			local projectile_radius = self:GetSpecialValueFor( "projectile_radius" )
			

			local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), self:GetCaster(), projectile_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _, hEnemy in pairs( hEnemies ) do
				if hEnemy ~= nil and hEnemy:IsInvulnerable() == false and hEnemy:IsMagicImmune() == false then
					local kv =
					{
						center_x = vLocation.x,
						center_y = vLocation.y,
						center_z = vLocation.z,
						should_stun = false, 
						duration = 0.5,
						knockback_duration = 0.5,
						knockback_distance = -50,
						knockback_height = 0,
					}
					hEnemy:AddNewModifier( self:GetCaster(), self, "modifier_knockback", kv )

					local damageInfo =
					{
						victim = hEnemy,
						attacker = self:GetCaster(),
						damage = self:GetSpecialValueFor( "damage" ),
						damage_type = self:GetAbilityDamageType(),
						ability = self,
					}
					ApplyDamage( damageInfo )
				end
			end

			local friendlies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), self:GetCaster(), projectile_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _, hFriend in pairs( friendlies ) do
				if hFriend ~= nil and hFriend:IsInvulnerable() == false and hFriend:IsMagicImmune() == false then	
					hFriend:AddNewModifier( self:GetCaster(), self, "modifier_golem_buff", { duration = 5 } )
				end
			end

			--EmitSoundOn( "Siltbreaker.Waves.Impact", hTarget )
		end

		local projectile = nil
		for _, proj in pairs( self.Projectiles ) do
			if proj ~= nil and proj.handle == nProjectileHandle then
				projectile = proj
			end
		end
	end

	return false
end

--------------------------------------------------------------------------------