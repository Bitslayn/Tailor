---@class FOXClothes.Outfit
---@field garments FOXClothes.Garment[]
local class = {}
class.__index = class

---@param garments FOXClothes.Garment[]
---@nodiscard
local function newOutfit(garments)
	return setmetatable({ garments = garments }, class)
end

return newOutfit
