modifier_death_passive_thinker = class({})

------------------------------------------------------------------

function modifier_death_passive_thinker:OnDestroy()
	if IsServer() then

		local nMiniSpawns = RandomInt( 1, 2 )

		for i = 1, nMiniSpawns do		
			CreateUnitByNameAsync("npc_dota_creature_smaller_golem_mm", self:GetCaster():GetOrigin() + RandomVector( RandomInt( 0, 50 ) ), true, nil, nil, self:GetCaster():GetTeamNumber(), function(unit)
						unit:SetAngles(0,RandomInt( 90, 360 ),0)
						unit:SetDeathXP( 10 )
						unit:SetMinimumGoldBounty( 1 )
						unit:SetMaximumGoldBounty( 1 )

						--ParticleManager:ReleaseParticleIndex(  ParticleManager:CreateParticle( "particles/creeps/golem/golem_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit ) )
						local nFXIndex = ParticleManager:CreateParticle( "particles/creeps/golem/golem_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_ABSORIGIN_FOLLOW, nil, unit:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )


						self.nPreviewFX = ParticleManager:CreateParticle( "particles/creeps/golem/golem_sparks_parent.vpcf", PATTACH_CUSTOMORIGIN, unit )
						ParticleManager:SetParticleControlEnt( self.nPreviewFX, 3, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( self.nPreviewFX )
				end)	
		end

		UTIL_Remove( self:GetParent() )
		UTIL_Remove( self:GetCaster() )
	end
end