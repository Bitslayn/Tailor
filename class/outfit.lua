---@class FOXClothes.Outfit
---@field garments FOXClothes.Garment[]
local class = {}
class.__index = class

---@param garments FOXClothes.Garment[]
---@nodiscard
local function newOutfit(garments)
	return setmetatable({ garments = garments }, class)
end

function class:apply()
	require("scripts/libraries/PartLayers")

	for _, part in pairs(collections.Skin) do
		part:initializeLayers():renderTypeLayer(2, "TRANSLUCENT")
	end

	for _, part in pairs(collections.Clothes) do
		part:initializeLayers():renderTypeLayer(2, "TRANSLUCENT"):renderTypeLayer(1, "NONE")
	end

	local layer = 3
	for i = #self.garments, 1, -1 do
		for j = 1, #self.garments[i].layers do
			for _, part in pairs(self.garments[i].parts) do
				part:setTextureLayer(layer, "CUSTOM", self.garments[i].layers[j].texture)
			end
			layer = layer + 1
		end
		self.garments[i]:apply(self.garments, i)
	end
end

return newOutfit
