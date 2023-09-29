Config = Config or {}

-- Get Vehicle Keys Function --
function Config.GetVehicleKeys(PLATE)
    -- Add your own acquired vehicle keys --

end

-- Garages Config --
Config.VehiclePlates = 'LSPD' -- Start of Plates
Config.Garages = {
    {
        label = 'Mission Row Garage',
        job = 'police',
        Ped = { model = 's_m_y_cop_01', coords = vec4(452.5, -993.56, 26.0, 179.85), scenario = 'WORLD_HUMAN_CLIPBOARD' },
        VehicleSpawn = vec4(447.34, -997.31, 25.15, 179.28),
        Vehicles = { -- Vehicle model, required rank, required cert, and vehicle mods
            { model = 'police',  rank = 0, cert = 'none', engine = 3, brakes = 2, transmission = 2, suspension = 2, armor = 2, turbo = true },
            { model = 'police2', rank = 0, cert = 'none', engine = 3, brakes = 2, transmission = 2, suspension = 2, armor = 2, turbo = true },
            { model = 'police3', rank = 0, cert = 'none', engine = 3, brakes = 2, transmission = 2, suspension = 2, armor = 2, turbo = true },
            { model = 'policeb', rank = 0, cert = 'mbu',  engine = 3, brakes = 2, transmission = 2, suspension = 2, armor = 2, turbo = true },
        }
    },
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
            { name = 'PD Dinghy',   model = 'dinghy3',  rank = 0, cert = 'none' },
            { name = 'PD Predator', model = 'predator', rank = 0, cert = 'none' },
        },
    },
}