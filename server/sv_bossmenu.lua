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

    if Config.RenewedPhone then exports['qb-phone']:fireUser(data.job, data.cid) end
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

    if Config.RenewedPhone then exports['qb-phone']:hireUser(job, TargetPlayer.PlayerData.citizenid, data[2]) end
    xTs.Log('pdbossmenu', 'blue', 'Officer Hired',
    '**Officer:** '..Player.PlayerData.charinfo.firstname..' ' ..Player.PlayerData.charinfo.lastname ..'  \n'..
    '**Hired:** '..TargetPlayer.PlayerData.charinfo.firstname ..' ' ..TargetPlayer.PlayerData.charinfo.lastname ..'  \n'..
    '**Rank:** '..QBCore.Shared.Jobs[job].grades[data[2]].name)
end)

-- Change Rank --
RegisterNetEvent('xt-pdextras:server:ChangeRank', function(data)
    exports['qb-phone']:JobsHandler(data.job, data.cid, tostring(data.grade))
end)

-- Returns Officers --
lib.callback.register('xt-pdextras:server:GetOfficers', function(source, menuID) return xTs.GetOfficers(source, menuID) end)

-- Returns Funds --
lib.callback.register('xt-pdextras:server:GetFunds', function(source, menuID) return xTs.GetFunds(source, menuID) end)