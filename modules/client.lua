local scully = GetResourceState('scully_emotemenu')
local rpemotes = GetResourceState('rpemotes')
local shown = false

local xTc = {}

-- Play Emote --
function xTc.Emote(emote)
    if scully == 'started' or scully == 'starting' then
        exports.scully_emotemenu:playEmoteByCommand(emote)
    end
    if rpemotes == 'started' or rpemotes == 'starting' then
        TriggerEvent('animations:client:EmoteCommandStart', {emote})
    end
end

-- End Emote --
function xTc.EndEmote()
    if scully == 'started' or scully == 'starting' then
        exports.scully_emotemenu:cancelEmote()
    end
    if rpemotes == 'started' or rpemotes == 'starting' then
        TriggerEvent('animations:client:EmoteCommandStart', {'c'})
    end
end

-- Create Vehicle
function xTc.CreateVehicle(hash, coords, plate, givekeys, locked)
    local model = GetHashKey(hash)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(50) end

    local vehicleID = CreateVehicle(model, coords.x, coords.y, coords.z, false, false)
    while not DoesEntityExist(vehicleID) do Wait(50) end
    SetModelAsNoLongerNeeded(model)
    SetVehicleOnGroundProperly(vehicleID)
    SetEntityInvincible(vehicleID, true)
    SetVehicleDirtLevel(vehicleID, 0.0)
    if locked then SetVehicleDoorsLocked(vehicleID, 2) else SetVehicleDoorsLocked(vehicleID, 1) end
    SetEntityHeading(vehicleID, coords.w)
    FreezeEntityPosition(vehicleID, true)
    SetVehicleNumberPlateText(vehicleID, plate)
    if givekeys then
        TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(vehicleID))
    end
    return vehicleID
end

-- Spawn Ped --
function xTc.Ped(model, coords, scenario)
    model = type(model) == 'string' and GetHashKey(model) or model

    lib.requestModel(model)
    local pedId = CreatePed(0, model, coords.x, coords.y, coords.z - 1, coords.w, false, false)
    TaskStartScenarioInPlace(pedId, scenario, 0, true)
    FreezeEntityPosition(pedId, true)
    SetEntityInvincible(pedId, true)
    SetBlockingOfNonTemporaryEvents(pedId, true)
    return pedId
end

-- Create Boss Menus --
function xTc.CreatePDBossMenus()
    for x = 1, #Config.BossMenus do
        local Location = Config.BossMenus[x]
        PDBossMenus[x] = exports.ox_target:addSphereZone({
            coords = Location.coords,
            radius = Location.radius,
            debug = Config.DebugPoly,
            drawSprite = true,
            options = {
                {
                    name = 'pdBossMenu',
                    label = Location.label,
                    icon = 'fas fa-briefcase',
                    event = "xt-pdextras:client:BossMenu",
                    onSelect = function()
                        TriggerEvent('xt-pdextras:client:BossMenu', x)
                    end,
                    canInteract = function()
                        local playerCerts, playerRank = lib.callback.await('xt-pdextras:server:CertsAndRank', false)
                        if (Location.rank == 0 or playerRank >= Location.rank) and (Location.cert == 'none' or playerCerts[Location.cert]) then return true else return false end
                    end,
                    job = Location.job,
                    distance = 2.5
                }
            }
        })
    end
end

-- Remove Boss Menus --
function xTc.CleanupPDBossMenus()
    for x = 1, #PDBossMenus do
        exports.ox_target:removeZone(PDBossMenus[x])
    end
end

-- Heli/Boat Peds --
function xTc.HeliBoatPeds()
    for x = 1, #Config.BoatsAndHelis do
        if DoesEntityExist(HeliAndBoatPeds[x]) then return end

        local location = Config.BoatsAndHelis[x]
        local label = location.label
        local ped = Config.BoatsAndHelis[x].ped
        HeliAndBoatPeds[x] = xTc.Ped(ped.model, ped.coords, ped.scenario)

        exports.ox_target:addLocalEntity(HeliAndBoatPeds[x], {
            {
                label = 'Access ' .. label,
                icon = ped.icon,
                onSelect = function()
                    TriggerEvent('xt-pdextras:client:HeliBoatMenu', x, label)
                end,
                job = location.job,
                distance = 2.0
            },
        })
    end
end

-- Remove Heli/Boat Peds --
function xTc.HeliBoatCleanup()
    for x = 1, #HeliAndBoatPeds do
        if DoesEntityExist(HeliAndBoatPeds[x]) then
            DeletePed(HeliAndBoatPeds[x])
        end
    end
end

-- Remove Points to Return Vehicles --
function xTc.RemoveVehicleReturnPoints()
    for r = 1, #ReturnPoints do
        for s = 1, #ReturnPoints[r] do
            ReturnPoints[r][s]:remove()
        end
    end
end

-- Enter Return Vehicle Point --
function xTc.EnterReturnPoint(class)
    local ped = cache.ped
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then return end
    local vehClass = GetVehicleClass(vehicle)
    if vehClass ~= class then return end
    if not shown then
        exports['qb-core']:DrawText('[E] - Store Vehicle')
        shown = true
    end
end

-- Exit Return Vehicle Point --
function xTc.ExitReturnPoint()
    if shown then
        exports['qb-core']:HideText()
        shown = false
    end
end

-- Inside Return Vehicle Point --
function xTc.InsideReturnPoint()
    local ped = cache.ped
    local veh = GetVehiclePedIsIn(ped, false)

    if veh == 0 then
        if shown then
            exports['qb-core']:HideText()
            shown = false
        end
        return
    end

    if not shown then
        exports['qb-core']:DrawText('[E] - Store Vehicle')
        shown = true
    end

    if IsControlJustPressed(0, 38) then
        QBCore.Functions.DeleteVehicle(veh)
        exports['qb-core']:HideText()
        shown = false
    end
end

-- Create Points to Return Vehicles --
function xTc.ReturnVehiclePoints()
    for x = 1, #Config.BoatsAndHelis do
        ReturnPoints[x] = {}
        for t = 1, #Config.BoatsAndHelis[x].returnLocations do
            local Location = Config.BoatsAndHelis[x].returnLocations[t]
            local vehClass = Config.BoatsAndHelis[x].class

            ReturnPoints[x][t] = lib.zones.poly({
                points = Location.coords,
                thickness = Location.radius,
                debug = Config.DebugPoly,
                inside = function()
                    xTc.InsideReturnPoint()
                end,
                onEnter = function()
                    xTc.EnterReturnPoint(vehClass)
                end,
                onExit = xTc.ExitReturnPoint
            })
        end
    end
end

-- Armory Zones --
function xTc.CreatePDArmory()
    for x = 1, #Config.Armory.locations do
        local Armory = Config.Armory.locations[x]
        ArmoryZone[x] = exports.ox_target:addBoxZone({
            coords = Armory.coords,
            size = Armory.size,
            rotation = Armory.heading,
            debug = Config.DebugPoly,
            options = {
                {
                    icon = Config.Armory.icon,
                    label = Config.Armory.title,
                    onSelect = function()
                        TriggerEvent('xt-pdextras:client:OpenArmory', x)
                    end,
                    job = Armory.job,
                    distance = 2.0
                }
            }
        })
    end
end

-- Remove Armory Zones --
function xTc.CleanupPDArmory()
    for x = 1, #ArmoryZone do
        exports.ox_target:removeZone(ArmoryZone[x])
    end
end

return xTc