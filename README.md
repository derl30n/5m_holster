# Holster Script for [FiveM <img src="https://upload.wikimedia.org/wikipedia/commons/5/5a/FiveM-Logo.png" width="90" height="50" />](https://fivem.net/)

[![GitHub release (with filter)](https://img.shields.io/github/v/release/derl30n/5m_holster)](https://github.com/derl30n/5m_holster/releases/latest)
[![Github All Releases download count](https://img.shields.io/github/downloads/derl30n/5m_holster/total?style=flat&color=brightgreen)](https://github.com/derl30n/5m_holster/releases/latest)




This is a server-side resource (executed on client only) for the Grand Theft Auto V Multiplayer [FiveM](https://fivem.net).
It automatically changes e.g. holster models whether the pistol, taser, baton, flashlight or whatever you like is drawn or holstered.

There are already holster scripts available, however they've not met my requirements. I wanted more...
So I created this resource which supports every type of weapon and equipment.

Thanks to its powerful and highly modular config it's super easy to configure to your likings!
Even if you run into issues, this resource gives you detailed error messages and solutions to the issues at hand.


[<img src="https://media.giphy.com/media/loGRS56xWOA5fEy5OF/giphy.gif" width="270" height="360"/>]()
[<img src="https://i.imgur.com/1pmOQKI.png" width="270" height="360">](https://i.imgur.com/1pmOQKI.png)
[<img src="https://i.imgur.com/r4oi14n.png" width="270" height="360">](https://i.imgur.com/r4oi14n.png)

## Features
Supports every ped drawable and weapon loaded in game.
Basically everything you dreamt of, you can configure it.
Draw a taser from the belt or vest, works. Wonna draw pepper spray from your duty belt? Sure, set ids in the config and enjoy!


## Installation
1. Download the [latest release](https://github.com/derl30n/5m_holster/releases/latest) as a zip file, or clone the repository using Git.
2. Put it in your `resources` folder.
3. Add `ensure holster` to your `server.cfg` to ensure it is run on start-up.

## Configuration

The configuration file can be found in the `src` folder of the resource. It's called [config.lua](https://github.com/derl30n/5m_holster/blob/master/src/config.lua). All configurations will take place in this file. 
The first few lines contain functions which help make the configuration process more streamline. You can ignore these.

### Adding Peds

Both multiplayer peds are already integrated. To add a new character simply create a new entry [`registerPed`](https://github.com/derl30n/5m_holster/blob/master/src/config.lua#L91) below the already existing ones. [Ped models can be found here.](https://docs.fivem.net/docs/game-references/ped-models/)
```lua
registerPed("mp_f_freemode_01")
registerPed("mp_m_freemode_01")
```

When this is done, you can go ahead and [add equipment](#adding-equipment) to this ped. The ped is available via `REGISTERED_PEDS.{ped_name}`.

### Removing Peds
Simply remove the corresponding `registerPed` line. Ensure there is no [equipment](https://github.com/derl30n/5m_holster/blob/master/src/config.lua#L102) left requiring the ped.

### Adding Weapons
A number of weapons are already integrated. To add new weapons simply create a new entry `registerWeapon` below the already existing ones. [Weapon models can be found here.](https://wiki.rage.mp/index.php?title=Weapons)
````lua
registerWeapon("weapon_combatpistol")   -- Combat Pistol
registerWeapon("weapon_revolver")       -- Heavy Revolver
registerWeapon("weapon_revolver_mk2")   -- Heavy Revolver Mk II
registerWeapon("weapon_doubleaction")   -- Double Action Revolver
registerWeapon("weapon_navyrevolver")   -- Navy Revolver
````

When this is done, you can go ahead and [add equipment](#adding-equipment) using your new weapon. The weapon is available via `REGISTERED_WPNS.{weapon_name}`.

### Removing Weapons
Simply remove the corresponding `registerWeapon` line. Ensure there is no [equipment](https://github.com/derl30n/5m_holster/blob/master/src/config.lua#L102) left requiring the weapon.

### Adding Equipment
A number of holsters are already integrated. To add new weapons simply create a new entry `registerEquipment` below the already existing ones. [Clothes can be found here.](https://github.com/root-cause/v-clothingnames/) The easiest way to configure for a mp character is by using a resource like the [eup-ui](https://forum.cfx.re/t/release-eup-for-fivem-server-sided/139848). Then simply select the body part and component id. You can also set a texture if there is one available.

<details>
  <summary>Eup vMenu example</summary>
    The picture below shows the default eup ui. The red circle marks the holster, the id is 149 and has 1 texture.

Example for weapon holster as see:
`registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 150, 149)`

Example for taser holster as seen:
`registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.accs, REGISTERED_WPNS.weapon_nightstick, 260, 262, 1)`

Examples can also be found down below in example config.

[<img src="https://i.imgur.com/ll1eqMd.jpeg">](https://i.imgur.com/ll1eqMd.jpeg)
</details>



Body parts are already pre-defined as [`COMPONENTS`](https://github.com/derl30n/5m_holster/blob/master/src/config.lua#L64). More infos can be found on [rage](https://wiki.rage.mp/index.php?title=Clothes) or [lspdfr wiki](https://www.lcpdfr.com/wiki/lspdfr/04/modding/doc/component/).

````lua
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
````

The `registerEquipment` function requires multiple parameters. The first three are [`PED`](#adding-peds), [`COMPONENT`](#adding-equipment) and [`WEAPON`](#adding-weapons).

`registerEquipment(REGISTERED_PEDS.mp_f_freemode_01, COMPONENTS.teef, REGISTERED_WPNS.weapon_combatpistol, 3, 1)`

The `3` represents the holstered id of the variation and the `1` the drawn id.

| name                                                                         | type | accessible via  | required | description                                              |
|------------------------------------------------------------------------------|------|-----------------|----------|----------------------------------------------------------|
| [ped](#adding-peds)       | hash | REGISTERED_PEDS | yes      | referes to the ped model, defined with 'registerPed'     |
| [component](#adding-equipment) | int  | COMPONENTS      | yes      | referes to a peds component, defined in 'COMPONENTS'     |
| [weapon](#adding-weapons)    | hash | REGISTERED_WPNS | yes      | referes to a weapon model, defined with 'registerWeapon' |
| holstered id                                                                 | int  | none            | yes      | referes to the drawable component of the ped             |
| drawn id                                                                     | int  | none            | yes      | referes to the drawable component of the ped             |
| texture holstered                                                            | int  | none            | no       | referes to the texture of the holster                    |
| texture drawn                                                                | int  | none            | no       | referes to the texture of thee holser                    |



### Example config for drawable taser, flashlight and baton
<details>
  <summary>Spoiler contains example config for extended use of different weapons and components</summary>

  ```lua
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
  ```

</details>

## FAQ
### How does this work?
Peds in GTA have variations of duty belts with and without guns in their holster. This script puts these variations to use by automatically changing components when the player draws or holsters a weapon. It's fully configurable and supports an unlimited combination of peds, weapons and components.

### Does this support EUP?
Yes, in fact, it's already preconfigured to work for the default pistol holsters for female and male mp characters.

### Does this have custom animations?
No, this resource does not have custom animations.
