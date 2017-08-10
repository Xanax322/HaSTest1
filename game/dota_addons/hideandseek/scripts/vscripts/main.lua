
XP_PER_LEVEL_TABLE = {
	0 -- 1	 
 }

deadTowerCounter = 0

function main:InitGameMode()
	print( "InitGameMode" )
	if GetMapName() == "has_11_players" then 
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 10 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 )
	else
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 )
	end
	--GameRules:SetTimeOfDay( 0.75 )
	GameRules:SetHeroRespawnEnabled( true )
	GameRules:SetUseUniversalShopMode( false )

	GameRules:SetPreGameTime( 5.0 )
	GameRules:SetPostGameTime( 15.0 )
	GameRules:SetTreeRegrowTime( 120.0 )
	GameRules:SetHeroMinimapIconScale( 0.6 )
	GameRules:SetCreepMinimapIconScale( 0.6 )
	GameRules:SetRuneMinimapIconScale( 0.6 )
	GameRules:SetGoldTickTime( 2.0 )
	GameRules:SetGoldPerTick( 3 )
	GameRules:SetStartingGold(1000)
	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	GameRules:GetGameModeEntity():SetBuybackEnabled( false )
	GameRules:GetGameModeEntity():SetRecommendedItemsDisabled( true )	
	GameRules:SetSameHeroSelectionEnabled( true )
	GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( false )
	GameRules:GetGameModeEntity():SetFixedRespawnTime(120)
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(1)		
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
	local GM = GameRules:GetGameModeEntity()
GM:SetCustomGameForceHero("npc_dota_hero_crystal_maiden")
GameRules:SetHeroSelectionTime(0)
GameRules:SetStrategyTime(0)
GameRules:SetShowcaseTime(0)
 
	
	--GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( true )

  
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(main, 'GameRulesStateChange'), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(main, 'OnNPCSpawn'), self)
--	ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(main, 'OnPlayerGainedLevel'), self)
--	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(main, 'OnItemPickedUp'), self)	
	ListenToGameEvent("dota_player_killed", Dynamic_Wrap(main, "OnHeroKilled"), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(main, 'OnGameRulesStateChange'), self)
	


end



function main:OnGameRulesStateChange(keys)
    local newState = GameRules:State_Get()
    if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        main:Timer()
    end
end


function main:Timer()
local numberOfPlayers = PlayerResource:GetPlayerCount()
	if numberOfPlayers == 11 then
		Timers:CreateTimer(2700, function()
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end)
	elseif numberOfPlayers == 9  then
		Timers:CreateTimer(2600, function()
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end)
	elseif numberOfPlayers == 9  then
		Timers:CreateTimer(2500, function()
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end)
	elseif numberOfPlayers == 8  then
		Timers:CreateTimer(2400, function()
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end)
	elseif numberOfPlayers == 7  then
		Timers:CreateTimer(2100, function()
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end)
	elseif numberOfPlayers == 6  then
		Timers:CreateTimer(1800, function()
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end)
	elseif numberOfPlayers == 5  then
		Timers:CreateTimer(1500, function()
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end)
	elseif numberOfPlayers == 4  then
		Timers:CreateTimer(1200, function()
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end)
	elseif numberOfPlayers == 3  then
		Timers:CreateTimer(900, function()
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end)
	else
		Timers:CreateTimer(600, function()
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end)
	end
end

function main:GameRulesStateChange(keys)
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		
		GameRules:GetGameModeEntity():SetContextThink("NightTimeThink", 
		function()
			EmitGlobalSound("Hero_Nightstalker.Darkness")
			GameRules:SetTimeOfDay( 0.75 )
			return 235
		end,
		0.1)

	end
end



function main:OnNPCSpawn(data)
	--print("spawn")
	local unit = EntIndexToHScript(data.entindex)

	if unit:IsHero() then	

		unit:SetAbilityPoints(0)

		for i = 0, 6 do
			local ability = unit:GetAbilityByIndex(i)
			if ability then
				ability:SetLevel(1)
			end 
		end

		if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then

			GameRules:GetGameModeEntity():SetContextThink("ReplaceHeroThink", 
			function()

				unit:AddNoDraw()
				unit = PlayerResource:ReplaceHeroWith(unit:GetPlayerID(), "npc_dota_hero_night_stalker", 0, 0)
				if GetMapName() == "OLD_map" then
				
				local table = {}
				table[1] = Vector(-5747,-4680,128)
				table[2] = Vector(5595,5896,128)
				table[3] = Vector(1000,6000,128)
				table[4] = Vector(4777,-5857,128)				
				table[5] = Vector(1030,-2239,128)
				
				unit:SetAbsOrigin(table[RandomInt(1,5)])

				else
				
				local table = {}
				table[1] = Vector(5751,5581,128)
				table[2] = Vector(5752,5582,128)
				table[3] = Vector(5753,5583,128)
				table[4] = Vector(5754,5584,128)				
				table[5] = Vector(5755,5585,128)
				
				unit:SetAbsOrigin(table[RandomInt(1,5)])
			
				end
			end,
			1)

		end

	end
end

function main:OnHeroKilled(data)
	local AllDead = true

	for i=0,10 do 
		if PlayerResource:IsValidPlayer(i) then
			local Hero = PlayerResource:GetSelectedHeroEntity(i)
			if Hero:IsAlive() and Hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				AllDead = false
			end
		end
	end

	if AllDead then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end
end
