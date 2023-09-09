local WearingNightVision = false
local Thermal = false
local ShowThermalUI = false

-- Check if Player is Wearing Night Vision Goggles --
local function WearingNV()
    local callback = false
    local NV = GetPedPropIndex(cache.ped, 0)
    for _, x in pairs(Config.Nightvision) do
        if NV == x then callback = true break end
    end
    return callback
end

-- Toggle Thermal Vision --
local function ToggleThermal()
    if not WearingNV() then return end
    Thermal = not Thermal
    lib.requestAnimDict('mp_masks@low_car@ds@')
    TaskPlayAnim(cache.ped, 'mp_masks@low_car@ds@', 'put_on_mask', 1.0, 1.0, 1000, 50, 0, false, false, false)
    Wait(1000)
    SetSeethrough(Thermal)
end

-- Toggle Night Vision --
local function ToggleNightVision(REMOVE)
    WearingNightVision = not WearingNightVision

    if ShowThermalUI then
        exports['qb-core']:HideText()
        ShowThermalUI = false
    end

    if WearingNightVision then
        lib.requestAnimDict('mp_masks@low_car@ds@')
        TaskPlayAnim(cache.ped, 'mp_masks@low_car@ds@', 'put_on_mask', 1.0, 1.0, 1000, 50, 0, false, false, false)
        Wait(1000)
        SetPedPropIndex(cache.ped, 0, 116, 0, true)
        SetTimecycleModifier("nightvision")
        SetTimecycleModifierStrength(1.0)
    else
        lib.requestAnimDict('missfbi4')
        TaskPlayAnim(cache.ped, 'missfbi4', 'takeoff_mask', 1.0, 1.0, 2000, 50, 0, false, false, false)
        Wait(1000)
        SetPedPropIndex(cache.ped, 0, 117, 0, true)
        ClearTimecycleModifier()
    end

    --if REMOVE then SetPedPropIndex(cache.ped, 0, -1, 0, true) end

    CreateThread(function()
        while WearingNightVision do
            if not WearingNV() then
                if ShowThermalUI then
                    exports['qb-core']:HideText()
                    ShowThermalUI = false
                end
                ClearTimecycleModifier()
            end

            if not ShowThermalUI then
                exports['qb-core']:DrawText('UP - Toggle Thermal')
                ShowThermalUI = true
            end

            if IsControlJustPressed(0, Config.ThermalKey) then
                ToggleThermal()
            end
            Wait(10)
        end
    end)
end

-- Night Vision Item --
exports('nightvision', function(data, slot)
    local playerPed = cache.ped
    if not WearingNV() then
        ToggleNightVision()
    else
        ToggleNightVision(true)
    end
end)

-- Slim Jims --
exports('slimjim', function(data, slot)
    local ped = cache.ped
    local pCoords = GetEntityCoords(ped)
    local veh, vehcoords = lib.getClosestVehicle(pCoords, 2.5, false)
    if not veh then QBCore.Functions.Notify('No vehicle nearby!', 'error') return end
    local difficulty = Config.SlimJim.difficulty[math.random(1, #Config.SlimJim.difficulty)]
    local keys = Config.SlimJim.keys

    local success = lib.skillCheck(difficulty, keys)
    Config.SlimJimSuccess(success, veh, vehcoords)
end)