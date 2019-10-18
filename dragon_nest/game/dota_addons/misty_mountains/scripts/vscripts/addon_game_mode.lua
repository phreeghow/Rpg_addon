-- wish I knew what I'm doing

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )

		ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CHoldoutGameMode, "OnGameRulesStateChange" ), self )

	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	GameRules:SetTimeOfDay( 0.75 )
	GameRules:SetHeroRespawnEnabled( false )
	--GameRules:SetUseUniversalShopMode( true )
	GameRules:SetHeroSelectionTime( 5.0 )
	GameRules:SetPreGameTime( 5.0 )
	GameRules:SetPostGameTime( 60.0 )
	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:SetHeroMinimapIconScale( 0.7 )
	GameRules:SetCreepMinimapIconScale( 0.7 )
	GameRules:SetRuneMinimapIconScale( 0.7 )
	GameRules:SetGoldTickTime( 60.0 )
	GameRules:SetGoldPerTick( 0 )
	GameRules:SetShowcaseTime( 0 )
	GameRules:SetCustomGameSetupAutoLaunchDelay(0) -- выбор тимы

	local mode = GameRules:GetGameModeEntity()

	mode:SetRemoveIllusionsOnDeath( true )
	mode:SetTopBarTeamValuesOverride( true )
	mode:SetTopBarTeamValuesVisible( false )
	mode:SetUnseenFogOfWarEnabled( true )
	mode:SetStashPurchasingDisabled( true )
	mode:SetCustomBuybackCooldownEnabled( true )
	mode:SetCustomBuybackCostEnabled( true )
 	mode:DisableHudFlip( true )
 	mode:SetLoseGoldOnDeath( false )
 	mode:SetFriendlyBuildingMoveToEnabled( true )
 	mode:SetDeathOverlayDisabled( true )
 	mode:SetHudCombatEventsDisabled( true )
	mode:SetWeatherEffectsDisabled( true )
	mode:SetCameraSmoothCountOverride( 2 )
	mode:SetSelectionGoldPenaltyEnabled( false )	
	mode:SetCameraDistanceOverride(1400)
	mode:SetDaynightCycleDisabled(true)
	mode:SetThink( "OnThink", self, "GlobalThink", 2 )
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running every second and so on." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function CHoldoutGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		--print( "OnGameRulesStateChange: Strategy Time" )
		self:ForceAssignHeroes()

	elseif nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		--print( "OnGameRulesStateChange: Hero Selection" )

	elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		--print( "OnGameRulesStateChange: Pre Game" )

	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "OnGameRulesStateChange: Game In Progress" )
	end
end

function CAddonTemplateGameMode:ForceAssignHeroes()
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hPlayer = PlayerResource:GetPlayer( nPlayerID )
			if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
				hPlayer:MakeRandomHeroSelection()
			end
		end
	end
end
