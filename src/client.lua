local PED_COMPONENT_VARIATION_PALETTE_ID = 0


local PedDataCache = {}

---
--- Creates a new instance of PedDataCache.
--- @return table New PedDataCache instance.
---
function PedDataCache.new()
    local self = {
        component = nil,
        equipment = nil,
        ped = nil,
        weapon = nil
    }

    ---
    --- Unpacks holstered equipment information from cached pedestrian data.
    --- @return number, number, number Pedestrian component, holstered equipment ID, and holstered texture ID.
    ---
    function self:unpackHolstered()
        return self.ped, self.component, self.equipment.holstered:unpack()
    end

    ---
    --- Unpacks drawn equipment information from cached pedestrian data.
    --- @return number, number, number Pedestrian component, drawn equipment ID, and drawn texture ID.
    ---
    function self:unpackDrawn()
        return self.ped, self.component, self.equipment.drawn:unpack()
    end

    return self
end


local PedDataPackage = {}

---
--- Creates and returns a data package for a pedestrian with specified component, equipment, and texture details.
--- @param ped number Pedestrian ID.
--- @param component number Pedestrian component ID.
--- @param equipment number Pedestrian equipment ID.
--- @param texture number Pedestrian texture ID.
--- @return table Data package containing ped, component, equipment, texture, and an issue message.
---
function PedDataPackage.new(ped, component, equipment, texture)
    local self = {
        ped = ped,
        component = component,
        equipment = equipment,
        texture = texture,
        issueMessage = ""
    }

    ---
    --- Adds a message to the issue message of a pedestrian data package.
    --- @param message string Message to be added.
    ---
    function self:addMessage(message)
        self.issueMessage = self.issueMessage .. message
    end

    ---
    --- Converts the data package to a string representation.
    --- @return string String representation of the data package.
    ---
    function self:toFormattedString()
        return string.format("%d %d %s %s %s", self.ped, self.component, self.equipment, self.texture, self.issueMessage)
    end

    return self
end


---
--- Advises on an out-of-range value in the data package and updates the package accordingly.
--- @param name string Name of the value to check.
--- @param valueMax number Maximum allowed value.
--- @param pedDataPackage table Data package to check and update.
---
local function adviseOnOutOfRangeValue(name, valueMax, pedDataPackage)
    local value = pedDataPackage[name]

    if value <= valueMax then
        return
    end

    pedDataPackage[name] = "!" .. value .. "!"
    pedDataPackage:addMessage(string.format(" | INVALID %s ID  %x, highest available ID: %x", string.upper(name), value, valueMax ))
end


---
--- Generates an error message for an invalid pedestrian component variation.
--- Advises on out-of-range values for equipment and texture.
--- @param pedDataPackage table Data package containing ped, component, equipment, texture, and issue messages.
--- @return string Error message for the invalid ped component variation.
---
local function getErrorMessageForInvalidVariation(pedDataPackage)
    local noAvailDrawable = GetNumberOfPedDrawableVariations(pedDataPackage.ped, pedDataPackage.component) - 1
    local numAvailTextures = GetNumberOfPedTextureVariations(pedDataPackage.ped, pedDataPackage.component, pedDataPackage.equipment) - 1

    adviseOnOutOfRangeValue("equipment", noAvailDrawable, pedDataPackage)
    adviseOnOutOfRangeValue("texture", numAvailTextures, pedDataPackage)

    return "Invalid ped component variation: " .. pedDataPackage:toFormattedString()
end


---
--- Sets pedestrian component variation based on weapon change, validating and handling errors.
--- @param ped number Pedestrian ID.
--- @param componentId number Pedestrian component ID.
--- @param drawableId number Pedestrian equipment ID.
--- @param textureId number Pedestrian texture ID.
---
local function setPedComponentVariationBasedOnWeaponChange(ped, componentId, drawableId, textureId)
    if not IsPedComponentVariationValid(ped, componentId, drawableId, textureId) then
        local error_message = getErrorMessageForInvalidVariation(PedDataPackage.new(ped, componentId, drawableId, textureId))

        error(error_message)
    end

    SetPedComponentVariation(ped, componentId, drawableId, textureId, PED_COMPONENT_VARIATION_PALETTE_ID)
end


---
--- Retrieves matching equipment for a pedestrian and weapon, considering drawn and holstered states.
--- @param ped number Pedestrian ID.
--- @param supportedComponents table Table of supported components for the given pedestrian and weapon.
--- @return number, table Pedestrian component ID and corresponding equipment table.
---
local function getMatchingEquipment(ped, supportedComponents)
    for componentId, componentList in pairs(supportedComponents) do
        local drawableId = GetPedDrawableVariation(ped, componentId)
        local equipment = componentList[drawableId]

        if equipment and (equipment.holstered.drawableId == drawableId or equipment.drawn.drawableId == drawableId) then
            return componentId, equipment
        end
    end
end


---
--- Updates equipment based on the selected weapon for the player's pedestrian.
--- @param supportedEquipment table A table storing supported equipment data.
--- @param pedDataCache table A table storing cached pedestrian data, including component and equipment information.
---
local function updateEquipment(supportedEquipment, pedDataCache)
    local ped = GetPlayerPed(-1)
    local weapon = GetSelectedPedWeapon(ped)

    if ped == pedDataCache.ped and weapon == pedDataCache.weapon then
        return
    end

    pedDataCache.ped = ped
    pedDataCache.weapon = weapon

    --- prevent future updates ped when nothing has changed
    if pedDataCache.component then
        setPedComponentVariationBasedOnWeaponChange(pedDataCache:unpackHolstered())
        pedDataCache.component = nil
    end

    if not supportedEquipment:contains(GetEntityModel(ped), weapon) then
        return
    end

    local component, equipment = getMatchingEquipment(ped, supportedEquipment:retrieve())

    if not equipment then
        return
    end

    pedDataCache.component = component
    pedDataCache.equipment = equipment

    setPedComponentVariationBasedOnWeaponChange(pedDataCache:unpackDrawn())
end


---
--- Main entry point for the script. Initializes supported equipment and continuously updates equipment based on the player's selected weapon.
---
local function main()
    local supportedEquipment = loadSupportedEquipmentFromConfig()
    local pedDataCache = PedDataCache.new()

    while true do
        updateEquipment(supportedEquipment, pedDataCache)

        Citizen.Wait(PAUSE_DURATION_BETWEEN_UPDATES_IN_MS)
    end
end


---
--- A Citizen thread that continuously updates the equipment based on the player's selected weapon.
--- Caches component and equipment information to avoid redundant updates.
---
Citizen.CreateThread(main)
