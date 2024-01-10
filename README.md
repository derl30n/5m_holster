# Advanced Holster Script for FiveM

[![GitHub release](https://img.shields.io/github/v/release/derl30n/5m_holster)](https://github.com/derl30n/5m_holster/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/derl30n/5m_holster/total?style=flat&color=brightgreen)](https://github.com/derl30n/5m_holster/releases/latest)

<img src="https://i.imgur.com/vKp2gsn.png" />

[<img src="https://media.giphy.com/media/loGRS56xWOA5fEy5OF/giphy.gif" width="270" height="360"/>]()
[<img src="https://i.imgur.com/1pmOQKI.png" width="270" height="360">](https://i.imgur.com/1pmOQKI.png)
[<img src="https://i.imgur.com/r4oi14n.png" width="270" height="360">](https://i.imgur.com/r4oi14n.png)

This server-side resource for FiveM automatically changes holster models based on the drawn weapon. It supports every ped drawable and weapon loaded in the game, including EUP outfits.


## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
    - [Pedestrians](#pedestrians)
    - [Weapons](#weapons)
    - [Equipment](#equipment)
- [Examples](#examples)
    - [EUP Addons](#eup-addons)
    - [Mass registration](#registerequipmentrange)
- [Support](#support)
- [FAQ](#faq)
- [License](#license)

## Features

- Supports every ped drawable and weapon loaded in the game, including EUP.
- Highly configurable with a modular config file.
- Detailed error messages and solutions provided for easy issue resolution.

## Installation

1. Download the [latest release](https://github.com/derl30n/5m_holster/releases/latest) as a zip file or clone the repository.
2. Place it in your `resources` folder.
3. Add `ensure 5m_holster` to your `server.cfg` for startup execution.

## Configuration

The configuration file, [config.lua](https://github.com/derl30n/5m_holster/blob/master/src/config.lua), is located in the `src` folder. Adjust configurations to your liking.

### Pedestrians

Integrate new characters using `registerPed`. Find ped models [here](https://docs.fivem.net/docs/game-references/ped-models/).

```lua
registerPed("mp_f_freemode_01")
registerPed("mp_m_freemode_01")
```

To remove a pedestrian, simply remove the corresponding `registerPed` line. Ensure no [equipment](#equipment) relies on the removed ped.

### Weapons

Add new weapons using `registerWeapon` below existing entries.
Weapon models can be found [here](https://wiki.rage.mp/index.php?title=Weapons).

```lua
registerWeapon("weapon_combatpistol")
registerWeapon("weapon_revolver")
registerWeapon("weapon_revolver_mk2")
```

To remove a weapon, remove the corresponding `registerWeapon` line. Ensure no [equipment](#equipment) relies on the removed weapon.

### Equipment

Add holsters, belts, vests etc. with `registerEquipment` and `registerEquipmentRange`.
Clothes can be found [here](https://github.com/root-cause/v-clothingnames/). Pre-defined body parts are listed in `COMPONENTS`.

<details>
  <summary>Components</summary>

  ```lua
  local COMPONENTS = {
    ["head"] = 0,
    ["berd"] = 1,  --- masks
    ["hair"] = 2,  --- hair styles
    ["uppr"] = 3,  --- torso: shirt etc [MIGHT BE HANDS]
    ["lowr"] = 4,  --- legs: pants
    ["jbib"] = 5,  --- Bags and Parachutes
    ["feet"] = 6,  --- shoes
    ["teef"] = 7,  --- holster
    ["accs"] = 8,  --- belt
    ["task"] = 9,  --- vests or body armor
    ["decl"] = 10, --- overlays like text and emblems.
    ["hand"] = 11  --- hands and arms
}
  ```

</details>


```lua
registerEquipment(REGISTERED_PEDS.ped_name, COMPONENTS.teef, REGISTERED_WPNS.weapon_name, id_holstered, id_drawn)
--- or for a range of equipment:
registerEquipmentRange(REGISTERED_PEDS.ped_name, COMPONENTS.teef, REGISTERED_WPNS.weapon_name, 146, 176, -1)
```

For more complex configurations, use resources like [eup-ui](https://forum.cfx.re/t/release-eup-for-fivem-server-sided/139848) to determine body parts and component IDs.

To remove equipment, remove the corresponding `registerEquipment` line.

<details>
  <summary>Explanation</summary>

The `registerEquipment` function requires multiple parameters. The first three are [`PED`](#pedestrians), [`COMPONENT`](#equipment) and [`WEAPON`](#weapons).

  ```lua
  registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 3, 1)
  ```

The `3` represents the holstered id of the variation and the `1` the drawn id.


| name                                                                         | type | accessible via  | required | description                                              |
|------------------------------------------------------------------------------|------|-----------------|----------|----------------------------------------------------------|
| [ped](#pedestrians)       | hash | REGISTERED_PEDS | yes      | refers to the ped model, defined with 'registerPed'     |
| [component](#equipmentt) | int  | COMPONENTS      | yes      | refers to a peds component, defined in 'COMPONENTS'     |
| [weapon](#weapons)    | hash | REGISTERED_WPNS | yes      | refers to a weapon model, defined with 'registerWeapon' |
| holstered id                                                                 | int  | none            | yes      | refers to the drawable component of the ped             |
| drawn id                                                                     | int  | none            | yes      | refers to the drawable component of the ped             |
| texture holstered                                                            | int  | none            | no       | refers to the texture of the holster                    |
| texture drawn                                                                | int  | none            | no       | refers to the texture of the holster                    |


</details>

## Examples

### registerEquipmentRange

<details>
  <summary>Example registerEquipmentRange</summary>

The config below shows an example how `registerEquipmentRange` can be used to add multiple holsters at once.
So if you have multiple holsters, instead of doing this

  ```lua
  registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 146, 145)
  registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 148, 147)
  registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 150, 149)
  registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 152, 151)
  registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 154, 153)
  registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 156, 155)
  -- Add more equipment as needed
  ```

you can simply do this

  ```lua
  registerEquipmentRange(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_pistol_mk2, 146, 156, -1)
  -- Add more equipment as needed
  ```

The `-1` points to the drawn id `146 - 1 = 145`, if the drawn id would be `147` it'd be `1` instead of `-1`.

</details>

### EUP Addons

<details>
  <summary>Example config featuring EUP Addons, drawable Baton, Taser and Flashlight</summary>

  ```lua
  --- see https://docs.fivem.net/docs/game-references/ped-models/ for more ped models
  registerPed("mp_f_freemode_01")
  registerPed("mp_m_freemode_01")
  -- Add more peds as needed

  --- see https://wiki.rage.mp/index.php?title=Weapons
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
  ```

</details>

## Support

- Open the console with `F8` for error messages. Example:
  <img src="https://i.imgur.com/ZygRVtM.png" />
- For bug reports or feature requests, [open an Issue on GitHub](https://github.com/derl30n/5m_holster/issues/new/choose).

## FAQ

#### How does this work?
Peds have variations of duty belts with and without guns. The script changes components when the player draws or holsters a weapon, supporting unlimited combinations of peds, weapons, and components.

#### Does this support EUP?
Yes, it's preconfigured to work with default pistol holsters for both female and male mp characters.

#### Does this support EUP Addons?
Yes, all clothes are supported.

#### Does this have custom animations?
No, it doesn't include custom animations.

#### Does this work in Singleplayer for LSPDFR?
No, this is a FiveM resource only.

## License

[GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html)