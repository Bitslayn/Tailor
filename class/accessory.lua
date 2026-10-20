---@class FOXTailor.Accessory
---@field name string
---@field group string
---@field parts FOXTailor.Accessory.Parts[]
local class = {}
class.__index = class

---@class FOXTailor.Accessory.Parts
---@field part ModelPart
---@field tint Vector3

---@param name string
---@param group string
---@return FOXTailor.Accessory
---@nodiscard
local function newAccessory(name, group)
	return setmetatable({ name = name, group = group, parts = {} }, class)
end

---@param part ModelPart
---@param tint Vector3?
---@return self
function class:addPart(part, tint)
	self.parts[#self.parts + 1] = { part = part, tint = tint or vectors.vec3() }
	return self
end

---@param groups FOXTailor.Mannequin.Groups
---@param layers table<string, integer>
---@param outfit FOXTailor.Outfit
---@param i integer
function class:apply(groups, layers, outfit, i)
	for j = 1, #self.parts do
		self.parts[j].part:setVisible(true)
	end
end

return newAccessory
