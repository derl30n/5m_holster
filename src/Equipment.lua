local NAME = "Equipment"

local Equipment = {}

---
--- Creates an equipment definition with holstered and drawn IDs along with textures.
--- @param holsteredDrawableId number Holstered equipment ID.
--- @param drawnDrawableId number Drawn equipment ID.
--- @param holsteredTextureId number Holstered texture ID.
--- @param drawnTextureId number Drawn texture ID (defaults to holstered texture if not provided).
--- @return table Equipment definition.
---
function Equipment.new(holsteredDrawableId, drawnDrawableId, holsteredTextureId, drawnTextureId)
    local Drawable = require "Drawable"

    if holsteredTextureId == nil then
        holsteredTextureId = 0
    end

    if drawnTextureId == nil then
        drawnTextureId = holsteredTextureId
    end

    local self = {
        holstered = Drawable.new(holsteredDrawableId, holsteredTextureId),
        drawn = Drawable.new(drawnDrawableId, drawnTextureId)
    }

    return self
end

return Equipment