local NAME = "Client"

local Client = {}

function Client.new()
    local PedDataPackage = require "PedDataPackage"

    local PED_COMPONENT_VARIATION_PALETTE_ID = 0

    local self = {
        supportedEquipment = require "ConfigParser".loadSupportedEquipment(),
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

return Client