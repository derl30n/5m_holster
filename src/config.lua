local supported_ped = {}
local supported_weapons = {}
supported_weapons_hash = {}

-- Function to register a ped
local function registerPed(ped_name)
    supported_ped[ped_name] = GetHashKey(ped_name)
end

-- Function to register a weapon
local function registerWeapon(weapon_name)
    local weapon_hash = GetHashKey(weapon_name)
    supported_weapons[weapon_name] = weapon_hash
    supported_weapons_hash[weapon_hash] = true
end

-- Function to create equipment definition
local function createEquipmentDefinition(id_holstered, id_drawn, texture_holstered, texture_drawn)
    return {
        ["id_holstered"] = id_holstered,
        ["id_drawn"] = id_drawn,
        ["texture_holstered"] = texture_holstered or 0,
        ["texture_drawn"] = texture_drawn or texture_holstered
    }
end

-- see https://www.lcpdfr.com/wiki/lspdfr/04/modding/doc/component/ OR https://wiki.rage.mp/index.php?title=Clothes
local components = {
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

registerPed("mp_f_freemode_01")
registerPed("mp_m_freemode_01")

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

-- add component from component_ids table
supported_equipment = {
    [supported_ped.mp_f_freemode_01] = {
        [components.teef] = {
            [supported_weapons.weapon_pistol_mk2] = {
                createEquipmentDefinition(1, 3),
                createEquipmentDefinition(9, 7),
                createEquipmentDefinition(29, 30),
                createEquipmentDefinition(81, 82),
                createEquipmentDefinition(88, 89),
                createEquipmentDefinition(146, 145),
                createEquipmentDefinition(148, 147),
                createEquipmentDefinition(150, 149),
                createEquipmentDefinition(152, 151),
                createEquipmentDefinition(154, 153),
                createEquipmentDefinition(156, 155),
                createEquipmentDefinition(158, 157),
                createEquipmentDefinition(160, 159),
                createEquipmentDefinition(162, 161),
                createEquipmentDefinition(164, 163),
                createEquipmentDefinition(166, 165),
                createEquipmentDefinition(168, 167),
                createEquipmentDefinition(170, 169),
                createEquipmentDefinition(172, 171),
                createEquipmentDefinition(174, 173),
                createEquipmentDefinition(176, 175)
            },
            [supported_weapons.weapon_combatpistol] = {
                createEquipmentDefinition(6, 5),
                createEquipmentDefinition(8, 2)
            }
        },

        [components.accs] = {
            [supported_weapons.weapon_stungun] = {
                createEquipmentDefinition(245, 246, 1, 0),
                createEquipmentDefinition(249, 250, 1, 0),
                createEquipmentDefinition(255, 256, 1, 0),
                createEquipmentDefinition(257, 258, 1, 0),
                createEquipmentDefinition(260, 261, 1, 0),
                createEquipmentDefinition(267, 268, 1, 0),
                createEquipmentDefinition(271, 272, 1, 0),
                createEquipmentDefinition(277, 278, 1, 0),
                createEquipmentDefinition(279, 280, 1, 0),
                createEquipmentDefinition(282, 283, 1, 0),
            },
            [supported_weapons.weapon_nightstick] = {
                createEquipmentDefinition(245, 247, 1),
                createEquipmentDefinition(249, 251, 1),
                createEquipmentDefinition(257, 259, 1),
                createEquipmentDefinition(260, 262, 1),
                createEquipmentDefinition(263, 264),
                createEquipmentDefinition(267, 269, 1),
                createEquipmentDefinition(271, 273, 1),
                createEquipmentDefinition(279, 281, 1),
                createEquipmentDefinition(282, 284, 1),
                createEquipmentDefinition(285, 286)
            },
            [supported_weapons.weapon_flashlight] = {
                createEquipmentDefinition(245, 248, 1),
                createEquipmentDefinition(249, 252, 1),
                createEquipmentDefinition(253, 254),
                createEquipmentDefinition(263, 265),
                createEquipmentDefinition(267, 270, 1),
                createEquipmentDefinition(271, 274, 1),
                createEquipmentDefinition(275, 276),
                createEquipmentDefinition(285, 287)
            }
        }
    },

    [supported_ped.mp_m_freemode_01] = {
        [components.teef] = {
            [supported_weapons.weapon_pistol_mk2] = {
                createEquipmentDefinition(1, 3),
                createEquipmentDefinition(9, 7),
                createEquipmentDefinition(42, 43),
                createEquipmentDefinition(110, 111),
                createEquipmentDefinition(119, 120),
                createEquipmentDefinition(176, 175),
                createEquipmentDefinition(178, 177),
                createEquipmentDefinition(180, 179),
                createEquipmentDefinition(182, 181),
                createEquipmentDefinition(184, 183),
                createEquipmentDefinition(186, 185),
                createEquipmentDefinition(188, 187),
                createEquipmentDefinition(190, 189),
                createEquipmentDefinition(192, 191),
                createEquipmentDefinition(194, 193),
                createEquipmentDefinition(196, 195),
                createEquipmentDefinition(198, 197),
                createEquipmentDefinition(200, 199),
                createEquipmentDefinition(202, 201),
                createEquipmentDefinition(204, 203),
                createEquipmentDefinition(206, 205)
            },
            [supported_weapons.weapon_combatpistol] = {
                createEquipmentDefinition(6, 5),
                createEquipmentDefinition(8, 2)
            },
            [supported_weapons.weapon_revolver] = {
                createEquipmentDefinition(122, 121)
            },
            [supported_weapons.weapon_revolver_mk2] = {
                createEquipmentDefinition(122, 121)
            },
            [supported_weapons.weapon_doubleaction] = {
                createEquipmentDefinition(122, 121)
            },
            [supported_weapons.weapon_navyrevolver] = {
                createEquipmentDefinition(122, 121)
            }
        },

        [components.accs] = {
            [supported_weapons.weapon_stungun] = {
                createEquipmentDefinition(199, 200, 1, 0),
                createEquipmentDefinition(203, 204, 1, 0),
                createEquipmentDefinition(209, 210, 1, 0),
                createEquipmentDefinition(211, 212, 1, 0),
                createEquipmentDefinition(214, 215, 1, 0),
                createEquipmentDefinition(221, 222, 1, 0),
                createEquipmentDefinition(225, 226, 1, 0),
                createEquipmentDefinition(231, 232, 1, 0),
                createEquipmentDefinition(233, 234, 1, 0),
                createEquipmentDefinition(236, 237, 1, 0)
            },
            [supported_weapons.weapon_nightstick] = {
                createEquipmentDefinition(199, 201, 1),
                createEquipmentDefinition(203, 205, 1),
                createEquipmentDefinition(211, 213, 1),
                createEquipmentDefinition(214, 216, 1),
                createEquipmentDefinition(217, 218),
                createEquipmentDefinition(221, 223, 1),
                createEquipmentDefinition(225, 227, 1),
                createEquipmentDefinition(233, 235, 1),
                createEquipmentDefinition(236, 238, 1),
                createEquipmentDefinition(239, 240)
            },
            [supported_weapons.weapon_flashlight] = {
                createEquipmentDefinition(199, 202, 1),
                createEquipmentDefinition(203, 206, 1),
                createEquipmentDefinition(207, 208),
                createEquipmentDefinition(217, 219),
                createEquipmentDefinition(221, 224, 1),
                createEquipmentDefinition(225, 228, 1),
                createEquipmentDefinition(229, 230),
                createEquipmentDefinition(239, 240)
            }
        }
    }
}
