-- Some code is reused from qb-policejob, but im not a braindead dummy and made it better

local officerBlips = {}

-- Cache Vehilce Class --
lib.onCache('vehicle', function(value)
    local newClass = nil
    if value then
        newClass = GetVehicleClass(value)
    end
    TriggerServerEvent('xt-pdextras:server:updateVehClass', newClass)
end)

-- Cleanup --
local function removeAllDutyBlips()
    if not officerBlips then return end

    for x = 0, #officerBlips do
        if DoesBlipExist(officerBlips[x]) then
            RemoveBlip(x)
        end
    end
end

-- Get Info From Config --
local function getBlipInfo(vehClass)
    local callback = nil
    for x, t in pairs(Config.DutyBlips) do
        if t.classes then
            for _, k in ipairs(t.classes) do
                if vehClass == k then
                    callback = Config.DutyBlips[x]
                    break
                end
            end
        end
    end
    return callback
end

-- Get Color Based on Job --
local function getBlipColor(job)
    local callback = nil
    for x, t in pairs(Config.JobColors) do
        if job == x then
            callback = t.color
            break
        end
    end
    return callback
end

-- Create Blips --
local function CreateDutyBlips(playerId, playerLabel, playerJob, playerLocation, vehClass)
    if DoesBlipExist(officerBlips[playerId]) then
        SetBlipCoords(officerBlips[playerId], playerLocation.x, playerLocation.y, playerLocation.z)
    else
        officerBlips[playerId] = AddBlipForCoord(playerLocation.x, playerLocation.y, playerLocation.z)
    end

    local blipInfo
    local blipColor = getBlipColor(playerJob)

    if not vehClass then
        blipInfo = Config.DutyBlips['none']
    else
        blipInfo = getBlipInfo(vehClass)
    end

    SetBlipSprite(officerBlips[playerId], blipInfo.sprite)

    ShowHeadingIndicatorOnBlip(officerBlips[playerId], true)
    SetBlipRotation(officerBlips[playerId], math.ceil(playerLocation.w))
    SetBlipScale(officerBlips[playerId], blipInfo.size)
    SetBlipColour(officerBlips[playerId], blipColor)
    SetBlipAsShortRange(officerBlips[playerId], false)
    SetBlipCategory(officerBlips[playerId], 255)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(playerLabel)
    EndTextCommandSetBlipName(officerBlips[playerId])
end

-- Remove Non Existent Blips, Create New Blips --
RegisterNetEvent('xt-pdextras:client:updateDutyBlips', function(blipsData)
    for x = 0, #officerBlips do
        if DoesBlipExist(officerBlips[x]) then
            for _, data in pairs(blipsData) do
                if blipsData.source == x then
                    break
                end
            end
            RemoveBlip(officerBlips[x])
            officerBlips[x] = nil
        end
    end

    for _, data in pairs(blipsData) do
        local id = GetPlayerFromServerId(data.source)
        if id ~= PlayerId() then -- Ignore your own blip
            CreateDutyBlips(id, data.label, data.job, data.location, data.vehClass)
        end
    end
end)

-- Handlers --
local function syncBlip(player, job) -- Sync blips w duty/job changes + reources start/player load
    local job = player.job or job
    if job.type == "leo" then
        local callSign = player.metadata['callsign']
        if not job.onduty then
            TriggerServerEvent('xt-pdextras:server:updateBlipInfo') -- Remove blip if it exist
        else
            TriggerServerEvent('xt-pdextras:server:updateBlipInfo', job.name, callSign) -- Set blip info
            if cache.vehicle then
                local class = GetVehicleClass(cache.vehicle)
                TriggerServerEvent('xt-pdextras:server:updateVehClass', class)
            end
        end
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function(PlayerData)
    syncBlip(PlayerData)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    local ID = ServerId()
    if DoesBlipExist(officerBlips[ID]) then
        RemoveBlip(ID)
    end
end)

AddEventHandler('onResourceStart', function(resource) -- Send info to server on resources restart
    if resource ~= GetCurrentResourceName() then return end
    local Player = QBCore.Functions.GetPlayerData()
    if not Player then return end
    syncBlip(Player)
end)

AddEventHandler('onResourceStop', function(resource) -- Remove Blips
    if resource ~= GetCurrentResourceName() then return end
    for x = 0, #officerBlips do
        if DoesBlipExist(officerBlips[x]) then
            RemoveBlip(x)
        end
    end
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty) -- Send info to server based on duty status
    local Player = QBCore.Functions.GetPlayerData()
    if not Player then return end
    syncBlip(Player)
end)

RegisterNetEvent('QRCore:Client:OnJobUpdate', function(job)
    syncBlip(nil, job)
end)
