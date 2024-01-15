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
    --- Generates an error message for an invalid pedestrian component variation.
    --- Advises on out-of-range values for equipment and texture.
    --- @return string Error message for the invalid ped component variation.
    ---
    function self:getErrorMessageForInvalidVariation()
        local noAvailDrawable = GetNumberOfPedDrawableVariations(self.ped, self.component) - 1
        local numAvailTextures = GetNumberOfPedTextureVariations(self.ped, self.component, self.equipment) - 1

        self:_adviseOnOutOfRangeValue("equipment", noAvailDrawable)
        self:_adviseOnOutOfRangeValue("texture", numAvailTextures)

        return "Invalid ped component variation: " .. self:_toFormattedString()
    end

    ---
    --- Advises on an out-of-range value in the data package and updates the package accordingly.
    --- @param name string Name of the value to check.
    --- @param valueMax number Maximum allowed value.
    ---
    function self:_adviseOnOutOfRangeValue(name, valueMax)
        local value = self[name]

        if value <= valueMax then
            return
        end

        self[name] = "!" .. value .. "!"
        self:_addMessage(string.format(" | INVALID %s ID  %x, highest available ID: %x", string.upper(name), value, valueMax ))
    end

    ---
    --- Adds a message to the issue message of a pedestrian data package.
    --- @param message string Message to be added.
    ---
    function self:_addMessage(message)
        self.issueMessage = self.issueMessage .. message
    end

    ---
    --- Converts the data package to a string representation.
    --- @return string String representation of the data package.
    ---
    function self:_toFormattedString()
        return string.format("%d %d %s %s %s", self.ped, self.component, self.equipment, self.texture, self.issueMessage)
    end

    return self
end


local Client = {}

function Client.new()
    local PED_COMPONENT_VARIATION_PALETTE_ID = 0

    local self = {
        supportedEquipment = LoadSupportedEquipmentFromConfig(),
        component = nil,
        equipment = nil,
        ped = nil,
        weapon = nil
    }

    ---
    --- Sets pedestrian component variation based on weapon change, validating and handling errors.
    --- @param ped number Pedestrian ID.
    --- @param componentId number Pedestrian component ID.
    --- @param drawableId number Pedestrian equipment ID.
    --- @param textureId number Pedestrian texture ID.
    ---
    local function _setPedComponentVariationBasedOnWeaponChange(ped, componentId, drawableId, textureId)
        if not IsPedComponentVariationValid(ped, componentId, drawableId, textureId) then
            local error_message = PedDataPackage.new(ped, componentId, drawableId, textureId):getErrorMessageForInvalidVariation()

            error(error_message)
        end

        SetPedComponentVariation(ped, componentId, drawableId, textureId, PED_COMPONENT_VARIATION_PALETTE_ID)
    end

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

    ---
    --- Sets the pedestrian component variation for holstered equipment based on the cached data.
    ---
    function self:setPedComponentVariationHolstered()
        _setPedComponentVariationBasedOnWeaponChange(self:unpackHolstered())
    end

    ---
    --- Sets the pedestrian component variation for drawn equipment based on the cached data.
    ---
    function self:setPedComponentVariationDrawn()
        _setPedComponentVariationBasedOnWeaponChange(self:unpackDrawn())
    end

    ---
    --- Retrieves matching equipment for a pedestrian and weapon, considering drawn and holstered states.
    --- @return number, table Pedestrian component ID and corresponding equipment table.
    ---
    function self:getMatchingEquipment()
        for componentId, componentList in pairs(self.supportedEquipment:retrieve()) do
            local drawableId = GetPedDrawableVariation(self.ped, componentId)
            local equipment = componentList[drawableId]

            if equipment and (equipment.holstered.drawableId == drawableId or equipment.drawn.drawableId == drawableId) then
                return componentId, equipment
            end
        end
    end

    ---
    --- Updates equipment based on the selected weapon for the player's pedestrian.
    ---
    function self:updateEquipment()
        local ped = GetPlayerPed(-1)
        local weapon = GetSelectedPedWeapon(ped)

        if ped == self.ped and weapon == self.weapon then
            return
        end

        self.ped = ped
        self.weapon = weapon

        --- prevent future updates ped when nothing has changed
        if self.component then
            self:setPedComponentVariationHolstered()
            self.component = nil
        end

        if not self.supportedEquipment:contains(GetEntityModel(ped), weapon) then
            return
        end

        local component, equipment = self:getMatchingEquipment()

        if not equipment then
            return
        end

        self.component = component
        self.equipment = equipment

        self:setPedComponentVariationDrawn()
    end

    return self
end


---
--- Main entry point for the script. Initializes the client and continuously updates equipment based on the player's selected weapon.
---
local function main()
    local client = Client.new()

    while true do
        client:updateEquipment()

        Citizen.Wait(PAUSE_DURATION_BETWEEN_UPDATES_IN_MS)
    end
end


---
--- A Citizen thread that continuously updates the equipment based on the player's selected weapon.
--- Caches component and equipment information to avoid redundant updates.
---
Citizen.CreateThread(main)
