---@class FOXTailor.Mannequin
---@field groups table<string, FOXTailor.Mannequin.Group>
local class = {}
class.__index = class

---@class FOXTailor.Mannequin.Group
---@field name string
---@field parts table<any, ModelPart>

---@return FOXTailor.Mannequin
---@nodiscard
local function newMannequin()
	return setmetatable({ groups = {} }, class)
end

---@param name string
---@param parts table<any, ModelPart>
---@return self
function class:addGroup(name, parts)
	self.groups[name] = { name = name, parts = parts }
	return self
end

-- TODO: Assert if an accessory targets a collection group instead of a ModelPart group
-- TODO: Store a list of applied accessories. If an accessory was already visible before applying the outfit,
-- that accessory should not become hidden when switching outfits.

---@param outfit FOXTailor.Outfit
---@return self
function class:applyOutfit(outfit)
	local layers = {}

	for _, group in next, self.groups do
		layers[group.name] = 3
	end

	-- Set ModelPart textures
	for i = #outfit.garments, 1, -1 do
		local garment = outfit.garments[i]
		for j = 1, #garment.layers do
			local group = garment.group

			for _, part in next, self.groups[group].parts do
				part:setTextureLayer(layers[group], "CUSTOM", garment.layers[j].texture)
			end

			layers[group] = layers[group] + 1
		end
	end

	outfit:bakeTextures()

	return self
end

return newMannequin
