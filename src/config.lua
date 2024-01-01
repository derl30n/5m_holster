supported_weapons_hash = {}
supported_equipment = {}

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
    supported_weapons_hash[weapon_hash] = true
end

-- Function to register equipment
local function registerEquipment(ped_hash, component_id, weapon_hash, id_holstered, id_drawn, texture_holstered, texture_drawn)
    local equipment_definition = createEquipmentDefinition(id_holstered, id_drawn, texture_holstered, texture_drawn)

    local weapon_list = supported_equipment[ped_hash] or {}
    local component_list = weapon_list[weapon_hash] or {}
    local equipment_list = component_list[component_id] or {}

    table.insert(equipment_list, equipment_definition)

    component_list[component_id] = equipment_list
    weapon_list[weapon_hash] = component_list
    supported_equipment[ped_hash] = weapon_list
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

UPDATE_INTERVAL_IN_MS = 200

-- see https://docs.fivem.net/docs/game-references/ped-models/ for more ped models
registerPed("mp_f_freemode_01")
registerPed("mp_m_freemode_01")
-- Add more peds as needed

-- see https://wiki.rage.mp/index.php?title=Weapons
registerWeapon("weapon_pistol_mk2")
registerWeapon("weapon_combatpistol")
registerWeapon("weapon_stungun")
registerWeapon("weapon_nightstick")
registerWeapon("weapon_revolver")
registerWeapon("weapon_revolver_mk2")
registerWeapon("weapon_doubleaction")
registerWeapon("weapon_navyrevolver")
registerWeapon("weapon_flashlight")
-- Add more weapons as needed


registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 1, 3)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 9, 3)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 29, 3)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 81, 82)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 88, 89)
registerEquipmentRange(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 146, 176, -1)

registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 6, 5)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 8, 2)


registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 245, 246, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 249, 250, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 255, 256, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 257, 258, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 260, 261, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 267, 268, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 271, 272, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 277, 278, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 279, 280, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 282, 283, 1, 0)

registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 245, 247, 1)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 249, 251, 1)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 257, 259, 1)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 260, 262, 1)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 263, 264)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 267, 269, 1)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 271, 273, 1)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 279, 281, 1)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 282, 284, 1)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 285, 286)

registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 245, 248, 1)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 249, 252, 1)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 253, 254)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 263, 265)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 267, 270, 1)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 271, 274, 1)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 275, 276)
registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 285, 287)


registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 1, 3)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 9, 7)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 42, 43)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 110, 111)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 119, 120)
registerEquipmentRange(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 176, 206, -1)

registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 6, 5)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 8, 2)

registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_revolver, 122, 121)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_revolver_mk2, 122, 121)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_doubleaction, 122, 121)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_navyrevolver, 122, 121)


registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 199, 200, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 203, 204, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 209, 210, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 211, 212, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 214, 215, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 221, 222, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 225, 226, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 231, 232, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 233, 234, 1, 0)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_stungun, 236, 237, 1, 0)

registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 199, 201, 1)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 203, 205, 1)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 211, 213, 1)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 214, 216, 1)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 217, 218)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 221, 223, 1)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 225, 227, 1)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 233, 235, 1)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 236, 238, 1)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 239, 240)

registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 199, 202, 1)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 203, 206, 1)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 207, 208)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 217, 219)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 221, 224, 1)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 225, 228, 1)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 229, 230)
registerEquipment(REGISTERED_PEDS.mp_m_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_flashlight, 239, 240)
-- Add more equipment as needed