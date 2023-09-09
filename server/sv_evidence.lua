local Utils = require 'modules.shared'
local xTs = require 'modules.server'

-- Open Personal or Other Locker --
RegisterNetEvent('xt-pdextras:server:OpenPDLocker', function(LOCATION)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local EvidenceInfo = Config.EvidenceRooms[LOCATION]
    local pCoords = GetEntityCoords(GetPlayerPed(src))
    local lockerCoords = vec3(EvidenceInfo.coords.x, EvidenceInfo.coords.y, EvidenceInfo.coords.z)
    local dist = #(lockerCoords - pCoords)
    if dist >= 5 then return end

    local CID = Player.PlayerData.citizenid
    local Stash = MySQL.query.await("SELECT * FROM `ox_inventory` WHERE name = ?", { 'PD-Locker-'..CID })
    if not Stash[1] then
        exports.ox_inventory:RegisterStash('PD-Locker-'..CID, 'PD Locker '..CID, Config.EvidenceLockerSize.slots, Config.EvidenceLockerSize.size)
        Wait(1000)
        TriggerClientEvent('xt-pdextras:client:OpenPDLocker', src)
    else
        TriggerClientEvent('xt-pdextras:client:OpenPDLocker', src)
    end
end)

-- Open Evidence Locker --
RegisterNetEvent('xt-pdextras:server:OpenEvidenceLocker', function(DRAWER, LOCATION)
    local src = source
    local Stash = MySQL.query.await("SELECT * FROM `ox_inventory` WHERE name = ?", { 'PD-Evidence-'..DRAWER })
    local EvidenceInfo = Config.EvidenceRooms[LOCATION]
    local pCoords = GetEntityCoords(GetPlayerPed(src))
    local lockerCoords = vec3(EvidenceInfo.coords.x, EvidenceInfo.coords.y, EvidenceInfo.coords.z)
    local dist = #(lockerCoords - pCoords)
    if dist >= 5 then return end

    if not Stash[1] then
        exports.ox_inventory:RegisterStash('PD-Evidence-'..DRAWER, 'PD Evidence '..DRAWER, Config.EvidenceLockerSize.slots, Config.EvidenceLockerSize.size)
        Wait(1000)
        TriggerClientEvent('xt-pdextras:client:OpenEvidenceLocker', src, DRAWER)
    else
        TriggerClientEvent('xt-pdextras:client:OpenEvidenceLocker', src, DRAWER)
    end
end)

-- Open Trash Can --
RegisterNetEvent('xt-pdextras:server:OpenTrash', function(DRAWER)
    local src = source
    local Stash = MySQL.query.await("SELECT * FROM `ox_inventory` WHERE name = ?", { 'PD-Trash' })

    if not Stash[1] then
        exports.ox_inventory:RegisterStash('PD-Trash', 'PD Trash', Config.EvidenceLockerSize.slots, Config.EvidenceLockerSize.size)
        Wait(1000)
        TriggerClientEvent('xt-pdextras:client:OpenTrash', src)
    else
        TriggerClientEvent('xt-pdextras:client:OpenTrash', src)
    end
end)