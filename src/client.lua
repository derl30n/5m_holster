---
--- Substitute values for keys in a string.
--- @param s string String containing keys like "${name}".
--- @param tab table Table containing values for the keys.
--- @return string String with values substituted for keys.
---
local function interp(s, tab)
    return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end


getmetatable("").__mod = interp


---
--- Create and return a data package for a pedestrian with specified component, equipment, and texture details.
--- @param ped number Pedestrian ID.
--- @param component number Pedestrian component ID.
--- @param equipment number Pedestrian equipment ID.
--- @param texture number Pedestrian texture ID.
--- @return table Data package containing ped, component, equipment, texture, and an issue message.
---
local function createPedDataPackage(ped, component, equipment, texture)
    local ped_data_package = {
        ["ped"] = ped,
        ["component"] = component,
        ["equipment"] = equipment,
        ["texture"] = texture,
        ["issue_message"] = ""
    }


    ---
    --- Add a message to the issue message of a pedestrian data package.
    --- @param message string Message to be added.
    ---
    function ped_data_package:addMessage(message)
        self.issue_message = self.issue_message .. message
    end


    return ped_data_package
end


---
--- Advise on an out-of-range value in the data package and update the package accordingly.
--- @param name string Name of the value to check.
--- @param max_value number Maximum allowed value.
--- @param data_package table Data package to check and update.
---
local function adviseOnOutOfRangeValue(name, max_value, data_package)
    local value = data_package[name]

    if value <= max_value then
        return
    end

    data_package[name] = "!" .. value .. "!"
    data_package:addMessage(" | INVALID ${name} ID  ${value}, highest available ID: ${max_value}" % { name = string.upper(name), value = value, max_value = max_value })
end


---
--- Generate an error message for an invalid pedestrian component variation.
--- Advise on out-of-range values for equipment and texture.
--- @param data_package table Data package containing ped, component, equipment, texture, and issue messages.
--- @return string Error message for the invalid ped component variation.
---
local function getErrorMessageForInvalidVariation(data_package)
    local num_avail_equip = GetNumberOfPedDrawableVariations(data_package.ped, data_package.component) - 1
    local num_avail_textures = GetNumberOfPedTextureVariations(data_package.ped, data_package.component, data_package.equipment) - 1

    adviseOnOutOfRangeValue("equipment", num_avail_equip, data_package)
    adviseOnOutOfRangeValue("texture", num_avail_textures, data_package)

    return "Invalid ped component variation: ${ped} ${component} ${equipment} ${texture} ${issue_message}" % data_package
end


---
--- Set pedestrian component variation based on weapon change, validating and handling errors.
--- @param ped number Pedestrian ID.
--- @param component number Pedestrian component ID.
--- @param equipment number Pedestrian equipment ID.
--- @param texture number Pedestrian texture ID.
---
local function setPedComponentVariationBasedOnWeaponChange(ped, component, equipment, texture)
    if not IsPedComponentVariationValid(ped, component, equipment, texture) then
        local error_message = getErrorMessageForInvalidVariation(createPedDataPackage(ped, component, equipment, texture))

        error(error_message)
    end

    SetPedComponentVariation(ped, component, equipment, texture, 0)
end


---
--- Retrieve matching equipment for a pedestrian and weapon, considering drawn and holstered states.
--- @param ped number Pedestrian ID.
--- @param ped_supported_components table Table of supported components for the given pedestrian and weapon.
--- @return number, table Pedestrian component ID and corresponding equipment table.
---
local function getMatchingEquipment(ped, ped_supported_components)
    for component_id, component_list in pairs(ped_supported_components) do
        local ped_equipment_id = GetPedDrawableVariation(ped, component_id)
        local equipment = component_list[ped_equipment_id]

        if equipment and (equipment.id_holstered == ped_equipment_id or equipment.id_drawn == ped_equipment_id) then
            return component_id, equipment
        end
    end
end


---
--- Updates equipment based on the selected weapon for the player's pedestrian.
--- @param cache table A table storing cached pedestrian data, including component and equipment information.
---
local function updateEquipment(cache)
    local ped = GetPlayerPed(-1)
    local ped_weapon = GetSelectedPedWeapon(ped)

    if ped == cache.ped and ped_weapon == cache.weapon then
        return
    end

    cache.ped = ped
    cache.weapon = ped_weapon

    -- prevent future updates ped when nothing has changed
    if cache.component then
        setPedComponentVariationBasedOnWeaponChange(ped, cache:unpackHolstered())
        cache.component = nil
    end

    if not SUPPORTED_EQUIPMENT:contains(GetEntityModel(ped), ped_weapon) then
        return
    end

    local component, equipment = getMatchingEquipment(ped, SUPPORTED_EQUIPMENT:retrieve())

    if not equipment then
        return
    end

    cache.component = component
    cache.equipment = equipment

    setPedComponentVariationBasedOnWeaponChange(ped, cache:unpackDrawn())
end


---
--- A thread that continuously updates the equipment based on the player's selected weapon.
--- Caches component and equipment information to avoid redundant updates.
---
Citizen.CreateThread(function()
    local cached_ped_data = {}


    ---
    --- Unpacks holstered equipment information from cached pedestrian data.
    --- @return number, number, number Pedestrian component, holstered equipment ID, and holstered texture ID.
    ---
    function cached_ped_data:unpackHolstered()
        return self.component, self.equipment.id_holstered, self.equipment.texture_holstered
    end


    ---
    --- Unpacks drawn equipment information from cached pedestrian data.
    --- @return number, number, number Pedestrian component, drawn equipment ID, and drawn texture ID.
    ---
    function cached_ped_data:unpackDrawn()
        return self.component, self.equipment.id_drawn, self.equipment.texture_drawn
    end


    while true do
        updateEquipment(cached_ped_data)

        Citizen.Wait(PAUSE_DURATION_BETWEEN_UPDATES_IN_MS)
    end
end)
