---@class FOXTailor
local api = {}

require("scripts/libraries/PartLayers")

---@class FOXTailor.Clothing
---@field name string
---@field apply function
---@field remove function

api.newGarment = require("./class/garment")
api.newAccessory = require("./class/accessory")

api.newOutfit = require("./class/outfit")
api.newMannequin = require("./class/mannequin")

return api