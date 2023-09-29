local xTc = require 'modules.client'
local Utils = require 'modules.shared'

local Player = QBCore.Functions.GetPlayerData()
local PlayerJob = QBCore.Functions.GetPlayerData().job
local onDuty = false
local CurrentCops = 0

ReturnPoints = {}
HeliAndBoatPeds = {}
PDBossMenus = {}
ArmoryZone = {}
EvidencePeds = {}
GaragePeds = {}

-- Fine Player Menu --
RegisterNetEvent('xt-pdextras:client:FinePlayerMenu', function()
    if not Utils.CheckJob(Config.PoliceJobs) then return end

    xTc.Emote('tablet2')
    local input = lib.inputDialog('Fine Player', {
        {type = 'number', label = 'Player ID', description = '', icon = 'hashtag'},
        {type = 'number', label = 'Fine Amount', description = '', icon = 'hashtag'},
        {type = 'input', label = 'Fine Reason', description = ''},
    })

    if not input then xTc.EndEmote() return end
    if not input[1] then RSClientNotify('Enter a player ID!', 'error') xTc.EndEmote() return end
    if input[2] <= 0 then RSClientNotify('You can\'t send a fine for zero or less!', 'error') xTc.EndEmote() return end
    TriggerServerEvent('xt-pdextras:server:FinePlayer', input)
    xTc.EndEmote()
end)

-- Player Shit --
local function playerLoaded()
    Player = QBCore.Functions.GetPlayerData()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    if Config.UseArmory then xTc.CreatePDArmory() end
    if Config.UseBossMenus then xTc.CreatePDBossMenus() end
    if Config.UseEvidence then xTc.EvidenceRoomPed() end
    if Config.UseGarages then xTc.GaragePeds() end
    if Config.UseBoatHeliLocations then
        xTc.HeliBoatPeds()
        xTc.ReturnVehiclePoints()
    end
end

-- Player Unload --
local function playerUnload()
    Player = {}
    PlayerJob = {}
    if Config.UseArmory then xTc.CleanupPDArmory() end
    if Config.UseBossMenus then xTc.CleanupPDBossMenus() end
    if Config.UseEvidence then xTc.RemoveEvidenceRoomPed() end
    if Config.UseGarages then xTc.RemoveGaragePeds() end
    if Config.UseBoatHeliLocations then
        xTc.RemoveVehicleReturnPoints()
        xTc.HeliBoatCleanup()
    end
end

AddEventHandler('onResourceStart', function(resource) if resource == GetCurrentResourceName() then playerLoaded() end end)
AddEventHandler('onResourceStop', function(resource) if resource == GetCurrentResourceName() then playerUnload() end end)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', playerLoaded)
RegisterNetEvent('QBCore:Client:OnPlayerUnload', playerUnload)
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job) PlayerJob = job end)
RegisterNetEvent('police:SetCopCount', function(amount) CurrentCops = amount end)
RegisterNetEvent('QBCore:Client:SetDuty', function(duty) onDuty = duty end)