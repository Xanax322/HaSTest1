-- Generated from template

if main == nil then
	_G.main = class({})
end

require( 'main' )

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	
	---------------------------------models-------------------------------
	PrecacheModel("models/items/bounty_hunter/back_jawtrap.vmdl", context)	--snap trap
	PrecacheModel("models/items/wards/blood_seeker_ward/bloodseeker_ward.vmdl", context)	--tombstone
	PrecacheModel("models/items/wards/portal_ward/portal_ward.vmdl", context)	--ward
	PrecacheModel("models/props_structures/tower_dragon_black.vmdl", context)	--tower
	

	PrecacheModel("models/heroes/treant_protector/treant_protector.vmdl", context)	--protector

	---------------------------------spells-------------------------------
	PrecacheResource("particle", "particles/world_destruction_fx/tree_dire_destroy.vpcf", context) --snap trap
	PrecacheResource("particle", "particles/items_fx/dust_of_appearance.vpcf", context) --intent loock
	PrecacheResource("particle", "particles/units/heroes/hero_treant/treant_leech_seed_rope.vpcf", context) --seed
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healing_ward_fortunes_tout_ward_gold_flame.vpcf", context) --heal
	PrecacheResource("particle", "particles/msg_fx/msg_damage.vpcf", context) --heal
	PrecacheResource("particle", "particles/units/heroes/hero_lion/lion_base_attack_glow.vpcf", context) --seed base attack
	PrecacheResource("particle_folder", "particles/units/heroes/hero_witch_doctor/", context) --heal
	PrecacheResource("particle_folder", "particles/units/heroes/hero_oracle/", context) --heal



	---------------------------------sounds------------------------------	
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nightstalker.vsndevts", context ) --night		
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts", context ) --blink
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_oracle.vsndevts", context ) --heal


	local pathToIG = LoadKeyValues("scripts/items/items_game.txt") 
	PrecacheForHero("npc_dota_hero_bloodseeker", pathToIG, context)
	PrecacheForHero("npc_dota_witch_doctor",pathToIG,context)	
end


-- Create the game mode when we activate
function Activate()
	main:InitGameMode()
end



function IsForHero(str, tbl)
	if type(tbl["used_by_heroes"]) ~= type(1) and tbl["used_by_heroes"] then -- привет от вашего друга, индийского быдлокодера работающего за еду
		if tbl["used_by_heroes"][str] then
			return true
		end
	end
	return false
end

function PrecacheForHero(name,path,context)

	print('[PrecacheHero] Start')
print("----------------------------------------Precache Start----------------------------------------")

	local wearablesList = {} --переменная для надеваемых шмоток(для всех героев)
	local precacheWearables = {} --переменная только для шмоток нужного героя
	local precacheParticle = {}
	for k, v in pairs(path) do
		if k == 'items' then
			wearablesList = v
		end
	end
	local counter = 0
	local counter_particle = 0
	local value
	for k, v in pairs(wearablesList) do -- выбираем из списка предметов только предметы на нужных героев
		if IsForHero(name, wearablesList[k]) then
			if wearablesList[k]["model_player"] then
				value = wearablesList[k]["model_player"] 
				precacheWearables[value] = true
			end
			if wearablesList[k]["particle_file"] then -- прекешируем еще и частицы, куда ж без них!
				value = wearablesList[k]["particle_file"] 
				precacheParticle[value] = true
			end
		end
	end

	for wearable,_ in pairs( precacheWearables ) do --собственно само прекеширование всех занесенных в список шмоток
		print("Precache model: " .. wearable)
		PrecacheResource( "model", wearable, context )
		counter = counter + 1
	end

	for wearable,_ in pairs( precacheParticle) do --и прекеширование частиц
		print("Precache particle: " .. wearable)
		PrecacheResource( "particle", wearable, context )
		counter_particle = counter_particle + 1

	end

	PrecacheUnitByNameSync(name, context) -- прекешируем саму модель героя! иначе будут бегать шмотки без тела
		
    print('[Precache]' .. counter .. " models loaded and " .. counter_particle .." particles loaded")
	print('[Precache] End')

end
