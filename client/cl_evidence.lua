local xTc = require 'modules.client'
local evidenceroom = {}

-- Evidence Room Menu --
RegisterNetEvent('xt-pdextras:client:EvidenceRoom', function(ID)
    local EvidenceRoomMenu = {
        {
            title = 'Personal Locker',
            description = 'Access your personal locker',
            arrow = true,
            icon = 'fas fa-user-lock',
            serverEvent = 'xt-pdextras:server:OpenPDLocker',
            args = ID
        },
        {
            title = 'Evidence Lockers',
            description = 'Access evidence lockers',
            arrow = true,
            icon = 'fas fa-lock',
            event = 'xt-pdextras:client:AccessEvidenceLockers',
            args = ID
        },
        {
            title = 'Trash Bin',
            description = 'Access the trash bin | Wipes after tsunami',
            arrow = true,
            icon = 'fas fa-trash',
            serverEvent = 'xt-pdextras:server:OpenTrash',
            args = ID
        },
    }
    lib.registerContext({
        id = 'evidence_room',
        title = data,
        options = EvidenceRoomMenu
    })
    lib.showContext('evidence_room')
end)

-- Open Trash Bin --
RegisterNetEvent('xt-pdextras:client:OpenTrash',function()
    local CID = QBCore.Functions.GetPlayerData().citizenid
    exports.ox_inventory:openInventory('stash', { id = 'PD-Trash' })
end)

-- Open a Evidence Locker --
RegisterNetEvent('xt-pdextras:client:OpenEvidenceLocker',function(DRAWER)
    exports.ox_inventory:openInventory('stash', { id = 'PD-Evidence-'..DRAWER })
end)

-- Open a PD Locker --
RegisterNetEvent('xt-pdextras:client:OpenPDLocker',function(CID)
    if CID == nil then
        CID = QBCore.Functions.GetPlayerData().citizenid
        exports.ox_inventory:openInventory('stash', { id = 'PD-Locker-'..CID })
    else
        exports.ox_inventory:openInventory('stash', { id = 'PD-Locker-'..CID })
    end
end)

-- Open a Evidence Locker --
RegisterNetEvent('xt-pdextras:client:AccessEvidenceLockers',function(LOCATION)
    local input = lib.inputDialog('Evidence locker', {'Case / Evidence Number'})
    if not input then return end
    local lockerNumber = tonumber(input[1])
    QBCore.Functions.Notify('Opened Evidence locker: '..lockerNumber)
    if not input[1] then QBCore.Functions.Notify('Invalid input') return end

    TriggerServerEvent("InteractSound_SV:PlayOnSource", "LockerOpen", 0.3)
    TriggerServerEvent('xt-pdextras:server:OpenEvidenceLocker', lockerNumber, LOCATION)
end)
