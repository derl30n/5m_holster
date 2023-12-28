local function setPedEquipment(ped, component, equipment, texture)
    SetPedComponentVariation(ped, component, equipment, texture, 0)
end

local function setEquipment(cache, ped, ped_weapon, component, weapons)
    local weapon = weapons[ped_weapon]
    if weapon == nil then
        return cache
    end

    local ped_equipment_id = GetPedDrawableVariation(ped, component)

    for _, equipment in ipairs(weapons[ped_weapon]) do
        if equipment.id_holstered == ped_equipment_id or equipment.id_drawn == ped_equipment_id then
            -- TODO: figure out how to refactor skipp/return to improve readability e.g. if not -> continue

            setPedEquipment(ped, component, equipment.id_drawn, equipment.texture_drawn)

            cache.component = component
            cache.equipment = equipment

            return cache
        end
    end
end

local function updateEquipment(cache)
    local ped = GetPlayerPed(-1)
    local ped_weapon = GetSelectedPedWeapon(ped)

    if ped_weapon == cache.weapon then
        return cache
    end

    cache.weapon = ped_weapon

    if cache.component ~= nil then
        setPedEquipment(ped, cache.component, cache.equipment.id_holstered, cache.equipment.texture)
        cache.component = nil -- TODO: do i need to set component to nil?
    end

    if supported_weapons_hash[ped_weapon] == nil then
        return cache
    end

    local ped_supported_equipment = supported_equipment[GetEntityModel(ped)]

    if ped_supported_equipment == nil then
        return cache
    end

    for component, weapons in pairs(ped_supported_equipment) do
        cache = setEquipment(cache, ped, ped_weapon, component, weapons)
    end

    return cache
end

Citizen.CreateThread(function()
    local cached_ped_data = {
        ["weapon"] = nil,
        ["component"] = nil,
        ["equipment"] = nil
    }

    -- TODO: write equipment changes to cache, delete pre-defined textures from config

    while true do
        cached_ped_data = updateEquipment(cached_ped_data)

        Citizen.Wait(200)
    end
end)