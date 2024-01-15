local NAME = "PedDataPackage"

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

return PedDataPackage