local NAME = "ConfigParser"

local ConfigParser = {}

---
--- Loads supported equipment configurations from the global EQUIPMENT table and initializes an EquipmentModule.
--- Caches and registers pedestrian and weapon hashes, and equipment configurations.
--- @return table An instance of EquipmentModule containing the loaded supported equipment configurations.
---
function ConfigParser.loadSupportedEquipment()
    local Config = require "Config"
    local Equipment = require "Equipment"
    local EquipmentRegistry = require "EquipmentRegistry"

    local pedHashCache = {}
    local wpnHashCache = {}

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
        local equipmentDefinition = Equipment.new(holsteredDrawableId, drawnDrawableId, holsteredTextureId, drawnTextureId)

        return pedHash, weaponHash, componentId, equipmentDefinition
    end

    local supportedEquipment = EquipmentRegistry.new()

    -- Iterate through each element in the Config.EQUIPMENT table
    for _, element in ipairs(Config.EQUIPMENT) do
        -- Retrieve or register hash values for pedestrian and weapon names
        local pedHash, weaponHash, componentId, equipmentDefinition = getEquipment(table.unpack(element))

        -- Add the equipment data to the supported equipment module
        supportedEquipment:add(pedHash, weaponHash, componentId, equipmentDefinition)
    end

    local constants = {}

    for _, element in ipairs(Config.CONSTANTS) do
        print(element)
    end

    return supportedEquipment, constants
end

function ConfigParser.loadConstants()
    local Config = require "Config"

    local constants = {}

    for _, element in ipairs(Config.CONSTANTS) do
        print(element)
    end

    return constants

end

return ConfigParser