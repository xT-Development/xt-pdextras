Config = Config or {}

-- Colors of Blips Based on Job --
Config.JobColors = {
    ['police'] = {
        color = 26,
    }
}

-- Blips Sprite / Size Based on Vehicle Class --
Config.DutyBlips = {
    ['none'] = { -- Walking
        size = 1.0,
        sprite = 126
    },
    ['veh'] = { -- Other vehicles
        classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 20, 21, 22 },
        size = 1.0,
        sprite = 225
    },
    ['pdveh'] = { -- PD vehicles
        classes = { 18, 19 },
        size = 1.0,
        sprite = 56
    },
    ['bike'] = { -- Motorbike
        classes = { 13 },
        size = 1.0,
        sprite = 226
    },
    ['heli'] = { -- Helicopters
        classes = { 15 },
        size = 1.0,
        sprite = 43
    },
    ['plane'] = { -- Planes
        classes = { 16 },
        size = 1.0,
        sprite = 307
    },
    ['boat'] = { -- Boats
        classes = { 14 },
        size = 1.0,
        sprite = 427
    },
}