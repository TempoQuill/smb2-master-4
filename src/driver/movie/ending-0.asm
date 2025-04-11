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


.include "src/data/ending/cork-room.asm"

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

	LDY #MUSIC_ENDING
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
	LDA #SFX_JUMP
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

	LDA #SFX_UPROOT
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

	LDA #SFX_TOSS
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


.include "src/data/ending/celebration.asm"


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
	; vblank
	JSR WaitForNMI_Ending_TurnOnPPU

	; contributor animations
	INC zf3
	INC z10
	JSR ContributorTicker

	JSR loc_BANK1_ABCC

	LDA ze6
	CMP #$03
	BCS loc_BANK1_AB20

; subcon animations
loc_BANK1_AAE7:
	; %01000000 = sprite zero
	; proceed if off
	BIT PPUSTATUS
	BVS loc_BANK1_AAE7

loc_BANK1_AAEC:
	; now proceed if on
	BIT PPUSTATUS
	BVC loc_BANK1_AAEC

	LDX #$02

loc_BANK1_AAF3:
	LDY #$00

; this looks like a manual delay, we keep reading, but we don't do anything for
; 512 loops
loc_BANK1_AAF5:
	LDA z00
	LDA z00
	DEY
	BNE loc_BANK1_AAF5

	DEX
	BNE loc_BANK1_AAF3

	LDA PPUSTATUS
	LDA zf2 ; x
	STA PPUSCROLL
	LDA #$00 ; y
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


.include "src/data/ending/contributor.asm"


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
