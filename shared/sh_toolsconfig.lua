Config = Config or {}

-- Nightvision Configuration --
Config.Nightvision = { 116, 117 } -- Night vision goggles clothing indexes
Config.ThermalKey = 172 -- Toggle Thermal (Up Arrow)

-- Slim Jim Configuration --
Config.SlimJim = {
    difficulty = { -- Choose random difficulty
        {'easy', 'easy'}
    },
    keys = { 'e' }
}

-- Slim Jim Success Function --
function Config.SlimJimSuccess(success, vehicle, vehCoords)
    local chance = math.random(1, 100)
    local pdChance = 50
    if success then
        QBCore.Functions.Notify('You unlocked the door!', 'success')
        pdChance = math.random(10, 20)
    else
        QBCore.Functions.Notify('You failed to unlock the door!', 'error')
        pdChance = math.random(50, 80)
    end

    if chance <= pdChance then exports['ps-dispatch']:CarJacking(vehicle) end
end