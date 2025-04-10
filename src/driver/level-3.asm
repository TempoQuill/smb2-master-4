;
; Resets level data and PPU scrolling.
;
; This starts at the end of the last page and works backwards to create a blank slate upon which to
; render the current area's level data.
;
ResetLevelData:
	LDA #<wLevelDataBuffer
	STA z0a
	LDY #>(wLevelDataBuffer+$0900)
	STY z0b
	LDY #>(wLevelDataBuffer-$0100)

	; Set all tiles to sky
	LDA #BackgroundTile_Sky

ResetLevelData_Loop:
	STA (z0a), Y
	DEY
	CPY #$FF
	BNE ResetLevelData_Loop

	DEC z0b
	LDX z0b
	CPX #>wLevelDataBuffer
	BCS ResetLevelData_Loop

	LDA #$00
	STA zPPUScrollX
	STA zPPUScrollY
	STA iCurrentLvlPageX
	STA zd5
	STA ze6
	STA zScreenYPage
	STA zScreenY
	STA iBoundLeftUpper
	STA iBoundLeftLower
	STA zScrollArray
	RTS


;
; Reads a color from the world's background palette
;
; ##### Input
; - `X`: color index
;
; ##### Output
; - `A`: background palette color
;
ReadWorldBackgroundColor:
	; stash X and Y registers
	STY z0e
	STX z0d
	; look up the address of the current world's palette
	LDY iCurrentWorldTileset
	LDA WorldBackgroundPalettePointersLo, Y
	STA z07
	LDA WorldBackgroundPalettePointersHi, Y
	STA z08
	; load the color
	LDY z0d
	LDA (z07), Y
	; restore prior X and Y registers
	LDY z0e
	LDX z0d
	RTS

;
; Reads a color from the world's sprite palette
;
; ##### Input
; - `X`: color index
;
; ##### Output
; - `A`: background palette color
;
ReadWorldSpriteColor:
	; stash X and Y registers
	STY z0e
	STX z0d
	; look up the address of the current world's palette
	LDY iCurrentWorldTileset
	LDA WorldSpritePalettePointersLo, Y
	STA z07
	LDA WorldSpritePalettePointersHi, Y
	STA z08
	; load the color
	LDY z0d
	LDA (z07), Y
	; restore prior X and Y registers
	LDY z0e
	LDX z0d
	RTS

;
; Loads the current area or jar palette
;
LoadCurrentPalette:
	LDA iSubAreaFlags
	CMP #$01
	BNE LoadCurrentPalette_NotJar

	; This function call will overwrite the
	; normal level loading area with $7A00
	JSR HijackLevelDataCopyAddressWithJar

	JMP LoadCurrentPalette_AreaOffset

; ---------------------------------------------------------------------------

LoadCurrentPalette_NotJar:
	JSR RestoreLevelDataCopyAddress

; Read the palette offset from the area header
LoadCurrentPalette_AreaOffset:
	LDY #$00
	LDA (z05), Y

; End of function LoadCurrentPalette

;
; Loads a world palette to RAM
;
; ##### Input
; - `A`: background palette header byte
;
ApplyPalette:
	; Read background palette index from area header byte
	STA z0f
	AND #%00111000
	ASL A
	TAX
	JSR ReadWorldBackgroundColor

	; Something PPU-related. If it's not right, the colors are very wrong.
	STA iSkyColor
	LDA #$3F
	STA iPPUBuffer
	LDA #$00
	STA iPPUBuffer + 1
	LDA #$20
	STA iPPUBuffer + 2

	LDY #$00
ApplyPalette_BackgroundLoop:
	JSR ReadWorldBackgroundColor
	STA iPPUBuffer + 3, Y
	INX
	INY
	CPY #$10
	BCC ApplyPalette_BackgroundLoop

	; Read sprite palette index from area header byte
	LDA z0f
	AND #$03
	ASL A
	STA z0f
	ASL A
	ADC z0f
	ASL A
	TAX

	LDY #$00
ApplyPalette_SpriteLoop:
	JSR ReadWorldSpriteColor
	STA iPPUBuffer + $17, Y
	INX
	INY
	CPY #$0C
	BCC ApplyPalette_SpriteLoop

	LDA #$00
	STA iPPUBuffer + $17, Y
	LDY #$03

ApplyPalette_PlayerLoop:
	LDA iBackupPlayerPal, Y
	STA iPPUBuffer + $13, Y
	DEY
	BPL ApplyPalette_PlayerLoop

	LDX #$03
	LDY #$10
ApplyPalette_SkyLoop:
	LDA iSkyColor
	STA iPPUBuffer + 3, Y
	INY
	INY
	INY
	INY
	DEX
	BPL ApplyPalette_SkyLoop
	RTS


GenerateSubspaceArea:
	LDA iCurrentLvlArea
	STA iCurrentAreaBackup
	LDA #$30 ; subspace palette (works like area header byte)
	STA z0f; why...?
	JSR ApplyPalette

	LDA iBoundLeftUpper
	STA ze8

	LDA iBoundLeftLower
	CLC
	ADC #$08
	BCC loc_BANK6_9439

	INC ze8

loc_BANK6_9439:
	AND #$F0
	PHA
	SEC

	SBC iBoundLeftLower
	STA zXVelocity
	PLA
	LSR A
	LSR A
	LSR A
	LSR A
	STA ze5
	LDA #$00
	STA ze6
	LDA ze8
	STA z0d
	JSR SetTileOffsetAndAreaPageAddr_Bank6

	LDY ze7
	LDX #$0F

GenerateSubspaceArea_TileRemapLoop:
	LDA (z01), Y
	JSR DoSubspaceTileRemap

	STA iSubspaceLayout, X
	TYA
	CLC
	ADC #$10
	TAY
	TXA
	CLC
	ADC #$10
	TAX
	AND #$F0
	BNE GenerateSubspaceArea_TileRemapLoop

	TYA
	AND #$0F
	TAY
	JSR IncrementAreaXOffset

	DEX
	BPL GenerateSubspaceArea_TileRemapLoop
	RTS


;
; Remaps a single subspace tile.
;
; This also handles creating the mushroom sprites.
;
; ##### Input
; - `A`: input tile
;
; ##### Output
; - `A`: output tile
;
DoSubspaceTileRemap:
	STY z08
	STX z07
	LDX #(SubspaceTilesReplace - SubspaceTilesSearch - 1)

DoSubspaceTileRemap_Loop:
	CMP SubspaceTilesSearch, X
	BEQ DoSubspaceTileRemap_ReplaceTile

	DEX
	BPL DoSubspaceTileRemap_Loop

	CMP #BackgroundTile_SubspaceMushroom1
	BEQ DoSubspaceTileRemap_CheckCreateMushroom

	CMP #BackgroundTile_SubspaceMushroom2
	BEQ DoSubspaceTileRemap_CheckCreateMushroom

	JMP DoSubspaceTileRemap_Exit

DoSubspaceTileRemap_CheckCreateMushroom:
	SEC
	SBC #BackgroundTile_SubspaceMushroom1
	TAY
	LDA iMushroomFlags, Y
	BNE DoSubspaceTileRemap_AfterCreateMushroom

	LDX z07
	JSR CreateSubspaceMushroomObject

DoSubspaceTileRemap_AfterCreateMushroom:
	LDA #BackgroundTile_SubspaceMushroom1
	JMP DoSubspaceTileRemap_Exit

DoSubspaceTileRemap_ReplaceTile:
	LDA SubspaceTilesReplace, X

DoSubspaceTileRemap_Exit:
	LDX z07
	LDY z08
	RTS


;
; Clears the sub-area tile layout when the player goes into a jar
;
ClearSubAreaTileLayout:
	LDX #$00
	STX zScrollCondition

ClearSubAreaTileLayout_Loop:
	LDA #BackgroundTile_Sky
	STA iSubspaceLayout, X
	INX
	BNE ClearSubAreaTileLayout_Loop

	LDA iCurrentLvlArea
	STA iCurrentAreaBackup
	LDA #$04 ; jar is always area 4
	STA iCurrentLvlArea
	LDA #$0A
	JSR HijackLevelDataCopyAddressWithJar

	LDY #$00
	LDA #$0A
	STA ze8
	STA i540
	STY ze6
	STY ze5
	STY iSurface
	LDY #$03
	STY iGroundSetting
	LDY #$04
	JSR ReadLevelBackgroundData_Page

	; object type
	LDY #$02
	LDA (z05), Y
	AND #%00000011
	STA iSpriteTypeLo
	LDA (z05), Y
	LSR A
	LSR A
	AND #%00000011
	STA iSpriteTypeHi
	JSR HijackLevelDataCopyAddressWithJar

	LDA #$0A
	STA ze8
	LDA #$00
	STA ze6
	STA ze5
	LDA #$03
	STA z04
	JSR ReadLevelForegroundData_NextByteObject

	LDA #$01
	STA zScrollCondition
	RTS

;
; Set the current background music to the current area's music as defined in the header.
;
; This stops the current music unless the player is currently invincible.
;
LoadAreaMusic:
	LDY #$03
	LDA (z05), Y
	AND #%00000011
	STA iLevelMusic
	CMP iMusicID
	BEQ LoadAreaMusic_Exit

	LDA iStarTimer
	CMP #$08
	BCS LoadAreaMusic_Exit

	LDA #Music_StopMusic
	STA iMusicQueue

LoadAreaMusic_Exit:
	RTS


;
; Unreferenced? A similar routine exists in Bank F, so it seems like this may
; be leftover code from a previous version.
;
Unused_LevelMusicIndexes:
	.db Music_Overworld
	.db Music_Inside
	.db Music_Boss
	.db Music_Wart
	.db Music_Subspace

Unused_ChangeAreaMusic:
	LDA iLevelMusic
	CMP iMusicID
	BEQ Unused_ChangeAreaMusic_Exit

	TAX
	STX iMusicID
	LDA iStarTimer
	CMP #$08
	BCS LoadAreaMusic_Exit

	LDA Unused_LevelMusicIndexes, X
	STA iMusicQueue

Unused_ChangeAreaMusic_Exit:
	RTS

; Unreferenced?
	LDA iCurrentLvlPage
	ASL A
	TAY
	LDA iAreaAddresses, Y
	STA iCurrentLvl
	STA sSavedLvl
	INY
	LDA iAreaAddresses, Y
	LSR A
	LSR A
	LSR A
	LSR A
	STA iCurrentLvlArea
	LDA iAreaAddresses, Y
	AND #$0F
	STA iCurrentLvlEntryPage
	STA sSavedLvlEntryPage
	RTS


;
; ## Area loading and rendering
;
; This is the main subroutine for parsing and rendering an entire area of a level.
;
LoadCurrentArea:
	; First, reset the level data and PPU scrolling.
	JSR ResetLevelData

	JSR ResetPPUScrollHi_Bank6

	; Determine the address of the raw level data.
	JSR RestoreLevelDataCopyAddress

	;
	; ### Read area header
	;
	; The level header is read backwards starting at the last byte.
	;

	; Queue any changes to the background music.
	JSR LoadAreaMusic

	;
	; Load initial ground appearance, which determines the tiles used for the background.
	;
	LDY #$03
	LDA (z05), Y
	LSR A
	AND #%00011100

	STA iSurface

	; This doesn't hurt, but shouldn't be necessary.
	JSR RestoreLevelDataCopyAddress

	; Determine whether this area is Horizontal or vertical.
	LDY #$00
	LDA (z05), Y
	ASL A
	LDA #$00
	ROL A
	STA zScrollCondition

	; Reset the area page so that we can start drawing from the beginning.
	LDA #$00
	STA ze8

	; Determine the level length (in pages).
	LDY #$02
	LDA (z05), Y
	LSR A
	LSR A
	LSR A
	LSR A
	STA iCurrentLvlPages

	; Determine the object types, which are used to determine which horizontal and vertical blocks are
	; used, as well as how some climbable objects appear.
	LDA (z05), Y
	AND #%00000011
	STA iSpriteTypeLo
	LDA (z05), Y
	LSR A
	LSR A
	AND #%00000011
	STA iSpriteTypeHi
	DEY

	; Load initial ground setting, which determines the shape of the ground layout.
	;
	; Using `$1F` skips rendering ground settings entirely, but no areas seem to use it.
	LDA (z05), Y
	AND #%00011111
	CMP #%00011111
	BEQ LoadCurrentArea_ForegroundData

	STA iGroundSetting

	;
	; ### Process level data
	;
	; The area is rendered in two passes (with the exception described above).
	;

	;
	; #### First pass: background terrain
	;
	; The first pass applies the ground settings and appearance to the entire area. This makes sure
	; that the ground is already in place when rendering objects that extend to the ground, such as
	; trees, vines, and platforms.
	;

	; Advance to the first object in the level data.
	INY
	INY
	INY

	; Reset the tile placement offset for the first pass.
	LDA #$00
	STA ze5
	STA ze6

	; Run the first pass of level rendering to apply ground settings and appearance.
	JSR ReadLevelBackgroundData

	;
	; #### Second pass: foreground objects
	;
	; The second pass renders normal level objects and sets up area pointers.
	;
LoadCurrentArea_ForegroundData:
	; Reset the tile placement offset for the second pass.
	LDA #$00
	STA ze6

	; Advance to the first object in the level data.
	LDA #$03
	STA z04

	; Run the second pass of level rendering to place regular objects in the level.
	JSR ReadLevelForegroundData

	; Bootstrap the pseudo-random number generator.
	LDA #$22
	ORA z10
	STA iPRNGSeed
	RTS


;
; Sets the raw level data pointer to the level data.
;
RestoreLevelDataCopyAddress:
	LDA #>wRawLevelData
	STA z06
	LDA #<wRawLevelData
	STA z05
	RTS


;
; Sets the raw level data pointer to the jar data.
;
; This is what allows jars to load so quickly.
;
HijackLevelDataCopyAddressWithJar:
	LDA #>wRawJarData
	STA z06
	LDA #<wRawJarData
	STA z05
	RTS


;
; ### Render foreground level data
;
; Reads level data from the beginning and processes individual objects.
;
; ##### Input
; - `z04`: raw data offset
;
ReadLevelForegroundData:
	; start at area page 0
	LDA #$00
	STA ze8

	; weird? the next lines do nothing
	LDY #$00
	JMP ReadLevelForegroundData_NextByteObject

ReadLevelForegroundData_NextByteObject:
	LDY z04

ReadLevelForegroundData_NextByte:
	INY
	LDA (z05), Y
	CMP #$FF
	BNE ReadLevelForegroundData_ProcessObject
	; Encountering `$FF` indicates the end of the level data.
	RTS

ReadLevelForegroundData_ProcessObject:
	; Stash the lower nybble of the first byte.
	; For a special object, this will be the special object type.
	; For a regular object, this will be the X position.
	LDA (z05), Y
	AND #$0F
	STA ze5
	; If the upper nybble of the first byte is $F, this is a special object.
	LDA (z05), Y
	AND #$F0
	CMP #$F0
	BNE ReadLevelForegroundData_RegularObject

ReadLevelForegroundData_SpecialObject:
	LDA ze5
	STY z0f
	JSR ProcessSpecialObjectForeground

	LDY z0f
	JMP ReadLevelForegroundData_NextByte

ReadLevelForegroundData_RegularObject:
	JSR UpdateAreaYOffset

	; check object type
	INY
	; upper nybble
	LDA (z05), Y
	LSR A
	LSR A
	LSR A
	LSR A
	STA i50e
	CMP #$03
	BCS ReadLevelForegroundData_RegularObjectWithSize

ReadLevelForegroundData_RegularObjectNoSize:
	PHA
	LDA (z05), Y
	AND #$0F
	STA i50e
	PLA
	BEQ ReadLevelForegroundData_RegularObjectNoSize_00

	PHA
	JSR SetTileOffsetAndAreaPageAddr_Bank6

	LDA (z05), Y
	AND #$0F
	STY z04
	PLA
	CMP #$01
	BNE ReadLevelForegroundData_RegularObjectNoSize_Not10

ReadLevelForegroundData_RegularObjectNoSize_10:
	JSR CreateObjects_10
	JMP ReadLevelForegroundData_RegularObject_Exit

ReadLevelForegroundData_RegularObjectNoSize_Not10:
	CMP #$02
	BNE ReadLevelForegroundData_RegularObjectNoSize_Not20

ReadLevelForegroundData_RegularObjectNoSize_20:
	JSR CreateObjects_20
	JMP ReadLevelForegroundData_RegularObject_Exit

ReadLevelForegroundData_RegularObjectNoSize_Not20:
	JMP ReadLevelForegroundData_RegularObject_Exit

ReadLevelForegroundData_RegularObjectWithSize:
	LDA (z05), Y
	AND #$0F
	STA i50d
	STY z04
	JSR SetTileOffsetAndAreaPageAddr_Bank6

	LDA i50e
	SEC
	SBC #$03
	STA i50e
	JSR CreateObjects_30thruF0

ReadLevelForegroundData_RegularObject_Exit:
	JMP ReadLevelForegroundData_NextByteObject

ReadLevelForegroundData_RegularObjectNoSize_00:
	JSR SetTileOffsetAndAreaPageAddr_Bank6

	LDA (z05), Y
	AND #$0F
	STY z04
	JSR CreateObjects_00

	JMP ReadLevelForegroundData_RegularObject_Exit


;
; Updates the area Y offset for object placement
;
; ##### Input
; - `A`: vertical offset
;
UpdateAreaYOffset:
	CLC
	ADC ze6
	BCC UpdateAreaYOffset_SamePage

	ADC #$0F
	JMP UpdateAreaYOffset_NextPage

UpdateAreaYOffset_SamePage:
	CMP #$F0
	BNE UpdateAreaYOffset_Exit

	LDA #$00

UpdateAreaYOffset_NextPage:
	INC ze8

UpdateAreaYOffset_Exit:
	STA ze6
	RTS


;
; Processes special objects for the second pass, which draws object tiles.
;
; On this pass, ground setting tiles are ignored, and we're just eating the bytes, but page skip
; objects still require updating the tile placement cursor.
;
; Area pointers are also processed in this pass. Although they _could_ be processed earlier, this
; reduces the likelihood of being overridden by a door pointer.
;
ProcessSpecialObjectForeground:
	JSR JumpToTableAfterJump

	.dw EatLevelObject1Byte ; Ground setting 0-8
	.dw EatLevelObject1Byte ; Ground setting 9-15
	.dw SkipForwardPage1Foreground ; Skip forward 1 page
	.dw SkipForwardPage2Foreground ; Skip forward 2 pages
	.dw ResetPageAndOffsetForeground ; New object layer
	.dw SetAreaPointer ; Area pointer
	.dw EatLevelObject1Byte ; Ground appearance


;
; Processes special objects for the first pass, which draws ground layout tiles.
;
ProcessSpecialObjectBackground:
	JSR JumpToTableAfterJump

	.dw SetGroundSettingA ; Ground setting 0-7
	.dw SetGroundSettingB ; Ground setting 8-15
	.dw SkipForwardPage1Background ; Skip forward 1 page
	.dw SkipForwardPage2Background ; Skip forward 2 pages
	.dw ResetPageAndOffsetBackground ; New object layer
	.dw SetAreaPointerNoOp ; Area pointer
	.dw SetGroundType ; Ground appearance

;
; #### Special Object `$F2` / `$F3`: Skip Page (Foreground)
;
; Moves the tile placement cursor forward one or two pages in the foregorund pass.
;
; ##### Output
;
; - `ze8`: area page
; - `ze6`: tile placement offset
;
;

SkipForwardPage2Foreground:
	INC ze8

SkipForwardPage1Foreground:
	INC ze8
	LDA #$00
	STA ze6
	RTS


;
; #### Special Object `$F2` / `$F3`: Skip Page (Background)
;
; Moves the tile placement cursor forward one or two pages in the background pass.
;
; ##### Output
;
; - `i540`: area page
; - `z0e`: tile placement offset
; - `z09`: tile placement offset (overflow counter)
;

SkipForwardPage2Background:
	INC i540

SkipForwardPage1Background:
	INC i540
	LDA #$00
	STA z0e
	STA z09
	RTS

;
; Advances two bytes in the level data.
;
; Unreferenced?
;
EatLevelObject2Bytes:
	INC z0f

;
; Advances one byte in the level data.
;
EatLevelObject1Byte:
	INC z0f
	RTS


;
; #### Area Pointer Object `$F5`
;
; Sets the area pointer for this page.
;
; ##### Input
; - `z0f`: level data byte offset
; - `ze8`: area page
;
; ##### Output
; - `z0f`: level data byte offset
;
SetAreaPointer:
	LDY z0f
	INY
	LDA ze8
	ASL A
	TAX
	LDA (z05), Y
	STA iAreaAddresses, X
	INY
	INX
	LDA (z05), Y
	STA iAreaAddresses, X
	STY z0f
	RTS

;
; Use top 3 bits for the X offset of a ground setting object
;
; ##### Output
; - `A`: 0-7
;
ReadGroundSettingOffset:
	LDY z0f
	INY
	LDA (z05), Y
	AND #%11100000
	LSR A
	LSR A
	LSR A
	LSR A
	LSR A
	RTS

;
; #### Special Object `$F0` / `$F1`: Ground Setting
;
; Sets ground setting at some relative offset on the current page.
;
; Object `$F0` can change the ground setting for offsets 0 through 7.
; Object `$F1` can change the ground setting for offsets 8 through 15.
;
; #### Input
; - `A`: Relative offset (0-7)
; - `z0f`: level data byte offset
;
; #### Output
; - `z0e`: tile placement offset
;
SetGroundSettingA:
	JSR ReadGroundSettingOffset
	JMP SetGroundSetting

SetGroundSettingB:
	JSR ReadGroundSettingOffset
	CLC
	ADC #$08

SetGroundSetting:
	STA z0e
	LDA zScrollCondition
	BNE SetGroundSetting_Exit

	LDA z0e
	ASL A
	ASL A
	ASL A
	ASL A
	STA z0e

SetGroundSetting_Exit:
	RTS


;
; #### Special Object `$F4`: New Layer (Foreground)
;
; Moves the tile placement cursor to the beginning of the first page in the foreground pass.
;
; ##### Output
;
; - `ze8`: area page
; - `ze6`: tile placement offset
;
ResetPageAndOffsetForeground:
	LDA #$00
	STA ze8 ; area page
	STA ze6 ; tile placement offset
	RTS


;
; #### Special Object `$F4`: New Layer (Background)
;
; Moves the tile placement cursor to the beginning of the first page in the background pass.
;
; ##### Output
;
; - `i540`: area page
; - `z0e`: tile placement offset
;
ResetPageAndOffsetBackground:
	LDA #$00
	STA i540
	STA z0e
	RTS


;
; Area pointers are not processed on the background pass.
;
SetAreaPointerNoOp:
	RTS


;
; #### Ground Appearance Object `$F6`
;
; Sets the ground appearance, which determines the tiles used when drawing the ground setting.
;
; ##### Output
;
; `iSurface`: the ground type used for drawing the background
;
SetGroundType:
	LDY z0f
	INY
	LDA (z05), Y
	AND #%00001111
	ASL A
	ASL A
	STA iSurface
	RTS


;
; ### Render background level data
;
; Reads level data from the beginning and processes the ground layout.
;
; This first pass is used for setting up the ground types and settings before normal objects are
; rendered in the level.
;
; ##### Input
; - `Y`: raw data offset
;
ReadLevelBackgroundData:
	LDA #$00
	STA i540

ReadLevelBackgroundData_Page:
	LDA #$00
	STA z09

ReadLevelBackgroundData_Object:
	LDA (z05), Y
	CMP #$FF
	BNE ReadLevelBackgroundData_ProcessObject

	; Encountering `$FF` indicates the end of the level data.
	; We need to render the remaining ground setting through the end of the last page in the area.
	LDA #$0A
	STA i540
	INC i540
	LDA #$00
	STA z0e
	JMP ReadLevelBackgroundData_RenderGround

ReadLevelBackgroundData_ProcessObject:
	LDA (z05), Y
	AND #$F0
	BEQ ReadLevelBackgroundData_ProcessObject_Advance2Bytes

	CMP #$F0
	BNE ReadLevelBackgroundData_ProcessRegularObject

;
; First byte of `$FX` indicates a special object.
;
ReadLevelBackgroundData_ProcessSpecialObject:
	LDA (z05), Y
	AND #$0F
	STY z0f
	JSR ProcessSpecialObjectBackground

	; Determine how many more bytes to advance after processing the special object.
	LDY z0f
	LDA (z05), Y
	AND #$0F

	; Ground setting `$F0` / `$F1` should render the previous ground setting
	CMP #$02
	BCC ReadLevelBackgroundData_RenderGround

	; Special objects except `$F0` / `$F1`
	CMP #$05
	BNE ReadLevelBackgroundData_ProcessObject_NotF5

ReadLevelBackgroundData_ProcessObject_Advance3Bytes:
	INY
	JMP ReadLevelBackgroundData_ProcessObject_Advance2Bytes

ReadLevelBackgroundData_ProcessObject_NotF5:
	; Special objects except `$F0` / `$F1` / `$F5`
	CMP #$06
	BNE ReadLevelBackgroundData_ProcessObject_AdvanceByte

; Ground appearance `$F6` is two bytes.
ReadLevelBackgroundData_ProcessObject_Advance2Bytes:
	INY

ReadLevelBackgroundData_ProcessObject_AdvanceByte:
	INY
	JMP ReadLevelBackgroundData_Object

;
; Processes a regular object, as indicated by a value of `$0X-$EX` in the first byte.
;
; ##### Input
; - `z09`: tile placement offset (overflow counter)
;
; ##### Output
; - `i540`: area page
; - `z09`: tile placement offset (overflow counter)
;
; Since we're only processing background objects, all this needs to do is look at the object offset
; and advance the tile placement cursor and current page as needed.
;
; #### The Door Pointer Y Offset "Bug"
;
; An interesting quirk about the level engine is that door pointers are used in worlds 1-5, but not
; worlds 6 and 7, due to the fact that the pointers have an effective Y offset of 1.
;
; The developers chose to disable door pointers to deal with this problem, but another solution
; would have been to modify the code here to determine whether an object was being used as a door
; pointer and avoid processing its position offset.
;
ReadLevelBackgroundData_ProcessRegularObject:
	CLC
	ADC z09
	BCC ReadLevelBackgroundData_ProcessRegularObject_SamePage

	; The object position overflowed to the next page.
	ADC #$0F
	JMP ReadLevelBackgroundData_ProcessRegularObject_NextPage

ReadLevelBackgroundData_ProcessRegularObject_SamePage:
	CMP #$F0
	BNE ReadLevelBackgroundData_ProcessRegularObject_Exit

	LDA #$00

ReadLevelBackgroundData_ProcessRegularObject_NextPage:
	INC i540

ReadLevelBackgroundData_ProcessRegularObject_Exit:
	STA z09
	JMP ReadLevelBackgroundData_ProcessObject_Advance2Bytes


;
; Renders the ground setting up to this point.
;
; This code is invoked when we encounter a ground setting object and need to render the previous
; ground setting up tothis point or when we have reached the end of the level data and need to
; render the current ground setting through the end of the area.
;
; #### Input
; - `ze8`: area page
; - `ze5`: tile placement offset shift
; - `ze6`: previous tile placement offset
; - `i540`: area page (end)
; - `z0e`: tile placement offset (end)
;
; #### Output
;
ReadLevelBackgroundData_RenderGround:
	JSR SetTileOffsetAndAreaPageAddr_Bank6

	JSR LoadGroundSetData

	LDA zScrollCondition
	BEQ ReadLevelBackgroundData_RenderGround_Vertical

ReadLevelBackgroundData_RenderGround_Horizontal:
	; Increment the column.
	INC ze5
	LDA ze5
	CMP #$10
	BNE ReadLevelBackgroundData_RenderGround_CheckComplete

	; Increment the page and reset to the first column.
	INC ze8
	LDA #$00
	STA ze5
	JMP ReadLevelBackgroundData_RenderGround_CheckComplete


ReadLevelBackgroundData_RenderGround_Vertical:
	; Increment the row.
	LDA #$10
	JSR UpdateAreaYOffset

ReadLevelBackgroundData_RenderGround_CheckComplete:
	; If there are more pages to render with this ground setting, keep going.
	LDA ze8
	CMP i540
	BNE ReadLevelBackgroundData_RenderGround

	LDA zScrollCondition
	BEQ ReadLevelBackgroundData_RenderGround_CheckComplete_Vertical

ReadLevelBackgroundData_RenderGround_CheckComplete_Horizontal:
	; If there is more to render with this ground setting, keep going.
	LDA ze5
	CMP z0e
	BCC ReadLevelBackgroundData_RenderGround

	; Otherwise, move on and process the next object.
	BCS ReadLevelBackgroundData_RenderGround_Exit

ReadLevelBackgroundData_RenderGround_CheckComplete_Vertical:
	LDA ze6
	CMP z0e
	BCC ReadLevelBackgroundData_RenderGround

ReadLevelBackgroundData_RenderGround_Exit:
	LDA (z05), Y
	; Encountering `$FF` indicates the end of the level data.
	CMP #$FF
	BEQ ReadGroundSetByte_Exit

	; Otherwise this was triggered because we encountered a ground setting object, so `iGroundSetting`
	; for the next time we need to render the ground.
	INY
	LDA (z05), Y
	AND #$1F
	STA iGroundSetting
	JMP ReadLevelBackgroundData_ProcessObject_AdvanceByte

; -----


;
; Reads the current ground setting byte.
;
; ##### Input
; - `X`: Ground setting offset
;
; ##### Output
; - `A`: Byte containing the 4 ground appearance bit pairs for the offset
;
ReadGroundSetByte:
	LDA zScrollCondition
	BNE ReadGroundSetByte_Vertical

	LDA VerticalGroundSetData, X
	RTS

ReadGroundSetByte_Vertical:
	LDA HorizontalGroundSetData, X

ReadGroundSetByte_Exit:
	RTS


;
; Draws the current ground setting and type to the raw tile buffer.
;
; ##### Input
; - `iGroundSetting`: current ground setting
; - `iSurface`: current ground appearance
; - `ze7`: tile placement offset
;
LoadGroundSetData:
	STY z04
	LDA iGroundSetting
	ASL A
	ASL A
	TAX
	LDY ze7

LoadGroundSetData_Loop:
	JSR ReadGroundSetByte

	JSR WriteGroundSetTiles1

	JSR ReadGroundSetByte

	JSR WriteGroundSetTiles2

	JSR ReadGroundSetByte

	JSR WriteGroundSetTiles3

	JSR ReadGroundSetByte

	JSR WriteGroundSetTiles4

	LDA zScrollCondition
	BEQ LoadGroundSetData_Horizontal

	INX
	BCS LoadGroundSetData_Exit

	BCC LoadGroundSetData_Loop

LoadGroundSetData_Horizontal:
	INX
	TYA
	AND #$0F
	BNE LoadGroundSetData_Loop

LoadGroundSetData_Exit:
	LDY z04
	RTS

;
; Draws current ground set tiles.
;
WriteGroundSetTiles:
WriteGroundSetTiles1:
	LSR A
	LSR A

WriteGroundSetTiles2:
	LSR A
	LSR A

WriteGroundSetTiles3:
	LSR A
	LSR A

WriteGroundSetTiles4:
	AND #$03
	STX z03
	; This `BEQ` is what effectively ignores the first index of the groundset tiles lookup tables.
	BEQ WriteGroundSetTiles_AfterWriteTile

	CLC
	ADC iSurface
	TAX
	LDA zScrollCondition
	BNE WriteGroundSetTiles_Horizontal

	JSR ReadGroundTileVertical

	JMP WriteGroundSetTiles_WriteTile

WriteGroundSetTiles_Horizontal:
	JSR ReadGroundTileHorizontal

WriteGroundSetTiles_WriteTile:
	STA (z01), Y

WriteGroundSetTiles_AfterWriteTile:
	LDX z03
	LDA zScrollCondition
	BNE WriteGroundSetTiles_IncrementYOffset

	INY
	RTS

WriteGroundSetTiles_IncrementYOffset:
	TYA
	CLC
	ADC #$10
	TAY
	RTS


ReadGroundTileHorizontal:
	STX z0c
	STY z0d
	LDX iCurrentWorldTileset
	LDA GroundTilesHorizontalLo, X
	STA z07
	LDA GroundTilesHorizontalHi, X
	STA z08
	LDY z0c
	LDA (z07), Y
	LDX z0c
	LDY z0d
	RTS


ReadGroundTileVertical:
	STX z0c
	STY z0d
	LDX iCurrentWorldTileset
	LDA GroundTilesVerticalLo, X
	STA z07
	LDA GroundTilesVerticalHi, X
	STA z08
	LDY z0c
	LDA (z07), Y
	LDX z0c
	LDY z0d
	RTS


;
; Updates the area page and tile placement offset
;
; ##### Input
; - `ze8`: area page
; - `ze5`: tile placement offset shift
; - `ze6`: previous tile placement offset
;
; ##### Output
; - `z01`: low byte of decoded level data RAM
; - `z02`: high byte of decoded level data RAM
; - `ze7`: target tile placement offset
;
SetTileOffsetAndAreaPageAddr_Bank6:
	LDX ze8
	JSR SetAreaPageAddr_Bank6

	LDA ze6
	CLC
	ADC ze5
	STA ze7
	RTS

;
; Updates the area page that we're drawing tiles to
;
; ##### Input
; - `X`: area page
;
; ##### Output
; - `z01`: low byte of decoded level data RAM
; - `z02`: high byte of decoded level data RAM
;
SetAreaPageAddr_Bank6:
	LDA DecodedLevelPageStartLo_Bank6, X
	STA z01
	LDA DecodedLevelPageStartHi_Bank6, X
	STA z02
	RTS


IncrementAreaXOffset:
	INY
	TYA
	AND #$0F
	BNE IncrementAreaXOffset_Exit

	TYA
	SEC
	SBC #$10
	TAY
	STX z0b
	LDX ze8
	INX
	STX z0d
	JSR SetAreaPageAddr_Bank6
	LDX z0b

IncrementAreaXOffset_Exit:
	RTS


; Moves one row down and increments the page, if necessary
IncrementAreaYOffset:
	TYA
	CLC
	ADC #$10
	TAY
	CMP #$F0
	BCC IncrementAreaYOffset_Exit

	; increment the area page
	LDX ze8
	INX
	JSR SetAreaPageAddr_Bank6

	TYA
	AND #$0F
	TAY

IncrementAreaYOffset_Exit:
	RTS


;
; Consume the object as an area pointer. This overwrites any existing area
; pointer for this page.
;
LevelParser_EatDoorPointer:
	LDY z04
	INY
	LDA (z05), Y
	STA z07
	INY
	LDA (z05), Y
	STA z08
	STY z04
	LDA ze8
	ASL A
	TAY
	LDA z07
	STA iAreaAddresses, Y
	INY
	LDA z08
	STA iAreaAddresses, Y
	RTS

;
; High byte of the PPU scroll offset for nametable B.
;
; When mirroring vertically, nametable A is `$2000` and nametable B is `$2800`.
; When mirroring horizontally, nametable A is `$2000` and nametable B is `$2400`.
;
PPUScrollHiOffsets_Bank6:
	.db $28 ; vertical
	.db $24 ; horizontal

;
; Resets the PPU high scrolling values and sets the high byte of the PPU scroll offset.
;
; The version of the subroutine in this bank is always called with `A = $00`.
;
; ##### Input
; - `A`: 0 = use nametable A, 1 = use nametable B
; - `Y`: 0 = vertical, 1 = horizontal
;
; ##### Output
; - `zYScrollPage`
; - `zXScrollPage`
; - `iPPUBigScrollCheck`: PPU scroll offset high byte
;
ResetPPUScrollHi_Bank6:
	LSR A
	BCS ResetPPUScrollHi_NametableB_Bank6

ResetPPUScrollHi_NametableA_Bank6:
	LDA #$01
	STA zXScrollPage
	ASL A
	STA zYScrollPage
	LDA #$20
	BNE ResetPPUScrollHi_Exit_Bank6

ResetPPUScrollHi_NametableB_Bank6:
	LDA #$00
	STA zXScrollPage
	STA zYScrollPage
	LDA PPUScrollHiOffsets_Bank6, Y

ResetPPUScrollHi_Exit_Bank6:
	STA iPPUBigScrollCheck
	RTS


;
; Creates a mushroom object in subspace.
;
; ##### Input
; - `X`: Object position
; - `Y`: Which mushroom (0 or 1)
;
CreateSubspaceMushroomObject:
	TXA
	PHA
	AND #$F0
	STA zObjectYLo
	TXA
	ASL A
	ASL A
	ASL A
	ASL A
	STA zObjectXLo

	; Subspace is page `$0A`.
	LDA #$0A
	STA zObjectXHi
	LDX #$00
	STX z12
	STX zObjectYHi

	; Create a living fungus.
	; Even most of this routine uses an enemy slot offset, the next few lines assume slot 0.
	; We just set `X` to 0, so this is a safe enough assumption.
	LDA #Enemy_Mushroom
	STA zObjectType
	LDA #EnemyState_Alive
	STA zEnemyState
	; Keep track of which mushroom so that you can't collect it twice.
	STY zObjectVariables

	; Reset various object timers and attributes
	LDA #$00
	STA zSpriteTimer, X
	STA zEnemyArray, X
	STA zHeldObjectTimer, X
	STA zObjectAnimTimer, X
	STA iObjectShakeTimer, X
	STA zEnemyCollision, X
	STA iObjectStunTimer, X
	STA iSpriteTimer, X
	STA iObjectFlashTimer, X
	STA zObjectYVelocity, X
	STA zObjectXVelocity, X

	; Load various object attributes for a mushroom
	LDY zObjectType, X
	LDA ObjectAttributeTable, Y
	AND #$7F
	STA zObjectAttributes, X
	LDA EnemyArray_46E_Data, Y
	STA i46e, X
	LDA ObjectHitbox_Data, Y
	STA iObjectHitbox, X
	LDA EnemyArray_492_Data, Y
	STA i492, X
	LDA #$FF
	STA iEnemyRawDataOffset, X

	; Restore X to its previous value
	PLA
	TAX
	RTS

GetCurrentArea:
	JSR LoadCurrentArea

	JSR LoadCurrentPalette

	JSR HideAllSprites

	JSR WaitForNMI

	JSR SetStack100Gameplay

	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	STA zPPUControl
	RTS

ClearLayoutAndPokeMusic:
	JSR ClearSubAreaTileLayout

	LDA #Music_Inside
	STA iMusicQueue
	LDA #$01
	STA iMusicID
	JMP loc_BANKF_E5E1

SubspaceGeneration:
	JSR GenerateSubspaceArea

	LDA iStarTimer
	CMP #$08
	BCS SubspaceGeneration_Starman

	LDA #Music_Subspace
	STA iMusicQueue

SubspaceGeneration_Starman:
	LDA #$04
	STA iMusicID
	RTS
