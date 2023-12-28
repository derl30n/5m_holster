local function setPedEquipment(ped, component, equipment, texture)
    SetPedComponentVariation(ped, component, equipment, texture, 0)
end

local function updateEquipment(ped_data)
    local ped = GetPlayerPed(-1)
    local ped_weapon = GetSelectedPedWeapon(ped)

    if ped_weapon == ped_data.weapon then
        return ped_data
    end

    ped_data.weapon = ped_weapon

    if ped_data.component ~= nil then
        setPedEquipment(ped, ped_data.component, ped_data.equipment.id_holstered, ped_data.equipment.texture)
        ped_data.component = nil -- TODO: do i need to set component to nil?
    end

    if supported_weapons_hash[ped_weapon] == nil then
        return ped_data
    end

    local ped_supported_equipment = supported_equipment[GetEntityModel(ped)]

    if ped_supported_equipment == nil then
        return ped_data
    end

    for component, weapons in pairs(ped_supported_equipment) do
        local weapon = weapons[ped_weapon]
        if weapon ~= nil then
            local ped_equipment_id = GetPedDrawableVariation(ped, component)

            for _, equipment in ipairs(weapons[ped_weapon]) do
                if equipment.id_holstered == ped_equipment_id or equipment.id_drawn == ped_equipment_id then
                    -- TODO: figure out how to refactor skipp/return to improve readability e.g. if not -> continue

                    setPedEquipment(ped, component, equipment.id_drawn, equipment.texture_drawn)

                    ped_data.component = component
                    ped_data.equipment = equipment

                    return ped_data
                end
            end
        end
    end
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