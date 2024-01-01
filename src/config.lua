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

local function construct_equipment(id_holstered, id_drawn, texture_holstered, texture_drawn)
    return {
        ["id_holstered"] = id_holstered,
        ["id_drawn"] = id_drawn,
        ["texture_holstered"] = texture_holstered or 0,
        ["texture_drawn"] = texture_drawn or texture_holstered
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
addWeapon("weapon_revolver")
addWeapon("weapon_revolver_mk2")
addWeapon("weapon_doubleaction")
addWeapon("weapon_navyrevolver")
addWeapon("weapon_flashlight")

addPed("mp_f_freemode_01")
addPed("mp_m_freemode_01")

-- add component from component_ids table
supported_equipment = {
    [supported_ped.mp_f_freemode_01] = {
        [component.teef] = {
            [supported_weapons.weapon_pistol_mk2] = {
                construct_equipment(1, 3),
                construct_equipment(9, 7),
                construct_equipment(29, 30),
                construct_equipment(81, 82),
                construct_equipment(88, 89),
                construct_equipment(146, 145),
                construct_equipment(148, 147),
                construct_equipment(150, 149),
                construct_equipment(152, 151),
                construct_equipment(154, 153),
                construct_equipment(156, 155),
                construct_equipment(158, 157),
                construct_equipment(160, 159),
                construct_equipment(162, 161),
                construct_equipment(164, 163),
                construct_equipment(166, 165),
                construct_equipment(168, 167),
                construct_equipment(170, 169),
                construct_equipment(172, 171),
                construct_equipment(174, 173),
                construct_equipment(176, 175)
            },
            [supported_weapons.weapon_combatpistol] = {
                construct_equipment(6, 5),
                construct_equipment(8, 2)
            }
        },

        [component.accs] = {
            [supported_weapons.weapon_stungun] = {
                construct_equipment(245, 246, 1, 0),
                construct_equipment(249, 250, 1, 0),
                construct_equipment(255, 256, 1, 0),
                construct_equipment(257, 258, 1, 0),
                construct_equipment(260, 261, 1, 0),
                construct_equipment(267, 268, 1, 0),
                construct_equipment(271, 272, 1, 0),
                construct_equipment(277, 278, 1, 0),
                construct_equipment(279, 280, 1, 0),
                construct_equipment(282, 283, 1, 0),
            },
            [supported_weapons.weapon_nightstick] = {
                construct_equipment(245, 247, 1),
                construct_equipment(249, 251, 1),
                construct_equipment(257, 259, 1),
                construct_equipment(260, 262, 1),
                construct_equipment(263, 264),
                construct_equipment(267, 269, 1),
                construct_equipment(271, 273, 1),
                construct_equipment(279, 281, 1),
                construct_equipment(282, 284, 1),
                construct_equipment(285, 286)
            },
            [supported_weapons.weapon_flashlight] = {
                construct_equipment(245, 248, 1),
                construct_equipment(249, 252, 1),
                construct_equipment(253, 254),
                construct_equipment(263, 265),
                construct_equipment(267, 270, 1),
                construct_equipment(271, 274, 1),
                construct_equipment(275, 276),
                construct_equipment(285, 287)
            }
        }
    },

    [supported_ped.mp_m_freemode_01] = {
        [component.teef] = {
            [supported_weapons.weapon_pistol_mk2] = {
                construct_equipment(1, 3),
                construct_equipment(9, 7),
                construct_equipment(42, 43),
                construct_equipment(110, 111),
                construct_equipment(119, 120),
                construct_equipment(176, 175),
                construct_equipment(178, 177),
                construct_equipment(180, 179),
                construct_equipment(182, 181),
                construct_equipment(184, 183),
                construct_equipment(186, 185),
                construct_equipment(188, 187),
                construct_equipment(190, 189),
                construct_equipment(192, 191),
                construct_equipment(194, 193),
                construct_equipment(196, 195),
                construct_equipment(198, 197),
                construct_equipment(200, 199),
                construct_equipment(202, 201),
                construct_equipment(204, 203),
                construct_equipment(206, 205)
            },
            [supported_weapons.weapon_combatpistol] = {
                construct_equipment(6, 5),
                construct_equipment(8, 2)
            },
            [supported_weapons.weapon_revolver] = {
                construct_equipment(122, 121)
            },
            [supported_weapons.weapon_revolver_mk2] = {
                construct_equipment(122, 121)
            },
            [supported_weapons.weapon_doubleaction] = {
                construct_equipment(122, 121)
            },
            [supported_weapons.weapon_navyrevolver] = {
                construct_equipment(122, 121)
            }
        },

        [component.accs] = {
            [supported_weapons.weapon_stungun] = {
                construct_equipment(199, 200, 1, 0),
                construct_equipment(203, 204, 1, 0),
                construct_equipment(209, 210, 1, 0),
                construct_equipment(211, 212, 1, 0),
                construct_equipment(214, 215, 1, 0),
                construct_equipment(221, 222, 1, 0),
                construct_equipment(225, 226, 1, 0),
                construct_equipment(231, 232, 1, 0),
                construct_equipment(233, 234, 1, 0),
                construct_equipment(236, 237, 1, 0)
            },
            [supported_weapons.weapon_nightstick] = {
                construct_equipment(199, 201, 1),
                construct_equipment(203, 205, 1),
                construct_equipment(211, 213, 1),
                construct_equipment(214, 216, 1),
                construct_equipment(217, 218),
                construct_equipment(221, 223, 1),
                construct_equipment(225, 227, 1),
                construct_equipment(233, 235, 1),
                construct_equipment(236, 238, 1),
                construct_equipment(239, 240)
            },
            [supported_weapons.weapon_flashlight] = {
                construct_equipment(199, 202, 1),
                construct_equipment(203, 206, 1),
                construct_equipment(207, 208),
                construct_equipment(217, 219),
                construct_equipment(221, 224, 1),
                construct_equipment(225, 228, 1),
                construct_equipment(229, 230),
                construct_equipment(239, 240)
            }
        }
    }
}
