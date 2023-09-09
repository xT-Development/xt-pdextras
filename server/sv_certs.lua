local Utils = require 'modules.shared'
local xTs = require 'modules.server'

-- Grant Certs --
RegisterNetEvent('xt-pdextras:server:GrantCert', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(data[1]))

    if not targetPlayer then
        QBCore.Functions.Notify(src, 'Invalid ID', 'error')
        return
    end

    local certs = targetPlayer.PlayerData.metadata["pdcerts"]
    local PlayerCoords = GetEntityCoords(GetPlayerPed(src))
    local TargetCoords = GetEntityCoords(GetPlayerPed(targetPlayer.PlayerData.source))
    local dist = #(PlayerCoords - vector3(TargetCoords.x, TargetCoords.y, TargetCoords.z))
    if dist >= 10 then return end

    if certs[data[2]] then QBCore.Functions.Notify(src, 'They are already certified!', 'error') return end
    certs[data[2]] = true
    targetPlayer.Functions.SetMetaData('pdcerts', certs)
    QBCore.Functions.Notify(src, 'Certification Granted', 'success')

    xTs.Log(Config.Webhooks.Certs.name, Config.Webhooks.Certs.color, 'PD Certification Granted',
    '**Officer:** '..Player.PlayerData.charinfo.firstname..' ' ..Player.PlayerData.charinfo.lastname ..'  \n'..
    '**Player:** '..targetPlayer.PlayerData.charinfo.firstname ..' ' ..targetPlayer.PlayerData.charinfo.lastname ..'  \n'..
    '**Certification:** '..Config.Certifications.certs[data[2]])
end)

-- Revoke Cert --
RegisterNetEvent('xt-pdextras:server:RevokeCert', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(data[1]))

    if not targetPlayer then
        QBCore.Functions.Notify(src, 'Invalid ID', 'error')
        return
    end

    local certs = targetPlayer.PlayerData.metadata["pdcerts"]
    local PlayerCoords = GetEntityCoords(GetPlayerPed(src))
    local TargetCoords = GetEntityCoords(GetPlayerPed(targetPlayer.PlayerData.source))
    local dist = #(PlayerCoords - vector3(TargetCoords.x, TargetCoords.y, TargetCoords.z))
    if dist >= 10 then return end

    if not certs[data[2]] then QBCore.Functions.Notify(src, 'They do not have this certification!', 'error') return end
    certs[data[2]] = false
    targetPlayer.Functions.SetMetaData('pdcerts', certs)
    QBCore.Functions.Notify(src, 'Certification Revoked', 'success')

    xTs.Log(Config.Webhooks.Certs.name, Config.Webhooks.Certs.color, 'PD Certification Revoked',
    '**Officer:** '..Player.PlayerData.charinfo.firstname..' ' ..Player.PlayerData.charinfo.lastname ..'  \n'..
    '**Player:** '..targetPlayer.PlayerData.charinfo.firstname ..' ' ..targetPlayer.PlayerData.charinfo.lastname ..'  \n'..
    '**Certification:** '..Config.Certifications.certs[data[2]])
end)


-- Grant / Revoke Certs --
lib.addCommand(Config.Certifications.command, {
    help = 'PD Certifications (Police Command Only)',
    params = {},
    restricted = false
}, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Utils.CheckJob(Config.PoliceJobs, src) then QBCore.Functions.Notify(src, 'You can not use this command!', 'error') return end
    if Player.PlayerData.job.grade.level <= Config.Certifications.reqRank then QBCore.Functions.Notify(src, 'You don\'t have the required rank to use this!', 'error') return end
    TriggerClientEvent('xt-pdextras:client:CertificationMenu', src)
end)

-- View Certs Command --
lib.addCommand(Config.Certifications.viewCommand, {
    help = 'View PD Certifications (Police Command Only)',
    params = {},
    restricted = false
}, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Utils.CheckJob(Config.PoliceJobs, src) then QBCore.Functions.Notify(src, 'You can not use this command!', 'error') return end

    local certs = Player.PlayerData.metadata["pdcerts"]
    TriggerClientEvent('xt-pdextras:client:ViewCerts', src, certs)
end)