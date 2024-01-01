local function setPedEquipment(ped, component, equipment, texture)
    SetPedComponentVariation(ped, component, equipment, texture, 0)
end

local function getMatchingEquipment(ped, ped_supported_equipment)
    for component_id, component_list in pairs(ped_supported_equipment) do
        local ped_equipment_id = GetPedDrawableVariation(ped, component_id)

        for _, equipment in ipairs(component_list) do
            if equipment.id_holstered == ped_equipment_id or equipment.id_drawn == ped_equipment_id then
                return component_id, equipment
            end
        end
    end
end

local function updateEquipment(cache)
    local ped = GetPlayerPed(-1)
    local ped_weapon = GetSelectedPedWeapon(ped)

    if ped_weapon == cache.weapon then
        return
    end

    cache.weapon = ped_weapon

    -- prevent updating ped when nothing has changed
    if cache.component then
        setPedEquipment(ped, cache.component, cache.equipment.id_holstered, cache.equipment.texture_holstered)
        cache.component = nil
    end

    if not supported_weapons_hash[ped_weapon] then
        return
    end

    local ped_supported_equipment = (supported_equipment[GetEntityModel(ped)] or {})[ped_weapon]

    if not ped_supported_equipment then
        return
    end

    local component, equipment = getMatchingEquipment(ped, ped_supported_equipment)

    if not equipment then
        return
    end

    setPedEquipment(ped, component, equipment.id_drawn, equipment.texture_drawn)

    cache.component = component
    cache.equipment = equipment
end

Citizen.CreateThread(function()
    local cached_ped_data = {}

    while true do
        updateEquipment(cached_ped_data)

        Citizen.Wait(200)
    end
end)