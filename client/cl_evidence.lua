local xTc = require 'modules.client'
local evidenceroom = {}

-- Evidence Room Menu --
AddEventHandler('xt-pdextras:client:EvidenceRoom', function(ID)
    local EvidenceRoomMenu = {
        {
            title = 'Personal Locker',
            description = 'Access your personal locker',
            arrow = true,
            icon = 'fas fa-user-lock',
            event = 'xt-pdextras:client:OpenPDLocker',
            args = ID
        },
        {
            title = 'Evidence Lockers',
            description = 'Access evidence lockers',
            arrow = true,
            icon = 'fas fa-fingerprint',
            event = 'xt-pdextras:client:AccessEvidenceLockers',
            args = ID
        },
        {
            title = 'Trash Bin',
            description = 'Emptied Every '..Config.WipeTrashInterval..' Minute(s)',
            arrow = true,
            icon = 'fas fa-trash',
            event = 'xt-pdextras:client:OpenTrash',
            args = ID
        },
    }
    lib.registerContext({
        id = 'evidence_room',
        title = 'Evidence Room',
        options = EvidenceRoomMenu
    })
    lib.showContext('evidence_room')
end)

-- Open Trash Bin --
AddEventHandler('xt-pdextras:client:OpenTrash',function(LOCATION)
    if not exports.ox_inventory:openInventory('stash', {id = 'PD-Trash-'..LOCATION}) then
        TriggerServerEvent('xt-pdextras:server:RegisterTrash', LOCATION)
        exports.ox_inventory:openInventory('stash', {id = 'PD-Trash-'..LOCATION})
    end
end)

-- Open a Evidence Locker --
RegisterNetEvent('xt-pdextras:client:OpenEvidenceLocker',function(DRAWER, LOCATION)
    if not exports.ox_inventory:openInventory('stash', {id = 'PD-Evidence-'..DRAWER}) then
        TriggerServerEvent('xt-pdextras:server:RegisterEvidenceLocker', DRAWER, LOCATION)
        exports.ox_inventory:openInventory('stash', {id = 'PD-Evidence-'..DRAWER})
    end
end)

-- Open a PD Locker --
AddEventHandler('xt-pdextras:client:OpenPDLocker',function(LOCATION, CID)
    if not CID then
        CID = QBCore.Functions.GetPlayerData().citizenid
    end

    if not exports.ox_inventory:openInventory('stash', {id = 'PD-Locker-'..CID}) then
        TriggerServerEvent('xt-pdextras:server:RegisterPDLocker', LOCATION, CID)
        exports.ox_inventory:openInventory('stash', {id = 'PD-Locker-'..CID})
    end
end)

-- Open a Evidence Locker --
AddEventHandler('xt-pdextras:client:AccessEvidenceLockers',function(LOCATION)
    local input = lib.inputDialog('Evidence locker', {
        { type = 'number', label = 'Case / Evidence Number' },
    })
    if not input[1] then QBCore.Functions.Notify('Invalid Input', 'error') return end
    local lockerNumber = tonumber(input[1])
    QBCore.Functions.Notify('Opened Evidence Locker: '..lockerNumber)


    TriggerServerEvent("InteractSound_SV:PlayOnSource", "LockerOpen", 0.3)
    TriggerEvent('xt-pdextras:client:OpenEvidenceLocker', lockerNumber, LOCATION)
end)