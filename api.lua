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
---@field tint FOXClothes.Garment.Tint?

---@class FOXClothes.Garment.Tint
---@field uv Vector4
---@field matrix Matrix4
---@field alpha boolean?

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
---@param alpha boolean?
---@return self
---@nodiscard
function class:addLayer(texture, x, y, u, v, matrix, alpha)
	table.insert(self.layers, { texture = texture, tint = x and { uv = vectors.vec4(x, y, u, v), matrix = matrix or matrices.mat4(), alpha = alpha } })
	return self
end

---@param color Vector3|Vector4
---@return self
---@nodiscard
function class:setColor(color)
	for i = 1, #self.layers do
		local tint = self.layers[i].tint
		if tint then
			-- TODO Test alpha support, it should act on the color rather than the texture if alpha is set to false. Probably should also make this more intuitive
			local mat = matrices.scale4(color.rgb --[[@as Vector3]])
			mat.v44 = color.a --[[@as number?]] or 1
			mat = mat * tint.matrix

			local x, y, u, v = tint.uv:unpack()

			self.layers[i].texture:applyMatrix(x, y, u, v, mat, true):update()
		end
	end
	return self
end

return api
