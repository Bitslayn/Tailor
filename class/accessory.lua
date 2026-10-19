---@class FOXTailor.Accessory
local class = {}
class.__index = class

---@param name string
---@param group string
---@return FOXTailor.Accessory
---@nodiscard
local function newAccessory(name, group)
	return setmetatable({ name = name, group = group }, class)
end

return newAccessory
