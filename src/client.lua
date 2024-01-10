---
--- Receives a string with keys build into it like ${name} and a table which contains values for the given keys and
--- returns a new string with the values.
---@param s string
---@param tab table
---@return string
local function interp(s, tab)
    return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end


getmetatable("").__mod = interp


---
--- Creates and returns a data package for a pedestrian with specified component, equipment, and texture details.
--- @param ped number Pedestrian ID
--- @param component number Pedestrian component ID
--- @param equipment number Pedestrian equipment ID
--- @param texture number Pedestrian texture ID
--- @return table A data package containing ped, component, equipment, texture, and an issue message.
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
    --- Adds a message to the issue message of a pedestrian data package.
    --- @param message string The message to be added.
    ---
    function ped_data_package:addMessage(message)
        self.issue_message = self.issue_message .. message
    end


    return ped_data_package
end


---
--- Advises on an out-of-range value in the data package and updates the package accordingly.
--- @param name string The name of the value to check.
--- @param max_value number The maximum allowed value.
--- @param data_package table The data package to check and update.
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
--- Generates an error message for an invalid pedestrian component variation.
--- Advises on out-of-range values for equipment and texture.
--- @param data_package table The data package containing ped, component, equipment, texture, and issue messages.
--- @return string The error message for the invalid ped component variation.
---
local function getErrorMessageForInvalidVariation(data_package)
    local num_avail_equip = GetNumberOfPedDrawableVariations(data_package.ped, data_package.component) - 1
    local num_avail_textures = GetNumberOfPedTextureVariations(data_package.ped, data_package.component, data_package.equipment) - 1

    adviseOnOutOfRangeValue("equipment", num_avail_equip, data_package)
    adviseOnOutOfRangeValue("texture", num_avail_textures, data_package)

    return "Invalid ped component variation: ${ped} ${component} ${equipment} ${texture} ${issue_message}" % data_package
end


---
--- Sets pedestrian component variation based on weapon change, validating and handling errors.
--- @param ped number Pedestrian ID
--- @param component number Pedestrian component ID
--- @param equipment number Pedestrian equipment ID
--- @param texture number Pedestrian texture ID
---
local function setPedComponentVariationBasedOnWeaponChange(ped, component, equipment, texture)
    if not IsPedComponentVariationValid(ped, component, equipment, texture) then
        local error_message = getErrorMessageForInvalidVariation(createPedDataPackage(ped, component, equipment, texture))

        error(error_message)
    end

    SetPedComponentVariation(ped, component, equipment, texture, 0)
end


---
--- Retrieves a table of supported components for a pedestrian and weapon combination.
--- @param ped number Pedestrian ID
--- @param ped_weapon number Pedestrian weapon ID
--- @return table A table of supported components for the given pedestrian and weapon.
---
local function getPedSupportedComponents(ped, ped_weapon)
    return (SUPPORTED_EQUIPMENT[GetEntityModel(ped)] or {})[ped_weapon] or {}
end


---
--- Retrieves matching equipment for a pedestrian and weapon, considering drawn and holstered states.
--- @param ped number Pedestrian ID
--- @param ped_weapon number Pedestrian weapon ID
--- @return number, table Pedestrian component ID and corresponding equipment table.
---
local function getMatchingEquipment(ped, ped_weapon)
    local ped_supported_components = getPedSupportedComponents(ped, ped_weapon)

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

    if ped_weapon == cache.weapon then
        return
    end

    cache.weapon = ped_weapon

    -- prevent future updates ped when nothing has changed
    if cache.component then
        setPedComponentVariationBasedOnWeaponChange(ped, cache:unpackHolstered())
        cache.component = nil
    end

    if not SUPPORTED_WEAPONS_HASH[ped_weapon] then
        return
    end

    local component, equipment = getMatchingEquipment(ped, ped_weapon)

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
