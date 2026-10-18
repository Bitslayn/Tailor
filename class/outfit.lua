---@class FOXTailor.Outfit
---@field garments FOXTailor.Garment[]
local class = {}
class.__index = class

---@param garments FOXTailor.Garment[]
---@nodiscard
local function newOutfit(garments)
	return setmetatable({ garments = garments }, class)
end

return newOutfit
