---@class FOXClothes.Garment
---@field name string
---@field parts ModelPart[]
---@field layers FOXClothes.Garment.Layer[]
---@field masks FOXClothes.Garment.Mask[]
local class = {}
class.__index = class

---@class FOXClothes.Garment.Layer
---@field texture Texture
---@field color Vector3|Vector4?
---@field tint FOXClothes.Garment.Tint?

---@class FOXClothes.Garment.Tint
---@field uv Vector4
---@field matrix Matrix4

---@class FOXClothes.Garment.Mask

---@param name string
---@param parts ModelPart[]
---@return FOXClothes.Garment
---@nodiscard
local function newGarment(name, parts)
	return setmetatable({ name = name, parts = parts, layers = {}, masks = {} }, class)
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

---@param wearing FOXClothes.Garment[]
---@param index integer
---@return self
function class:apply(wearing, index)
	---@type Vector4[]
	local mask_queue = {}

	-- Queue masks
	for i = 1, index - 1 do
		if self.masks[wearing[i].name] then
			for _, mask in ipairs(self.masks[wearing[i].name]) do
				mask_queue[#mask_queue + 1] = mask
			end
		end
	end

	-- Apply textures
	for i = 1, #self.layers do
		local texture = self.layers[i].texture
		texture:restore()

		-- Apply masks
		for j = 1, #mask_queue do
			local x, y, u, v = mask_queue[j]:unpack()
			texture:fill(x, y, u, v, 0, 0, 0, 0)
		end

		-- Apply tint
		local tint = self.layers[i].tint
		if tint then
			local mat = matrices.scale4(self.color.rgb --[[@as Vector3]])
			mat.v44 = self.color.a --[[@as number?]] or 1
			mat = mat * tint.matrix

			local x, y, u, v = tint.uv:unpack()

			texture:applyMatrix(x, y, u, v, mat, true)
		end

		texture:update()
	end

	return self
end

return newGarment