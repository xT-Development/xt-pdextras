local Utils = {}

-- Debug Print --
function Utils.Debug(type, debugTxt)
    if debugTxt == nil then debugTxt = '' end
    if Config.Debug then
        print("^2xT Debug ^7| "..type.." | ^2"..debugTxt)
    end
end

-- Check Job Client/Server --
function Utils.CheckJob(job, src)
    local checkType = IsDuplicityVersion() and 'server' or 'client'
    local callback = false
    if checkType == 'client' then -- Checks for client/server
        local Player = QBCore.Functions.GetPlayerData()
        if type(job) == 'string' then -- Checks for string or table of jobs
            if Player.job.name == job then
                callback = true
            end
        elseif type(job) == 'table' then
            for _,v in pairs(job) do
                if Player.job.name == v then
                    callback = true
                    break
                end
            end
        end
    else
        local Player
        if src then
            Player = QBCore.Functions.GetPlayer(src)
        else
            Player = QBCore.Functions.GetPlayer(source)
        end
        if type(job) == 'string' then
            if Player.PlayerData.job.name == job then
                callback = true
            end
        elseif type(job) == 'table' then
            for _,v in pairs(job) do
                if Player.PlayerData.job.name == v then
                    callback = true
                    break
                end
            end
        end
    end
    return callback
end

return Utils