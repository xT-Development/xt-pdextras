-- Main Menu --
RegisterNetEvent('xt-pdextras:client:BossMenu', function(menuID)
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
RegisterNetEvent('xt-pdextras:client:HireOfficer', function(job)
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
    TriggerServerEvent('xt-pdextras:server:HireOfficer', input, job)
end)

-- View Officers --
RegisterNetEvent('xt-pdextras:client:ViewOfficersMenu', function(menuID)
    local Officers = lib.callback.await('xt-pdextras:server:GetOfficers', false, menuID)
    local job = Config.BossMenus[menuID].job
    local OfficersMenu = {}

    for x, t in pairs(Officers) do
        OfficersMenu[#OfficersMenu+1] = {
            title = t.name,
            description = QBCore.Shared.Jobs[job].grades[tostring(t.grade)].name,
            event = 'xt-pdextras:client:OfficerInfoMenu',
            args = { officer = t, job = job },
            icon = 'fas fa-user'
        }
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

-- View Officer Specifically --
RegisterNetEvent('xt-pdextras:client:OfficerInfoMenu', function(data)
    local OfficerInfoMenu = {
        {
            title = 'Fire Officer',
            serverEvent = 'xt-pdextras:server:FireOfficer',
            args = { job = data.job, cid = data.officer.cid },
            icon = 'fas fa-user-slash'
        },
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

    lib.registerContext({
        id = 'officers_info_menu',
        title = data.officer.name,
        menu = 'pd_officers_menu',
        options = OfficerInfoMenu
    })
    lib.showContext('officers_info_menu')
end)

-- View Officers Certifications --
RegisterNetEvent('xt-pdextras:client:GetPlayerCertMenu', function(data)
    local playerCerts, playerRank = lib.callback.await('xt-pdextras:server:CertsAndRank', false, data.officer.cid)
    local OfficerCertsMenu = {}
    local hasCert = ''

    for x, t in pairs(playerCerts) do
        if t then hasCert = '✅' else hasCert = '❌' end
        OfficerCertsMenu[#OfficerCertsMenu+1] = {
            title = hasCert..' | '..Config.Certifications.certs[x],
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
RegisterNetEvent('xt-pdextras:client:ChangeRank', function(data)
    local RankMenu = {}
    local ranks = {}

    for x, t in pairs(QBCore.Shared.Jobs[data.job].grades) do
        table.insert(ranks, tonumber(x))
    end

    table.sort(ranks)
    for x = 1, #ranks do
        local Grade = QBCore.Shared.Jobs[data.job].grades[tostring(ranks[x])]
        RankMenu[#RankMenu+1] = {
            title = ranks[x]..' | '..Grade.name,
            serverEvent = 'xt-pdextras:server:ChangeRank',
            args = { job = data.job, cid = data.officer.cid, grade = ranks[x] }
        }
    end

    lib.registerContext({
        id = 'rank_menu',
        title = data.officer.name..' | '..QBCore.Shared.Jobs[data.job].grades[tostring(data.officer.grade)].name,
        menu = 'officers_info_menu',
        options = RankMenu
    })
    lib.showContext('rank_menu')
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
RegisterNetEvent('xt-pdextras:client:GrantCert', function()
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
RegisterNetEvent('xt-pdextras:client:RevokeCert', function()
    local info = {}
    for x, t in pairs(Config.Certifications.certs) do info[#info+1] = { value = x, label = t } end
    local input = lib.inputDialog('Revoke Certification', {
        { type = 'number', label = 'Player ID', description = '', icon = 'hashtag' },
        { type = 'select', label = 'Certification', options = info },
    })
    if not input then return end
    TriggerServerEvent('xt-pdextras:server:RevokeCert', input)
end)