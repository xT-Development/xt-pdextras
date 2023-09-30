-- Main Menu --
AddEventHandler('xt-pdextras:client:BossMenu', function(menuID)
    local account = lib.callback.await('xt-pdextras:server:GetFunds', false, menuID)
    local BossMenu = {
        {
            title = 'Society Funds: $'..account,
            args = menuID,
            icon = 'fas fa-dollar-sign'
        },
        {
            title = 'View Officers',
            description = 'View all officers in the department',
            event = 'xt-pdextras:client:ViewOfficersMenu',
            args = menuID,
            icon = 'fas fa-people-group'
        },
        {
            title = 'View Officers by Rank',
            description = 'View department ranks and officers with each rank',
            event = 'xt-pdextras:client:RankMenu',
            args = menuID,
            icon = 'fas fa-people-group'
        },
        {
            title = 'Hire Officer',
            description = 'Hire a new officer',
            event = 'xt-pdextras:client:HireOfficer',
            args = Config.BossMenus[menuID].job,
            icon = 'fas fa-user-plus'
        },
        {
            title = 'Grant / Revoke Certification',
            description = 'Grant or revoke a PD certification',
            event = 'xt-pdextras:client:CertificationMenu',
            icon = 'fas fa-certificate'
        }
    }

    lib.registerContext({
        id = 'pd_boss_menu',
        title = 'PD Boss Menu',
        options = BossMenu
    })
    lib.showContext('pd_boss_menu')
end)

-- Hire an Officer --
AddEventHandler('xt-pdextras:client:HireOfficer', function(job)
    local options = {}
    local ranks = {}
    local rank = -1

    for x, t in ipairs(QBCore.Shared.Jobs[job].grades) do
        table.insert(ranks, tonumber(x))
    end

    for x = 1, #ranks do
        local Grade = QBCore.Shared.Jobs[job].grades[tostring(ranks[x])]
        options[#options+1] = { value = tostring(ranks[x]), label = ranks[x]..' | '..Grade.name }
    end

    local input = lib.inputDialog('Hire Officer', {
        { type = 'number', label = 'Player ID', description = '', icon = 'hashtag' },
        { type = 'select', label = 'Rank', options = options },
    })

    if not input then return end
    local confirmation = lib.alertDialog({
        header = 'Confirm Hiring Citizen',
        size = 'xs',
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Hire Citizen',
            cancel = 'Cancel'
        }
    })
    if not confirmation then lib.showContext('pd_boss_menu') return end
    TriggerServerEvent('xt-pdextras:server:HireOfficer', input, job)
end)

-- View Officers --
AddEventHandler('xt-pdextras:client:ViewOfficersMenu', function(menuID)
    local Officers = lib.callback.await('xt-pdextras:server:GetOfficers', false, menuID)
    local job = Config.BossMenus[menuID].job
    local PlayerJob = QBCore.Functions.GetPlayerData().job
    local OfficersMenu = {}

    for x, t in pairs(Officers) do
        if t.grade <= tonumber(PlayerJob.grade.level) then
            OfficersMenu[#OfficersMenu+1] = {
                title = t.name,
                description = QBCore.Shared.Jobs[job].grades[tostring(t.grade)].name,
                event = 'xt-pdextras:client:OfficerInfoMenu',
                args = { officer = t, job = job },
                icon = 'fas fa-user'
            }
        end
    end

    lib.registerContext({
        id = 'pd_officers_menu',
        title = 'Officers',
        menu = 'pd_boss_menu',
        hasSearch = true,
        options = OfficersMenu
    })
    lib.showContext('pd_officers_menu')
end)

-- Select Rank to View Officers --
AddEventHandler('xt-pdextras:client:RankMenu', function(menuID)
    local job = Config.BossMenus[menuID].job
    local RanksMenu = {}
    local ranks = {}

    for x, t in pairs(QBCore.Shared.Jobs[job].grades) do
        table.insert(ranks, tonumber(x))
    end

    table.sort(ranks)
    for x = 1, #ranks do
        local Grade = QBCore.Shared.Jobs[job].grades[tostring(ranks[x])]
        RanksMenu[#RanksMenu+1] = {
            title = ranks[x]..' | '..Grade.name,
            event = 'xt-pdextras:client:ViewOfficersRankMenu',
            args = { rank = ranks[x], menu = menuID }
        }
    end

    lib.registerContext({
        id = 'ranks_menu',
        title = 'View Officers by Rank',
        menu = 'pd_boss_menu',
        options = RanksMenu
    })
    lib.showContext('ranks_menu')
end)

-- View Officers by Rank Menu --
AddEventHandler('xt-pdextras:client:ViewOfficersRankMenu', function(data)
    local Officers = lib.callback.await('xt-pdextras:server:GetOfficers', false, data.menu)
    local job = Config.BossMenus[data.menu].job
    local OfficersByRankMenu = {}

    for x, t in pairs(Officers) do
        if t.grade == data.rank then
            OfficersByRankMenu[#OfficersByRankMenu+1] = {
                title = t.name,
                description = QBCore.Shared.Jobs[job].grades[tostring(t.grade)].name,
                event = 'xt-pdextras:client:OfficerInfoMenu',
                args = { officer = t, job = job },
                icon = 'fas fa-user'
            }
        end
    end

    lib.registerContext({
        id = 'pd_officers_menu',
        title = QBCore.Shared.Jobs[job].grades[tostring(data.rank)].name..' Officers',
        menu = 'ranks_menu',
        hasSearch = true,
        options = OfficersByRankMenu
    })
    lib.showContext('pd_officers_menu')
end)

-- View Individual Officer --
AddEventHandler('xt-pdextras:client:OfficerInfoMenu', function(data)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local OfficerInfoMenu = {
        {
            title = 'Change Rank',
            event = 'xt-pdextras:client:ChangeRank',
            args = { job = data.job, officer = data.officer },
            icon = 'fas fa-ranking-star'
        },
        {
            title = 'View Officer Certifications',
            event = 'xt-pdextras:client:GetPlayerCertMenu',
            args = { officer = data.officer },
            icon = 'fas fa-certificate'
        },
    }

    if data.officer.cid ~= PlayerData.citizenid then
        OfficerInfoMenu[#OfficerInfoMenu+1] = {
            title = 'Fire Officer',
            event = 'xt-pdextras:client:FireOfficerConfirmation',
            args = { job = data.job, cid = data.officer.cid, name = data.officer.name },
            icon = 'fas fa-user-slash'
        }
    end

    lib.registerContext({
        id = 'officers_info_menu',
        title = data.officer.name,
        menu = 'pd_officers_menu',
        options = OfficerInfoMenu
    })
    lib.showContext('officers_info_menu')
end)

-- View Officers Certifications --
AddEventHandler('xt-pdextras:client:GetPlayerCertMenu', function(data)
    local playerCerts, playerRank = lib.callback.await('xt-pdextras:server:CertsAndRank', false, data.officer.cid)
    local OfficerCertsMenu = {}
    local hasCert = ''

    if playerCerts then
        for x, t in pairs(playerCerts) do
            if t then hasCert = '✅' else hasCert = '❌' end
            OfficerCertsMenu[#OfficerCertsMenu+1] = {
                title = hasCert..' | '..Config.Certifications.certs[x],
            }
        end
    else
        OfficerCertsMenu[#OfficerCertsMenu+1] = {
            title = '❌ | NONE FOUND',
        }
    end

    lib.registerContext({
        id = 'officer_certs_menu',
        title =  data.officer.name..' Certifications',
        menu = 'officers_info_menu',
        options = OfficerCertsMenu
    })
    lib.showContext('officer_certs_menu')
end)

-- Change Officer Rank Menu --
AddEventHandler('xt-pdextras:client:ChangeRank', function(data)
    local OfficerRanksMenu = {}
    local ranks = {}

    for x, t in pairs(QBCore.Shared.Jobs[data.job].grades) do
        table.insert(ranks, tonumber(x))
    end

    table.sort(ranks)
    for x = 1, #ranks do
        local Grade = QBCore.Shared.Jobs[data.job].grades[tostring(ranks[x])]
        OfficerRanksMenu[#OfficerRanksMenu+1] = {
            title = ranks[x]..' | '..Grade.name,
            event = 'xt-pdextras:client:ChangeRankConfirmation',
            args = { job = data.job, cid = data.officer.cid, grade = ranks[x], name = data.officer.name }
        }
    end

    lib.registerContext({
        id = 'officer_rank_menu',
        title = data.officer.name..' | '..QBCore.Shared.Jobs[data.job].grades[tostring(data.officer.grade)].name,
        menu = 'officers_info_menu',
        options = OfficerRanksMenu
    })
    lib.showContext('officer_rank_menu')
end)

-- Grant / Revoke Certs --
RegisterNetEvent('xt-pdextras:client:CertificationMenu', function()
    lib.registerContext({
        id = 'cert_menu',
        title =  'PD Certifications Menu',
        menu = 'pd_boss_menu',
        options = {
            {
                title = 'Grant a Certification',
                event = 'xt-pdextras:client:GrantCert',
                icon = 'fas fa-check'
            },
            {
                title = 'Revoke a Certification',
                event = 'xt-pdextras:client:RevokeCert',
                icon = 'fas fa-xmark'
            },
        }
    })
    lib.showContext('cert_menu')
end)

-- View Personal Certs --
RegisterNetEvent('xt-pdextras:client:ViewCerts', function(certs)
    local CertsMenu = {}
    local hasCert = ''

    for x, t in pairs(certs) do
        if t then hasCert = '✅' else hasCert = '❌' end
        CertsMenu[#CertsMenu+1] = {
            title = hasCert..' | '..Config.Certifications.certs[x]
        }
    end
    lib.registerContext({
        id = 'certs_menu',
        title =  'My PD Certifications',
        options = CertsMenu
    })
    lib.showContext('certs_menu')
end)

-- Grant Certs --
AddEventHandler('xt-pdextras:client:GrantCert', function()
    local info = {}
    for x, t in pairs(Config.Certifications.certs) do info[#info+1] = { value = x, label = t } end
    local input = lib.inputDialog('Grant Certification', {
        { type = 'number', label = 'Player ID', description = '', icon = 'hashtag' },
        { type = 'select', label = 'Certification', options = info },
    })

    if not input then return end
    TriggerServerEvent('xt-pdextras:server:GrantCert', input)
end)

-- Revoke Certs --
AddEventHandler('xt-pdextras:client:RevokeCert', function()
    local info = {}
    for x, t in pairs(Config.Certifications.certs) do info[#info+1] = { value = x, label = t } end
    local input = lib.inputDialog('Revoke Certification', {
        { type = 'number', label = 'Player ID', description = '', icon = 'hashtag' },
        { type = 'select', label = 'Certification', options = info },
    })
    if not input then return end
    TriggerServerEvent('xt-pdextras:server:RevokeCert', input)
end)

-- Confirm Firing --
AddEventHandler('xt-pdextras:client:FireOfficerConfirmation', function(data)
    local alert = lib.alertDialog({
        header = 'Firing Officer',
        content = ('Are you sure you want to fire %s?'):format(data.name),
        size = 'xs',
        centered = true,
        cancel = true,
    })
    if not alert then lib.showContext('officers_info_menu') return end
    TriggerServerEvent('xt-pdextras:server:FireOfficer', data)
end)

-- Confirm Rank Change --
AddEventHandler('xt-pdextras:client:ChangeRankConfirmation', function(data)
    local confirmation = lib.alertDialog({
        header = 'Confirm Rank Change',
        content = ('Are you sure you want to change %s\'s rank to %s?'):format(data.name, QBCore.Shared.Jobs[data.job].grades[tostring(data.grade)].name),
        size = 'xs',
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Confirm Change',
            cancel = 'Cancel'
        }
    })
    if not confirmation then lib.showContext('pd_boss_menu') return end
    TriggerServerEvent('xt-pdextras:server:ChangeRank', data)
end)