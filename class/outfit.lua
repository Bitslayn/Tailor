---@class FOXTailor.Outfit
---@field garments FOXTailor.Garment[]
local class = {}
class.__index = class

---@param garments FOXTailor.Garment[]
---@return FOXTailor.Outfit
---@nodiscard
local function newOutfit(garments)
	return setmetatable({ garments = garments }, class)
end

-- Dev note: Customization will be handled in the outfit rather than the garment.
-- This will allow garments to not have to control coloring (making reusability easier),
-- but also reduce cross talk required to make outfits work how they should.

return newOutfit
