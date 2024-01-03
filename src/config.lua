SUPPORTED_WEAPONS_HASH = {}
SUPPORTED_EQUIPMENT = {}

local REGISTERED_PEDS = {}
local REGISTERED_WPNS = {}

-- Function to create equipment definition
local function createEquipmentDefinition(id_holstered, id_drawn, texture_holstered, texture_drawn)
    return {
        ["id_holstered"] = id_holstered,
        ["id_drawn"] = id_drawn,
        ["texture_holstered"] = texture_holstered,
        ["texture_drawn"] = texture_drawn or texture_holstered
    }
end

-- Function to register a ped
local function registerPed(ped_name)
    local ped_hash = GetHashKey(ped_name)

    if not IsModelValid(ped_hash) then
        error("invalid ped: " .. tostring(ped_name))
    end

    REGISTERED_PEDS[ped_name] = ped_hash
end

-- Function to register a weapon
local function registerWeapon(weapon_name)
    local weapon_hash = GetHashKey(weapon_name)

    if not IsWeaponValid(weapon_hash) then
        error("Invalid weapon " .. tostring(weapon_name))
    end

    REGISTERED_WPNS[weapon_name] = weapon_hash
    SUPPORTED_WEAPONS_HASH[weapon_hash] = true
end

-- Function to register equipment
local function registerEquipment(ped_hash, component_id, weapon_hash, id_holstered, id_drawn, texture_holstered, texture_drawn)
    local equipment_definition = createEquipmentDefinition(id_holstered, id_drawn, texture_holstered, texture_drawn)

    local weapon_list = SUPPORTED_EQUIPMENT[ped_hash] or {}
    local component_list = weapon_list[weapon_hash] or {}
    local equipment_list = component_list[component_id] or {}

    equipment_list[equipment_definition.id_drawn] = equipment_definition
    equipment_list[equipment_definition.id_holstered] = equipment_definition

    component_list[component_id] = equipment_list
    weapon_list[weapon_hash] = component_list
    SUPPORTED_EQUIPMENT[ped_hash] = weapon_list
end

-- Function to mass register equipment within an explicit range
local function registerEquipmentRange(ped_hash, component_id, weapon_hash, id_holstered_init, id_holstered_max, id_drawn_offset, texture_holstered, texture_drawn)
    for i = id_holstered_init, id_holstered_max, 2 do
        registerEquipment(ped_hash, component_id, weapon_hash, i, i + id_drawn_offset, texture_holstered, texture_drawn)
    end
end

-- see https://www.lcpdfr.com/wiki/lspdfr/04/modding/doc/component/ OR https://wiki.rage.mp/index.php?title=Clothes
local COMPONENTS = {
    ["head"] = 0,
    ["berd"] = 1, -- masks
    ["hair"] = 2, -- hair styles
    ["uppr"] = 3, -- torso: shirt etc [MIGHT BE HANDS]
    ["lowr"] = 4, -- legs: pants
    ["jbib"] = 5, -- Bags and Parachutes
    ["feet"] = 6, -- shoes
    ["teef"] = 7, -- holster
    ["accs"] = 8, -- belt
    ["task"] = 9, -- vests or body armor
    ["decl"] = 10, -- overlays like text and emblems.
    ["hand"] = 11 -- hands and arms
}

--[[
    ##### #####        DO NOT CHANGE VALUES ABOVE        ##### #####
    ##### #####          CONFIG STARTS HERE              ##### #####
    ##### #####       MODIFY BELOW TO YOUR LIKINGS       ##### #####
    ##### #####      SEE README.md FOR DOCUMENTATION     ##### #####
]]--

PAUSE_DURATION_BETWEEN_UPDATES_IN_MS = 200

-- see https://docs.fivem.net/docs/game-references/ped-models/ for more ped models
registerPed("mp_f_freemode_01")
registerPed("mp_m_freemode_01")
-- Add more peds as needed

-- see https://wiki.rage.mp/index.php?title=Weapons
registerWeapon("weapon_combatpistol")
registerWeapon("weapon_revolver")
registerWeapon("weapon_revolver_mk2")
registerWeapon("weapon_doubleaction")
registerWeapon("weapon_navyrevolver")
-- Add more weapons as needed


-- Female MP Ped
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 3, 1)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 6, 5)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 8, 2)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 29, 30)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 81, 82)

registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_combatpistol, 9, 10)

-- Male MP Ped
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 1, 3)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 6, 5)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 8, 2)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 42, 43)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 110, 111)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 119, 120)

registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_combatpistol, 16, 18)

--[[ examples for different weapons
    registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_revolver, 8, 2)
    registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_revolver_mk2, 8, 2)
    registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_doubleaction, 8, 2)
    registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_navyrevolver, 8, 2)
]]--

-- Add more equipment as needed