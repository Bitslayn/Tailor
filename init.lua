---@class FOXTailor
local api = {}

require("scripts/libraries/PartLayers")

api.newGarment = require("./class/garment")
api.newOutfit = require("./class/outfit")
api.newMannequin = require("./class/mannequin")

return api