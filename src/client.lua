local function setPedComponentVariationBasedOnWeaponChange(ped, component, equipment, texture)
    if not IsPedComponentVariationValid(ped, component, equipment, texture) then
        local _, msg = pcall(error,"Invalid ped component variation: ")
        print(msg, ped, component, equipment, texture)
        return
    end
    SetPedComponentVariation(ped, component, equipment, texture, 0)
end

local function getMatchingEquipment(ped, ped_supported_components)
    for component_id, component_list in pairs(ped_supported_components) do
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

    -- prevent future updates ped when nothing has changed
    if cache.component then
        setPedComponentVariationBasedOnWeaponChange(ped, cache.component, cache.equipment.id_holstered, cache.equipment.texture_holstered)
        cache.component = nil
    end

    if not supported_weapons_hash[ped_weapon] then
        return
    end

    local ped_supported_components = (supported_equipment[GetEntityModel(ped)] or {})[ped_weapon]

    if not ped_supported_components then
        return
    end

    local component, equipment = getMatchingEquipment(ped, ped_supported_components)

    if not equipment then
        return
    end

    setPedComponentVariationBasedOnWeaponChange(ped, component, equipment.id_drawn, equipment.texture_drawn)

    cache.component = component
    cache.equipment = equipment
end

Citizen.CreateThread(function()
    local cached_ped_data = {}

    while true do
        updateEquipment(cached_ped_data)

        Citizen.Wait(UPDATE_INTERVAL_IN_MS)
    end
end)