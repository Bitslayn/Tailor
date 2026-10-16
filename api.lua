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
---@param x integer?
---@param y integer?
---@param u integer?
---@param v integer?
---@param matrix Matrix4?
---@param alpha boolean?
---@return self
---@nodiscard
function class:addLayer(texture, x, y, u, v, matrix, alpha)
	table.insert(self.layers, { texture = texture, tint = x and { uv = vectors.vec4(x, y, u, v), matrix = matrix, alpha = alpha } })
	return self
end

return api
