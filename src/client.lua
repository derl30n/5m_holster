local function setPedEquipment(ped, component, equipment, texture)
    SetPedComponentVariation(ped, component, equipment, texture, 0)
end

Citizen.CreateThread(function()
    local ped_data = {
        ["weapon"] = nil,
        ["component"] = nil,
        ["equipment"] = nil
    }

    while true do
        local ped = GetPlayerPed(-1)
        local new_weapon = GetSelectedPedWeapon(ped)
        local ped_supported_equipment

        if new_weapon == ped_data.weapon then
            goto continue
        end

        ped_data["weapon"] = new_weapon

        if ped_data.component ~= nil then
            setPedEquipment(ped, ped_data.component, ped_data.equipment.id_holstered, ped_data.equipment.texture)
            ped_data["component"] = nil -- TODO: do i need to set component to nil?
        end

        if supported_weapons_hash[new_weapon] == nil then
            goto continue
        end

        ped_supported_equipment = supported_equipment[GetEntityModel(ped)]

        if ped_supported_equipment == nil then
            goto continue
        end

        for component, weapons in pairs(ped_supported_equipment) do
            local weapon = weapons[new_weapon]
            if weapon ~= nil then
                local ped_equipment_id = GetPedDrawableVariation(ped, component)

                for _, equipment in ipairs(weapons[new_weapon]) do
                    if equipment.id_holstered ~= ped_equipment_id and equipment.id_drawn ~= ped_equipment_id then
                        goto skipp
                    end

                    setPedEquipment(ped, component, equipment.id_drawn, equipment.texture_drawn)

                    ped_data["component"] = component
                    ped_data["equipment"] = equipment

                    goto continue
                    ::skipp::
                end
            end
        end

        ::continue::
        Citizen.Wait(200)
    end
end)