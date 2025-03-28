
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
	STA iPulse2SFX

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
IFDEF FREE_FOR_ALL
CreateEnemy_Bank1:
ENDIF
	LDY #$08
IFNDEF FREE_FOR_ALL
	BNE CreateEnemy_Bank1_FindSlot

CreateEnemy_Bank1:
	LDY #$05
ENDIF

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
	LDA #0
	STA iStack + 1
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
; - `iMusicQueue`: song to play if we need to change the music
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
	STA iMusicQueue

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
