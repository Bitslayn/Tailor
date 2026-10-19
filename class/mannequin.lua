---@class FOXTailor.Mannequin
---@field collections table<string, FOXTailor.Mannequin.Collections>
local class = {}
class.__index = class

---@class FOXTailor.Mannequin.Collections
---@field name string
---@field parts table<any, ModelPart>
---@field offset integer

---@nodiscard
local function newMannequin()
	return setmetatable({ collections = {} }, class)
end

---@param name string
---@param parts table<any, ModelPart>
---@param layer_offset integer?
---@return self
function class:addCollection(name, parts, layer_offset)
	self.collections[name] = { name = name, parts = parts, offset = layer_offset or 1 }
	return self
end

---@param outfit FOXTailor.Outfit
---@return self
function class:applyOutfit(outfit)
	local layers = {}

	for _, collection in next, self.collections do
		layers[collection.name] = self.collections[collection.name].offset

		for _, part in next, collection.parts do
			part:initializeLayers():renderTypeLayer(2, "TRANSLUCENT")
		end
	end

	-- Set ModelPart textures
	for i = #outfit.garments, 1, -1 do
		local garment = outfit.garments[i]
		for j = 1, #garment.layers do
			local collection = garment.collection

			for _, part in next, self.collections[collection].parts do
				part:setTextureLayer(layers[collection], "CUSTOM", garment.layers[j].texture)
			end

			layers[collection] = layers[collection] + 1
		end
	end

	outfit:bakeTextures()

	return self
end

return newMannequin
