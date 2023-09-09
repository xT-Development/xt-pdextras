local Utils = require 'modules.shared'
local xTs = require 'modules.server'

-- Fire --
RegisterNetEvent('xt-pdextras:server:FireOfficer', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local TargetPlayer = QBCore.Functions.GetPlayerByCitizenId(data.cid)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(src))
    local TargetCoords = GetEntityCoords(GetPlayerPed(TargetPlayer.PlayerData.source))
    local dist = #(PlayerCoords - TargetCoords)
    if dist >= 10 then return end

    if Config.RenewedPhone then
        exports['qb-phone']:fireUser(data.job, data.cid)
    else
        TriggerEvent('qb-bossmenu:server:FireEmployee', data.cid)
    end

    QBCore.Functions.Notify(src, TargetPlayer.PlayerData.charinfo.firstname ..' ' ..TargetPlayer.PlayerData.charinfo.lastname..' was fired!', 'success')

    xTs.Log('pdbossmenu', 'blue', 'Officer Fired',
    '**Officer:** '..Player.PlayerData.charinfo.firstname..' ' ..Player.PlayerData.charinfo.lastname ..'  \n'..
    '**Fired:** '..TargetPlayer.PlayerData.charinfo.firstname ..' ' ..TargetPlayer.PlayerData.charinfo.lastname)
end)

-- Hire --
RegisterNetEvent('xt-pdextras:server:HireOfficer', function(data, job)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local TargetPlayer = QBCore.Functions.GetPlayer(tonumber(data[1]))
    local PlayerCoords = GetEntityCoords(GetPlayerPed(src))
    local TargetCoords = GetEntityCoords(GetPlayerPed(TargetPlayer.PlayerData.source))
    local dist = #(PlayerCoords - TargetCoords)
    if dist >= 10 then return end

    if Config.RenewedPhone then
        exports['qb-phone']:hireUser(job, TargetPlayer.PlayerData.citizenid, data[2])
    else
        TriggerEvent('qb-bossmenu:server:HireEmployee', tonumber(data[1]))
    end

    QBCore.Functions.Notify(src, TargetPlayer.PlayerData.charinfo.firstname ..' ' ..TargetPlayer.PlayerData.charinfo.lastname..' was hired!', 'success')
    QBCore.Functions.Notify(tonumber(data[1]), 'You were hired as a '..QBCore.Shared.Jobs[data.job].grades[tostring(data.grade)].name..'!', 'success')

    xTs.Log('pdbossmenu', 'blue', 'Officer Hired',
    '**Officer:** '..Player.PlayerData.charinfo.firstname..' ' ..Player.PlayerData.charinfo.lastname ..'  \n'..
    '**Hired:** '..TargetPlayer.PlayerData.charinfo.firstname ..' ' ..TargetPlayer.PlayerData.charinfo.lastname ..'  \n'..
    '**Rank:** '..QBCore.Shared.Jobs[job].grades[data[2]].name)
end)

-- Change Rank --
RegisterNetEvent('xt-pdextras:server:ChangeRank', function(data)
    local gradeName = QBCore.Shared.Jobs[data.job].grades[tostring(data.grade)].name

    if Config.RenewedPhone then
        exports['qb-phone']:JobsHandler(data.job, data.cid, tostring(data.grade))
    else
        local data = {
            cid = data.cid,
            grade = data.grade,
            gradename = gradeName
        }
        TriggerEvent('qb-bossmenu:server:GradeUpdate', data)
    end

    QBCore.Functions.Notify(source, data.name..' Updated: '..gradeName, 'success')
end)

-- Returns Officers --
lib.callback.register('xt-pdextras:server:GetOfficers', function(source, menuID) return xTs.GetOfficers(source, menuID) end)

-- Returns Funds --
lib.callback.register('xt-pdextras:server:GetFunds', function(source, menuID) return xTs.GetFunds(source, menuID) end)