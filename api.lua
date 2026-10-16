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
---@field tint FOXClothes.Garment.Tint

---@class FOXClothes.Garment.Tint
---@field uv Vector4?
---@field matrix Matrix4?
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
---@param u integer?
---@param v integer?
---@param x integer?
---@param y integer?
---@param matrix Matrix4?
---@param alpha boolean?
---@return self
---@nodiscard
function class:addLayer(texture, u, v, x, y, matrix, alpha)
	table.insert(self.layers, { texture = texture, tint = u and { uv = vectors.vec4(u, v, x, y), matrix = matrix, alpha = alpha } })
	return self
end

return api
