local function deleteVehicle(entity)
    CreateThread(function()
        while DoesEntityExist(entity) do
            DeleteEntity(entity)
            Wait(100)
        end
    end)
end

CreateThread(function()
    while true do
        local osTime = os.time()
        local allVeh = GetAllVehicles()
        for i = 1, #allVeh do
            local vehicle = allVeh[i]
            local entity = Entity(vehicle)
            local lastDrive = entity.state.lastDrive
            if not lastDrive or GetPedInVehicleSeat(vehicle, -1) ~= 0 then
                entity.state:set('lastDrive', osTime + config.second, false)
            elseif osTime > lastDrive then
                if GetEntityRoutingBucket(entity) == 0 then
                    entity.state:set('lastDrive', nil, false)
                    deleteVehicle(vehicle)
                else
                    entity.state:set('lastDrive', osTime + config.second, false)
                end
            end
        end
        Wait(10000)
    end
end)
