local QBCore = exports['qb-core']:GetCoreObject() 
updateClothing = function()
	local playerPed = PlayerPedId()
	QBCore.Functions.TriggerCallback('pbrpClothingItems:GetClothes', function(outfitname) for i = 1, #Config do if Config[i].itemName == outfitname then for k, v in pairs(Config[i].set) do SetPedComponentVariation(playerPed, v.c1, v.c2, v.c3, 0) end end end end)
end

RegisterNetEvent('pbrpClothingItems')
AddEventHandler('pbrpClothingItems', function(number, label)
	local playerPed = PlayerPedId()
	for k, v in pairs(Config[number].set) do SetPedComponentVariation(playerPed, v.c1, v.c2, v.c3, 0) end
	QBCore.Functions.Notify("You've put on " .. label, 'success', 1500)
end)

Citizen.CreateThread(function()
	Wait(5000)
	while not LocalPlayer.state['isLoggedIn'] do
		Wait(1000)
	end
	Wait(10000) 
	updateClothing()
end)

-- RegisterCommand('changeback', function()
-- 	local xPlayer = QBCore.Functions.GetPlayer(source)
-- 	local ident = xPlayer.PlayerData.citizenid
-- 	TriggerEvent('skinchanger:getSkin', function(skin)
-- 		print("heere")
-- 		if skin == nil then
-- 			print("Skin wasn't loaded properly from illenium. Report error to Developer Team.")
-- 		else
-- 			TriggerServerEvent('pbrpClothingItems:reset')
-- 			TriggerEvent('skinchanger:loadSkin', skin)
-- 			TriggerEvent("illenium-appearance:client:reloadSkin", source)
-- 			print("Triggered")
-- 		end
-- 	end)
-- end)
