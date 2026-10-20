---@class FOXTailor.Mannequin
---@field collections table<string, FOXTailor.Mannequin.Collections>
local class = {}
class.__index = class

---@class FOXTailor.Mannequin.Collections
---@field name string
---@field parts table<any, ModelPart>

---@return FOXTailor.Mannequin
---@nodiscard
local function newMannequin()
	return setmetatable({ collections = {} }, class)
end

---@param name string
---@param parts table<any, ModelPart>
---@return self
function class:addCollection(name, parts)
	self.collections[name] = { name = name, parts = parts }
	return self
end

-- TODO: Assert if an accessory targets a collection group instead of a ModelPart group
-- TODO: Store a list of applied accessories. If an accessory was already visible before applying the outfit,
-- that accessory should not become hidden when switching outfits.

---@param outfit FOXTailor.Outfit
---@return self
function class:applyOutfit(outfit)
	local layers = {}

	for _, collection in next, self.collections do
		layers[collection.name] = 3
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
