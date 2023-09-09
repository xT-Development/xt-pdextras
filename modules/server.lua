local xTs = {}

-- Return Player Certs and Rank --
function xTs.CertsAndRank(source, target)
    local PlayerMetadata
    local PlayerJob
    if not target then
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        PlayerMetadata = Player.PlayerData.metadata
        PlayerJob = Player.PlayerData.job
    else
        local findPlayer = MySQL.query.await("SELECT * FROM `players` WHERE citizenid = ?", { target })
        if findPlayer[1] then
            PlayerMetadata = json.decode(findPlayer[1].metadata)
            PlayerJob = json.decode(findPlayer[1].job)
        end
    end

    if not Player then return end
    local certs = PlayerMetadata["pdcerts"]
    local rank = PlayerJob.grade.level

    return certs, rank
end

-- Get All Officers --
function xTs.GetOfficers(source, menuID)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local Employees = {}

    local jobs = MySQL.query.await("SELECT * FROM `player_jobs` WHERE jobname = ?", { Config.BossMenus[menuID].job })
    if jobs[1] then Employees = json.decode(jobs[1].employees) end
    return Employees
end

-- Get Job Funds --
function xTs.GetFunds(source, menuID)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local callback = nil
    if not Player then return end

    local account = MySQL.query.await("SELECT * FROM `bank_accounts_new` WHERE id = ?", { Config.BossMenus[menuID].job })
    if account[1] then callback = account[1].amount end
    return callback
end

-- Server Log --
function xTs.Log(logName, color, title, text)
    TriggerEvent("qb-log:server:CreateLog", logName, title, color, text, false, 'xt-pdextras')
end

function xTs.ClosestEvidenceLocker(source, distance)
    local pCoords = GetEntityCoords(GetPlayerPed(source))
    local callback = nil
    for x = 1, #Config.EvidenceRooms do
        local evidenceCoords = vec3(Config.EvidenceRooms[x].coords.x, Config.EvidenceRooms[x].coords.y, Config.EvidenceRooms[x].coords.z)
        local dist = #(evidenceCoords - pCoords)
        if dist <= distance then
            callback = x
            break
        end
    end
    return callback
end

return xTs