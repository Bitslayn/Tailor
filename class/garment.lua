---@class FOXTailor.Garment
---@field name string
---@field collection string
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
---@param collection string
---@return FOXTailor.Garment
---@nodiscard
local function newGarment(name, collection)
	return setmetatable({ name = name, collection = collection, layers = {}, masks = {} }, class)
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

return newGarment