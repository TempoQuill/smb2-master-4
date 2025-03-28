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
IFNDEF STATS_TESTING_PURPOSES ; longer subspace time
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
