-- Generated from template

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
	_G.CAddonTemplateGameMode = CAddonTemplateGameMode
end

require( "precache" )

--------------------------------------------------------------------------------

-- Precache resources, this hook happens before most things
function Precache( context )
	for _,Item in pairs( g_ItemPrecache ) do
		PrecacheItemByNameSync( Item, context )
	end

	for _,Unit in pairs( g_UnitPrecache ) do
		PrecacheUnitByNameAsync( Unit, function( unit ) end )
	end

	for _,Model in pairs( g_ModelPrecache ) do
		PrecacheResource( "model", Model, context  )
	end

	for _,Particle in pairs( g_ParticlePrecache ) do
		PrecacheResource( "particle", Particle, context  )
	end

	for _,ParticleFolder in pairs( g_ParticleFolderPrecache ) do
		PrecacheResource( "particle_folder", ParticleFolder, context )
	end

	for _,Sound in pairs( g_SoundPrecache ) do
		PrecacheResource( "soundfile", Sound, context )
	end
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()

	LinkModifiers()
end


function LinkModifiers()
	--LinkLuaModifier( "modifier_provides_fow_position", "modifiers/modifier_provides_fow_position", LUA_MODIFIER_MOTION_NONE )
end

function CAddonTemplateGameMode:InitGameMode()
	--print( "Template addon is loaded." )


	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	GameRules:SetTimeOfDay( 0.75 )
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetHeroRespawnEnabled( false )
	--GameRules:SetUseUniversalShopMode( true )
	GameRules:SetHeroSelectionTime( 0.0 )
	GameRules:SetPreGameTime( 0.0 )
	GameRules:SetPostGameTime( 60.0 )
	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:SetHeroMinimapIconScale( 0.7 )
	GameRules:SetCreepMinimapIconScale( 0.7 )
	GameRules:SetRuneMinimapIconScale( 0.7 )
	GameRules:SetGoldTickTime( 3600.0 )
	GameRules:SetGoldPerTick( 100 )
	GameRules:SetShowcaseTime( 0 )
	GameRules:SetCustomGameSetupAutoLaunchDelay(0) -- выбор тимы


	local mode = GameRules:GetGameModeEntity()

	mode:SetRemoveIllusionsOnDeath( true )
	mode:SetTopBarTeamValuesOverride( true )
	mode:SetTopBarTeamValuesVisible( false )
	mode:SetUnseenFogOfWarEnabled( true )
	mode:SetStashPurchasingDisabled( false )
	mode:SetCustomBuybackCooldownEnabled( true )
	mode:SetCustomBuybackCostEnabled( true )
 	mode:DisableHudFlip( false )
 	mode:SetLoseGoldOnDeath( false )
 	mode:SetFriendlyBuildingMoveToEnabled( true )
 	mode:SetDeathOverlayDisabled( true )
 	mode:SetHudCombatEventsDisabled( true )
	mode:SetWeatherEffectsDisabled( true )
	mode:SetCameraSmoothCountOverride( 2 )
	mode:SetSelectionGoldPenaltyEnabled( false )
	mode:SetCameraDistanceOverride(1120)
	mode:SetDaynightCycleDisabled(true)

	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CAddonTemplateGameMode, "OnGameRulesStateChange" ), self )
	mode:SetThink( "OnThink", self, "GlobalThink", 2 )
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function CAddonTemplateGameMode:OnGameRulesStateChange()
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