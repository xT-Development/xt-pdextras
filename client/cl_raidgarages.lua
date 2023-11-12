local function getVehIcon(name)
    local class = GetVehicleClassFromName(name)
    local callback = 'fas fa-car'

    local classes = {
        [8] = 'fas fa-motorcycle',
        [9] = 'fas fa-truck-monster',
        [10] = 'fas fa-truck-moving',
        [11] = 'fas fa-truck',
        [12] = 'fas fa-van-shuttle',
        [13] = 'fas fa-bicycle',
        [14] = 'fas fa-ship',
        [15] = 'fas fa-helicopter',
        [16] = 'fas fa-plane',
        [17] = 'fas fa-truck',
        [18] = 'fas fa-taxi',
        [19] = 'fas fa-truck-moving',
        [20] = 'fas fa-truck-moving',
    }

    if classes[class] then callback = classes[class] end
    return callback
end

AddEventHandler('xt-pdextras:client:raidGarage', function(data)
    local garageType = data.type
    local garageId = data.garageId
    local garage = data.garage
    local categories = data.categories and data.categories or {'car'}
    local header = data.header
    local superCategory = data.superCategory

    local input = lib.inputDialog('Raid Citizen\'s Garage', { { type = 'input', label = 'Citizen\'s State ID', required = true } })
    if not input then return end

    local pData = { string.upper(input[1]), garageId }
    local playerVehicles = lib.callback.await('xt-pdextras:server:getPlayerVehiclesAtGarage', 1000, pData)
    if not playerVehicles then return QBCore.Functions.Notify('No vehicles found!', 'error', 3000) end

    local menu = {}
    for x = 1, #playerVehicles do
        local vehInfo = playerVehicles[x]
        local vehIcon = getVehIcon(vehInfo.vehicle)
        local vehTitle = sharedVehicles[vehInfo.vehicle].name
        local vehDescription =
        ('Fuel: %s%s'):format(vehInfo.fuel, '%')..'  \n'..
        ('Body: %s%s'):format(math.ceil(vehInfo.body/100), '%')..'  \n'..
        ('Engine: %s%s'):format(math.ceil(vehInfo.engine/100), '%')

        local isDisabled = false
        if vehInfo.state == 0 then
            vehTitle = vehTitle..' ( OUT / DEPOT )'
            isDisabled = true
        elseif vehInfo.state == 2 then
            vehTitle = vehTitle..' ( POLICE IMPOUNDED )'
            isDisabled = true
        end

        menu[#menu+1] = {
          title = vehTitle,
          description = vehDescription,
          icon = vehIcon,
          disabled = isDisabled,
          event = 'qb-garages:client:TakeOutGarage',
          args = {
            vehicle = vehInfo,
            vehicleModel = vehInfo.vehicle,
            type = garageType,
            garage = garage,
            superCategory = superCategory,
          }
        }
    end

    lib.registerContext({
        id = 'raid_garage_menu',
        title = ('%s Vehicles'):format(input[1]),
        options = menu
    })
    lib.showContext('raid_garage_menu')
end)