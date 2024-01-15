local pedHashCache = {}
local wpnHashCache = {}


local EquipmentModule = {}

---
--- Creates a new instance of the EquipmentModule.
--- @return table New EquipmentModule instance.
---
function EquipmentModule.new()
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


local DrawableDefinition = {}

---
--- Creates a new instance of DrawableDefinition.
--- @param drawableId number Drawable ID.
--- @param textureId number Texture ID.
--- @return table New DrawableDefinition instance.
---
function DrawableDefinition.new(drawableId, textureId)
    local self = {
        drawableId = drawableId,
        textureId = textureId
    }

    ---
    --- Unpacks the drawable and texture IDs.
    --- @return number, number Unpacked drawable and texture IDs.
    ---
    function self:unpack()
        return self.drawableId, self.textureId
    end

    return self
end


local EquipmentDefinition = {}

---
--- Creates an equipment definition with holstered and drawn IDs along with textures.
--- @param holsteredDrawableId number Holstered equipment ID.
--- @param drawnDrawableId number Drawn equipment ID.
--- @param holsteredTextureId number Holstered texture ID.
--- @param drawnTextureId number Drawn texture ID (defaults to holstered texture if not provided).
--- @return table Equipment definition.
---
function EquipmentDefinition.new(holsteredDrawableId, drawnDrawableId, holsteredTextureId, drawnTextureId)
    if holsteredTextureId == nil then
        holsteredTextureId = 0
    end

    if drawnTextureId == nil then
        drawnTextureId = holsteredTextureId
    end

    local self = {
        holstered = DrawableDefinition.new(holsteredDrawableId, holsteredTextureId),
        drawn = DrawableDefinition.new(drawnDrawableId, drawnTextureId)
    }

    return self
end


---
--- Registers a hash value for a given name, caches it, and returns the hash.
--- Throws an error if the hash is not valid according to the specified verification function.
--- @param name string The name associated with the hash.
--- @param cache table The cache table to store the registered hash.
--- @param verify function The verification function to check the validity of the hash.
--- @param type string A string indicating the type of hash (e.g., "Ped" or "Weapon").
--- @return number The registered hash value.
---
local function registerHash(name, cache, verify, type)
    local hash = GetHashKey(name)

    if not verify(hash) then
        error("Invalid " .. type .. ": " .. name)
    end

    cache[name] = hash

    return hash
end


---
--- Retrieves a cached hash value for a given name, or registers and caches it if not found.
--- Throws an error if the registered hash is not valid according to the specified verification function.
--- @param name string The name associated with the hash.
--- @param cache table The cache table to store and retrieve the hash.
--- @param verify function The verification function to check the validity of the hash.
--- @param type string A string indicating the type of hash (e.g., "Ped" or "Weapon").
--- @return number The cached or registered hash value.
---
local function getHash(name, cache, verify, type)
    return cache[name] or registerHash(name, cache, verify, type)
end


---
--- Retrieves the hash value for a pedestrian model by its name, caching and registering if necessary.
--- Throws an error if the registered hash is not a valid pedestrian model.
--- @param name string The name of the pedestrian model.
--- @return number The pedestrian model hash value.
---
local function getPedHash(name)
    return getHash(name, pedHashCache, IsModelValid, "Ped")
end


---
--- Retrieves the hash value for a weapon by its name, caching and registering if necessary.
--- Throws an error if the registered hash is not a valid weapon.
--- @param name string The name of the weapon.
--- @return number The weapon hash value.
---
local function getWeaponHash(name)
    return getHash(name, wpnHashCache, IsWeaponValid, "Weapon")
end


---
--- Registers equipment for a specific pedestrian, component, and weapon combination.
--- @param pedName string Name of the pedestrian model.
--- @param componentId number Component ID.
--- @param weaponName string Name of the weapon.
--- @param holsteredDrawableId number Holstered equipment ID.
--- @param drawnDrawableId number Drawn equipment ID.
--- @param holsteredTextureId number Holstered texture ID.
--- @param drawnTextureId number Drawn texture ID.
--- @return number, number, number, table Registered pedHash, weaponHash, componentId, and equipmentDefinition.
---
local function getEquipment(pedName, componentId, weaponName, holsteredDrawableId, drawnDrawableId, holsteredTextureId, drawnTextureId)
    local pedHash = getPedHash(pedName)
    local weaponHash = getWeaponHash(weaponName)
    local equipmentDefinition = EquipmentDefinition.new(holsteredDrawableId, drawnDrawableId, holsteredTextureId, drawnTextureId)

    return pedHash, weaponHash, componentId, equipmentDefinition
end


---
--- Loads supported equipment configurations from the global EQUIPMENT table and initializes an EquipmentModule.
--- Caches and registers pedestrian and weapon hashes, and equipment configurations.
--- @return table An instance of EquipmentModule containing the loaded supported equipment configurations.
---
function LoadSupportedEquipmentFromConfig()
    local supportedEquipment = EquipmentModule.new()

    -- Iterate through each element in the global EQUIPMENT table
    for _, element in ipairs(EQUIPMENT) do
        -- Retrieve or register hash values for pedestrian and weapon names
        local pedHash, weaponHash, componentId, equipmentDefinition = getEquipment(table.unpack(element))

        -- Add the equipment data to the supported equipment module
        supportedEquipment:add(pedHash, weaponHash, componentId, equipmentDefinition)
    end

    -- Clear the global EQUIPMENT table to free up memory
    EQUIPMENT = nil

    return supportedEquipment
end
