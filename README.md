<div align="center">
  <h1>xt-pdextras</h1>
  <a href="https://dsc.gg/xtdev"> <img align="center" src="https://user-images.githubusercontent.com/101474430/233859688-2b3b9ecc-41c8-41a6-b2e3-a9f1aad473ee.gif"/></a><br>
  <a href="https://dsc.gg/xtdev"> xT Development Discord</a><br>
</div>

## Features:
<details>
    <summary>Police Tools</summary>
    <ul>
        <li>Night vision goggles w/ thermal vision toggle</li>
        <li>Slimjims - Easier "lockpick" for Police to open vehicles</li>
    </ul>
</details>

<details>
    <summary>Police Certifications</summary>
    <ul>
        <li>Granted / Revoked by Officers w/ access to the bossmenus</li>
        <li>View your own certs w/ a command</li>
    </ul>
</details>

<details>
    <summary>Boss Menus</summary>
    <ul>
        <li>View officers info (rank, certifications)</li>
        <li>Change officers ranks</li>
        <li>Grant Revoke certifications</li>
        <li>View officers by specific rank</li>
    </ul>
</details>

<details>
    <summary>Evidence Lockers</summary>
    <ul>
        <li>Create / Open evidence lockers at specific locations, or use a command nearby to open evidence lockers</li>
        <li>PD "trash can" that will regularly wipe (set in config)</li>
    </ul>
</details>

<details>
    <summary>Armory</summary>
    <ul>
        <li>Restock option. Set certain items and max amounts for a "quick refill"</li>
        <li>Rank / Cert checks for each item</li>
        <li>Categorized items. Weapons, ammo, medical items, & tools</li>
    </ul>
</details>

<details>
    <summary>Police Garages</summary>
    <ul>
        <li>Rank & Cert checks for each vehicle</li>
    </ul>
</details>

<details>
    <summary>Police Garages / Boats / Helis</summary>
    <ul>
        <li>Rank & Cert checks for each vehicle</li>
    </ul>
</details>

<details>
    <summary>Commands</summary>
    <ul>
        <li>View your own certs</li>
        <li>Send players a fine</li>
    </ul>
</details>

<details>
    <summary>Duty Blips</summary>
    <ul>
         <li>Blip sprite changes based on vehicle</li>
          <li>Different blip colors for each LEO job</li>
    </ul>
</details>

## Dependencies:
- ox_inventory
- ox_target
- ox_lib
- oxmysql

## Setup:
- PD Certifications Usage: Add the following to `qb-core > server > player.lua` inside your existing playerdata
```lua
    PlayerData.metadata['pdcerts'] = PlayerData.metadata['pdcerts'] or {
        ['airone'] = false,             -- Air-1
        ['mbu'] = false,                -- Motorbike Unit
        ['fto'] = false,                -- Field Training Officer
        ['hsu'] = false,                -- High Speed Unit
        ['classthree'] = false,         -- Class 3
        ['classtwo'] = false,           -- Class 2
        ['alr'] = false,                -- Armalite Rifle
        ['canine'] = false,             -- Canine
        ['swat'] = false                -- SWAT
    }
```
- Boss Menu Usage: Add the following function to `qb-phone > server > employment.lua`
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

- Raid Garages Usage: Find the `PublicGarage` function in qb-garages and replace it with the following:
```lua
local function PublicGarage(garageName, type)
    local garage = Config.Garages[garageName]
    local categories = garage.vehicleCategories
    local superCategory = GetSuperCategoryFromCategories(categories)
    local isHidden = true
    if PlayerJob.name == 'police' and type ~= 'depot' then isHidden = false end

    exports['qb-menu']:openMenu({
        {
            header = garage.label,
            isMenuHeader = true,
        },
        {
            header = 'Raid Garage',
            txt = 'Search for a citizen\'s vehicles',
            icon = 'fas fa-magnifying-glass',
            hidden = isHidden,
            params = {
                event = 'xt-pdextras:client:raidGarage',
                args = {
                    garage = garage,
                    garageId = garageName,
                    categories = categories,
                    superCategory = superCategory,
                    type = type,
                }
            }
        },
        {
            header = Lang:t("menu.text.vehicles"),
            txt = Lang:t("menu.text.vehicles"),
            params = {
                event = "qb-garages:client:GarageMenu",
                args = {
                    garageId = garageName,
                    garage = garage,
                    categories = categories,
                    header =  Lang:t("menu.header."..garage.type.."_"..superCategory, {value = garage.label}),
                    superCategory = superCategory,
                    type = type
                }
            }
        },
        {
            header = Lang:t("menu.leave.car"),
            txt = "",
            params = {
                event = 'qb-menu:closeMenu'
            }
        },
    })
end
```

