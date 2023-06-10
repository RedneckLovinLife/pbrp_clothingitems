local QBCore = exports['qb-core']:GetCoreObject()

local ClothesList = {}

function RegisterClothes()
	for i = 1, #Config do
		QBCore.Functions.CreateUseableItem(Config[i].itemName , function(source, item)
			local Player = QBCore.Functions.GetPlayer(source)
			Player.Functions.RemoveItem(Config[i].itemName, 1)
			TriggerClientEvent('pbrpClothingItems', source, i, Config[i].label)
			updateClothes(Config[i].itemName, source)
		end)
	end
end

Citizen.CreateThread(function()
	RegisterClothes()
	readClothes()
end)

readClothes = function() MySQL.Async.fetchAll('SELECT * FROM players', {}, function(result) for k, v in pairs(result) do if v.clothes then ClothesList[v.citizenid] = v.clothes end end end) end 

updateClothes = function(outfit, src)
	local xPlayer = QBCore.Functions.GetPlayer(src)
	local ident = xPlayer.PlayerData.citizenid
	if ClothesList[ident] then xPlayer.Functions.AddItem(ClothesList[ident], 1) end
	ClothesList[ident] = outfit
	MySQL.Async.execute('UPDATE players SET clothes = @clothes WHERE citizenid = @identifier', {
		['clothes'] = outfit,
		['identifier'] = ident,
	})
end

QBCore.Functions.CreateCallback('pbrpClothingItems:GetClothes', function(source, cb)
	local source = source
	local xPlayer = QBCore.Functions.GetPlayer(source)
	cb(ClothesList[xPlayer.PlayerData.citizenid])

end)

RegisterCommand('deleteoutfit', function(source, args)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local ident = xPlayer.PlayerData.citizenid
	if ClothesList[ident] then
		ClothesList[ident] = nil
		MySQL.Async.execute('UPDATE players SET clothes = NULL WHERE citizenid = @identifier', {
			['identifier'] = ident,
		})
	end
end)

-- RegisterNetEvent('pbrpClothingItems:reset')
-- AddEventHandler('pbrpClothingItems:reset', function()
RegisterCommand('changeback', function(source, args)
	local src = source
	local xPlayer = QBCore.Functions.GetPlayer(src)
	local ident = xPlayer.PlayerData.citizenid
	if ClothesList[ident] then
  		xPlayer.Functions.AddItem(ClothesList[ident], 1)
  		Citizen.Wait(100)
		ClothesList[ident] = nil
  		Citizen.Wait(100)
		MySQL.Async.execute('UPDATE players SET clothes = NULL WHERE citizenid = @identifier', {
			['identifier'] = ident,
		})
		Citizen.Wait(100)
		--TriggerClientEvent('skinchanger:client:loadSkin', skin)
        TriggerClientEvent("illenium-appearance:client:reloadSkin", source)
	end
end)
