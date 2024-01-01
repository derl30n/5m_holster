local function setPedEquipment(ped, component, equipment, texture)
    SetPedComponentVariation(ped, component, equipment, texture, 0)
end

local function findEquipment(ped, weapon, component)
    if not weapon then
        return
    end

    local ped_equipment_id = GetPedDrawableVariation(ped, component)

    for _, equipment in ipairs(weapon) do
        if equipment.id_holstered == ped_equipment_id or equipment.id_drawn == ped_equipment_id then
            return equipment
        end
    end
end

local function getMatchingEquipment(ped, ped_weapon, ped_supported_equipment)
    for component, weapons in pairs(ped_supported_equipment) do
        local equipment = findEquipment(ped, weapons[ped_weapon], component)

        if equipment then
            return component, equipment
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

    if cache.component then -- prevent updating ped when nothing has changed
        setPedEquipment(ped, cache.component, cache.equipment.id_holstered, cache.equipment.texture_holstered)
        cache.component = nil
    end

    if not supported_weapons_hash[ped_weapon] then
        return
    end

    local ped_supported_equipment = supported_equipment[GetEntityModel(ped)]

    if not ped_supported_equipment then
        return
    end

    local component, equipment = getMatchingEquipment(ped, ped_weapon, ped_supported_equipment)

    if not equipment then
        return
    end

    setPedEquipment(ped, component, equipment.id_drawn, equipment.texture_drawn)

    cache.component = component
    cache.equipment = equipment
end

Citizen.CreateThread(function()
    -- TODO: Initialize tables with an empty table {} instead of nil to avoid potential issues with accessing keys that do not exist.
    local cached_ped_data = {
        ["weapon"] = nil,
        ["component"] = nil,
        ["equipment"] = nil
    }

    while true do
        updateEquipment(cached_ped_data)

        Citizen.Wait(200)
    end
end)