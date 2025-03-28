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
	STY iMusicQueue
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

	LDA #SoundEffect2_Watch
	STA iPulse2SFX
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
