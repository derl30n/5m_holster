--- Table storing equipment data and hash keys for quick existence checks.
SUPPORTED_EQUIPMENT = {
    data = {},      --- Stores equipment data.
    hash_table = {} --- Stores hash keys for quick existence checks.
}
SUPPORTED_EQUIPMENT = { data = {}, hash_table = {} }

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
--- Register a pedestrian model by its name, storing its hash for future reference.
--- @param ped_name string Name of the pedestrian model.
--- @return number Hash of the pedestrian model.
---
local function registerPed(ped_name)
    local ped_hash = GetHashKey(ped_name)

    if not IsModelValid(ped_hash) then
        error("invalid ped: " .. tostring(ped_name))
    end

    ped_hash_cache[ped_name] = ped_hash

    return ped_hash
end


---
--- Get the hash of a pedestrian model by its name.
--- @param ped_name string Name of the pedestrian model.
--- @return number Hash of the pedestrian model.
---
local function getPedHash(ped_name)
    return ped_hash_cache[ped_name] or registerPed(ped_name)
end


---
--- Register a weapon by its name, storing its hash for future reference.
--- @param weapon_name string Name of the weapon.
--- @return number Hash of the weapon.
---
local function registerWeapon(weapon_name)
    local weapon_hash = GetHashKey(weapon_name)

    if not IsWeaponValid(weapon_hash) then
        error("Invalid weapon " .. tostring(weapon_name))
    end

    wpn_hash_cache[weapon_name] = weapon_hash

    return weapon_hash
end


---
--- Get the hash of a weapon by its name.
--- @param weapon_name string Name of the weapon.
--- @return number Hash of the weapon.
---
local function getWeaponHash(weapon_name)
    return wpn_hash_cache[weapon_name] or registerWeapon(weapon_name)
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
end

loadConfig()
