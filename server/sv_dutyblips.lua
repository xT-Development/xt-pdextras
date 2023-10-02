-- Some code is reused from qb-policejob, but im not a braindead dummy and made it better

local GPSBlips = {}

-- Update Officer Blips --
local function UpdateBlips()
    local officerBlips = {}
    local foundSource = nil

    for x, t in pairs(GPSBlips) do
        local ply = x
        local pPed = GetPlayerPed(ply)
        local coords, heading = GetEntityCoords(pPed), GetEntityHeading(pPed)

        officerBlips[ply] = {
            source = ply,
            label = t.callsign,
            vehClass = t.vehClass,
            job = t.job,
            location = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
                w = heading
            }
        }
    end
    for x, t in pairs(GPSBlips) do
        if x == t.source then
            TriggerClientEvent("xt-pdextras:client:updateDutyBlips", t.source, officerBlips)
        end
    end
end

-- Get Veh Class from Cache --
RegisterNetEvent('xt-pdextras:server:updateVehClass',function(vehClass)
    local src = source
    if not GPSBlips[src] then GPSBlips[src] = {}  end
    GPSBlips[src].vehClass = vehClass
end)

-- Update Officer Blip Info --
RegisterNetEvent('xt-pdextras:server:updateBlipInfo',function(job, callsign)
    local src = source
    if not job and not callsign then
        if GPSBlips[src] then
            GPSBlips[src] = nil
            return
        end
    end

    if not GPSBlips[src] then GPSBlips[src] = {}  end
    GPSBlips[src].source = src
    GPSBlips[src].job = job
    GPSBlips[src].callsign = callsign
end)

-- Constant Blips Update --
SetInterval(function()
    UpdateBlips()
end, 1000)