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
	JSR PrepareForPPUDraw

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
	JSR PrepareForPPUDraw

	LDA zPPUDrawerRemains
	STA zBigPPUDrawer + 1
	LDA ze1
	STA ze2
	LDX #$01
	JSR IncrementAttrRow

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
PrepareForPPUDraw:
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
	JSR IncrementAttrRow

	JMP loc_BANK0_83DE

; up
loc_BANK0_83D4:
	LDX #$00
	JSR CopyBackgroundAttributesToPPUBuffer_Vertical

	LDX #$00
	JSR DecrementAttrRow

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
	JSR DecrementAttrRow

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
	JSR IncrementAttrRow

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
IncrementAttrRow:
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
DecrementAttrRow:
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
	STA sSavedLvlEntryPage
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
	JSR JudgeHorizontalPPUAttr

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
JudgeHorizontalPPUAttr:
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
