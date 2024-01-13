--- Table storing equipment data and hash keys for quick existence checks.
SUPPORTED_EQUIPMENT = {
    data = {},      --- Stores equipment data.
    hash_table = {} --- Stores hash keys for quick existence checks.
}

---
--- Add equipment data to the supported equipment table.
--- @param ped_hash number Hash of the pedestrian model.
--- @param weapon_hash number Hash of the weapon.
--- @param component number Component ID.
--- @param equipment table Equipment definition.
---
function SUPPORTED_EQUIPMENT:add(ped_hash, weapon_hash, component, equipment)
    local comp_hash = ped_hash + weapon_hash
    local component_list = self.data[comp_hash] or {}
    local equipment_list = component_list[component] or {}

    equipment_list[equipment.id_drawn] = equipment
    equipment_list[equipment.id_holstered] = equipment

    component_list[component] = equipment_list

    self.data[comp_hash] = component_list
    self.hash_table[comp_hash] = true
end

---
--- Check if a combination of pedestrian and weapon hashes exists in the supported equipment table.
--- @param ped_hash number Hash of the pedestrian model.
--- @param weapon_hash number Hash of the weapon.
--- @return boolean True if the combination exists, otherwise false.
---
function SUPPORTED_EQUIPMENT:contains(ped_hash, weapon_hash)
    self.cached_hash = ped_hash + weapon_hash
    return self.hash_table[self.cached_hash]
end

---
--- Retrieve equipment data for the last checked hash keys.
--- @return table Equipment data corresponding to the last checked hash keys.
---
function SUPPORTED_EQUIPMENT:retrieve()
    return self.data[self.cached_hash]
end


local ped_hash_cache = {}
local wpn_hash_cache = {}


---
--- Create an equipment definition with holstered and drawn IDs along with textures.
--- @param id_holstered number Holstered equipment ID.
--- @param id_drawn number Drawn equipment ID.
--- @param texture_holstered number Holstered texture ID.
--- @param texture_drawn number Drawn texture ID (defaults to holstered texture if not provided).
--- @return table Equipment definition.
---
local function getEquipmentDefinition(id_holstered, id_drawn, texture_holstered, texture_drawn)
    return {
        id_holstered = id_holstered,
        id_drawn = id_drawn,
        texture_holstered = texture_holstered,
        texture_drawn = texture_drawn or texture_holstered
    }
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
    return getHash(name, ped_hash_cache, IsModelValid, "Ped")
end


---
--- Retrieves the hash value for a weapon by its name, caching and registering if necessary.
--- Throws an error if the registered hash is not a valid weapon.
--- @param name string The name of the weapon.
--- @return number The weapon hash value.
---
local function getWeaponHash(name)
    return getHash(name, wpn_hash_cache, IsWeaponValid, "Weapon")
end


---
--- Register equipment for a specific pedestrian, component, and weapon combination.
--- @param ped_name string Name of the pedestrian model.
--- @param component_id number Component ID.
--- @param weapon_name string Name of the weapon.
--- @param id_holstered number Holstered equipment ID.
--- @param id_drawn number Drawn equipment ID.
--- @param texture_holstered number Holstered texture ID.
--- @param texture_drawn number Drawn texture ID.
---
local function registerEquipment(ped_name, component_id, weapon_name, id_holstered, id_drawn, texture_holstered, texture_drawn)
    local ped_hash = getPedHash(ped_name)
    local weapon_hash = getWeaponHash(weapon_name)
    local equipment_definition = getEquipmentDefinition(id_holstered, id_drawn, texture_holstered or 0, texture_drawn)

    SUPPORTED_EQUIPMENT:add(ped_hash, weapon_hash, component_id, equipment_definition)
end


---
--- Load equipment configurations from the EQUIPMENT table.
---
local function loadConfig()
    for _, element in ipairs(EQUIPMENT) do
        registerEquipment(table.unpack(element))
    end

    EQUIPMENT = nil
end

loadConfig()
