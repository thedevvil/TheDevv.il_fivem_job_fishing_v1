
QBCore = exports['qb-core']:GetCoreObject()


QBCore.Functions.CreateUseableItem("fishingrod", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('fishing:fishstart', source)
end)

				
RegisterNetEvent('fishing:catch')
AddEventHandler('fishing:catch', function(bait)
	
	local src = source
	local weight = 2
	local luck = math.random(1,100)
	local Player = QBCore.Functions.GetPlayer(src)
			if luck >= 80 and luck <= 100 then
				randomItem = "salmon"
				itemInfo = QBCore.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
				fishname = "Somon"
				TriggerClientEvent('QBCore:Notify', src, "Balık Tuttun 1x "..fishname, 'success')
			elseif luck >= 70 and luck <= 80 then
				randomItem = "stripedbass"
				itemInfo = QBCore.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
				fishname = "Levrek"
				TriggerClientEvent('QBCore:Notify', src, "Balık Tuttun 1x "..fishname, 'success')
			elseif luck >= 0 and luck <= 70 then
				randomItem = "fish"
				itemInfo = QBCore.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
				fishname = "Balık"
				TriggerClientEvent('QBCore:Notify', src, "Balık Tuttun 1x "..fishname, 'success')
		else
			TriggerClientEvent('QBCore:Notify', src, "Balık Kaçtı", 'error')
	end
end)



RegisterServerEvent("qb-fishing:sellFish")
AddEventHandler("qb-fishing:sellFish", function()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local price = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k].name ~= nil then 
                if Player.PlayerData.items[k].name == "fish" then 
                    price = price + (Config.FishingItems["fish"]["price"] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("fish", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "stripedbass" then 
                    price = price + (Config.FishingItems["stripedbass"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("stripedbass", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "salmon" then 
                    price = price + (Config.FishingItems["salmon"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("salmon", Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-fish")
		TriggerClientEvent('QBCore:Notify', src, "Balıkları sattın $"..price)
		TriggerEvent("qb-bossmenu:server:addAccountMoney", 'fishing', price)
	end
end)