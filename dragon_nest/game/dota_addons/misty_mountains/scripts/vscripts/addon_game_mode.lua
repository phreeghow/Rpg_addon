-- Generated from template

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )

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
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end