local Utils = require 'modules.shared'

-- Open PD Garage Menu --
AddEventHandler('xt-pdextras:client:PDGarageMenu', function(station, label)
    local playerCerts, playerRank = lib.callback.await('xt-pdextras:server:CertsAndRank')
    local GarageMenu = {}
    for x = 1, #Config.Garages[station].Vehicles do
        local vehicle = Config.Garages[station].Vehicles[x]
        if (vehicle.rank == 0 or playerRank >= vehicle.rank) and (vehicle.cert == 'none' or playerCerts[vehicle.cert]) then
            GarageMenu[#GarageMenu + 1] = {
                title = sharedVehicles[vehicle.model]?.name or GetDisplayNameFromVehicleModel(vehicle.model),
                arrow = true,
                icon = 'fas fa-car',
                event = 'xt-pdextras:client:SpawnVehicle',
                args = {
                    vehicle = x,
                    station = station
                }
            }
        end
    end
    lib.registerContext({
        id = 'garage_menu',
        title =  label,
        options = GarageMenu
    })
    lib.showContext('garage_menu')
end)

-- Spawn PD Vehicle --
AddEventHandler('xt-pdextras:client:SpawnVehicle',function(data)
    if not Utils.CheckJob(Config.PoliceJobs) then return end

    local stationInfo = Config.Garages[data.station]
    local vehInfo = Config.Garages[data.station].Vehicles[data.vehicle]
    QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        local veh = NetToVeh(netId)
        SetVehicleNumberPlateText(veh, Config.VehiclePlates..tostring(math.random(1000, 9999)))

        -- Peformance Mods
        Wait(100)
        SetVehicleModKit(veh, 0)
        SetVehicleMod(veh, 11, vehInfo.engine, false) --engine
        SetVehicleMod(veh, 12, vehInfo.brakes, false) --brakes
        SetVehicleMod(veh, 13, vehInfo.transmission, false) --transmission
        SetVehicleMod(veh, 15, vehInfo.suspension, false) --suspension
        SetVehicleMod(veh, 16, vehInfo.armor, false) --armor
        ToggleVehicleMod(veh,  18, vehInfo.turbo) --turbo

        SetVehicleFixed(veh)
        exports[Config.Fuel]:SetFuel(veh, 100)

        Config.GetVehicleKeys(QBCore.Functions.GetPlate(veh))
    end, vehInfo.model, stationInfo.VehicleSpawn, true)
end)