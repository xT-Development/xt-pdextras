Config = Config or {}

-- Armory Config --
-- locations
-- Quick Restock Config
-- Armory Items & Categories

Config.Armory = {
    title = 'Police Armory',
    icon = 'fas fa-handcuffs',
    locations = {
        { job = 'police', coords = vector3(458.67, -978.52, 30.69), size = vec3(7.0, 0.6, 1.0), heading = 90 }
    },
    restock = { -- Restock Inventory w/ These Items
        {
            item = 'WEAPON_COMBATPISTOL',
            amount = 1,
            max = 1,
            type = 'weapon',
            attachments = {
                { component = "COMPONENT_AT_PI_FLSH", label = "Flashlight" },
            }
        },
        {
            item = 'ammo-9',
            amount = 100,
            max = 100,
            type = 'item'
        },
        {
            item = 'ifaks',
            amount = 15,
            max = 15,
            type = 'item'
        },
        {
            item = 'armor',
            amount = 5,
            max = 5,
            type = 'item'
        },
        {
            item = 'WEAPON_STUNGUN',
            amount = 1,
            max = 1,
            type = 'weapon',
            attachments = 'none'
        },
        {
            item = 'handcuffs',
            amount = 1,
            max = 1,
            type = 'item',
        },
    },
    items = {
        {
            title = 'Weapons',
            type = 'weapons',
            icon = 'fas fa-gun',
            items = {
                {
                    type = 'weapon',
                    item = 'WEAPON_COMBATPISTOL',
                    rank = 0,
                    cert = 'none',
                    attachments = {
                        { component = "COMPONENT_AT_PI_FLSH", label = "Flashlight" },
                    }
                },
                {
                    type = 'weapon',
                    item = 'WEAPON_STUNGUN',
                    rank = 0,
                    cert = 'none',
                    attachments = {
                        { component = "COMPONENT_AT_PI_FLSH", label = "Flashlight" },
                    }
                },
                {
                    type = 'weapon',
                    item = 'WEAPON_NIGHTSTICK',
                    rank = 0,
                    cert = 'none',
                },
            }
        },
        {
            title = 'Ammo',
            type = 'ammo',
            icon = 'fas fa-bullseye',
            items = {
                { label = 'Pistol Ammo', item = 'ammo-9' },
                { label = 'SMG Ammo', item = 'ammo-rifle' },
                { label = 'Rifle Ammo', item = 'ammo-rifle2' },
                { label = 'Shotgun Ammo', item = 'ammo-shotgun' },
            }
        },
        {
            title = 'Medical Items',
            type = 'medical',
            icon = 'fas fa-hospital',
            items = {
                {
                    type = 'item',
                    item = 'ifaks',
                    rank = 0,
                    cert = 'none',
                },
                {
                    type = 'item',
                    item = 'armor',
                    rank = 0,
                    cert = 'none',
                },
            }
        },
        {
            title = 'Police Tools & Equipment',
            type = 'tools',
            icon = 'fas fa-certificate',
            items = {
                {
                    type = 'item',
                    item = 'handcuffs',
                    rank = 0,
                    cert = 'none',
                },
                {
                    type = 'item',
                    item = 'WEAPON_FLASHLIGHT',
                    rank = 0,
                    cert = 'none',
                },
                {
                    type = 'item',
                    item = 'empty_evidence_bag',
                    rank = 0,
                    cert = 'none',
                },
                {
                    type = 'item',
                    item = 'police_stormram',
                    rank = 0,
                    cert = 'none',
                },
            }
        },
    }
}