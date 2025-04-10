;
; ## Object creation routine selection
;
; Object types are grouped into `$10` value ranges, where the upper nybble determines which routine
; or jump table to use.
;

;
; ### Length-based object table
;
; The `$3X-$FX` range is used for objects that specify a type in the upper nybble and length in the
; lower nybble, including runs of horizontal or vertical blocks, platforms, and waterfalls.
;
CreateObjects_30thruF0:
	JSR JumpToTableAfterJump

	.dw CreateObject_HorizontalBlocks ; $3X
	.dw CreateObject_HorizontalBlocks ; $4X
	.dw CreateObject_HorizontalBlocks ; $5X
	.dw CreateObject_HorizontalBlocks ; $6X
	.dw CreateObject_HorizontalBlocks ; $7X
	.dw CreateObject_VerticalBlocks ; $8X
	.dw CreateObject_VerticalBlocks ; $9X
	.dw CreateObject_VerticalBlocks ; $AX
	.dw CreateObject_WhaleOrDrawBridgeChain ; $BX
	.dw CreateObject_JumpthroughPlatform ; $CX
	.dw CreateObject_HorizontalPlatform ; $DX
	.dw CreateObject_HorizontalPlatform ; $EX
	.dw CreateObject_WaterfallOrFrozenRocks ; $FX

;
; ### Single object tables
;
; The `$0X-$2X` range is used for various single-block and one-off objects, such a mushroom blocks,
; standable vines, doors, and vertical objects that extend all the way to the ground.
;
CreateObjects_00:
	JSR JumpToTableAfterJump

	.dw CreateObject_SingleBlock ; $00
	.dw CreateObject_SingleBlock ; $01
	.dw CreateObject_SingleBlock ; $02
	.dw CreateObject_SingleBlock ; $03
	.dw CreateObject_SingleBlock ; $04
	.dw CreateObject_SingleBlock ; $05
	.dw CreateObject_Vase ; $06
	.dw CreateObject_Vase ; $07
	.dw CreateObject_Vase ; $08
	.dw CreateObject_Door ; $09
	.dw CreateObject_Door ; $0A
	.dw CreateObject_Door ; $0B
	.dw CreateObject_Vine ; $0C
	.dw CreateObject_Vine ; $0D
	.dw CreateObject_StarBackground ; $0E
	.dw CreateObject_Pillar ; $0F

CreateObjects_10:
	LDA i50e
	JSR JumpToTableAfterJump

	.dw CreateObject_BigCloud ; $10
	.dw CreateObject_SmallCloud ; $11
	.dw CreateObject_VineBottom ; $12
	.dw CreateObject_LightEntranceRight ; $13
	.dw CreateObject_LightEntranceLeft ; $14
	.dw CreateObject_Tall ; $15
	.dw CreateObject_Tall ; $16
	.dw CreateObject_Pyramid ; $17
	.dw CreateObject_Wall ; $18
	.dw CreateObject_Wall ; $19
	.dw CreateObject_Horn ; $1A
	.dw CreateObject_DrawBridgeChain ; $1B
	.dw CreateObject_Door ; $1C
	.dw CreateObject_Door ; $1D
	.dw CreateObject_RockWallEntrance ; $1E
	.dw CreateObject_TreeBackground ; $1F

CreateObjects_20:
	JMP CreateObject_SingleObject


;
; ## World object tiles
;
; The repeating blocks in the `$3X-$AX` range are specified per world in these
; lookup tables. Each world has 4 values for each object type, which are
; selected using byte 3 of the area header.
;
; `$3X-$9X` is specified using `%......XX` in byte 3 of the header.
; `$AX` (ladder/chain) is specified using `%....XX..` in byte 3 of the header.
;

WorldObjectTilePointersLo:
	.db <World1ObjectTiles
	.db <World2ObjectTiles
	.db <World3ObjectTiles
	.db <World4ObjectTiles
	.db <World5ObjectTiles
	.db <World6ObjectTiles
	.db <World7ObjectTiles

WorldObjectTilePointersHi:
	.db >World1ObjectTiles
	.db >World2ObjectTiles
	.db >World3ObjectTiles
	.db >World4ObjectTiles
	.db >World5ObjectTiles
	.db >World6ObjectTiles
	.db >World7ObjectTiles

World1ObjectTiles:
	.db $97, $92, $12, $12 ; 3X (horizontal jump-through block)
	.db $1C, $99, $1C, $1C ; 4X (horizontal solid block)
	.db $45, $45, $45, $45 ; 5X (small veggie grass)
	.db $65, $65, $65, $65 ; 6X (bridge)
	.db $1A, $1A, $1A, $1A ; 7X (spikes)
	.db $A0, $00, $9D, $A2 ; 8X (vertical wall, eg. rock, bombable)
	.db $A0, $A0, $A0, $A0 ; 9X (vertical wall, eg. rock with angle)
	.db $80, $07, $81, $80 ; AX (ladder, chain)
	.db $81, $81, $81, $81 ; AX over background (ladder with shadow)

World2ObjectTiles:
	.db $96, $92, $93, $12 ; 3X (horizontal jump-through block)
	.db $1C, $1C, $1C, $1C ; 4X (horizontal solid block)
	.db $45, $45, $45, $45 ; 5X (small veggie grass)
	.db $65, $65, $65, $65 ; 6X (bridge)
	.db $1A, $1A, $1A, $1A ; 7X (spikes)
	.db $A0, $40, $9D, $18 ; 8X (vertical wall, eg. rock, bombable)
	.db $A0, $A0, $A0, $A0 ; 9X (vertical wall, eg. rock with angle)
	.db $80, $07, $81, $80 ; AX (ladder, chain)
	.db $81, $81, $81, $81 ; AX over background (ladder with shadow)

World3ObjectTiles:
	.db $97, $92, $12, $12 ; 3X (horizontal jump-through block)
	.db $1C, $99, $A0, $1C ; 4X (horizontal solid block)
	.db $45, $45, $45, $45 ; 5X (small veggie grass)
	.db $65, $65, $65, $65 ; 6X (bridge)
	.db $1A, $1A, $1A, $1A ; 7X (spikes)
	.db $A0, $00, $9D, $A2 ; 8X (vertical wall, eg. rock, bombable)
	.db $A0, $A0, $A0, $A0 ; 9X (vertical wall, eg. rock with angle)
	.db $80, $07, $81, $80 ; AX (ladder, chain)
	.db $81, $81, $81, $81 ; AX over background (ladder with shadow)

World4ObjectTiles:
	.db $16, $92, $16, $12 ; 3X (horizontal jump-through block)
	.db $1C, $99, $A2, $18 ; 4X (horizontal solid block)
	.db $45, $45, $45, $45 ; 5X (small veggie grass)
	.db $65, $65, $65, $65 ; 6X (bridge)
	.db $1A, $1A, $1A, $1A ; 7X (spikes)
	.db $A0, $1F, $9D, $18 ; 8X (vertical wall, eg. rock, bombable)
	.db $A0, $A0, $A0, $A0 ; 9X (vertical wall, eg. rock with angle)
	.db $80, $07, $81, $80 ; AX (ladder, chain)
	.db $81, $81, $81, $81 ; AX over background (ladder with shadow)

World5ObjectTiles:
	.db $97, $92, $12, $12 ; 3X (horizontal jump-through block)
	.db $1C, $99, $1C, $1C ; 4X (horizontal solid block)
	.db $45, $45, $45, $45 ; 5X (small veggie grass)
	.db $65, $65, $65, $65 ; 6X (bridge)
	.db $1A, $1A, $1A, $1A ; 7X (spikes)
	.db $A0, $A4, $9D, $18 ; 8X (vertical wall, eg. rock, bombable)
	.db $A0, $A0, $A0, $A0 ; 9X (vertical wall, eg. rock with angle)
	.db $80, $07, $81, $80 ; AX (ladder, chain)
	.db $81, $81, $81, $81 ; AX over background (ladder with shadow)

World6ObjectTiles:
	.db $96, $92, $93, $12 ; 3X (horizontal jump-through block)
	.db $1C, $1C, $1C, $1C ; 4X (horizontal solid block)
	.db $45, $45, $45, $45 ; 5X (small veggie grass)
	.db $65, $65, $65, $65 ; 6X (bridge)
	.db $1A, $1A, $1A, $1A ; 7X (spikes)
	.db $A0, $40, $9D, $18 ; 8X (vertical wall, eg. rock, bombable)
	.db $A0, $A0, $A0, $A0 ; 9X (vertical wall, eg. rock with angle)
	.db $80, $07, $81, $80 ; AX (ladder, chain)
	.db $81, $81, $81, $81 ; AX over background (ladder with shadow)

World7ObjectTiles:
	.db $12, $68, $12, $9D ; 3X (horizontal jump-through block)
	.db $9C, $67, $64, $69 ; 4X (horizontal solid block)
	.db $45, $45, $45, $45 ; 5X (small veggie grass)
	.db $65, $65, $65, $65 ; 6X (bridge)
	.db $1A, $1A, $1A, $1A ; 7X (spikes)
	.db $9C, $9C, $9C, $9C ; 8X (vertical wall, eg. rock, bombable)
	.db $A0, $A0, $A0, $A0 ; 9X (vertical wall, eg. rock with angle)
	.db $80, $07, $81, $80 ; AX (ladder, chain)
	.db $81, $81, $81, $81 ; AX over background (ladder with shadow)


;
; ## Object creation routines
;
; These routines are responsible for turning an object in the level data into a set of tiles that
; are applied to the raw tile buffer.
;
; Some are specific one-offs to draw a particular object, where as otherws are generic routines,
; such as drawing an _n_-tile row or column of tile _x_. Many fall somewhere in-between.
;


;
; Places a tile using the world-specific tile lookup table.
;
; ##### Input
; - `Y`: destination tile
; - `i50e`: type of object to create (upper nybble of level object minus 3)
;
;     ```
;     $00 = jumpthrough block
;     $01 = solid block
;     $02 = grass
;     $03 = bridge
;     $04 = spikes
;     $05 = vertical rock
;     $06 = vertical rock with angle
;     $07 = ladder
;     $08 = whale
;     $09 = jumpthrough platform
;     $0A = log platform
;     $0B = cloud platform
;     $0C = waterfall
;     ```
;
; ##### Output
; - `A`: tile that was written
;
CreateWorldSpecificTile:
	LDA i50e
	ASL A
	ASL A
	STA z0f
	LDA i50e
	CMP #$07
	BCC CreateWorldSpecificTile_3Xthru9X

CreateWorldSpecificTile_AXthruFX:
	LDA iSpriteTypeHi
	JMP CreateWorldSpecificTile_ApplyObjectType

CreateWorldSpecificTile_3Xthru9X:
	LDA iSpriteTypeLo

CreateWorldSpecificTile_ApplyObjectType:
	CLC
	ADC z0f
	TAX
	LDA i50e
	CMP #$03
	BNE CreateWorldSpecificTile_LookUpTile

	; bridge casts a shadow on background bricks
	LDA (z01), Y
	CMP #BackgroundTile_BackgroundBrick
	BNE CreateWorldSpecificTile_LookUpTile

	LDA #BackgroundTile_BridgeShadow
	BNE CreateWorldSpecificTile_Exit

CreateWorldSpecificTile_LookUpTile:
	STX z07
	STY z08
	LDX iCurrentWorldTileset
	LDA WorldObjectTilePointersLo, X
	STA z0c
	LDA WorldObjectTilePointersHi, X
	STA z0d
	LDY z07
	LDA (z0c), Y
	LDY z08
	LDX z07

CreateWorldSpecificTile_Exit:
	STA (z01), Y
	RTS


;
; Creates a horizontal run of blocks
;
; ##### Input
; - `i50d`: number of blocks to create
; - `ze7`: target tile placement offset
;
CreateObject_HorizontalBlocks:
	LDY ze7

CreateObject_HorizontalBlocks_Loop:
	JSR CreateWorldSpecificTile

	JSR IncrementAreaXOffset

	DEC i50d
	BPL CreateObject_HorizontalBlocks_Loop
	RTS


;
; Creates a light entrance with the trail facing right
;
; World 6 has some extra logic to make the entrance extend down to the floor.
;
; ##### Input
; - `ze7`: target tile placement offset
;
CreateObject_LightEntranceRight:
	LDA iCurrentWorldTileset
	CMP #$05
	BNE CreateObject_LightEntranceRight_NotWorld6

	JMP CreateObject_LightEntranceRight_World6

CreateObject_LightEntranceRight_NotWorld6:
	LDY ze7
	LDA #BackgroundTile_LightDoor
	STA (z01), Y
	INY
	LDA #BackgroundTile_LightTrailRight
	STA (z01), Y
	LDA ze7
	CLC
	ADC #$10
	TAY
	LDA #BackgroundTile_LightDoor
	STA (z01), Y
	INY
	LDA #BackgroundTile_LightTrail
	STA (z01), Y
	INY
	LDA #BackgroundTile_LightTrailRight
	STA (z01), Y

	LDA iCurrentWorld
	CMP #$05
	BEQ CreateObject_LightEntranceRight_World6or7Exit

	LDA iCurrentWorld
	CMP #$06
	BEQ CreateObject_LightEntranceRight_World6or7Exit

	JSR LevelParser_EatDoorPointer

CreateObject_LightEntranceRight_World6or7Exit:
	RTS

CreateObject_LightEntranceRight_World6:
	LDY ze7
	LDA #$00
	STA z08

CreateObject_LightEntranceRight_World6Loop:
	LDA (z01), Y
	CMP #BackgroundTile_Sky
	BNE CreateObject_LightEntranceRight_World6_Exit

	LDA #BackgroundTile_LightDoor
	STA (z01), Y
	LDA z08
	TAX

CreateObject_LightEntranceRight_World6InnerLoop:
	CPX #$00
	BEQ CreateObject_LightEntranceRight_World6_TrailRight

	INY
	LDA #BackgroundTile_LightTrail
	STA (z01), Y
	DEX
	JMP CreateObject_LightEntranceRight_World6InnerLoop

CreateObject_LightEntranceRight_World6_TrailRight:
	INY
	LDA #BackgroundTile_LightTrailRight
	STA (z01), Y
	INC z08
	LDY ze7
	TYA
	CLC
	ADC #$10
	TAY
	STA ze7
	JMP CreateObject_LightEntranceRight_World6Loop

CreateObject_LightEntranceRight_World6_Exit:
	RTS


;
; Creates a light entrance with the trail facing left
;
; ##### Input
; - `ze7`: target tile placement offset
;
CreateObject_LightEntranceLeft:
	LDY ze7
	LDA #BackgroundTile_LightDoor
	STA (z01), Y
	DEY
	LDA #BackgroundTile_LightTrailLeft
	STA (z01), Y
	LDY ze7
	TYA
	CLC
	ADC #$10
	TAY
	LDA #BackgroundTile_LightDoor
	STA (z01), Y
	DEY
	LDA #BackgroundTile_LightTrail
	STA (z01), Y
	DEY
	LDA #BackgroundTile_LightTrailLeft
	STA (z01), Y

	LDA iCurrentWorld
	CMP #$05
	BEQ CreateObject_LightEntranceLeft_World6or7Exit

	LDA iCurrentWorld
	CMP #$06
	BEQ CreateObject_LightEntranceLeft_World6or7Exit

	JSR LevelParser_EatDoorPointer

CreateObject_LightEntranceLeft_World6or7Exit:
	RTS


;
; Creates a vertical run of blocks.
;
; ##### Input
; - `i50d`: number of blocks to create
; - `i50e`: type of object to create (upper nybble of level object minus 3)
;
;     ```
;     $00 = jumpthrough block
;     $01 = solid block
;     $02 = grass
;     $03 = bridge
;     $04 = spikes
;     $05 = vertical rock
;     $06 = vertical rock with angle
;     $07 = ladder
;     $08 = whale
;     $09 = jumpthrough platform
;     $0A = log platform
;     $0B = cloud platform
;     $0C = waterfall
;     ```
; - `ze7`: target tile placement offset
;
CreateObject_VerticalBlocks:
	LDY ze7

	LDA i50e
	CMP #$06
	BNE CreateObject_VerticalBlocks_NotClawGrip

	LDA iCurrentLvl
	CMP #$0E
	BNE CreateObject_VerticalBlocks_NotClawGrip

	LDA iCurrentLvlArea
	CMP #$05
	BNE CreateObject_VerticalBlocks_NotClawGrip

CreateObject_VerticalBlocks_ClawGripRockLoop:
	LDA #BackgroundTile_ClawGripRock
	STA (z01), Y
	JSR IncrementAreaYOffset

	DEC i50d
	BPL CreateObject_VerticalBlocks_ClawGripRockLoop
	RTS

CreateObject_VerticalBlocks_NotClawGrip:
	LDA i50e
	CMP #$06
	BNE CreateObject_VerticalBlocks_Normal

	LDA #BackgroundTile_RockWallAngle
	STA (z01), Y
	JMP CreateObject_VerticalBlocks_NextRow

CreateObject_VerticalBlocks_Normal:
	JSR CreateWorldSpecificTile

CreateObject_VerticalBlocks_NextRow:
	JSR IncrementAreaYOffset

	DEC i50d
	BPL CreateObject_VerticalBlocks_Normal
	RTS


;
; Lookup tables for single blocks
;
; Each the lower nybble of the object type is used as the offset, except for the
; standable ladder, which is described in the subroutine below.
;
World1thru6SingleBlocks:
	.db BackgroundTile_MushroomBlock
	.db BackgroundTile_POWBlock
	.db BackgroundTile_BombableBrick
	.db BackgroundTile_VineStandable
	.db BackgroundTile_JarSmall
	.db BackgroundTile_LadderStandable
	.db BackgroundTile_LadderStandableShadow

World7SingleBlocks:
	.db BackgroundTile_MushroomBlock
	.db BackgroundTile_POWBlock
	.db BackgroundTile_BombableBrick
	.db BackgroundTile_ChainStandable
	.db BackgroundTile_JarSmall
	.db BackgroundTile_LadderStandable
	.db BackgroundTile_LadderStandableShadow


;
; Creates a single block
;
; ##### Input
; - `i50e`: object type to use as an offset in the lookup table
;
CreateObject_SingleBlock:
	LDA i50e
	TAX

;
; Object `$05` is a single ladder tile that the player can stand on.
;
; When `iSpriteTypeHi` is set, it is given a shadow. This works by
; incrementing the offset by one so that object `$05` ends up using offset `$06`
; in the lookup table!
;
	CMP #$05
	BNE CreateObject_SingleBlock_NotLadderStandable

	LDA iSpriteTypeHi
	BEQ CreateObject_SingleBlock_NotLadderStandable

	INX

CreateObject_SingleBlock_NotLadderStandable:
	LDY ze7
	; World 7 gets its own lookup table for climbable chains instead of vines
	LDA iCurrentWorldTileset
	CMP #$06
	BNE CreateObject_SingleBlock_NotWorld7

CreateObject_SingleBlock_World7:
	LDA World7SingleBlocks, X
	JMP CreateObject_SingleBlock_Exit

CreateObject_SingleBlock_NotWorld7:
	LDA World1thru6SingleBlocks, X

CreateObject_SingleBlock_Exit:
	STA (z01), Y
	RTS


;
; Horizontal platform lookup tables. Choose between logs and clouds.
;
HorizontalPlatformLeftTiles:
	.db BackgroundTile_LogLeft
	.db BackgroundTile_CloudLeft
HorizontalPlatformMiddleTiles:
	.db BackgroundTile_LogMiddle
	.db BackgroundTile_CloudMiddle
HorizontalPlatformRightTiles:
	.db BackgroundTile_LogRight
	.db BackgroundTile_CloudRight

;
; Creates a horizontal platform with special tiles for the endcaps.
;
; The log platforms and jump-through cloud platforms both use this.
;
CreateObject_HorizontalPlatform:
	LDA iCurrentWorldTileset
	CMP #$04
	BNE CreateObject_HorizontalPlatform_NotWorld5

	; In World 5, we want to do some special stuff to make the logs look like
	; branches coming out of the tree trunk background.
	JMP CreateObject_HorizontalPlatform_World5

CreateObject_HorizontalPlatform_NotWorld5:
	LDY ze7
	LDA i50e
	SEC
	SBC #$0A
	TAX
	LDA HorizontalPlatformLeftTiles, X
	STA (z01), Y
	DEC i50d
	BEQ CreateObject_HorizontalPlatform_Exit

CreateObject_HorizontalPlatform_Loop:
	JSR IncrementAreaXOffset

	LDA HorizontalPlatformMiddleTiles, X
	STA (z01), Y
	DEC i50d
	BNE CreateObject_HorizontalPlatform_Loop

CreateObject_HorizontalPlatform_Exit:
	JSR IncrementAreaXOffset

	LDA HorizontalPlatformRightTiles, X
	STA (z01), Y
	RTS


;
; Lookup table for the big green platforms.
;
GreenPlatformTiles:
	.db BackgroundTile_GreenPlatformTopLeft
	.db BackgroundTile_GreenPlatformTop
	.db BackgroundTile_GreenPlatformTopRight
	.db BackgroundTile_GreenPlatformLeft
	.db BackgroundTile_GreenPlatformMiddle
	.db BackgroundTile_GreenPlatformRight

; These are the background tiles that the green platforms are allowed to overwrite.
; Any other tiles will stop the green platform from extending to the bottom of the page.
GreenPlatformOverwriteTiles:
	.db BackgroundTile_Sky
	.db BackgroundTile_WaterfallTop
	.db BackgroundTile_Waterfall
GreenPlatformTiles_End:


;
; Draws the typical green hill platforms in Worlds 1 through 6 or the mushroom
; house platforms in World 7.
;
CreateObject_JumpthroughPlatform:
	LDA iCurrentWorldTileset
	CMP #$06
	BNE CreateObject_GreenJumpthroughPlatform

	JMP CreateObject_MushroomJumpthroughPlatform

;
; #### Green platforms
;
; Creates the typical (usually) green hill platforms used throughout World 1 through 6.
;
; These platforms are allowed to overlap each other, but typically appear behind other tiles that
; are already present in the area.
;
; ##### Input
; - `ze7`: target tile placement offset
; - `ze8`: area page
; - `i50d`: width of platform
;
CreateObject_GreenJumpthroughPlatform:
	; Start with a top-left tile.
	LDX #$00

CreateObject_GreenJumpthroughPlatform_Row:
	STX z0b
	; Update the area page.
	LDX ze8
	JSR SetAreaPageAddr_Bank6

	; These two lines seem like leftovers.
	LDX #$05
	LDY ze7

	; Draw a left corner or side.
	LDX z0b
	LDY ze7
	LDA i50d
	STA z07
	JSR CreateObject_GreenJumpthroughPlatformTile

	; Skip to the right side if we're drawing a short platform.
	INX
	LDA z07
	BEQ CreateObject_GreenJumpthroughPlatform_Right

	; Draw top or middle tiles.
CreateObject_GreenJumpthroughPlatform_Loop:
	JSR IncrementAreaXOffset

	JSR CreateObject_GreenJumpthroughPlatformTile

	BNE CreateObject_GreenJumpthroughPlatform_Loop

	; Draw right corner or side.
CreateObject_GreenJumpthroughPlatform_Right:
	JSR IncrementAreaXOffset

	INX
	JSR CreateObject_GreenJumpthroughPlatformTile

	; Exit if we've hit the bottom of the page.
	LDA ze7
	CLC
	ADC #$10
	CMP #$F0
	BCS CreateObject_GreenJumpthroughPlatform_Exit

	; Drawing a left side tile next.
	LDX #$03
	STA ze7
	JMP CreateObject_GreenJumpthroughPlatform_Row

CreateObject_GreenJumpthroughPlatform_Exit:
	RTS


;
; Lookup table for green platform overlap tiles.
;
; When drawing the top of a green platform, if the destination tile matches the compare tile, the
; corresponding left or right overlap tile will be drawn instead.
;
GreenPlatformOverlapCompareTiles:
	.db BackgroundTile_GreenPlatformLeft
	.db BackgroundTile_GreenPlatformMiddle
	.db BackgroundTile_GreenPlatformRight

GreenPlatformOverlapLeftTiles:
	.db BackgroundTile_GreenPlatformTopLeftOverlapEdge
	.db BackgroundTile_GreenPlatformTopLeftOverlap
	.db BackgroundTile_GreenPlatformTopLeftOverlap

GreenPlatformOverlapRightTiles:
	.db BackgroundTile_GreenPlatformTopRightOverlap
	.db BackgroundTile_GreenPlatformTopRightOverlap
	.db BackgroundTile_GreenPlatformTopRightOverlapEdge


;
; Draws a single tile of the green platform, taking into account the existing tile at the target.
;
; ##### Input
; - `X`: offset in `GreenPlatformTiles` table (0-2=top, 3-5=middle)
; - `Y`: raw data offset
;
CreateObject_GreenJumpthroughPlatformTile:
	STX z08
	TXA
	BNE CreateObject_GreenJumpthroughPlatformTile_NotTopLeft

	; Check if the top left corner requires a special tile
	LDX #(GreenPlatformOverlapLeftTiles - GreenPlatformOverlapCompareTiles - 1)
	LDA (z01), Y

CreateObject_GreenJumpthroughPlatformTile_TopLeftLoop:
	CMP GreenPlatformOverlapCompareTiles, X
	BEQ CreateObject_GreenJumpthroughPlatformTile_TopLeftMatch

	DEX
	BPL CreateObject_GreenJumpthroughPlatformTile_TopLeftLoop

	BMI CreateObject_GreenJumpthroughPlatformTile_CheckOverwrite

CreateObject_GreenJumpthroughPlatformTile_TopLeftMatch:
	LDA GreenPlatformOverlapLeftTiles, X
	BNE CreateObject_GreenJumpthroughPlatformTile_SetTile

CreateObject_GreenJumpthroughPlatformTile_NotTopLeft:
	LDX z08
	CPX #$02
	BNE CreateObject_GreenJumpthroughPlatformTile_CheckOverwrite

	; Check if the top right corner requires a special tile
	LDX #(GreenPlatformOverlapLeftTiles - GreenPlatformOverlapCompareTiles - 1)
	LDA (z01), Y

CreateObject_GreenJumpthroughPlatformTile_TopRightLoop:
	CMP GreenPlatformOverlapCompareTiles, X
	BEQ CreateObject_GreenJumpthroughPlatformTile_TopRightMatch

	DEX
	BPL CreateObject_GreenJumpthroughPlatformTile_TopRightLoop

	BMI CreateObject_GreenJumpthroughPlatformTile_CheckOverwrite

CreateObject_GreenJumpthroughPlatformTile_TopRightMatch:
	LDA GreenPlatformOverlapRightTiles, X
	BNE CreateObject_GreenJumpthroughPlatformTile_SetTile

	; Check if the target tile can be overwritten by a green platform
CreateObject_GreenJumpthroughPlatformTile_CheckOverwrite:
	LDX #(GreenPlatformTiles_End - GreenPlatformTiles - 1)

CreateObject_GreenJumpthroughPlatformTile_CheckOverwriteLoop:
	LDA (z01), Y
	CMP GreenPlatformTiles, X
	BEQ CreateObject_GreenJumpthroughPlatformTile_Overwrite

	DEX
	BPL CreateObject_GreenJumpthroughPlatformTile_CheckOverwriteLoop

	; Otherwise, we cannot overwrite this tile with a green platform.
	LDX z08
	JMP CreateObject_GreenJumpthroughPlatformTile_Exit

CreateObject_GreenJumpthroughPlatformTile_Overwrite:
	LDX z08
	LDA GreenPlatformTiles, X

CreateObject_GreenJumpthroughPlatformTile_SetTile:
	STA (z01), Y

CreateObject_GreenJumpthroughPlatformTile_Exit:
	LDX z08
	DEC z07
	RTS

; -----


;
; Lookup table for tall objects that extend to the ground.
;
TallObjectTopTiles:
	.db BackgroundTile_LightDoor
	.db BackgroundTile_PalmTreeTop

TallObjectBottomTiles:
	.db BackgroundTile_LightDoor
	.db BackgroundTile_PalmTreeTrunk


;
; #### Tall objects
;
; ##### Input
; - `ze7`: target tile placement offset
; - `i50e`: type of object to create (lower nybble of level object minus 5)
;
; Creates a tree or light door object that extends down until it hits another tile.
;
CreateObject_Tall:
	LDA iCurrentWorldTileset
	CMP #$04
	BNE CreateObject_Tall_NotWorld5
	JMP CreateObject_Tall_World5

CreateObject_Tall_NotWorld5:
	LDA i50e
	SEC
	SBC #$05
	STA z07
	TAX
	LDY ze7
	LDA TallObjectTopTiles, X
	STA (z01), Y

CreateObject_Tall_NotWorld5_Loop:
	JSR IncrementAreaYOffset

	LDA (z01), Y
	CMP #BackgroundTile_Sky
	BNE CreateObject_Tall_NotWorld5_Exit

	LDX z07
	LDA TallObjectBottomTiles, X
	STA (z01), Y
	BNE CreateObject_Tall_NotWorld5_Loop

CreateObject_Tall_NotWorld5_Exit:
	RTS


;
; Lookup table for tall objects that extend to the ground in World 5.
;
World5TallObjectTopTiles:
	.db BackgroundTile_PalmTreeTop
	.db BackgroundTile_PalmTreeTop

World5TallObjectBottomTiles:
	.db BackgroundTile_PalmTreeTrunk
	.db BackgroundTile_PalmTreeTrunk


;
; ##### Tall objects (World 5)
;
; Other than the fact that this only renders palm trees and not doors, the only practical difference
; in this subroutine is that it will stop at the bottom of the screen if it doesn't encounter
; another tile beforehand.
;
; This appears to be a work-around for the palm trees in 5-2 that have vertical
; rock platforms beneath them. Since the rock comes later, tree trunk tiles would
; render all the way down to the screen and through to the next page!
;
; Using a new object layer would have achieved the same effect, but the
; developer decided to create this special case instead.
;
CreateObject_Tall_World5:
	LDX #$00
	LDA i50e
	CMP #$05
	BEQ CreateObject_Tall_World5_DoLookup

	INX

CreateObject_Tall_World5_DoLookup:
	STX z07
	LDY ze7
	LDA World5TallObjectTopTiles, X
	STA (z01), Y

CreateObject_Tall_World5_Loop:
	JSR IncrementAreaYOffset

	LDA (z01), Y
	CMP #BackgroundTile_Sky
	BNE CreateObject_Tall_World5_Exit

	LDX z07
	LDA World5TallObjectBottomTiles, X
	STA (z01), Y
	CPY #$E0
	BCC CreateObject_Tall_World5_Loop

CreateObject_Tall_World5_Exit:
	RTS

; -----

;
; Creates the larger, two-tile-wide big cloud.
;
CreateObject_BigCloud:
	LDY ze7
	LDA #BackgroundTile_BgCloudLeft
	STA (z01), Y
	INY
	LDA #BackgroundTile_BgCloudRight
	STA (z01), Y
	RTS

; -----


;
; Creates a tiny, single-tile cloud.
;
CreateObject_SmallCloud:
	LDY ze7
	LDA #BackgroundTile_BgCloudSmall
	STA (z01), Y
	RTS

; -----


JarTopTiles:
	.db BackgroundTile_JarTopPointer
	.db BackgroundTile_JarTopGeneric
	.db BackgroundTile_JarTopNonEnterable


CreateObject_Vase:
	LDY ze7
	LDA i50e
	SEC
	SBC #$06
	TAX
	LDA JarTopTiles, X
	STA (z01), Y

CreateObject_Vase_Loop:
	JSR IncrementAreaYOffset

	LDA (z01), Y
	CMP #BackgroundTile_Sky
	BNE CreateObject_Vase_Exit

	LDA #BackgroundTile_JarMiddle
	STA (z01), Y
	JMP CreateObject_Vase_Loop

CreateObject_Vase_Exit:
	TYA
	SEC
	SBC #$10
	TAY
	LDA #BackgroundTile_JarBottom
	STA (z01), Y
	RTS


;
; Creates a vine that extends downwards until it hits another tile.
;
; ##### Input
; - `ze7`: target tile placement offset
; - `i50e`: type of object to create
;
CreateObject_Vine:
	LDY ze7
	LDA i50e
	; `$0D` is a vine with no top, so start right at the middle.
	CMP #$0D
	BEQ CreateObject_Vine_Middle

	LDA #BackgroundTile_VineTop
	STA (z01), Y

CreateObject_Vine_Loop:
	JSR IncrementAreaYOffset

CreateObject_Vine_Middle:
	LDA (z01), Y
	CMP #BackgroundTile_Sky
	BNE CreateObject_Vine_Exit

	LDA #BackgroundTile_Vine
	STA (z01), Y
	LDA zScrollCondition
	BEQ CreateObject_Vine_Next

	; In horizontal areas, stop at the bottom of the screen.
	CPY #$E0
	BCS CreateObject_Vine_Exit

CreateObject_Vine_Next:
	JMP CreateObject_Vine_Loop

CreateObject_Vine_Exit:
	RTS

; -----


;
; Creates a vine that extends upwards until it hits another tile.
;
; ##### Input
; - `ze7`: target tile placement offset for the BOTTOM of the vine
;
CreateObject_VineBottom:
	LDY ze7
	LDA #BackgroundTile_VineBottom
	STA (z01), Y

CreateObject_VineBottom_Loop:
	; Stop at the top of the page.
	TYA
	SEC
	SBC #$10
	TAY
	CMP #$F0
	BCS CreateObject_VineBottom_Exit

	; Stop if we hit tile that isn't blank.
	LDA (z01), Y
	CMP #BackgroundTile_Sky
	BNE CreateObject_VineBottom_Exit

	; Draw a section of the vine
	LDA #BackgroundTile_Vine
	STA (z01), Y
	JMP CreateObject_VineBottom_Loop

CreateObject_VineBottom_Exit:
	RTS


;
; Lookup table for single object tiles.
;
SingleObjects:
	.db BackgroundTile_GrassCoin ; $20
	.db BackgroundTile_GrassLargeVeggie ; $21
	.db BackgroundTile_GrassSmallVeggie ; $22
	.db BackgroundTile_GrassRocket ; $23
	.db BackgroundTile_GrassShell ; $24
	.db BackgroundTile_GrassBomb ; $25
	.db BackgroundTile_GrassPotion ; $26
	.db BackgroundTile_Grass1UP ; $27
	.db BackgroundTile_GrassPow ; $28
	.db BackgroundTile_Cherry ; $29
	.db BackgroundTile_GrassBobOmb ; $2A
	.db BackgroundTile_SubspaceMushroom1 ; $2B
	.db BackgroundTile_Phanto ; $2C
	.db BackgroundTile_SubspaceMushroom2 ; $2D
	.db BackgroundTile_WhaleEye ; $2E
	; No entry for $2F in this table, so it uses tile $A4 due to the LDY below

;
; Creates a single tile object using the lookup table above.
;
; ##### Input
; - `ze7`: target tile placement offset
; - `i50e`: type of object to create
;
CreateObject_SingleObject:
	LDY ze7
	LDX i50e
	LDA SingleObjects, X
	STA (z01), Y
	RTS

; -----


World1thru6BrickWallTiles:
	.db BackgroundTile_BackgroundBrick
	.db BackgroundTile_SolidBrick2Wall

World7BrickWallTiles:
	.db BackgroundTile_GroundBrick2
	.db BackgroundTile_GroundBrick2


CreateObject_Wall:
	LDA i50e
	SEC
	SBC #$08
	STA z08
	LDY ze7
	LDX ze8
	JSR SetAreaPageAddr_Bank6

	LDY ze7
	LDA #$05
	STA z07
	LDA (z01), Y
	CMP #BackgroundTile_Sky
	BNE CreateObject_Wall_Exit

loc_BANK6_8D69:
	LDX z08
	LDA iCurrentWorldTileset
	CMP #$06
	BNE loc_BANK6_8D78

	LDA World7BrickWallTiles, X
	JMP loc_BANK6_8D7B

loc_BANK6_8D78:
	LDA World1thru6BrickWallTiles, X

loc_BANK6_8D7B:
	STA (z01), Y
	JSR IncrementAreaXOffset

	DEC z07
	BPL loc_BANK6_8D69

	LDA ze7
	CLC
	ADC #$10
	CMP #$F0
	BCS CreateObject_Wall_Exit

	STA ze7
	JMP CreateObject_Wall

CreateObject_Wall_Exit:
	RTS


WaterfallTiles:
	.db BackgroundTile_WaterfallTop
	.db BackgroundTile_Waterfall


CreateObject_WaterfallOrFrozenRocks:
	LDA iCurrentWorldTileset
	CMP #$03
	BNE CreateObject_Waterfall

	JMP CreateObject_FrozenRocks

CreateObject_Waterfall:
	LDA #$00
	STA z08

CreateObject_Waterfall_OuterLoop:
	LDY ze7
	LDX ze8
	JSR SetAreaPageAddr_Bank6

	LDY ze7
	LDA i50d
	STA z07
	LDX z08

CreateObject_Waterfall_InnerLoop:
	LDA WaterfallTiles, X
	STA (z01), Y
	JSR IncrementAreaXOffset

	DEC z07
	BPL CreateObject_Waterfall_InnerLoop

	LDA #$01
	STA z08
	LDA ze7
	CLC
	ADC #$10
	CMP #$F0
	BCS CreateObject_Waterfall_Exit

	STA ze7
	JMP CreateObject_Waterfall_OuterLoop

CreateObject_Waterfall_Exit:
	RTS

CreateObject_Pyramid:
	LDY ze7
	LDA #$00
	STA z08

loc_BANK6_8DD8:
	LDA (z01), Y
	CMP #BackgroundTile_Sky
	BEQ loc_BANK6_8DDF
	RTS

; ---------------------------------------------------------------------------

loc_BANK6_8DDF:
	LDA #BackgroundTile_PyramidLeftAngle
	STA (z01), Y
	LDX z08
	BEQ loc_BANK6_8DF9

loc_BANK6_8DE7:
	INY
	LDA #BackgroundTile_PyramidLeft
	STA (z01), Y
	DEX
	BNE loc_BANK6_8DE7

	LDX z08

loc_BANK6_8DF1:
	INY
	LDA #BackgroundTile_PyramidRight
	STA (z01), Y
	DEX
	BNE loc_BANK6_8DF1

loc_BANK6_8DF9:
	INY
	LDA #BackgroundTile_PyramidRightAngle
	STA (z01), Y
	INC z08
	LDA ze7
	CLC
	ADC #$10
	STA ze7
	SEC
	SBC z08
	TAY
	JMP loc_BANK6_8DD8

; Not referenced, maybe unused...?
	LDY ze7
	LDA #BackgroundTile_CactusTop
	STA (z01), Y

loc_BANK6_8E14:
	JSR IncrementAreaYOffset

	LDA (z01), Y
	CMP #BackgroundTile_Sky
	BEQ loc_BANK6_8E1E
	RTS

; ---------------------------------------------------------------------------

loc_BANK6_8E1E:
	LDA #BackgroundTile_CactusMiddle
	STA (z01), Y
	BNE loc_BANK6_8E14

; =============== S U B R O U T I N E =======================================

sub_BANK6_8E24:
	LDA z09
	ASL A
	ASL A
	SEC
	ADC z09
	STA z09
	ASL z0a
	LDA #$20
	BIT z0a
	BCS loc_BANK6_8E39

	BNE loc_BANK6_8E3B

	BEQ loc_BANK6_8E3D

loc_BANK6_8E39:
	BNE loc_BANK6_8E3D

loc_BANK6_8E3B:
	INC z0a

loc_BANK6_8E3D:
	LDA z0a
	EOR z09
	RTS

; End of function sub_BANK6_8E24

StarBackgroundTiles:
	.db BackgroundTile_Sky
	.db BackgroundTile_StarBg1
	.db BackgroundTile_Sky
	.db BackgroundTile_Sky
	.db BackgroundTile_Sky
	.db BackgroundTile_Sky
	.db BackgroundTile_StarBg2
	.db BackgroundTile_Sky

CreateObject_StarBackground:
	LDA ze8
	STA z0d
	LDA #$80
	STA z0a
	LDA #$31
	STA z09

CreateObject_StarBackground_Loop:
	JSR sub_BANK6_8E24

	AND #$07
	TAX
	LDA StarBackgroundTiles, X
	STA (z01), Y
	JSR IncrementAreaYOffset

	CPY #$30
	BCC CreateObject_StarBackground_Loop

	TYA
	AND #$0F
	TAY
	JSR IncrementAreaXOffset

	LDA z0d
	STA ze8
	CMP #$A
	BNE CreateObject_StarBackground_Loop

	LDA #$00
	STA ze8
	STA ze6
	STA ze5
	RTS


;
; Lookup table for whale tiles.
;
; It's unclear why there are entries for black background tiles and jumpthrough
; cloud platforms, but the mushroom houses table also has this.
;
WhaleLeftTiles:
	.db BackgroundTile_Black
	.db BackgroundTile_CloudLeft
	.db BackgroundTile_WhaleTopLeft
	.db BackgroundTile_Whale
	.db BackgroundTile_WaterWhale

WhaleMiddleTiles:
	.db BackgroundTile_Black
	.db BackgroundTile_CloudMiddle
	.db BackgroundTile_WhaleTop
	.db BackgroundTile_Whale
	.db BackgroundTile_WaterWhale

WhaleRightTiles:
	.db BackgroundTile_Black
	.db BackgroundTile_CloudRight
	.db BackgroundTile_WhaleTopRight
	.db BackgroundTile_Whale
	.db BackgroundTile_WaterWhale


;
; Draws a row of the whale
;
; ##### Input
; - `ze7`: target tile placement offset
; - `i50d`: width of house
; - `i50e`: offset in the tile lookup table plus `$0A`, for some reason
;
CreateObject_WhaleRow:
	LDY ze7
	LDA i50e
	SEC
	SBC #$0A
	TAX
	LDA WhaleLeftTiles, X
	STA (z01), Y
	DEC i50d
	BEQ CreateObject_WhaleRow_Right

CreateObject_WhaleRow_Loop:
	JSR IncrementAreaXOffset

	LDA WhaleMiddleTiles, X
	STA (z01), Y
	DEC i50d
	BNE CreateObject_WhaleRow_Loop

CreateObject_WhaleRow_Right:
	JSR IncrementAreaXOffset

	LDA WhaleRightTiles, X
	STA (z01), Y
	RTS


CreateObject_WhaleOrDrawBridgeChain:
	LDA iCurrentWorldTileset
	CMP #$06
	BNE CreateObject_Whale

	JMP CreateObject_DrawBridgeChain

;
; Draws a whale.
;
; ##### Input
; - `i50d`: width of whale
;
CreateObject_Whale:
	LDA i50d
	STA z07
	LDA #$0C
	STA i50e
	JSR CreateObject_WhaleRow

	INC i50e

CreateObject_Whale_Loop:
	LDA z07
	STA i50d
	LDA ze7
	CLC
	ADC #$10
	STA ze7
	CMP #$B0
	; This branch doesn't actually skip anything...
	BCC CreateObject_Whale_AboveWater

CreateObject_Whale_AboveWater:
	LDX ze8
	JSR SetAreaPageAddr_Bank6

	JSR CreateObject_WhaleRow

	; Check to see if we're at the fixed row above the water.
	TYA
	AND #$F0
	CMP #$B0
	BNE CreateObject_Whale_NotTail

	; Draw the whale tail two tiles away.
	JSR IncrementAreaXOffset
	JSR IncrementAreaXOffset

	LDA #BackgroundTile_WhaleTail
	STA (z01), Y
	INC i50e
	JMP CreateObject_Whale_Loop

CreateObject_Whale_NotTail:
	LDA i50e
	CMP #$0E
	BNE CreateObject_Whale_Loop

	JSR IncrementAreaXOffset
	JSR IncrementAreaXOffset

	LDA #BackgroundTile_WaterWhaleTail
	STA (z01), Y
	RTS


;
; Lookup table for frozen rocks over water tiles.
;
FrozenRockTiles:
	.db BackgroundTile_WaterWhale
	.db BackgroundTile_FrozenRock


CreateObject_FrozenRocks:
	LDA #$01
	STA z08

loc_BANK6_8F19:
	LDY ze7
	LDX ze8
	JSR SetAreaPageAddr_Bank6

	LDY ze7
	LDA i50d
	STA z07
	LDX z08

loc_BANK6_8F29:
	LDA FrozenRockTiles, X
	STA (z01), Y
	JSR IncrementAreaXOffset

	DEC z07
	BPL loc_BANK6_8F29

	LDA z08
	BNE loc_BANK6_8F3A
	RTS

; ---------------------------------------------------------------------------

loc_BANK6_8F3A:
	LDA ze7
	CLC
	ADC #$10
	CMP #$C0
	BCC loc_BANK6_8F45

	DEC z08

loc_BANK6_8F45:
	STA ze7
	JMP loc_BANK6_8F19

;
; Horizontal platform lookup tables for World 5.
;
; Unlike HorizontalPlatform(Left/Middle/Right)Tiles, these support overlap with
; the red tree background.
;
HorizontalPlatformWithOverlapLeftTiles:
	.db BackgroundTile_LogLeft
	.db BackgroundTile_CloudLeft
	.db BackgroundTile_LogMiddle
HorizontalPlatformWithOverlapMiddleTiles:
	.db BackgroundTile_LogMiddle
	.db BackgroundTile_CloudMiddle
HorizontalPlatformWithOverlapRightTiles:
	.db BackgroundTile_LogRight
	.db BackgroundTile_CloudRight
	.db BackgroundTile_LogRightTree

;
; Creates a horizontal platform with special tiles for the endcaps.
;
; The endcaps use alternate tiles when they overlap a non-sky tile, which is how
; the game achieves the effect of a tree with branches in World 5.
;
; Amusingly, since cloud platforms also use this subroutine, their endcaps will
; turn into logs if they overlap another object.
;
CreateObject_HorizontalPlatform_World5:
	LDY ze7
	LDA i50e
	SEC
	SBC #$0A
	TAX
	JSR CreateObject_HorizontalPlatform_World5CheckOverlap

	LDA HorizontalPlatformWithOverlapLeftTiles, X
	STA (z01), Y
	LDX z07
	DEC i50d
	BEQ CreateObject_HorizontalPlatform_World5_Exit

CreateObject_HorizontalPlatform_World5_Loop:
	JSR IncrementAreaXOffset

	LDA HorizontalPlatformWithOverlapMiddleTiles, X
	STA (z01), Y
	DEC i50d
	BNE CreateObject_HorizontalPlatform_World5_Loop

CreateObject_HorizontalPlatform_World5_Exit:
	JSR IncrementAreaXOffset

	JSR CreateObject_HorizontalPlatform_World5CheckOverlap

	LDA HorizontalPlatformWithOverlapRightTiles, X
	STA (z01), Y
	RTS


;
; Check if the next platform tile overlaps the background
;
; ##### Output
; - `X`: table offset for (2 if there is an overlap)
;
CreateObject_HorizontalPlatform_World5CheckOverlap:
	STX z07
	LDA (z01), Y
	CMP #BackgroundTile_Sky
	BEQ CreateObject_HorizontalPlatform_World5CheckOverlap_Exit

	; otherwise, the platform is overlapping the background, so we need a special tile
	LDX #$02

CreateObject_HorizontalPlatform_World5CheckOverlap_Exit:
	RTS


;
; Lookup table for tree background tiles
;
TreeBackgroundTiles:
	.db BackgroundTile_TreeBackgroundRight
	.db BackgroundTile_TreeBackgroundMiddleLeft
	.db BackgroundTile_TreeBackgroundLeft


;
; Creates a tree background
;
; ##### Input
; - `ze7`: target tile placement offset
; - `ze8`: area page
;
CreateObject_TreeBackground:
	; width of the middle of the tree (0 = two tiles, 4 = ten tiles)
	LDA #$04
	STA z07
	LDY ze7
	LDX ze8
	JSR SetAreaPageAddr_Bank6

	LDX #$02

	; Stop when it touches the ground
	LDA (z01), Y
	CMP #BackgroundTile_Sky
	BNE CreateObject_TreeBackground_Exit

CreateObject_TreeBackground_Loop:
	; Draw the left side of the tree
	LDA TreeBackgroundTiles, X
	STA (z01), Y
	JSR IncrementAreaXOffset

	; Draw the middle of the tree
	DEX
	CPX #$01
	BNE CreateObject_TreeBackground_Right

	JSR CreateObject_TreeBackground_MiddleLoop

CreateObject_TreeBackground_Right:
	; Draw the right side of the tree
	DEX
	BPL CreateObject_TreeBackground_Loop

	; Try to draw the next row
	LDY ze7
	JSR IncrementAreaYOffset

	STY ze7
	JMP CreateObject_TreeBackground

CreateObject_TreeBackground_Exit:
	RTS


;
; Loops through and creates n+1 pairs of tiles for the middle of the tree.
;
CreateObject_TreeBackground_MiddleLoop:
	LDA #BackgroundTile_TreeBackgroundMiddleLeft
	STA (z01), Y
	JSR IncrementAreaXOffset

	LDA #BackgroundTile_TreeBackgroundMiddleRight
	STA (z01), Y
	JSR IncrementAreaXOffset

	DEC z07
	BPL CreateObject_TreeBackground_MiddleLoop
	RTS


; Unreferenced?
SomeUnusedTilesTop:
	.db BackgroundTile_LightDoor
	.db BackgroundTile_CactusTop
	.db BackgroundTile_PalmTreeTop
SomeUnusedTilesBottom:
	.db BackgroundTile_LightDoor
	.db BackgroundTile_CactusMiddle
	.db BackgroundTile_PalmTreeTrunk


;
; This 3x9 tile entrance is used in 6-3
;
RockWallEntranceTiles:
	.db BackgroundTile_RockWallAngle
	.db BackgroundTile_RockWall
	.db BackgroundTile_RockWall

	.db BackgroundTile_RockWall
	.db BackgroundTile_RockWall
	.db BackgroundTile_RockWall

	.db BackgroundTile_RockWall
	.db BackgroundTile_RockWall
	.db BackgroundTile_RockWall

	.db BackgroundTile_RockWallEyeLeft
	.db BackgroundTile_RockWallEyeRight
	.db BackgroundTile_RockWall

	.db BackgroundTile_RockWallMouth
	.db BackgroundTile_RockWallMouth
	.db BackgroundTile_RockWall

	.db BackgroundTile_DarkDoor
	.db BackgroundTile_DarkDoor
	.db BackgroundTile_RockWall

	.db BackgroundTile_DarkDoor
	.db BackgroundTile_DarkDoor
	.db BackgroundTile_RockWall

	.db BackgroundTile_DarkDoor
	.db BackgroundTile_DarkDoor
	.db BackgroundTile_RockWall

	.db BackgroundTile_DarkDoor
	.db BackgroundTile_DarkDoor
	.db BackgroundTile_RockWall


;
; Creates the rock wall face entrance for 6-3.
;
; If you ask me, this is a lot of trouble for a one-off, especially since they
; didn't correctly align the "eyes" and "teeth" tiles with the wall pattern!
;
CreateObject_RockWallEntrance:
	LDX #$00

CreateObject_RockWallEntrance_Loop:
	LDY ze7
	LDA #$02
	STA z09

CreateObject_RockWallEntrance_InnerLoop:
	LDA RockWallEntranceTiles, X
	STA (z01), Y
	INX
	INY
	DEC z09
	BPL CreateObject_RockWallEntrance_InnerLoop

	LDY ze7
	TYA
	CLC
	ADC #$10
	STA ze7
	CPX #$1B
	BNE CreateObject_RockWallEntrance_Loop
	RTS


;
; Door tile lookup tables
;
DoorTopTiles:
	.db BackgroundTile_DoorTop
	.db BackgroundTile_DoorTop
	.db BackgroundTile_DarkDoor
	.db BackgroundTile_DoorwayTop
	.db BackgroundTile_WindowTop

DoorBottomTiles:
	.db BackgroundTile_DoorBottomLock
	.db BackgroundTile_DoorBottom
	.db BackgroundTile_DarkDoor
	.db BackgroundTile_DarkDoor
	.db BackgroundTile_DarkDoor


;
; Creates a door object.
;
; ##### Input
; - `ze7`: target tile placement offset
; - `i50e`: type of object to create
;
CreateObject_Door:
	LDY ze7
	LDA i50e
	CMP #$09
	BNE CreateObject_Door_Unlocked

	; If we've already used the key, create an unlocked door
	LDA iKeyUsed
	BEQ CreateObject_Door_Unlocked

	; Use the door two slots after the locked door for the unlocked version
	INC i50e
	INC i50e

CreateObject_Door_Unlocked:
	LDA i50e
	SEC
	SBC #$09
	TAX
	LDA DoorTopTiles, X
	STA (z01), Y
	JSR IncrementAreaYOffset

	LDA DoorBottomTiles, X
	STA (z01), Y

	;
	; For Worlds 1-5, the object after a door is used as an area pointer.
	;
	; This seems to be primarily a way to save space, as this method costs 1 byte
	; less than using a normal area pointer object.
	;
	; **But wait! Why not also use this space-saving trick for Worlds 6 and 7?**
	;
	; Regular level objects use the first nybble of the first byte for the Y
	; offset relative to the previous object. As it turns out, door pointer are
	; still "regular objects," at least insofar as their Y offset factors in when
	; rendering the level.
	;
	; For an area pointer, the first byte is the level offset. The first nybble of
	; that byte is $0 for levels 1-1 through 6-1, so there is no Y offset.
	; Door pointers starting in 6-2 would introduce a Y offset because that is
	; level offset is $10. Having everything after a door shift down by 1 row was
	; probably a nuisance when programming the levels.
	;
	LDA iCurrentWorld
	CMP #$05
	BEQ CreateObject_Door_Exit

	LDA iCurrentWorld
	CMP #$06
	BEQ CreateObject_Door_Exit

	JSR LevelParser_EatDoorPointer

CreateObject_Door_Exit:
	RTS


;
; Lookup table for World 7 mushroom house tiles.
;
; Interestingly, there are entries for black background tiles and jumpthrough
; cloud platforms in this table as well, although they are never used. Perhaps
; these houses would have included their own base at some point.
;
MushroomHouseLeftTiles:
	.db BackgroundTile_Black
	.db BackgroundTile_CloudLeft
	.db BackgroundTile_MushroomTopLeft
	.db BackgroundTile_HouseLeft

MushroomHouseMiddleTiles:
	.db BackgroundTile_Black
	.db BackgroundTile_CloudMiddle
	.db BackgroundTile_MushroomTopMiddle
	.db BackgroundTile_HouseMiddle

MushroomHouseRightTiles:
	.db BackgroundTile_Black
	.db BackgroundTile_CloudRight
	.db BackgroundTile_MushroomTopRight
	.db BackgroundTile_HouseRight


;
; Draws a row of the mushroom house
;
; ##### Input
; - `ze7`: target tile placement offset
; - `i50d`: width of house
; - `i50e`: offset in the tile lookup table plus $0A, for some reason
;
CreateObject_MushroomHouseRow:
	LDY ze7
	LDA i50e
	SEC
	SBC #$0A
	TAX
	LDA MushroomHouseLeftTiles, X
	STA (z01), Y
	DEC i50d
	BEQ CreateObject_MushroomHouseRow_Right

CreateObject_MushroomHouseRow_Loop:
	JSR IncrementAreaXOffset

	LDA MushroomHouseMiddleTiles, X
	STA (z01), Y
	DEC i50d
	BNE CreateObject_MushroomHouseRow_Loop

CreateObject_MushroomHouseRow_Right:
	JSR IncrementAreaXOffset

	LDA MushroomHouseRightTiles, X
	STA (z01), Y
	RTS


;
; Draws the jump-through mushroom house platforms used in World 7
;
CreateObject_MushroomJumpthroughPlatform:
	LDA i50d
	STA z07
	LDA #$0C
	STA i50e
	; Draw roof of mushroom house
	JSR CreateObject_MushroomHouseRow

CreateObject_MushroomJumpthroughPlatform_Loop:
	LDA ze7
	CLC
	ADC #$10
	STA ze7
	LDA #$0D
	STA i50e
	LDA z07

	STA i50d
	LDX ze8
	JSR SetAreaPageAddr_Bank6

	LDY ze7
	LDA (z01), Y
	CMP #BackgroundTile_Sky
	BNE CreateObject_MushroomJumpthroughPlatform_Exit

	; Draw body of mushroom house
	JSR CreateObject_MushroomHouseRow

	LDA ze7
	CMP #$E0
	BCC CreateObject_MushroomJumpthroughPlatform_Loop

CreateObject_MushroomJumpthroughPlatform_Exit:
	RTS


;
; Lookup table for pillar tiles, arranged by world
;
PillarTopTiles:
	.db BackgroundTile_LogPillarTop1
	.db BackgroundTile_CactusTop
	.db BackgroundTile_LogPillarTop1
	.db BackgroundTile_LogPillarTop0
	.db BackgroundTile_LogPillarTop1
	.db BackgroundTile_CactusTop
	.db BackgroundTile_ColumnPillarTop2

PillarBottomTiles:
	.db BackgroundTile_LogPillarMiddle1
	.db BackgroundTile_CactusMiddle
	.db BackgroundTile_LogPillarMiddle1
	.db BackgroundTile_LogPillarMiddle0
	.db BackgroundTile_LogPillarMiddle1
	.db BackgroundTile_CactusMiddle
	.db BackgroundTile_ColumnPillarMiddle2


;
; Draws a pillar that extends to the ground
;
; ##### Input
; - `ze7`: target tile placement offset
;
CreateObject_Pillar:
	LDX iCurrentWorldTileset
	LDY ze7
	LDA PillarTopTiles, X
	STA (z01), Y

CreateObject_Pillar_Loop:
	JSR IncrementAreaYOffset

	LDA (z01), Y
	CMP #BackgroundTile_Sky
	BNE CreateObject_Pillar_Exit

	LDX iCurrentWorldTileset
	LDA PillarBottomTiles, X
	STA (z01), Y

	;
	; Normally the pillars extend until they hit another tile, wrapping around to
	; the top of the next page, if necessary.
	;
	; This World 5 check prevents logs from coming down from the sky in the last
	; area before ClawGrip's boss room.
	;
	LDA iCurrentWorldTileset
	CMP #$04
	BNE CreateObject_Pillar_Loop

	; Prevent the pillar from looping around to the next page
	CPY #$E0
	BCC CreateObject_Pillar_Loop

CreateObject_Pillar_Exit:
	RTS


;
; Draws one horn of Wart's vegetable thrower
;
; ##### Input
; - `ze7`: target tile placement offset
;
CreateObject_Horn:
	LDY ze7
	LDA #BackgroundTile_HornTopLeft
	STA (z01), Y
	INY
	LDA #BackgroundTile_HornTopRight
	STA (z01), Y
	LDA ze7
	CLC
	ADC #$10
	TAY
	LDA #BackgroundTile_HornBottomLeft
	STA (z01), Y
	INY
	LDA #BackgroundTile_HornBottomRight
	STA (z01), Y
	RTS


;
; Draws the drawbridge chain
;
; ##### Input
; - `ze7`: target tile placement offset
;
CreateObject_DrawBridgeChain:
	LDY ze7

CreateObject_DrawBridgeChain_Loop:
	LDA #BackgroundTile_DrawBridgeChain
	STA (z01), Y
	TYA
	CLC
	ADC #$F
	TAY
	DEC i50d
	BNE CreateObject_DrawBridgeChain_Loop
	RTS
