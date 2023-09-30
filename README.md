# xt-pdextras
Extra PD QoL Features for QBCore

## Features:
- Police Tools
    - Night vision goggles w/ thermal vision toggle
    - Slimjims - Easier "lockpick" for Police to open vehicles
- Police Certifications
    - Granted / Revoked by Officers w/ access to the bossmenus
    - View your own certs w/ a command
- Boss Menus
    - View officers info (rank, certifications)
    - Change officers ranks
    - Grant Revoke certifications
    - View officers by specific rank
- Evidence Lockers
    - Create / Open evidence lockers at specific locations, or use a command nearby to open evidence lockers
    - PD "trash can" that will regularly wipe (set in config)
- Armory
    - Restock option. Set certain items and max amounts for a "quick refill"
    - Rank / Cert checks for each item
    - Categorized items. Weapons, ammo, medical items, & tools
- Police Garages
    - Rank & Cert checks for each vehicle
- Police Boat & Helis
    - Rank & Cert checks for each vehicle
- Commands
    - View your own certs
    - Send players a fine

## Dependencies:
- ox_inventory
- ox_target
- ox_lib
- oxmysql

## Setup:
- Add the following function to qb-phone > server > employment.lua
```lua
local function JobsHandler(source, Job, CID, grade)
    local src = source
    local srcPlayer = QBCore.Functions.GetPlayer(src)

    if not srcPlayer then return print("no source") end

    local srcCID = srcPlayer.PlayerData.citizenid

    if not Job or not CID or not CachedJobs[Job] then return end
    local Player = QBCore.Functions.GetPlayerByCitizenId(CID)
    if not CachedJobs[Job].employees[CID] then return notifyPlayer(src, "Citizen is not employed at the job...") end
    if tonumber(grade) > tonumber(CachedJobs[Job].employees[srcCID].grade) then return notifyPlayer(src, "You cannot promote someone higher than you...") end

    CachedJobs[Job].employees[CID].grade = tonumber(grade)

    MySQL.update('UPDATE player_jobs SET employees = ? WHERE jobname = ?', { json.encode(CachedJobs[Job].employees), Job })

    TriggerClientEvent("qb-phone:client:JobsHandler", -1, Job, CachedJobs[Job].employees)

    if Player and CachedPlayers[CID] then
        CachedPlayers[CID][Job] = CachedJobs[Job].employees[CID]

        local newGrade = type(CachedJobs[Job].employees[CID].grade) ~= "number" and tonumber(CachedJobs[Job].employees[CID].grade) or CachedJobs[Job].employees[CID].grade
        Player.Functions.SetJob(Job, newGrade)

        TriggerClientEvent('qb-phone:client:MyJobsHandler', Player.PlayerData.source, Job, CachedPlayers[CID][Job], CachedJobs[Job].employees)
    end
end
exports('JobsHandler', JobsHandler)
```

