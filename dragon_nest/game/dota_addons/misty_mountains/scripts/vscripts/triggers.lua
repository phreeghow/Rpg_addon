--[[ checkpoints ]]

function AbilityOn(trigger)
	local hUser = trigger.activator
	if hUser:GetUnitName() == "npc_dota_hero_dazzle" then
		hUser:SetDayTimeVisionRange(hUser:GetCurrentVisionRange()+100)
		--AddFOWViewer( hUser:GetTeamNumber(), hUser:GetOrigin(), 1000, 1000, false )
		hUser:AddNewModifier( hUser, nil, "modifier_keeper_of_the_light_spirit_form", { duration = 20} )
		print(hUser:GetCurrentVisionRange())
	else
		print(hUser:GetUnitName())
	end
end


function Bridge_OnStartTouch( trigger )
	local hHero = trigger.activator
	local sGateTriggerName = thisEntity:GetName()
	print( "Bridge_OnStartTouch: " .. sGateTriggerName .. " activated by " .. hHero:GetUnitName() )


	local hRelay = Entities:FindByName( nil, sGateTriggerName .. "_relay" )
	hRelay:Trigger()
	print( "Triggered relay named " .. hRelay:GetName() )
end



function Bridge_OnEndTouch( trigger )
	local hHero = trigger.activator
	local sGateTriggerName = thisEntity:GetName()
	print( "Bridge_OnStartTouch: " .. sGateTriggerName .. " activated by " .. hHero:GetUnitName() )

	local hRelay = Entities:FindByName( nil, sGateTriggerName .. "_relay_off" )
	hRelay:Trigger()
	print( "Triggered relay named " .. hRelay:GetName() )
end
