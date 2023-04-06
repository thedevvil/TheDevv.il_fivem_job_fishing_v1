QBCore = exports['qb-core']:GetCoreObject()

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local fishing = false
local lastInput = 0
local pause = false
local pausetimer = 0
local correct = 0

local bait = "none"

Citizen.CreateThread(function()
	while true do
	Wait(600)
		if pause and fishing then
			pausetimer = pausetimer + 1
		end
	end
end)

Citizen.CreateThread(function()
	local sleep = 500
	while true do
		local playerPed = PlayerPedId()
		if fishing then
			sleep = 5
			if IsControlJustReleased(0, Keys['X']) or IsEntityDead(playerPed) or IsEntityInWater(playerPed) then
				FishingStop()
				QBCore.Functions.Notify("İşlem durduruldu..")
			end
			if fishing then
				local pos = GetEntityCoords(playerPed)
				if not (pos.x <= -1825.0 and pos.x >= -1864.0 and pos.y <= -1236.5 and pos.y >= -1269.0) or IsPedInAnyVehicle(playerPed) then
					FishingStop()
					QBCore.Functions.Notify("İşlem durduruldu..")
				end
			end	
		end	
		Wait(sleep)
	end
end)


			

Citizen.CreateThread(function()
	while true do
		local wait = math.random(Config.FishTime.a , Config.FishTime.b)
		Wait(wait)
			if fishing then
				pause = true
				exports.rprogress:MiniGame({
					Difficulty = "Easy",
					onComplete = function(success)
					  if success then
						TriggerServerEvent('fishing:catch', bait)
					   else
						QBCore.Functions.Notify("Balık Kaçtı..", "error")
					   end    
					end
				})
				input = 0
				pausetimer = 0
			end
			
	end
end)

FishingStop = function()
	fishing = false
	local pPed = PlayerPedId()
	local pEntity = "prop_fishing_rod_02"
	ClearPedTasks(pPed)
	SetCurrentPedWeapon(pPed, GetHashKey("WEAPON_UNARMED"), true)
end



RegisterNetEvent('fishing:fishstart')
AddEventHandler('fishing:fishstart', function()
	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(playerPed)
	if IsPedInAnyVehicle(playerPed) then
		QBCore.Functions.Notify("Araç içerisinde bunu yapamazsın","error")
	else
		if (pos.x <= -1825.0 and pos.x >= -1864.0 and pos.y <= -1236.5 and pos.y >= -1269.0) and not fishing then
			QBCore.Functions.Notify("Balık yakalama başladı","success")
			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_STAND_FISHING", 0, true)
			fishing = true
		else
			QBCore.Functions.Notify("Sadece belirlenen alanlarda balık tutabilirsiniz.","error")
		end
	end
end)



