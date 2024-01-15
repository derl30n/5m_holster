local NAME = "Drawable"

local Drawable = {}

---
--- Creates a new instance of DrawableDefinition.
--- @param drawableId number Drawable ID.
--- @param textureId number Texture ID.
--- @return table New DrawableDefinition instance.
---
function Drawable.new(drawableId, textureId)
    local self = {
        drawableId = drawableId,
        textureId = textureId
    }

    ---
    --- Unpacks the drawable and texture IDs.
    --- @return number, number Unpacked drawable and texture IDs.
    ---
    function self:unpack()
        return self.drawableId, self.textureId
    end

    return self
end

return Drawable