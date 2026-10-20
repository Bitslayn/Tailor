---@class FOXTailor.Garment
---@field name string
---@field group string
---@field layers FOXTailor.Garment.Layer[]
---@field masks FOXTailor.Garment.Mask[]
local class = {}
class.__index = class

---@class FOXTailor.Garment.Layer
---@field texture Texture
---@field color Vector3|Vector4?
---@field tint FOXTailor.Garment.Tint?

---@class FOXTailor.Garment.Tint
---@field uv Vector4
---@field matrix Matrix4

---@class FOXTailor.Garment.Mask

---@param name string
---@param group string
---@return FOXTailor.Garment
---@nodiscard
local function newGarment(name, group)
	return setmetatable({ name = name, group = group, layers = {}, masks = {} }, class)
end

---@param texture Texture
---@param x integer?
---@param y integer?
---@param u integer?
---@param v integer?
---@param matrix Matrix4?
---@return self
function class:addLayer(texture, x, y, u, v, matrix)
	table.insert(self.layers, { texture = texture, tint = x and { uv = vectors.vec4(x, y, u, v), matrix = matrix or matrices.mat4() } })
	return self
end

---Given the name of the garment worn above this garment, mask out this part of the texture.
---@param name string
---@param x integer
---@param y integer
---@param u integer
---@param v integer
---@return self
function class:addMask(name, x, y, u, v)
	if not self.masks[name] then
		self.masks[name] = {}
	end
	self.masks[name][#self.masks[name] + 1] = vectors.vec4(x, y, u, v)
	return self
end

---@param color Vector3|Vector4
---@return self
function class:setColor(color)
	self.color = color
	return self
end

---@param outfit FOXTailor.Outfit
---@param i integer
function class:applyTextures(outfit, i)
	---@type Vector4[]
	local mask_queue = {}

	-- Queue masks
	for j = 1, i - 1 do
		local mask = self.masks[outfit.garments[j].name]
		if mask then
			for k = 1, #mask do
				mask_queue[#mask_queue + 1] = mask[k]
			end
		end
	end

	-- Apply textures
	for j = 1, #self.layers do
		local texture = self.layers[j].texture
		texture:restore()

		-- Apply masks
		for k = 1, #mask_queue do
			local x, y, u, v = mask_queue[k]:unpack()
			texture:fill(x, y, u, v, 0, 0, 0, 0)
		end

		-- Apply tint
		local tint = self.layers[j].tint
		if tint then
			local mat = matrices.scale4(self.color.rgb --[[@as Vector3]])
			mat.v44 = self.color.a --[[@as number?]] or 1
			mat = mat * tint.matrix

			local x, y, u, v = tint.uv:unpack()

			texture:applyMatrix(x, y, u, v, mat, true)
		end

		texture:update()
	end
end

---@param groups FOXTailor.Mannequin.Groups
---@param layers table<string, integer>
---@param outfit FOXTailor.Outfit
---@param i integer
function class:apply(groups, layers, outfit, i)
	for j = 1, #self.layers do
		local group = self.group

		for _, part in next, groups[group].parts do
			part:setTextureLayer(layers[group], "CUSTOM", self.layers[j].texture)
		end

		layers[group] = layers[group] + 1
	end

	self:applyTextures(outfit, i)
end

return newGarment
