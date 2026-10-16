---@class FOXClothes
local api = {}

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
function api:newGarment(name, parts)
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

---@param color Vector3|Vector4
---@return self
function class:setColor(color)
	self.color = color
	return self
end

---@return self
function class:apply()
	for i = 1, #self.layers do
		local tint = self.layers[i].tint
		if tint then
			local mat = matrices.scale4(self.color.rgb --[[@as Vector3]])
			mat.v44 = self.color.a --[[@as number?]] or 1
			mat = mat * tint.matrix

			local x, y, u, v = tint.uv:unpack()

			self.layers[i].texture:restore():applyMatrix(x, y, u, v, mat, true):update()
		end
	end
	return self
end

return api
