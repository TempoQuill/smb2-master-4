;
; ## Level palettes
;
; Each world has several sets of background and sprite palettes, which are set per area in the level
; header. Subspace is defined separately in each world, but they all use the same colors!
;

;
; #### Palette pointers
;
WorldBackgroundPalettePointersLo:
	.db <World1BackgroundPalettes
	.db <World2BackgroundPalettes
	.db <World3BackgroundPalettes
	.db <World4BackgroundPalettes
	.db <World5BackgroundPalettes
	.db <World6BackgroundPalettes
	.db <World7BackgroundPalettes

WorldSpritePalettePointersLo:
	.db <World1SpritePalettes
	.db <World2SpritePalettes
	.db <World3SpritePalettes
	.db <World4SpritePalettes
	.db <World5SpritePalettes
	.db <World6SpritePalettes
	.db <World7SpritePalettes

WorldBackgroundPalettePointersHi:
	.db >World1BackgroundPalettes
	.db >World2BackgroundPalettes
	.db >World3BackgroundPalettes
	.db >World4BackgroundPalettes
	.db >World5BackgroundPalettes
	.db >World6BackgroundPalettes
	.db >World7BackgroundPalettes

WorldSpritePalettePointersHi:
	.db >World1SpritePalettes
	.db >World2SpritePalettes
	.db >World3SpritePalettes
	.db >World4SpritePalettes
	.db >World5SpritePalettes
	.db >World6SpritePalettes
	.db >World7SpritePalettes
