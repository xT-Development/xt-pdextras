Config = {}

-- Debug Configs --
Config.Debug = true
Config.DebugPoly = false

-- General Configs --
Config.RenewedPhone = true -- Enable if using Renewed-Phone / Uses qb-management if false
Config.PoliceJobs = { 'police' } -- Set to the name of your police job(s)
Config.Fuel = 'cdn-fuel' -- Set to the name of your fuel script

-- Enable / Disable Features --
Config.UseArmory = true
Config.UseBoatHeliLocations = true
Config.UseBossMenus = true
Config.UseEvidence = true
Config.UseGarages = true

-- Fines Config --
Config.FineCommand = {
    enable = true,
    command = 'fine',
    commission = { enable = true, amount = 0.05 } -- 5% of Fine
}

-- Webhooks Config --
Config.Webhooks = {
    Fines = { name = 'fines', title = 'Fined Player', color = 'green' },
    Certs = { name = 'pdcerts', color = 'green' },
}

-- Boss Menu Configs --
Config.BossMenus = {
    { label = 'PD Management', job = 'police', rank = 3, cert = 'none', coords = vec3(461.42, -986.25, 30.73), radius = 0.4 },
    { label = 'PD Management', job = 'police', rank = 4, cert = 'none', coords = vec3(447.05, -974.0, 30.5), radius = 0.4 }
}

-- Evidence Rooms Config --
Config.EvidenceRooms = { -- Locker locations (Spawn Peds)
    { label = 'Mission Row Evidence Room', model = 'a_f_y_femaleagent',  coords = vec4(465.27, -990.02, 24.91, 91.33), scenario = 'WORLD_HUMAN_CLIPBOARD' },
}
Config.EvidenceLockerSize = { slots = 50, size = 100000 } -- Size of lockers
Config.EvidenceCommand = 'evidence' -- Ex: /evidence 1   -- Opens Evidence 1
Config.EvidenceCommandDistance = 10 -- Evidence command is usable if player is within this distance from any accessible evidence locker
Config.WipeTrashInterval = 1 -- Minutes between clearing the trash cans

-- Grant / Revoke Certifications --
Config.Certifications = {
    command = 'pdcerts', -- Grant/Revoke Certs Menu
    viewCommand = 'viewcerts', -- View personal certs
    reqRank = 4, -- Required rank to grant/revoke certs
    certs = { -- Metadata values
        ['airone'] = 'Air One', -- Air-1
        ['mbu'] = 'Motorbike Unit', -- Motorbike Unit
        ['fto'] = 'Field Training Officer', -- Field Training Officer
        ['hsu'] = 'High Speed Unit', -- High Speed Unit
        ['classthree'] = 'Class 3 Weapons', -- Class 3
        ['classtwo'] = 'Class 2 Weapons', -- Class 2
        ['alr'] = 'Armalite Rifle', -- Armalite Rifle
        ['canine'] = 'Canine', -- Canine
        ['swat'] = 'S.W.A.T', -- SWAT
    }
}

--------------------------------------------

QBCore = exports['qb-core']:GetCoreObject()
sharedItems = exports.ox_inventory:Items()
sharedVehicles = QBCore.Shared.Vehicles