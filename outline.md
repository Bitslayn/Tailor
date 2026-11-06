# Classes

- Style
- Garment
- Accessory
- Outfit
- Mannequin

## Style

-- Allows for creating customization options, which colors xyuv regions taking in an optional color tint multiplier

```lua
local pants_style = api.newStyle()
	:addRegion("tear", vec(0, 0), vec(10, 10), vec(0, 0, 0))
	:addRegion("tear", vec(0, 0), vec(10, 10), vec(0, 0, 0))
	:addRegion("belt", vec(0, 0), vec(10, 10), vec(0, 0, 0))
```

## Garment

Stores things like the textures, and masks

```lua
local shirt = api.newGarment("shirt", "clothes")
	:addLayer(textures["shirt"])

local pants = api.newGarment("pants", "clothes")
	:addLayer(textures["pants_base"])
	:addLayer(textures["pants_accent"], pants_style)

pants:addMask("shirt", 0, 0, 10, 10)
```

## Accessory

Stores a parts that are made visible when worn.

```lua
local crown = api.newAccessory("crown")
	:addPart(collections.Accessories.Crown)
```

## Outfit

Builds outfits and applies customizations. Bakes everything into the textures

```lua
local outfit = api.newOutfit({
	crown,
	shirt,
	pants
})
```

## Mannequin

Stores the model layers to apply garments to. Only grabs the textures from the outfit and nothing else.

```lua
local mannequin = api.newMannequin()
	:addGroup("skin", collections.Skin)
	:addGroup("clothes", collections.Clothes)

mannequin:applyOutfit(outfit)
```
