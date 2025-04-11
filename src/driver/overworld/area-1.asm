AreaMainRoutine:
	LDA iAreaTransitionID
	BEQ AreaMainRoutine_NoTransition
	RTS

AreaMainRoutine_NoTransition:
	LDA iAreaInitFlag
	BEQ AreaInitialization

	JMP AreaMainRoutine_Gameplay

; ---------------------------------------------------------------------------

AreaInitialization:
	INC iAreaInitFlag
	STA i5ba
	STA iPOWTimer
	STA iSkyFlashTimer
	STA iMaskDoorOpenFlag
	STA iMaskClosingFlag
	STA iSwarmType
	STA iMaskPreamble
	STA iScrollXLock
	STA iVerticalScrollVelocity
	STA zPlayerXVelocity
	STA zDamageCooldown
	STA zHeldItem
	STA zPlayerStateTimer
	STA iBGYOffset
	STA iPokeyTempScreenX
	STA iCrouchJumpTimer
	STA iFloatTimer
	STA iQuicksandDepth
	STA iVictory

	LDY #$1B
AreaInitialization_CarryYOffsetLoop:
	; Copy the global carrying Y offsets to memory
	; These are used for every character for different frames of the pickup animation
	LDA ItemCarryYOffsets, Y
	STA wHeldItemYOffsets, Y
	DEY
	BPL AreaInitialization_CarryYOffsetLoop

	; Copy the character-specific FINAL carrying heights into memory
	LDY zCurrentCharacter
	LDA CarryYOffsetBigLo, Y
	STA wHeldItemYOffsets
	LDA CarryYOffsetSmallLo, Y
	STA wHeldItemYOffsets + $07
	LDA CarryYOffsetBigHi, Y
	STA wHeldItemYOffsets + $0E
	LDA CarryYOffsetSmallHi, Y
	STA wHeldItemYOffsets + $15

	LDA #$B6
	STA iPRNGSeed
	LDA iTransitionType

	; Play the slide-whistle when you start the game and drop into 1-1
	ORA iCurrentLvl
	BNE AreaInitialization_CheckObjectCarriedOver

	LDA #SFX_FALL
	STA iHillSFX

AreaInitialization_CheckObjectCarriedOver:
	LDA iObjectToUseNextRoom
	BEQ AreaInitialization_SetEnemyData

	LDX #$05
	STX z12
	CMP #Enemy_Mushroom
	BEQ AreaInitialization_SetEnemyData

	STA zObjectType, X
	LDY #EnemyState_Alive
	STY zEnemyState + 5
	LDY #$FF
	STY iEnemyRawDataOffset + 5
	CMP #Enemy_Rocket
	BNE AreaInitialization_NonRocketCarryOver

AreaInitialization_Rocket:
	; A = $38 (Enemy_Rocket)
	; X = $05 (from above)
	STA zEnemyArray, X
	STA iIsInRocket, X ; Bug? This sets iObjectXVelocity for enemy 0
	STA i477, X
	LDA #$00
	STA zObjectXHi, X
	STA zObjectYHi, X
	JSR SetEnemyAttributes

	LDA #$F0
	STA zObjectYVelocity, X
	ASL A
	STA zObjectYLo, X
	LDA #$78
	STA zObjectXLo, X
	BNE AreaInitialization_SetEnemyData

AreaInitialization_NonRocketCarryOver:
	PHA
	STX iHeldItemIndex
	JSR EnemyInit_Basic

	LDA #$01
	STA zHeldObjectTimer, X
	STA zHeldItem
	JSR CarryObject

	PLA
	CMP #Enemy_Key
	BNE AreaInitialization_SetEnemyData

AreaInitialization_KeyCarryOver:
	INC zObjectVariables, X
	DEX
	STX z12
	LDA #EnemyState_Alive
	STA zEnemyState, X
	LDA #Enemy_Phanto
	STA zObjectType, X
	JSR EnemyInit_Basic

	LDA #$00
	STA iPhantoTimer
	LDA zScreenY
	STA zObjectYLo, X
	LDA zScreenYPage
	STA zObjectYHi, X
	LDA iBoundLeftLower
	STA zObjectXLo, X
	LDA iBoundLeftUpper
	STA zObjectXHi, X
	JSR UnlinkEnemyFromRawData

AreaInitialization_SetEnemyData:
	LDA #<wRawEnemyPointer
	STA zRawSpriteData
	LDA #>wRawEnemyPointer
	STA zRawSpriteData + 1
	LDA zScrollCondition
	BNE AreaInitialization_HorizontalArea

;
; Loads area enemies based on the vertical screen scroll
;
AreaInitialization_VerticalArea:
	LDA #$14
	STA z09
	LDA zScreenY
	SBC #$30
	AND #$F0
	STA z05
	LDA zScreenYPage
	SBC #$00
	STA z06

AreaInitialization_VerticalArea_Loop:
	LDA z06
	CMP #$0B
	BCS AreaInitialization_VerticalArea_Next

	JSR CheckObjectVerticalSpawnBoundaries_InitializePage
	JSR CheckObjectVerticalSpawnBoundaries_InitializePage

AreaInitialization_VerticalArea_Next:
	JSR IncrementSpawnBoundaryTile

	DEC z09
	BPL AreaInitialization_VerticalArea_Loop

	RTS

; End of function AreaMainRoutine

;
; Increments the spawn boundary by one tile, incrementing the page if necessary
;
IncrementSpawnBoundaryTile:
	LDA z05
	CLC
	ADC #$10
	STA z05
	BCC IncrementSpawnBoundaryTile_Exit

	INC z06

IncrementSpawnBoundaryTile_Exit:
	RTS


;
; Loads area enemies based on the horizontal screen scroll
;
AreaInitialization_HorizontalArea:
	; Start 3 tiles to the left of the screen boundary
	LDA iBoundLeftLower
	SBC #$30
	AND #$F0
	STA z05
	LDA iBoundLeftUpper
	SBC #$00
	STA z06

	; Check a screen and a half's worth of objects
	LDA #$17
	STA z09
AreaInitialization_HorizontalArea_Loop:
	LDA z06
	CMP #$0B
	BCS AreaInitialization_HorizontalArea_Next

	JSR CheckObjectHorizontalSpawnBoundaries_InitializePage
	JSR CheckObjectHorizontalSpawnBoundaries_InitializePage

AreaInitialization_HorizontalArea_Next:
	JSR IncrementSpawnBoundaryTile

	DEC z09
	BPL AreaInitialization_HorizontalArea_Loop

	RTS

;
; Main routine handles
;
; 1. Check object spawn boundaries
; 2. Stopwatch
; 3. Calculate right screen boundary
; 4. Run enemy logic
;
AreaMainRoutine_Gameplay:
	JSR CheckObjectSpawnBoundaries

IFDEF SIXTEEN_BIT_WATCH_TIMER
	LDA iWatchTimer + 1
	BNE AreaMainRoutine_HandleStopwatch
	LDA iWatchTimer
	BEQ AreaMainRoutine_CalculateScreenBoundaryRight
AreaMainRoutine_HandleStopwatch:
ELSE
	LDA iWatchTimer
	BEQ AreaMainRoutine_CalculateScreenBoundaryRight
ENDIF

	; Handle the stopwatch
	LDA z10
	AND #$1F
	BNE AreaMainRoutine_DecrementStopwatch

	LDY #SFX_WATCH
	STY iHillSFX

AreaMainRoutine_DecrementStopwatch:
	LSR A
	BCC AreaMainRoutine_CalculateScreenBoundaryRight

	DEC iWatchTimer

IFDEF SIXTEEN_BIT_WATCH_TIMER
	LDA iWatchTimer
	CMP #$ff
	BNE AreaMainRoutine_CalculateScreenBoundaryRight
	LDA iWatchTimer + 1
	BEQ AreaMainRoutine_CalculateScreenBoundaryRight
	DEC iWatchTimer + 1
ENDIF

	; Calculate the screen boundary on the right
AreaMainRoutine_CalculateScreenBoundaryRight:
	LDA iBoundLeftLower
	CLC
	ADC #$FF
	STA iBoundRightLower
	LDA iBoundLeftUpper
	ADC #$00
	STA iBoundRightUpper

	; Loop through objects and
	LDX #$08
AreaMainRoutine_ObjectLoop:
	STX z12

	; Determine the DMA offset for the sprite, starting with the enemy ID offset
	; by the sprite flicker slot.
	TXA
	CLC
	ADC iObjectFlickerer
	TAY
	LDA SpriteFlickerDMAOffset, Y

	; If the object is being carried, it gets slot $10
	LDY zHeldObjectTimer, X
	BEQ AreaMainRoutine_SetObjectDMAOffset

	LDA #$10

	; Unless it's the rocket, in which case it takes slot $00
	LDY zObjectType, X
	CMP #Enemy_Rocket
	BNE AreaMainRoutine_SetObjectDMAOffset

	LDA #$00

AreaMainRoutine_SetObjectDMAOffset:
	STA zf4 ; Store object DMA offset

	; Is it dead?
	LDA zEnemyState, X
	CMP #EnemyState_Dead
	BCS AreaMainRoutine_DecrementObjectTimer1

	; Is it affected by the stopwatch?
	LDA zObjectType, X
	CMP #Enemy_VegetableSmall
	BCS AreaMainRoutine_DecrementObjectTimer1

	; If the stopwatch is running, freeze object timers 1 and 2.
	LDA iWatchTimer
	BNE AreaMainRoutine_DecrementObjectFlashTimer
IFDEF SIXTEEN_BIT_WATCH_TIMER
	LDA iWatchTimer + 1
	BNE AreaMainRoutine_DecrementObjectFlashTimer
ENDIF

	; General-purpose time-based behavior
AreaMainRoutine_DecrementObjectTimer1:
	LDA zSpriteTimer, X
	BEQ AreaMainRoutine_DecrementObjectTimer2

	DEC zSpriteTimer, X

AreaMainRoutine_DecrementObjectTimer2:
	LDA iSpriteTimer, X
	BEQ AreaMainRoutine_DecrementObjectFlashTimer

	DEC iSpriteTimer, X

	; Flashing palette
AreaMainRoutine_DecrementObjectFlashTimer:
	LDA iObjectFlashTimer, X
	BEQ AreaMainRoutine_DecrementObjectStunTimer

	DEC iObjectFlashTimer, X

	; Enemy stun timer
AreaMainRoutine_DecrementObjectStunTimer:
	LDA iObjectStunTimer, X
	BEQ AreaMainRoutine_ObjectBehavior

	LDA z10
	LSR A
	BCC AreaMainRoutine_ObjectBehavior

	DEC iObjectStunTimer, X

	; Tick PRNG, update the temprary screen position, and run the object behavior
AreaMainRoutine_ObjectBehavior:
	JSR TickPseudoRNG

	JSR SetSpriteTempScreenPosition

	JSR HandleEnemyState

	; Next object (previous index), if there is one
	LDX z12
	DEX
	BPL AreaMainRoutine_ObjectLoop

	; Done with the regular objects! Is there an active swarm currently?
	LDA iSwarmType
	BEQ HandleEnemyState_Inactive
