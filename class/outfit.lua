---@class FOXTailor.Outfit
---@field garments FOXTailor.Garment[]
local class = {}
class.__index = class

---@param garments FOXTailor.Garment[]
---@nodiscard
local function newOutfit(garments)
	return setmetatable({ garments = garments }, class)
end

-- Dev note: Customization will be handled in the outfit rather than the garment.
-- This will allow garments to not have to control coloring (making reusability easier),
-- but also reduce cross talk required to make outfits work how they should.

---@return self
function class:bakeTextures()
	for i = #self.garments, 1, -1 do
		local garment = self.garments[i]

		---@type Vector4[]
		local mask_queue = {}

		-- Queue masks
		for j = 1, i - 1 do
			local mask = garment.masks[self.garments[j].name]
			if mask then
				for k = 1, #mask do
					mask_queue[#mask_queue + 1] = mask[k]
				end
			end
		end

		-- Apply textures
		for j = 1, #garment.layers do
			local texture = garment.layers[j].texture
			texture:restore()

			-- Apply masks
			for k = 1, #mask_queue do
				local x, y, u, v = mask_queue[k]:unpack()
				texture:fill(x, y, u, v, 0, 0, 0, 0)
			end

			-- Apply tint
			local tint = garment.layers[j].tint
			if tint then
				local mat = matrices.scale4(garment.color.rgb --[[@as Vector3]])
				mat.v44 = garment.color.a --[[@as number?]] or 1
				mat = mat * tint.matrix

				local x, y, u, v = tint.uv:unpack()

				texture:applyMatrix(x, y, u, v, mat, true)
			end

			texture:update()
		end
	end

	return self
end

return newOutfit
