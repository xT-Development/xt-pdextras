local Utils = require 'modules.shared'
local xTs = require 'modules.server'

-- Open Personal or Other Locker --
RegisterNetEvent('xt-pdextras:server:RegisterPDLocker', function(LOCATION, CID)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local EvidenceInfo = Config.EvidenceRooms[LOCATION]
    local pCoords = GetEntityCoords(GetPlayerPed(src))
    local lockerCoords = vec3(EvidenceInfo.coords.x, EvidenceInfo.coords.y, EvidenceInfo.coords.z)
    local dist = #(lockerCoords - pCoords)
    if dist >= 5 then return end

    exports.ox_inventory:RegisterStash('PD-Locker-'..CID, 'PD Locker '..CID, Config.EvidenceLockerSize.slots, Config.EvidenceLockerSize.size)
end)

-- Open Evidence Locker --
RegisterNetEvent('xt-pdextras:server:RegisterEvidenceLocker', function(DRAWER, LOCATION)
    local src = source
    local EvidenceInfo = Config.EvidenceRooms[LOCATION]
    local pCoords = GetEntityCoords(GetPlayerPed(src))
    local lockerCoords = vec3(EvidenceInfo.coords.x, EvidenceInfo.coords.y, EvidenceInfo.coords.z)
    local dist = #(lockerCoords - pCoords)
    if dist >= 5 then return end

    exports.ox_inventory:RegisterStash('PD-Evidence-'..DRAWER, 'PD Evidence '..DRAWER, Config.EvidenceLockerSize.slots, Config.EvidenceLockerSize.size)
end)

-- Open Trash Can --
RegisterNetEvent('xt-pdextras:server:RegisterTrash', function(LOCATION)
    local src = source
    local TrashInfo = Config.EvidenceRooms[LOCATION]
    local pCoords = GetEntityCoords(GetPlayerPed(src))
    local TrashCoords = vec3(TrashInfo.coords.x, TrashInfo.coords.y, TrashInfo.coords.z)
    local dist = #(TrashCoords - pCoords)
    if dist >= 5 then return end

    exports.ox_inventory:RegisterStash('PD-Trash-'..LOCATION, 'PD Trash '..LOCATION, Config.EvidenceLockerSize.slots, Config.EvidenceLockerSize.size)
end)

-- Evidence Command --
lib.addCommand(Config.EvidenceCommand, {
    help = 'Open / Create an Evidence Locker',
    params = {
        {
            name = 'locker',
            type = 'number',
            help = 'Evidence Locker #',
            optional = false,
        },
    },
    restricted = false
}, function(source, args, raw)
    if not Utils.CheckJob(Config.PoliceJobs, source) then return end
    local closestLocker = xTs.ClosestEvidenceLocker(source, Config.EvidenceCommandDistance)
    if not closestLocker then QBCore.Functions.Notify(source, 'You are not near an evidence locker!', 'error') end
    TriggerClientEvent('xt-pdextras:client:OpenEvidenceLocker', source, args.locker, closestLocker)
end)

-- Empty Trash Cans --
lib.cron.new(('*/%s * * * *'):format(Config.WipeTrashInterval), function()
    for x = 1, #Config.EvidenceRooms do
        local Trash = MySQL.query.await("SELECT * FROM `ox_inventory` WHERE name = ?", { 'PD-Trash-'..x })
        if not Trash and not Trash[1] then return end

        exports.ox_inventory:ClearInventory(Trash[1].name)
        Utils.Debug(Trash[1].name..' Emptied')
    end
end)