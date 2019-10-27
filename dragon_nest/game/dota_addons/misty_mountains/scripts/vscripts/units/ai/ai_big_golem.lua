
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	hWaves = thisEntity:FindAbilityByName( "golem_waves" ),

	thisEntity:SetContextThink( "GolemThink", GolemThink, 1 )
end

--------------------------------------------------------------------------------

function GolemThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity:GetHealthPercent() < 50 then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		for i=1,#enemies do
			local enemy = enemies[i]
			if enemy ~= nil then
				if enemy:IsRealHero() and enemy:IsAlive() then

					local bWavesReady = ( #enemies > 0 and hWaves ~= nil and hWaves:IsFullyCastable() )
					if bWavesReady then
						return CastWaves( hSiltUnit, hEnemies )
					-- elseif bEarthbindReady then
					-- 	return BindArea( enemies[ RandomInt( 1, #enemies ) ] )
					end
				end
			end
		end
	end

	

	local fFuzz = RandomFloat( 0, 0.5 ) -- Adds some timing separation to these guys
	return 0.5 + fFuzz
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

-- function BindArea( enemy )
-- 	if ( not thisEntity:HasModifier( "modifier_provide_vision" ) ) then
-- 		--print( "If player can't see me, provide brief vision to his team as I start my Smash" )
-- 		thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1 } )
-- 	end

-- 	local vEnemySpeed = enemy:GetBaseMoveSpeed()
-- 	local vEnemyForward = enemy:GetForwardVector()
-- 	local vPos = nil
-- 	if enemy:IsMoving() then
-- 		vPos = enemy:GetOrigin() + ( vEnemyForward * vEnemySpeed )
-- 	else
-- 		vPos = enemy:GetOrigin()
-- 	end

-- 	ExecuteOrderFromTable({
-- 		UnitIndex = thisEntity:entindex(),
-- 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
-- 		Position = vPos,
-- 		AbilityIndex = EarthbindAbility:entindex(),
-- 		Queue = false,
-- 	})
-- 	return 1.5
-- end

--------------------------------------------------------------------------------

function CastWaves()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hWaves:entindex(),
		Queue = false,
	})

	return 12
end

-- --------------------------------------------------------------------------------

-- function CastPoof()
-- 	ExecuteOrderFromTable({
-- 		UnitIndex = thisEntity:entindex(),
-- 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
-- 		AbilityIndex = SummonClones:entindex(),
-- 	})

-- 	return 2.5
-- end

