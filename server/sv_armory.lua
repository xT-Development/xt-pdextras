-- Get Inventory Item --
RegisterNetEvent('xt-pdextras:server:GetArmoryItem', function(armoryData, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local PlayerCoords = GetEntityCoords(GetPlayerPed(src))
    local armoryCoords = Config.Armory.locations[armoryData.location].coords
    local dist = #(PlayerCoords - vector3(armoryCoords.x, armoryCoords.y, armoryCoords.z))
    if dist >= 5 then return  end
    if armoryData.item.type == 'weapon' then
        local info = { attachments = armoryData.item.attachments }
        if exports.ox_inventory:AddItem(src, armoryData.item.item, amount, info) then
            TriggerClientEvent('xt-pdextras:client:ArmoryCategory', src, armoryData.categoryInfo)
            return
        end
    else
        if exports.ox_inventory:AddItem(src, armoryData.item.item, amount) then
            TriggerClientEvent('xt-pdextras:client:ArmoryCategory', src, armoryData.categoryInfo)
            return
        end
    end
end)

-- Restock Inventory --
RegisterNetEvent('xt-pdextras:server:Restock', function(location)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local PlayerCoords = GetEntityCoords(GetPlayerPed(src))
    local armoryCoords = Config.Armory.locations[location].coords
    local dist = #(PlayerCoords - vector3(armoryCoords.x, armoryCoords.y, armoryCoords.z))
    local itemCount = 0
    if dist >= 5 then return  end

    for x = 1, #Config.Armory.restock do
        local Item = Config.Armory.restock[x]
        local Amount = exports.ox_inventory:Search(src, 'count', Item.item)
        if Amount ~= nil then
            if Amount < Item.max then
                local difference = (Item.max - Amount)
                if Item.type == 'weapon' and Item.attachments ~= 'none' then
                    local info = { attachments = Item.attachments }
                    if exports.ox_inventory:AddItem(src, Item.item, Item.amount, info) then
                        itemCount = itemCount + 1
                        if itemCount == #Config.Armory.restock then return end
                    end
                else
                    if Item.type == 'weapon' and Item.attachments ~= 'none' then
                        local info = { attachments = Item.attachments }
                        if exports.ox_inventory:AddItem(src, Item.item, Item.amount, info) then
                            itemCount = itemCount + 1
                            if itemCount == #Config.Armory.restock then return end
                        end
                    else
                        if exports.ox_inventory:AddItem(src, Item.item, difference) then
                            itemCount = itemCount + 1
                            if itemCount == #Config.Armory.restock then return end
                        end
                    end
                end
            else
                itemCount = itemCount + 1
                if itemCount == #Config.Armory.restock then return end
            end
        else
            if Item.type == 'weapon' and Item.attachments ~= 'none' then
                local info = { attachments = Item.attachments }
                if exports.ox_inventory:AddItem(src, Item.item, Item.amount, info) then
                    itemCount = itemCount + 1
                    if itemCount == #Config.Armory.restock then return end
                end
            else
                if exports.ox_inventory:AddItem(src, Item.item, Item.amount) then
                    itemCount = itemCount + 1
                    if itemCount == #Config.Armory.restock then return end
                end
            end
        end
    end
end)