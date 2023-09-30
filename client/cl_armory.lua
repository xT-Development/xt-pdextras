local xTc = require 'modules.client'

-- Armory Menu --
AddEventHandler('xt-pdextras:client:OpenArmory', function(location)
    local ArmoryMenu = {}
    for x = 1, #Config.Armory.items do
        local Armory = Config.Armory.items[x]
        ArmoryMenu[#ArmoryMenu+1] = {
            title = Armory.title,
            icon = Armory.icon,
            event = 'xt-pdextras:client:ArmoryCategory',
            args = {
                category = x,
                location = location
            }
        }
    end

    ArmoryMenu[#ArmoryMenu+1] = {
        title = 'Restock Inventory',
        icon = 'fas fa-retweet',
        event = 'xt-pdextras:client:Restock',
        args = location
    }

    lib.registerContext({
        id = 'pd_armroy_menu',
        title = Config.Armory.title,
        options = ArmoryMenu
    })
    lib.showContext('pd_armroy_menu')
end)

-- Armory Category Menu --
AddEventHandler('xt-pdextras:client:ArmoryCategory', function(categoryInfo)
    local playerCerts, playerRank = lib.callback.await('xt-pdextras:server:CertsAndRank')
    local Items = Config.Armory.items[categoryInfo.category].items
    local ArmoryCategory = {}
    for x = 1, #Items do
        local Item = Items[x]
        local image

        if sharedItems[Item.item]?.client?.image then
            image = "https://cfx-nui-"..sharedItems[Item.item].client.image:gsub('^url%(nui://(.-)%)$', '%1')
        else
            image = "https://cfx-nui-ox_inventory/web/images/".. Item.item .. ".png"
        end

        if Config.Armory.items[categoryInfo.category].type == 'ammo' then
            ArmoryCategory[#ArmoryCategory+1] = {
                title = Item.label,
                icon = 'fas fa-bullseye',
                event = 'xt-pdextras:client:InputItemAmount',
                args = {
                    item = Item,
                    location = categoryInfo.location,
                    categoryInfo = categoryInfo
                }
            }
        else
            if (Item.rank == 0 or playerRank >= Item.rank) and (Item.cert == 'none' or playerCerts[Item.cert]) then
                ArmoryCategory[#ArmoryCategory+1] = {
                    title = sharedItems[Item.item].label,
                    icon = image,
                    image = image,
                    event = 'xt-pdextras:client:InputItemAmount',
                    metadata = { sharedItems[Item.item].description },
                    args = {
                        item = Item,
                        location = categoryInfo.location,
                        categoryInfo = categoryInfo
                    }
                }
            end
        end
    end
    lib.registerContext({
        id = 'pd_armory_category',
        title = Config.Armory.items[categoryInfo.category].title,
        menu = 'pd_armroy_menu',
        options = ArmoryCategory
    })
    lib.showContext('pd_armory_category')
end)

-- Input Amount of Item --
AddEventHandler('xt-pdextras:client:InputItemAmount', function(info)
    if info.item.type == 'weapon' then
        TriggerServerEvent('xt-pdextras:server:GetArmoryItem', info, 1)
    else
        local input = lib.inputDialog('Dialog title', {
            {type = 'number', label = 'Item Amount', description = '', icon = 'hashtag'},
        })
        if not input then return end
        TriggerServerEvent('xt-pdextras:server:GetArmoryItem', info, input[1])
    end
end)

-- Restock Inventory --
AddEventHandler('xt-pdextras:client:Restock', function(location)
    local PlayerCoords = GetEntityCoords(cache.ped)
    local armoryCoords = Config.Armory.locations[location].coords
    local dist = #(PlayerCoords - vector3(armoryCoords.x, armoryCoords.y, armoryCoords.z))

    if dist >= 6 then return end
    xTc.Emote('adjust')
    QBCore.Functions.Progressbar('pd_restock', 'Restocking Inventory...', 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        xTc.EndEmote()
        TriggerServerEvent('xt-pdextras:server:Restock', location)
    end, function()
        xTc.EndEmote()
        QBCore.Functions.Notify('Canceled...', 'error')
    end)
end)