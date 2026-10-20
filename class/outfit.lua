---@class FOXTailor.Outfit
---@field clothes FOXTailor.Clothing[]
local class = {}
class.__index = class

---@param clothes FOXTailor.Clothing[]
---@return FOXTailor.Outfit
---@nodiscard
local function newOutfit(clothes)
	return setmetatable({ clothes = clothes }, class)
end

-- Dev note: Customization will be handled in the outfit rather than the garment.
-- This will allow garments to not have to control coloring (making reusability easier),
-- but also reduce cross talk required to make outfits work how they should.

return newOutfit
