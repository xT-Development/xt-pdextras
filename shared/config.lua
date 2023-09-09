Config = {}

-- Debug Configs --
Config.Debug = true -- Set to true to enable debug mode
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
    { label = 'PD Management', job = 'police', rank = 4, cert = 'none', coords = vec3(461.42, -986.25, 30.73), radius = 0.4 }
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

-- Boats & Helis Config --
Config.BoatsAndHelis = {
    {
        label = 'Mission Row Helipad',
        job = 'police',
        spawn = vec4(449.9, -981.46, 44.06, 360.0),
        class = 15, -- Vehicle Class Allowed
        ped = {
            model = 's_m_y_cop_01',
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            coords = vec4(463.67, -982.35, 43.69, 92.01),
            icon = 'fas fa-helicopter'
        },
        returnLocations = {
            {
                coords = {
                    vec(455.12957763672, -986.68438720703, 43),
                    vec(454.99450683594, -975.41595458984, 43),
                    vec(443.66360473633, -975.45849609375, 43),
                    vec(443.81823730469, -986.82061767578, 43)
                },
                radius = 10
            }
        },
        vehicles = {
            { name = 'PD Maverick', model = 'polmav', livery = 0, rank = 0, cert = 'none' },
        },
    },
    {
        label = 'PD Boats Dock',
        job = 'police',
        spawn = vec4(-785.92, -1438.53, 0.12, 138.35),
        class = 14, -- Vehicle Class Allowed
        ped = {
            model = 's_m_y_cop_01',
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            coords = vec4(-782.71, -1441.87, 1.6, 283.12),
            icon = 'fas fa-anchor'
        },
        returnLocations = {
            {
                coords = {
                    vec(-792.79852294922, -1452.7060546875, -3),
                    vec(-771.24548339844, -1427.0616455078, -3),
                    vec(-776.81048583984, -1422.7752685547, -3),
                    vec(-798.68078613281, -1447.5490722656, -3)
                },
                radius = 10
            }
        },
        vehicles = {
            { name = 'PD Dinghy', model = 'dinghy3', rank = 0, cert = 'none' },
            { name = 'PD Predator', model = 'predator', rank = 0, cert = 'none' },
        },
    },
}

--------------------------------------------

QBCore = exports['qb-core']:GetCoreObject()
sharedItems = exports.ox_inventory:Items()