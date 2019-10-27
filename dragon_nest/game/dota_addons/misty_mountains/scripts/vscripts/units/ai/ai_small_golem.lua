
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	BoulderAbility = thisEntity:FindAbilityByName( "golem_boulder" )

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

	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = thisEntity:GetOrigin()
		thisEntity.bInitialized = true
	end

	if ( not thisEntity.bAcqRangeModified ) and thisEntity:GetAggroTarget() then
		thisEntity:SetAcquisitionRange( 900 )
		thisEntity.bAcqRangeModified = true
	end

	-- Are we too far from our initial spawn position?
	local fDist = ( thisEntity:GetOrigin() - thisEntity.vInitialSpawnPos ):Length2D()
	if fDist > 1000 then
		RetreatHome()
		return 1.0
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	
	local hChances = RandomInt( 0 , 2 )
	if hChances ~= 0 then
		for i=1,#enemies do
			local enemy = enemies[i]
			if enemy ~= nil then
				if enemy:IsRealHero() and enemy:IsAlive() then
					local bBoulderReady = ( #enemies > 0 and BoulderAbility ~= nil and BoulderAbility:IsFullyCastable() )
					if bBoulderReady then
						--print( "RandomInt"..hChances )
						return BoulderThrow( enemies[ RandomInt( 1, #enemies ) ] )
					-- elseif bEarthbindReady then
					-- 	return BindArea( enemies[ RandomInt( 1, #enemies ) ] )
					end
				end
			end
		end
	end

	local fFuzz = RandomInt( -1, 2 ) -- Adds some timing separation to these guys
	--print( 2 + fFuzz.."- Diff" )
	return 2 + fFuzz
end

--------------------------------------------------------------------------------
function RetreatHome()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.vInitialSpawnPos
	})
end

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

function BoulderThrow( enemy )

	-- if ( not thisEntity:HasModifier( "modifier_provide_vision" ) ) then
	-- 	--print( "If player can't see me, provide brief vision to his team as I start my Smash" )
	-- 	thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1 } )
	-- end

	local vEnemySpeed = enemy:GetBaseMoveSpeed()
	local vEnemyForward = enemy:GetForwardVector()
	local vPos = nil
	if enemy:IsMoving() then
		vPos = enemy:GetOrigin() + ( vEnemyForward * vEnemySpeed)
	else
		vPos = enemy:GetOrigin()
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = BoulderAbility:entindex(),
		Position = vPos,
		Queue = false,
	})

	return 0.25
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

