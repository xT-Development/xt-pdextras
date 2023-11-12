local Utils = require 'modules.shared'
local xTs = require 'modules.server'

-- Get All Officers --
lib.callback.register('xt-pdextras:server:CertsAndRank', function(source, target) return xTs.CertsAndRank(source, target) end)

-- Get Player Vehicles in Specific Garage --
lib.callback.register('xt-pdextras:server:getPlayerVehiclesAtGarage', function(source, data)
    local vehicles = MySQL.query.await('SELECT * FROM `player_vehicles` WHERE `citizenid` = ? AND `garage` = ?', { data[1], data[2] })
    if vehicles and vehicles[1] then
        return vehicles
    end
    return nil
end)

-- Fine Player --
if Config.FineCommand.enable then
    RegisterNetEvent('xt-pdextras:server:FinePlayer', function(fine)
        local src = source
        local player = QBCore.Functions.GetPlayer(src)
        local targetPlayer = QBCore.Functions.GetPlayer(tonumber(fine[1]))

        if not targetPlayer then QBCore.Functions.Notify(src, 'Invalid ID', 'error') return end

        local pCoords = GetEntityCoords(GetPlayerPed(src))
        local targetCoords = GetEntityCoords(GetPlayerPed(targetPlayer.PlayerData.source))
        local dist = #(pCoords - targetCoords)

        if dist >= 6 then QBCore.Functions.Notify(src, 'You\'re too far away!', 'error') return end

        if targetPlayer.Functions.RemoveMoney('bank', math.ceil(fine[2]), 'paid-fine', 'xt-pdextras') then
            if Config.FineCommand.commission.enable then player.Functions.AddMoney('bank', math.ceil((fine[2] * Config.FineCommand.commission.amount)), 'fine-commission', 'xt-pdextras') end
            xTs.Log(Config.Webhooks.Fines.name, Config.Webhooks.Fines.color, Config.Webhooks.Fines.title,
            '**Officer:** '..player.PlayerData.charinfo.firstname..' ' ..player.PlayerData.charinfo.lastname ..'  \n'..
            '**Player:** '..targetPlayer.PlayerData.charinfo.firstname ..' ' ..targetPlayer.PlayerData.charinfo.lastname ..'  \n'..
            '**Fine Amount:** $'..math.ceil(fine[2])..'  \n'..
            '**Fine Reason: **'..fine[3])
        end
    end)

    lib.addCommand(Config.FineCommand.command, {
        help = 'Fine a Player (Police Only)',
        params = {},
        restricted = false
    }, function(source)
        local src = source
        TriggerClientEvent('xt-pdextras:client:FinePlayerMenu', src)
    end)
end