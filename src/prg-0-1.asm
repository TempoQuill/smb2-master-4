;
; Bank 0 & Bank 1
; ===============
;
; What's inside:
;
;   - Title screen
;   - Player controls
;   - Player state handling
;   - Enemy handling
;

;
; Initializes a vertical area
;
InitializeAreaVertical:
	LDA i502
	BNE loc_BANK0_805D

	LDA #HMirror
	JSR ChangeNametableMirroring

	LDA iCurrentLvlEntryPage
	BNE loc_BANK0_8013

loc_BANK0_800F:
	LDA #$09
	BNE loc_BANK0_8016

loc_BANK0_8013:
	SEC
	SBC #$01

loc_BANK0_8016:
	ORA #$C0
	STA zBGBufferBackward
	SEC
	SBC #$40
	STA zBGBuffer
	LDA iCurrentLvlEntryPage

loc_BANK0_8022:
	CLC
	ADC #$01
	CMP #$0A
	BNE loc_BANK0_802B

	LDA #$00

loc_BANK0_802B:
	ORA #$10
	STA zBGBufferForward
	LDA iCurrentLvlEntryPage
	LDY #$00
	JSR ResetPPUScrollHi

	LDA #$20
	STA zPPUDrawerRemains
	LDA #$60
	STA zPPUDrawerOffset

	; Set the flag for the initial screen render
	INC i502

	; Initialize the PPU update boundary
	LDA #$E0
	STA ze2
	LDA #$01
	STA ze4
	STA i53a
	LSR A
	STA zBigPPUDrawer + 1

	; Set the screen y-position
	LDY iCurrentLvlEntryPage
	JSR PageHeightCompensation
	STA zScreenY
	STY zScreenYPage

	; Cue player transition
	JSR ApplyAreaTransition

loc_BANK0_805D:
	LDA #$00
	STA z06
	LDA #$FF
	STA i505
	LDA #$A0
	STA iPPUBigScrollCheck + 1

	JSR sub_BANK0_823D

	LDA i53a
	BNE InitializeAreaVertical_Exit

	; Initial screen render is complete
	INC zBreakStartLevelLoop

	LDA #$E8
	STA ze1
	LDA #$C8
	STA ze2

	LDA #$00
	STA i502

InitializeAreaVertical_Exit:
	JMP EnsureCorrectMusic


;
; Applies vertical screen scrolling if `DetermineVerticalScroll` indicated that
; it was necessary.
;
ApplyVerticalScroll:
	LDA zScrollArray
	AND #%00000100
	BNE loc_BANK0_809D

	;	Not currently in a scroll interval
	LDA zScrollArray
	AND #%00000111
	BNE loc_BANK0_8092

	JMP loc_BANK0_819C

; ---------------------------------------------------------------------------

loc_BANK0_8092:
	LDA zScrollArray
	ORA #%00000100
	STA zScrollArray
	LDA #$12
	STA iCameraOSTiles

loc_BANK0_809D:
	LDA zScrollArray
	LSR A
	LDA zPPUScrollY
	BCC loc_BANK0_8103

	BNE loc_BANK0_80B1

	LDA zBGBufferBackward
	AND #$0F
	CMP #$09
	BNE loc_BANK0_80B1

	JMP loc_BANK0_819C

; ---------------------------------------------------------------------------

loc_BANK0_80B1:
	LDA #$01
	JSR SetObjectLocks

	LDA zPPUScrollY
	SEC
	SBC #$04
	STA zPPUScrollY
	LDA zScreenY
	SEC
	SBC #$04
	STA zScreenY
	BCS loc_BANK0_80C8

	DEC zScreenYPage

loc_BANK0_80C8:
	LDA zPPUScrollY
	CMP #$0FC
	BNE loc_BANK0_80DB

	LDA #$EC
	STA zPPUScrollY
	LDA zYScrollPage
	EOR #$02
	STA zYScrollPage
	LSR A
	STA zXScrollPage

loc_BANK0_80DB:
	LDA zPPUScrollY
	AND #$07
	BEQ loc_BANK0_80E2
	RTS

; ---------------------------------------------------------------------------

loc_BANK0_80E2:
	LDX #$00
	JSR loc_BANK0_8287

	INX
	JSR loc_BANK0_8287

	LDA zPPUScrollY
	AND #$0F
	BNE loc_BANK0_80FB

	LDX #$00
	JSR DecrementVerticalScrollRow

	LDX #$01
	JSR DecrementVerticalScrollRow

loc_BANK0_80FB:
	LDX #$01
	JSR PrepareBackgroundDrawing_Vertical

	JMP loc_BANK0_8170

; ---------------------------------------------------------------------------

loc_BANK0_8103:
	BNE loc_BANK0_8121

	LDA iCurrentLvlPages
	STA z0f
	CMP #$09
	BNE loc_BANK0_8114

	LDA #$00
	STA z0f
	BEQ loc_BANK0_8116

loc_BANK0_8114:
	INC z0f

loc_BANK0_8116:
	LDA zBGBufferForward
	AND #$0F
	CMP z0f
	BNE loc_BANK0_8121

	JMP loc_BANK0_819C

; ---------------------------------------------------------------------------

loc_BANK0_8121:
	LDA #$01
	JSR SetObjectLocks

	LDA zPPUScrollY
	CLC
	ADC #$04
	STA zPPUScrollY
	LDA zScreenY
	CLC
	ADC #$04
	STA zScreenY
	BCC loc_BANK0_8138

	INC zScreenYPage

loc_BANK0_8138:
	LDA zPPUScrollY
	AND #$07
	BEQ loc_BANK0_813F
	RTS

; ---------------------------------------------------------------------------

loc_BANK0_813F:
	LDA zPPUScrollY
	CMP #$F0
	BNE loc_BANK0_8152

	LDA #$00
	STA zPPUScrollY
	LDA zYScrollPage
	EOR #$02
	STA zYScrollPage
	LSR A
	STA zXScrollPage

loc_BANK0_8152:
	LDX #$02
	JSR sub_BANK0_828F

	DEX
	JSR sub_BANK0_828F

	LDA zPPUDrawerOffset
	AND #$20
	BNE loc_BANK0_816B

	LDX #$02
	JSR IncrementVerticalScrollRow

	LDX #$01
	JSR IncrementVerticalScrollRow

loc_BANK0_816B:
	LDX #$02
	JSR PrepareBackgroundDrawing_Vertical

loc_BANK0_8170:
	LDA iCameraOSTiles
	CMP #$12
	BNE loc_BANK0_818F

	LDA #$01
	STA ze4
	LDA zScrollArray
	LSR A
	BCC loc_BANK0_8186

; up
	LDX #$01
	LDA #$00
	BEQ loc_BANK0_818A

; down
loc_BANK0_8186:
	LDX #$02
	LDA #$10

loc_BANK0_818A:
	STA z01
	JSR sub_BANK0_8314

loc_BANK0_818F:
	; Update PPU for scrolling
	JSR CopyBackgroundToPPUBuffer_Vertical

	DEC iCameraOSTiles
	BNE locret_BANK0_81A0

	LDA #$00
	JSR SetObjectLocks

loc_BANK0_819C:
	LDA #$00
	STA zScrollArray

locret_BANK0_81A0:
	RTS


; ---------------------------------------------------------------------------
	.db $01


;
; Stashes screen scrolling information so that it can be restored after leaving
; the pause screen
;
StashScreenScrollPosition:
	LDA zPPUScrollY
	STA iPPUScrollY
	LDA zPPUScrollX
	STA iPPUScrollX
	LDA zYScrollPage
	STA iYScrollPage
	LDA zXScrollPage
	STA iXScrollPage
	LDA zScreenYPage
	STA iScreenYPage
	LDA zScreenY
	STA iScreenY
	LDA iBoundLeftUpper
	STA iBoundLeftUpper_Backup
	LDA ze1
	STA i517
	LDA #$00
	STA zPPUScrollY
	STA zPPUScrollX
	STA zYScrollPage
	STA zXScrollPage
	RTS


RestoreScreenScrollPosition:
	LDA iPPUScrollY
	STA zPPUScrollY
	LDA iPPUScrollX
	STA zPPUScrollX
	STA iBoundLeftLower
	LDA iYScrollPage
	STA zYScrollPage
	LDA iXScrollPage
	STA zXScrollPage
	LDA iBoundLeftUpper_Backup
	STA iBoundLeftUpper
	LDA iScreenYPage
	STA zScreenYPage
	LDA iScreenY
	STA zScreenY
	RTS


; Used for redrawing the screen in a vertical area after unpausing
sub_BANK0_81FE:
	LDA zBGBufferBackward
	AND #$10
	BEQ loc_BANK0_820B

	LDA ze1
	SEC
	SBC #$08
	STA ze1

loc_BANK0_820B:
	LDA #$01
	STA ze4
	LDA zBGBufferBackward
	STA zBGBuffer
	LDA #$10
	STA z01
	LDX #$00
	JSR sub_BANK0_8314

	LDA zPPUDrawerRemains
	STA zBigPPUDrawer + 1
	LDA ze1
	STA ze2
	LDX #$01
	JSR sub_BANK0_846A

	LDA #$F0
	STA iPPUBigScrollCheck
	STA iPPUBigScrollCheck + 1
	LDA zBGBufferForward
	STA i505
	INC zd5
	LDA #$01
	STA z06
	RTS


; Used for redrawing the background tiles in a vertical area
sub_BANK0_823D:
	; Clear the flag to indicate that we're drawing
	LDX #$00
	STX i537

	JSR PrepareBackgroundDrawing_Vertical

	; Update PPU for area init
	JSR CopyBackgroundToPPUBuffer_Vertical

	LDX #$00
	JSR sub_BANK0_828F

	LDA iPPUBigScrollCheck
	CMP zBigPPUDrawer
	BNE loc_BANK0_8277

	LDA iPPUBigScrollCheck + 1
	CLC
	ADC #$20
	CMP zBigPPUDrawer + 1
	BNE loc_BANK0_8277

loc_BANK0_825E:
	LDA z06
	TAX
	BEQ loc_BANK0_8268

	LDA i517
	STA ze1

loc_BANK0_8268:
	; Set the flag to indicate that we've finished drawing
	INC i537

	LDA #$00
	STA i53a, X
	STA i53d
	STA i53e
	RTS

; ---------------------------------------------------------------------------

loc_BANK0_8277:
	LDA zBigPPUDrawer + 1
	AND #$20
	BNE locret_BANK0_828E

	LDA zBGBuffer
	CMP i505
	BEQ loc_BANK0_825E

	JMP IncrementVerticalScrollRow

; ---------------------------------------------------------------------------

; Decrement tiles row
loc_BANK0_8287:
	LDA zPPUDrawerRemains, X
	SEC
	SBC #$20
	STA zPPUDrawerRemains, X

locret_BANK0_828E:
	RTS


; Increment tiles row
sub_BANK0_828F:
	LDA zBigPPUDrawer + 1, X
	CLC
	ADC #$20
	STA zBigPPUDrawer + 1, X
	RTS


;
; Decrement the drawing boundary table entry by one row of tiles
;
DecrementVerticalScrollRow:
	; Decrement the row offset
	LDA zBGBufferBackward, X
	SEC
	SBC #$10
	STA zBGBufferBackward, X
	AND #$F0
	CMP #$F0
	BNE DecrementVerticalScrollRow_Exit

	; Decrement the page
	LDA zBGBufferBackward, X
	AND #$0F
	CLC
	ADC #$E0
	STA zBGBufferBackward, X
	DEC zBGBufferBackward, X
	LDA zBGBufferBackward, X
	CMP #$DF
	BNE loc_BANK0_82B9

	; Wrap around to the last row of the last page
	LDA #$E9
	STA zBGBufferBackward, X

; @TODO: What's this doing, exactly?
loc_BANK0_82B9:
	LDA #$A0
	STA zPPUDrawerRemains, X

DecrementVerticalScrollRow_Exit:
	RTS


;
; Increment the drawing boundary table entry by one column of tiles
;
IncrementVerticalScrollRow:
	; Increment the row offset
	LDA zBGBuffer, X
	CLC
	ADC #$10
	STA zBGBuffer, X
	AND #$F0
	CMP #$F0
	BNE IncrementVerticalScrollRow_Exit

	; Increment the page
	LDA zBGBuffer, X
	AND #$0F
	STA zBGBuffer, X
	INC zBGBuffer, X
	LDA zBGBuffer, X
	CMP #$0A
	BNE loc_BANK0_82DD

	; Wrap around to the first row of the first page
	LDA #$00
	STA zBGBuffer, X

; @TODO: What's this doing, exactly?
loc_BANK0_82DD:
	LDA #$00
	STA zBigPPUDrawer + 1, X

IncrementVerticalScrollRow_Exit:
	RTS


;
; Determines which background tiles from the decoded level data to draw to the
; screen and where to draw them for vertical areas.
;
; ##### Input
; - `zBGBuffer`: drawing boundary table
; - `X`: drawing boundary index (`$00` = full, `$01` = up, `$02` = down)
;
; ##### Output
; - `zLevelDataPointer`: decoded level data address
; - `zLevelDataOffset`: level data offset
; - `zBigPPUDrawer`: PPU start address
;
PrepareBackgroundDrawing_Vertical:
	; Lower nybble is used for page
	LDA zBGBuffer, X
	AND #$0F
	TAY
	; Get the address of the decoded level data
	LDA DecodedLevelPageStartLo_Bank1, Y
	STA zLevelDataPointer
	LDA DecodedLevelPageStartHi_Bank1, Y
	STA zLevelDataPointer + 1

	; Upper nybble is used for the tile offset (rows)
	LDA zBGBuffer, X
	AND #$F0
	STA zLevelDataOffset

	; Determine where on the screen we should draw the tile
	LDA zBGBuffer, X
	LSR A
	BCC PrepareBackgroundDrawing_Vertical_Nametable2800

	LDA #$20
	BNE PrepareBackgroundDrawing_Vertical_SetNametableHi

PrepareBackgroundDrawing_Vertical_Nametable2800:
	LDA #$28

PrepareBackgroundDrawing_Vertical_SetNametableHi:
	STA zBigPPUDrawer

	LDA zBGBuffer, X
	AND #$C0
	ASL A
	ROL A
	ROL A
	ADC zBigPPUDrawer
	STA zBigPPUDrawer

	LDA zBigPPUDrawer + 1, X
	STA zBigPPUDrawer + 1

PrepareBackgroundDrawing_Vertical_Exit:
	RTS


;
; =============== S U B R O U T I N E =======================================
;
sub_BANK0_8314:
	LDA zBGBuffer, X
	AND #$10
	BEQ PrepareBackgroundDrawing_Vertical_Exit

	LDA zBGBuffer, X
	STA z03
	SEC
	SBC z01
	STA zBGBuffer, X
	JSR PrepareBackgroundDrawing_Vertical

; loop through tiles to generate PPU attribute data
loc_BANK0_8326:
	LDA #$0F
	STA zAttrUpdateIndex
	LDA #$00
	STA zBGBufferSize

loc_BANK0_832E:
	JSR ReadNextTileAndSetPaletteInPPUAttribute

	LDA zAttrUpdateIndex
	BPL loc_BANK0_832E

	LDA z03
	STA zBGBuffer, X
	DEC ze4
	JMP PrepareBackgroundDrawing_Vertical


;
; This draws ground tiles to the PPU buffer
;
; ##### Input
; - `i300`: offset in PPU buffer
; - `zBigPPUDrawer`: PPU start address
; - `zLevelDataPointer`: decoded level data address
; - `zLevelDataOffset`: level data offset
;
CopyBackgroundToPPUBuffer_Vertical:
	; Set the PPU start address (ie. where we're going to draw tiles)
	LDX i300
	LDA zBigPPUDrawer
	STA iPPUBuffer, X
	INX
	LDA zBigPPUDrawer + 1
	STA iPPUBuffer, X
	INX

	; We're going to draw a full row of tiles on the screen
	LDA #$20
	STA iPPUBuffer, X

	; Prepare the counters
	INX
	LDA #$00
	STA zBGBufferSize
	LDA #$0F
	STA zAttrUpdateIndex

	LDA zd5
	BEQ CopyBackgroundToPPUBuffer_Vertical_Loop

	LDY zLevelDataOffset
	CPY #$E0
	BNE CopyBackgroundToPPUBuffer_Vertical_Loop

	LDA #$00
	STA ze4
	INC iBottomRowField

CopyBackgroundToPPUBuffer_Vertical_Loop:
	LDY zLevelDataOffset
	LDA (zLevelDataPointer), Y
	STA iTileID
	AND #%11000000
	ASL A
	ROL A
	ROL A
	TAY
	; Get the tile quad pointer
	LDA TileQuadPointersLo, Y
	STA z00
	LDA TileQuadPointersHi, Y
	STA z01
	LDY zLevelDataOffset
	LDA (zLevelDataPointer), Y
	ASL A
	ASL A
	TAY
	LDA zd5
	BEQ loc_BANK0_8390

	INY
	INY

loc_BANK0_8390:
	; Write the tile to the PPU buffer
	LDA (z00), Y
	STA iPPUBuffer, X
	INC zBGBufferSize
	INX
	INY
	LDA zBGBufferSize
	LSR A
	BCS loc_BANK0_8390

	INC zLevelDataOffset
	LDA zd5
	BEQ loc_BANK0_83A7

	JSR SetTilePaletteInPPUAttribute

loc_BANK0_83A7:
	; Did we finish drawing the row yet?
	LDA zBGBufferSize
	CMP #$20
	BCC CopyBackgroundToPPUBuffer_Vertical_Loop

	LDA #$00
	STA iPPUBuffer, X
	STX i300
	LDA zd5
	BEQ loc_BANK0_840B

	LDA ze4
	BEQ loc_BANK0_83C2

	DEC ze4
	JMP loc_BANK0_83DE

; ---------------------------------------------------------------------------

loc_BANK0_83C2:
	LDA zScrollArray
	LSR A
	BCS loc_BANK0_83D4

; down
	LDX #$01
	JSR CopyBackgroundAttributesToPPUBuffer_Vertical

	LDX #$01
	JSR sub_BANK0_846A

	JMP loc_BANK0_83DE

; up
loc_BANK0_83D4:
	LDX #$00
	JSR CopyBackgroundAttributesToPPUBuffer_Vertical

	LDX #$00
	JSR sub_BANK0_8478

loc_BANK0_83DE:
	LDX #$00
	LDA zScrollArray
	LSR A
	BCC loc_BANK0_83FA

; up
	INX
	LDA zBGBufferBackward, X
	AND #$F0
	CMP #$E0
	BEQ loc_BANK0_83F4

	LDA zBGBufferBackward, X
	AND #$10
	BNE loc_BANK0_840B

loc_BANK0_83F4:
	JSR sub_BANK0_8478

	JMP loc_BANK0_840B

; down
loc_BANK0_83FA:
	LDA zBGBufferBackward, X
	AND #$F0
	CMP #$E0
	BEQ loc_BANK0_8408

	LDA zBGBufferBackward, X
	AND #$10
	BEQ loc_BANK0_840B

loc_BANK0_8408:
	JSR sub_BANK0_846A

loc_BANK0_840B:
	LDA zd5
	EOR #$01
	STA zd5
	RTS


;
; This draws ground background attributes to the PPU buffer
;
CopyBackgroundAttributesToPPUBuffer_Vertical:
	LDY i300
	; Setting the attribute address to update
	LDA zBigPPUDrawer
	ORA #$03
	STA iPPUBuffer, Y
	INY
	LDA ze1, X
	STA iPPUBuffer, Y
	INY
	; We're updating 8 blocks of attribute data
	LDA #$08
	STA iPPUBuffer, Y
	INY

	LDX #$07
CopyBackgroundAttributesToPPUBuffer_Vertical_Loop:
	LDA iBottomRowField
	BEQ CopyBackgroundAttributesToPPUBuffer_Vertical_FullRow

CopyBackgroundAttributesToPPUBuffer_Vertical_HalfRow:
	; Bottom row of PPU attributes has half-sized blocks
  ; Shift background palettes down one quad
	LDA zScrollBuffer, X
	LSR A
	LSR A
	LSR A
	LSR A
	STA zScrollBuffer, X
	JMP CopyBackgroundAttributesToPPUBuffer_Vertical_Next

CopyBackgroundAttributesToPPUBuffer_Vertical_FullRow:
	LDA zScrollArray
	LSR A
	BCC CopyBackgroundAttributesToPPUBuffer_Vertical_Next

CopyBackgroundAttributesToPPUBuffer_Vertical_Reverse:
	; Swap palettes for upper and lower background quads, since tiles are drawn
	; in the reverse order when scrolling up
	LDA zScrollBuffer, X
	ASL A
	ASL A
	ASL A
	ASL A
	STA z01
	LDA zScrollBuffer, X
	LSR A
	LSR A
	LSR A
	LSR A
	ORA z01
	STA zScrollBuffer, X

CopyBackgroundAttributesToPPUBuffer_Vertical_Next:
	LDA zScrollBuffer, X
	STA iPPUBuffer, Y
	INY
	DEX
	BPL CopyBackgroundAttributesToPPUBuffer_Vertical_Loop

	LDA #$01
	STA ze4
	LSR A
	STA iBottomRowField
	STA iPPUBuffer, Y
	STY i300
	RTS


; Increment attributes row
sub_BANK0_846A:
	LDA ze1, X
	CLC
	ADC #$08
	STA ze1, X
	BCC locret_BANK0_8477

	LDA #$C0
	STA ze1, X

locret_BANK0_8477:
	RTS


; Decrement attributes row
sub_BANK0_8478:
	LDA ze1, X
	SEC
	SBC #$08
	STA ze1, X
	CMP #$C0
	BCS locret_BANK0_8487

	LDA #$F8
	STA ze1, X

locret_BANK0_8487:
	RTS


;
; Sets the palette for the tile in the current PPU attribute block.
; We effectively write these two bits at a time, since each attribute block
; contains four background tiles.
;
; This subroutine is only used in vertical areas.
;
; ##### Input
; - `iTileID`: tile ID to use for the palette
; - `zAttrUpdateIndex`: determines index to update in buffer
;
SetTilePaletteInPPUAttribute:
	LDA zAttrUpdateIndex
	LSR A
	TAY
	; Shift two bits to the right to make room for the next tile
	LDA zScrollBuffer, Y
	LSR A
	LSR A
	STA zScrollBuffer, Y
	; Load the color for the next tile and apply it to the attribute value
	LDA iTileID
	AND #%11000000
	ORA zScrollBuffer, Y
	STA zScrollBuffer, Y

	; Move on to the next block
	DEC zAttrUpdateIndex
	RTS


; Unused?
_code_04A2:
	LDX #$07
	LDA #$00

; Unused?
loc_BANK0_84A6:
	STA zScrollBuffer, X
	DEX
	BNE loc_BANK0_84A6
	RTS


;
; Loads a background tile from the level data and determines its PPU attribute data
;
; ##### Input
; - `zLevelDataPointer`: decoded level data address
;
; ##### Output
; - `iTileID` - tile ID
;
ReadNextTileAndSetPaletteInPPUAttribute:
sub_BANK0_84AC:
	LDY zLevelDataOffset
	LDA (zLevelDataPointer), Y
	STA iTileID
	INC zLevelDataOffset
	JMP SetTilePaletteInPPUAttribute


;
; Initializes a horizontal area
;
InitializeAreaHorizontal:
	LDA i502
	BNE loc_BANK0_855C

	LDA #VMirror
	JSR ChangeNametableMirroring

	JSR ApplyAreaTransition

	LDA #$00
	STA zPPUScrollY

	LDA iCurrentLvlEntryPage
	BNE loc_BANK0_851A

	LDA #$09
	BNE loc_BANK0_851D

loc_BANK0_851A:
	SEC
	SBC #$01

loc_BANK0_851D:
	ORA #$D0
	STA zBGBufferBackward
	SEC
	SBC #$20
	STA zBGBuffer
	LDA iCurrentLvlEntryPage
	CLC
	ADC #$01
	CMP #$0A
	BNE loc_BANK0_8532

	LDA #$00

loc_BANK0_8532:
	ORA #$10
	STA zBGBufferForward
	LDA iCurrentLvlEntryPage
	LDY #$01
	JSR ResetPPUScrollHi

	; Set the flag for the initial screen render
	INC i502

	; Set the screen x-position
	LDA iCurrentLvlEntryPage
	STA iBoundLeftUpper

	; Initialize the PPU update boundary
	LDA #$01
	STA i53a
	LSR A
	STA z06
	LDA #$FF
	STA i505
	LDA #$0F
	STA iPPUBigScrollCheck + 1

	JSR sub_BANK0_856A

loc_BANK0_855C:
	JSR sub_BANK0_87AA

	LDA i53a
	BNE InitializeAreaHorizontal_Exit

	STA i502
	INC zBreakStartLevelLoop

InitializeAreaHorizontal_Exit:
	JMP EnsureCorrectMusic


; =============== S U B R O U T I N E =======================================

sub_BANK0_856A:
	LDA iCurrentLvlEntryPage
	BNE loc_BANK0_8576

	LDA zXVelocity
	BMI loc_BANK0_85E7

	LDA iCurrentLvlEntryPage

loc_BANK0_8576:
	CMP iCurrentLvlPages
	BNE loc_BANK0_857F

	LDA zXVelocity
	BPL loc_BANK0_85E7

loc_BANK0_857F:
	LDX #$02
	LDA zXVelocity
	BPL loc_BANK0_858B

	LDA #$FF
	STA z0b
	BNE loc_BANK0_858F

loc_BANK0_858B:
	LDA #$00
	STA z0b

loc_BANK0_858F:
	LDA zXVelocity
	AND #$F0
	CLC
	ADC zBGBuffer, X
	PHP
	ADC z0b
	PLP
	STA z0c
	LDA z0b
	BNE loc_BANK0_85B1

	BCC loc_BANK0_85C2

	LDA zBGBuffer, X
	AND #$0F
	CMP #$09
	BNE loc_BANK0_85C2

	LDA z0c
	AND #$F0
	JMP loc_BANK0_85C4

; ---------------------------------------------------------------------------

loc_BANK0_85B1:
	BCS loc_BANK0_85C2

	LDA zBGBuffer, X
	AND #$0F
	BNE loc_BANK0_85C2

	LDA z0c
	AND #$F0
	ADC #$09
	JMP loc_BANK0_85C4

; ---------------------------------------------------------------------------

loc_BANK0_85C2:
	LDA z0c

loc_BANK0_85C4:
	STA zBGBuffer, X
	DEX
	BPL loc_BANK0_858F

	LDA zXVelocity
	STA zPPUScrollX
	STA iBoundLeftLower
	AND #$F0
	STA iCurrentLvlPageX
	LDA zXVelocity
	BPL loc_BANK0_85E7

	DEC iBoundLeftUpper
	LDA zXScrollPage
	EOR #$01
	STA zXScrollPage
	LDA #$01
	STA iPPUBigScrollCheck + 1

loc_BANK0_85E7:
	LDA #$00
	STA zXVelocity
	RTS

; End of function sub_BANK0_856A


;
; Applies horizontal screen scrolling.
;
; Unlike vertical scrolling, horizontal scrolling can happen continuously as
; the player moves left and right.
;
;
;
ApplyHorizontalScroll:
	; Reset the PPU tile update flag
	LDA #$00
	STA iScrollUpdateQueue

	; Are we scrolling in more tiles?
	LDA iHorScrollDir
	BEQ ApplyHorizontalScroll_CheckMoveCameraX

	; Which direction?
	LDA iHorScrollDir
	LSR A
	BCS ApplyHorizontalScroll_Left

ApplyHorizontalScroll_Right:
	LDX #$02
	STX z09
	LDA #$10
	STA z01
	DEX
	LDA iHorScrollDir
	STA zScrollArray
	JSR CopyAttributesToHorizontalBuffer

	LDA z03
	STA zBGBufferForward
	LDA #$00
	STA iHorScrollDir
	BEQ ApplyHorizontalScroll_CheckMoveCameraX

ApplyHorizontalScroll_Left:
	LDX #$01
	STX z09
	DEX
	STX z01
	LDA iHorScrollDir
	STA zScrollArray
	JSR CopyAttributesToHorizontalBuffer

	LDA #$00
	STA iHorScrollDir

ApplyHorizontalScroll_CheckMoveCameraX:
	LDA zXVelocity
	BNE ApplyMoveCameraX
	RTS


ApplyMoveCameraX:
	LDA zXVelocity
	BPL ApplyMoveCameraX_Right

ApplyMoveCameraX_ScrollLeft:
	LDA #$01
	STA zScrollArray

	; Weird `JMP`, but okay...
	JMP ApplyMoveCameraX_Left

ApplyMoveCameraX_Right:
	LDA #$02
	STA zScrollArray

	LDX zXVelocity
ApplyMoveCameraX_Right_Loop:
	LDA zPPUScrollX
	BNE loc_BANK0_8651

	LDA iBoundLeftUpper
	CMP iCurrentLvlPages
	BNE loc_BANK0_8651

	; Can't scroll past beyond the last page of the area
	JMP ApplyMoveCameraX_Exit

; Scrolling one pixel at a time in a tight loop seems crazy at first, but in
; practice it only ends up being like 3 iterations at most.
ApplyMoveCameraX_Right_AddPixel:
loc_BANK0_8651:
	LDA zPPUScrollX
	CLC
	ADC #$01
	STA zPPUScrollX
	STA iBoundLeftLower
	BCC loc_BANK0_8669

	INC iBoundLeftUpper
	LDA zXScrollPage
	EOR #$01
	STA zXScrollPage
	ASL A
	STA zYScrollPage

loc_BANK0_8669:
	LDA iBoundLeftUpper
	CMP iCurrentLvlPages
	BEQ loc_BANK0_8685

	LDA zPPUScrollX
	AND #$F0
	CMP iCurrentLvlPageX
	BEQ ApplyMoveCameraX_Right_Next

	STA iCurrentLvlPageX
	LDA #$01
	STA iScrollUpdateQueue

ApplyMoveCameraX_Right_Next:
	DEX
	BNE ApplyMoveCameraX_Right_Loop

loc_BANK0_8685:
	LDA iScrollUpdateQueue
	BEQ ApplyMoveCameraX_Exit

	LDX #$02
loc_BANK0_868C:
	JSR IncrementHorizontalScrollColumn

	DEX
	BNE loc_BANK0_868C

	LDX #$02
	JSR PrepareBackgroundDrawing_Horizontal

	JMP loc_BANK0_86E6


ApplyMoveCameraX_Left:
	LDX zXVelocity
ApplyMoveCameraX_Left_Loop:
	LDA zPPUScrollX
	BNE loc_BANK0_86A8

	LDA iBoundLeftUpper
	BNE loc_BANK0_86A8

	; Can't scroll past beyond the first page of the area
	JMP ApplyMoveCameraX_Exit

loc_BANK0_86A8:
	LDA zPPUScrollX
	SEC
	SBC #$01
	STA zPPUScrollX
	STA iBoundLeftLower
	BCS loc_BANK0_86C0

	DEC iBoundLeftUpper
	LDA zXScrollPage
	EOR #$01
	STA zXScrollPage
	ASL A
	STA zYScrollPage

loc_BANK0_86C0:
	LDA zPPUScrollX
	AND #$F0
	CMP iCurrentLvlPageX
	BEQ loc_BANK0_86D1

	STA iCurrentLvlPageX
	LDA #$01
	STA iScrollUpdateQueue

loc_BANK0_86D1:
	INX
	BNE ApplyMoveCameraX_Left_Loop

	LDA iScrollUpdateQueue
	BEQ ApplyMoveCameraX_Exit

	LDX #$02
loc_BANK0_86DB:
	JSR DecrementHorizontalScrollColumn

	DEX
	BNE loc_BANK0_86DB

	LDX #$01
	JSR PrepareBackgroundDrawing_Horizontal

loc_BANK0_86E6:
	JSR CopyBackgroundToPPUBuffer_Horizontal

ApplyMoveCameraX_Exit:
	LDA #$00
	STA zScrollArray
	RTS


;
; Resets the PPU high scrolling values and sets the high byte of the PPU scroll offset.
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
ResetPPUScrollHi:
	LSR A
	BCS ResetPPUScrollHi_NametableB

ResetPPUScrollHi_NametableA:
	LDA #$01
	STA zXScrollPage
	ASL A
	STA zYScrollPage
	LDA #$20
	BNE ResetPPUScrollHi_Exit

ResetPPUScrollHi_NametableB:
	LDA #$00
	STA zXScrollPage
	STA zYScrollPage
	LDA PPUScrollHiOffsets, Y

ResetPPUScrollHi_Exit:
	STA iPPUBigScrollCheck
	RTS


;
; High byte of the PPU scroll offset for nametable B.
;
; When mirroring vertically, nametable A is `$2000` and nametable B is `$2800`.
; When mirroring horizontally, nametable A is `$2000` and nametable B is `$2400`.
;
PPUScrollHiOffsets:
	.db $28 ; vertical
	.db $24 ; horizontal


; The sub-area "page" is the index in the DecodedLevelPageStart table.
; This is why there are 10 blank pages in the jar enemy data.
SubAreaPage:
	.db $0A


; Stash the PPU scrolling data from the main area and rest it for the subarea
UseSubareaScreenBoundaries:
	LDA zPPUScrollX
	STA iPPUScrollX
	LDA zXScrollPage
	STA iXScrollPage
	LDA iBoundLeftUpper
	STA iBoundLeftUpper_Backup
	INC i53d
	LDA SubAreaPage
	STA iCurrentLvlEntryPage
	JSR ResetPPUScrollHi

	LDA #$00
	STA zPPUScrollX
	STA iBoundLeftLower
	LDA SubAreaPage
	STA iBoundLeftUpper

	JSR ApplyAreaTransition

	LDA SubAreaPage
	STA zBGBuffer
	LDA #$E0
	STA iPPUBigScrollCheck
	LDA SubAreaPage
	CLC
	ADC #$F0
	STA i505
	RTS


; Restore the PPU scrolling data for the main area
UseMainAreaScreenBoundaries:
	LDA iPPUScrollX
	STA zPPUScrollX
	STA iBoundLeftLower
	LDA iXScrollPage
	STA zXScrollPage
	LDA iBoundLeftUpper_Backup
	STA iBoundLeftUpper
	LDA i53d
	BNE UseMainAreaScreenBoundaries_Exit

	INC i53e
	INC i53d
	INC zd5
	JSR RestorePlayerPosition

	LDA zBGBufferBackward
	STA zBGBuffer
	LDA #$10
	STA z01
	LDA #$F0
	STA iPPUBigScrollCheck
	STA iPPUBigScrollCheck + 1
	LDA zBGBufferForward
	STA i505

UseMainAreaScreenBoundaries_Exit:
	RTS


; Used for redrawing the screen in a horizontal area after unpausing
sub_BANK0_8785:
	LDA zBGBufferBackward
	STA zBGBuffer
	LDA #$10
	STA z01
	LDA #$F0
	STA iPPUBigScrollCheck
	STA iPPUBigScrollCheck + 1
	LDA zBGBufferForward
	CLC
	ADC #$10
	ADC #$00
	CMP #$0A
	BNE loc_BANK0_87A2

	LDA #$00

loc_BANK0_87A2:
	STA i505
	LDA #$01
	STA z06
	RTS

; Used for redrawing the background tiles in a horizontal area
sub_BANK0_87AA:
	LDX #$00
	STX i537
	STX iScrollUpdateQueue
	STX zScrollArray

	JSR PrepareBackgroundDrawing_Horizontal

	JSR CopyBackgroundToPPUBuffer_Horizontal

	LDA iPPUBigScrollCheck
	CMP zBigPPUDrawer
	BNE loc_BANK0_87DA

	LDA iPPUBigScrollCheck + 1
	CLC
	ADC #$01
	CMP zBigPPUDrawer + 1
	BNE loc_BANK0_87DA

loc_BANK0_87CB:
	LDA #$00
	STA i53a
	STA i53d
	STA i53e
	INC i537
	RTS

; ---------------------------------------------------------------------------

loc_BANK0_87DA:
	LDA zBGBuffer
	CMP i505
	BEQ loc_BANK0_87CB

	LDX #$00
	JMP IncrementHorizontalScrollColumn

;
; Decrement the drawing boundary table entry by one column of tiles
;
DecrementHorizontalScrollColumn:
	; Decrement the column offset
	LDA zBGBuffer, X
	SEC
	SBC #$10
	STA zBGBuffer, X
	BCS DecrementHorizontalScrollColumn_Exit

	; Decrement the page
	DEC zBGBuffer, X
	LDA zBGBuffer, X
	CMP #$EF
	BNE DecrementHorizontalScrollColumn_Exit

	; Wrap around to the last column of the last page
	LDA #$F9
	STA zBGBuffer, X

DecrementHorizontalScrollColumn_Exit:
	RTS


;
; Increment the drawing boundary table entry by one column of tiles
;
IncrementHorizontalScrollColumn:
	; Increment the column offset
	LDA zBGBuffer, X
	CLC
	ADC #$10
	STA zBGBuffer, X
	BCC IncrementHorizontalScrollColumn_Exit

	; Increment the page
	INC zBGBuffer, X
	LDA zBGBuffer, X
	CMP #$0A
	BNE IncrementHorizontalScrollColumn_Exit

	; Wrap around to the first page
	LDA #$00
	STA zBGBuffer, X

IncrementHorizontalScrollColumn_Exit:
	RTS


;
; Determines which background tiles from the decoded level data to draw to the
; screen and where to draw them for horizontal areas.
;
; ##### Input
; - `zBGBuffer`: drawing boundary table
; - `X`: drawing boundary index (`$00` = full, `$01` = left, `$02` = right)
;
; ##### Output
; - `zLevelDataPointer`: decoded level data address
; - `zLevelDataOffset`: level data offset
; - `zBigPPUDrawer`: PPU start address
;
PrepareBackgroundDrawing_Horizontal:
	; Stash Y so we can restore it later
	STY z0f

	; Lower nybble is used for page
	LDA zBGBuffer, X
	AND #$0F
	TAY
	; Get the address of the decoded level data
	LDA DecodedLevelPageStartLo_Bank1, Y
	STA zLevelDataPointer
	LDA DecodedLevelPageStartHi_Bank1, Y
	STA zLevelDataPointer + 1

	; Upper nybble is used for the tile offset (columns)
	LDA zBGBuffer, X
	LSR A
	LSR A
	LSR A
	LSR A
	STA zLevelDataOffset

	; Determine where on the screen we should draw the tile
	ASL A
	STA zBigPPUDrawer + 1

	LDY #$20
	LDA zBGBuffer, X
	LSR A
	BCS PrepareBackgroundDrawing_Horizontal_Exit

	LDY #$24

PrepareBackgroundDrawing_Horizontal_Exit:
	STY zBigPPUDrawer

	; Restore original Y value
	LDY z0f
	RTS


;
; horizontal
;
sub_BANK0_883C:
	STX z08
	LDX z09
	LDY #$02
	LDA zBGBuffer, X
	STA z03
	SEC
	SBC z01
	STA zBGBuffer, X

	JSR PrepareBackgroundDrawing_Horizontal

	LDA #$07
	STA zAttrUpdateIndex
	LDA #$00
	STA zBGBufferSize

loc_BANK0_8856:
	JSR sub_BANK0_8925

	LDA zAttrUpdateIndex
	BPL loc_BANK0_8856

	LDA zBigPPUDrawer + 1
	AND #$1C
	LSR A
	LSR A
	ORA #$C0
	STA iBigDrawerAttrPointer + 1
	LDA zBigPPUDrawer
	ORA #$03
	STA iBigDrawerAttrPointer
	LDX z08
	RTS


;
; Draws the background data to the PPU buffer
;
CopyBackgroundToPPUBuffer_Horizontal:
	LDA #$0F
	STA zAttrUpdateIndex

	LDA #$00
	STA zBGBufferSize
	STA zd5
	TAX
CopyBackgroundToPPUBuffer_Horizontal_Loop:
	LDY zLevelDataOffset
	LDA (zLevelDataPointer), Y
	STA iTileID
	AND #%11000000
	ASL A
	ROL A
	ROL A
	TAY
	; Get the tile quad pointer
	LDA TileQuadPointersLo, Y
	STA z00
	LDA TileQuadPointersHi, Y
	STA z01

	LDY zLevelDataOffset
	LDA (zLevelDataPointer), Y
	ASL A
	ASL A
	TAY
	LDA zd5
	BEQ loc_BANK0_88A0

	INY

loc_BANK0_88A0:
	LDA (z00), Y
	STA iScrollTileBuffer, X
	INY
	LDA (z00), Y
	STA iScrollTileBuffer + $1E, X
	INY
	LDA (z00), Y
	STA iScrollTileBuffer + $01, X
	INY
	LDA (z00), Y
	STA iScrollTileBuffer + $1F, X
	INC zBGBufferSize
	INX
	INX
	LDA zLevelDataOffset
	CLC
	ADC #$10
	STA zLevelDataOffset
	LDA zBGBufferSize
	CMP #$0F
	BCC CopyBackgroundToPPUBuffer_Horizontal_Loop

	LDA #$00
	STA iBigDrawerAttrPointer
	LDA zScrollArray
	LSR A
	BCS loc_BANK0_88F2

; down
	LDA zBigPPUDrawer + 1
	AND #$02
	BEQ loc_BANK0_88FD

	LDA zScrollArray
	BNE loc_BANK0_88F8

	LDA #$10
	STA z01
	LDX #$00
	STX z09
	INX
	JSR CopyAttributesToHorizontalBuffer

	LDA z03
	STA zBGBuffer
	JSR PrepareBackgroundDrawing_Horizontal

	JMP loc_BANK0_88FD

; up
loc_BANK0_88F2:
	LDA zBigPPUDrawer + 1
	AND #$02
	BNE loc_BANK0_88FD

loc_BANK0_88F8:
	LDA zScrollArray
	STA iHorScrollDir

loc_BANK0_88FD:
	INC iScrollUpdateQueue
	RTS


;
; Does some kind of transformation to copy PPU attribute data from the common
; scrolling PPU update buffer to the horizontal-only buffer.
;
; I'm not totally sure why it is necessary to do this rather than writing the
; attribute data in the final order the first time?
;
; NOTE: There is code that assumes `X = $00` after running this subroutine!
;
CopyAttributesToHorizontalBuffer:
	JSR sub_BANK0_883C

	LDX #$07
	STX z0e
	LDY #$00
CopyAttributesToHorizontalBuffer_Loop:
	LDX z0e
	LDA zScrollBuffer, X
	STA iHorScrollBuffer, Y
	INY
	DEX
	DEX
	DEX
	DEX
	LDA zScrollBuffer, X
	STA iHorScrollBuffer, Y
	INY
	DEC z0e
	LDA z0e
	CMP #03
	BNE CopyAttributesToHorizontalBuffer_Loop
	RTS


;
; Determines the PPU attribute data for a group of four tiles in a horizontal area.
; Reads a group of four background tiles to determine the PPU attribute data
;
sub_BANK0_8925:
	STY z0f
	LDA #01
	STA z04
	LDY zLevelDataOffset
	LDX zAttrUpdateIndex

loc_BANK0_892F:
	LDA zScrollBuffer, X
	LSR A
	LSR A
	STA zScrollBuffer, X
	LDA (zLevelDataPointer), Y
	AND #%11000000
	ORA zScrollBuffer, X
	STA zScrollBuffer, X
	INY
	LDA zScrollBuffer, X
	LSR A
	LSR A
	STA zScrollBuffer, X
	LDA (zLevelDataPointer), Y
	AND #%11000000
	ORA zScrollBuffer, X
	STA zScrollBuffer, X
	LDA zLevelDataOffset
	CLC
	ADC #$10
	TAY
	STA zLevelDataOffset
	DEC z04
	BPL loc_BANK0_892F

	DEC zAttrUpdateIndex
	LDY z0f
	RTS


SetObjectLocks:
	LDX #$07

SetObjectLocks_Loop:
	STA iObjectLock - 1, X
	DEX
	BPL SetObjectLocks_Loop
	RTS


GrowShrinkSFXIndexes:
	.db SoundEffect2_Shrinking
	.db SoundEffect2_Growing


HandlePlayerState:
	LDA zPlayerState ; Handles player states?
	CMP #PlayerState_Lifting
	BCS loc_BANK0_8A26 ; If the player is changing size, just handle that

	LDA #$00 ; Check if the player needs to change size
	LDY #$10
	CPY iPlayerHP
	ROL A
	EOR iCurrentPlayerSize
	BEQ loc_BANK0_8A26

	LDY iCurrentPlayerSize
	BEQ loc_Shrinking

	LDA GrowShrinkSFXIndexes, Y
	STA iHillSFX
	BNE loc_ChangeSize
loc_Shrinking:
	LDA GrowShrinkSFXIndexes, Y
	STA iPulse1SFX

loc_ChangeSize:
	LDA #$1E
	STA zPlayerStateTimer
	LDA #PlayerState_ChangingSize
	STA zPlayerState

loc_BANK0_8A26:
	LDA #ObjAttrib_Palette0
	STA zPlayerAttributes
	LDA zPlayerState
	JSR JumpToTableAfterJump ; Player state handling?

	.dw HandlePlayerState_Normal ; Normal
	.dw HandlePlayerState_Climbing ; Climbing
	.dw HandlePlayerState_Lifting ; Lifting
	.dw HandlePlayerState_ClimbingAreaTransition ; Climbing area transition
	.dw HandlePlayerState_GoingDownJar ; Going down jar
	.dw HandlePlayerState_ExitingJar ; Exiting jar
	.dw HandlePlayerState_HawkmouthEating ; Hawkmouth eating
	.dw HandlePlayerState_Dying ; Dying
	.dw HandlePlayerState_ChangingSize ; Changing size


HandlePlayerState_Normal:
	JSR PlayerGravity

	; player animation frame, crouch jump charging
	JSR sub_BANK0_8C1A

	; maybe only y-collision?
	JSR PlayerTileCollision

	; screen boundary x-collision
	JSR PlayerAreaBoundaryCollision

	JSR ApplyPlayerPhysicsY


;
; Applies player physics on the x-axis
;
ApplyPlayerPhysicsX:
	LDX #$00
	JSR ApplyPlayerPhysics

	LDA zScrollCondition
	BNE ApplyPlayerPhysicsX_Exit

	STA zPlayerXHi

ApplyPlayerPhysicsX_Exit:
	RTS


;
; What goes up must come down
;
HandlePlayerState_Dying:
	LDA zPlayerStateTimer
	BNE locret_BANK0_8A86

	LDA iPlayerScreenYPage
	CMP #02
	BNE HandlePlayerState_DyingPhysics

	LDA iCurrentMusic
	BNE locret_BANK0_8A86
	BEQ LoseALife

HandlePlayerState_DyingPhysics:
	JSR ApplyPlayerPhysicsY

	LDA zPlayerYVelocity
	BMI loc_BANK0_8A72

	CMP #$39
	BCS locret_BANK0_8A86

loc_BANK0_8A72:
	INC zPlayerYVelocity
	INC zPlayerYVelocity
	RTS

; ---------------------------------------------------------------------------

LoseALife:
	LDA #02
	STA zPlayerAnimFrame
	LDY #$01 ; Set game mode to title card
	DEC iExtraMen
	BNE SetGameModeAfterDeath

	INY ; If no lives, increase game mode
; from 1 (title card) to 2 (game over)

SetGameModeAfterDeath:
	STY iGameMode

locret_BANK0_8A86:
	RTS

; ---------------------------------------------------------------------------

HandlePlayerState_Lifting:
	LDA zPlayerStateTimer
	BNE locret_BANK0_8AC1

	LDX iHeldItemIndex
	LDY zHeldObjectTimer, X
	CPY #$02
	BCC loc_BANK0_8ABB

	CPY #$07
	BNE loc_BANK0_8A9D

	LDA zObjectType, X
	TAX
	LDA PickupSounds, X
	LDX iHeldItemIndex
	STA iDPCMSFX

loc_BANK0_8A9D:
	DEC zHeldObjectTimer, X
	LDA PlayerLiftFrames, Y
	STA zPlayerAnimFrame
	LDA zEnemyState, X
	CMP #$06
	BEQ loc_BANK0_8AB0

	LDA zObjectType, X
	CMP #Enemy_VegetableSmall
	BNE loc_BANK0_8AB5

loc_BANK0_8AB0:
	LDA PlayerLiftTimer - 2, Y
	BPL loc_BANK0_8AB8

loc_BANK0_8AB5:
	LDA iPickupSpeed - 2, Y

loc_BANK0_8AB8:
	STA zPlayerStateTimer
	RTS

; ---------------------------------------------------------------------------

loc_BANK0_8ABB:
	STA zPlayerState
	INC zPlayerGrounding

loc_BANK0_8ABF:
	INC zPlayerHitBoxHeight

locret_BANK0_8AC1:
	RTS


PlayerLiftTimer:
	.db $00
	.db $01
	.db $01
	.db $01

PlayerLiftFrames:
	.db $01
	.db $02
	.db $04
	.db $04
	.db $04
	.db $04
	.db $08
	.db $08

byte_BANK0_8ACE:
	.db $00
	.db $10
	.db $F0
; ---------------------------------------------------------------------------

PickupSounds:
	.db DPCM_Uproot   ; Enemy_Heart
	.db DPCM_ItemPull ; Enemy_Shyguy
	.db DPCM_ItemPull ; Enemy_Tweeter
	.db DPCM_ItemPull ; Enemy_Shyguy
	.db DPCM_ItemPull ; Enemy_Porcupo
	.db DPCM_ItemPull ; Enemy_Snifit
	.db DPCM_ItemPull ; Enemy_Snifit
	.db DPCM_ItemPull ; Enemy_Snifit
	.db DPCM_ItemPull ; Enemy_Ostro
	.db DPCM_Uproot   ; Enemy_BobOmb
	.db DPCM_ItemPull ; Enemy_Albatoss
	.db DPCM_ItemPull ; Enemy_Albatoss
	.db DPCM_ItemPull ; Enemy_Albatoss
	.db DPCM_ItemPull ; Enemy_Ninji
	.db DPCM_ItemPull ; Enemy_Ninji
	.db DPCM_ItemPull ; Enemy_Beezo
	.db DPCM_ItemPull ; Enemy_Beezo
	.db DPCM_Uproot   ; Enemy_WartBubble
	.db DPCM_ItemPull ; Enemy_Pidgit
	.db DPCM_ItemPull ; Enemy_Trouter
	.db DPCM_ItemPull ; Enemy_Hoopstar
	.db DPCM_ItemPull ; Enemy_Shyguy
	.db DPCM_ItemPull ; Enemy_BobOmb
	.db DPCM_ItemPull ; Enemy_Phanto
	.db DPCM_ItemPull ; Enemy_Cobrat
	.db DPCM_ItemPull ; Enemy_Cobrat
	.db DPCM_ItemPull ; Enemy_Pokey
	.db DPCM_Uproot   ; Enemy_Bullet
	.db DPCM_ItemPull ; Enemy_Birdo
	.db DPCM_ItemPull ; Enemy_Mouser
	.db DPCM_ItemPull ; Enemy_Egg
	.db DPCM_ItemPull ; Enemy_Tryclyde
	.db DPCM_ItemPull ; Enemy_Fireball
	.db DPCM_ItemPull ; Enemy_Clawgrip
	.db DPCM_ItemPull ; Enemy_ClawgripRock
	.db DPCM_ItemPull ; Enemy_Panser
	.db DPCM_ItemPull ; Enemy_Panser
	.db DPCM_ItemPull ; Enemy_Panser
	.db DPCM_ItemPull ; Enemy_Autobomb
	.db DPCM_ItemPull ; Enemy_AutobombFire
	.db DPCM_Uproot   ; Enemy_WhaleSpout
	.db DPCM_ItemPull ; Enemy_Flurry
	.db DPCM_ItemPull ; Enemy_Fryguy
	.db DPCM_ItemPull ; Enemy_FryguySplit
	.db DPCM_ItemPull ; Enemy_Wart
	.db DPCM_ItemPull ; Enemy_Hawkmouth
	.db DPCM_ItemPull ; Enemy_Spark
	.db DPCM_ItemPull ; Enemy_Spark
	.db DPCM_ItemPull ; Enemy_Spark
	.db DPCM_ItemPull ; Enemy_Spark
	.db DPCM_Uproot   ; Enemy_Vegetable
	.db DPCM_Uproot   ; Enemy_Vegetable
	.db DPCM_Uproot   ; Enemy_Vegetable
	.db DPCM_Uproot   ; Enemy_Shell
	.db DPCM_Uproot   ; Enemy_Coin
	.db DPCM_Uproot   ; Enemy_Bomb
	.db DPCM_Uproot   ; Enemy_Rocket
	.db DPCM_ItemPull ; Enemy_MushroomBlock
	.db DPCM_ItemPull ; Enemy_POWBlock
	.db DPCM_ItemPull ; Enemy_FallingLogs
	.db DPCM_ItemPull ; Enemy_SubspaceDoor
	.db DPCM_ItemPull ; Enemy_Key
	.db DPCM_Uproot   ; Enemy_SubspacePotion
	.db DPCM_ItemPull ; 
	.db DPCM_Uproot   ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_Uproot   ; 
	.db DPCM_ItemPull ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_ItemPull ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_Uproot   ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_ItemPull ; 
	.db DPCM_Uproot   ; 
	.db DPCM_ItemPull ; 

HandlePlayerState_Climbing:
	LDA zInputCurrentState
	AND #ControllerInput_Down | ControllerInput_Up
	LSR A
	LSR A
	TAY
	CPY #$02
	BNE loc_BANK0_8ADF

	JSR PlayerClimbAnimation

loc_BANK0_8ADF:
	LDA ClimbSpeed, Y
	STA zPlayerYVelocity
	LDA zInputCurrentState
	AND #ControllerInput_Right | ControllerInput_Left
	TAY
	LDA byte_BANK0_8ACE, Y
	STA zPlayerXVelocity
	LDA zPlayerXLo
	CLC
	ADC #$04
	AND #$0F
	CMP #$08
	BCS loc_BANK0_8B14

	LDY TileCollisionHitboxIndex + $0B
	LDA zPlayerYVelocity
	BMI loc_BANK0_8B01

	INY

loc_BANK0_8B01:
	LDX #$00
	JSR PlayerTileCollision_CheckClimbable

	BCS loc_BANK0_8B0E

loc_BANK0_8B08:
	LDA zPlayerYVelocity
	BPL loc_BANK0_8B14

	STX zPlayerYVelocity

loc_BANK0_8B0E:
	JSR ApplyPlayerPhysicsX

	JMP ApplyPlayerPhysicsY

; ---------------------------------------------------------------------------

loc_BANK0_8B14:
	LDA #$00
	STA zPlayerState
	RTS


;
; Does climbing animation and sound
;
PlayerClimbAnimation:
	LDA z10
	AND #$07
	BNE PlayerClimbAnimation_Exit

	LDA zPlayerFacing
	EOR #$01
	STA zPlayerFacing
	LDA #Hill_Vine
	STA iHillSFX

PlayerClimbAnimation_Exit:
	RTS


ClimbableTiles:
	.db BackgroundTile_Vine
	.db BackgroundTile_VineStandable
	.db BackgroundTile_VineBottom
	.db BackgroundTile_ClimbableSky
	.db BackgroundTile_Chain
	.db BackgroundTile_Ladder
	.db BackgroundTile_LadderShadow
	.db BackgroundTile_LadderStandable
	.db BackgroundTile_LadderStandableShadow
	.db BackgroundTile_ChainStandable


;
; Checks whether the player is on a climbable tile
;
; Input
;   z00 = tile ID
; Output
;   C = set if the player is on a climbable tile
;
PlayerTileCollision_CheckClimbable:
	JSR sub_BANK0_924F

	LDA z00
	LDY #$09

PlayerTileCollision_CheckClimbable_Loop:
	CMP ClimbableTiles, Y
	BEQ PlayerTileCollision_CheckClimbable_Exit

	DEY
	BPL PlayerTileCollision_CheckClimbable_Loop

	CLC

PlayerTileCollision_CheckClimbable_Exit:
	RTS


HandlePlayerState_GoingDownJar:
	LDA #ObjAttrib_BehindBackground
	STA zPlayerAttributes
	INC zPlayerYLo
	LDA zPlayerYLo
	AND #$0F
	BNE HandlePlayerState_GoingDownJar_Exit

	STA zPlayerState
	JSR DoAreaReset

	PLA
	PLA
	JSR StashPlayerPosition_Bank0

	LDA #TransitionType_Jar
	STA iTransitionType
	LDA iInJarType
	BNE HandlePlayerState_GoingDownJar_NonWarp

	LDA #GameMode_Warp
	STA iGameMode
	RTS

HandlePlayerState_GoingDownJar_NonWarp:
	CMP #$01
	BEQ HandlePlayerState_GoingDownJar_Regular

	STA iAreaTransitionID
	RTS

HandlePlayerState_GoingDownJar_Regular:
	STA iSubAreaFlags

HandlePlayerState_GoingDownJar_Exit:
	RTS


HandlePlayerState_ExitingJar:
	LDA #ObjAttrib_BehindBackground
	STA zPlayerAttributes
	DEC zPlayerYLo
	LDA zPlayerYLo
	AND #$0F
	BNE locret_BANK0_8B86

	STA zPlayerState

locret_BANK0_8B86:
	RTS


; The climb transition triggers on particular player screen y-positions
ClimbTransitionYExitPositionHi:
	.db $00 ; down
	.db $FF ; up

ClimbTransitionYExitPositionLo:
	.db $EE ; down
	.db $DE ; up

; The second climbing trigger table uses $00 as the high value
ClimbTransitionYEnterPositionLo:
	.db $09 ; down
	.db $A1 ; up


HandlePlayerState_ClimbingAreaTransition:
	; Determine the climbing direction from the y-velocity ($00 = down, $00 = up)
	LDA zPlayerYVelocity
	ASL A
	ROL A
	AND #$01
	TAY

HandlePlayerState_CheckExitPosition:
	; Determine whether the player screen y-position matches the table entry
	LDA iPlayerScreenYPage
	CMP ClimbTransitionYExitPositionHi, Y
	BNE HandlePlayerState_CheckEnterPosition

	LDA iPlayerScreenY
	CMP ClimbTransitionYExitPositionLo, Y
	BNE HandlePlayerState_CheckEnterPosition

	; The position matches, so keep climbing and transition to the next area
	JSR DoAreaReset

	INC iAreaTransitionID
	LDA #TransitionType_Vine
	STA iTransitionType
	RTS

HandlePlayerState_CheckEnterPosition:
	LDA iPlayerScreenYPage
	BNE HandlePlayerState_JustClimb

	; Climbing until player reaches the desired position
	LDA iPlayerScreenY
	CMP ClimbTransitionYEnterPositionLo, Y
	BEQ HandlePlayerState_SetClimbing

HandlePlayerState_JustClimb:
	; do the climb animation if the player is going up
	TYA
	BEQ HandlePlayerState_JustClimb_Physics

	JSR PlayerClimbAnimation

HandlePlayerState_JustClimb_Physics:
	JMP ApplyPlayerPhysicsY

HandlePlayerState_SetClimbing:
	LDA #PlayerState_Climbing
	STA zPlayerState
	RTS



HandlePlayerState_HawkmouthEating:
	LDA zPlayerStateTimer
	BEQ loc_BANK0_8BE9

	JSR ApplyPlayerPhysicsY

	LDA zPlayerCollision

	BEQ locret_BANK0_8BEB

	LDA #ObjAttrib_BehindBackground
	STA zPlayerAttributes
	LDA #$04
	STA zPlayerXVelocity
	LDA #$01
	STA zPlayerFacing

loc_BANK0_8BE3:
	JSR ApplyPlayerPhysicsX

	JMP PlayerWalkJumpAnim

; ---------------------------------------------------------------------------

loc_BANK0_8BE9:
	STA zPlayerState

locret_BANK0_8BEB:
	RTS


; Alternate between large and small graphics on these frames when changing size
ChangingSizeKeyframes:
	.db $05
	.db $0A
	.db $0F
	.db $14
	.db $19


HandlePlayerState_ChangingSize:
	LDA zPlayerStateTimer
	BEQ loc_BANK0_8C0D

	INC zDamageCooldown

	LDY #$04
HandlePlayerState_ChangingSize_Loop:
	CMP ChangingSizeKeyframes, Y
	BNE HandlePlayerState_ChangingSize_Next

	LDA iCurrentPlayerSize
	EOR #$01
	STA iCurrentPlayerSize
	JMP LoadCharacterCHRBanks

HandlePlayerState_ChangingSize_Next:
	DEY
	BPL HandlePlayerState_ChangingSize_Loop
	RTS

; ---------------------------------------------------------------------------

loc_BANK0_8C0D:
	LDY zPlayerAnimFrame
	CPY #$0A
	BNE loc_BANK0_8C15

	LDA #PlayerState_Climbing

loc_BANK0_8C15:
	STA zPlayerState
	RTS

; ---------------------------------------------------------------------------

PlayerControlAcceleration:
	.db $FE
	.db $02

; =============== S U B R O U T I N E =======================================

; player crouch subroutine
sub_BANK0_8C1A:
	JSR PlayerWalkJumpAnim

	LDA zPlayerGrounding
	BNE ResetPartialCrouchJumpTimer

	LDA zPlayerHitBoxHeight
	BEQ loc_BANK0_8C2B

	LDA zPlayerStateTimer
	BNE loc_BANK0_8C92

	DEC zPlayerHitBoxHeight

loc_BANK0_8C2B:
	LDA zInputBottleneck
	BPL loc_BANK0_8C3D ; branch if not pressing A Button

	INC zPlayerGrounding
	LDA #SpriteAnimation_Jumping
	STA zPlayerAnimFrame
	JSR PlayerStartJump

	LDA #Hill_Jump
	STA iHillSFX

loc_BANK0_8C3D:
	LDA iIsRidingCarpet
	BNE loc_BANK0_8C92

	LDA iQuicksandDepth
	BNE ResetPartialCrouchJumpTimer

	LDA zInputCurrentState ; skip if down button is not pressed
	AND #ControllerInput_Down
	BEQ ResetPartialCrouchJumpTimer

	INC zPlayerHitBoxHeight ; set ducking state?
	LDA #SpriteAnimation_Ducking ; set ducking animation
	STA zPlayerAnimFrame
	LDA zPlayerGrounding ; skip ahead if player is in air
	BNE ResetPartialCrouchJumpTimer

	LDA iCrouchJumpTimer ; check if crouch jump is charged
	CMP #$3C
	BCS loc_BANK0_8C92

	LDA #0
	STA zSFXReelTimer
	INC iCrouchJumpTimer ; increment crouch jump charge
	BNE loc_BANK0_8C92

ResetPartialCrouchJumpTimer: ; reset crouch jump timer if it isn't full
	LDA iCrouchJumpTimer
	CMP #$3C ; max crouch jump timer
	BCS loc_BANK0_8C6F

	LDA #$00 ; reset crouch jump timer to zero
	STA iCrouchJumpTimer

loc_BANK0_8C6F:
	LDA zInputCurrentState
	AND #ControllerInput_Right | ControllerInput_Left
	BEQ loc_BANK0_8C92

	AND #$01
	STA zPlayerFacing
	TAY
	LDA iFriction
	LSR A
	LSR A
	AND z10
	BNE ResetCrouchJumpTimer

	LDA zPlayerXVelocity
	CLC
	ADC PlayerControlAcceleration, Y
	STA zPlayerXVelocity

ResetCrouchJumpTimer:
	LDA #$00
	STA iCrouchJumpTimer
	BEQ loc_BANK0_8C95 ; unconditional branch?

loc_BANK0_8C92:
	LDA iCrouchJumpTimer ; check if crouch jump is charged
	CMP #$3C
	BNE loc_skipsound
	LDA zSFXReelTimer
	BNE loc_skipsound

	LDA #DPCM_ChargeJump
	STA iDPCMSFX
	LDA #1
	STA zSFXReelTimer

loc_skipsound:
	JSR sub_BANK0_8D2C

loc_BANK0_8C95:
	JMP sub_BANK0_8DC0

; End of function sub_BANK0_8C1A


;
; Starts a jump
;
; The jump height is based on a lookup table using the following bitfield:
;
; %xxxxxRCI
;   R = whether the player is running
;   C = whether the crouch timer is charged
;   I = whether the player is holding an item
;
PlayerStartJump:
	LDA iQuicksandDepth
	CMP #$02
	BCC PlayerStartJump_LoadXVelocity

	; Quicksand
	LDA iSinkingJumpHeight
	STA zPlayerYVelocity
	BNE PlayerStartJump_Exit

PlayerStartJump_LoadXVelocity:
	; The x-velocity may affect the jump
	LDA zPlayerXVelocity
	BPL PlayerStartJump_CheckXSpeed

	; Absolute value of x-velocity
	EOR #$FF
	CLC
	ADC #$01

PlayerStartJump_CheckXSpeed:
	; Set carry flag if the x-speed is fast enough
	CMP #$08
	; Clear y subpixel
	LDA #$00
	STA iPlayerYSubpixel
	; Set bit for x-speed using carry flag
	ROL A

	; Check crouch jump timer
	LDY iCrouchJumpTimer
	CPY #$3C
	BCC PlayerStartJump_SetYVelocity

	; Clear zInputCurrentState for a crouch jump
	LDA #$00
	STA zInputCurrentState

PlayerStartJump_SetYVelocity:
	; Set bit for charged jump using carry flag
	ROL A
	; Set bit for whether player is holding an item
	ASL A
	ORA zHeldItem
	TAY
	LDA iMainJumpHeights, Y
	STA zPlayerYVelocity

	LDA iFloatLength
	STA iFloatTimer

PlayerStartJump_Exit:
	LDA #$00
	STA iCrouchJumpTimer
	RTS


; =============== S U B R O U T I N E =======================================

;
; Apply gravity to the player's y-velocity
;
; This also handles floating
;
PlayerGravity:
	LDA iQuicksandDepth
	CMP #$02
	BCC loc_BANK0_8CE5

	LDA iGravities + 2
	BNE loc_BANK0_8D13

loc_BANK0_8CE5:
	LDA iGravities
	LDY zInputCurrentState ; holding jump button to fight physics
	BPL PlayerGravity_Falling

	LDA iGravities + 1
	LDY zPlayerYVelocity
	CPY #$0FC
	BMI PlayerGravity_Falling

	LDY iFloatTimer
	BEQ PlayerGravity_Falling

	DEC iFloatTimer
	LDA z10
	LSR A
	LSR A
	LSR A
	AND #$03
	TAY
	LDA FloatingYVelocity, Y
	STA zPlayerYVelocity
	RTS

PlayerGravity_Falling:
	LDY zPlayerYVelocity
	BMI loc_BANK0_8D13

	CPY #$39
	BCS loc_BANK0_8D18

loc_BANK0_8D13:
	CLC
	ADC zPlayerYVelocity
	STA zPlayerYVelocity

loc_BANK0_8D18:
	LDA iFloatTimer
	CMP iFloatLength
	BEQ PlayerGravity_Exit

	LDA #$00
	STA iFloatTimer

PlayerGravity_Exit:
	RTS


FloatingYVelocity:
	.db $FC
	.db $00
	.db $04
	.db $00

PlayerXDeceleration:
	.db $FD
	.db $03


; =============== S U B R O U T I N E =======================================

sub_BANK0_8D2C:
	LDA zPlayerGrounding
	BNE locret_BANK0_8D61

	LDA z10
	AND iFriction
	BNE loc_BANK0_8D4D

	LDA zPlayerXVelocity
	AND #$80
	ASL A
	ROL A
	TAY
	LDA zPlayerXVelocity
	ADC PlayerXDeceleration, Y
	TAX
	EOR PlayerControlAcceleration, Y
	BMI loc_BANK0_8D4B

	LDX #$00

loc_BANK0_8D4B:
	STX zPlayerXVelocity

loc_BANK0_8D4D:
	LDA zPlayerHitBoxHeight
	BNE locret_BANK0_8D61

	LDA zPlayerAnimFrame
	CMP #SpriteAnimation_Throwing
	BEQ locret_BANK0_8D61

	LDA #SpriteAnimation_Standing
	STA zPlayerAnimFrame
	LDA #$00
	STA zWalkCycleTimer

loc_BANK0_8D5F:
	STA zPlayerWalkFrame

locret_BANK0_8D61:
	RTS

; End of function sub_BANK0_8D2C

; ---------------------------------------------------------------------------

PlayerWalkFrameDurations:
	.db $0C
	.db $0A
	.db $08
	.db $05
	.db $03
	.db $02
	.db $02
	.db $02
	.db $02
	.db $02

PlayerWalkFrames:
	.db SpriteAnimation_Standing ; $00
	.db SpriteAnimation_Walking ; $01
	.db SpriteAnimation_Throwing ; ; $02

; =============== S U B R O U T I N E =======================================

; jump animation subroutine
PlayerWalkJumpAnim:
	LDA zPlayerHitBoxHeight ; exit if we're ducking, since the player will be ducking
	BNE ExitPlayerWalkJumpAnim

	; if we're not in the air, skip ahead
	LDA zPlayerGrounding
	BEQ PlayerWalkAnim

	LDA zCurrentCharacter ; does this character get to flutter jump?
	CMP #Character_Luigi
	BNE ExitPlayerWalkJumpAnim

	LDA zWalkCycleTimer
	BNE UpdatePlayerAnimationFrame ; maintain current frame

	LDA #$02 ; fast animation
	BNE NextPlayerWalkFrame

PlayerWalkAnim:
	LDA zWalkCycleTimer
	BNE UpdatePlayerAnimationFrame ; maintain current frame

	LDA #$05
	LDY iFriction
	BNE NextPlayerWalkFrame

	LDA zPlayerXVelocity
	BPL PlayerWalkFrameDuration

	; use absolute value of zPlayerXVelocity
	EOR #$FF
	CLC
	ADC #$01

PlayerWalkFrameDuration:
	LSR A
	LSR A
	LSR A
	TAY
	LDA PlayerWalkFrameDurations, Y

NextPlayerWalkFrame:
	STA zWalkCycleTimer ; hold frame for duration specified in accumulator
	DEC zPlayerWalkFrame
	BPL UpdatePlayerAnimationFrame

	LDA #$01 ; next walk frame
	STA zPlayerWalkFrame

UpdatePlayerAnimationFrame:
	LDY zPlayerWalkFrame
	LDA PlayerWalkFrames, Y
	STA zPlayerAnimFrame

ExitPlayerWalkJumpAnim:
	RTS


ThrowXVelocity:
	.db $00 ; standing, left (blocks)
	.db $00 ; standing, right (blocks)
	.db $D0 ; moving, left (blocks)
	.db $30 ; moving, right (blocks)
	.db $D0 ; standing, left (projectiles)
	.db $30 ; standing, right (projectiles)
	.db $D0 ; moving, left (projectiles)
	.db $30 ; moving, right (projectiles)

ThrowYVelocity:
	.db $18 ; standing (blocks)
	.db $00 ; moving (blocks)
	.db $18 ; standing (projectiles)
	.db $F8 ; moving (projectiles)

; used for objects that can be thrown next to the player
SoftThrowOffset:
	.db $F0
	.db $10



; Determine the max speed based on the terrain and what the player is carrying.
sub_BANK0_8DC0:
	LDY #$02
	LDA iQuicksandDepth
	CMP #$02
	BCS loc_BANK0_8DE0

	DEY
	LDA zHeldItem
	BEQ loc_BANK0_8DDF

	LDX iHeldItemIndex
	LDA zObjectType, X
	CMP #Enemy_VegetableSmall
	BCC loc_BANK0_8DE0

	CMP #Enemy_MushroomBlock
	BCC loc_BANK0_8DDF

	CMP #Enemy_FallingLogs
	BCC loc_BANK0_8DE0

loc_BANK0_8DDF:
	DEY

; 1.5x max speed when the run button is held!
loc_BANK0_8DE0:
	LDA iRunSpeeds, Y
	BIT zInputCurrentState
	BVC loc_BANK0_8DEC

	LSR A
	CLC
	ADC iRunSpeeds, Y

loc_BANK0_8DEC:
	CMP zPlayerXVelocity
	BPL loc_BANK0_8DF2

	STA zPlayerXVelocity

loc_BANK0_8DF2:
	LDA iRunSpeeds + 3, Y
	BIT zInputCurrentState
	BVC loc_BANK0_8DFF

	SEC
	ROR A
	CLC
	ADC iRunSpeeds + 3, Y

loc_BANK0_8DFF:
	CMP zPlayerXVelocity
	BMI loc_BANK0_8E05

	STA zPlayerXVelocity

; Check to see if we have an item that we want to throw.
loc_BANK0_8E05:
	BIT zInputBottleneck
	BVC locret_BANK0_8E41

	LDA zHeldItem
	BEQ locret_BANK0_8E41

	LDY #$00
	LDX iHeldItemIndex
	LDA zEnemyState, X
	CMP #EnemyState_Sand
	BEQ locret_BANK0_8E41

	LDA zObjectType, X
	CMP #Enemy_MushroomBlock
	BCC loc_BANK0_8E22

	CMP #Enemy_POWBlock
	BCC loc_BANK0_8E28

loc_BANK0_8E22:
	CMP #Enemy_Bomb
	BCC loc_BANK0_8E42

	LDY #$02

loc_BANK0_8E28:
	STY z07
	LDA zPlayerFacing
	ASL A
	ORA zPlayerHitBoxHeight
	TAX
	LDY TileCollisionHitboxIndex + $06, X
	LDX #$00
	JSR sub_BANK0_924F

	LDA z00
	LDY z07
	JSR CheckTileUsesCollisionType

	BCC loc_BANK0_8E42
	; else carried item can't be thrown

locret_BANK0_8E41:
	RTS

; ---------------------------------------------------------------------------

loc_BANK0_8E42:
	LDA #SpriteAnimation_Throwing
	STA zPlayerAnimFrame
	LDA #$02
	STA zPlayerWalkFrame
	LDA #$0A
	STA zWalkCycleTimer
	DEC zHeldItem
	LDA #Hill_Throw
	STA iHillSFX
	LDA #$00
	STA zPlayerHitBoxHeight
	STA zInputBottleneck
	STA z01
	LDX iHeldItemIndex
	LDA #Enemy_Coin
	CMP zObjectType, X
	ROL z01
	LDA zPlayerXVelocity
	BPL loc_BANK0_8E6F

	EOR #$FF
	CLC
	ADC #$01

loc_BANK0_8E6F:
	CMP #$08
	ROL z01
	BNE loc_BANK0_8E89

	LDY zPlayerFacing
	LDA SoftThrowOffset, Y
	CLC
	ADC zObjectXLo, X
	STA zObjectXLo, X
	LDA zScrollCondition
	BEQ loc_BANK0_8E89

	DEY
	TYA
	ADC zObjectXHi, X

loc_BANK0_8E87:
	STA zObjectXHi, X

loc_BANK0_8E89:
	LDY z01
	LDA ThrowYVelocity, Y
	STA zObjectYVelocity, X
	LDA z01
	ASL A
	ORA zPlayerFacing
	TAY
	LDA ThrowXVelocity, Y
	STA zObjectXVelocity, X
	LDA #$01
	STA iObjectBulletTimer, X
	LSR A
	STA zHeldObjectTimer, X
	RTS


;
; Applies player physics on the y-axis
;
ApplyPlayerPhysicsY:
	LDX #$0A

;
; Applies player physics, although could theoretically be used for objects too
;
; Input
;   X = direction ($00 for horizontal, $0A for vertical)
;
ApplyPlayerPhysics:
	; Add acceleration to velocity
	LDA zPlayerXVelocity, X
	CLC
	ADC iPlayerXVelocity, X
	PHP
	BPL loc_BANK0_8EB4

	EOR #$FF
	CLC
	ADC #$01

loc_BANK0_8EB4:
	PHA
	; Upper nybble of velocity is for lo position
	LSR A
	LSR A
	LSR A
	LSR A
	TAY

	; Lower nybble of velocity is for subpixel position
	PLA
	ASL A
	ASL A
	ASL A
	ASL A
	CLC

	ADC iPlayerXSubpixel, X
	STA iPlayerXSubpixel, X

	TYA
	ADC #$00
	PLP
	BPL loc_BANK0_8ED1

	EOR #$FF
	CLC
	ADC #$01

loc_BANK0_8ED1:
	LDY #$00
	CMP #$00
	BPL loc_BANK0_8ED8

	DEY

loc_BANK0_8ED8:
	CLC
	ADC zPlayerXLo, X
	STA zPlayerXLo, X
	TYA
	ADC zPlayerXHi, X
	STA zPlayerXHi, X
	LDA #$00
	STA iPlayerXVelocity, X
	RTS


;
; Jumpthrough collision results
;
; This table determines per direction whether a tile is solid (for jumpthrough
; blocks) or interactive (for spikes/ice/conveyors)
;
;   $01 = true
;   $02 = false
;
JumpthroughTileCollisionTable:
InteractiveTileCollisionTable:
	.db $02 ; jumpthrough bottom (y-velocity < 0)
	.db $02
	.db $01 ; jumpthrough top (y-velocity > 0)
	.db $01
	.db $02 ; jumpthrough right (x-velocity < 0)
	.db $02
	.db $02 ; jumpthrough left (x-velocity > 0)
	.db $02


;
; Collision flags that should be set if a given collision check passes
;
EnableCollisionFlagTable:
	.db CollisionFlags_Up
	.db CollisionFlags_Up
	.db CollisionFlags_Down
	.db CollisionFlags_Down
	.db CollisionFlags_Left
	.db CollisionFlags_Left
	.db CollisionFlags_Right
	.db CollisionFlags_Right

ConveyorSpeedTable:
	.db $F0
	.db $10


;
; Player Tile Collision
; =====================
;
; Handles player collision with background tiles
;
PlayerTileCollision:
	; Reset a bunch of collision flags
	LDA #$00
	STA zPlayerCollision
	STA iFriction
	STA z07
	STA z0a ; conveyor
	STA z0e
 ; spikes
	STA z0c ; ice

	JSR PlayerTileCollision_CheckCherryAndClimbable

	; Determine bounding box lookup index
	LDA zPlayerHitBoxHeight
	ASL A
	ORA zHeldItem
	TAX

	; Look up the bounding box for collision detection
	LDA TileCollisionHitboxIndex, X
	STA z08

	; Determine whether the player is going up
	LDA zPlayerYVelocity
	CLC
	ADC iPlayerYVelocity
	BPL PlayerTileCollision_Downward

PlayerTileCollision_Upward:
	JSR CheckPlayerTileCollision_Twice ; use top two tiles
	JSR CheckPlayerTileCollision_IncrementTwice ; skip bottom two tiles

	LDA zPlayerCollision
	BNE PlayerTileCollision_CheckDamageTile
	BEQ PlayerTileCollision_Horizontal

PlayerTileCollision_Downward:
	JSR CheckPlayerTileCollision_IncrementTwice ; skip top two tiles
	JSR CheckPlayerTileCollision_Twice ; use bottom two tiles

	LDA zPlayerCollision
	BNE PlayerTileCollision_CheckInteractiveTiles

	LDA #$00
	LDX #$01

	; Do the quicksand check in worlds 2 and 6
	LDY iCurrentWorldTileset
	CPY #$01
	BEQ PlayerTileCollision_Downward_CheckQuicksand

	CPY #$05
	BNE PlayerTileCollision_Downward_AfterCheckQuicksand

PlayerTileCollision_Downward_CheckQuicksand:
	JSR PlayerTileCollision_CheckQuicksand

PlayerTileCollision_Downward_AfterCheckQuicksand:
	STA iQuicksandDepth
	STX zPlayerGrounding
	JMP PlayerTileCollision_Horizontal

PlayerTileCollision_CheckInteractiveTiles:
	; Reset quicksand depth
	LDA #$00
	STA iQuicksandDepth

	LDA zPlayerYLo
	AND #$0C
	BNE PlayerTileCollision_Horizontal

	STA zPlayerGrounding
	LDA zPlayerYLo
	AND #$F0
	STA zPlayerYLo

PlayerTileCollision_CheckConveyorTile:
	LSR z0a
	BCC PlayerTileCollision_CheckSlipperyTile

	LDX z0a
	LDA ConveyorSpeedTable, X
	STA iPlayerXVelocity

PlayerTileCollision_CheckSlipperyTile:
	LSR z0c
	BCC PlayerTileCollision_CheckJar

	LDA #$0F
	STA iFriction

PlayerTileCollision_CheckJar:
	JSR TileBehavior_CheckJar

PlayerTileCollision_CheckDamageTile:
	LDA #$00
	STA zPlayerYVelocity
	STA iPlayerYVelocity
	LDA iStarTimer
	BNE PlayerTileCollision_Horizontal

	LSR z0e
	BCC PlayerTileCollision_Horizontal

	LDA iPlayerScreenX
	STA iSpriteTempScreenX
	ROR z12

	JSR PlayerTileCollision_HurtPlayer

PlayerTileCollision_Horizontal:
	LDY #$02
	LDA zPlayerXVelocity
	CLC
	ADC iPlayerXVelocity
	BMI loc_BANK0_8FA3

	DEY
	JSR CheckPlayerTileCollision_IncrementTwice

loc_BANK0_8FA3:
	STY zPlayerTrajectory
	JSR CheckPlayerTileCollision_Twice

	LDA zPlayerCollision
	AND #CollisionFlags_Right | CollisionFlags_Left
	BEQ PlayerTileCollision_Exit

	JMP PlayerHorizontalCollision_Bank0

PlayerTileCollision_Exit:
	RTS


;
; Check collision attributes for the next two tiles
;
; Input
;   z07: collision direction
;   z08: bounding box offset
;
; Output
;   z07 += 2
;   z08 += 2
;
CheckPlayerTileCollision_Twice:
	JSR CheckPlayerTileCollision

CheckPlayerTileCollision:
	LDX #$00
	LDY z08
	JSR sub_BANK0_924F

	LDX z07
	LDY JumpthroughTileCollisionTable, X
	LDA z00

	JSR CheckTileUsesCollisionType

	BCC CheckPlayerTileCollision_Exit

CheckPlayerTileCollision_CheckSpikes:
	CMP #BackgroundTile_Spikes
	BNE CheckPlayerTileCollision_CheckIce

	LDA InteractiveTileCollisionTable, X
	STA z0e
	BNE CheckPlayerTileCollision_UpdatePlayerCollision

CheckPlayerTileCollision_CheckIce:
	CMP #BackgroundTile_JumpThroughIce
	BNE CheckPlayerTileCollision_CheckConveyor

	LDA InteractiveTileCollisionTable, X
	STA z0c
	BNE CheckPlayerTileCollision_UpdatePlayerCollision

CheckPlayerTileCollision_CheckConveyor:
	SEC
	SBC #BackgroundTile_ConveyorLeft
	CMP #$02
	BCS CheckPlayerTileCollision_UpdatePlayerCollision

	ASL A
	ORA InteractiveTileCollisionTable, X
	STA z0a

CheckPlayerTileCollision_UpdatePlayerCollision:
	LDA EnableCollisionFlagTable, X
	ORA zPlayerCollision
	STA zPlayerCollision

CheckPlayerTileCollision_Exit:
	JMP CheckPlayerTileCollision_Increment

;
; Skip two tiles
;
; Output
;   z07 += 2
;   z08 += 2
;
CheckPlayerTileCollision_IncrementTwice:
	JSR CheckPlayerTileCollision_Increment

CheckPlayerTileCollision_Increment:
	INC z07
	INC z08
	RTS


PlayerTileCollision_CheckCherryAndClimbable:
	LDY TileCollisionHitboxIndex + $0A

	; z10 seems to be a global counter
	; this code increments Y every other frame, but why?
	; Seems like it alternates on each frame between checking the top and bottom of the player.
	LDA z10
	LSR A
	BCS PlayerTileCollision_CheckCherryAndClimbable_AfterTick
	INY

PlayerTileCollision_CheckCherryAndClimbable_AfterTick:
	LDX #$00
	JSR PlayerTileCollision_CheckClimbable

	BCS PlayerTileCollision_Climbable

	LDA z00
	CMP #BackgroundTile_Cherry
	BNE PlayerTileCollision_Climbable_Exit

	INC iCherryAmount
	LDA iCherryAmount
	SBC #$05
	BNE PlayerTileCollision_Cherry

	STA iCherryAmount
	JSR CreateStarman

PlayerTileCollision_Cherry:
	LDA #Hill_Cherry
	STA iHillSFX
	LDA #BackgroundTile_Sky
	JMP loc_BANK0_937C

PlayerTileCollision_Climbable:
	LDA zInputCurrentState
	AND #ControllerInput_Down | ControllerInput_Up
	BEQ PlayerTileCollision_Climbable_Exit

	LDY zHeldItem
	BNE PlayerTileCollision_Climbable_Exit

	LDA zPlayerXLo
	CLC
	ADC #$04
	AND #$0F
	CMP #$08
	BCS PlayerTileCollision_Climbable_Exit

	LDA #PlayerState_Climbing
	STA zPlayerState
	STY zPlayerGrounding
	STY zPlayerHitBoxHeight
	LDA #SpriteAnimation_Climbing
	STA zPlayerAnimFrame

	; Break JSR PlayerTileCollision_CheckCherryAndClimbable
	PLA
	PLA
	; Break JSR PlayerTileCollision
	PLA
	PLA

PlayerTileCollision_Climbable_Exit:
	RTS


;
; Check whether a tile should use the given collision handler type
;
; Input
;   A = tile ID
;   Y = collision handler type (0 = solid for mushroom blocks, 1 = jumpthrough, 2 = solid)
; Output
;   C = whether or not collision type Y is relevant
;
CheckTileUsesCollisionType:
	PHA ; stash tile ID for later

	; determine which tile table to use (0-3)
	AND #$C0
	ASL A
	ROL A
	ROL A

	; add the offset for the type of collision we're checking
	ADC TileGroupTable, Y
	TAY

	; check which side of the tile ID pivot we're on
	PLA
	CMP TileSolidnessTable, Y
	RTS


;
; These map the two high bits of a tile to offets in TileSolidnessTable
;
TileGroupTable:
	.db $00 ; solid to mushroom blocks
	.db $04 ; solid on top
	.db $08 ; solid on all sides


PickUpToEnemyTypeTable:
	.db Enemy_MushroomBlock ; $00
	.db Enemy_MushroomBlock ; $01
	.db Enemy_MushroomBlock ; $02
	.db Enemy_POWBlock ; $03
	.db Enemy_Coin ; $04
	.db Enemy_VegetableLarge ; $05
	.db Enemy_VegetableSmall ; $06
	.db Enemy_Rocket ; $07
	.db Enemy_Shell ; $08
	.db Enemy_Bomb ; $09
	.db Enemy_SubspacePotion ; $0A
	.db Enemy_Mushroom1up ; $0B
	.db Enemy_POWBlock ; $0C
	.db Enemy_BobOmb ; $0D
	.db Enemy_MushroomBlock ; $0E ; this one seems to be overridden for digging in sand


; find a slot for the item being lifted
loc_BANK0_9074:
	LDX #$06

loc_BANK0_9076:
	LDA zEnemyState, X
	BEQ loc_BANK0_9080

	INX
	CPX #$09
	BCC loc_BANK0_9076
	RTS

; create the sprite for the item being picked up
loc_BANK0_9080:
	LDA z00
	STA zObjectVariables, X
	LDA z03
	STA zObjectXHi, X
	LDA z04
	STA zObjectYHi, X
	LDA z05
	STA zObjectXLo, X
	LDA z06
	STA zObjectYLo, X
	LDA #$00
	STA iObjectBulletTimer, X
	STA zObjectAnimTimer, X
	STA zEnemyArray, X
	JSR UnlinkEnemyFromRawData_Bank1

	LDA #EnemyState_Alive
	LDY z09
	CPY #$0E
	BNE loc_BANK0_90AE

	LDA #$20
	STA zSpriteTimer, X
	LDA #EnemyState_Sand

loc_BANK0_90AE:
	STA zEnemyState, X
	LDA PickUpToEnemyTypeTable, Y ; What sprite is spawned for you when lifting a bg object
	STA zObjectType, X

	LDY #$FF ; regular bomb fuse
	CMP #Enemy_Bomb
	BEQ loc_BANK0_90C1

	CMP #Enemy_BobOmb
	BNE loc_BANK0_90C5

	LDY #$50 ; BobOmb fuse

loc_BANK0_90C1:
	STY zSpriteTimer, X
	BNE loc_BANK0_90EA

loc_BANK0_90C5:
	CMP #Enemy_Mushroom1up
	BNE loc_BANK0_90D5

IFNDEF STATS_TESTING_PURPOSES
	LDA iLifeUpEventFlag
ENDIF
	BEQ loc_BANK0_90EA

IFNDEF STATS_TESTING_PURPOSES
	LDA #Enemy_VegetableSmall
	STA zObjectType, X

	JMP loc_BANK0_90EA
ENDIF

loc_BANK0_90D5:
	CMP #Enemy_VegetableLarge
	BNE loc_BANK0_90EA

	LDY iLargeVeggieAmount
	INY
	CPY #$05
	BCC loc_BANK0_90E7

	LDA #Enemy_Stopwatch
	STA zObjectType, X
	LDY #$00

loc_BANK0_90E7:
	STY iLargeVeggieAmount

loc_BANK0_90EA:
	JSR loc_BANK1_B9EB

	LDA #CollisionFlags_Down
	STA zEnemyCollision, X
	LDA #BackgroundTile_Sky
	JSR ReplaceTile_Bank0

	LDA #$07
	STA zHeldObjectTimer, X
	STX iHeldItemIndex
	LDA #PlayerState_Lifting
	STA zPlayerState
	LDA #$06
	STA zPlayerStateTimer
	LDA #SpriteAnimation_Pulling
	STA zPlayerAnimFrame
	INC zHeldItem
	RTS


TileBehavior_CheckJar:
	LDY zHeldItem
	BNE loc_BANK0_917C

	LDA zPlayerHitBoxHeight
	BEQ TileBehavior_CheckPickUp

	LDA z00
	LDX iSubAreaFlags
	CPX #$02
	BNE TileBehavior_CheckJar_NotSubspace

	; In SubSpace, a non-enterable jar can be entered
	; Now Y = $00
	CMP #BackgroundTile_JarTopNonEnterable
	BEQ TileBehavior_GoDownJar

	BNE loc_BANK0_917C

TileBehavior_CheckJar_NotSubspace:
	INY
	; Now Y = $01
	CMP #BackgroundTile_JarTopGeneric
	BEQ TileBehavior_GoDownJar

	CMP #BackgroundTile_JarTopPointer
	BNE loc_BANK0_917C

	INY
	; Now Y = $02

TileBehavior_GoDownJar:
	LDA zPlayerXLo
	CLC
	ADC #$04
	AND #$0F
	CMP #$08
	BCS loc_BANK0_917C

	; Stop horiziontal movement
	LDA #$00
	STA zPlayerXVelocity

	; We're going down the jar!
	LDA #DPCM_GoingDownJar
	STA iDPCMSFX
	LDA #PlayerState_GoingDownJar
	STA zPlayerState

	; What kind of jar are we going down?
	; $00 = warp, $01 = regular, $02 = pointer
	STY iInJarType

;
; Snaps the player to the closest tile (for entering doors and jars)
;
SnapPlayerToTile:
	LDA zPlayerXLo
	CLC
	ADC #$08
	AND #$F0
	STA zPlayerXLo
	BCC SnapPlayerToTile_Exit

	LDA zScrollCondition
	BEQ SnapPlayerToTile_Exit

	INC zPlayerXHi

SnapPlayerToTile_Exit:
	RTS


TileBehavior_CheckPickUp:
	BIT zInputBottleneck
	BVC loc_BANK0_917C

	; B button pressed

	LDA zPlayerXLo
	CLC
	ADC #$06
	AND #$0F
	CMP #$0C
	BCS loc_BANK0_917C

	LDA z00
	CMP #BackgroundTile_DiggableSand
	BNE loc_BANK0_916E

	LDA #$0E
	BNE loc_BANK0_9177

; blocks that can be picked up
loc_BANK0_916E:
	CMP #BackgroundTile_Unused6D
	BCS loc_BANK0_917C

	; convert to an index in PickUpToEnemyTypeTable
	SEC
	SBC #BackgroundTile_MushroomBlock
	BCC loc_BANK0_917C

loc_BANK0_9177:
	STA z09
	JMP loc_BANK0_9074

; ---------------------------------------------------------------------------

loc_BANK0_917C:
	LDA zPlayerHitBoxHeight
	BNE locret_BANK0_91CE

	LDA z06
	SEC
	SBC #$10
	STA z06
	STA ze6
	LDA z04
	SBC #$00
	STA z04
	STA z01
	LDA z03
	STA z02
	JSR sub_BANK0_92C1

	BCS locret_BANK0_91CE

	JSR SetTileOffsetAndAreaPageAddr_Bank1

	LDY ze7
	LDA (z01), Y
	LDX zHeldItem
	BEQ loc_BANK0_91AE

	LDX iHeldItemIndex
	LDY zObjectType, X
	CPY #Enemy_Key
	BNE locret_BANK0_91CE

loc_BANK0_91AE:
	LDX iSubAreaFlags
	CPX #$02
	BEQ loc_BANK0_91BF

	LDY #$04

; check to see if the tile matches one of the door tiles
loc_BANK0_91B7:
	CMP DoorTiles, Y
	BEQ loc_BANK0_91EB

	DEY
	BPL loc_BANK0_91B7

loc_BANK0_91BF:
	BIT zInputBottleneck
	BVC locret_BANK0_91CE

	STA z00
	CMP #BackgroundTile_GrassInactive
	BCS locret_BANK0_91CE

	SEC
	SBC #BackgroundTile_GrassCoin
	BCS loc_BANK0_91CF

locret_BANK0_91CE:
	RTS

; ---------------------------------------------------------------------------

loc_BANK0_91CF:
	LDX iSubAreaFlags
	CPX #$02
	BNE loc_BANK0_91E3

IFNDEF STATS_TESTING_PURPOSES
	LDA iSubspaceVisitCount
	CMP #$02
	BCS loc_BANK0_91E2 ; skip if we've already visited Subspace twice

	INC iSubspaceCoinCount
ENDIF
	LDX #$00

loc_BANK0_91E2:
	TXA

loc_BANK0_91E3:
	CLC
	ADC #$04
	STA z09
	JMP loc_BANK0_9074

; ---------------------------------------------------------------------------

;
; Checks to see if we're trying to go through the door
;
; Input
;   Y = tile index in DoorTiles
loc_BANK0_91EB:
	LDA zInputBottleneck
	AND #ControllerInput_Up
	BEQ locret_BANK0_91CE

	; player is holding up and is trying to go through this door
	LDA zPlayerXLo
	CLC
	ADC #$05
	AND #$0F
	CMP #$0A
	BCS locret_BANK0_91CE

	CPY #$04 ; index of BackgroundTile_LightDoorEndLevel
	BNE loc_BANK0_9205

	; setting iGameMode to $03 to go to Bonus Chance
	DEY
	STY iGameMode
	RTS

; ---------------------------------------------------------------------------

loc_BANK0_9205:
	LDA #TransitionType_Door
	STA iTransitionType
	TYA
	JSR JumpToTableAfterJump

DoorHandlingPointers:
	.dw DoorHandling_UnlockedDoor ; unlocked door
	.dw DoorHandling_LockedDoor ; locked door
	.dw DoorHandling_Entrance ; dark door
	.dw DoorHandling_Entrance ; light door


DoorHandling_UnlockedDoor:
	JSR DoorAnimation_Unlocked

DoorHandling_GoThroughDoor:
	INC iDoorAnimTimer
	INC iPlayerLock
	JSR SnapPlayerToTile

	LDA #SoundEffect3_Door
	STA iNoiseSFX

DoorHandling_Exit:
	RTS


DoorHandling_LockedDoor:
	LDA zHeldItem
	; don't come to a locked door empty-handed
	BEQ DoorHandling_Exit

	; and make sure you have a key
	LDY iHeldItemIndex
	LDA zObjectType, Y
	CMP #Enemy_Key
	BNE DoorHandling_Exit

	; the key has been used
	INC iKeyUsed
	TYA
	TAX

	JSR TurnKeyIntoPuffOfSmoke
	JSR DoorAnimation_Locked
	JMP DoorHandling_GoThroughDoor


DoorHandling_Entrance:
	INC iAreaTransitionID
	JMP DoAreaReset


DoorTiles:
	.db BackgroundTile_DoorBottom
	.db BackgroundTile_DoorBottomLock
	.db BackgroundTile_DarkDoor
	.db BackgroundTile_LightDoor
	.db BackgroundTile_LightDoorEndLevel


;
; Seems to determine what kind of tile the player has collided with?
;
; Input
;   X = object index (0 = player)
;   Y = bounding box offset
; Output
;   z00 = tile ID
;
sub_BANK0_924F:
	TXA
	PHA
	LDA #$00
	STA z00
	STA z01
	LDA VerticalTileCollisionHitboxX, Y
	BPL loc_BANK0_925E

	DEC z00

loc_BANK0_925E:
	CLC
	ADC zPlayerXLo, X
	AND #$F0
	STA z05
	PHP
	LSR A
	LSR A
	LSR A
	LSR A
	STA ze5
	PLP
	LDA zPlayerXHi, X
	ADC z00
	STA z02
	STA z03
	LDA zScrollCondition
	BNE loc_BANK0_927D

	STA z02
	STA z03

loc_BANK0_927D:
	LDA VerticalTileCollisionHitboxY, Y
	BPL loc_BANK0_9284

	DEC z01

loc_BANK0_9284:
	CLC
	ADC zPlayerYLo, X
	AND #$F0
	STA z06
	STA ze6
	LDA zPlayerYHi, X
	ADC z01
	STA z01
	STA z04
	JSR sub_BANK0_92C1

	BCC loc_BANK0_929E

	LDA #$00
	BEQ loc_BANK0_92A5

loc_BANK0_929E:
	JSR SetTileOffsetAndAreaPageAddr_Bank1

	LDY ze7
	LDA (z01), Y

loc_BANK0_92A5:
	STA z00
	PLA
	TAX
	RTS


; =============== S U B R O U T I N E =======================================

sub_BANK0_92AA:
	STA z0f
	TYA
	BMI locret_BANK0_92C0

	ASL A
	ASL A
	ASL A
	ASL A
	CLC
	ADC z0f
	BCS loc_BANK0_92BC

	CMP #$F0
	BCC locret_BANK0_92C0

loc_BANK0_92BC:
	CLC
	ADC #$10
	INY

locret_BANK0_92C0:
	RTS

; End of function sub_BANK0_92AA


;
; NOTE: This is a copy of the "sub_BANK3_BC2E" routine in Bank 3
;
;
sub_BANK0_92C1:
	LDY z01
	LDA ze6
	JSR sub_BANK0_92AA

	STY z01
	STA ze6
	LDY zScrollCondition
	LDA z01, Y
	STA ze8
	LDA z02
	CMP byte_BANK0_92E0 + 1, Y
	BCS locret_BANK0_92DF

	LDA z01
	CMP byte_BANK0_92E0, Y

locret_BANK0_92DF:
	RTS


byte_BANK0_92E0:
	.db $0A
	.db $01
	.db $0B


; Unused?
; Copy of DetermineVerticalScroll
_code_12E3:
	LDX zScrollArray
	BNE locret_BANK0_9311

	LDA zPlayerState
	CMP #PlayerState_Lifting
	BCS locret_BANK0_9311

	LDA iPlayerScreenY
	LDY iPlayerScreenYPage
	BMI loc_BANK0_92FF

	BNE loc_BANK0_9305

	CMP #$B4
	BCS loc_BANK0_9305

	CMP #$21
	BCS loc_BANK0_9307

loc_BANK0_92FF:
	LDY zPlayerGrounding
	BNE loc_BANK0_9307

	BEQ loc_BANK0_9306

loc_BANK0_9305:
	INX

loc_BANK0_9306:
	INX

loc_BANK0_9307:
	LDA iVerticalScrollVelocity
	STX iVerticalScrollVelocity
	BNE locret_BANK0_9311

loc_BANK0_930F:
	STX zScrollArray

locret_BANK0_9311:
	RTS


PlayerCollisionDirectionTable:
	.db CollisionFlags_Right
	.db CollisionFlags_Left

PlayerCollisionResultTable_Bank0:
	.db CollisionFlags_80
	.db CollisionFlags_00


;
; Enforces the left/right boundaries of horizontal areas
;
PlayerAreaBoundaryCollision:
	LDA zScrollCondition
	BEQ PlayerAreaBoundaryCollision_Exit

	LDA iPlayerScreenX
	LDY zPlayerTrajectory
	CPY #$01
	BEQ PlayerAreaBoundaryCollision_CheckRight

PlayerAreaBoundaryCollision_CheckLeft:
	CMP #$08
	BCC PlayerAreaBoundaryCollision_BoundaryHit

PlayerAreaBoundaryCollision_Exit:
	RTS

PlayerAreaBoundaryCollision_CheckRight:
	CMP #$E8
	BCC PlayerAreaBoundaryCollision_Exit

PlayerAreaBoundaryCollision_BoundaryHit:
	LDA zPlayerCollision
	ORA PlayerCollisionDirectionTable - 1, Y
	STA zPlayerCollision

;
; NOTE: This is a copy of the "PlayerHorizontalCollision" routine in Bank 3
;
PlayerHorizontalCollision_Bank0:
	LDX #$00
	LDY zPlayerTrajectory
	LDA zPlayerXVelocity
	EOR PlayerCollisionResultTable_Bank0 - 1, Y
	BPL loc_BANK0_9340

	STX zPlayerXVelocity

loc_BANK0_9340:
	LDA iPlayerXVelocity
	EOR PlayerCollisionResultTable_Bank0 - 1, Y
	BPL loc_BANK0_934B

	STX iPlayerXVelocity

loc_BANK0_934B:
	STX iPlayerXSubpixel

locret_BANK0_934E:
	RTS


; =============== S U B R O U T I N E =======================================

;
; NOTE: This is a copy of the "sub_BANK3_BC50" routine in Bank 3
;
; Replaces tile when something is picked up
;
; Input
;   A = Target tile
;   X = Enemy index of object being picked up
;
ReplaceTile_Bank0:
	PHA ; Something to update the PPU for some tile change
	LDA zObjectXLo, X
	CLC
	ADC #$08
	PHP
	LSR A
	LSR A
	LSR A
	LSR A
	STA ze5
	PLP
	LDA zObjectXHi, X
	LDY zScrollCondition
	BEQ ReplaceTile_StoreXHi_Bank0

	ADC #$00

ReplaceTile_StoreXHi_Bank0:
	STA z02
	LDA zObjectYLo, X
	CLC
	ADC #$08
	AND #$F0
	STA ze6
	LDA zObjectYHi, X
	ADC #$00
	STA z01
	JSR sub_BANK0_92C1

	PLA
	BCS locret_BANK0_934E

;
; Input
;   A = Target tile
;
loc_BANK0_937C:
	; Stash X so we can restore it later on
	STX z03

	; Stash the target tile and figure out where to draw it
	PHA
	JSR SetTileOffsetAndAreaPageAddr_Bank1
	PLA
	; Update the tile in the decoded level data
	LDY ze7
	STA (z01), Y

	PHA
	LDX i300
	LDA #$00
	STA iPPUBuffer, X
	TYA
	AND #$F0
	ASL A
	ROL iPPUBuffer, X
	ASL A
	ROL iPPUBuffer, X
	STA iPPUBuffer + 1, X
	TYA
	AND #$0F
	ASL A

	ADC iPPUBuffer + 1, X
	STA iPPUBuffer + 1, X
	CLC
	ADC #$20
	STA iPPUBuffer + 6, X
	LDA zScrollCondition
	ASL A
	TAY
	LDA z01
	AND #$10
	BNE loc_BANK0_93B9

	INY

loc_BANK0_93B9:
	LDA byte_BANK0_940A, Y
	CLC
	ADC iPPUBuffer, X
	STA iPPUBuffer, X
	STA iPPUBuffer + 5, X
	LDA #$02
	STA iPPUBuffer + 2, X
	STA iPPUBuffer + 7, X

	PLA
	PHA
	AND #%11000000
	ASL A
	ROL A
	ROL A
	TAY
	; Get the tile quad pointer
	LDA TileQuadPointersLo, Y
	STA z00
	LDA TileQuadPointersHi, Y
	STA z01
	PLA
	ASL A
	ASL A
	TAY
	LDA (z00), Y
	STA iPPUBuffer + 3, X
	INY
	LDA (z00), Y
	STA iPPUBuffer + 4, X
	INY
	LDA (z00), Y
	STA iPPUBuffer + 8, X
	INY
	LDA (z00), Y
	STA iPPUBuffer + 9, X
	LDA #$00
	STA iPPUBuffer + 10, X
	TXA
	CLC
	ADC #$0A
	STA i300
	LDX z03
	RTS


; Another byte of PPU high addresses for horiz/vert levels
byte_BANK0_940A:
	.db $20
	.db $28
	.db $20
	.db $24


;
; NOTE: This is a copy of the "StashPlayerPosition" routine in Bank 3
;
StashPlayerPosition_Bank0:
	LDA iSubAreaFlags
	BNE StashPlayerPosition_Exit_Bank0

	LDA zPlayerXHi
	STA iPlayerXHi
	LDA zPlayerXLo
	STA iPlayer_X_Lo
	LDA zPlayerYHi
	STA iPlayerYHi
	LDA zPlayerYLo
	STA iPlayerYLoBackup

StashPlayerPosition_Exit_Bank0:
	RTS

;
; Restores the player position from the backup values after exiting a subarea
;
RestorePlayerPosition:
	LDA iPlayerXHi
	STA zPlayerXHi
	LDA iPlayer_X_Lo
	STA zPlayerXLo
	LDA iPlayerYHi
	STA zPlayerYHi
	LDA iPlayerYLoBackup
	STA zPlayerYLo
	LDA zPlayerXLo
	SEC
	SBC iBoundLeftLower
	STA iPlayerScreenX
	LDA zPlayerYLo
	SEC
	SBC zScreenY
	STA iPlayerScreenY
	LDA zPlayerYHi
	SBC zScreenYPage
	STA iPlayerScreenYPage
	LDA iTransitionType
	SEC
	SBC #TransitionType_SubSpace
	BNE StashPlayerPosition_Exit_Bank0

	; resetting these to zero (A=$00, otherwise we would have branched)
	STA zPlayerState
	STA iPlayerLock
	STA iSubTimeLeft
	JSR DoorAnimation_Unlocked

	LDA #$0A
	STA iSubDoorTimer
	RTS


;
; Performs an area transition
;
ApplyAreaTransition:
	LDA iTransitionType
	CMP #TransitionType_Jar
	BNE ApplyAreaTransition_NotJar

ApplyAreaTransition_Jar:
	LDA iInJarType
	BNE ApplyAreaTransition_NotJar

	JSR RestorePlayerPosition

	JMP ApplyAreaTransition_MoveCamera

ApplyAreaTransition_NotJar:
	LDA iCurrentLvlEntryPage
	LDY #$00
	LDX zScrollCondition
	BNE ApplyAreaTransition_Horizontal

ApplyAreaTransition_Vertical:
	STY zPlayerXHi
	STA zPlayerYHi
	BEQ ApplyAreaTransition_SetPlayerPosition

ApplyAreaTransition_Horizontal:
	STA zPlayerXHi
	STY zPlayerYHi

ApplyAreaTransition_SetPlayerPosition:
	JSR AreaTransitionPlacement

	; The height of a page is only `$0F` tiles instead of `$10`.
	; zPlayerYHi is currently using the vertical page rather than the actual high
	; byte of the absolute position, so we need to convert it to compensate!
	LDY zPlayerYHi
	LDA zPlayerYLo
	JSR PageHeightCompensation
	STY zPlayerYHi
	STA zPlayerYLo

	LDA zPlayerXLo
	SEC
	SBC iBoundLeftLower
	STA iPlayerScreenX

	LDA zPlayerYLo
	SEC
	SBC zScreenY
	STA iPlayerScreenY

	LDA zPlayerYHi
	SBC zScreenYPage
	STA iPlayerScreenYPage

	LDA iTransitionType
	CMP #TransitionType_SubSpace
	BNE ApplyAreaTransition_MoveCamera

	JSR DoorAnimation_Unlocked

ApplyAreaTransition_MoveCamera:
	LDA zPlayerXLo
	SEC
	SBC #$78
	STA zXVelocity
	RTS


;
; Do the player placement after an area transition
;
AreaTransitionPlacement:
	LDA iTransitionType
	JSR JumpToTableAfterJump

	.dw AreaTransitionPlacement_Reset
	.dw AreaTransitionPlacement_Door
	.dw AreaTransitionPlacement_Jar
	.dw AreaTransitionPlacement_Climbing
	.dw AreaTransitionPlacement_Subspace
	.dw AreaTransitionPlacement_Rocket


AreaTransitionPlacement_Reset:
	LDA #$01
	STA zPlayerFacing
	JSR AreaTransitionPlacement_Middle

	LSR A
	LSR A
	LSR A
	LSR A
	STA ze5
	LDA #$D0
	STA zPlayerYLo
	STA ze6
	LDA iCurrentLvlEntryPage
	STA ze8

;
; The player must start in empty space (not a wall)
;
AreaTransitionPlacement_Reset_FindOpenSpace:
	LDA #$0C
	STA z03
AreaTransitionPlacement_Reset_FindOpenSpaceLoop:
	JSR SetTileOffsetAndAreaPageAddr_Bank1

	LDY ze7
	LDA (z01), Y
	CMP #BackgroundTile_Sky
	BEQ AreaTransitionPlacement_MovePlayerUp1Tile

	JSR AreaTransitionPlacement_MovePlayerUp1Tile

	STA ze6
	DEC z03
	BNE AreaTransitionPlacement_Reset_FindOpenSpaceLoop


;
; Moves the player up by one tile
;
AreaTransitionPlacement_MovePlayerUp1Tile:
	LDA zPlayerYLo
	SEC
	SBC #$10
	STA zPlayerYLo
	RTS


;
; Looks for a door and positions the player at it
;
; The implementation of this requires the destination door to be at the
; OPPOSITE side of the screen from the origin door horizontally, but it can be
; at any position vertically.
;
; If no suitable door is found, the player is positioned to fall from the
; top-middle of the screen instead
;
AreaTransitionPlacement_Door:
	LDA zPlayerXLo
	; Switch the x-position to the opposite side of the screen
	CLC
	ADC #$08
	AND #$F0
	EOR #$F0
	STA zPlayerXLo

	; Convert to a tile offset
	LSR A
	LSR A
	LSR A
	LSR A
	STA ze5

	; Start at the bottom of the page
	LDA #$E0
	STA zPlayerYLo
	STA ze6
	LDA iCurrentLvlEntryPage
	STA ze8
	LDA #$0D
	STA z03

AreaTransitionPlacement_Door_Loop:
	JSR SetTileOffsetAndAreaPageAddr_Bank1

	; Read the target tile
	LDY ze7
	LDA (z01), Y
	LDY #$05

AreaTransitionPlacement_Door_InnerLoop:
	; See if it matches any door tile
	CMP DoorTiles - 1, Y
	BEQ AreaTransitionPlacement_Door_Exit
	DEY
	BNE AreaTransitionPlacement_Door_InnerLoop

	; Nothing matched on this row, so check the next row or give up
	DEC z03
	BEQ AreaTransitionPlacement_Door_Fallback

	JSR AreaTransitionPlacement_MovePlayerUp1Tile

	STA ze6
	JMP AreaTransitionPlacement_Door_Loop

AreaTransitionPlacement_Door_Fallback:
	; Place in the middle of the screen if no door is found
	JSR AreaTransitionPlacement_Middle

AreaTransitionPlacement_Door_Exit:
	JSR AreaTransitionPlacement_MovePlayerUp1Tile

	LDA #$00
	STA iPlayerLock
	RTS

;
; Place the player at the top of the screen in the middle horizontally
;
AreaTransitionPlacement_Jar:
	LDA #$00
	STA zPlayerYLo

;
; Place the player in the air in the middle of the screen horizontally
;
AreaTransitionPlacement_Middle:
	LDA #$01
	STA zPlayerGrounding
	LDA #$78
	STA zPlayerXLo
	RTS

;
; Looks for a climbable tile (vine/chain/ladder) and positions the player at it
;
; The implementation of this requires the destination to be at the OPPOSITE
; side of the screen from the origin horizontally, otherwise the player will
; be climbing on nothing.
;
AreaTransitionPlacement_Climbing:
	LDA zPlayerXLo
	; Switch the x-position to the opposite side of the screen
	CLC
	ADC #$08
	AND #$F0
	EOR #$F0
	STA zPlayerXLo

	; Switch the y-position to the opposite side of the screen
	LDA iPlayerScreenY
	CLC
	ADC #$08
	AND #$F0
	EOR #$10
	STA zPlayerYLo
	CMP #$F0
	BEQ AreaTransitionPlacement_Climbing_Exit

	DEC zPlayerYHi

AreaTransitionPlacement_Climbing_Exit:
	LDA #SpriteAnimation_Climbing
	STA zPlayerAnimFrame
	RTS


AreaTransitionPlacement_Subspace:
	LDA iPlayerScreenX
	SEC
	SBC zXVelocity
	EOR #$FF
	CLC
	ADC #$F1
	STA zPlayerXLo
	LDA iPlayerScreenY
	STA zPlayerYLo
	DEC iPlayerLock
IFNDEF STATS_TESTING_PURPOSES
	LDA #$63
ELSE
	LDA #$FF
ENDIF
	STA iSubTimeLeft
	RTS


AreaTransitionPlacement_Rocket:
	JSR AreaTransitionPlacement_Middle
	LDA #$60
	STA zPlayerYLo
	RTS


;
; Converts a y-position from page+offset to hi+lo coordinates, compensating for
; the fact that a page height is only $0F tiles, not a full $10.
;
; ##### Input
; - `Y`: page
; - `A`: position on page
;
; ##### Output
; - `Y`: hi position
; - `A`: lo position
;
PageHeightCompensation:
	; If player is above the top, exit
	CPY #$00
	BMI PageHeightCompensation_Exit

	; Convert page to number of tiles
	PHA
	TYA
	ASL A
	ASL A
	ASL A
	ASL A
	STA z0f
	PLA

	; Subtract the tiles from the position
	SEC
	SBC z0f
	BCS PageHeightCompensation_Exit

	; Carry to the high byte
	DEY

PageHeightCompensation_Exit:
	RTS


TitleScreenPPUDataPointers:
	.dw iPPUBuffer
	.dw TitleLayout


WaitForNMI_TitleScreen_TurnOnPPU:
	LDA #PPUMask_ShowLeft8Pixels_BG | PPUMask_ShowLeft8Pixels_SPR | PPUMask_ShowBackground | PPUMask_ShowSprites
	STA zPPUMask

WaitForNMI_TitleScreen:
	LDA zScreenUpdateIndex
	ASL A
	TAX
	LDA TitleScreenPPUDataPointers, X
	STA zPPUDataBufferPointer
	LDA TitleScreenPPUDataPointers + 1, X
	STA zPPUDataBufferPointer + 1

	LDA #$00
	STA zNMIOccurred
WaitForNMI_TitleScreenLoop:
	LDA zNMIOccurred
	BPL WaitForNMI_TitleScreenLoop
	RTS


TitleLayout:
	; red lines, vertical, left
	.db $20, $00, $DE, $FD
	.db $20, $01, $DE, $FD
	.db $20, $02, $DE, $FD
	.db $20, $03, $DE, $FD
	; red lines, vertical, right
	.db $20, $1C, $DE, $FD
	.db $20, $1D, $DE, $FD
	.db $20, $1E, $DE, $FD
	.db $20, $1F, $DE, $FD
	; red lines, horizontal, top
	.db $20, $03, $5D, $FD
	.db $20, $23, $5D, $FD
	.db $20, $43, $5D, $FD
	.db $20, $63, $5D, $FD
	; red lines, vertical, bottom
	.db $23, $63, $5D, $FD
	.db $23, $83, $5D, $FD
	.db $23, $A3, $5D, $FD

	; ornate frame, top
	.db $20, $68, $10, $48, $4A, $4C, $4E, $50, $51, $52, $53, $54, $55, $56, $57, $58, $5A, $5C, $5E
	.db $20, $84, $08, $FD, $22, $23, $24, $49, $4B, $4D, $4F
	.db $20, $94, $08, $59, $5B, $5D, $5F, $2E, $2F, $30, $FD
	.db $20, $A4, $03, $25, $26, $27
	.db $20, $B9, $03, $31, $32, $33
	.db $20, $C4, $03, $28, $29, $2A
	.db $20, $D9, $03, $34, $35, $36
	.db $20, $E3, $03, $2B, $2C, $2D
	.db $20, $FA, $03, $37, $38, $39
	.db $21, $03, $02, $3A, $3B
	.db $21, $1B, $02, $40, $41
	; ornate frame, lines down, top
	.db $21, $23, $C6, $3C
	.db $21, $3C, $C6, $42
	; ornate frame, middle
	.db $21, $E3, $01, $3D
	.db $21, $FC, $01, $60
	.db $22, $02, $02, $3E, $3F
	.db $22, $1C, $02, $61, $62
	.db $22, $22, $02, $43, $44
	.db $22, $3C, $02, $63, $64
	.db $22, $43, $01, $45
	.db $22, $5C, $01, $65
	; ornate frame, lines down, bottom
	.db $22, $63, $C6, $3C
	.db $22, $7C, $C4, $42
	; ornate frame, bottom, characters
;                          Snifit
	.db $22, $C4, $02, $A6, $A8
	.db $22, $E4, $02, $A7, $A9
;                          Mario,    Princess
	.db $22, $FA, $04, $80, $82, $88, $8A
;                          Luigi
	.db $23, $04, $02, $FF, $AF
;                          Radish
	.db $23, $14, $02, $9E, $A0
;                          Mario,    Princess
	.db $23, $1A, $04, $AC, $FF, $89, $8B
;                               Luigi
	.db $23, $23, $03, $46, $FF, $FF
;                          Shyguy
	.db $23, $2A, $02, $A2, $A4
;                                                        Radish,  Wind, Toad
	.db $23, $2E, $0B, $67, $6C, $6E, $70, $72, $69, $9F, $A1, $75, $98, $9A
;                          Mario,    Princess
	.db $23, $3A, $04, $FF, $FF, $8C, $8E
;                               Luigi,                        Shyguy
	.db $23, $43, $1B, $47, $94, $96, $74, $74, $74, $74, $A3, $A5, $74, $66, $68
;                                                   Toad           Mario,    Princess
	.db $6D, $6F, $71, $73, $6A, $6B, $74, $74, $99, $9B, $74, $85, $87, $8D, $8F
;                          Luigi,         Grass
	.db $23, $64, $05, $95, $97, $FD, $FD, $FD
;                          Toad,     Grass
	.db $23, $77, $04, $9C, $9D, $FD, $FD
;                          Grass
	.db $23, $89, $02, $FD, $FD

	; SUPER
	;                  SSSSSSSS  UUUUUUUU  PPPPPPPP  EEEEEEEE  RRRRRRRR
	.db $20, $CB, $0A, $00, $01, $08, $08, $FC, $01, $FC, $08, $FC, $01
	.db $20, $EB, $0A, $02, $03, $08, $08, $0A, $05, $0B, $0C, $0A, $0D
	.db $21, $0B, $0A, $04, $7B, $04, $7B, $0E, $07, $FD, $7C, $0E, $7C
	.db $21, $2B, $05, $06, $07, $06, $07, $09
	.db $21, $31, $04, $76, $09, $09, $09

	; TM
	;                  TTT  MMM
	.db $21, $38, $02, $F9, $FA

	; MARIO
	;                  MMMMMMMMMMMMM  AAAAAAAA  RRRRRRRR  III  OOOOOOOO
	.db $21, $46, $0A, $00, $0F, $01, $00, $01, $FC, $01, $08, $00, $01
	.db $21, $66, $0A, $10, $10, $08, $10, $08, $10, $08, $08, $10, $08
	.db $21, $86, $0A, $08, $08, $08, $08, $08, $13, $0D, $08, $08, $08
	.db $21, $A6, $0A, $7C, $7C, $7C, $FD, $7C, $0E, $7C, $7C, $7C, $7C
	.db $21, $C6, $0A, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $04, $7B
	.db $21, $E6, $0A, $09, $09, $09, $09, $09, $09, $09, $09, $06, $07

	; BROS
	;                  BBBBBBBB  RRRRRRRR  OOOOOOOO  SSSSSSSS
	.db $21, $51, $08, $FC, $01, $FC, $01, $00, $01, $00, $01 ; BROS
	.db $21, $71, $08, $10, $08, $10, $08, $10, $08, $10, $08
	.db $21, $91, $08, $13, $0D, $13, $0D, $08, $08, $77, $03
	.db $21, $B1, $08, $0E, $7C, $0E, $7C, $7C, $7C, $12, $7C
	.db $21, $D1, $09, $7D, $7B, $7C, $7C, $04, $7B, $04, $7B, $7C
	.db $21, $F1, $09, $11, $07, $09, $09, $06, $07, $06, $07, $09

	; 2
	;             22222222222222222222222
	.db $22, $0E, $04, $14, $15, $16, $17
	.db $22, $2E, $04, $18, $19, $1A, $1B
	.db $22, $4E, $04, $1C, $1D, $1E, $1F
	.db $22, $6E, $04, $78, $79, $7A, $20
	.db $22, $8E, $04, $76, $76, $76, $21

	; (C) 1988
	;                  (C)  111  999  888  888
	.db $22, $E9, $05, $F8, $D1, $D9, $D8, $D8 ; (C) 1988

	; NINTENDO
	;                  NNN  III  NNN  TTT  EEE  NNN  DDD  OOO
	.db $22, $EF, $08, $E7, $E2, $E7, $ED, $DE, $E7, $DD, $E8

	.db $23, $CA, $04, $80, $A0, $A0, $20
	.db $23, $D1, $0E, $80, $A8, $AA, $AA, $A2, $22, $00, $00, $88, $AA, $AA, $AA, $AA, $22
	.db $23, $E3, $02, $44, $11
	.db $23, $EA, $04, $F0, $F4, $F1, $F0
	.db $23, $F1, $01, $03
	.db $23, $F6, $01, $0C
	.db $00

TitleBackgroundPalettes:
	.db $0F, $37, $16, $07 ; Most of screen, outline, etc.
	.db $0F, $27, $38, $08 ; 2
	.db $0F, $31, $2C, $01 ; Logo
	.db $0F, $37, $27, $30 ; Copyright, Story, Sclera

TitleSpritePalettes:
	.db $0F, $01, $16, $27 ; Mario, Grass
	.db $0F, $36, $25, $06 ; Princess, Snifit
	.db $0F, $30, $27, $01 ; Toad, Radish
	.db $0F, $36, $2A, $01 ; Luigi

TitleOAM:
;           Y    Tile Attr X
	; Snifit - 4
	.db $AF, $A6, $01, $20 ; 22C4
	.db $AF, $A8, $01, $28 ; 22C5
	.db $B7, $A7, $01, $20 ; 22E4
	.db $B7, $A9, $01, $28 ; 22E5
	; Mario - 8
	.db $B7, $80, $00, $D0 ; 22FA
	.db $B7, $82, $00, $D8 ; 22FB
	.db $BF, $81, $00, $D0 ; 231A
	.db $BF, $83, $00, $D8 ; 231B
	.db $C7, $84, $00, $D0 ; 233A
	.db $C7, $86, $00, $D8 ; 233B
	.db $CF, $AD, $00, $D0 ; 235A
	.db $CF, $AE, $00, $D8 ; 235B
	; Luigi - 8
	.db $BF, $90, $03, $20 ; 2304
	.db $BF, $92, $03, $28 ; 2305
	.db $C7, $B0, $03, $20 ; 2324
	.db $C7, $93, $03, $28 ; 2325
	.db $CF, $B1, $03, $20 ; 2344
	.db $CF, $B2, $03, $28 ; 2345
	.db $D7, $B3, $03, $20 ; 2364
	.db $D7, $B4, $03, $28 ; 2365
	; Radish - 4
	.db $BF, $9E, $02, $A0 ; 2314
	.db $BF, $A0, $02, $A8 ; 2315
	.db $C7, $9F, $02, $A0 ; 2334
	.db $C7, $A1, $02, $A8 ; 2335
	; Toad - 6
	.db $C7, $98, $02, $B8 ; 2337
	.db $C7, $9A, $02, $C0 ; 2338
	.db $CF, $B5, $02, $B8 ; 2357
	.db $CF, $B6, $02, $C0 ; 2358
	.db $D7, $B7, $02, $B8 ; 2377
	.db $D7, $B8, $02, $C0 ; 2378
	; Grass - 2
	.db $D7, $AA, $03, $38 ; 2367
	.db $D7, $AB, $03, $40 ; 2368
	; Grass - 2
	.db $D7, $AA, $03, $C8 ; 2379
	.db $D7, $AB, $03, $D0 ; 237A
	; Grass - 2
	.db $DF, $AA, $03, $48 ; 2389
	.db $DF, $AB, $03, $50 ; 238A
	.db $00

TitleStoryText_STORY:
	.db $EC, $ED, $E8, $EB, $F2 ; STORY

TitleStoryTextPointersHi:
	.db >TitleStoryText_Line01
	.db >TitleStoryText_Line02
	.db >TitleStoryText_Line03
	.db >TitleStoryText_Line04
	.db >TitleStoryText_Line05
	.db >TitleStoryText_Line06
	.db >TitleStoryText_Line07
	.db >TitleStoryText_Line08
	.db >TitleStoryText_Line08 ; For some reason line 8 is referenced twice here, but not used
	.db >TitleStoryText_Line09
	.db >TitleStoryText_Line10
	.db >TitleStoryText_Line11
	.db >TitleStoryText_Line12
	.db >TitleStoryText_Line13
	.db >TitleStoryText_Line14
	.db >TitleStoryText_Line15
	.db >TitleStoryText_Line16

TitleStoryTextPointersLo:
	.db <TitleStoryText_Line01
	.db <TitleStoryText_Line02
	.db <TitleStoryText_Line03
	.db <TitleStoryText_Line04
	.db <TitleStoryText_Line05
	.db <TitleStoryText_Line06
	.db <TitleStoryText_Line07
	.db <TitleStoryText_Line08
	.db <TitleStoryText_Line08
	.db <TitleStoryText_Line09
	.db <TitleStoryText_Line10
	.db <TitleStoryText_Line11
	.db <TitleStoryText_Line12
	.db <TitleStoryText_Line13
	.db <TitleStoryText_Line14
	.db <TitleStoryText_Line15
	.db <TitleStoryText_Line16

TitleStoryText_Line01:
	.db $F0, $E1, $DE, $E7, $FB, $FB, $E6, $DA, $EB, $E2, $E8, $FB, $E8, $E9, $DE, $E7
	.db $DE, $DD, $FB, $DA ; WHEN MARIO OPENED A

TitleStoryText_Line02:
	.db $DD, $E8, $E8, $EB, $FB, $DA, $DF, $ED, $DE, $EB, $FB, $FB, $DC, $E5, $E2, $E6
	.db $DB, $E2, $E7, $E0 ; DOOR AFTER CLIMBING

TitleStoryText_Line03:
	.db $DA, $FB, $E5, $E8, $E7, $E0, $FB, $EC, $ED, $DA, $E2, $EB, $FB, $E2, $E7, $FB
	.db $FB, $E1, $E2, $EC ; A LONG STAIR IN HIS

TitleStoryText_Line04:
	.db $DD, $EB, $DE, $DA, $E6, $F7, $FB, $DA, $E7, $E8, $ED, $E1, $DE, $EB, $FB, $F0
	.db $E8, $EB, $E5, $DD ; DREAM, ANOTHER WORLD

TitleStoryText_Line05:
	.db $EC, $E9, $EB, $DE, $DA, $DD, $FB, $FB, $FB, $DB, $DE, $DF, $E8, $EB, $DE, $FB
	.db $FB, $E1, $E2, $E6 ; SPREAD BEFORE HIM

TitleStoryText_Line06:
	.db $DA, $E7, $DD, $FB, $E1, $DE, $FB, $E1, $DE, $DA, $EB, $DD, $FB, $DA, $FB, $EF
	.db $E8, $E2, $DC, $DE ; AND HE HEARD A VOICE

TitleStoryText_Line07:
	.db $DC, $DA, $E5, $E5, $FB, $DF, $E8, $EB, $FB, $E1, $DE, $E5, $E9, $FB, $ED, $E8
	.db $FB, $FB, $DB, $DE ; CALL FOR HELP TO BE

TitleStoryText_Line08:
	.db $FB, $DF, $EB, $DE, $DE, $DD, $FB, $FB, $DF, $EB, $E8, $E6, $FB, $DA, $FB, $EC
	.db $E9, $DE, $E5, $E5 ; FREED FROM A SPELL

TitleStoryText_Line09:
	.db $DA, $DF, $ED, $DE, $EB, $FB, $FB, $DA, $F0, $DA, $E4, $DE, $E7, $E2, $E7, $E0
	.db $F7, $FB, $FB, $FB ; AFTER AWAKENING,

TitleStoryText_Line10:
	.db $E6, $DA, $EB, $E2, $E8, $FB, $FB, $F0, $DE, $E7, $ED, $FB, $ED, $E8, $FB, $FB
	.db $DA, $FB, $FB, $FB ; MARIO WENT TO A

TitleStoryText_Line11:
	.db $DC, $DA, $EF, $DE, $FB, $FB, $E7, $DE, $DA, $EB, $DB, $F2, $FB, $DA, $E7, $DD
	.db $FB, $FB, $ED, $E8 ; CAVE NEARBY AND TO

TitleStoryText_Line12:
	.db $E1, $E2, $EC, $FB, $FB, $EC, $EE, $EB, $E9, $EB, $E2, $EC, $DE, $FB, $E1, $DE
	.db $FB, $EC, $DA, $F0 ; HIS SURPRISE HE SAW

TitleStoryText_Line13:
	.db $DE, $F1, $DA, $DC, $ED, $E5, $F2, $FB, $FB, $F0, $E1, $DA, $ED, $FB, $E1, $DE
	.db $FB, $EC, $DA, $F0 ; EXACTLY WHAT HE SAW

TitleStoryText_Line14:
	.db $E2, $E7, $FB, $E1, $E2, $EC, $FB, $DD, $EB, $DE, $DA, $E6, $CF, $CF, $CF, $CF
	.db $FB, $FB, $FB, $FB ; IN HIS DREAM....

TitleStoryText_Line15:
	.db $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB
	.db $FB, $FB, $FB, $FB ; (blank)

TitleStoryText_Line16:
	.db $FB, $FB, $E9, $EE, $EC, $E1, $FB, $EC, $ED, $DA, $EB, $ED, $FB, $DB, $EE, $ED
	.db $ED, $E8, $E7, $FB ; PUSH START BUTTON

TitleAttributeData1:
	.db $23, $CB, $42, $FF
	.db $23, $D1, $01, $CC
	.db $23, $D2, $44, $FF
	.db $23, $D6, $01, $33
	.db $23, $D9, $01, $CC
	.db $23, $DA, $44, $FF

TitleAttributeData2:
	.db $23, $DE, $01, $33
	.db $23, $E1, $01, $CC
	.db $23, $E2, $44, $FF
	.db $23, $E6, $01, $33
	.db $23, $EA, $44, $FF
	.db $23, $E9, $01, $CC
	.db $23, $EE, $01, $33


; =============== S U B R O U T I N E =======================================

TitleScreen:
	LDY #$07 ; Does initialization of RAM.
	STY z01 ; This clears $200 to $7FF.
	LDY #$00
	STY z00
	TYA

InitMemoryLoop:
	STA (z00), Y ; I'm not sure if a different method of initializing memory
; would work better in this case.
	DEY
	BNE InitMemoryLoop

	DEC z01
	LDX z01
	CPX #$02
	BCS InitMemoryLoop ; Stop initialization after we hit $200.

loc_BANK0_9A53:
	LDA #$00
	TAY

InitMemoryLoop2:
	; Clear $0000-$00FF.
	; Notably, this leaves the stack area $0100-$01FF uninitialized.
	; This is not super important, but you might want to do it yourself to
	; track stack corruption or whatever.
	STA z00, Y
	INY
	BNE InitMemoryLoop2

	JSR LoadTitleScreenCHRBanks

	JSR ClearNametablesAndSprites

	LDA PPUSTATUS
	LDA #$3F
	LDY #$00
	STA PPUADDR
	STY PPUADDR

InitTitleBackgroundPalettesLoop:
	LDA TitleBackgroundPalettes, Y
	STA PPUDATA
	INY
	CPY #$20
	BCC InitTitleBackgroundPalettesLoop

	LDA #$01
	STA zPPUDataBufferPointer
	LDA #$03
	STA zPPUDataBufferPointer + 1
	LDA #Stack100_Menu
	STA iStack
	; PPUCtrl_Base2000
	; PPUCtrl_WriteHorizontal
	; PPUCtrl_Sprite0000
	; PPUCtrl_Background1000
	; PPUCtrl_SpriteSize8x8
	; PPUCtrl_NMIEnabled
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x8 | PPUCtrl_NMIEnabled
	STA zPPUControl
	STA PPUCTRL
	; zScreenUpdateIndex is already 0
	; wait to read from iPPUBuffer
	JSR WaitForNMI_TitleScreen

	LDA #$01 ; AKA BG Layout
	STA zScreenUpdateIndex
	JSR WaitForNMI_TitleScreen

	JSR PlaceTitleSprites

	LDA #Music_Title
	STA iMusic
	JSR WaitForNMI_TitleScreen_TurnOnPPU

	LDA #$03
	STA z10
	LDA #$25
	STA zTitleScreenTimer
	LDA #$20
	STA zPlayerXHi
	LDA #$C7
	STA zObjectXHi
	LDA #$52
	STA zObjectXHi + 1

loc_BANK0_9AB4:
	JSR WaitForNMI_TitleScreen

	LDA zObjectXHi + 2
	BNE loc_BANK0_9AF3

loc_BANK0_9ABB:
	INC z10
	LDA z10
	AND #$0F
	BEQ loc_BANK0_9AC6

	JMP loc_BANK0_9B4D

; ---------------------------------------------------------------------------

loc_BANK0_9AC6:
	DEC z02
	LDA z02
	CMP #$06
	BNE loc_BANK0_9B4D

	INC zObjectXHi + 2
	LDA zPlayerXHi
	STA iPPUBuffer
	LDA zObjectXHi
	STA iPPUBuffer + 1
	LDA zObjectXHi + 1
	STA iPPUBuffer + 2
	LDA #$E6
	STA zObjectXHi
	LDA #$54
	STA zObjectXHi + 1
	LDA #$0FB
	STA iPPUBuffer + 3
	LDA #$00
	STA iPPUBuffer + 4
	BEQ loc_BANK0_9B4D

loc_BANK0_9AF3:
	LDA zPlayerXHi
	STA iPPUBuffer
	LDA zObjectXHi
	STA iPPUBuffer + 1
	LDA zObjectXHi + 1
	STA iPPUBuffer + 2
	LDA #$0FB
	STA iPPUBuffer + 3
	LDA #$00
	STA iPPUBuffer + 4
	LDA zObjectXHi
	CLC
	ADC #$20
	STA zObjectXHi
	LDA zPlayerXHi
	ADC #$00
	STA zPlayerXHi
	CMP #$23

loc_BANK0_9B1B:
	BCC loc_BANK0_9B4D

	LDA #$20
	STA z10
	LDX #$17
	LDY #$00

loc_BANK0_9B25:
	LDA TitleAttributeData1, Y
	STA iPPUBuffer + 4, Y
	INY
	DEX
	BPL loc_BANK0_9B25

	LDA #$00
	STA iPPUBuffer + 4, Y
	JSR WaitForNMI_TitleScreen

	LDX #$1B
	LDY #$00

loc_BANK0_9B3B:
	LDA TitleAttributeData2, Y
	STA iPPUBuffer, Y
	INY
	DEX
	BPL loc_BANK0_9B3B

	LDA #$00
	STA iPPUBuffer, Y
	JMP loc_BANK0_9B59

; ---------------------------------------------------------------------------

loc_BANK0_9B4D:
	LDA zInputBottleneck
	AND #ControllerInput_Start
	BEQ loc_BANK0_9B56

	JMP loc_BANK0_9C1F

; ---------------------------------------------------------------------------

loc_BANK0_9B56:
	JMP loc_BANK0_9AB4

; ---------------------------------------------------------------------------

loc_BANK0_9B59:
	JSR WaitForNMI_TitleScreen

	LDA zObjectXHi + 4
	BEQ loc_BANK0_9B63

	JMP loc_BANK0_9C19

; ---------------------------------------------------------------------------

loc_BANK0_9B63:
	LDA zObjectXHi + 3
	CMP #$09
	BEQ loc_BANK0_9B93

	LDA zObjectXHi + 3
	BNE loc_BANK0_9BA3

	DEC z10
	BMI TitleScreen_WriteSTORYText

	JMP loc_BANK0_9C19

; ---------------------------------------------------------------------------

TitleScreen_WriteSTORYText:
	LDA #$20
	STA iPPUBuffer
	LDA #$0AE
	STA iPPUBuffer + 1
	LDA #$05 ; Length of STORY text (5 bytes)
	STA iPPUBuffer + 2
	LDY #$04 ; Bytes to copy minus one (5-1=4)

TitleScreen_WriteSTORYTextLoop:
	LDA TitleStoryText_STORY, Y ; Copy STORY text to PPU write buffer
	STA iPPUBuffer + 3, Y
	DEY
	BPL TitleScreen_WriteSTORYTextLoop

	LDA #$00 ; Terminate STORY text in buffer
	STA iPPUBuffer + 8

loc_BANK0_9B93:
	INC zObjectXHi + 3
	LDA #$21
	STA zPlayerXHi
	LDA #$06
	STA zObjectXHi
	LDA #$40
	STA zObjectXHi + 5
	BNE loc_BANK0_9C19

loc_BANK0_9BA3:
	DEC zObjectXHi + 5
	BPL loc_BANK0_9C19

loc_BANK0_9BA7:
	LDA #$40
	STA zObjectXHi + 5
	LDA zPlayerXHi
	STA iPPUBuffer

loc_BANK0_9BB0:
	LDA zObjectXHi

loc_BANK0_9BB2:
	STA iPPUBuffer + 1
	LDA #$14
	STA iPPUBuffer + 2
	LDX zObjectXHi + 3
	DEX
	LDA TitleStoryTextPointersHi, X
	STA z04
	LDA TitleStoryTextPointersLo, X
	STA z03
	LDY #$00
	LDX #$13

loc_BANK0_9BCB:
	LDA (z03), Y
	STA iPPUBuffer + 3, Y
	INY
	DEX
	BPL loc_BANK0_9BCB

	LDA #$00
	STA iPPUBuffer + 3, Y
	INC zObjectXHi + 3
	LDA zObjectXHi
	CLC
	ADC #$40
	STA zObjectXHi
	LDA zPlayerXHi
	ADC #$00
	STA zPlayerXHi
	LDA zObjectXHi + 3
	CMP #$09
	BCC loc_BANK0_9C19

	BNE loc_BANK0_9C0B

	LDA #$09
	STA z02
	LDA #$03
	STA z10
	LDA #$20
	STA zPlayerXHi
	LDA #$C7
	STA zObjectXHi
	LDA #$52
	STA zObjectXHi + 1
	LDA #$00
	STA zObjectXHi + 2
	JMP loc_BANK0_9ABB

; ---------------------------------------------------------------------------

loc_BANK0_9C0B:
	CMP #$12
	BCC loc_BANK0_9C19

	INC zObjectXHi + 4
	LDA #$25
	STA z02
	LDA #$03
	STA z10

loc_BANK0_9C19:
	LDA zInputCurrentState
	AND #ControllerInput_Start
	BEQ loc_BANK0_9C35

loc_BANK0_9C1F:
	LDA #Music_StopMusic
	STA iMusic
	JSR WaitForNMI_TitleScreen

	LDA #$00
	TAY

loc_BANK0_9C2A:
	STA z00, Y
	INY
	CPY #$F0
	BCC loc_BANK0_9C2A

	JSR HideAllSprites

	INC iMainGameState
	LDA #$02 ; Number of continues on start
	STA iNumContinues
	RTS

; ---------------------------------------------------------------------------

loc_BANK0_9C35:
	LDA zObjectXHi + 4
	BEQ loc_BANK0_9C4B

	INC z10
	LDA z10
	AND #$0F
	BNE loc_BANK0_9C4B

	DEC z02
	LDA z02
	CMP #$06
	BNE loc_BANK0_9C4B

	BEQ loc_BANK0_9C4E

loc_BANK0_9C4B:
	JMP loc_BANK0_9B59

; ---------------------------------------------------------------------------

loc_BANK0_9C4E:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x8 | PPUCtrl_NMIDisabled
	STA zPPUControl

loc_BANK0_9C52:
	STA PPUCTRL
	JMP loc_BANK0_9A53

; End of function TitleScreen



EndingPPUDataPointers:
	.dw iPPUBuffer
	.dw EndingCorkJarRoom
	.dw EndingCelebrationCeilingTextAndPodium
	.dw EndingCelebrationFloorAndSubconParade
	.dw EndingCelebrationPaletteFade1
	.dw EndingCelebrationPaletteFade2
	.dw EndingCelebrationPaletteFade3
	.dw EndingCelebrationSubconStandStill
	.dw EndingCelebrationUnusedText_THE_END
	.dw EndingCelebrationText_MARIO
	.dw EndingCelebrationText_PRINCESS
	.dw EndingCelebrationText_TOAD
	.dw EndingCelebrationText_LUIGI


WaitForNMI_Ending_TurnOffPPU:
	LDA #$00
	BEQ WaitForNMI_Ending_SetPPUMaskMirror

WaitForNMI_Ending_TurnOnPPU:
	LDA #PPUMask_ShowLeft8Pixels_BG | PPUMask_ShowLeft8Pixels_SPR | PPUMask_ShowBackground | PPUMask_ShowSprites

WaitForNMI_Ending_SetPPUMaskMirror:
	STA zPPUMask

WaitForNMI_Ending:
	LDA zScreenUpdateIndex
	ASL A
	TAX
	LDA EndingPPUDataPointers, X
	STA zPPUDataBufferPointer
	LDA EndingPPUDataPointers + 1, X
	STA zPPUDataBufferPointer + 1

	LDA #$00
	STA zNMIOccurred
WaitForNMI_EndingLoop:
	LDA zNMIOccurred
	BPL WaitForNMI_EndingLoop
	RTS


EndingCorkJarRoom:
	; palettes
	.db $3F, $00, $10
	.db $30, $31, $21, $0F ; $50
	.db $30, $27, $16, $0F ; $54
	.db $30, $38, $13, $0F ; $58
	.db $30, $27, $2A, $0F ; $5C
	.db $3F, $14, $0C
	.db $FF, $37, $16, $0F ; $1C
	.db $FF, $30, $10, $0F ; $20
	.db $30, $26, $16, $06 ; $54

	; layout
	; upper left wall
	.db $20, $00, $9E, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72, $73
	.db $20, $01, $9E, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73, $72
	; lower left wall
	.db $22, $02, $8E, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73
	.db $22, $03, $8E, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72
	; floor
	.db $23, $44, $18, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $23, $64, $18, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $23, $84, $18, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $23, $A4, $18, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	; lower right wall
	.db $22, $1C, $8E, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73
	.db $22, $1D, $8E, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72
	; upper right wall
	.db $20, $1E, $9E, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72, $73
	.db $20, $1F, $9E, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73, $72
	; door
	.db $22, $C6, $84, $80, $82, $84, $86
	.db $22, $C7, $84, $81, $83, $85, $87
	; jar platform
	.db $23, $0E, $06, $74, $76, $74, $76, $74, $76
	.db $23, $2E, $06, $75, $77, $75, $77, $75, $77

	; upper back wall (above stain glass window)
	.db $20, $02, $5C, $92
	.db $20, $22, $5C, $92
	; stain glass windows
	.db $20, $42, $1C ; row 1
	.db $A8, $A9, $A9, $A9, $A9, $AA
	.db $A8, $A9, $A9, $A9, $A9, $AA
	.db $A8, $A9, $A9, $A9, $A9, $AA
	.db $A8, $A9, $A9, $A9, $A9, $AA
	.db $A8, $A9, $A9, $A9
	.db $20, $62, $1C ; row 2
	.db $AF, $B0, $B1, $B2, $B3, $AB
	.db $AF, $B3, $B0, $B1, $B2, $AB
	.db $AF, $B2, $B3, $B0, $B1, $AB
	.db $AF, $B1, $B2, $B3, $B0, $AB
	.db $AF, $B0, $B1, $B2
	.db $20, $82, $1C ; row 3
	.db $AF, $BB, $BC, $BD, $B4, $AB
	.db $AF, $B4, $BB, $BC, $BD, $AB
	.db $AF, $BD, $B4, $BB, $BC, $AB
	.db $AF, $BC, $BD, $B4, $BB, $AB
	.db $AF, $BB, $BC, $BD
	.db $20, $A2, $1C ; row 4
	.db $AF, $BA, $BE, $BF, $B5, $AB
	.db $AF, $B5, $BA, $BE, $BF, $AB
	.db $AF, $BF, $B5, $BA, $BE, $AB
	.db $AF, $BE, $BF, $B5, $BA, $AB
	.db $AF, $BA, $BE, $BF
	.db $20, $C2, $1C ; row 5
	.db $AF, $B9, $B8, $B7, $B6, $AB
	.db $AF, $B6, $B9, $B8, $B7, $AB
	.db $AF, $B7, $B6, $B9, $B8, $AB
	.db $AF, $B8, $B7, $B6, $B9, $AB
	.db $AF, $B9, $B8, $B7
	.db $20, $E2, $1C ; row 6
	.db $AE, $AD, $AD, $AD, $AD, $AC
	.db $AE, $AD, $AD, $AD, $AD, $AC
	.db $AE, $AD, $AD, $AD, $AD, $AC
	.db $AE, $AD, $AD, $AD, $AD, $AC
	.db $AE, $AD, $AD, $AD

	; lower back wall (below stain glass window)
	.db $21, $02, $C8, $92
	.db $21, $03, $C8, $92
	.db $21, $1C, $C8, $92
	.db $21, $1D, $C8, $92
	.db $21, $04, $58, $92
	.db $21, $24, $58, $92
	.db $21, $44, $58, $92
	.db $21, $64, $58, $92
	.db $21, $84, $58, $92

	; each side of the lower part of the room
	; left
	.db $21, $A4, $CD, $92
	.db $21, $A5, $CD, $92
	.db $21, $A6, $C9, $92 ; above door
	.db $21, $A7, $C9, $92
	.db $21, $A8, $CD, $92
	.db $21, $A9, $CD, $92
	.db $21, $AA, $CD, $92
	; right
	.db $21, $B7, $CD, $92
	.db $21, $B8, $CD, $92
	.db $21, $B9, $CD, $92
	.db $21, $BA, $CD, $92
	.db $21, $BB, $CD, $92

	; window to sky
	; left frame
	.db $21, $AB, $85, $92, $92, $92, $95, $93
	.db $22, $4B, $C8, $90
	.db $21, $AC, $85, $92, $92, $9B, $96, $94
	.db $21, $AD, $83, $92, $9B, $9C
	; right frame
	.db $21, $B4, $83, $92, $9D, $9E
	.db $21, $B5, $85, $92, $92, $9D, $9A, $98
	.db $21, $B6, $85, $92, $92, $92, $99, $97
	.db $22, $56, $C8, $91
	; center frame
	.db $21, $AE, $06, $9B, $9F, $A6, $A7, $9F, $9D
	.db $21, $CE, $06, $9C, $FD, $FD, $FD, $FD, $9E

	; the sky itself
	.db $21, $EE, $46, $FD
	.db $22, $0D, $48, $FD
	.db $22, $2D, $48, $FD
	.db $22, $4C, $4A, $FD
	.db $22, $6C, $4A, $A0
	.db $22, $8C, $0A, $A1, $A2, $A1, $A2, $00, $00, $A1, $A2, $A1, $A2
	.db $22, $AC, $0A, $A3, $A4, $A5, $A4, $00, $00, $A5, $A4, $A3, $A4

	; attributes
	.db $23, $C0, $20
	.db $E2, $D0, $70, $F0, $D0, $70, $F0, $98
	.db $E6, $D6, $71, $FD, $F6, $F3, $F5, $9A
	.db $22, $00, $00, $00, $00, $00, $00, $88
	.db $22, $00, $00, $00, $00, $00, $00, $88
	.db $23, $E0, $20
	.db $AA, $00, $00, $00, $00, $00, $00, $AA
	.db $AA, $40, $00, $00, $00, $00, $00, $AA
	.db $AA, $A4, $A0, $A8, $AA, $A0, $A0, $AA
	.db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A

	.db $00

EndingCelebrationUnusedText_THANK_YOU:
	.db $21, $0C, $09, $ED, $E1, $DA, $E7, $E4, $FB, $F2, $E8, $EE
	.db $00

CorkRoomSpriteStartX:
	.db $30 ; player
	.db $80 ; subcon 8
	.db $80 ; subcon 7
	.db $80 ; subcon 6
	.db $80 ; subcon 5
	.db $80 ; subcon 4
	.db $80 ; subcon 3
	.db $80 ; subcon 2
	.db $80 ; subcon 1
	.db $80 ; cork

CorkRoomSpriteStartY:
	.db $B0 ; player
	.db $A0 ; subcon 8
	.db $A0 ; subcon 7
	.db $A0 ; subcon 6
	.db $A0 ; subcon 5
	.db $A0 ; subcon 4
	.db $A0 ; subcon 3
	.db $A0 ; subcon 2
	.db $A0 ; subcon 1
	.db $95 ; cork

CorkRoomSpriteTargetX:
	.db $10 ; player
	.db $F4 ; subcon 8
	.db $0C ; subcon 7
	.db $E8 ; subcon 6
	.db $18 ; subcon 5
	.db $EC ; subcon 4
	.db $14 ; subcon 3
	.db $F8 ; subcon 2
	.db $08 ; subcon 1
	.db $00 ; cork

CorkRoomSpriteTargetY:
	.db $00 ; player
	.db $C4 ; subcon 8
	.db $C4 ; subcon 7
	.db $B8 ; subcon 6
	.db $B8 ; subcon 5
	.db $A8 ; subcon 4
	.db $A8 ; subcon 3
	.db $A0 ; subcon 2
	.db $A0 ; subcon 1
	.db $00 ; cork

CorkRoomSpriteDelay:
	.db $00 ; player
	.db $E0 ; subcon 8
	.db $D0 ; subcon 7
	.db $B0 ; subcon 6
	.db $90 ; subcon 5
	.db $70 ; subcon 4
	.db $50 ; subcon 3
	.db $30 ; subcon 2
	.db $10 ; subcon 1
	.db $00 ; cork

CorkRoomSpriteAttributes:
	.db $00 ; player
	.db $01 ; subcon 8
	.db $41 ; subcon 7
	.db $01 ; subcon 6
	.db $41 ; subcon 5
	.db $01 ; subcon 4
	.db $41 ; subcon 3
	.db $01 ; subcon 2
	.db $41 ; subcon 1
	.db $02 ; cork

CorkRoomJarOAMData:
;           Y    Tile Attr X
	.db $9F, $88, $03, $80
	.db $9F, $8A, $03, $88
	.db $AF, $8C, $03, $80
	.db $AF, $8E, $03, $88
	.db $00

FreeSubconsScene:
	JSR WaitForNMI_Ending_TurnOffPPU
	JSR ClearNametablesAndSprites

	LDA #CHRBank_SubconEndingTiles
	STA iObjCHR3
	STA iBGCHR2

	LDA #Stack100_Menu
	STA iStack
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	STA zPPUControl
	STA PPUCTRL
	JSR WaitForNMI_Ending

	LDA #EndingUpdateBuffer_JarRoom
	STA zScreenUpdateIndex
	JSR WaitForNMI_Ending

	LDA #$60
	STA zEndgameTimer
	LDA #$01
	STA zPlayerFacing
	LSR A
	STA zPlayerState ; A=$00
	STA zEndgameCorkTimer
	STA iCrouchJumpTimer
	STA ze6
	STA ze5
	STA iObjectFlickerer

	LDX #$09
FreeSubconsScene_SpriteLoop:
	LDA CorkRoomSpriteStartX, X
	STA zObjectXLo - 1, X
	LDA CorkRoomSpriteStartY, X
	STA zObjectYLo - 1, X
	LDA CorkRoomSpriteTargetX, X
	STA zObjectXVelocity - 1, X
	LDA CorkRoomSpriteTargetY, X
	STA zObjectYVelocity - 1, X
	LDA CorkRoomSpriteDelay, X
	STA zSpriteTimer - 1, X
	LDA CorkRoomSpriteAttributes, X
	STA zObjectAttributes - 1, X
	DEX
	BPL FreeSubconsScene_SpriteLoop

FreeSubconsScene_JumpingLoop:
	JSR WaitForNMI_Ending_TurnOnPPU

	INC z10
	JSR HideAllSprites

	JSR PlaceCorkRoomJar

	JSR FreeSubconsScene_Player

	JSR FreeSubconsScene_Cork

	LDA zEndgameTimer
	BEQ FreeSubconsScene_Exit

	LDA z10
	AND #$07
	BNE FreeSubconsScene_JumpingLoop

	DEC zEndgameTimer
	LDA zEndgameTimer
	CMP #$25
	BNE FreeSubconsScene_JumpingLoop

	LDY #Music_EndingAndCast
	STY iMusic
	BNE FreeSubconsScene_JumpingLoop

FreeSubconsScene_Exit:
	JSR EndingSceneTransition

	LDA ze6
	BEQ FreeSubconsScene_JumpingLoop
	RTS


;
; Moves the player, driving the main action in the scene
;
FreeSubconsScene_Player:
	LDA zWalkCycleTimer
	BEQ FreeSubconsScene_Player_AfterWalkFrameCounter

	DEC zWalkCycleTimer

FreeSubconsScene_Player_AfterWalkFrameCounter:
	LDA zPlayerStateTimer
	BEQ FreeSubconsScene_Player_AfterStateTimer

	DEC zPlayerStateTimer

FreeSubconsScene_Player_AfterStateTimer:
	LDA zPlayerXLo
	STA iPlayerScreenX
	LDA zPlayerYLo
	STA iPlayerScreenY
	JSR RenderPlayer

	LDA zPlayerState
	JSR JumpToTableAfterJump


	.dw FreeSubconsScene_Phase1
	.dw FreeSubconsScene_Phase2
	.dw FreeSubconsScene_Phase3
	.dw FreeSubconsScene_Phase4
	.dw FreeSubconsScene_Phase5


; Walking in and first jump
FreeSubconsScene_Phase1:
	JSR PlayerWalkJumpAnim

	JSR ApplyPlayerPhysicsX

	; check x-position to trigger first jump
	LDA zPlayerXLo
	CMP #$3E
	BCC FreeSubconsScene_PhaseExit

	INC zPlayerState
	INC zPlayerGrounding
	LDA #SpriteAnimation_Jumping
	STA zPlayerAnimFrame

FreeSubconsScene_Jump:
	LDA #Hill_Jump
	STA iHillSFX
	JMP PlayerStartJump


; Physics and second jump
FreeSubconsScene_Phase2:
	JSR PlayerWalkJumpAnim

	JSR ApplyPlayerPhysicsX

	JSR ApplyCorkRoomGravity

	JSR ApplyPlayerPhysicsY

	LDA zPlayerYVelocity
	BMI FreeSubconsScene_PhaseExit

	; check y-position to trigger second jump
	LDA zPlayerYLo
	CMP #$A0
	BCC FreeSubconsScene_Phase2_NoJump

	; set x-velocity to land second jump on the jar
	LDA #$0C
	STA zPlayerXVelocity
	JMP FreeSubconsScene_Jump

FreeSubconsScene_Phase2_NoJump:
	; check the top of the jar
	CMP #$75
	BCC FreeSubconsScene_PhaseExit

	; check x-position for jar
	LDA zPlayerXLo
	CMP #$70
	BCC FreeSubconsScene_PhaseExit

	INC zPlayerState
	DEC zPlayerGrounding

FreeSubconsScene_PhaseExit:
	RTS


; Start pulling the cork
FreeSubconsScene_Phase3:
	JSR PlayerWalkJumpAnim

	JSR ApplyPlayerPhysicsX

	; check x-position for jar
	LDA zPlayerXLo
	CMP #$80
	BCC FreeSubconsScene_PhaseExit

	; pull the cork
	INC zPlayerState
	INC zHeldItem
	LDA #SpriteAnimation_Pulling
	STA zPlayerAnimFrame
	LDA #$05
	STA zEndgameCorkTimer
	LDA #$28
	STA zPlayerStateTimer
	RTS


PullCorkFrameDurations:
	.db $14
	.db $0A
	.db $14
	.db $0A

PullCorkOffsets:
	.db $1C
	.db $1B
	.db $1E
	.db $1D
	.db $1F


; Pull the cork out
FreeSubconsScene_Phase4:
	; use zPlayerStateTimer to hold this frame
	LDA zPlayerStateTimer
	BNE FreeSubconsScene_Phase4_Exit

	; next zEndgameCorkTimer to move cork
	DEC zEndgameCorkTimer
	BNE FreeSubconsScene_Phase4_NextCorkFrame

	; uncorked! start jumping
	INC zPlayerState
	INC zPlayerGrounding

	LDA #SpriteAnimation_Jumping
	STA zPlayerAnimFrame

	LDA #DPCM_Uproot
	STA iDPCMSFX

	LDA #$A0
	STA zObjectYVelocity + 8
	RTS

FreeSubconsScene_Phase4_NextCorkFrame:
	LDY zEndgameCorkTimer
	LDA PullCorkFrameDurations - 1, Y
	STA zPlayerStateTimer

FreeSubconsScene_Phase4_Exit:
	RTS


; Free Subcons and jump repeatedly
FreeSubconsScene_Phase5:
	JSR FreeSubconsScene_Subcons

	JSR ApplyCorkRoomGravity

	JSR PlayerWalkJumpAnim

	JSR ApplyPlayerPhysicsY

	LDA zPlayerYVelocity
	BMI FreeSubconsScene_Phase5_Exit

	; jump when we're on the jar
	LDA zPlayerYLo
	CMP #$80
	BCC FreeSubconsScene_Phase5_Exit

	JMP PlayerStartJump

FreeSubconsScene_Phase5_Exit:
	RTS


CorkRoomCharacterGravity:
	.db $04 ; Mario
	.db $04 ; Princess
	.db $04 ; Toad
	.db $01 ; Luigi


ApplyCorkRoomGravity:
	LDY zCurrentCharacter
	LDA CorkRoomCharacterGravity, Y
	CLC
	ADC zPlayerYVelocity
	STA zPlayerYVelocity
	RTS


;
; Spits out Subcons and makes them flap their little wings
;
FreeSubconsScene_Subcons:
	LDX #$07

FreeSubconsScene_Subcons_Loop:
	STX z12
	LDA zSpriteTimer, X
	BEQ FreeSubconsScene_Subcons_Movement

	CMP #$01
	BNE FreeSubconsScene_Subcons_Next

	LDA #Hill_Throw
	STA iHillSFX
	BNE FreeSubconsScene_Subcons_Next

FreeSubconsScene_Subcons_Movement:
	JSR ApplyObjectMovement_Bank1

	LDA zObjectYVelocity, X
	CMP #$08
	BMI FreeSubconsScene_Subcons_Render

	LDA #$00
	STA zObjectXVelocity, X
	LDA #$F9
	STA zObjectYVelocity, X
	LDA CorkRoomSpriteAttributes + 1, X
	EOR #ObjAttrib_Palette0 | ObjAttrib_16x32
	STA zObjectAttributes, X

FreeSubconsScene_Subcons_Render:
	LDA z10
	ASL A
	AND #$02
	STA z0f
	JSR FreeSubconsScene_Render

	INC zSpriteTimer, X

FreeSubconsScene_Subcons_Next:
	DEC zSpriteTimer, X
	DEX
	BPL FreeSubconsScene_Subcons_Loop
	RTS



FreeSubconsScene_Cork:
	LDA #$04
	STA z0f
	LDX #$08
	STX z12
	JSR FreeSubconsScene_Render

	LDY zEndgameCorkTimer
	BNE FreeSubconsScene_Cork_Pull

	LDA zObjectYLo + 8
	CMP #$F0
	BCS FreeSubconsScene_Cork_Exit

	JMP ApplyObjectPhysicsY_Bank1

FreeSubconsScene_Cork_Pull:
	LDA PullCorkOffsets - 1, Y
	CLC
	ADC zPlayerYLo
	STA zObjectYLo + 8

FreeSubconsScene_Cork_Exit:
	RTS


CorkRoomSpriteTiles:
	.db $E8 ; subcon left, wings up
	.db $EA ; subcon right, wings up
	.db $EC ; subcon left, wings down
	.db $EE ; subcon right, wings down
	.db $61 ; cork left
	.db $63 ; cork right

CorkRoomSpriteOAMAddress:
	.db $30 ; subcon 8
	.db $38 ; subcon 7
	.db $40 ; subcon 6
	.db $48 ; subcon 5
	.db $50 ; subcon 4
	.db $58 ; subcon 3
	.db $60 ; subcon 2
	.db $68 ; subcon 1
	.db $10 ; cork


FreeSubconsScene_Render:
	LDY CorkRoomSpriteOAMAddress, X
	LDA zObjectYLo, X
	STA iVirtualOAM, Y
	STA iVirtualOAM + 4, Y
	LDA zObjectXLo, X
	STA iVirtualOAM + 3, Y
	CLC
	ADC #$08
	STA iVirtualOAM + 7, Y
	LDA zObjectAttributes, X
	STA iVirtualOAM + 2, Y
	STA iVirtualOAM + 6, Y
	LDX z0f
	AND #ObjAttrib_16x32
	BNE FreeSubconsScene_Render_Flipped

	LDA CorkRoomSpriteTiles, X
	STA iVirtualOAM + 1, Y
	LDA CorkRoomSpriteTiles + 1, X
	BNE FreeSubconsScene_Render_Exit

FreeSubconsScene_Render_Flipped:
	LDA CorkRoomSpriteTiles + 1, X
	STA iVirtualOAM + 1, Y
	LDA CorkRoomSpriteTiles, X

FreeSubconsScene_Render_Exit:
	STA iVirtualOAM + 5, Y
	LDX z12
	RTS


EndingCelebrationCeilingTextAndPodium:
	.db $20, $00, $20
	.db $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81
	.db $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81

	.db $20, $20, $20
	.db $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80
	.db $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80

	.db $20, $40, $20
	.db $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81
	.db $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81

	.db $20, $60, $20
	.db $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80
	.db $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80

	.db $20, $88, $01, $5A
	.db $20, $89, $4E, $9A
	.db $20, $97, $01, $5C
	.db $20, $A8, $C3, $9B
	.db $20, $B7, $C3, $56
	.db $21, $08, $01, $5B
	.db $21, $09, $4E, $57
	.db $21, $17, $01, $5D
	.db $20, $A9, $4E, $FE
	.db $20, $C9, $4E, $FE
	.db $20, $E9, $4E, $FE
	.db $20, $AB, $0B, $DC, $E8, $E7, $ED, $EB, $E2, $DB, $EE, $ED, $E8, $EB
	.db $20, $E3, $04, $40, $42, $44, $46
	.db $20, $F9, $04, $40, $42, $44, $46
	.db $21, $23, $C9, $48
	.db $21, $24, $C9, $49
	.db $21, $25, $C9, $4A
	.db $21, $26, $C9, $4B
	.db $22, $43, $04, $4C, $4D, $4E, $4F
	.db $21, $03, $04, $41, $43, $45, $47
	.db $21, $19, $04, $41, $43, $45, $47
	.db $21, $39, $C9, $48
	.db $21, $3A, $C9, $49
	.db $21, $3B, $C9, $4A
	.db $21, $3C, $C9, $4B
	.db $22, $59, $04, $4C, $4D, $4E, $4F
	.db $21, $CA, $4C, $54
	.db $21, $EA, $4C, $55
	.db $22, $0B, $0A, $50, $52, $50, $52, $50, $52, $50, $52, $50, $52
	.db $22, $2B, $0A, $51, $53, $51, $53, $51, $53, $51, $53, $51, $53
	.db $22, $80, $60, $58
	.db $22, $A0, $60, $58
	.db $22, $C0, $60, $58
	.db $22, $E0, $60, $58
	.db $22, $4C, $02, $3A, $3B
	.db $22, $6C, $C5, $3C
	.db $22, $6D, $C5, $3D
	.db $22, $52, $02, $3A, $3B
	.db $22, $72, $C5, $3C
	.db $22, $73, $C5, $3D
	.db $00

EndingCelebrationFloorAndSubconParade:
	.db $23, $00, $20
	.db $00, $02, $08, $0A, $0C, $0E, $04, $06, $08, $0A, $04, $06, $0C, $0E, $04, $06
	.db $08, $0A, $00, $02, $0C, $0E, $0C, $0E, $00, $02, $04, $06, $04, $06, $08, $0A

	.db $23, $20, $20
	.db $01, $03, $09, $0B, $0D, $0F, $05, $07, $09, $0B, $05, $07, $0D, $0F, $05, $07
	.db $09, $0B, $01, $03, $0D, $0F, $0D, $0F, $01, $03, $05, $07, $05, $07, $09, $0B

	.db $27, $00, $20
	.db $74, $76, $74, $76, $74, $76, $74, $76, $74, $76, $74, $76, $74, $76, $74, $76
	.db $74, $76, $74, $76, $74, $76, $74, $76, $74, $76, $74, $76, $74, $76, $74, $76

	.db $27, $20, $20
	.db $75, $77, $75, $77, $75, $77, $75, $77, $75, $77, $75, $77, $75, $77, $75, $77
	.db $75, $77, $75, $77, $75, $77, $75, $77, $75, $77, $75, $77, $75, $77, $75, $77

	.db $23, $40, $20
	.db $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81
	.db $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81

	.db $23, $60, $20
	.db $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80
	.db $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80

	.db $23, $80, $20
	.db $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81
	.db $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81

	.db $23, $A0, $20
	.db $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80
	.db $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80

	.db $27, $40, $20
	.db $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81
	.db $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81

	.db $27, $60, $20
	.db $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80
	.db $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80

	.db $27, $80, $20
	.db $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81
	.db $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81

	.db $27, $A0, $20
	.db $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80
	.db $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80, $81, $80

	.db $23, $C0, $48, $AA
	.db $23, $C8, $08, $00, $00, $AA, $AA, $AA, $AA, $00, $00

	.db $23, $D0, $20
	.db $00, $00, $0A, $0A, $0A, $0A, $00, $00
	.db $00, $00, $80, $A0, $A0, $20, $00, $00
	.db $00, $00, $08, $2A, $8A, $02, $00, $00
	.db $FF, $FF, $FF, $EE, $BB, $FF, $FF, $FF

	.db $23, $F0, $48, $A5
	.db $23, $F8, $48, $0A
	.db $27, $F0, $48, $A5
	.db $27, $F8, $48, $0A
	.db $00

EndingCelebrationSubconStandStill:
	.db $23, $00, $20
	.db $70, $72, $70, $72, $70, $72, $70, $72, $70, $72, $70, $72, $70, $72, $70, $72
	.db $70, $72, $70, $72, $70, $72, $70, $72, $70, $72, $70, $72, $70, $72, $70, $72
	.db $23, $20, $20
	.db $71, $73, $71, $73, $71, $73, $71, $73, $71, $73, $71, $73, $71, $73, $71, $73
	.db $71, $73, $71, $73, $71, $73, $71, $73, $71, $73, $71, $73, $71, $73, $71, $73
	.db $00

EndingCelebrationUnusedText_THE_END:
	.db $21, $AC, $07
	.db $ED, $E1, $DE, $FB, $DE, $E7, $DD
	.db $00

EndingCelebrationPaletteFade1:
	.db $3F, $00, $20
	.db $38, $30, $21, $0F
	.db $38, $30, $16, $0F
	.db $38, $28, $18, $0F
	.db $38, $10, $00, $0F
	.db $38, $27, $16, $01
	.db $38, $37, $2A, $01
	.db $38, $27, $30, $01
	.db $38, $36, $25, $07
	.db $00

EndingCelebrationPaletteFade2:
	.db $3F, $00, $20
	.db $0F, $10, $00, $0F
	.db $0F, $10, $00, $0F
	.db $0F, $10, $00, $0F
	.db $0F, $10, $00, $0F
	.db $0F, $10, $00, $0F
	.db $0F, $10, $00, $0F
	.db $0F, $10, $00, $0F
	.db $0F, $10, $00, $0F
	.db $00

EndingCelebrationPaletteFade3:
	.db $3F, $00, $20
	.db $0F, $00, $0F, $0F
	.db $0F, $00, $0F, $0F
	.db $0F, $00, $0F, $0F
	.db $0F, $00, $0F, $0F
	.db $0F, $00, $0F, $0F
	.db $0F, $00, $0F, $0F
	.db $0F, $00, $0F, $0F
	.db $0F, $00, $0F, $0F
	.db $00

EndingScreenUpdateIndex:
	.db EndingUpdateBuffer_PaletteFade1
	.db EndingUpdateBuffer_PaletteFade2 ; 1 ; @TODO This seems wrong, somehow
	.db EndingUpdateBuffer_PaletteFade3 ; 2

ContributorSpriteZeroOAMData:
	.db $8C, $FC, $20, $94

ContributorCharacterOAMData:
	; Mario
	.db $4F, $61, $20, $50
	.db $4F, $63, $20, $58
	.db $5F, $65, $20, $50
	.db $5F, $67, $20, $58
	; Luigi
	.db $4F, $69, $21, $68
	.db $4F, $6B, $21, $70
	.db $5F, $6D, $21, $68
	.db $5F, $6F, $21, $70
	; Toad
	.db $4F, $83, $22, $88
	.db $4F, $83, $62, $90
	.db $5F, $87, $22, $88
	.db $5F, $87, $62, $90
	; Princess
	.db $4F, $8B, $23, $A0
	.db $4F, $8D, $23, $A8
	.db $5F, $8F, $23, $A0
	.db $5F, $91, $23, $A8


;
; Shows the part of the ending where the Subcons carry Wart to an uncertain
; fate while the characters stand and wave
;
ContributorScene:
	INC iMainGameState
	JSR WaitForNMI_Ending_TurnOffPPU

	LDA #VMirror
	JSR ChangeNametableMirroring

	JSR ClearNametablesAndSprites

	LDA #Stack100_Menu
	STA iStack
	JSR EnableNMI_Bank1

	JSR WaitForNMI_Ending

	LDA #EndingUpdateBuffer_CeilingTextAndPodium
	STA zScreenUpdateIndex
	JSR WaitForNMI_Ending

	LDA #EndingUpdateBuffer_FloorAndSubconParade
	STA zScreenUpdateIndex
	JSR WaitForNMI_Ending

	JSR Ending_GetContributor

	JSR WaitForNMI_Ending

	LDA #HMirror
	JSR ChangeNametableMirroring

	LDY #$03
ContributorScene_SpriteZeroLoop:
	LDA ContributorSpriteZeroOAMData, Y
	STA iVirtualOAM, Y
	DEY
	BPL ContributorScene_SpriteZeroLoop

	LDA #$00
	STA zf3
	STA ze6

	LDY #$3F
ContributorScene_CharacterLoop:
	LDA ContributorCharacterOAMData, Y
	STA iVirtualOAM + $10, Y
	DEY
	BPL ContributorScene_CharacterLoop

	LDA #$FF
	STA zPlayerXHi
	LDA #$A0
	STA zPlayerXLo
	LDA #$08
	STA zPlayerXVelocity
	LDA #$01
	STA zScrollCondition

loc_BANK1_AAD4:
	JSR WaitForNMI_Ending_TurnOnPPU

	INC zf3
	INC z10
	JSR ContributorTicker

	JSR loc_BANK1_ABCC

	LDA ze6
	CMP #$03
	BCS loc_BANK1_AB20

loc_BANK1_AAE7:
	BIT PPUSTATUS
	BVS loc_BANK1_AAE7

loc_BANK1_AAEC:
	BIT PPUSTATUS
	BVC loc_BANK1_AAEC

	LDX #$02

loc_BANK1_AAF3:
	LDY #$00

loc_BANK1_AAF5:
	LDA z00
	LDA z00
	DEY
	BNE loc_BANK1_AAF5

	DEX
	BNE loc_BANK1_AAF3

	LDA PPUSTATUS
	LDA zf2
	STA PPUSCROLL
	LDA #$00
	STA PPUSCROLL
	LDA zf3
	CMP #$0A
	BCC loc_BANK1_AB1D

	LDA #$00
	STA zf3
	LDA zf2
	SEC
	SBC #$30
	STA zf2

loc_BANK1_AB1D:
	JMP loc_BANK1_AAD4

; ---------------------------------------------------------------------------

loc_BANK1_AB20:
	LDA #VMirror
	JSR ChangeNametableMirroring

	LDA #$01
	STA zf2
	LSR A
	STA zf3
	STA z07
	LDA #EndingUpdateBuffer_SubconStandStill
	STA zScreenUpdateIndex

loc_BANK1_AB32:
	JSR WaitForNMI_Ending

	JSR EnableNMI_Bank1

	INC zf3
	JSR ContributorTicker

	JSR ContributorCharacterAnimation

loc_BANK1_AB40:
	BIT PPUSTATUS
	BVS loc_BANK1_AB40

loc_BANK1_AB45:
	BIT PPUSTATUS
	BVC loc_BANK1_AB45

	LDX #$02

loc_BANK1_AB4C:
	LDY #$00

loc_BANK1_AB4E:
	LDA z00
	LDA z00
	DEY
	BNE loc_BANK1_AB4E

	DEX
	BNE loc_BANK1_AB4C

	LDA #$B0
	ORA zf2
	STA zPPUControl
	STA PPUCTRL
	LDA PPUSTATUS
	LDA #$00
	STA PPUSCROLL
	LDA #$00
	STA PPUSCROLL
	LDA zf3
	CMP #$14
	BCC loc_BANK1_AB80

	LDA #$00
	STA zf3
	LDA zf2
	EOR #$01
	STA zf2
	INC z07

loc_BANK1_AB80:
	LDA z07
	CMP #$29
	BCC loc_BANK1_AB32

	LDY iMusicLoopPoint
	INY
	CPY iCurrentMusicOffset
	BNE loc_BANK1_AB32

	JSR EndingSceneTransition

	LDA ze6
	CMP #$04
	BCC loc_BANK1_AB32
	RTS


;
; Advances to the next scene and does the palette transition
;
EndingSceneTransition:
	LDA z10
	AND #$03
	BNE EndingSceneTransition_Exit

	INC ze5
	LDY ze5
	CPY #$03
	BCS EndingSceneTransition_Next

	LDA EndingScreenUpdateIndex, Y
	STA zScreenUpdateIndex
	RTS

EndingSceneTransition_Next:
	INC ze6

EndingSceneTransition_Exit:
	RTS


; ---------------------------------------------------------------------------

loc_BANK1_ABA7:
	LDA z10
	AND #$03
	BNE EndingSceneTransition_Exit

	DEC ze5
	LDY ze5
	LDA EndingScreenUpdateIndex, Y
	STA zScreenUpdateIndex
	TYA
	BNE EndingSceneTransition_Exit

	INC ze6
	RTS


EnableNMI_Bank1:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	STA zPPUControl
	STA PPUCTRL
	RTS


DisableNMI_Bank1:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIDisabled
	STA PPUCTRL
	STA zPPUControl
	RTS



loc_BANK1_ABCC:
	JSR ContributorCharacterAnimation

	LDA ze6
	JSR JumpToTableAfterJump

	.dw loc_BANK1_ABA7
	.dw loc_BANK1_AC0A
	.dw loc_BANK1_AC87


byte_BANK1_ABDA:
	.db $C0
	.db $C8
	.db $B8
	.db $B8
	.db $C8
	.db $C0

byte_BANK1_ABE0:
	.db $C0
	.db $08
	.db $E0
	.db $F0
	.db $D0
	.db $E8

EndingWartTiles:
	.db $11
	.db $13
	.db $19
	.db $1B
	.db $21
	.db $23
	.db $15
	.db $17
	.db $1D
	.db $1F
	.db $25
	.db $27

byte_BANK1_ABF2:
	.db $00
	.db $08
	.db $10
	.db $18
	.db $20
	.db $28
	.db $00
	.db $08
	.db $10
	.db $18
	.db $20
	.db $28

byte_BANK1_ABFE:
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $10
	.db $10
	.db $10
	.db $10
	.db $10
	.db $10


; ---------------------------------------------------------------------------

loc_BANK1_AC0A:
	JSR ApplyPlayerPhysicsX

	LDA zPlayerXHi
	CMP #$01
	BNE loc_BANK1_AC37

	LDA zPlayerXLo
	CMP #$20
	BCC loc_BANK1_AC37

	INC ze6

	LDA #$A0
	STA z10
	LDX #$05

loc_BANK1_AC22:
	LDA #$20
	STA zObjectXLo, X
	LDA #$A8

loc_BANK1_AC28:
	STA zObjectYLo, X
	LDA byte_BANK1_ABDA, X
	STA zObjectXVelocity, X
	LDA byte_BANK1_ABE0, X
	STA zObjectYVelocity, X
	DEX
	BPL loc_BANK1_AC22

loc_BANK1_AC37:
	LDY #$A0
	LDA z10
	AND #$38
	BNE loc_BANK1_AC40

	DEY

loc_BANK1_AC40:
	AND #$08
	BNE loc_BANK1_AC45

	DEY

loc_BANK1_AC45:
	STY zPlayerYLo
	LDX #$0B
	LDY #$70

loc_BANK1_AC4B:
	LDA zPlayerYLo
	CLC
	ADC byte_BANK1_ABFE, X
	STA iVirtualOAM, Y
	LDA EndingWartTiles, X
	STA iVirtualOAM + 1, Y
	LDA #$01
	STA iVirtualOAM + 2, Y
	LDA zPlayerXLo
	CLC
	ADC byte_BANK1_ABF2, X
	STA iVirtualOAM + 3, Y
	LDA zPlayerXHi

loc_BANK1_AC6A:
	ADC #$00
	BEQ loc_BANK1_AC73

	LDA #$F0
	STA iVirtualOAM, Y

loc_BANK1_AC73:
	INY
	INY
	INY
	INY
	DEX
	BPL loc_BANK1_AC4B
	RTS


ZonkTiles:
	.db $39
	.db $35
	.db $37
	.db $35
	.db $37
	.db $39

byte_BANK1_AC81:
	.db $00
	.db $06
	.db $03
	.db $09
	.db $0F
	.db $0C


loc_BANK1_AC87:
	LDA z10
	BNE loc_BANK1_ACA4

loc_BANK1_AC8B:
	STA iObjectXSubpixel + 6
	STA iObjectYSubpixel + 6
	STA zObjectXLo + 6
	STA z10
	LDA #$6F
	STA zObjectYLo + 6
	LDA #$E6
	STA zObjectXVelocity + 6
	LDA #$0DA
	STA zObjectYVelocity + 6

	INC ze6


loc_BANK1_ACA4:
	LDX #$05

loc_BANK1_ACA6:
	STX z12
	JSR ApplyObjectPhysicsX_Bank1

	JSR ApplyObjectPhysicsY_Bank1

	LDY #$F0
	LDA z10
	BEQ loc_BANK1_ACC1

	AND #$0F
	CMP byte_BANK1_AC81, X
	BNE loc_BANK1_ACC3

	LDA #$20
	STA zObjectXLo, X
	LDY #$A8

loc_BANK1_ACC1:
	STY zObjectYLo, X

loc_BANK1_ACC3:
	TXA
	ASL A
	ASL A
	TAY
	LDA zObjectXLo, X
	CMP #$80
	BCS loc_BANK1_ACD1

	LDA #$F0
	BNE loc_BANK1_ACD6

loc_BANK1_ACD1:
	STA iVirtualOAM + $73, Y
	LDA zObjectYLo, X

loc_BANK1_ACD6:
	STA iVirtualOAM + $70, Y
	LDA ZonkTiles, X
	STA iVirtualOAM + $71, Y
	LDA #$00
	STA iVirtualOAM + $72, Y
	DEX
	BPL loc_BANK1_ACA6
	RTS


ContributorAnimationTiles:
ContributorAnimationTiles_Mario:
	.db $61
	.db $61
	.db $63
	.db $93
	.db $65
	.db $65
	.db $67
	.db $67
ContributorAnimationTiles_Luigi:
	.db $69
	.db $69
	.db $95
	.db $6B
	.db $6D
	.db $6D
	.db $97
	.db $6F
ContributorAnimationTiles_Toad:
	.db $83
	.db $85
	.db $83
	.db $85
	.db $87
	.db $89
	.db $87
	.db $89
ContributorAnimationTiles_Princess:
	.db $8B
	.db $8B
	.db $99
	.db $8D
	.db $8F
	.db $8F
	.db $91
	.db $91

ContributorAnimationTilesOffset:
	.db (ContributorAnimationTiles_Mario - ContributorAnimationTiles + 6)
	.db (ContributorAnimationTiles_Luigi - ContributorAnimationTiles + 6)
	.db (ContributorAnimationTiles_Toad - ContributorAnimationTiles + 6)
	.db (ContributorAnimationTiles_Princess - ContributorAnimationTiles + 6)


ContributorCharacterAnimation:
	INC zPlayerWalkFrame
	LDA #$03
	STA z00
	LDA zPlayerWalkFrame
	STA z01
	LDY #$3C

ContributorCharacterAnimation_OuterLoop:
	LDX z00
	LDA ContributorAnimationTilesOffset, X
	TAX
	INC z01
	LDA z01
	AND #$10
	BEQ ContributorCharacterAnimation_Render

	INX

ContributorCharacterAnimation_Render:
	LDA #$03
	STA z02
ContributorCharacterAnimation_InnerLoop:
	LDA ContributorAnimationTiles, X
	STA iVirtualOAM + $11, Y
	DEX
	DEX
	DEY
	DEY
	DEY
	DEY
	DEC z02
	BPL ContributorCharacterAnimation_InnerLoop

	DEC z00
	BPL ContributorCharacterAnimation_OuterLoop
	RTS


;
; Calculates the list of top contributors
;
Ending_GetContributor:
	LDA #$00
	STA iLevelRecord

	LDY #$03
Ending_GetContributor_Loop:
	LDA iCharacterLevelCount, Y
	CMP iLevelRecord
	BCC Ending_GetContributor_Next

	LDA iCharacterLevelCount, Y
	STA iLevelRecord

Ending_GetContributor_Next:
	DEY
	BPL Ending_GetContributor_Loop

	LDX #$00
	LDY #$03
Ending_GetContributor_Loop2:
	LDA iCharacterLevelCount, Y
	CMP iLevelRecord
	BNE Ending_GetContributor_Next2

	TYA
	STA iContributors, X
	INX

Ending_GetContributor_Next2:
	DEY
	BPL Ending_GetContributor_Loop2

	DEX
	STX iNumContributions
	LDX #$00
	LDA #$21
	STA iPPUBuffer, X
	INX
	LDA #$2A
	STA iPPUBuffer, X
	INX
	LDA #$0C
	STA iPPUBuffer, X
	INX
	LDY #$00
	LDA iCharacterLevelCount, Y
	JSR sub_BANK1_AE43

	TYA
	STA iPPUBuffer, X
	INX
	LDA z01
	STA iPPUBuffer, X
	INX
	LDA #$0FB
	STA iPPUBuffer, X
	INX
	LDY #$03
	LDA iCharacterLevelCount, Y
	JSR sub_BANK1_AE43

	TYA
	STA iPPUBuffer, X
	INX
	LDA z01
	STA iPPUBuffer, X
	INX

	LDA #$0FB
	STA iPPUBuffer, X
	INX
	STA iPPUBuffer, X
	INX
	LDY #$02
	LDA iCharacterLevelCount, Y
	JSR sub_BANK1_AE43

	TYA
	STA iPPUBuffer, X
	INX
	LDA z01
	STA iPPUBuffer, X
	INX
	LDA #$0FB
	STA iPPUBuffer, X
	INX
	LDY #$01
	LDA iCharacterLevelCount, Y
	JSR sub_BANK1_AE43

	TYA
	STA iPPUBuffer, X
	INX
	LDA z01
	STA iPPUBuffer, X
	INX
	LDA #$00
	STA iPPUBuffer, X
	LDA #$3C
	STA iContributorTimer
	RTS


; =============== S U B R O U T I N E =======================================

ContributorTicker:
	DEC iContributorTimer
	BPL ContributorTicker_Exit

	LDA #$3C
	STA iContributorTimer
	LDY iContributorID
	LDA iContributors, Y
	CLC
	ADC #$09

	STA zScreenUpdateIndex

	DEC iContributorID
	BPL ContributorTicker_Exit

	LDA iNumContributions
	STA iContributorID

ContributorTicker_Exit:
	RTS


EndingCelebrationText_MARIO:
	.db $20, $ED, $08, $E6, $DA, $EB, $E2, $E8, $FE, $FE, $FE
	.db $00

EndingCelebrationText_PRINCESS:
	.db $20, $ED, $08, $E9, $EB, $E2, $E7, $DC, $DE, $EC, $EC
	.db $00

EndingCelebrationText_TOAD:
	.db $20, $ED, $08, $ED, $E8, $DA, $DD, $FE, $FE, $FE, $FE
	.db $00

EndingCelebrationText_LUIGI:
	.db $20, $ED, $08, $E5, $EE, $E2, $E0, $E2, $FE, $FE, $FE
	.db $00


; =============== S U B R O U T I N E =======================================

sub_BANK1_AE43:
	LDY #$D0

loc_BANK1_AE45:
	CMP #$0A
	BCC loc_BANK1_AE4F

	SBC #$0A

loc_BANK1_AE4B:
	INY
	JMP loc_BANK1_AE45

; ---------------------------------------------------------------------------

loc_BANK1_AE4F:
	ORA #$D0
	CPY #$D0
	BNE loc_BANK1_AE57

	LDY #$0FB

loc_BANK1_AE57:
	STA z01
	RTS

; End of function sub_BANK1_AE43

; ---------------------------------------------------------------------------

MysteryCharacterData3900:
	.db $FB ; @TODO ??? Not sure what this is
	.db $FF
	.db $00
	.db $08
	.db $0C
	.db $18
	.db $1A


;
; NOTE: A copy of this subroutine also exists in Bank 2
;
; Applies object physics for the y-axis
;
; Input
;   X = enemy index
;
ApplyObjectPhysicsY_Bank1:
	TXA
	CLC
	ADC #$0A
	TAX

;
; NOTE: A copy of this subroutine also exists in Bank 2
;
; Applies object physics for the x-axis
;
; Input
;   X = enemy index, physics direction
;       ($00-$09 for horizontal, $0A-$13 for vertical)
;
; Output
;   X = RAM_12
;
ApplyObjectPhysicsX_Bank1:
	; Add acceleration to velocity
	LDA zObjectXVelocity, X
	CLC
	ADC iObjectXVelocity, X

	PHA
	; Lower nybble of velocity is for subpixel position
	ASL A
	ASL A
	ASL A
	ASL A
	STA z01

	; Upper nybble of velocity is for lo position
	PLA
	LSR A
	LSR A
	LSR A
	LSR A

	CMP #$08
	BCC ApplyObjectPhysics_StoreVelocityLo_Bank1

	; Left/up: Carry negative bits through upper nybble
	ORA #$F0

ApplyObjectPhysics_StoreVelocityLo_Bank1:
	STA z00

	LDY #$00
	ASL A
	BCC ApplyObjectPhysics_StoreDirection_Bank1

	; Left/up
	DEY

ApplyObjectPhysics_StoreDirection_Bank1:
	STY z02

	; Add lower nybble of velocity for subpixel position
	LDA iObjectXSubpixel, X
	CLC
	ADC z01
	STA iObjectXSubpixel, X

	; Add upper nybble of velocity for lo position
	LDA zObjectXLo, X
	ADC z00
	STA zObjectXLo, X

ApplyObjectPhysics_PositionHi_Bank1:
	LSR z01
	LDA zObjectXHi, X
	ADC z02
	STA zObjectXHi, X

ApplyObjectPhysics_Exit_Bank1:
	LDX z12
	RTS



;
; Applies object physics
;
; Input
;   X = enemy index
;
ApplyObjectMovement_Bank1:
	LDA iObjectShakeTimer, X
	BNE ApplyObjectMovement_Vertical_Bank1

	JSR ApplyObjectPhysicsX_Bank1

ApplyObjectMovement_Vertical_Bank1:
	JSR ApplyObjectPhysicsY_Bank1

	LDA zObjectYVelocity, X
	BMI ApplyObjectMovement_Gravity_Bank1

	; Check terminal velocity
	CMP #$3E
	BCS ApplyObjectMovement_Exit_Bank1

ApplyObjectMovement_Gravity_Bank1:
	INC zObjectYVelocity, X
	INC zObjectYVelocity, X

ApplyObjectMovement_Exit_Bank1:
	RTS


DoorAnimation_Locked:
	LDA #$01
	BNE DoorAnimation

DoorAnimation_Unlocked:
	LDA #$00

DoorAnimation:
	PHA
	LDY #$08

DoorAnimation_Loop:
	; skip if inactive
	LDA zEnemyState, Y
	BEQ DoorAnimation_LoopNext

	; skip enemies that aren't the door
	LDA zObjectType, Y
	CMP #Enemy_SubspaceDoor
	BNE DoorAnimation_LoopNext

	LDA #EnemyState_PuffOfSmoke
	STA zEnemyState, Y
	LDA #$20
	STA zSpriteTimer, Y

DoorAnimation_LoopNext:
	DEY
	BPL DoorAnimation_Loop

	JSR CreateEnemy_TryAllSlots_Bank1

	BMI DoorAnimation_Exit

	LDA #$00
	STA iDoorAnimTimer
	STA iSubDoorTimer
	LDX z00
	PLA
	STA i477, X
	LDA #Enemy_SubspaceDoor
	STA zObjectType, X
	LDA zPlayerXLo
	ADC #$08
	AND #$F0
	STA zObjectXLo, X
	LDA zPlayerXHi
	ADC #$00
	STA zObjectXHi, X
	LDA zPlayerYLo
	STA zObjectYLo, X
	LDA zPlayerYHi
	STA zObjectYHi, X
	LDA #ObjAttrib_Palette1 | ObjAttrib_16x32
	STA zObjectAttributes, X
	LDX z12
	RTS

DoorAnimation_Exit:
	PLA
	RTS


CreateStarman:
	JSR CreateEnemy_Bank1

	BMI CreateStarman_Exit

	LDX z00
	LDA #Enemy_Starman
	STA zObjectType, X
	LDA iBoundLeftLower
	ADC #$D0
	STA zObjectXLo, X
	LDA iBoundLeftUpper
	ADC #$00
	STA zObjectXHi, X
	LDA zScreenY
	ADC #$E0
	STA zObjectYLo, X
	LDA zScreenYPage
	ADC #$00
	STA zObjectYHi, X
	JSR loc_BANK1_BA17

	LDX z12

CreateStarman_Exit:
	RTS


; =============== S U B R O U T I N E =======================================

EnemyInit_Basic_Bank1:
	LDA #$00
	STA zSpriteTimer, X
	LDA #$00
	STA zObjectVariables, X

loc_BANK1_B9EB:
	LDA #$00
	STA zEnemyArray, X
	STA iObjectBulletTimer, X
	STA zHeldObjectTimer, X
	STA zObjectAnimTimer, X
	STA iObjectShakeTimer, X
	STA zEnemyCollision, X
	STA iObjectStunTimer, X
	STA iSpriteTimer, X
	STA iObjectXVelocity, X
	STA iObjectYVelocity, X
	STA iObjectFlashTimer, X
	STA i477, X
	STA i480, X
	STA iEnemyHP, X
	STA zObjectYVelocity, X
	STA zObjectXVelocity, X

; look up object attributes
loc_BANK1_BA17:
	LDY zObjectType, X
	LDA ObjectAttributeTable, Y
	AND #ObjAttrib_Palette | ObjAttrib_Horizontal | ObjAttrib_FrontFacing | ObjAttrib_Mirrored | ObjAttrib_BehindBackground | ObjAttrib_16x32
	STA zObjectAttributes, X
	LDA EnemyArray_46E_Data, Y
	STA i46e, X
	LDA ObjectHitbox_Data, Y
	STA iObjectHitbox, X
	LDA EnemyArray_492_Data, Y
	STA i492, X
	RTS

; End of function EnemyInit_Basic_Bank1


;
; Turns the key into a puff of smoke
;
; Input
;   X = enemy slot
; Output
;   X = value of z12
;
TurnKeyIntoPuffOfSmoke:
	LDA zObjectAttributes, X
	AND #%11111100
	ORA #ObjAttrib_Palette1
	STA zObjectAttributes, X
	LDA #EnemyState_PuffOfSmoke
	STA zEnemyState, X
	STA zObjectAnimTimer, X
	LDA #$1F
	STA zSpriteTimer, X
	LDX z12
	RTS


;
; NOTE: This is a copy of the "UnlinkEnemyFromRawData" routine in Bank 2, but
; it is used here for spawning the door animation and Starman objects.
;
; Spawned enemies are linked to an offset in the raw enemy data, which prevents
; from being respawned until they are killed or moved offscreen.
;
; This subroutine ensures that the enemy in a particular slot is not linked to
; the raw enemy data
;
; Input
;   X = enemy slot
;
UnlinkEnemyFromRawData_Bank1:
	LDA #$FF
	STA iEnemyRawDataOffset, X
	RTS


;
; Updates the area page and tile placement offset
;
; Input
;   ze8 = area page
;   ze5 = tile placement offset shift
;   ze6 = previous tile placement offset
; Output
;   RAM_1 = low byte of decoded level data RAM
;   RAM_2 = low byte of decoded level data RAM
;   ze7 = target tile placement offset
;
SetTileOffsetAndAreaPageAddr_Bank1:
	LDX ze8
	JSR SetAreaPageAddr_Bank1

	LDA ze6
	CLC
	ADC ze5
	STA ze7
	RTS


DecodedLevelPageStartLo_Bank1:
	.db <wLevelDataBuffer
	.db <(wLevelDataBuffer+$00F0)
	.db <(wLevelDataBuffer+$01E0)
	.db <(wLevelDataBuffer+$02D0)
	.db <(wLevelDataBuffer+$03C0)
	.db <(wLevelDataBuffer+$04B0)
	.db <(wLevelDataBuffer+$05A0)
	.db <(wLevelDataBuffer+$0690)
	.db <(wLevelDataBuffer+$0780)
	.db <(wLevelDataBuffer+$0870)
	.db <(iSubspaceLayout)

DecodedLevelPageStartHi_Bank1:
	.db >wLevelDataBuffer
	.db >(wLevelDataBuffer+$00F0)
	.db >(wLevelDataBuffer+$01E0)
	.db >(wLevelDataBuffer+$02D0)
	.db >(wLevelDataBuffer+$03C0)
	.db >(wLevelDataBuffer+$04B0)
	.db >(wLevelDataBuffer+$05A0)
	.db >(wLevelDataBuffer+$0690)
	.db >(wLevelDataBuffer+$0780)
	.db >(wLevelDataBuffer+$0870)
	.db >(iSubspaceLayout)


;
; Updates the area page that we're reading tiles from
;
; Input
;   X = area page
; Output
;   z01 = low byte of decoded level data RAM
;   z02 = low byte of decoded level data RAM
;
SetAreaPageAddr_Bank1:
	LDA DecodedLevelPageStartLo_Bank1, X
	STA z01
	LDA DecodedLevelPageStartHi_Bank1, X
	STA z02
	RTS


;
; Checks whether the player is on a quicksand tile
;
; Input
;   z00 = tile ID
; Output
;   A = Whether the player is sinking in quicksand
;   X = zPlayerGrounding flag
;
PlayerTileCollision_CheckQuicksand:
	LDA #$01
	LDY z00
	CPY #BackgroundTile_QuicksandSlow
	BEQ PlayerTileCollision_QuicksandSlow

	CPY #BackgroundTile_QuicksandFast
	BEQ PlayerTileCollision_QuicksandFast

PlayerTileCollision_NotQuicksand:
	LDA #$00
	RTS

PlayerTileCollision_QuicksandFast:
	LDA #$08

PlayerTileCollision_QuicksandSlow:
	STA zPlayerYVelocity
	LDA iQuicksandDepth
	BNE loc_BANK1_BA9B

	LDA zPlayerYLo
	AND #$10
	STA i4eb

loc_BANK1_BA9B:
	; check if player is too far under
	LDA zPlayerYLo
	AND #$0F
	TAY
	LDA i4eb
	EOR zPlayerYLo
	AND #$10
	BEQ loc_BANK1_BAB6

	; kill if >= this check
	CPY #$0C
	BCC loc_BANK1_BAB4

	LDA #$00
	STA zPlayerStateTimer
	JSR KillPlayer

loc_BANK1_BAB4:
	LDY #$04

loc_BANK1_BAB6:
	CPY #$04
	BCS loc_BANK1_BABC

	LDY #$01

loc_BANK1_BABC:
	TYA
	DEX
	RTS


PlayerTileCollision_HurtPlayer:
	LDA zDamageCooldown
	BNE locret_BANK1_BAEC

	LDA iPlayerHP
	SEC
	SBC #$10
	BCC loc_BANK1_BAED

	STA iPlayerHP
	LDA #$7F
	STA zDamageCooldown
	LDA iPlayerScreenX
	SEC
	SBC iSpriteTempScreenX
	ASL A
	ASL A
	STA zPlayerXVelocity
	LDA #$C0
	LDY zPlayerYVelocity
	BPL loc_BANK1_BAE5

	LDA #$00

loc_BANK1_BAE5:
	STA zPlayerYVelocity
	LDA #SoundEffect2_Injury
	STA iPulse1SFX

locret_BANK1_BAEC:
	RTS

; ---------------------------------------------------------------------------

loc_BANK1_BAED:
	LDA #$C0
	STA zPlayerYVelocity
	LDA #$20
	STA zPlayerStateTimer
	LDY z12
	BMI loc_BANK1_BAFD

	LSR A
	STA iObjectStunTimer, Y

loc_BANK1_BAFD:
	JMP KillPlayer


; ---------------------------------------------------------------------------

_code_3B00:
	LDY iEnemyRawDataOffset, X
	BMI loc_BANK1_BB0B

	LDA (zRawSpriteData), Y
	AND #$7F
	STA (zRawSpriteData), Y

loc_BANK1_BB0B:
	LDA #$00
	STA zEnemyState, X
	RTS


;
; NOTE: This is a copy of the "CreateEnemy" routine in Bank 2, but it is used
; here for spawning the door animation and Starman objects.
;
; Creates a generic red Shyguy enemy and
; does some basic initialization for it.
;
; CreateEnemy_TryAllSlots checks all 9 object slots
; CreateEnemy only checks the first 6 object slots
;
; Output
;   N = enabled if no empty slot was found
;   Y = $FF if there no empty slot was found
;   z00 = slot used
;
CreateEnemy_TryAllSlots_Bank1:
	LDY #$08
	BNE CreateEnemy_Bank1_FindSlot

CreateEnemy_Bank1:
	LDY #$05

CreateEnemy_Bank1_FindSlot:
	LDA zEnemyState, Y
	BEQ CreateEnemy_Bank1_FoundSlot

	DEY
	BPL CreateEnemy_Bank1_FindSlot
	RTS

CreateEnemy_Bank1_FoundSlot:
	LDA #EnemyState_Alive
	STA zEnemyState, Y
	LSR A
	STA iLocalBossArray, Y
	LDA #Enemy_ShyguyRed
	STA zObjectType, Y
	LDA zObjectXLo, X
	ADC #$05
	STA zObjectXLo, Y
	LDA zObjectXHi, X
	ADC #$00
	STA zObjectXHi, Y
	LDA zObjectYLo, X
	STA zObjectYLo, Y
	LDA zObjectYHi, X
	STA zObjectYHi, Y
	STY z00
	TYA
	TAX

	JSR EnemyInit_Basic_Bank1
	JSR UnlinkEnemyFromRawData_Bank1

	LDX z12
	RTS

HidePauseScreen_01:
	JSR RestoreScreenScrollPosition

	LDA zScrollCondition
	BNE HidePauseScreen_Horizontal

HidePauseScreen_Vertical:
	LDA #HMirror
	JSR ChangeNametableMirroring

	JSR sub_BANK0_81FE

HidePauseScreen_Vertical_Loop:
	JSR WaitForNMI

	JSR sub_BANK0_823D

	LDA i537
	BEQ HidePauseScreen_Vertical_Loop

	JSR WaitForNMI_TurnOnPPU

	JMP VerticalLevel_CheckScroll

HidePauseScreen_Horizontal:
	LDA #VMirror
	JSR ChangeNametableMirroring

	JSR sub_BANK0_8785

HidePauseScreen_Horizontal_Loop:
	JSR WaitForNMI

	JSR sub_BANK0_87AA

	LDA i537
	BEQ HidePauseScreen_Horizontal_Loop

	JSR WaitForNMI_TurnOnPPU

	JMP HorizontalLevel_CheckScroll

ExitSubArea:
	JSR UseMainAreaScreenBoundaries

ExitSubArea_Loop:
	JSR WaitForNMI

	JSR sub_BANK0_87AA

	LDA i537
	BEQ ExitSubArea_Loop

	JSR WaitForNMI_TurnOnPPU

	JMP HorizontalLevel_CheckScroll

;
; Checks that we're playing the correct music and switches if necessary, unless
; we're playing the invincibility music.
;
; ##### Input
; - `iLevelMusic`: music we should be playing
; - `iMusicID`: music we're actually playing
; - `iStarTimer`: whether the player is invincible
;
; ##### Output
; - `iMusicID`: music we should be plathing
; - `iMusic`: song to play if we need to change the music
;
EnsureCorrectMusic:
	LDA iLevelMusic
	CMP iMusicID
	BEQ EnsureCorrectMusic_Exit

	TAX
	STX iMusicID
	LDA iStarTimer
	CMP #$08
	BCS EnsureCorrectMusic_Exit

	LDA LevelMusicIndexes, X
	STA iMusic

EnsureCorrectMusic_Exit:
	RTS

PlaceTitleSprites:
	LDX #$FF
PlaceTitleSprites_Loop:
	INX
	LDA TitleOAM, X
	BEQ PlaceTitleSprites_Exit
	STA iVirtualOAM, X
	INX
	LDA TitleOAM, X
	STA iVirtualOAM, X
	INX
	LDA TitleOAM, X
	STA iVirtualOAM, X
	INX
	LDA TitleOAM, X
	STA iVirtualOAM, X
	BNE PlaceTitleSprites_Loop

PlaceTitleSprites_Exit:
	RTS

PlaceCorkRoomJar:
	LDX #$FF
PlaceCorkRoomJar_Loop:
	INX
	LDA CorkRoomJarOAMData, X
	BEQ PlaceCorkRoomJar_Exit
	STA iVirtualOAM, X
	INX
	LDA CorkRoomJarOAMData, X
	STA iVirtualOAM, X
	INX
	LDA CorkRoomJarOAMData, X
	STA iVirtualOAM, X
	INX
	LDA CorkRoomJarOAMData, X
	STA iVirtualOAM, X
	BNE PlaceCorkRoomJar_Loop

PlaceCorkRoomJar_Exit:
	RTS
