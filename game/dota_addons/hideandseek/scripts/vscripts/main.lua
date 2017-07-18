
XP_PER_LEVEL_TABLE = {
	0 -- 1	 
 }

deadTowerCounter = 0

function main:InitGameMode()
	print( "InitGameMode" )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 )
	
	--GameRules:SetTimeOfDay( 0.75 )
	GameRules:SetHeroRespawnEnabled( false )
	GameRules:SetUseUniversalShopMode( false )
	GameRules:SetHeroSelectionTime( 10.0 )
	GameRules:SetPreGameTime( 5.0 )
	GameRules:SetPostGameTime( 60.0 )
	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:SetHeroMinimapIconScale( 0.3 )
	GameRules:SetCreepMinimapIconScale( 0.3 )
	GameRules:SetRuneMinimapIconScale( 0.3 )
	GameRules:SetGoldTickTime( 1.0 )
	GameRules:SetGoldPerTick( 3 )
	GameRules:SetStartingGold(1000)
	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	GameRules:GetGameModeEntity():SetBuybackEnabled( false )
	GameRules:GetGameModeEntity():SetRecommendedItemsDisabled( true )	
	GameRules:SetSameHeroSelectionEnabled( true )

	GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( false )
	
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(1)		
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )


	GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)	
	GameRules:SetUseBaseGoldBountyOnHeroes(false)
	
	
	--GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( true )

    ListenToGameEvent('entity_killed', Dynamic_Wrap(main, 'OnEntityKilled'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(main, 'GameRulesStateChange'), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(main, 'OnNPCSpawn'), self)
--	ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(main, 'OnPlayerGainedLevel'), self)
--	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(main, 'OnItemPickedUp'), self)	
	ListenToGameEvent("dota_player_killed", Dynamic_Wrap(main, "OnHeroKilled"), self)
	


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

				local table = {}
				table[1] = Vector(-3200,-4352,128)
				table[2] = Vector(-1563,-512,128)
				table[3] = Vector(-3584,3840,128)
				table[4] = Vector(4864,3840,128)				
				table[5] = Vector(3456,-4352,128)

				unit:SetAbsOrigin(table[RandomInt(1,5)])
			end,
			1)

		end

	end
end


function main:OnHeroKilled(data)
--	print("hero killed")

	local killedUnit = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	local point = {}
	point[1] = Vector(-838,1944,256)
	point[2] = Vector(3526,-1266,256)
	point[3] = Vector(-640,-4480,256)

	killedUnit:SetAbsOrigin(point[RandomInt(1,3)])

	local newItem = CreateItem( "item_tombstone", killedUnit, killedUnit )
	newItem:SetPurchaseTime( 0 )
	newItem:SetPurchaser( killedUnit )
	local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )
	tombstone:SetContainedItem( newItem )
	tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
	FindClearSpaceForUnit( tombstone, killedUnit:GetAbsOrigin(), true )	

	local AllDead = true

	for i=0,5 do
		if PlayerResource:IsValidPlayer(i) then
			local player = PlayerResource:GetSelectedHeroEntity(i)
			if player:IsAlive() and (player:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
				AllDead = false
			end
		end
	end

	if AllDead then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end

end


function main:OnEntityKilled (event)
   local killedEntity = EntIndexToHScript(event.entindex_killed)

    if killedEntity:GetUnitName() == "blood_tower" then
    	deadTowerCounter = deadTowerCounter + 1
		--EmitGlobalSound("Invasion.HommerWin")
	end	

	if deadTowerCounter >= 5 then
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end

end