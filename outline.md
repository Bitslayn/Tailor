# Classes
- Garment
- Outfit
- Mannequin

## Garment

Stores things like the textures, the masks, and the tint regions

```lua
local shirt = api.newGarment("shirt", "clothes")
	:addLayer(textures["shirt"])

local pants = api.newGarment("pants", "clothes")
	:addLayer(textures["pants_belt"], vec(0, 0, 0))
	:addLayer(textures["pants_base"], vec(1, 1, 1))

pants:addMask("shirt", 0, 0, 10, 10)
```

## Outfit

Builds outfits and enables customizations. Bakes everything into the textures

```lua
local outfit = api.newOutfit({
	shirt,
	pants
})

outfit.shirt:setColor(vectors.hexToRGB("#ff0000"))
```

## Mannequin

Stores the model layers to apply garments to. Only grabs the textures from the outfit and nothing else.

```lua
local mannequin = api.newMannequin()
	:addCollection("skin", collections.Skin, 2)
	:addCollection("clothes", collections.Clothes, 1)

mannequin:applyOutfit(outfit)
```