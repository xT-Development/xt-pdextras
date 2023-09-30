local Utils = require 'modules.shared'

-- Helicopter / Boat Menu --
AddEventHandler('xt-pdextras:client:HeliBoatMenu', function(station, label)
    local playerCerts, playerRank = lib.callback.await('xt-pdextras:server:CertsAndRank')
    local stationInfo = Config.BoatsAndHelis[station]
    local HeliMenu = {}
    for x = 1, #stationInfo.vehicles do
        local vehicle = stationInfo.vehicles[x]
        if (vehicle.rank == 0 or playerRank >= vehicle.rank) and (vehicle.cert == 'none' or playerCerts[vehicle.cert]) then
            HeliMenu[#HeliMenu + 1] = {
                title = vehicle.name,
                arrow = true,
                icon = stationInfo.ped.icon,
                event = 'xt-pdextras:client:SpawnHeliOrBoat',
                args = {
                    vehicle = vehicle.model,
                    livery = vehicle.livery,
                    coords = stationInfo.spawn,
                    station = station
                }
            }
        end
    end

    lib.registerContext({
        id = 'heli_menu',
        title =  label,
        options = HeliMenu
    })
    lib.showContext('heli_menu')
end)

-- Spawn Boat/Heli --
AddEventHandler('xt-pdextras:client:SpawnHeliOrBoat',function(data)
    if not Utils.CheckJob(Config.PoliceJobs) then return end

    QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        local veh = NetToVeh(netId)
        SetVehicleLivery(veh, data.livery)
        SetVehicleNumberPlateText(veh, Config.VehiclePlates..tostring(math.random(1000, 9999)))
        Wait(100)
        SetVehicleFixed(veh)
        exports[Config.Fuel]:SetFuel(veh, 100)
        TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh))
    end, data.vehicle, data.coords, true)
end)