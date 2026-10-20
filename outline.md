# Classes

- Garment
- Accessory
- Outfit
- Mannequin

## Garment

Stores things like the textures, and masks

```lua
local shirt = api.newGarment("shirt", "clothes")
	:addLayer(textures["shirt"])

local pants = api.newGarment("pants", "clothes")
	:addLayer(textures["pants_belt"], vec(0, 0, 0))
	:addLayer(textures["pants_base"], vec(1, 1, 1))

pants:addMask("shirt", 0, 0, 10, 10)
```

## Accessory

Stores a parts that are made visible when worn. Attaches to mannequin group parts, not collections.

```lua
local crown = api.newAccessory("crown", "head")
	:addPart(collections.Accessories.Crown, vec(0, 0, 0))
```

## Outfit

Builds outfits and enables customizations. Bakes everything into the textures

```lua
local outfit = api.newOutfit({
	crown,
	shirt,
	pants
})

outfit.shirt:setColor(vectors.hexToRGB("#ff0000"))
```

## Mannequin

Stores the model layers to apply garments to. Only grabs the textures from the outfit and nothing else.

```lua
local mannequin = api.newMannequin()
	:addGroup("head", pivots.Head)
	:addGroup("skin", collections.Skin)
	:addGroup("clothes", collections.Clothes)

mannequin:applyOutfit(outfit)
```
