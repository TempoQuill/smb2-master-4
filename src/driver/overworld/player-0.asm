GrowShrinkSFXIndexes:
	.db SoundEffect2_Shrinking
	.db Hill_Grow


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
	STA iPulse2SFX

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
	DEC sExtraMen
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
IFNDEF FREE_FOR_ALL
	CMP #$06
	BEQ loc_BANK0_8AB0
ENDIF

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
	JSR JudgeCollidedTile

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
	JMP JudgeMaxMinVelocity

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
loc_BANK0_8D16:
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
JudgeMaxMinVelocity:
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
	JSR JudgeCollidedTile

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
	LDA #SoundEffect2_Watch
	STA iPulse2SFX
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
	JSR JudgeCollidedTile

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
DetermineLiftSlot:
IFNDEF FREE_FOR_ALL
	LDX #$06
ELSE
	LDX #$00
ENDIF

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

IFNDEF STATS_TESTING_PURPOSES ; infinite 1UP mushrooms
	LDA iLifeUpEventFlag
ENDIF
	BEQ loc_BANK0_90EA

IFNDEF STATS_TESTING_PURPOSES ; infinite 1UP mushrooms
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
	JMP DetermineLiftSlot

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

IFNDEF STATS_TESTING_PURPOSES ; infinite coined visits
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
	JMP DetermineLiftSlot

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
	BNE ParseDoorType

	; setting iGameMode to $03 to go to Bonus Chance
	DEY
	STY iGameMode
	RTS

; ---------------------------------------------------------------------------

ParseDoorType:
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
	STA iNoiseDrumSFX

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
JudgeCollidedTile:
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
