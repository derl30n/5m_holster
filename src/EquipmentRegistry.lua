local NAME = "EquipmentRegistry"

local EquipmentRegistry = {}

---
--- Creates a new instance of the EquipmentModule.
--- @return table New EquipmentModule instance.
---
function EquipmentRegistry.new()
    local self = {
        data = {},
        hashTable = {}
    }

    ---
    --- Adds equipment data to the supported equipment table.
    --- @param pedHash number Hash of the pedestrian model.
    --- @param weaponHash number Hash of the weapon.
    --- @param component number Component ID.
    --- @param equipment table Equipment definition.
    ---
    function self:add(pedHash, weaponHash, component, equipment)
        local combinedHash = pedHash + weaponHash
        local componentList = self.data[combinedHash] or {}
        local equipmentList = componentList[component] or {}

        equipmentList[equipment.drawn.drawableId] = equipment
        equipmentList[equipment.holstered.drawableId] = equipment

        componentList[component] = equipmentList

        self.data[combinedHash] = componentList
        self.hashTable[combinedHash] = true
    end

    ---
    --- Checks if a combination of pedestrian and weapon hashes exists in the supported equipment table.
    --- @param pedHash number Hash of the pedestrian model.
    --- @param weaponHash number Hash of the weapon.
    --- @return boolean True if the combination exists, otherwise false.
    ---
    function self:contains(pedHash, weaponHash)
        self.currentCombinedHash = pedHash + weaponHash

        return self.hashTable[self.currentCombinedHash] ~= nil
    end

    ---
    --- Retrieves equipment data for the last checked hash keys.
    --- @return table Equipment data corresponding to the last checked hash keys.
    ---
    function self:retrieve()
        return self.data[self.currentCombinedHash]
    end

    return self
end

return EquipmentRegistry