local function setPedEquipment(ped, component, equipment, texture)
    SetPedComponentVariation(ped, component, equipment, texture, 0)
end

local function findEquipment(ped, weapon, component)
    if weapon == nil then
        return
    end

    local ped_equipment_id = GetPedDrawableVariation(ped, component)

    for _, equipment in ipairs(weapon) do
        if equipment.id_holstered == ped_equipment_id or equipment.id_drawn == ped_equipment_id then
            return equipment
        end
    end
end

local function updateEquipment(cache)
    local ped_weapon = GetSelectedPedWeapon(ped)

    if ped_weapon == cache.weapon then
        return
    end

    cache.weapon = ped_weapon

    if cache.component ~= nil then -- TODO: analyze gain of keeping this check and setting nil
        setPedEquipment(ped, cache.component, cache.equipment.id_holstered, cache.equipment.texture)
        cache.component = nil -- prevents unnecessary updates
    end

    if supported_weapons_hash[ped_weapon] == nil then
        return
    end

    local ped_supported_equipment = supported_equipment[GetEntityModel(ped)]

    if ped_supported_equipment == nil then
        return
    end

    for component, weapons in pairs(ped_supported_equipment) do
        local equipment = findEquipment(ped, weapons[ped_weapon], component)

        if equipment ~= nil then
            setPedEquipment(ped, component, equipment.id_drawn, equipment.texture_drawn)

            cache.component = component
            cache.equipment = equipment
        end
    end

    return
end

Citizen.CreateThread(function()
    local cached_ped_data = {
        ["weapon"] = nil,
        ["component"] = nil,
        ["equipment"] = nil
    }

    -- TODO: write equipment changes to cache, delete pre-defined textures from config

    while true do
        updateEquipment(cached_ped_data)

        Citizen.Wait(200)
    end
end)