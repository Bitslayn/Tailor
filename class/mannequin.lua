---@class FOXTailor.Mannequin
---@field groups FOXTailor.Mannequin.Groups
local class = {}
class.__index = class

---@alias FOXTailor.Mannequin.Groups table<string, FOXTailor.Mannequin.Group>

---@class FOXTailor.Mannequin.Group
---@field name string
---@field parts table<any, ModelPart>

---@return FOXTailor.Mannequin
---@nodiscard
local function newMannequin()
	return setmetatable({ groups = {} }, class)
end

---@param name string
---@param parts table<any, ModelPart>
---@return self
function class:addGroup(name, parts)
	self.groups[name] = { name = name, parts = parts }
	return self
end

-- TODO: Assert if an accessory targets a collection group instead of a ModelPart group
-- TODO: Store a list of applied accessories. If an accessory was already visible before applying the outfit,
-- that accessory should not become hidden when switching outfits.

---@param outfit FOXTailor.Outfit
---@return self
function class:applyOutfit(outfit)
	local groups = self.groups
	local layers = {}

	for _, group in next, groups do
		layers[group.name] = 3
		if type(group.parts) ~= "ModelPart" then
			for _, part in next, group.parts do
				part:initializeLayers()
			end
		end
	end

	for i = #outfit.garments, 1, -1 do
		local garment = outfit.garments[i]
		garment:apply(groups, layers, outfit, i)
	end

	return self
end

return newMannequin
