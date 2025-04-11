
LevelMusicIndexes:
	.db MUSIC_OVERWORLD
	.db MUSIC_INSIDE ; 1 ; Music indexes.
	.db MUSIC_BOSS ; 2
	.db MUSIC_WART ; 3
	.db MUSIC_SUBSPACE ; 4


; =============== S U B R O U T I N E =======================================

sub_BANKF_F0F9:
	JSR NextSpriteFlickerSlot

	LDA iIsInRocket
	BNE loc_BANKF_F11B

	; boss clear fanfare locks player movement
	LDA iCurrentMusic
	CMP #MUSIC_BOSS_CLEAR
	BEQ loc_BANKF_F115

	LDA iPlayerLock
	BNE loc_BANKF_F115

	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR HandlePlayerState

loc_BANKF_F115:
	JSR SetPlayerScreenPosition

	JSR RenderPlayer

loc_BANKF_F11B:
	JMP RunFrame_Common

; End of function sub_BANKF_F0F9

;
; Does a lot of important stuff in horizontal levels
;
RunFrame_Horizontal:
	JSR NextSpriteFlickerSlot

	; If the player is in a rocket, cut to the chase
	LDA iIsInRocket
	BNE RunFrame_Common

	; Switch to banks 0/1 for the scrolling logic
	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	; If the boss clear fanfare is playing or `iPlayerLock` is set, skip the
	; player state update subroutine
	LDA iCurrentMusic
	CMP #MUSIC_BOSS_CLEAR
	BEQ RunFrame_Horizontal_AfterPlayerState

	LDA iPlayerLock
	BNE RunFrame_Horizontal_AfterPlayerState

	JSR HandlePlayerState

RunFrame_Horizontal_AfterPlayerState:
	JSR GetMoveCameraX

	JSR ApplyHorizontalScroll

	JSR SetPlayerScreenPosition

	JSR RenderPlayer

; back to the shared stuff
RunFrame_Common:
	LDA #PRGBank_2_3
	JSR ChangeMappedPRGBank

	JSR AreaMainRoutine

	JSR AreaSecondaryRoutine

	JSR AnimateCHRRoutine

	JSR SetAreaStartPage

	; Decrement player state timers
	LDX #$03
DecrementPlayerStateTimers_Loop:
	LDA zPlayerStateTimer, X
	BEQ DecrementPlayerStateTimers_Zero

	DEC zPlayerStateTimer, X

DecrementPlayerStateTimers_Zero:
	DEX
	BPL DecrementPlayerStateTimers_Loop

	; If invincible, decrement timer every 8 frames
	LDY iStarTimer
	BEQ RunFrame_Exit

	LDA z10
	AND #$07
	BNE RunFrame_Exit

	; When the invincibility timer hits 8, restore the regular level music
	DEC iStarTimer
	CPY #$08
	BNE RunFrame_Exit

	LDY iMusicID
	LDA LevelMusicIndexes, Y
	STA iMusicQueue

RunFrame_Exit:
	RTS


;
; Does a lot of important stuff in vertical levels
;
RunFrame_Vertical:
	JSR NextSpriteFlickerSlot

	JSR DetermineVerticalScroll

	; If the player is in a rocket, cut to the chase
	LDA iIsInRocket
	BNE RunFrame_Vertical_Common

	; If the boss clear fanfare is playing or `iPlayerLock` is set, skip the
	; player state update subroutine
	LDA iCurrentMusic
	CMP #MUSIC_BOSS_CLEAR
	BEQ RunFrame_Vertical_AfterPlayerState

	LDA iPlayerLock
	BNE RunFrame_Vertical_AfterPlayerState

	; Switch to banks 0/1 for the scrolling logic
	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR HandlePlayerState

RunFrame_Vertical_AfterPlayerState:
	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR ApplyVerticalScroll

	JSR SetPlayerScreenPosition

	JSR RenderPlayer

RunFrame_Vertical_Common:
	JMP RunFrame_Common


;
; Stores the current level/area and player state in the `Init` variables so that they can be
; to restart the area from the previous transition after the player dies.
;
RememberAreaInitialState:
	LDA iAreaTransitionID
	CMP #$02 ; Skip if the player is going into a pointer jar
	BEQ RememberAreaInitialState_Exit

	LDY #$03
RememberAreaInitialState_Loop:
	LDA iCurrentLvl, Y
	STA iCurrentLevel_Init, Y
	DEY
	BPL RememberAreaInitialState_Loop

	LDA zPlayerXLo
	STA iPlayer_X_Lo_Init
	LDA zPlayerYLo
	STA iPlayer_Y_Lo_Init
	LDA iPlayerScreenX
	STA iPlayerScreenX_Init
	LDA iPlayerScreenY
	STA iPlayerScreenY_Init
	LDA zPlayerYVelocity
	STA iPlayer_Y_Velocity_Init
	LDA zPlayerState
	STA iPlayer_State_Init

RememberAreaInitialState_Exit:
	RTS


;
; Level Initialization
; ====================
;
; Sets up in-level gameplay (eg. after level card)
;
LevelInitialization:
	LDY #$03
	LDA iCurrentLevel_Init
	STA sSavedLvl

; Loop through and set level, area, page, and transition from RAM
LevelInitialization_AreaSetupLoop:
	LDA iCurrentLevel_Init, Y
	STA iCurrentLvl, Y
	DEY
	BPL LevelInitialization_AreaSetupLoop

	; position the player
	LDA iPlayer_X_Lo_Init
	STA zPlayerXLo
	LDA iPlayer_Y_Lo_Init
	STA zPlayerYLo
	LDA iPlayerScreenX_Init
	STA iPlayerScreenX
	LDA iPlayerScreenY_Init
	STA iPlayerScreenY
	LDA iPlayer_Y_Velocity_Init
	STA zPlayerYVelocity
	LDA iPlayer_State_Init
	STA zPlayerState
	LDA #$00
	STA iSubAreaFlags
	STA iInJarType
	STA zPlayerGrounding
	STA zDamageCooldown


RestorePlayerToFullHealth:
	LDY iPlayerMaxHP ; Get player's current max HP
	LDA PlayerHealthValueByHeartCount, Y ; Get the health value for this amount of hearts
	STA iPlayerHP
	RTS


PlayerHealthValueByHeartCount:
	.db PlayerHealth_2_HP
	.db PlayerHealth_3_HP
	.db PlayerHealth_4_HP
; Max hearts = (hearts - 2), value is 0,$01,2
; This table determines what the player's HP is set to
ClimbSpeed:
	.db $00
ClimbSpeedDown:
	.db $20
ClimbSpeedUp:
	.db $F0
; Bug: The climb speed index is determined by checking the up/down flags in
; zInputCurrentState. If both are enabled, the index it out of bounds and uses
; the LDA ($A5) below, which zips the player up the vine!
IFDEF FIX_CLIMB_ZIP
	.db $00
ENDIF

;
; Calculates the player's position onscreen.
;
; The screen position is also used for the jump-out-of-a-jar screen transition
; and bottomless pit checks, which works because of the assumption that the
; camera can always keep up with the player in normal gameplay.
;
SetPlayerScreenPosition:
	LDA zPlayerXLo
	SEC
	SBC iBoundLeftLower
	STA iPlayerScreenX
	LDA zPlayerYLo
	CLC
	SBC zScreenY
	STA iPlayerScreenY
	LDA zPlayerYHi
	SBC zScreenYPage
	STA iPlayerScreenYPage

	; Exit if the player state is not standing/jumping or climbing
	LDA zPlayerState
	CMP #PlayerState_Lifting
	BCS SetPlayerScreenPosition_Exit

	LDA iPlayerScreenYPage
	BEQ SetPlayerScreenPosition_CheckClimbing

	BMI SetPlayerScreenPosition_Above

; If the player falls below the screen, they are in a bottomless pit.
SetPlayerScreenPosition_Below:
	LDA #$00
	STA zPlayerStateTimer
	JMP KillPlayer

; If the player is above the screen, they might be jumping out of a jar.
SetPlayerScreenPosition_Above:
	; Verify that the y-position is above the first page of the area
	LDA zPlayerYHi
	BPL SetPlayerScreenPosition_Exit

	; We're above the top of the area, so check if we're in a jar
	LDA iInJarType
	BEQ SetPlayerScreenPosition_CheckClimbing

	; Check if the player is far enough above the top of the area
	LDA zPlayerYLo
	CMP #$F0
	BCS SetPlayerScreenPosition_Exit

	; Exit the jar!
	JSR DoAreaReset

	; Break out of the previous subroutine
	PLA
	PLA

	; Put the player in a crouching stance
	LDY #$00
	STY zPlayerHitBoxHeight
	STY zPlayerYVelocity
	STY zPlayerXVelocity
	LDA #SFX_JAR_UP
	STA iDPCMSFX
	LDA #PlayerState_ExitingJar
	STA zPlayerState
	LDA #SpriteAnimation_Ducking
	STA zPlayerAnimFrame
	LDA iInJarType
	STY iInJarType
	CMP #$02
	BNE SetPlayerScreenPosition_ExitSubAreaJar

SetPlayerScreenPosition_ExitPointerJar:
	STA iAreaTransitionID
	RTS

SetPlayerScreenPosition_ExitSubAreaJar:
	STY iSubAreaFlags
	LDA iCurrentAreaBackup
	STA iCurrentLvlArea
	LDA #PRGBank_8_9
	JSR ChangeMappedPRGBank

	JMP CopyEnemyDataToMemory

SetPlayerScreenPosition_Exit:
	RTS

SetPlayerScreenPosition_CheckClimbing:
	LDA zPlayerState
	CMP #PlayerState_Climbing
	BNE SetPlayerScreenPosition_Exit

	; No climbing transitions from subspace
	LDA iSubAreaFlags
	CMP #$02
	BEQ SetPlayerScreenPosition_Exit

	; Climbing upwards
	LDA ClimbSpeedUp
	LDY zPlayerYHi
	BMI SetPlayerScreenPosition_DoClimbingTransition

	; Climbing downwards
	LDA iPlayerScreenY
	CMP #$B8
	BCC SetPlayerScreenPosition_Exit

	; Set y-position to an odd number
	LSR zPlayerYLo
	SEC
	ROL zPlayerYLo
	LDA ClimbSpeedDown

SetPlayerScreenPosition_DoClimbingTransition:
	STA zPlayerYVelocity
	LDA #PlayerState_ClimbingAreaTransition
	STA zPlayerState
	RTS


;
; Calculate the x-velocity of the camera based on the distance between the player
; and the center of the screen.
;
GetMoveCameraX:
	LDA #$00
	LDY iScrollXLock
	BNE GetMoveCameraX_Exit

	LDA zPlayerXLo
	SEC
	SBC #$78
	SEC
	SBC iBoundLeftLower

GetMoveCameraX_Exit:
	STA zXVelocity
	RTS


; Tiles to use for eye sprite. If $00, this will use the character-specific table
CharacterFrameEyeTiles:
	.db $00 ; Walk1
	.db $00 ; Carry1
	.db $00 ; Walk2
	.db $00 ; Carry2
	.db $FB ; Duck
	.db $FB ; DuckCarry
	.db $00 ; Jump
	.db $FB ; Death
	.db $FB ; Lift
	.db $00 ; Throw
	.db $FB ; Climb

; Specific to each character
CharacterEyeTiles:
	.db $D5 ; Mario
	.db $D9 ; Luigi
	.db $FB ; Toad
	.db $D7 ; Princess

CharacterTiles_Walk1:
	.db $00
	.db $02
	.db $04 ; $00 - start of relative character tile offets, for some reason
	.db $06 ; $01

CharacterTiles_Carry1:
	.db $0C ; $02
	.db $0E ; $03
	.db $10 ; $04
	.db $12 ; $05

CharacterTiles_Walk2:
	.db $00 ; $06
	.db $02 ; $07
	.db $08 ; $08
	.db $0A ; $09

CharacterTiles_Carry2:
	.db $0C ; $0a
	.db $0E ; $0b
	.db $14 ; $0c
	.db $16 ; $0d

CharacterTiles_Duck:
	.db $FB ; $0e
	.db $FB ; $0f
	.db $2C ; $10
	.db $2C ; $11

CharacterTiles_DuckCarry:
	.db $FB ; $12
	.db $FB ; $13
	.db $2E ; $14
	.db $2E ; $15

CharacterTiles_Jump:
	.db $0C ; $16
	.db $0E ; $17
	.db $10 ; $18
	.db $12 ; $19

CharacterTiles_Death:
	.db $30 ; $1a
	.db $30 ; $1b
	.db $32 ; $1c
	.db $32 ; $1d

CharacterTiles_Lift:
	.db $20 ; $1e
	.db $22 ; $1f
	.db $24 ; $20
	.db $26 ; $21

CharacterTiles_Throw:
	.db $00 ; $22
	.db $02 ; $23
	.db $28 ; $24
	.db $2A ; $25

CharacterTiles_Climb:
	.db $18 ; $26
	.db $1A ; $27
	.db $1C ; $28
	.db $1E ; $29

CharacterTiles_PrincessJumpBody:
	.db $B4 ; $2a
	.db $B6 ; $2b

DamageInvulnBlinkFrames:
	.db $01, $01, $01, $02, $02, $04, $04, $04


;
; Renders the player sprite
;
RenderPlayer:
	LDY zPlayerState
	CPY #PlayerState_ChangingSize
	BEQ loc_BANKF_F337

	LDY iStarTimer
	BNE loc_BANKF_F337

	LDA zDamageCooldown ; Determine if the player is invincible from damage,
; and if so, if they should be visible
	BEQ loc_BANKF_F345

	LSR A
	LSR A
	LSR A
	LSR A
	TAY
	LDA zDamageCooldown
	AND DamageInvulnBlinkFrames, Y
	BNE loc_BANKF_F345
	RTS

; ---------------------------------------------------------------------------

loc_BANKF_F337:
	LDA z10
	CPY #$18
	BCS loc_BANKF_F33F

	LSR A
	LSR A

loc_BANKF_F33F:
	AND #ObjAttrib_Palette
	ORA zPlayerAttributes
	STA zPlayerAttributes

loc_BANKF_F345:
	LDA iQuicksandDepth
	BEQ loc_BANKF_F350

	LDA #ObjAttrib_BehindBackground
	ORA zPlayerAttributes
	STA zPlayerAttributes

loc_BANKF_F350:
	LDA iPlayerScreenX
	STA iVirtualOAM + $23
	STA iVirtualOAM + $2B
	CLC
	ADC #$08
	STA iVirtualOAM + $27
	STA iVirtualOAM + $2F
	LDA iPlayerScreenY
	STA z00
	LDA iPlayerScreenYPage
	STA z01
	LDY zPlayerAnimFrame
	CPY #$04
	BEQ loc_BANKF_F382

	LDA iCurrentPlayerSize
	BEQ loc_BANKF_F382

	LDA z00
	CLC
	ADC #$08
	STA z00
	BCC loc_BANKF_F382

	INC z01

loc_BANKF_F382:
	LDA zCurrentCharacter
	CMP #Character_Princess
	BEQ loc_BANKF_F394

	CPY #$00
	BNE loc_BANKF_F394

	LDA z00
	BNE loc_BANKF_F392

	DEC z01

loc_BANKF_F392:
	DEC z00

loc_BANKF_F394:
	JSR FindSpriteSlot

	LDA z01
	BNE loc_BANKF_F3A6

	LDA z00
	STA iVirtualOAM, Y
	STA iVirtualOAM + $20
	STA iVirtualOAM + $24

loc_BANKF_F3A6:
	LDA z00
	CLC
	ADC #$10
	STA z00
	LDA z01
	ADC #$00
	BNE loc_BANKF_F3BB

	LDA z00
	STA iVirtualOAM + $28
	STA iVirtualOAM + $2C

loc_BANKF_F3BB:
	LDA iCrouchJumpTimer
	CMP #$3C
	BCC loc_BANKF_F3CA

	LDA z10
	AND #ObjAttrib_Palette1
	ORA zPlayerAttributes
	STA zPlayerAttributes

loc_BANKF_F3CA:
	LDA zPlayerFacing
	LSR A
	ROR A
	ROR A
	ORA zPlayerAttributes
	AND #%11111100
	ORA #ObjAttrib_Palette1
	STA iVirtualOAM + 2, Y
	LDX zPlayerAnimFrame
	CPX #$07
	BEQ loc_BANKF_F3E2

	CPX #$04
	BNE loc_BANKF_F3EE

loc_BANKF_F3E2:
	LDA zPlayerAttributes
	STA iVirtualOAM + $22
	STA iVirtualOAM + $2A
	ORA #$40
	BNE loc_BANKF_F3F8

loc_BANKF_F3EE:
	AND #$FC
	ORA zPlayerAttributes
	STA iVirtualOAM + $22
	STA iVirtualOAM + $2A

loc_BANKF_F3F8:
	STA iVirtualOAM + $26
	STA iVirtualOAM + $2E
	LDA CharacterFrameEyeTiles, X
	BNE loc_BANKF_F408

	LDX zCurrentCharacter
	LDA CharacterEyeTiles, X

loc_BANKF_F408:
	STA iVirtualOAM + 1, Y

	LDA zPlayerAnimFrame
	CMP #$06
	BCS loc_BANKF_F413

	ORA zHeldItem

loc_BANKF_F413:
	ASL A
	ASL A
	TAX
	LDA zPlayerFacing
	BNE loc_BANKF_F44A

	LDA iVirtualOAM + $23
	STA iVirtualOAM + 3, Y
	LDA CharacterTiles_Walk1, X
	STA iVirtualOAM + $21
	LDA CharacterTiles_Walk1 + 1, X
	STA iVirtualOAM + $25
	LDA iCurrentPlayerSize
	BNE loc_BANKF_F43F

	LDA zCurrentCharacter
	CMP #Character_Princess
	BNE loc_BANKF_F43F

	LDA zPlayerAnimFrame
	CMP #SpriteAnimation_Jumping
	BNE loc_BANKF_F43F

	LDX #$2A

loc_BANKF_F43F:
	LDA CharacterTiles_Walk1 + 2, X
	STA iVirtualOAM + $29
	LDA CharacterTiles_Walk1 + 3, X
	BNE loc_BANKF_F478

loc_BANKF_F44A:
	LDA iVirtualOAM + $27
	STA iVirtualOAM + 3, Y
	LDA CharacterTiles_Walk1 + 1, X
	STA iVirtualOAM + $21
	LDA CharacterTiles_Walk1, X
	STA iVirtualOAM + $25
	LDA iCurrentPlayerSize
	BNE loc_BANKF_F46F

	LDA zCurrentCharacter
	CMP #Character_Princess
	BNE loc_BANKF_F46F

	LDA zPlayerAnimFrame
	CMP #SpriteAnimation_Jumping
	BNE loc_BANKF_F46F

	LDX #$2A

loc_BANKF_F46F:
	LDA CharacterTiles_Walk1 + 3, X
	STA iVirtualOAM + $29
	LDA CharacterTiles_Walk1 + 2, X

loc_BANKF_F478:
	STA iVirtualOAM + $2D
	RTS


; =============== S U B R O U T I N E =======================================

SetAreaStartPage:
	LDA zScrollCondition
	BNE SetAreaStartPage_HorizontalLevel

	LDY zPlayerYHi
	LDA zPlayerYLo
	JSR GetVerticalAreaStartPage

	TYA
	BPL SetAreaStartPage_SetAndExit
	LDA #$00
	BEQ SetAreaStartPage_SetAndExit

SetAreaStartPage_HorizontalLevel:
	LDA zPlayerXHi

SetAreaStartPage_SetAndExit:
	STA iCurrentLvlPage
	RTS

;
; Check if the player position requires vertical scrolling
;
DetermineVerticalScroll:
	; Exit if vertical scrolling is already happening
	LDX zScrollArray
	BNE DetermineVerticalScroll_Exit

	; Exit if the player is doing any kind of transition
	LDA zPlayerState
	CMP #PlayerState_Lifting
	BCS DetermineVerticalScroll_Exit

	; Use the player's position to detmine how to scroll
	LDA iPlayerScreenY
	LDY iPlayerScreenYPage
	BMI DetermineVerticalScroll_ScrollUpOnGround ; eg. `iPlayerScreenYPage == $FF`
	BNE DetermineVerticalScroll_ScrollDown ; eg. `iPlayerScreenYPage == $01`

	; Scroll down if player is near the bottom
	CMP #$B4
	BCS DetermineVerticalScroll_ScrollDown

	; Scroll up if the player is near the top
	CMP #$21
	BCS DetermineVerticalScroll_StartFromStationary

; Don't start scrolling for offscreen player until they're standing or climbing
DetermineVerticalScroll_ScrollUpOnGround:
	LDY zPlayerGrounding
	BNE DetermineVerticalScroll_StartFromStationary ; Player is in the air
	BEQ DetermineVerticalScroll_ScrollUp ; Player is NOT in the air

DetermineVerticalScroll_ScrollDown:
	; Set X = $02, scroll down
	INX

DetermineVerticalScroll_ScrollUp:
	; Set X = $01, scroll up
	INX

DetermineVerticalScroll_StartFromStationary:
	LDA iVerticalScrollVelocity
	STX iVerticalScrollVelocity
	BNE DetermineVerticalScroll_Exit

	; We weren't already vertically scrolling, but we need to start
	STX zScrollArray

DetermineVerticalScroll_Exit:
	RTS


; Determines start page for vertical area
GetVerticalAreaStartPage:
	STA z0f
	TYA
	BMI locret_BANKF_F4D9

	ASL A
	ASL A
	ASL A
	ASL A
	CLC
	ADC z0f
	BCS loc_BANKF_F4D5

	CMP #$F0
	BCC locret_BANKF_F4D9

loc_BANKF_F4D5:
	CLC
	ADC #$10
	INY

locret_BANKF_F4D9:
	RTS
