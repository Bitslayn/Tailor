---@class FOXClothes.Mannequin
---@field collections table<string, ModelPart[]>
local class = {}
class.__index = class

---@nodiscard
local function newMannequin()
	return setmetatable({ collections = {} }, class)
end

---@param name string
---@param parts ModelPart[]
---@return self
function class:addCollection(name, parts)
	self.collections[name] = parts
	return self
end

---@param outfit FOXClothes.Outfit
---@return self
function class:applyOutfit(outfit)
	require("scripts/libraries/PartLayers")

	for _, parts in pairs(self.collections) do
		for i = 1, #parts do
			parts[i]:initializeLayers():renderTypeLayer(2, "TRANSLUCENT")
		end
	end

	local layer = 3
	for i = #outfit.garments, 1, -1 do
		for j = 1, #outfit.garments[i].layers do
			for _, part in pairs(self.collections[outfit.garments[i].collection]) do
				part:setTextureLayer(layer, "CUSTOM", outfit.garments[i].layers[j].texture)
			end
			layer = layer + 1
		end
		outfit.garments[i]:apply(outfit.garments, i)
	end

	return self
end

return newMannequin
