local supported_ped = {}
local supported_weapons = {}
supported_weapons_hash = {}

local function addWeapon(weapon_name)
    local weapon_hash = GetHashKey(weapon_name)
    supported_weapons[weapon_name] = weapon_hash
    supported_weapons_hash[weapon_hash] = true
end

local function addPed(ped_name)
    supported_ped[ped_name] = GetHashKey(ped_name)
end

local function construct_equipment(id_holstered, id_drawn, texture, texture_drawn)
    return {
        ["id_holstered"] = id_holstered,
        ["id_drawn"] = id_drawn,
        ["texture"] = texture or 0,
        ["texture_drawn"] = texture_drawn or texture
    }
end

-- see https://www.lcpdfr.com/wiki/lspdfr/04/modding/doc/component/ OR https://wiki.rage.mp/index.php?title=Clothes
local component = {
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

-- see https://wiki.rage.mp/index.php?title=Weapons
addWeapon("weapon_pistol_mk2")
addWeapon("weapon_combatpistol")
addWeapon("weapon_stungun")
addWeapon("weapon_nightstick")

addPed("mp_f_freemode_01")
addPed("mp_m_freemode_01")

-- add component from component_ids table
supported_equipment = {
    [supported_ped.mp_f_freemode_01] = {
        [component.teef] = {
            [supported_weapons.weapon_pistol_mk2] = {
                construct_equipment(1, 3),
                construct_equipment(8, 2),
                construct_equipment(9, 7),
                construct_equipment(29, 30),
                construct_equipment(81, 82)
            },
            [supported_weapons.weapon_combatpistol] = {
                construct_equipment(6, 5)
            }
        },

        --[component.accs] = {},
        --[component.task] = {}
    },

    [supported_ped.mp_m_freemode_01] = {
        [component.teef] = {
            [supported_weapons.weapon_pistol_mk2] = {
                construct_equipment(1, 3),
                construct_equipment(8, 2),
                construct_equipment(42, 43),
                construct_equipment(110, 111),
                construct_equipment(119, 120),
                construct_equipment(188, 187)
            },
            [supported_weapons.weapon_combatpistol] = {
                construct_equipment(6, 5)
            }
        },

        [component.accs] = {
            [supported_weapons.weapon_stungun] = {
                construct_equipment(214, 215, 1, 0)
            },
            [supported_weapons.weapon_nightstick] = {
                construct_equipment(214, 216, 1)
            }
        },
        --[component.task] = {}
    }
}
