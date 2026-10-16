---@class FOXClothes.Mannequin
---@field collections table<string, FOXClothes.Mannequin.Collections>
local class = {}
class.__index = class

---@class FOXClothes.Mannequin.Collections
---@field parts ModelPart[]
---@field offset integer

---@nodiscard
local function newMannequin()
	return setmetatable({ collections = {} }, class)
end

---@param name string
---@param parts ModelPart[]
---@param layer_offset integer?
---@return self
function class:addCollection(name, parts, layer_offset)
	self.collections[name] = { parts = parts, offset = layer_offset or 1 }
	return self
end

---@param outfit FOXClothes.Outfit
---@return self
function class:applyOutfit(outfit)
	require("scripts/libraries/PartLayers")

	-- TODO fix layering issues and variable naming

	for _, collection in pairs(self.collections) do
		for i = 1, #collection.parts do
			collection.parts[i]:initializeLayers():renderTypeLayer(2, "TRANSLUCENT")
		end
	end

	local layers = {}

	for i = #outfit.garments, 1, -1 do
		for j = 1, #outfit.garments[i].layers do
			local collection = outfit.garments[i].collection
			layers[collection] = (layers[collection] or self.collections[collection].offset) + 1

			for _, part in pairs(self.collections[collection].parts) do
				part:setTextureLayer(layers[collection], "CUSTOM", outfit.garments[i].layers[j].texture)
			end
		end
		outfit.garments[i]:apply(outfit.garments, i)
	end

	return self
end

return newMannequin
