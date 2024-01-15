---
--- Main entry point for the script. Initializes the client and continuously updates equipment based on the player's selected weapon.
---
local function main()
    local Client = require("Client")
    local constants = require "ConfigParser".loadConstants()

    Client.new()

    while true do
        client:updateEquipment()

        Citizen.Wait(constants.PAUSE_DURATION_BETWEEN_UPDATES_IN_MS)
    end
end


---
--- A Citizen thread that continuously updates the equipment based on the player's selected weapon.
--- Caches component and equipment information to avoid redundant updates.
---
Citizen.CreateThread(main)