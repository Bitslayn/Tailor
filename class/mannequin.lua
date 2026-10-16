---@class FOXClothes.Mannequin
---@field collections table<string, ModelPart[]>
local class = {}
class.__index = class

---@nodiscard
local function newMannequin()
	return setmetatable({ collections = {} }, class)
end

---@param name string
---@param parts ModelPart[]
---@return self
function class:addCollection(name, parts)
	self.collections[name] = parts
	return self
end

return newMannequin
