;
; Bank 2 & Bank 3
; ===============
;
; What's inside:
;
;   - Enemy initialization and logic
;

CarryYOffsets:
CarryYOffsetBigLo:
	.db $FA ; Mario
	.db $F6 ; Princess
	.db $FC ; Toad
	.db $F7 ; Luigi

CarryYOffsetBigHi:
	.db $FF ; Mario
	.db $FF ; Princess
	.db $FF ; Toad
	.db $FF ; Luigi

CarryYOffsetSmallLo:
	.db $02 ; Mario
	.db $FE ; Princess
	.db $04 ; Toad
	.db $FF ; Luigi

CarryYOffsetSmallHi:
	.db $00 ; Mario
	.db $FF ; Princess
	.db $00 ; Toad
	.db $FF ; Luigi


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

	LDA #Hill_Fall
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

	; Check a screen and a half screen's worth of objects
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

	LDY #SoundEffect2_Watch
	STY iPulse1SFX

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

InitializeSwarm:
	SEC
	SBC #((EnemyInitializationTable_End - EnemyInitializationTable) / 2)

InitializeSwarmRelative:
	JSR JumpToTableAfterJump


GeneratorInitializationTable:
	.dw Swarm_AlbatossCarryingBobOmb
	.dw Swarm_BeezoDiving
	.dw Swarm_Stop
	.dw Generator_VegetableThrower
GeneratorInitializationTable_End:


Swarm_Stop:
	LDA #$00
	STA iSwarmType

HandleEnemyState_Inactive:
	RTS


;
; The pseudo-random number generator uses four bytes to generate values.
; It runs once for each object slot.
;
TickPseudoRNG:
	LDY #$00
	JSR TickPseudoRNG_Inner

	INY

TickPseudoRNG_Inner:
	LDA iPRNGSeed
	ASL A
	ASL A
	SEC
	ADC iPRNGSeed
	STA iPRNGSeed

	ASL iPRNGSeed + 1
	LDA #$20
	BIT iPRNGSeed + 1

	; Bit 7 of `iPRNGSeed + 1` before the shift determines whether the next
	; branch checks for `== $20` or `!= $20`
	BCC TickPseudoRNG_Reversed

	; Increment first for `!= $20`
	BEQ TickPseudoRNG_EOR
	BNE TickPseudoRNG_IncEOR

	; Increment first for `== $20`
TickPseudoRNG_Reversed:
	BNE TickPseudoRNG_EOR

TickPseudoRNG_IncEOR:
	INC iPRNGSeed + 1
TickPseudoRNG_EOR:
	LDA iPRNGSeed + 1
	EOR iPRNGSeed
	STA iPRNGValue, Y

	RTS


HandleEnemyState:
	LDA zEnemyState, X
	JSR JumpToTableAfterJump

	.dw HandleEnemyState_Inactive ; 0 (not active)
	.dw HandleEnemyState_Alive ; Alive
	.dw HandleEnemyState_Dead ; Dead
	.dw HandleEnemyState_BlockFizzle ; Block fizzle
	.dw HandleEnemyState_BombExploding ; Bomb exploding
	.dw HandleEnemyState_PuffOfSmoke ; Puff of smoke
	.dw HandleEnemyState_Sand ; Sand after digging
	.dw loc_BANK2_85B2 ; Object carried/thrown?


; Offset from left boundary of screen\
SpawnBoundaryOffsets:
	.db $18 ; rightward (lo)
	.db $E0 ; leftward (lo)
	.db $01 ; rightward (hi)
	.db $FF ; leftward (hi)


CheckObjectSpawnBoundaries:
	LDA iVictory
	BNE CheckObjectSpawnBoundaries_Exit

	LDA zScrollCondition
	JSR JumpToTableAfterJump

	.dw CheckObjectVerticalSpawnBoundaries
	.dw CheckObjectHorizontalSpawnBoundaries


CheckObjectHorizontalSpawnBoundaries:
	LDY zPlayerTrajectory
	; Low offset (pixel)
	LDA iBoundLeftLower
	CLC
	ADC SpawnBoundaryOffsets - 1, Y
	AND #$F0
	STA z05
	; High offset (page)
	LDA iBoundLeftUpper
	ADC SpawnBoundaryOffsets + 1, Y
	STA z06
	CMP #$0A
	BCS CheckObjectSpawnBoundaries_Exit


CheckObjectHorizontalSpawnBoundaries_InitializePage:
	LDA iSubAreaFlags
	CMP #$02
	BEQ CheckObjectSpawnBoundaries_Exit

	; Initialize the enemy data page offset
	LDX #$00
	STX z00
CheckObjectHorizontalSpawnBoundaries_InitializePage_Loop:
	; Stop looping and start checking the individual enemies on the current page
	CPX z06
	BEQ CheckObjectHorizontalSpawnBoundaries_InitializePage_Next

	; Advance to the next page of enemy data
	LDA z00
	TAY
	CLC
	ADC (zRawSpriteData), Y
	STA z00
	INX
	JMP CheckObjectHorizontalSpawnBoundaries_InitializePage_Loop


CheckObjectHorizontalSpawnBoundaries_InitializePage_Next:
	; We're on the page, now start counting bytes of enemy data
	LDY z00
	LDA (zRawSpriteData), Y
	STA z01
	LDX #$FF
	DEY

CheckObjectHorizontalSpawnBoundaries_InitializePage_NextObject:
	INY
	INY
	INX
	INX
	CPX z01
	BCC CheckObjectHorizontalSpawnBoundaries_InitializePage_InitializeObject

	LDX z12

CheckObjectSpawnBoundaries_Exit:
	RTS


CheckObjectHorizontalSpawnBoundaries_InitializePage_InitializeObject:
	; If bit 7 of the enemy type is set, it's already active and we should not re-initialize
	LDA (zRawSpriteData), Y
	BMI CheckObjectHorizontalSpawnBoundaries_InitializePage_NextObject

	; Load the x-position of the object
	INY
	LDA (zRawSpriteData), Y
	DEY
	AND #$F0
	CMP z05
	BNE CheckObjectHorizontalSpawnBoundaries_InitializePage_NextObject

	; Check if it's a generator/swarm object (end of enemy init table < enemy type > boss types)
	LDA (zRawSpriteData), Y
	CMP #Enemy_BossBirdo
	BCS CheckObjectHorizontalSpawnBoundaries_InitializePage_RegularObject
	CMP #((EnemyInitializationTable_End - EnemyInitializationTable) / 2)
	BCC CheckObjectHorizontalSpawnBoundaries_InitializePage_RegularObject

	STA iSwarmType
	RTS


CheckObjectHorizontalSpawnBoundaries_InitializePage_RegularObject:
	; Look for an enmpy slot for the object
	LDX #$04
CheckObjectHorizontalSpawnBoundaries_InitializePage_RegularObject_Loop:
	LDA zEnemyState, X
	BEQ CheckObjectHorizontalSpawnBoundaries_InitializePage_CreateObject

	DEX
	BPL CheckObjectHorizontalSpawnBoundaries_InitializePage_RegularObject_Loop

	RTS

CheckObjectHorizontalSpawnBoundaries_InitializePage_CreateObject:
	; Store the object slot used
	STX z12

	; Set the x-position of the object (we already looked it up)
	LDA z05
	STA zObjectXLo, X
	LDA z06
	STA zObjectXHi, X

	; Set the y-position of the object (fetch from the enemy data)
	INY
	LDA (zRawSpriteData), Y
	DEY
	ASL A
	ASL A
	ASL A
	ASL A
	STA zObjectYLo, X
	LDA #$00
	STA zObjectYHi, X

	JMP CheckObjectSpawnBoundaries_InitializePage_PreInitObject


CheckObjectVerticalSpawnBoundaries:
	LDA z10
	AND #$01
	TAY
	INY
	LDA zScrollArray
	BEQ loc_BANK2_82FC

	AND #$03
	EOR #$03
	TAY

loc_BANK2_82FC:
	LDA zScreenY
	CLC
	ADC SpawnBoundaryOffsets - 1, Y
	AND #$F0
	STA z05
	LDA zScreenYPage
	ADC SpawnBoundaryOffsets + 1, Y
	STA z06
	CMP #$0A
	BCS CheckObjectSpawnBoundaries_Exit

CheckObjectVerticalSpawnBoundaries_InitializePage:
	LDX #$00
	STX z00
CheckObjectVerticalSpawnBoundaries_InitializePage_Loop:
	; Stop looping and start checking the individual enemies on the current page
	CPX z06
	BEQ CheckObjectVerticalSpawnBoundaries_InitializePage_Next

	; Advance to the next page of enemy data
	LDA z00
	TAY
	CLC
	ADC (zRawSpriteData), Y
	STA z00
	INX
	JMP CheckObjectVerticalSpawnBoundaries_InitializePage_Loop


CheckObjectVerticalSpawnBoundaries_InitializePage_Next:
	; We're on the page, now start counting bytes of enemy data
	LDY z00
	LDA (zRawSpriteData), Y
	STA z01
	LDX #$FF
	DEY

CheckObjectVerticalSpawnBoundaries_InitializePage_NextObject:
	INY
	INY
	INX
	INX
	CPX z01
	BCC CheckObjectVerticalSpawnBoundaries_InitializePage_InitializeObject

	LDX z12

CheckObjectVerticalSpawnBoundaries_Exit:
	RTS


CheckObjectVerticalSpawnBoundaries_InitializePage_InitializeObject:
	; If bit 7 of the enemy type is set, it's already active and we should not re-initialize
	LDA (zRawSpriteData), Y
	BMI CheckObjectVerticalSpawnBoundaries_InitializePage_NextObject

	; Load the y-position of the object
	INY
	LDA (zRawSpriteData), Y
	DEY
	ASL A
	ASL A
	ASL A
	ASL A
	CMP z05
	BNE CheckObjectVerticalSpawnBoundaries_InitializePage_NextObject

	; Check if it's a generator/swarm object (end of enemy init table < enemy type > boss types)
	LDA (zRawSpriteData), Y
	CMP #Enemy_BossBirdo
	BCS CheckObjectVerticalSpawnBoundaries_InitializePage_RegularObject
	CMP #((EnemyInitializationTable_End - EnemyInitializationTable) / 2)
	BCC CheckObjectVerticalSpawnBoundaries_InitializePage_RegularObject

	STA iSwarmType
	RTS


CheckObjectVerticalSpawnBoundaries_InitializePage_RegularObject:
	LDX #$04
CheckObjectVerticalSpawnBoundaries_InitializePage_RegularObject_Loop:
	LDA zEnemyState, X
	BEQ CheckObjectVerticalSpawnBoundaries_InitializePage_CreateObject

	DEX
	BPL CheckObjectVerticalSpawnBoundaries_InitializePage_RegularObject_Loop

	RTS


CheckObjectVerticalSpawnBoundaries_InitializePage_CreateObject:
	; Store the object slot used
	STX z12

	; Set the y-position of the object (we already looked it up)
	LDA z05
	STA zObjectYLo, X
	LDA z06
	STA zObjectYHi, X

	; Set the x-position of the object (fetch from the enemy data)
	INY
	LDA (zRawSpriteData), Y
	DEY
	AND #$F0
	STA zObjectXLo, X
	LDA #$00
	STA zObjectXHi, X

CheckObjectSpawnBoundaries_InitializePage_PreInitObject:
	; Reset the flag to spawn a door
	STA iLocalBossArray, X
	; Stash the enemy data offset
	STY z0c

	; Face the player (horizontal levels only)
	LDA (zRawSpriteData), Y
	AND #%00111111
	CMP #Enemy_VegetableSmall
	BCS CheckObjectSpawnBoundaries_InitializePage_MarkEnemyData

	LDA zScrollCondition
	BEQ CheckObjectSpawnBoundaries_InitializePage_MarkEnemyData

	JSR EnemyFindWhichSidePlayerIsOn

	LDA z0f
	ADC #$18
	CMP #$30
	BCC CheckObjectVerticalSpawnBoundaries_Exit

CheckObjectSpawnBoundaries_InitializePage_MarkEnemyData:
	; enable bit 7 of the raw enemy data to indicate that the enemy has spawned
	LDY z0c
	LDA (zRawSpriteData), Y
	ORA #%10000000
	STA (zRawSpriteData), Y

	; Is this a boss type?
	CMP #%10000000 | Enemy_BossBirdo
	AND #%01111111
	BCC CheckObjectSpawnBoundaries_InitializePage_SetObjectType

	; Enable the flag to spawn a door for boss types
	AND #%00111111
	STA iLocalBossArray, X

CheckObjectSpawnBoundaries_InitializePage_SetObjectType:
	STA zObjectType, X
	TYA
	STA iEnemyRawDataOffset, X
	INC zEnemyState, X
	LDA zObjectType, X

InitializeEnemy:
	JSR JumpToTableAfterJump

EnemyInitializationTable:
	.dw EnemyInit_Basic ; Heart
	.dw EnemyInit_Basic ; ShyguyRed
	.dw EnemyInit_Basic ; Tweeter
	.dw EnemyInit_Basic ; ShyguyPink
	.dw EnemyInit_Basic ; Porcupo
	.dw EnemyInit_Basic ; SnifitRed
	.dw EnemyInit_Stationary ; SnifitGray
	.dw EnemyInit_Basic ; SnifitPink
	.dw EnemyInit_Basic ; Ostro
	.dw EnemyInit_Bobomb ; BobOmb
	.dw EnemyInit_Basic ; AlbatossCarryingBobOmb
	.dw EnemyInit_AlbatossStartRight ; AlbatossStartRight
	.dw EnemyInit_AlbatossStartLeft ; AlbatossStartLeft
	.dw EnemyInit_Basic ; NinjiRunning
	.dw EnemyInit_Stationary ; NinjiJumping
	.dw EnemyInit_BeezoDiving ; BeezoDiving
	.dw EnemyInit_Basic ; BeezoStraight
	.dw EnemyInit_Basic ; WartBubble
	.dw EnemyInit_Basic ; Pidgit
	.dw EnemyInit_Trouter ; Trouter
	.dw EnemyInit_Basic ; Hoopstar
	.dw EnemyInit_JarGenerators ; JarGeneratorShyguy
	.dw EnemyInit_JarGenerators ; JarGeneratorBobOmb
	.dw EnemyInit_Phanto ; Phanto
	.dw EnemyInit_Cobrats ; CobratJar
	.dw EnemyInit_Cobrats ; CobratSand
	.dw EnemyInit_Pokey ; Pokey
	.dw EnemyInit_Basic ; Bullet
	.dw EnemyInit_Birdo ; Birdo
	.dw EnemyInit_Mouser ; Mouser
	.dw EnemyInit_Basic ; Egg
	.dw EnemyInit_Tryclyde ; Tryclyde
	.dw EnemyInit_Basic ; Fireball
	.dw EnemyInit_Clawgrip ; Clawgrip
	.dw EnemyInit_Basic ; ClawgripRock
	.dw EnemyInit_Stationary ; PanserStationaryFiresAngled
	.dw EnemyInit_Basic ; PanserWalking
	.dw EnemyInit_Stationary ; PanserStationaryFiresUp
	.dw EnemyInit_Basic ; Autobomb
	.dw EnemyInit_Basic ; AutobombFire
	.dw EnemyInit_WhaleSpout ; WhaleSpout
	.dw EnemyInit_Basic ; Flurry
	.dw EnemyInit_Fryguy ; Fryguy
	.dw EnemyInit_Fryguy ; FryguySplit
	.dw EnemyInit_Wart ; Wart
	.dw EnemyInit_HawkmouthBoss ; HawkmouthBoss
	.dw EnemyInit_Sparks ; Spark1
	.dw EnemyInit_Sparks ; Spark2
	.dw EnemyInit_Sparks ; Spark3
	.dw EnemyInit_Sparks ; Spark4
	.dw EnemyInit_Basic ; VegetableSmall
	.dw EnemyInit_Basic ; VegetableLarge
	.dw EnemyInit_Basic ; VegetableWart
	.dw EnemyInit_Basic ; Shell
	.dw EnemyInit_Basic ; Coin
	.dw EnemyInit_Basic ; Bomb
	.dw EnemyInit_Basic ; Rocket
	.dw EnemyInit_Basic ; MushroomBlock
	.dw EnemyInit_Basic ; POWBlock
	.dw EnemyInit_FallingLogs ; FallingLogs
	.dw EnemyInit_Basic ; SubspaceDoor
	.dw EnemyInit_Key ; Key
	.dw EnemyInit_Basic ; SubspacePotion
	.dw EnemyInit_Stationary ; Mushroom
	.dw EnemyInit_Stationary ; Mushroom1up
	.dw EnemyInit_Basic ; FlyingCarpet
	.dw EnemyInit_Hawkmouth ; HawkmouthRight
	.dw EnemyInit_Hawkmouth ; HawkmouthLeft
	.dw EnemyInit_CrystalBallStarmanStopwatch ; CrystalBall
	.dw EnemyInit_CrystalBallStarmanStopwatch ; Starman
	.dw EnemyInit_CrystalBallStarmanStopwatch ; Stopwatch
EnemyInitializationTable_End:


;
; Sets enemy attributes to the default for the object type
;
; Input
;   X = enemy index
;
SetEnemyAttributes:
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
	RTS


;
; Enemy initialization with a timer reset
;
EnemyInit_Basic:
	LDA #$00
	STA zSpriteTimer, X

;
; Enemy initialization without an explicit timer reset
;
; Most things are set to $00
;
EnemyInit_BasicWithoutTimer:
	LDA #$00
	STA zObjectVariables, X
	LDA #$00 ; You do realize you already LDA #$00, right???
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

EnemyInit_BasicAttributes:
	JSR SetEnemyAttributes

; Initialize enemy movement in direction of player
EnemyInit_BasicMovementTowardPlayer:
	JSR EnemyFindWhichSidePlayerIsOn

; Initialize enemy movement
; Y = 1 (move to the left)
; Y = 0 (move to the right)
EnemyInit_BasicMovement:
	INY ; uses using index 1 or 2 of EnemyInitialAccelerationTable
	STY zEnemyTrajectory, X
	LDA EnemyInitialAccelerationTable, Y
	STA zObjectXVelocity, X

	; Double the speed of objects when bit 6 of 46E is set
	LDA i46e, X
	AND #%01000000
	BEQ EnemyInit_BasicMovementExit
	ASL zObjectXVelocity, X ; Change the speed of certain objects?

EnemyInit_BasicMovementExit:
	RTS


BeezoXOffsetTable:
	.db $FE ; If player moving right
	.db $00 ; If moving left

BeezoDiveSpeedTable:
	.db $12, $16, $1A, $1E, $22, $26, $2A, $2D
	.db $30, $32, $34, $37, $39, $3B, $3D, $3E

EnemyInit_BeezoDiving:
	JSR EnemyInit_Basic

	LDY zPlayerTrajectory ; $02 = left, $01 = right
	LDA iBoundLeftLower
	ADC BeezoXOffsetTable - 1, Y
	STA zObjectXLo, X ; Spawn in front of the player to dive at them
	LDA iBoundLeftUpper
	ADC #$00
	STA zObjectXHi, X

; =============== S U B R O U T I N E =======================================

EnemyBeezoDiveSetup:
	LDA zPlayerYHi
	BPL loc_BANK2_84D5

	; If above the screen, just abort and use the least descend-y one
	LDY #$00
	BEQ loc_BANK2_84DF

loc_BANK2_84D5:
	LDA zPlayerYLo ; Check how far down on the screen the player is
	SEC
	SBC zScreenY
	LSR A ; And then take only the highest 4 bits
	LSR A ; (divide by 16)
	LSR A
	LSR A
	TAY

loc_BANK2_84DF:
	LDA BeezoDiveSpeedTable, Y
	STA zObjectYVelocity, X
	RTS

; End of function EnemyBeezoDiveSetup

; ---------------------------------------------------------------------------

EnemyInit_Phanto:
	JSR EnemyInit_Basic

	LDA #$0C
	STA zObjectXVelocity, X
	LDA #$A0
	STA iPhantoTimer
	RTS

; =============== S U B R O U T I N E =======================================

EnemyInit_Bobomb:
	JSR EnemyInit_Basic

	LDA #$FF
	STA zSpriteTimer, X
	RTS

; End of function EnemyInit_Bobomb

; ---------------------------------------------------------------------------

HandleEnemyState_Dead:
	JSR CheckObjectCollision ; collision detection

	JSR sub_BANK2_88E8

	LDA zEnemyState, X
	BNE MakeEnemyFlipUpsideDown

	LDA iLocalBossArray, X
	BEQ EnemyDeathMaybe

loc_BANK2_8509:
	STA iVictory
	JSR DestroyOnscreenEnemies

	JSR Swarm_Stop

	LDA #Music_BossClearFanfare
	STA iMusic
	LDA iEndOfLevelDoorPage, X
	STA zObjectXHi, X
	LDA #$80
	STA zObjectXLo, X
	ASL A
	STA zObjectYHi, X
	LDA #$B0
	LDY zObjectType, X
	CPY #Enemy_Clawgrip
	BNE loc_BANK2_852D

	LDA #$70

loc_BANK2_852D:
	STA zObjectYLo, X
	LDA #%01000001
	STA zObjectAttributes, X
	STA i46e, X
	JMP TurnIntoPuffOfSmoke

; ---------------------------------------------------------------------------

EnemyDeathMaybe:
	LDA zObjectType, X
	CMP #Enemy_Bullet ; "Stray bullet" enemy type
	BEQ MakeEnemyFlipUpsideDown

	INC iKills
	LDY iKills
	CPY #$08 ; number of enemies to kill before a heart appears
	BCC MakeEnemyFlipUpsideDown

	LDA #$00 ; reset enemy kill counter for heart counter
	STA iKills

	LDA #EnemyState_Alive ; convert dead enemy to living heart
	STA zEnemyState, X
	STA zObjectAttributes, X
	LDA #%00000111 ; what's this magic number for?
	STA i46e, X
	LDA #Enemy_Heart
	STA zObjectType, X
	LDA zObjectYLo, X
	SBC #$60 ; subtract this amount from the y position where the enemy despawned
	STA zObjectYLo, X
	LDA zObjectYHi, X
	SBC #$00
	STA zObjectYHi, X


;
; Spawned enemies are linked to an offset in the raw enemy data, which prevents
; from being respawned until they are killed or moved offscreen.
;
; This subroutine ensures that the enemy in a particular slot is not linked to
; the raw enemy data
;s
; Input
;   X = enemy slot
;
UnlinkEnemyFromRawData:
	LDA #$FF
	STA iEnemyRawDataOffset, X
	RTS


MakeEnemyFlipUpsideDown:
	ASL zObjectAttributes, X ; Shift left...
	SEC ; Set carry...
	ROR zObjectAttributes, X ; Shift right. Effectively sets $80 bit

RenderSpriteAndApplyObjectMovement:
	JSR RenderSprite


;
; Applies object physics
;
; Input
;   X = enemy index
;
ApplyObjectMovement:
	; disable horiziontal physics while shaking
	LDA iObjectShakeTimer, X
	BNE ApplyObjectMovement_Vertical

	JSR ApplyObjectPhysicsX

ApplyObjectMovement_Vertical:
	JSR ApplyObjectPhysicsY

	LDA zObjectYVelocity, X
	BMI ApplyObjectMovement_Gravity

	; Check terminal velocity
	CMP #$3E
	BCS ApplyObjectMovement_Exit

ApplyObjectMovement_Gravity:
	INC zObjectYVelocity, X
	INC zObjectYVelocity, X

ApplyObjectMovement_Exit:
	RTS


HandleEnemyState_BlockFizzle:
	JSR sub_BANK2_88E8

	LDA zSpriteTimer, X
	BEQ loc_BANK2_85AF

	TAY
	LSR A
	LSR A
	AND #$01
	STA zEnemyTrajectory, X
	LDA #%00000001
	STA zObjectAttributes, X
	STA i46e, X
	LDA #$3C
	CPY #$C
	BCC loc_BANK2_85AC

	LDA #$3E

loc_BANK2_85AC:
	JMP RenderSprite_DrawObject

; ---------------------------------------------------------------------------

loc_BANK2_85AF:
	JMP EnemyDestroy

; ---------------------------------------------------------------------------

loc_BANK2_85B2:
	JSR sub_BANK2_88E8

	JSR EnemyBehavior_CheckDamagedInterrupt

	LDA zHeldObjectTimer, X
	BEQ loc_BANK2_85C1

	LDA #EnemyState_Alive
	STA zEnemyState, X
	RTS

; ---------------------------------------------------------------------------

loc_BANK2_85C1:
	LDA zSpriteTimer, X
	BEQ loc_BANK2_85AF

	LDA zObjectType, X
	CMP #Enemy_VegetableSmall
	BCS loc_BANK2_85E1

	JSR IncrementAnimationTimerBy2

	LDA z10
	AND #$03
	STA iObjectShakeTimer, X
	LDA z10
	AND #$10
	LSR A
	LSR A
	LSR A
	LSR A
	ADC #$01
	STA zEnemyTrajectory, X

loc_BANK2_85E1:
	JSR sub_BANK2_9486

	JMP CheckObjectCollision


ExplosionTileXOffsets:
	.db $F8
	.db $00
	.db $F8
	.db $00
	.db $08
	.db $10
	.db $08
	.db $10

ExplosionTileYOffsets:
	.db $F8
	.db $F8

EnemyInitialAccelerationTable:
	; these values are shared with ExplosionTileYOffsets!
	.db $08
	.db $08
	.db $F8
	.db $F8
	.db $08
	.db $08


HandleEnemyState_BombExploding:
	JSR sub_BANK2_88E8

	LDA zee
	ORA zef
	BNE loc_BANK2_85AF

	LDA zSpriteTimer, X
	BEQ loc_BANK2_85AF

	CMP #$1A
	BCS loc_BANK2_8610

	SBC #$11
	BMI loc_BANK2_8610

	TAY
	JSR sub_BANK2_8670

loc_BANK2_8610:
	LDA #$60
	STA z00
	LDX #$00
	LDY #$40

loc_BANK2_8618:
	LDA iSpriteTempScreenY
	CLC
	ADC ExplosionTileYOffsets, X
	STA iVirtualOAM, Y
	LDA iSpriteTempScreenX
	CLC
	ADC ExplosionTileXOffsets, X
	STA iVirtualOAM + 3, Y
	LDA #$01
	STA iVirtualOAM + 2, Y
	LDA z00
	STA iVirtualOAM + 1, Y
	CLC
	ADC #$02
	STA z00
	INY
	INY
	INY
	INY
	INX
	CPX #$08
	BNE loc_BANK2_8618

	LDX z12
	JMP CheckObjectCollision

; ---------------------------------------------------------------------------

locret_BANK2_8649:
	RTS

; ---------------------------------------------------------------------------
byte_BANK2_864A:
	.db $FB
	.db $08
	.db $15
	.db $FB
	.db $08
	.db $15
	.db $FB
	.db $08
	.db $15

byte_BANK2_8653:
	.db $FF
	.db $00
	.db $00
	.db $FF
	.db $00
	.db $00
	.db $FF
	.db $00
	.db $00

byte_BANK2_865C:
	.db $FC
	.db $FC
	.db $FC
	.db $08
	.db $08
	.db $08
	.db $14
	.db $14
	.db $14

byte_BANK2_8665:
	.db $FF
	.db $FF
	.db $FF
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00

byte_BANK2_866E:
	.db $5F
	.db $06

; =============== S U B R O U T I N E =======================================

sub_BANK2_8670:
	LDA zObjectXLo, X
	CLC
	ADC byte_BANK2_864A, Y
	STA z0c
	LDA zObjectXHi, X
	ADC byte_BANK2_8653, Y
	STA z0d
	CMP #$B
	BCS locret_BANK2_8649

	LDA zObjectYLo, X
	ADC byte_BANK2_865C, Y
	AND #$F0
	STA z0e
	STA z0b
	LDA zObjectYHi, X
	ADC byte_BANK2_8665, Y
	STA z0f
	CMP #$A
	BCS locret_BANK2_8649

	LDY zScrollCondition
	BNE loc_BANK2_86BD

	LSR A
	ROR z0e
	LSR A
	ROR z0e
	LSR A
	ROR z0e
	LSR A
	ROR z0e
	LDA z0e

	LDY #$FF
loc_BANK2_86AD:
	SEC
	SBC #$0F
	INY
	BCS loc_BANK2_86AD

	STY z0d
	ADC #$0F
	ASL A
	ASL A
	ASL A
	ASL A
	STA z0e

loc_BANK2_86BD:
	LDA z0c
	LSR A
	LSR A
	LSR A
	LSR A
	STA z04
	ORA z0e
	STA z05
	LDY #$00
	LDA iBoundLeftUpper
	CMP #$A
	BNE loc_BANK2_86D5

	STY z0d
	INY

loc_BANK2_86D5:
	LDA #$10
	STA z07
	LDA byte_BANK2_866E, Y
	STA z08
	LDY z0d

loc_BANK2_86E0:
	LDA z07
	CLC
	ADC #$F0
	STA z07
	LDA z08
	ADC #$00
	STA z08
	DEY
	BPL loc_BANK2_86E0

	LDY z05
	LDA (z07), Y
	CMP #$9D
	BEQ loc_BANK2_8701

	CMP #$93
	BEQ loc_BANK2_8701

	CMP #$72
	BEQ loc_BANK2_8701

	RTS

; ---------------------------------------------------------------------------

loc_BANK2_8701:
	LDA #$40
	STA (z07), Y
	LDA z0d
	AND #$01
	EOR #$01
	ASL A

loc_BANK2_870C:
	ASL A
	LDY zScrollCondition
	BNE loc_BANK2_8712

	ASL A

loc_BANK2_8712:
	PHA
	LDA z0e
	STA z02
	LDA z0c
	AND #$F0
	STA z03
	LDA #$08
	STA z00
	LDA z02
	ASL A
	ROL z00
	ASL A
	ROL z00
	AND #$E0
	STA z01
	LDA z03
	LSR A
	LSR A
	LSR A
	ORA z01
	LDX i300
	STA iPPUBuffer + 1, X
	CLC
	ADC #$20
	STA iPPUBuffer + 6, X
	PLA
	ORA z00
	STA iPPUBuffer, X
	ADC #$00
	STA iPPUBuffer + 5, X

loc_BANK2_874B:
	LDA #$02
	STA iPPUBuffer + 2, X
	STA iPPUBuffer + 7, X
	LDA #$FA
	STA iPPUBuffer + 3, X
	STA iPPUBuffer + 4, X
	STA iPPUBuffer + 8, X
	STA iPPUBuffer + 9, X
	LDA #$00
	STA iPPUBuffer + 10, X
	TXA
	CLC
	ADC #$A
	STA i300
	LDX #$08

loc_BANK2_876F:
	LDA zEnemyState, X
	BEQ loc_BANK2_8778

	DEX
	BPL loc_BANK2_876F

	BMI loc_BANK2_8795

loc_BANK2_8778:
	LDA z0c
	AND #$F0
	STA zObjectXLo, X
	LDA z0d
	LDY zScrollCondition
	BNE loc_BANK2_8785

	TYA

loc_BANK2_8785:
	STA zObjectXHi, X
	LDA z0b
	STA zObjectYLo, X
	LDA z0f
	STA zObjectYHi, X
	JSR EnemyInit_BasicWithoutTimer

	JSR sub_BANK2_98C4

loc_BANK2_8795:
	LDX z12

locret_BANK2_8797:
	RTS

; End of function sub_BANK2_8670

; ---------------------------------------------------------------------------
byte_BANK2_8798:
	.db $46
	.db $4A
	.db $4E
	.db $52
; ---------------------------------------------------------------------------

HandleEnemyState_PuffOfSmoke:
	JSR sub_BANK2_88E8

	LDA zObjectAttributes, X
	ORA #ObjAttrib_Mirrored
	STA zObjectAttributes, X
	LDA zSpriteTimer, X
	BNE loc_BANK2_87AC

	JMP loc_BANK2_8842

; ---------------------------------------------------------------------------

loc_BANK2_87AC:
	LSR A
	LSR A
	LSR A
	TAY
	LDA byte_BANK2_8798, Y
	JSR RenderSprite_DrawObject

	LDA iLocalBossArray, X
	BEQ locret_BANK2_8797

	LDA zSpriteTimer, X
	CMP #$03
	BNE locret_BANK2_8797

	LDY #$22
	LDA zObjectType, X
	CMP #Enemy_Clawgrip
	BNE loc_BANK2_87CA

	; Clawgrip special hack:
	; Move the "Draw the door" PPU command
	; up 8 tile rows ($100) to be on the platform
	DEY

loc_BANK2_87CA:
	STY wHawkDoorBuffer
	STY wHawkDoorBuffer + $07
	INY
	STY wHawkDoorBuffer + $0E
	STY wHawkDoorBuffer + $17
	LDY #$03

loc_BANK2_87D9:
	; Boss door PPU updates
	LDA iEndOfLevelDoorPage, X
	AND #%00000001
	ASL A
	ASL A
	EOR #%00000100
	LDX zScrollCondition
	BNE loc_BANK2_87E7

	ASL A

loc_BANK2_87E7:
	LDX EndOfLevelDoorRowOffsets, Y
	ORA wHawkDoorBuffer, X
	STA wHawkDoorBuffer, X
	LDX z12
	DEY
	BPL loc_BANK2_87D9

	LDA #$14
	STA zScreenUpdateIndex
	LDY iEndOfLevelDoorPage, X
	LDA #$5F
	STA z01
	LDA #$10
	STA z00

loc_BANK2_8804:
	LDA z00
	CLC
	ADC #$F0
	STA z00
	LDA z01
	ADC #$00
	STA z01
	DEY
	BPL loc_BANK2_8804

	LDA zObjectType, X
	CMP #Enemy_Clawgrip
	BNE DrawEndOfLevelDoorTiles

	; Clawgrip special hack:
	; Move the "Draw the door" PPU command
	; up 8 tile rows ($100) to be on the platform
	LDA z00
	SEC
	SBC #$40
	STA z00
	LDA z01
	SBC #$00
	STA z01

DrawEndOfLevelDoorTiles:
	LDY #$B8
	LDA #BackgroundTile_LightDoorEndLevel
	STA (z00), Y
	LDY #$C8
	STA (z00), Y
	LDA #BackgroundTile_LightTrailRight
	LDY #$B9
	STA (z00), Y
	LDY #$CA
	STA (z00), Y
	LDA #BackgroundTile_LightTrail
	LDY #$C9
	STA (z00), Y
	RTS

; ---------------------------------------------------------------------------

loc_BANK2_8842:
	LDA zObjectType, X
	CMP #Enemy_FryguySplit
	BNE loc_BANK2_8855

	DEC iFryguySplitFlames
	BPL loc_BANK2_8855

	INC iLocalBossArray, X
	INC zObjectType, X
	JMP loc_BANK2_8509

; ---------------------------------------------------------------------------

loc_BANK2_8855:
	JMP EnemyDestroy

; ---------------------------------------------------------------------------

HandleEnemyState_Sand:
	JSR sub_BANK2_88E8

	LDA #$12
	STA zObjectAttributes, X
	LDA zSpriteTimer, X
	BEQ loc_BANK2_8888

	LDA #$F8
	STA zObjectYVelocity, X
	JSR ApplyObjectPhysicsY

	LDA #$B2
	LDY zSpriteTimer, X
	CPY #$10
	BCS loc_BANK2_8885

	LDA #%10000000
	STA i46e, X
	LDA #$01
	STA zObjectAttributes, X
	ASL A
	STA zEnemyTrajectory, X
	INC zObjectAnimTimer, X
	JSR IncrementAnimationTimerBy2

	LDA #$B4

loc_BANK2_8885:
	JMP RenderSprite_DrawObject

; ---------------------------------------------------------------------------

loc_BANK2_8888:
	CPX iHeldItemIndex
	BNE loc_BANK2_8891

	LDA #$00
	STA zHeldItem

loc_BANK2_8891:
	JMP EnemyDestroy

; =============== S U B R O U T I N E =======================================

sub_BANK2_8894:
	LDA #$00
	STA zee
	LDA zObjectAttributes, X
	LDY #$01
	AND #ObjAttrib_Horizontal
	BNE loc_BANK2_88B9

	LDA zObjectType, X
	CMP #Enemy_Pokey
	BEQ loc_BANK2_88B9

	CMP #Enemy_Ostro
	BEQ loc_BANK2_88B9

	CMP #Enemy_HawkmouthBoss
	BEQ loc_BANK2_88B9

	CMP #Enemy_Clawgrip
	BEQ loc_BANK2_88B9

	LDA i46e, X
	AND #%00100000
	BEQ loc_BANK2_88BB

loc_BANK2_88B9:
	; something for double-wide sprites?
	LDY #$03

; seems to be logic for positioning sprites onscreen
loc_BANK2_88BB:
	LDA zObjectXLo, X
	CLC
	ADC byte_BANK2_88E4, Y
	STA z0e
	LDA zObjectXHi, X
	ADC #$00
	STA z0f
	LDA z0e
	CMP iBoundLeftLower
	LDA z0f
	SBC iBoundLeftUpper
	BEQ loc_BANK2_88DC

	LDA zee
	ORA byte_BANK2_88E0, Y
	STA zee

loc_BANK2_88DC:
	DEY
	BPL loc_BANK2_88BB

locret_BANK2_88DF:
	RTS

; End of function sub_BANK2_8894

; ---------------------------------------------------------------------------
; threshold for x-wrapping sprites near the edge of the screen
byte_BANK2_88E0: ; hi
	.db $08
	.db $04
	.db $02
	.db $01
byte_BANK2_88E4: ; lo
	.db $00
	.db $08
	.db $10
	.db $18

; =============== S U B R O U T I N E =======================================

sub_BANK2_88E8:
	JSR sub_BANK2_8894

	LDA #$22
	LDY zObjectType, X
	CPY #Enemy_Wart
	BEQ loc_BANK2_88F9

	CPY #Enemy_Tryclyde
	BEQ loc_BANK2_88F9

	LDA #$10

loc_BANK2_88F9:
	ADC zObjectYLo, X
	STA z00
	LDA zObjectYHi, X
	ADC #$00
	STA z01
	LDA z00
	CMP zScreenY
	LDA z01
	SBC zScreenYPage
	STA zef

	CPY #Enemy_Phanto
	BEQ locret_BANK2_88DF

	CPY #Enemy_FlyingCarpet
	BEQ locret_BANK2_88DF

	CPY #Enemy_HawkmouthLeft
	BEQ locret_BANK2_88DF

	CPY #Enemy_HawkmouthBoss
	BEQ locret_BANK2_88DF

	TXA
	AND #$01
	STA z00
	LDA z10
	AND #$01
	EOR z00
	BNE locret_BANK2_88DF

	LDA zScreenY
	SBC #$30
	STA z01
	LDA zScreenYPage
	SBC #$00
	STA z00
	INC z00
	LDA zScreenY
	ADC #$FF
	PHP
	ADC #$30
	STA z03
	LDA zScreenYPage
	ADC #$00
	PLP
	ADC #$00
	STA z02
	INC z02
	LDA zObjectYLo, X
	CMP z01
	LDY zObjectYHi, X
	INY
	TYA
	SBC z00
	BMI loc_BANK2_89A5

	LDA zObjectYLo, X
	CMP z03
	LDY zObjectYHi, X
	INY
	TYA
	SBC z02
	BPL loc_BANK2_89A5

	LDA iBoundLeftLower
	SBC #$30
	STA z01
	LDA iBoundLeftUpper
	SBC #$00
	STA z00
	INC z00
	LDA iBoundRightLower
	ADC #$30
	STA z03
	LDA iBoundRightUpper
	ADC #$00
	STA z02
	INC z02
	LDA zObjectXLo, X
	CMP z01
	LDY zObjectXHi, X
	INY
	TYA
	SBC z00
	BMI loc_BANK2_899C

	LDA zObjectXLo, X
	CMP z03
	LDY zObjectXHi, X
	INY
	TYA
	SBC z02
	BMI EnemyDestroy_Exit

loc_BANK2_899C:
	LDY zObjectType, X
	LDA EnemyArray_46E_Data, Y
	AND #$08
	BNE EnemyDestroy_Exit

loc_BANK2_89A5:
	LDA zHeldObjectTimer, X
	BNE EnemyDestroy_Exit

; End of function sub_BANK2_88E8

; =============== S U B R O U T I N E =======================================

EnemyDestroy:
	; load raw enemy data offset so we can allow the level object to respawn
	LDY iEnemyRawDataOffset, X
	; nothing to reset if offset is invalid
	BMI EnemyDestroy_AfterAllowRespawn

	; disabling bit 7 allows the object to respawn
	LDA (zRawSpriteData), Y
	AND #$7F
	STA (zRawSpriteData), Y

EnemyDestroy_AfterAllowRespawn:
	LDA #EnemyState_Inactive
	STA zEnemyState, X

EnemyDestroy_Exit:
	RTS

; End of function EnemyDestroy

; ---------------------------------------------------------------------------

HandleEnemyState_Alive:
	LDA #$01
	STA iObjectNonSticky, X
	LDY iObjectBulletTimer, X
	DEY
	CPY #$1F
	BCS loc_BANK2_89C9

	INC iObjectBulletTimer, X

loc_BANK2_89C9:
	JSR sub_BANK2_88E8

	LDA zPlayerState
	CMP #PlayerState_ChangingSize
	BEQ loc_BANK2_89E2

	LDA zScrollArray
	AND #%00000100
	BNE loc_BANK2_8A07

	LDA iWatchTimer
	BNE loc_BANK2_89E2
IFDEF SIXTEEN_BIT_WATCH_TIMER
	LDA iWatchTimer + 1
	BNE loc_BANK2_89E2
ENDIF

	LDA iObjectStunTimer, X
	BEQ loc_BANK2_8A0A

loc_BANK2_89E2:
	LDA zObjectType, X

IFDEF REV_A
	CMP #Enemy_FryguySplit
	BEQ loc_BANK2_8A0A
ENDIF

	CMP #Enemy_Heart
	BEQ loc_BANK2_8A0A

	CMP #Enemy_FlyingCarpet
	BEQ loc_BANK2_89F0

	CMP #Enemy_VegetableSmall
	BCS loc_BANK2_8A0A

loc_BANK2_89F0:
	JSR EnemyBehavior_CheckDamagedInterrupt

	LDA iObjectBulletTimer, X
	BEQ loc_BANK2_89FB

	JSR ApplyObjectMovement

loc_BANK2_89FB:
	LDA zHeldObjectTimer, X
	BEQ loc_BANK2_8A04

	DEC zObjectAnimTimer, X

loc_BANK2_8A01:
	JMP CarryObject

; ---------------------------------------------------------------------------

loc_BANK2_8A04:
	JSR CheckObjectCollision

loc_BANK2_8A07:
	JMP RenderSprite

; ---------------------------------------------------------------------------

loc_BANK2_8A0A:
	LDY #$01
	LDA zObjectXVelocity, X
	BEQ loc_BANK2_8A15

	BPL loc_BANK2_8A13

	INY

loc_BANK2_8A13:
	STY zEnemyTrajectory, X

loc_BANK2_8A15:
	LDY zObjectType, X
	LDA ObjectAttributeTable, Y
	AND #ObjAttrib_Palette0 | ObjAttrib_BehindBackground
	BNE loc_BANK2_8A41

	LDA zObjectAttributes, X
	AND #ObjAttrib_Palette | ObjAttrib_Horizontal | ObjAttrib_FrontFacing | ObjAttrib_Mirrored | ObjAttrib_16x32 | ObjAttrib_UpsideDown
	STA zObjectAttributes, X
	LDA zHeldObjectTimer, X
	CMP #$02
	BCC loc_BANK2_8A41

	LDA zObjectType, X
	CMP #Enemy_BobOmb
	BNE loc_BANK2_8A36

	LDA zEnemyCollision, X
	AND #CollisionFlags_Down
	BNE loc_BANK2_8A3B

loc_BANK2_8A36:
	LDA ObjectAttributeTable, Y
	BPL loc_BANK2_8A41

loc_BANK2_8A3B:
	LDA zObjectAttributes, X
	ORA #ObjAttrib_BehindBackground
	STA zObjectAttributes, X

loc_BANK2_8A41:
	JSR RunEnemyBehavior

	LDA zObjectYHi, X
	BMI loc_BANK2_8A50

	LDA iSpriteTempScreenY
	CMP #$E8
	BCC loc_BANK2_8A50

	RTS

; ---------------------------------------------------------------------------

loc_BANK2_8A50:
	JMP CheckObjectCollision

; ---------------------------------------------------------------------------

RunEnemyBehavior:
	LDA zObjectType, X
	JSR JumpToTableAfterJump


EnemyBehaviorPointerTable:
	.dw EnemyBehavior_00 ; $00
	.dw EnemyBehavior_BasicWalker ; $01
	.dw EnemyBehavior_BasicWalker ; $02
	.dw EnemyBehavior_BasicWalker ; $03
	.dw EnemyBehavior_BasicWalker ; $04
	.dw EnemyBehavior_BasicWalker ; $05
	.dw EnemyBehavior_BasicWalker ; $06
	.dw EnemyBehavior_BasicWalker ; $07
	.dw EnemyBehavior_Ostro ; $08
	.dw EnemyBehavior_BobOmb ; $09
	.dw EnemyBehavior_Albatoss ; $0A
	.dw EnemyBehavior_Albatoss ; $0B
	.dw EnemyBehavior_Albatoss ; $0C
	.dw EnemyBehavior_NinjiRunning ; $0D
	.dw EnemyBehavior_NinjiJumping ; $0E
	.dw EnemyBehavior_Beezo ; $0F
	.dw EnemyBehavior_Beezo ; $10
	.dw EnemyBehavior_WartBubble ; $11
	.dw EnemyBehavior_Pidgit ; $12
	.dw EnemyBehavior_Trouter ; $13
	.dw EnemyBehavior_Hoopstar ; $14
	.dw EnemyBehavior_JarGenerators ; $15
	.dw EnemyBehavior_JarGenerators ; $16
	.dw EnemyBehavior_Phanto ; $17
	.dw EnemyBehavior_CobratJar ; $18
	.dw EnemyBehavior_CobratGround ; $19
	.dw EnemyBehavior_Pokey ; $1A
	.dw EnemyBehavior_BulletAndEgg ; $1B
	.dw EnemyBehavior_Birdo ; $1C
	.dw EnemyBehavior_Mouser ; $1D
	.dw EnemyBehavior_BulletAndEgg ; $1E
	.dw EnemyBehavior_Tryclyde ; $1F
	.dw EnemyBehavior_Fireball ; $20
	.dw EnemyBehavior_Clawgrip ; $21
	.dw EnemyBehavior_ClawgripRock ; $22
	.dw EnemyBehavior_PanserRedAndGray ; $23
	.dw EnemyBehavior_PanserPink ; $24
	.dw EnemyBehavior_PanserRedAndGray ; $25
	.dw EnemyBehavior_Autobomb ; $26
	.dw EnemyBehavior_AutobombFire ; $27
	.dw EnemyBehavior_WhaleSpout ; $28
	.dw EnemyBehavior_Flurry ; $29
	.dw EnemyBehavior_Fryguy ; $2A
	.dw EnemyBehavior_FryguySplit ; $2B
	.dw EnemyBehavior_Wart ; $2C
	.dw EnemyBehavior_HawkmouthBoss ; $2D
	.dw EnemyBehavior_Spark ; $2E
	.dw EnemyBehavior_Spark ; $2F
	.dw EnemyBehavior_Spark ; $30
	.dw EnemyBehavior_Spark ; $31
	.dw EnemyBehavior_Vegetable ; $32
	.dw EnemyBehavior_Vegetable ; $33
	.dw EnemyBehavior_Vegetable ; $34
	.dw EnemyBehavior_Shell ; $35
	.dw EnemyBehavior_Coin ; $36
	.dw EnemyBehavior_Bomb ; $37
	.dw EnemyBehavior_Rocket ; $38
	.dw EnemyBehavior_MushroomBlockAndPOW ; $39
	.dw EnemyBehavior_MushroomBlockAndPOW ; $3A
	.dw EnemyBehavior_FallingLogs ; $3B
	.dw EnemyBehavior_SubspaceDoor ; $3C
	.dw EnemyBehavior_Key ; $3D
	.dw EnemyBehavior_SubspacePotion ; $3E
	.dw EnemyBehavior_Mushroom ; $3F
	.dw EnemyBehavior_Mushroom1up ; $40
	.dw EnemyBehavior_FlyingCarpet ; $41
	.dw EnemyBehavior_Hawkmouth ; $42
	.dw EnemyBehavior_Hawkmouth ; $43
	.dw EnemyBehavior_CrystalBall ; $44
	.dw EnemyBehavior_Starman ; $45
	.dw EnemyBehavior_Mushroom ; $46
EnemyBehaviorPointerTable_End:


EnemyInit_JarGenerators:
	JSR EnemyInit_Basic

	LDA #$50
	STA zObjectAnimTimer, X
	RTS


SparkAccelerationTable:
	.db $F0
	.db $E0
	.db $F0
	.db $E0
	.db $10
	.db $20


EnemyInit_Sparks:
	JSR EnemyInit_Basic

	LDY zObjectType, X
	LDA SparkAccelerationTable - Enemy_Spark1, Y
	STA zObjectXVelocity, X
	LDA SparkAccelerationTable - Enemy_Spark1 + 2, Y
	STA zObjectYVelocity, X
	RTS


SparkCollision: ; spark movement based on collision
	.db CollisionFlags_Up | CollisionFlags_Down ; horizontal
	.db CollisionFlags_Left | CollisionFlags_Right ; vertical

SparkTurnOffset:
	.db $00 ; clockwise
	.db $0A ; counter-clockwise


;
; Spark movement works by traveling along one axis at a time and turning when
; either colliding along the movement axis or running out of wall along the
; axis perpendicular to movement.
;
EnemyBehavior_Spark:
	JSR EnemyBehavior_CheckDamagedInterrupt

	JSR IncrementAnimationTimerBy2

	JSR RenderSprite

	LDA zObjectXLo, X
	ORA zObjectYLo, X
	AND #$0F
	BNE EnemyBehavior_Spark_Move

	JSR ObjectTileCollision_SolidBackground

	LDY i477, X
	LDA zEnemyCollision, X
	AND SparkCollision, Y
	BEQ EnemyBehavior_Spark_Turn

	LDA SparkCollision, Y
	EOR #$0F
	AND zEnemyCollision, X
	BEQ EnemyBehavior_Spark_Move

	TYA
	EOR #$01
	STA i477, X
	TAY

;
; Reverses the direction of movement for the specified axis
;
; Input
;   X = enemy slot
;   Y = movement axis
;
EnemyBehavior_Spark_FlipAxisVelocity:
	TXA
	CLC
	ADC SparkTurnOffset, Y
	TAY
	LDA zObjectXVelocity, Y
	EOR #$FF
	ADC #$01
	STA zObjectXVelocity, Y
	RTS


EnemyBehavior_Spark_Turn:
	TYA
	EOR #$01
	STA i477, X
	JSR EnemyBehavior_Spark_FlipAxisVelocity

EnemyBehavior_Spark_Move:
	LDA i477, X
	BNE EnemyBehavior_Spark_MoveVertical

EnemyBehavior_Spark_MoveHorizontal:
	JMP ApplyObjectPhysicsX

EnemyBehavior_Spark_MoveVertical:
	JMP ApplyObjectPhysicsY


IncrementAnimationTimerBy2:
	INC zObjectAnimTimer, X
	INC zObjectAnimTimer, X
	RTS


AlbatossSwarmStartXLo:
	.db $F0
	.db $00

AlbatossSwarmStartXHi:
	.db $FF
	.db $01


Swarm_AlbatossCarryingBobOmb:
	JSR Swarm_CreateEnemy

	ADC AlbatossSwarmStartXLo, Y
	STA zObjectXLo, X
	LDA iBoundLeftUpper
	ADC AlbatossSwarmStartXHi, Y
	STA zObjectXHi, X
	STY z01
	LDA #Enemy_AlbatossCarryingBobOmb
	STA zObjectType, X
	JSR SetEnemyAttributes

	LDA iPRNGValue
	AND #$1F
	ADC #$20
	STA zObjectYLo, X
	LDY z01
	JSR EnemyInit_BasicMovement

	ASL zObjectXVelocity, X
	RTS


BeezoSwarmStartXLo:
	.db $00
	.db $FF


Swarm_BeezoDiving:
	JSR Swarm_CreateEnemy

	ADC BeezoSwarmStartXLo, Y
	STA zObjectXLo, X
	LDA zScrollCondition
	BEQ Swarm_BeezoDiving_Vertical

Swarm_BeezoDiving_Horizontal:
	LDA iBoundLeftUpper
	ADC #$00

Swarm_BeezoDiving_Vertical:
	STA zObjectXHi, X
	LDA zScreenY
	STA zObjectYLo, X
	LDA zScreenYPage
	STA zObjectYHi, X
	STY z01
	LDA #Enemy_BeezoDiving
	STA zObjectType, X
	JSR SetEnemyAttributes

	LDY z01
	JSR EnemyInit_BasicMovement

	JMP EnemyBeezoDiveSetup


;
; Generates a swarm enemy
;
; Output
;   A = iBoundLeftLower
;   X = enemy slot (z00)
;   Y = enemy direction
;
Swarm_CreateEnemy:
	; Pause for the Stopwatch
	LDA iWatchTimer
	BNE Swarm_CreateEnemy_Fail
IFDEF SIXTEEN_BIT_WATCH_TIMER
	LDA iWatchTimer + 1
	BNE Swarm_CreateEnemy_Fail
ENDIF

	; Generate an enemy when the counter overflows
	LDA iSwarmTimer
	CLC
	ADC #$03
	STA iSwarmTimer
	BCC Swarm_CreateEnemy_Fail

	; Create the enemy, but bail if it's not possible
	JSR CreateEnemy

	BMI Swarm_CreateEnemy_Fail

	; Pick a direction
	LDY #$00
	LDA z10
	AND #$40
	BNE Swarm_CreateEnemy_Exit

	INY

Swarm_CreateEnemy_Exit:
	LDX z00
	LDA iBoundLeftLower
	RTS

Swarm_CreateEnemy_Fail:
	; Break out of the parent swarm subroutine
	PLA
	PLA
	RTS


EnemyBehavior_Fireball:
	JSR ObjectTileCollision

	JSR sub_BANK2_927A

	JSR EnemyBehavior_CheckDamagedInterrupt

	JSR RenderSprite

	LDA zObjectVariables, X
	BNE EnemyBehavior_Fireball_CheckCollision

	JMP ApplyObjectMovement


EnemyBehavior_Fireball_CheckCollision:
	LDA zEnemyCollision, X
	AND #CollisionFlags_Right | CollisionFlags_Left
	BEQ EnemyBehavior_Fireball_Exit

	JSR TurnIntoPuffOfSmoke

EnemyBehavior_Fireball_Exit:
	JMP sub_BANK2_9430


PanserFireXVelocity:
	.db $10
	.db $F0


EnemyBehavior_PanserPink:
	LDA zObjectAnimTimer, X
	ASL A
	BNE EnemyBehavior_PanserRedAndGray

	JSR EnemyInit_BasicMovementTowardPlayer

EnemyBehavior_PanserRedAndGray:
	JSR ObjectTileCollision

	LDA zEnemyCollision, X
	PHA
	AND #CollisionFlags_Down
	BEQ loc_BANK2_8C1A

	JSR ResetObjectYVelocity

loc_BANK2_8C1A:
	PLA
	AND #CollisionFlags_Right | CollisionFlags_Left
	BEQ loc_BANK2_8C22

	JSR EnemyBehavior_TurnAround

loc_BANK2_8C22:
	JSR ApplyObjectMovement

	LDA #%10000011
	STA i46e, X
	LDA #$02
	STA zEnemyTrajectory, X
	JSR EnemyBehavior_CheckDamagedInterrupt

	INC zObjectAnimTimer, X
	LDA zObjectAnimTimer, X
	AND #$2F
	BNE loc_BANK2_8C3D

	LDA #$10
	STA zSpriteTimer, X

loc_BANK2_8C3D:
	LDY zSpriteTimer, X
	BEQ loc_BANK2_8C8E

	CPY #$06
	BNE loc_BANK2_8C7C

	JSR CreateEnemy

	BMI loc_BANK2_8C7C

	LDA zObjectType, X
	PHA
	LDX z00
	LDA iPRNGValue
	AND #$0F
	ORA #$BC
	STA zObjectYVelocity, X
	JSR EnemyFindWhichSidePlayerIsOn

	PLA
	CMP #Enemy_PanserStationaryFiresUp
	LDA PanserFireXVelocity, Y
	BCC loc_BANK2_8C65

	LDA #$00

loc_BANK2_8C65:
	STA zObjectXVelocity, X
	LDA zObjectXLo, X
	SBC #$05
	STA zObjectXLo, X
	LDA zObjectXHi, X
	SBC #$00
	STA zObjectXHi, X
	LDA #DPCM_Fire
	STA iDPCMSFX
	LDA #Enemy_Fireball
	STA zObjectType, X
	JSR SetEnemyAttributes

	LDX z12

loc_BANK2_8C7C:
	LDA zObjectAttributes, X
	ORA #$10
	STA zObjectAttributes, X
	LDA #$AE
	JSR RenderSprite_DrawObject

	LDA zObjectAttributes, X
	AND #$EF
	STA zObjectAttributes, X
	RTS

; ---------------------------------------------------------------------------

loc_BANK2_8C8E:
	JMP RenderSprite

; ---------------------------------------------------------------------------

EnemyInit_Key:
	LDY #$05

loc_BANK2_8C93:
	LDA zEnemyState, Y
	BEQ loc_BANK2_8CA3

loc_BANK2_8C98:
	CPY z12
	BEQ loc_BANK2_8CA3

	LDA zObjectType, Y
	CMP #Enemy_Key
	BEQ loc_BANK2_8CAE

loc_BANK2_8CA3:
	DEY
	BPL loc_BANK2_8C93

	LDA iKeyUsed
	BNE loc_BANK2_8CAE

loc_BANK2_8CAB:
	JMP EnemyInit_Stationary

; ---------------------------------------------------------------------------

loc_BANK2_8CAE:
	JMP EnemyDestroy

; ---------------------------------------------------------------------------

EnemyInit_CrystalBallStarmanStopwatch:
	LDY #$05

loc_BANK2_8CB3:
	LDA zEnemyState, Y
	BEQ loc_BANK2_8CC3

	CPY z12
	BEQ loc_BANK2_8CC3

	LDA zObjectType, Y
	CMP #Enemy_CrystalBall
	BEQ loc_BANK2_8CAE

loc_BANK2_8CC3:
	DEY
	BPL loc_BANK2_8CB3

	LDA iMaskDoorOpenFlag
	BNE loc_BANK2_8CAE

	BEQ loc_BANK2_8CAB

	JSR CreateEnemy

	BMI locret_BANK2_8CF7

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
	JSR SetEnemyAttributes

	LDX z12

locret_BANK2_8CF7:
	RTS

; ---------------------------------------------------------------------------

EnemyBehavior_Starman:
	LDA #$FC
	STA zObjectYVelocity, X
	LDY #$F8
	LDA z10
	STA iObjectFlashTimer, X
	BPL loc_BANK2_8D07

	LDY #$08

loc_BANK2_8D07:
	STY zObjectXVelocity, X
	JMP RenderSpriteAndApplyObjectMovement

; ---------------------------------------------------------------------------

EnemyBehavior_JarGenerators:
	JSR ObjectTileCollision

	AND #$03
	BNE EnemyBehavior_JarGenerators_Active

	JMP EnemyDestroy

EnemyBehavior_JarGenerators_Active:
	INC zObjectAnimTimer, X
	LDA zObjectAnimTimer, X
	ASL A
	BNE locret_BANK2_8D5E

	JSR CreateEnemy

	BMI locret_BANK2_8D5E

	LDY z00
	LDA zObjectXLo, Y
	SEC
	SBC #$06
	STA zObjectXLo, Y
	LDA zObjectYLo, Y
	SBC #$04
	STA zObjectYLo, Y
	LDA zObjectYHi, Y
	SBC #$00
	STA zObjectYHi, Y
	LDA #$1A
	STA i480, Y
	LDA #$F8
	STA zObjectYVelocity, Y
	LDA zObjectType, X
	CMP #Enemy_JarGeneratorBobOmb
	BNE locret_BANK2_8D5E

	LDA #Enemy_BobOmb
	STA zObjectType, Y
	LDA zObjectXVelocity, Y
	ASL A
	STA zObjectXVelocity, Y
	LDA #$FF
	STA zSpriteTimer, Y

locret_BANK2_8D5E:
	RTS


EnemyInit_Hawkmouth:
	DEC zObjectYLo, X
	DEC zObjectYLo, X
	LDY #$01
	STY wColBoxTop + $0B
	INY
	STY wColBoxLeft + $0B


EnemyInit_Stationary:
	JSR EnemyInit_Basic

	LDA #$00
	STA zObjectXVelocity, X
	RTS


EnemyBehavior_Hawkmouth:
	LDA zee
	BEQ loc_BANK2_8D7B

loc_BANK2_8D78:
	JMP RenderSprite_HawkmouthLeft

; ---------------------------------------------------------------------------

loc_BANK2_8D7B:
	LDA iMaskPreamble
	BEQ loc_BANK2_8D8A

	DEC iMaskPreamble
	BNE loc_BANK2_8D78

	LDA #SoundEffect2_HawkUp
	STA iPulse1SFX

loc_BANK2_8D8A:
	LDA iMaskClosingFlag
	BEQ loc_BANK2_8DBA

	DEC iMaskDoorOpenFlag
	BNE loc_BANK2_8D78

	LDA #$00
	STA iMaskClosingFlag
	LDA #TransitionType_Door
	STA iTransitionType
	JSR DoAreaReset

	LDY iCurrentLvlRelative
	LDA iCurrentWorldTileset
	CMP #$06
	BNE loc_BANK2_8DAC

	INY

loc_BANK2_8DAC:
	CPY #$02
	BCC SetGameModeBonusChance

	INC iAreaTransitionID
	RTS

; ---------------------------------------------------------------------------

SetGameModeBonusChance:
	LDA #GameMode_BonusChance
	STA iGameMode
	RTS

; ---------------------------------------------------------------------------

loc_BANK2_8DBA:
	LDA iMaskDoorOpenFlag
	BEQ RenderSprite_HawkmouthLeft

	CMP #$30
	BEQ loc_BANK2_8DDB

	LDA zee
	AND #$04
	BNE RenderSprite_HawkmouthLeft

	INC iMaskDoorOpenFlag
	LDA z10
	AND #$03
	BNE loc_BANK2_8DD8

	DEC wColBoxTop + $0B
	INC wColBoxLeft + $0B

loc_BANK2_8DD8:
	JMP RenderSprite_HawkmouthLeft

; ---------------------------------------------------------------------------

loc_BANK2_8DDB:
	LDA zEnemyCollision, X
	AND #CollisionFlags_PlayerInsideMaybe
	BEQ RenderSprite_HawkmouthLeft

	LDA zObjectYLo, X
	CMP zPlayerYLo
	BCS RenderSprite_HawkmouthLeft

	LDA zPlayerCollision
	AND #CollisionFlags_Down
	BEQ RenderSprite_HawkmouthLeft

	LDA zHeldItem
	BNE RenderSprite_HawkmouthLeft

	LDA #PlayerState_HawkmouthEating
	STA zPlayerState
	LDA #$30
	STA zPlayerStateTimer
	LDA #$FC
	STA zPlayerYVelocity
	LDA #SoundEffect2_HawkDown
	STA iPulse1SFX
	INC iMaskClosingFlag

RenderSprite_HawkmouthLeft:
	LDA zef
	BNE loc_BANK2_8E60

	LDA zObjectType, X
	SEC
	SBC #$41
	STA zEnemyTrajectory, X
	LDA iMaskDoorOpenFlag

; =============== S U B R O U T I N E =======================================

sub_BANK2_8E13:
	STA z07
	LSR A
	LSR A
	EOR #$FF
	SEC
	ADC iSpriteTempScreenY
	STA iSpriteTempScreenY
	LDY iDoorAnimTimer
	BEQ loc_BANK2_8E27

	LDY #$10

loc_BANK2_8E27:
	STY zf4
	LDA #$8E
	LDY z07
	BEQ loc_BANK2_8E31

	LDA #$92

loc_BANK2_8E31:
	JSR RenderSprite_DrawObject

	LDA z07
	TAY
	LSR A
	CLC
	ADC iSpriteTempScreenY
	ADC #$08
	CPY #$00
	BNE loc_BANK2_8E44

	ADC #$07

loc_BANK2_8E44:
	STA z00
	JSR FindSpriteSlot

	LDX #$9A
	LDA z07
	BEQ loc_BANK2_8E58

	LDA iMaskClosingFlag
	BEQ loc_BANK2_8E56

	LDY #$10

loc_BANK2_8E56:
	LDX #$96

loc_BANK2_8E58:
	STY zf4
	JSR SetSpriteTiles

	JSR SetSpriteTiles

loc_BANK2_8E60:
	LDX z12
	RTS

; End of function sub_BANK2_8E13

; ---------------------------------------------------------------------------

EnemyInit_Trouter:
	JSR EnemyInit_Stationary

	LDA zObjectXLo, X
	ADC #$08
	STA zObjectXLo, X
	LDA zObjectYLo, X
	LSR A
	LSR A
	LSR A
	LSR A
	STA zEnemyArray, X
	LDA #$80
	STA zSpriteTimer, X

locret_BANK2_8E78:
	RTS


byte_BANK2_8E79:
	.db $AC
	.db $AE
	.db $B1
	.db $B5
	.db $B8
	.db $BC
	.db $C0
	.db $C4
	.db $C8
	.db $CC
	.db $D2
	.db $D8

byte_BANK2_8E85:
	.db $92
	.db $EA


EnemyBehavior_Trouter:
	JSR EnemyBehavior_CheckDamagedInterrupt

	INC zObjectAnimTimer, X
	JSR EnemyBehavior_Check42FPhysicsInterrupt

	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

	LDA #$09
	LDY zObjectYVelocity, X
	BMI loc_BANK2_8E9A

	LDA #$89

loc_BANK2_8E9A:
	STA zObjectAttributes, X
	LDY zScrollCondition
	LDA zObjectYLo, X
	CMP byte_BANK2_8E85, Y
	BCC loc_BANK2_8EB6

	LDY zSpriteTimer, X
	BNE locret_BANK2_8E78

	STA zObjectYLo, X
	LDY zEnemyArray, X
	LDA byte_BANK2_8E79, Y
	STA zObjectYVelocity, X
	LDA #$C0
	STA zSpriteTimer, X

loc_BANK2_8EB6:
	JSR sub_BANK2_9430

	INC zObjectYVelocity, X
	JMP RenderSprite


Enemy_Hoopstar_YVelocity:
	.db $FA ; up
	.db $0C ; down

Enemy_Hoopstar_Attributes:
	.db $91 ; up
	.db $11 ; down


EnemyBehavior_Hoopstar:
	JSR EnemyBehavior_CheckDamagedInterrupt

	INC zObjectAnimTimer, X
	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

	JSR RenderSprite

	JSR EnemyBehavior_Check42FPhysicsInterrupt

	LDA #$00
	STA zObjectXVelocity, X

	JSR EnemyBehavior_Hoopstar_Climb

	LDY i477, X
	BCC loc_BANK2_8EEC

	LDA zObjectYLo, X
	CMP zScreenY
	LDA zObjectYHi, X
	SBC zScreenYPage
	BEQ loc_BANK2_8EF3

	ASL A
	ROL A
	AND #$01
	BPL loc_BANK2_8EEF

loc_BANK2_8EEC:
	TYA
	EOR #$01

loc_BANK2_8EEF:
	STA i477, X
	TAY

loc_BANK2_8EF3:
	LDA Enemy_Hoopstar_YVelocity, Y
	STA zObjectYVelocity, X
	LDA Enemy_Hoopstar_Attributes, Y
	STA zObjectAttributes, X
	JSR EnemyFindWhichSidePlayerIsOn

	LDA z0f
	ADC #$10
	CMP #$20
	BCS loc_BANK2_8F0A

	ASL zObjectYVelocity, X

loc_BANK2_8F0A:
	JMP ApplyObjectPhysicsY

; ---------------------------------------------------------------------------

EnemyBehavior_00:
	LDA zef
	BEQ loc_BANK2_8F14

	JMP EnemyDestroy

; ---------------------------------------------------------------------------

loc_BANK2_8F14:
	LDY #$FC
	LDA z10
	AND #$20
	BEQ loc_BANK2_8F1E

	LDY #$04

loc_BANK2_8F1E:
	STY zObjectXVelocity, X
	LDA #$F8
	STA zObjectYVelocity, X
	JSR sub_BANK2_9430

RenderSprite_Heart:
	LDA zee
	AND #$08
	ORA zef
	BNE RenderSprite_Heart_Exit

	; This part of the code seems to only run
	; if the graph we're trying to draw is
	; a heart sprite ...
	LDY zf4
	LDA iSpriteTempScreenY
	STA iVirtualOAM, Y
	LDA iSpriteTempScreenX
	STA iVirtualOAM + 3, Y
SetHeartSprite:
	LDA #$D8
	STA iVirtualOAM + 1, Y
	LDA z10
	AND #$20
	EOR #$20
	ASL A
	ORA #$01
	STA iVirtualOAM + 2, Y

RenderSprite_Heart_Exit:
	RTS


Enemy_Birdo_Attributes:
	.db ObjAttrib_Palette3 | ObjAttrib_16x32
	.db ObjAttrib_Palette1 | ObjAttrib_16x32
	.db ObjAttrib_Palette2 | ObjAttrib_16x32


;
; Initializes a Birdo (and a few other boss enemies, such as Mouser and Clawgrip)
;
EnemyInit_Birdo:
	JSR EnemyInit_Basic

	LDY #$00 ; Default to the Gray Birdo (fires only fireballs)
	LDA zObjectXLo, X ; Check if this is a special Birdo.
	CMP #$A0 ; means this is a Pink Birdo (fires only eggs, slowly)
	BEQ EnemyInit_Birdo_SetType

	INY
	CMP #$B0 ; tile x-position on page = $B
	BEQ EnemyInit_Birdo_SetType ; If yes, this is a Red Birdo (fires eggs and fireballs)

	INY

EnemyInit_Birdo_SetType:
	STY zObjectVariables, X ; Set the Birdo type
	LDA Enemy_Birdo_Attributes, Y
	STA zObjectAttributes, X
	LDA #$02
	STA iEnemyHP, X

EnemyInit_Birdo_Exit:
	LDA zObjectXHi, X
	STA iEndOfLevelDoorPage, X
	RTS


ProjectileLaunchXOffsets:
	.db $FE
	.db $F8


EnemyBehavior_Birdo:
	JSR EnemyBehavior_CheckDamagedInterrupt

	JSR ObjectTileCollision

	LDA #$00
	STA zObjectXVelocity, X
	JSR EnemyFindWhichSidePlayerIsOn

	INY
	STY zEnemyTrajectory, X
	JSR RenderSprite

	LDA zEnemyCollision, X
	AND #CollisionFlags_Down
	BEQ loc_BANK2_8FD2

	JSR ResetObjectYVelocity

	LDA z10
	BNE loc_BANK2_8FA3

	LDA #$E0
	STA zObjectYVelocity, X
	BNE loc_BANK2_8FD2


BirdoSpitDelay:
	.db $7F
	.db $3F
	.db $3F


; Health-based Birdo egg/fire chances.
; If PRNG & $1F >= this, shoot an egg
; Otherwise, shoot a fireball
BirdoHealthEggProbabilities:
	.db $08
	.db $06
	.db $04


loc_BANK2_8FA3:
	LDY zObjectVariables, X
	LDA BirdoSpitDelay, Y
	AND z10
	BNE loc_BANK2_8FB6

	LDA zee
	AND #$0C
	BNE loc_BANK2_8FB6

	LDA #$1C
	STA zSpriteTimer, X

loc_BANK2_8FB6:
	LDY zSpriteTimer, X
	BNE BirdoBehavior_SpitProjectile

	INC zEnemyArray, X
	LDA zEnemyArray, X
	AND #$40
	BEQ loc_BANK2_901B

	JSR IncrementAnimationTimerBy2

	LDA #$0A
	LDY zEnemyArray, X
	BMI loc_BANK2_8FCD

	LDA #$F6

loc_BANK2_8FCD:
	STA zObjectXVelocity, X
	JMP ApplyObjectPhysicsX

; ---------------------------------------------------------------------------

loc_BANK2_8FD2:
	JMP ApplyObjectMovement_Vertical

; ---------------------------------------------------------------------------

BirdoBehavior_SpitProjectile:
	CPY #$08
	BNE loc_BANK2_901B

	LDA #DPCM_Egg
	STA iDPCMSFX
	JSR sub_BANK2_95E5

	BMI loc_BANK2_901B

	LDY iEnemyHP, X
	LDA zObjectVariables, X
	LDX z00
	CMP #$02 ; If we're a Gray Birdo, always shoot fire
	BEQ _Birdo_SpitFire

	CMP #$01 ; If we're a Pink Birdo, always shoot eggs
	BNE _Birdo_SpitEgg

	LDA iPRNGValue ; Otherwise, randomly determine what to fire
	AND #$1F ; If PRNG & $1F >= our health-probability number,
	CMP BirdoHealthEggProbabilities, Y ; fire an egg out
	BCS _Birdo_SpitEgg ; Otherwise just fall through to barfing fire

_Birdo_SpitFire:
	INC zObjectVariables, X ; Shoot a fireball
	LDA #Enemy_Fireball
	BNE EnemyBehavior_SpitProjectile

_Birdo_SpitEgg:
	LDA #Enemy_Egg ; Shoot an egg


;
; Spits an object (used by Birdo and Autobomb)
;
; Input
;   A = Object type
;   X = Enemy index
;
EnemyBehavior_SpitProjectile:
	STA zObjectType, X
	LDA zObjectYLo, X
	CLC
	ADC #$03
	STA zObjectYLo, X
	LDY zEnemyTrajectory, X
	LDA zObjectXLo, X
	ADC ProjectileLaunchXOffsets - 1, Y
	STA zObjectXLo, X
	JSR SetEnemyAttributes

	LDX z12

loc_BANK2_901B:
	JMP RenderSprite


; Unused?
	.db $18
	.db $E8

; Maps upper nybble of y-velocity to a corresponding bounce velocity
ObjectBounceVelocityY:
	.db $FE
	.db $F8
	.db $F0
	.db $E8


EnemyBehavior_Coin:
	JSR IncrementAnimationTimerBy2

	LDA zObjectYVelocity, X
	CMP #$EA
	BNE EnemyBehavior_Mushroom1up

	LDA #SoundEffect2_CoinGet
	STA iPulse1SFX

EnemyBehavior_Mushroom1up:
	LDA zObjectYVelocity, X
	CMP #$10
	BMI EnemyBehavior_Mushroom

	JSR TurnIntoPuffOfSmoke

	LDA zObjectType, X
	CMP #Enemy_Mushroom1up
	BEQ Award1upMushroom

	INC iTotalCoins
	RTS

; ---------------------------------------------------------------------------

Award1upMushroom:
IFNDEF STATS_TESTING_PURPOSES
	INC iLifeUpEventFlag
ENDIF
	INC iExtraMen
	BNE loc_BANK2_9050 ; Check if lives overflow. If so, reduce by one again

	DEC iExtraMen

loc_BANK2_9050:
	LDA #SoundEffect2_1UP
	STA iPulse1SFX
	RTS

; ---------------------------------------------------------------------------

EnemyBehavior_CrystalBall:
	INC iSpriteTempScreenY
	JSR AttachObjectToBirdo

;
; Behavior for objects that turn into smoke after you pick them up
; (eg. mushrooms, crystal ball, stopwatch)
;
EnemyBehavior_Mushroom:
	LDA zHeldObjectTimer, X
	CMP #$01
	BNE EnemyBehavior_Mushroom_StayMaterial

	LDA zPlayerHitBoxHeight
	BEQ EnemyBehavior_Mushroom_PickUp

EnemyBehavior_Mushroom_StayMaterial:
	JMP EnemyBehavior_Bomb

EnemyBehavior_Mushroom_PickUp:
	JSR CarryObject

	LDA #$00
	STA zHeldItem
	STA zHeldObjectTimer, X
	JSR TurnIntoPuffOfSmoke

	LDA zObjectType, X
	CMP #Enemy_CrystalBall
	BNE EnemyBehavior_PickUpNotCrystalBall

	LDA iMaskDoorOpenFlag
	BNE EnemyBehavior_CrystalBall_Exit

	LDA #Music_CrystalGetFanfare
	STA iMusic
	LDA #$60
	STA iMaskPreamble
	INC iMaskDoorOpenFlag

EnemyBehavior_CrystalBall_Exit:
	RTS

EnemyBehavior_PickUpNotCrystalBall:
	CMP #Enemy_Mushroom1up
	BEQ EnemyBehavior_PickUpMushroom1up

	CMP #Enemy_Stopwatch
	BEQ EnemyBehavior_PickUpStopwatch

	CMP #Enemy_Mushroom
	BNE EnemyBehavior_PickUpNotMushroom

EnemyBehavior_PickUpMushroom:
	LDX zObjectVariables
	INC iMushroomFlags, X
	LDX z12
	INC iPlayerMaxHP
	JSR RestorePlayerToFullHealth

	LDA #Music_MushroomGetJingle
	STA iMusic
	RTS

EnemyBehavior_PickUpMushroom1up:
	LDA #$09
	STA zObjectAttributes, X

EnemyBehavior_PickUpNotMushroom:
	LDA #$E0
	STA zObjectYVelocity, X
	LDA #$01
	STA zEnemyState, X
	RTS

EnemyBehavior_PickUpStopwatch:
	LDA #$FF
	STA iWatchTimer
IFDEF SIXTEEN_BIT_WATCH_TIMER
	INC iWatchTimer + 1
ENDIF
	RTS


EnemyBehavior_Key:
	JSR AttachObjectToBirdo

;
; Behavior for objects that have background collision detection
;
EnemyBehavior_Bomb:
	JSR ObjectTileCollision

	LDA zEnemyCollision, X
	PHA
	AND zEnemyTrajectory, X
	BEQ EnemyBehavior_CheckGround

	JSR EnemyBehavior_TurnAround

	JSR HalfObjectVelocityX
	JSR HalfObjectVelocityX
	JSR HalfObjectVelocityX

EnemyBehavior_CheckGround:
	PLA
	AND #CollisionFlags_Down
	BEQ EnemyBehavior_CheckBombTimer

	; object is touching ground
	LDA zObjectYVelocity, X
	CMP #$09
	BCC EnemyBehavior_Grounded

	; object is falling faster than $08
	LSR A
	LSR A
	LSR A
	LSR A
	TAY
	LDA ObjectBounceVelocityY, Y
	JSR ApplyVelocityYAndHalfObjectVelocityX

	JMP EnemyBehavior_CheckBombTimer

EnemyBehavior_Grounded:
	JSR ResetObjectYVelocity

	LDA z0b
	BNE EnemyBehavior_CheckBombTimer

	STA zObjectXVelocity, X

EnemyBehavior_CheckBombTimer:
	LDA zObjectType, X
	CMP #Enemy_Bomb
	BNE EnemyBehavior_Vegetable

	LDA zSpriteTimer, X
	BNE EnemyBehavior_BombTick

	LDY zHeldObjectTimer, X
	BEQ EnemyBehavior_Bomb_Explode

	STA zHeldItem
	STA zHeldObjectTimer, X

EnemyBehavior_Bomb_Explode:
	LDA #EnemyState_BombExploding
	STA zEnemyState, X
	LDA #$20
	STA zSpriteTimer, X
	STA iSkyFlashTimer
	LDA #SoundEffect3_Bomb
	STA iNoiseSFX
	LSR A
	; A = $00
	STA iObjectBulletTimer, X
	RTS


EnemyBehavior_BombTick:
	CMP #$40
	BCS EnemyBehavior_Vegetable

	; bomb flashing
	LSR A
	BCC EnemyBehavior_Vegetable

	INC zObjectAttributes, X
	LDA zObjectAttributes, X
	AND #$FB
	STA zObjectAttributes, X

EnemyBehavior_Vegetable:
	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

	JSR ApplyObjectMovement

RenderSprite_VegetableLarge:
	LDA zEnemyArray, X
	BNE loc_BANK2_913E

	JMP RenderSprite_NotAlbatoss

; ---------------------------------------------------------------------------

loc_BANK2_913E:
	JMP RenderSprite_DrawObject

; ---------------------------------------------------------------------------

EnemyBehavior_SubspacePotion:
	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

	JSR ObjectTileCollision

	LDA zEnemyCollision, X
	PHA
	AND #CollisionFlags_Right | CollisionFlags_Left
	BEQ EnemyBehavior_SubspacePotion_CheckGroundCollision

	JSR EnemyBehavior_TurnAround

	JSR HalfObjectVelocityX
	JSR HalfObjectVelocityX

EnemyBehavior_SubspacePotion_CheckGroundCollision:
	PLA
	AND #CollisionFlags_Down
	BEQ EnemyBehavior_Vegetable

	JSR ResetObjectYVelocity

	LDA zObjectYLo, X
	SEC
	SBC #$10
	STA zObjectYLo, X
	LDA zObjectXLo, X
	ADC #$07
	AND #$F0
	STA zObjectXLo, X
	LDA zObjectXHi, X
	ADC #$00
	STA zObjectXHi, X
	LDA #$10
	STA iSpriteTimer, X
	LDA #Hill_LampBossDeath
	STA iHillSFX
	INC zEnemyArray, X
	LDA #Enemy_SubspaceDoor
	STA zObjectType, X
	JSR SetEnemyAttributes

	LDA #$10
	STA i5bb

	; No Subspace Doors allowed in vertical levels
	LDA zScrollCondition
	BNE EnemyBehavior_SubspacePotion_CreateDoor

	; subspace door fail
	LDA #DPCM_BossHurt
	STA iDPCMSFX
	JSR EnemyDestroy

EnemyBehavior_SubspacePotion_CreateDoor:
	JSR CreateEnemy

	BMI TurnIntoPuffOfSmoke_Exit

	LDY z00
	LDA zObjectXLo, X
	STA zObjectXLo, Y
	LDA zObjectXHi, X
	STA zObjectXHi, Y
	LDA #$41
	STA zObjectAttributes, Y
	TYA
	TAX


;
; Turns an object into a puff of smoke
;
; Input
;   X = enemy index of object to poof
;
TurnIntoPuffOfSmoke:
	LDA zObjectAttributes, X ; Get current object sprite attributes...
	AND #ObjAttrib_Horizontal | ObjAttrib_FrontFacing | ObjAttrib_Mirrored | ObjAttrib_BehindBackground | ObjAttrib_16x32 | ObjAttrib_UpsideDown
	ORA #ObjAttrib_Palette1
	STA zObjectAttributes, X
	LDA #EnemyState_PuffOfSmoke
	STA zEnemyState, X ; WINNERS DON'T SMOKE SHROOMS
	STA zObjectAnimTimer, X ; No idea what this address is for
	LDA #$1F
	STA zSpriteTimer, X ; Puff-of-smoke animation timer?
	LDX z12

TurnIntoPuffOfSmoke_Exit:
	RTS


byte_BANK2_91C5:
	.db $F8
	.db $08


;
; Look for a Birdo to attach to
;
AttachObjectToBirdo:
	LDA zObjectVariables, X
	BNE AttachObjectToBirdo_Skip

	LDY #$05
AttachObjectToBirdo_Loop:
	LDA zEnemyState, Y
	CMP #EnemyState_Alive
	BNE AttachObjectToBirdo_NotLiveBirdo

	LDA zObjectType, Y
	CMP #Enemy_Birdo
	BEQ AttachObjectToBirdo_DoAttach

AttachObjectToBirdo_NotLiveBirdo:
	DEY
	BPL AttachObjectToBirdo_Loop

AttachObjectToBirdo_Skip:
	LDA #$01
	STA zObjectVariables, X
	JMP SetEnemyAttributes

AttachObjectToBirdo_DoAttach:
	LDA zObjectXHi, Y
	CMP zObjectXHi, X
	BNE AttachObjectToBirdo_Skip

	LDA zObjectXLo, Y
	STA zObjectXLo, X
	LDA zObjectYLo, Y
	ADC #$0E
	STA zObjectYLo, X
	JSR EnemyFindWhichSidePlayerIsOn

	LDA byte_BANK2_91C5, Y
	STA zObjectXVelocity, X
	LDA #$E0
	STA zObjectYVelocity, X
	PLA
	PLA
	LDA #%00000111
	STA i46e, X
	LDA #$30
	STA zf4
	JMP RenderSprite



byte_BANK2_9212:
	.db $F0

byte_BANK2_9213:
	.db $FF
	.db $00
; ---------------------------------------------------------------------------

EnemyInit_AlbatossStartLeft:
	JSR EnemyInit_Basic

	LDA #$F0
	BNE loc_BANK2_9221

EnemyInit_AlbatossStartRight:
	JSR EnemyInit_Basic

	LDA #$10

loc_BANK2_9221:
	STA zObjectXVelocity, X
	INC zEnemyArray, X
	LDA zObjectType, X
	SEC

loc_BANK2_9228:
	SBC #$0B
	TAY
	LDA iBoundLeftLower
	ADC byte_BANK2_9212, Y
	STA zObjectXLo, X
	LDA iBoundLeftUpper
	ADC byte_BANK2_9213, Y
	STA zObjectXHi, X
	RTS

; ---------------------------------------------------------------------------

EnemyBehavior_Albatoss:
	JSR RenderSprite_Albatoss

	INC zObjectAnimTimer, X
	LDA zEnemyArray, X
	BNE loc_BANK2_9271

	LDA zEnemyCollision, X
	AND #CollisionFlags_Damage
	BNE loc_BANK2_9256

	JSR EnemyFindWhichSidePlayerIsOn

	LDA z0f
	ADC #$30
	CMP #$60
	BCS loc_BANK2_926E

loc_BANK2_9256:
	JSR CreateEnemy

	BMI loc_BANK2_926E

	LDX z00
	LDA #Enemy_BobOmb
	STA zObjectType, X
	LDA zObjectYLo, X
	ADC #$10
	STA zObjectYLo, X
	JSR EnemyInit_Bobomb

	LDX z12
	INC zEnemyArray, X

loc_BANK2_926E:
	JMP loc_BANK2_9274

; ---------------------------------------------------------------------------

loc_BANK2_9271:
	JSR EnemyBehavior_CheckDamagedInterrupt

loc_BANK2_9274:
	JMP ApplyObjectPhysicsX

; ---------------------------------------------------------------------------

EnemyBehavior_AutobombFire:
	JSR sub_BANK2_9289

sub_BANK2_927A:
	ASL zObjectAttributes, X
	LDA z10
	LSR A
	LSR A
	LSR A
	ROR zObjectAttributes, X
	RTS


; Unused?
	.db $D0
	.db $03


EnemyBehavior_BulletAndEgg:
	JSR ObjectTileCollision

sub_BANK2_9289:
	JSR EnemyBehavior_CheckDamagedInterrupt

	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

	LDA zEnemyArray, X
	ORA iObjectBulletTimer, X
	BEQ loc_BANK2_9299

	JMP RenderSpriteAndApplyObjectMovement

; ---------------------------------------------------------------------------

loc_BANK2_9299:
	LDA zObjectYVelocity, X
	BPL loc_BANK2_929F

	STA zEnemyArray, X

loc_BANK2_929F:
	LDA zEnemyCollision, X
	AND #CollisionFlags_Right | CollisionFlags_Left
	BEQ loc_BANK2_92BE

	STA zEnemyArray, X
	LDA zObjectType, X
	CMP #Enemy_Bullet
	BNE loc_BANK2_92B5

	LDA #EnemyState_Dead
	STA zEnemyState, X
	INC zObjectYLo, X
	INC zObjectYLo, X

loc_BANK2_92B5:
	JSR EnemyBehavior_TurnAround

	JSR HalfObjectVelocityX

	JSR HalfObjectVelocityX

loc_BANK2_92BE:
	JSR ApplyObjectPhysicsX

	JMP RenderSprite

; End of function sub_BANK2_9289


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
CreateEnemy_TryAllSlots:
	LDY #$08
	BNE CreateEnemy_FindSlot

CreateEnemy:
	LDY #$05

CreateEnemy_FindSlot:
	LDA zEnemyState, Y
	BEQ CreateEnemy_FoundSlot

	DEY
	BPL CreateEnemy_FindSlot

	RTS

CreateEnemy_FoundSlot:
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

	JSR EnemyInit_Basic
	JSR UnlinkEnemyFromRawData

	LDX z12
	RTS


Phanto_AccelX:
	.db $01
	.db $FF
Phanto_MaxVelX:
	.db $30
	.db $D0
Phanto_AccelY:
	.db $01
	.db $FF ; Exit up
	.db $01 ; Exit down
Phanto_MaxVelY:
	.db $18
	.db $E8
	.db $18

EnemyBehavior_Phanto:
	LDA iObjectShakeTimer, X
	BEQ Phanto_AfterDecrementShakeTimer

	DEC iObjectShakeTimer, X

Phanto_AfterDecrementShakeTimer:
	JSR RenderSprite

	LDY #$01 ; Move away from player
	LDA zHeldItem
	BEQ Phanto_Movement

	LDX iHeldItemIndex
	LDA zObjectType, X
	LDX z12

	; Strange code. Phanto only chases you if you have the key.
	; So you should just be able to use BEQ/BNE.
	; This way seems to imply that Phanto would
	; chase you if you were carrying a range of items,
	; but...  what could those items have been?
	; But instead we do it like this for... reasons.
	; Nintendo.
	CMP #Enemy_Key
	BCC Phanto_Movement

	; Subspace Potion is >= Enemy_Key, so ignore it
	CMP #Enemy_SubspacePotion
	BCS Phanto_Movement

	LDA iPhantoTimer
	CMP #$A0
	BNE Phanto_AfterStartTimer

	; Kick off Phanto activation timer
	DEC iPhantoTimer

Phanto_AfterStartTimer:
	DEY ; Move toward player

Phanto_Movement:
	LDA zObjectYHi, X
	CLC
	ADC #$01
	STA z05
	LDA zPlayerYLo
	CMP zObjectYLo, X
	LDX zPlayerYHi
	INX
	TXA
	LDX z12
	SBC z05
	BPL loc_BANK2_9351

	INY ; Other side of player vertically

loc_BANK2_9351:
	LDA zObjectYVelocity, X
	CMP Phanto_MaxVelY, Y
	BEQ loc_BANK2_935E

	CLC
	ADC Phanto_AccelY, Y
	STA zObjectYVelocity, X

loc_BANK2_935E:
	LDA i480, X
	CLC
	ADC #$A0
	STA i480, X
	BCC loc_BANK2_937F

	LDA i477, X
	AND #$01
	TAY
	LDA zObjectXVelocity, X
	CLC
	ADC Phanto_AccelX, Y
	STA zObjectXVelocity, X
	CMP Phanto_MaxVelX, Y
	BNE loc_BANK2_937F

	INC i477, X

loc_BANK2_937F:
	LDA zScrollCondition
	BEQ loc_BANK2_9388

	LDA zPlayerXVelocity
	STA iObjectXVelocity, X

loc_BANK2_9388:
	LDY iPhantoTimer
	BEQ Phanto_Activated

	; Hold the timer at $A0
	CPY #$A0
	BEQ Phanto_AfterDecrementActivateTimer

	CPY #$80
	BNE Phanto_AfterFlashing

	; Start flashing
	LDA #$40
	STA iObjectFlashTimer, X

Phanto_AfterFlashing:
	CPY #$40
	BNE Phanto_AfterSound

	; Start vibrating
	LDA #$40
	STA iObjectShakeTimer, X

	; Play Phanto activation sound effect
	LDA #DPCM_Phanto
	STA iDPCMSFX

Phanto_AfterSound:
	DEC iPhantoTimer

Phanto_AfterDecrementActivateTimer:
	LDA #$00
	STA iObjectXVelocity, X
	STA zObjectXVelocity, X
	STA zObjectYVelocity, X

Phanto_Activated:
	JMP sub_BANK2_9430


Enemy_Ninji_JumpVelocity:
	.db $E8
	.db $D0
	.db $D8
	.db $D0


EnemyBehavior_NinjiJumping:
	LDA zEnemyCollision, X
	AND #CollisionFlags_Down
	BEQ EnemyBehavior_Ninji_MidAir

	LDA iObjectBulletTimer, X
	BNE EnemyBehavior_NinjiJumping_DetermineJump

	; stop x-velocity
	STA zObjectXVelocity, X

EnemyBehavior_NinjiJumping_DetermineJump:
	TXA
	ASL A
	ASL A
	ASL A
	ADC z10
	AND #$3F
	BNE EnemyBehavior_Ninji_MidAir

	LDA zObjectAnimTimer, X
	AND #$C0
	ASL A
	ROL A
	ROL A
	TAY
	LDA Enemy_Ninji_JumpVelocity, Y
	BNE EnemyBehavior_Ninji_Jump

EnemyBehavior_NinjiRunning:
	LDA zEnemyCollision, X
	AND #CollisionFlags_Down
	BEQ EnemyBehavior_Ninji_MidAir

	LDA zPlayerYLo
	CLC
	ADC #$10
	CMP zObjectYLo, X
	BNE EnemyBehavior_Ninji_MidAir

	JSR EnemyFindWhichSidePlayerIsOn

	INY
	TYA
	CMP zEnemyTrajectory, X
	BNE EnemyBehavior_Ninji_MidAir

	LDA z0f
	ADC #$28
	CMP #$50
	BCS EnemyBehavior_Ninji_MidAir

	LDA #$D8

EnemyBehavior_Ninji_Jump:
	STA zObjectYVelocity, X
	LDA zObjectAnimTimer, X
	AND #$F0
	STA zObjectAnimTimer, X
	JSR ApplyObjectPhysicsY

EnemyBehavior_Ninji_MidAir:
	JMP EnemyBehavior_BasicWalker

; ---------------------------------------------------------------------------

EnemyBehavior_Beezo:
	JSR EnemyBehavior_CheckDamagedInterrupt

	JSR RenderSprite

	INC zObjectAnimTimer, X
	JSR EnemyBehavior_Check42FPhysicsInterrupt

	JSR IncrementAnimationTimerBy2

loc_BANK2_941D:
	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

	LDA zObjectYVelocity, X
	BEQ loc_BANK2_9436

	BPL loc_BANK2_9429

	STA iObjectBulletTimer, X

loc_BANK2_9429:
	LDA z10
	LSR A
	BCC sub_BANK2_9430

	DEC zObjectYVelocity, X

; =============== S U B R O U T I N E =======================================

sub_BANK2_9430:
	JSR ApplyObjectPhysicsX

	JMP ApplyObjectPhysicsY

; End of function sub_BANK2_9430

; ---------------------------------------------------------------------------

loc_BANK2_9436:
	JSR ApplyObjectPhysicsX

loc_BANK2_9439:
	JMP sub_BANK2_9430


BulletProjectileXSpeeds:
	.db $20
	.db $E0


EnemyBehavior_BobOmb:
	LDY zSpriteTimer, X
	CPY #$3A ; When to stop walking
	BCS EnemyBehavior_BasicWalker

	; Stop walking if the BobOmb is touching the ground
	LDA zEnemyCollision, X
	AND #CollisionFlags_Down
	BEQ EnemyBehavior_BobOmb_CheckFuse

	LDA #$00
	STA zObjectXVelocity, X

EnemyBehavior_BobOmb_CheckFuse:
	DEC zObjectAnimTimer, X
	TYA
	BNE EnemyBehavior_BobOmb_Flash

	; Unset zHeldItem if this BobOmb is being carried
	LDA zHeldObjectTimer, X
	BEQ EnemyBehavior_BobOmb_Explode

	STY zHeldItem
	STY zHeldObjectTimer, X

EnemyBehavior_BobOmb_Explode:
	JMP EnemyBehavior_Bomb_Explode


EnemyBehavior_BobOmb_Flash:
	CMP #$30 ; When to start flashing
	BCS EnemyBehavior_BasicWalker

	; Palette cycle every other frame
	LSR A
	BCC EnemyBehavior_BasicWalker

	INC zObjectAttributes, X
	LDA zObjectAttributes, X
	AND #%11111011
	STA zObjectAttributes, X


EnemyBehavior_BasicWalker:
	JSR ObjectTileCollision

loc_BANK2_9470:
	JSR EnemyBehavior_CheckDamagedInterrupt

	LDA i480, X
	BEQ loc_BANK2_9492

	LDA zEnemyCollision, X
	AND #CollisionFlags_Up
	BEQ loc_BANK2_9481

	JMP EnemyDestroy

; ---------------------------------------------------------------------------

loc_BANK2_9481:
	DEC i480, X
	INC zSpriteTimer, X

; =============== S U B R O U T I N E =======================================

sub_BANK2_9486:
	LDA zObjectAttributes, X
	ORA #ObjAttrib_BehindBackground
	STA zObjectAttributes, X
	JSR ApplyObjectPhysicsY

	JMP RenderSprite

; End of function sub_BANK2_9486

; ---------------------------------------------------------------------------

; Object collision with background tiles
loc_BANK2_9492:
	LDA zEnemyCollision, X
	AND zEnemyTrajectory, X
	BEQ loc_BANK2_94A6

	JSR EnemyBehavior_TurnAround

	LDA iObjectBulletTimer, X
	BEQ loc_BANK2_94A6

	JSR HalfObjectVelocityX

	JSR HalfObjectVelocityX

loc_BANK2_94A6:
	INC zObjectAnimTimer, X
	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

loc_BANK2_94AB:
	JSR RenderSprite

	LDA zObjectType, X
	CMP #Enemy_SnifitGray
	BNE loc_BANK2_94BB

	LDA iObjectBulletTimer, X
	BNE loc_BANK2_94BB

	STA zObjectXVelocity, X

loc_BANK2_94BB:
	JSR ApplyObjectMovement

	LDA zEnemyCollision, X
	LDY zObjectYVelocity, X
	BPL loc_BANK2_9503

	AND #$08
	BEQ loc_BANK2_94CD

	LDA #$00
	STA zObjectYVelocity, X
	RTS

; ---------------------------------------------------------------------------

loc_BANK2_94CD:
	LDA iObjectBulletTimer, X
	BNE EnemyBehavior_Walk

	; check if this enemy fires bullets when jumping
	LDA zObjectType, X
	CMP #Enemy_SnifitGray
	BNE EnemyBehavior_Walk

	; bullet generator
	LDA zObjectYVelocity, X ; check if enemy is starting to fall
	CMP #$FE
	BNE EnemyBehavior_Walk

	LDA iPRNGValue ; check random number generator
	BPL EnemyBehavior_Walk

	; jumper high bullet
	JSR CreateBullet

EnemyBehavior_Walk:
	DEC zObjectAnimTimer, X
	LDA zObjectType, X
	CMP #Enemy_SnifitPink
	BEQ EnemyBehavior_TurnAtCliff

	CMP #Enemy_ShyguyPink
	BNE EnemyBehavior_BasicWalkerExit

EnemyBehavior_TurnAtCliff:
	; skip if being thrown
	LDA iObjectBulletTimer, X
	BNE EnemyBehavior_BasicWalkerExit

	; skip if already turning around
	LDA i477, X
	BNE EnemyBehavior_BasicWalkerExit

	INC i477, X
	JMP EnemyBehavior_TurnAround

EnemyBehavior_BasicWalkerExit:
	RTS

; ---------------------------------------------------------------------------

loc_BANK2_9503:
	AND #$04
	BEQ loc_BANK2_94CD

	LDA #$00
	STA i477, X
	LDY zObjectType, X ; Get the current object ID
	CPY #Enemy_Tweeter ; Check if this enemy is a Tweeter
	BNE loc_BANK2_9528 ; If not, go handle some other enemies

	; ...but very, very, very rarely, only
	; when their timer (that increments once per bounce)
	; hits #$3F -- almost unnoticable
	LDA #$3F
	JSR sub_BANK2_9599

	INC zObjectVariables, X ; Make small jump 3 times, then make big jump
	LDY #$F0
	LDA zObjectVariables, X
	AND #$03 ; Check if the timer is a multiple of 4
	BNE loc_BANK2_9523 ; If not, skip over the next bit

	LDY #$E0

loc_BANK2_9523:
	STY zObjectYVelocity, X ; Set Y acceleration for bouncing
	JMP ApplyObjectPhysicsY

; ---------------------------------------------------------------------------

loc_BANK2_9528:
	LDA #$1F
	CPY #Enemy_BobOmb
	BEQ sub_BANK2_9599

	CPY #Enemy_Flurry
	BEQ sub_BANK2_9599

	LDA #$3F
	CPY #Enemy_NinjiRunning
	BEQ sub_BANK2_9599

	; this redundant red snifit check smells funny, almost like there was
	; some other follow-the-player enemy
	LDA #$7F ; unused
	CPY #Enemy_SnifitRed
	BEQ EnemyBehavior_Snifit

	CPY #Enemy_SnifitRed
	BEQ EnemyBehavior_Snifit

	CPY #Enemy_SnifitPink
	BEQ EnemyBehavior_Snifit

	CPY #Enemy_SnifitGray
	BNE loc_BANK2_959D

	LDA iObjectBulletTimer, X
	BNE loc_BANK2_959D

	JSR EnemyFindWhichSidePlayerIsOn

	INY
	STY zEnemyTrajectory, X
	LDA zObjectAnimTimer, X
	AND #$3F
	BNE EnemyBehavior_Snifit

	LDA #$E8
	STA zObjectYVelocity, X
	JMP ApplyObjectPhysicsY


EnemyBehavior_Snifit:
	LDA iObjectShakeTimer, X
	BEQ EnemyBehavior_Snifit_NoBullet

	DEC zObjectAnimTimer, X
	DEC iObjectShakeTimer, X
	BNE EnemyBehavior_Snifit_NoBullet

	; telegraphed bullet (walking snifits)
	JSR CreateBullet

	JMP loc_BANK2_95BB

EnemyBehavior_Snifit_NoBullet:
loc_BANK2_9574:
	TXA
	ASL A
	ASL A
	ASL A
	ADC z10
	ASL A
	BNE EnemyBehavior_Snifit_AnimationTimer

	LDA zObjectType, X
	CMP #Enemy_SnifitGray
	BNE EnemyBehavior_Snifit_CheckPlayerY

	; jumper low bullet
	JSR CreateBullet

	JMP EnemyInit_DisableObjectAttributeBit8


EnemyBehavior_Snifit_CheckPlayerY:
	LDA zObjectYLo, X
	SEC
	SBC #$10
	CMP zPlayerYLo
	BNE EnemyBehavior_Snifit_AnimationTimer

	LDA #$30 ; shake duration
	STA iObjectShakeTimer, X

EnemyBehavior_Snifit_AnimationTimer:
	LDA #$7F

;
; Gives em the ol' razzle-dazzle
;
; Input
;   A = timer mask
;
sub_BANK2_9599:
	AND zObjectAnimTimer, X
	BEQ loc_BANK2_95B8

loc_BANK2_959D:
	LDA iObjectBulletTimer, X
	BEQ loc_BANK2_95BB

	LDA zObjectYVelocity, X
	CMP #$1A
	BCC loc_BANK2_95B8

	LDA #$F0

;
; Sets the y-velocity, applies vertical physics, and cuts x-velocity in half
;
; Input
;   A = y-velocity
;   X = enemy index
;
ApplyVelocityYAndHalfObjectVelocityX:
	JSR SetzObjectYVelocity
	JSR ApplyObjectPhysicsY

;
; Cuts the x-velocity of the current object in half
;
; Input
;   X = enemy index
; Output
;   RAM_0 = previous x-velocity
;
HalfObjectVelocityX:
	; Store the current X-velocity in RAM_0
	LDA zObjectXVelocity, X
	STA z00
	; Shift left to save the sign in the carry bit
	ASL A
	; Cut in half and preserve the sign
	ROR zObjectXVelocity, X
	RTS


; ---------------------------------------------------------------------------

loc_BANK2_95B8:
	JSR EnemyInit_BasicWithoutTimer

loc_BANK2_95BB:
	LDA zObjectType, X
	CMP #Enemy_ShyguyRed
	BNE EnemyInit_DisableObjectAttributeBit8

	LDA zObjectYVelocity, X
	CMP #$04
	BCC EnemyInit_DisableObjectAttributeBit8

	JSR EnemyInit_BasicWithoutTimer

;
; Disables bit 8 on the object attribute, which causes the object to appear
; behind the background while being pulled
;
EnemyInit_DisableObjectAttributeBit8:
	ASL zObjectAttributes, X
	LSR zObjectAttributes, X

;
; Does SetzObjectYVelocity with y-velocity of 0
;
ResetObjectYVelocity:
	LDA #$00

;
; Sets the y-velocity of an object and shifts it half a tile down if it's not a
; a vegetable
;
; Input
;   A = y-velocity
;   X = enemy index
;
SetzObjectYVelocity:
	STA zObjectYVelocity, X
	LDA zObjectType, X
	CMP #Enemy_VegetableSmall
	LDA zObjectYLo, X
	BCS SetzObjectYVelocity_Exit

	ADC #$08
	BCC SetzObjectYVelocity_Exit

	INC zObjectYHi, X

SetzObjectYVelocity_Exit:
	AND #$F0
	STA zObjectYLo, X
	RTS


; =============== S U B R O U T I N E =======================================

sub_BANK2_95E5:
	JSR CreateEnemy_TryAllSlots

	JMP CreateBullet_WithSlotInY

; End of function sub_BANK2_95E5

; =============== S U B R O U T I N E =======================================

CreateBullet:
	JSR CreateEnemy

CreateBullet_WithSlotInY:
	BMI CreateBullet_Exit

	LDY zEnemyTrajectory, X
	LDX z00
	LDA BulletProjectileXSpeeds - 1, Y
	STA zObjectXVelocity, X
	LDA #$00
	STA zObjectYVelocity, X
	LDA #Enemy_Bullet
	STA zObjectType, X
	JSR SetEnemyAttributes

	LDX z12

CreateBullet_Exit:
	RTS


CharacterYOffsetCrouch:
	.db $0A ; Mario
	.db $0E ; Princess
	.db $0A ; Toad
	.db $0D ; Luigi
	.db $04 ; Small Mario
	.db $07 ; Small Princess
	.db $04 ; Small Toad
	.db $06 ; Small Luigi


; This is run when the player is carrying
; something, to update its position to
; wherever the player is above their head
CarryObject:
	LDA zPlayerFacing
	EOR #$01
	TAY
	INY
	STY zEnemyTrajectory, X
	LDA zPlayerXLo
	STA zObjectXLo, X
	LDA zPlayerXHi
	STA zObjectXHi, X

	LDA zPlayerYHi
	STA z07
	LDA zPlayerYLo
	LDY iObjectHitbox, X
	CPY #$03
	BEQ loc_BANK2_9636

	CPY #$02
	BEQ loc_BANK2_9636

	SBC #$0E
	BCS loc_BANK2_9636

	DEC z07

loc_BANK2_9636:
	LDY zPlayerAnimFrame
	CPY #SpriteAnimation_Ducking
	CLC
	BNE loc_BANK2_964D

	LDY iCurrentPlayerSize
	CPY #$01
	LDY zCurrentCharacter
	BCC loc_BANK2_964A

	INY
	INY
	INY
	INY

loc_BANK2_964A:
	ADC CharacterYOffsetCrouch, Y

loc_BANK2_964D:
	PHP
	LDY zHeldObjectTimer, X
	CLC
	LDX iCurrentPlayerSize
	BEQ loc_BANK2_965D

	INY
	INY
	INY
	INY
	INY
	INY
	INY

loc_BANK2_965D:
	ADC wHeldItemYOffsets - 1, Y
	LDX z12
	STA zObjectYLo, X
	LDA z07
	ADC wHeldItemYOffsets + $D, Y
	PLP
	ADC #$00
	STA zObjectYHi, X
	LDY zHeldObjectTimer, X
	CPY #$05
	BCS loc_BANK2_9686

	LDA zObjectType, X
	CMP #Enemy_VegetableSmall
	BCS loc_BANK2_9686

	LDA iObjectStunTimer, X
	BNE loc_BANK2_9681

	INC zObjectAnimTimer, X

loc_BANK2_9681:
	ASL zObjectAttributes, X
	SEC
	ROR zObjectAttributes, X

loc_BANK2_9686:
	JSR SetSpriteTempScreenPosition

	JMP RenderSprite


; Unused?
	.db $10
	.db $F0


EnemyBehavior_MushroomBlockAndPOW:
	JSR sub_BANK2_9692

EnemyBehavior_MushroomBlockAndPOW_Exit:
	RTS

; =============== S U B R O U T I N E =======================================

sub_BANK2_9692:
	LDA zHeldObjectTimer, X
	BEQ loc_BANK2_969B

	PLA
	PLA
	JMP CarryObject

; ---------------------------------------------------------------------------

loc_BANK2_969B:
	JSR RenderSprite

	LDA zObjectType, X
	CMP #Enemy_POWBlock
	BCS loc_BANK2_96AA

	JSR ObjectTileCollision_SolidBackground

	JMP loc_BANK2_96AD

; ---------------------------------------------------------------------------

loc_BANK2_96AA:
	JSR ObjectTileCollision

loc_BANK2_96AD:
	LDA iObjectBulletTimer, X
	BEQ EnemyBehavior_MushroomBlockAndPOW_Exit

	JSR ApplyObjectMovement

	PLA
	PLA
	LDA zEnemyCollision, X
	PHA
	AND #CollisionFlags_Right | CollisionFlags_Left
	BEQ loc_BANK2_96D4

	LDA #$00
	STA zObjectXVelocity, X
	LDA zObjectXLo, X
	ADC #$08
	AND #$F0
	STA zObjectXLo, X
	LDA zScrollCondition
	BEQ loc_BANK2_96D4

	LDA zObjectXHi, X
	ADC #$00
	STA zObjectXHi, X

loc_BANK2_96D4:
	PLA
	LDY zObjectYVelocity, X
	BMI locret_BANK2_9718

	AND #CollisionFlags_Down
	BEQ locret_BANK2_9718

	LDA z0e
	CMP #$16
	BNE loc_BANK2_96EC

	LDA zObjectXVelocity, X
	BEQ loc_BANK2_96EC

	LDA #$14
	JMP SetzObjectYVelocity

; ---------------------------------------------------------------------------

loc_BANK2_96EC:
	LDA zObjectType, X
	CMP #Enemy_POWBlock
	BNE loc_BANK2_96FF

	LDA #$20
	STA iPOWTimer
	LDA #SoundEffect3_POW
	STA iNoiseSFX
	JMP sub_BANK2_98C4

; ---------------------------------------------------------------------------

loc_BANK2_96FF:
	LDA zObjectYVelocity, X
	CMP #$16
	BCC loc_BANK2_970D

	JSR ResetObjectYVelocity

	LDA #$F5
	JMP ApplyVelocityYAndHalfObjectVelocityX

; ---------------------------------------------------------------------------

loc_BANK2_970D:
	JSR ResetObjectYVelocity

	LDA zObjectVariables, X
	JSR ReplaceTile

	JMP EnemyDestroy

; ---------------------------------------------------------------------------

locret_BANK2_9718:
	RTS

; End of function sub_BANK2_9692

; ---------------------------------------------------------------------------

EnemyBehavior_SubspaceDoor:
	LDA #$04
	STA iObjectHitbox, X
	LDA #$02
	STA zEnemyTrajectory, X
	LDY iSubTimeLeft
	BEQ loc_BANK2_9741

	LDA z10
	AND #$03
	BNE loc_BANK2_9741

	LDY zPlayerState
	CPY #PlayerState_Dying
	BEQ loc_BANK2_9741

	DEC iSubTimeLeft
	BNE loc_BANK2_9741

	STA iSubAreaFlags
	JSR DoAreaReset

	JMP loc_BANK2_97FF

; ---------------------------------------------------------------------------

loc_BANK2_9741:
	LDA iSpriteTimer, X
	BNE locret_BANK2_9718

	LDA iSubDoorTimer
	BEQ loc_BANK2_9753

	DEC iSubDoorTimer
	BNE loc_BANK2_9753

	LDY iMusicID
	LDA LevelMusicIndexes, Y
	CMP iCurrentMusic
	BEQ loc_BANK2_9750

	LDY iStarTimer
	CPY #8
	BCS loc_BANK2_9750

	STA iMusic

loc_BANK2_9750:
	JMP TurnIntoPuffOfSmoke

; ---------------------------------------------------------------------------

loc_BANK2_9753:
	LDA zObjectAttributes, X
	ORA #ObjAttrib_16x32
	STA zObjectAttributes, X
	LDY iDoorAnimTimer
	LDA DoorSpriteAnimation, Y
	LDY #$00
	ASL A
	BCC loc_BANK2_9767

	INY
	STY zEnemyTrajectory, X

loc_BANK2_9767:
	LDA iDoorAnimTimer
	BEQ loc_BANK2_979A

	LDA zf4
	PHA
	JSR FindSpriteSlot

	CPY zf4
	PHP
	LDA zEnemyTrajectory, X
	CMP #$01
	BNE loc_BANK2_977F

	PLA
	EOR #$01
	PHA

loc_BANK2_977F:
	PLP
	BCC loc_BANK2_9784

	STY zf4

loc_BANK2_9784:
	LDA #$7A
	JSR RenderSprite_DrawObject

	LDY zf4
	LDA iVirtualOAM + 7, Y
	SEC
	SBC #$04
	STA iVirtualOAM + 7, Y
	STA iVirtualOAM + $F, Y
	PLA
	STA zf4

loc_BANK2_979A:
	JSR FindSpriteSlot

	CPY zf4
	PHP
	LDA zEnemyTrajectory, X
	CMP #$01
	BNE loc_BANK2_97AA

	PLA
	EOR #$01
	PHA

loc_BANK2_97AA:
	PLP
	BCS loc_BANK2_97AF

	STY zf4

loc_BANK2_97AF:
	LDA iDoorAnimTimer
	CMP #$19
	BCC loc_BANK2_97BA

	LDY #$00
	STY zf4

loc_BANK2_97BA:
	LDA #$76
	LDY i477, X
	BEQ loc_BANK2_97C3

	LDA #$7E

loc_BANK2_97C3:
	JSR RenderSprite_DrawObject

	LDX iDoorAnimTimer
	BEQ loc_BANK2_9805

	INC iDoorAnimTimer
	LDY zf4
	LDA DoorSpriteAnimation, X
	BMI loc_BANK2_9805

	CLC
	ADC iVirtualOAM + 3, Y
	STA iVirtualOAM + 3, Y
	STA iVirtualOAM + $B, Y
	CPX #(DoorSpriteAnimationEnd-DoorSpriteAnimation)
	BNE loc_BANK2_9805

	LDA #$00
	STA iDoorAnimTimer
	JSR DoAreaReset

	LDA iTransitionType
	CMP #TransitionType_Door
	BNE loc_BANK2_97F7

	INC iAreaTransitionID
	BNE loc_BANK2_97FF

loc_BANK2_97F7:
	LDA iSubAreaFlags
	EOR #$02
	STA iSubAreaFlags

loc_BANK2_97FF:
	PLA
	PLA
	PLA
	PLA
	PLA
	PLA

loc_BANK2_9805:
	LDX z12
	RTS


DoorSpriteAnimation:
	.db $00
	.db $01
	.db $01
	.db $02
	.db $02
	.db $03
	.db $04
	.db $06
	.db $08
	.db $FF
	.db $FF
	.db $FF
	.db $FF
	.db $FF
	.db $FF
	.db $FF
	.db $FF
	.db $FF
	.db $FF
	.db $FF
	.db $FF
	.db $FF
	.db $FF
	.db $FF
	.db $FF
	.db $08
	.db $06
	.db $04
	.db $03
	.db $02
	.db $02
	.db $02
	.db $02
	.db $01
	.db $01
	.db $01
	.db $01
	.db $01
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
DoorSpriteAnimationEnd:
	.db $00

; Unused?
	.db $A9
	.db $02
	.db $D0
	.db $06


;
; Note: Door animation code copied from Bank 1
;
; It's here, but seems to be unused?
;
DoorAnimation_Locked_Bank2:
	LDA #$01
	BNE DoorAnimation_Bank2

DoorAnimation_Unlocked_Bank2:
	LDA #$00

DoorAnimation_Bank2:
	PHA
	LDY #$08

DoorAnimation_Loop_Bank2:
	; skip if inactive
	LDA zEnemyState, Y
	BEQ DoorAnimation_LoopNext_Bank2

	LDA zObjectType, Y
	CMP #Enemy_SubspaceDoor
	BNE DoorAnimation_LoopNext_Bank2

	LDA #EnemyState_PuffOfSmoke
	STA zEnemyState, Y
	LDA #$20
	STA zSpriteTimer, Y

DoorAnimation_LoopNext_Bank2:
	DEY
	BPL DoorAnimation_Loop_Bank2

	JSR CreateEnemy_TryAllSlots

	BMI DoorAnimation_Exit_Bank2

	LDA #$00
	STA iDoorAnimTimer
	STA iSubDoorTimer
	LDX z00
	PLA
	STA i477, X
	LDA #Enemy_SubspaceDoor
	STA zObjectType, X
	JSR SetEnemyAttributes

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

DoorAnimation_Exit_Bank2:
	PLA
	RTS


ShellSpeed:
	.db $1C
	.db $E4


EnemyBehavior_Shell:
	JSR ObjectTileCollision

	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

	LDA zEnemyCollision, X
	AND #CollisionFlags_Right | CollisionFlags_Left
	BEQ EnemyBehavior_Shell_Slide

EnemyBehavior_Shell_Destroy:
	; shell destruction
	LDA #DPCM_Shell
	STA iDPCMSFX
	JMP TurnIntoPuffOfSmoke


EnemyBehavior_Shell_Slide:
	LDA zEnemyCollision, X
	AND #CollisionFlags_Down
	BEQ EnemyBehavior_Shell_Render

	JSR ResetObjectYVelocity

EnemyBehavior_Shell_Render:
	JSR RenderSprite

	LDY zEnemyTrajectory, X
	LDA ShellSpeed - 1, Y
	STA zObjectXVelocity, X
	JMP ApplyObjectMovement


; =============== S U B R O U T I N E =======================================

sub_BANK2_98C4:
	LDA #EnemyState_BlockFizzle
	STA zEnemyState, X
	LDA #$18
	STA zSpriteTimer, X

locret_BANK2_98CC:
	RTS

; End of function sub_BANK2_98C4


;
; Intercepts the normal enemy behavior when the object is being carried
;
EnemyBehavior_CheckBeingCarriedTimerInterrupt:
	LDA zHeldObjectTimer, X
	BEQ locret_BANK2_98CC

	; Cancel previous subroutine and go into carry mode
	PLA
	PLA
	JMP CarryObject


;
; If iObjectBulletTimer is set, interrupt the EnemyBehavior subroutine and just
; render the sprite and run physics
;
; Input
;   X = enemy index
;
EnemyBehavior_Check42FPhysicsInterrupt:
	LDA iObjectBulletTimer, X
	BEQ locret_BANK2_98EA

	PLA
	PLA
	JMP RenderSpriteAndApplyObjectMovement


EnemyInit_FallingLogs:
	JSR EnemyInit_Stationary

	STA iObjectStunTimer, X
	LDA zObjectYLo, X
	STA zObjectVariables, X

locret_BANK2_98EA:
	RTS



; ---------------------------------------------------------------------------

EnemyBehavior_FallingLogs:
	ASL zObjectAttributes, X
	LDA z10
	ASL A
	ASL A
	ASL A
	ASL A
	ROR zObjectAttributes, X
	LDY zEnemyArray, X
	BNE loc_BANK2_9919

	; behind background
	LDA zObjectAttributes, X
	ORA #ObjAttrib_BehindBackground
	STA zObjectAttributes, X
	LDA zObjectVariables, X
	SEC
	SBC #$0C
	CMP zObjectYLo, X
	LDA #$FE
	BCC loc_BANK2_9914

	; in front of background
	LDA zObjectAttributes, X
	AND #$DF
	STA zObjectAttributes, X
	INC zEnemyArray, X
	LDA #$04

loc_BANK2_9914:
	STA zObjectYVelocity, X
	JMP loc_BANK2_9921

; ---------------------------------------------------------------------------

loc_BANK2_9919:
	LDA z10
	AND #$07
	BNE loc_BANK2_9921

	INC zObjectYVelocity, X

loc_BANK2_9921:
	JSR ApplyObjectPhysicsY

	LDA zObjectYLo, X
	CMP #$F0
	BCC loc_BANK2_9932

	LDA #$00
	STA zEnemyArray, X
	LDA zObjectVariables, X
	STA zObjectYLo, X

loc_BANK2_9932:
	JMP RenderSprite

; ---------------------------------------------------------------------------

;
; Kills all enemies on the screen (ie. POW block quake)
;
KillOnscreenEnemies:
	LDA #$00

;
; Destroys all enemies on the screen
;
; Input
;   A = 0 for POW
;
DestroyOnscreenEnemies:
	STA z00
	LDX #$08

DestroyOnscreenEnemies_Loop:
	LDA zEnemyState, X
	CMP #EnemyState_Alive
	BNE DestroyOnscreenEnemies_Next

	LDA z00
	BEQ KillOnscreenEnemies_CheckCollision

	LDA zObjectType, X
	CMP #Enemy_Bomb
	BEQ DestroyOnscreenEnemies_DestroyItem

	CMP #Enemy_VegetableSmall
	BCS DestroyOnscreenEnemies_Next

DestroyOnscreenEnemies_DestroyItem:
	LDA zHeldItem
	BEQ DestroyOnscreenEnemies_Poof

	CPX iHeldItemIndex
	BNE DestroyOnscreenEnemies_Poof

	LDA #$00
	STA zHeldItem

DestroyOnscreenEnemies_Poof:
	STX z0e
	JSR TurnIntoPuffOfSmoke

	LDX z0e
	JMP DestroyOnscreenEnemies_Next

KillOnscreenEnemies_CheckCollision:
	LDA zEnemyCollision, X
	BEQ DestroyOnscreenEnemies_Next

IFDEF FIX_POW_LOG_GLITCH
	LDA zObjectType, X
	CMP #Enemy_VegetableSmall
	BCS KillOnscreenEnemies_SetCollision
ENDIF

	; BUG: For object that don't follow normal gravity rules, this will send
	; them flying into the air, ie. throwing a POW block from a falling log
	LDA #$D8
	STA zObjectYVelocity, X

KillOnscreenEnemies_SetCollision:
	LDA zEnemyCollision, X
	ORA #CollisionFlags_Damage
	STA zEnemyCollision, X

DestroyOnscreenEnemies_Next:
	DEX
	BPL DestroyOnscreenEnemies_Loop

	LDX z12
	RTS


;
; Checks whether the enemy is taking mortal damage
;
; If so, play the sound effect, kill the enemy, and cancel the previous enemy
; behavior subroutine.
;
; Input
;   X = enemy index
;
EnemyBehavior_CheckDamagedInterrupt:
	LDA zEnemyCollision, X
	AND #CollisionFlags_Damage
	BEQ EnemyBehavior_CheckDamagedInterrupt_Exit

	LDA zHeldObjectTimer, X
	BEQ EnemyBehavior_CheckDamagedInterrupt_SoundEffect

	; remove the item from the player's hands
	LDA #$00
	STA zHeldItem

EnemyBehavior_CheckDamagedInterrupt_SoundEffect:
	LDY zObjectType, X
	; is this enemy a squawker?
	LDA EnemyArray_46E_Data, Y
	AND #%00001000
	BNE EnemyBehavior_CheckDamagedInterrupt_BossDeathSound

	; normal enemy hit sound
	LDA iDPCMSFX
	BNE EnemyBehavior_CheckDamagedInterrupt_CheckPidgit

	LDA #DPCM_Impact
	STA iDPCMSFX
	BNE EnemyBehavior_CheckDamagedInterrupt_CheckPidgit

EnemyBehavior_CheckDamagedInterrupt_BossDeathSound:
	LDA #Hill_LampBossDeath
	STA iHillSFX
	STA iHillBossPriority

EnemyBehavior_CheckDamagedInterrupt_CheckPidgit:
	; killing pidgit leaves a flying carpet behind
	CPY #Enemy_Pidgit
	BNE EnemyBehavior_CheckDamagedInterrupt_SetDead

	LDA iObjectBulletTimer, X
	BNE EnemyBehavior_CheckDamagedInterrupt_SetDead

	JSR CreateFlyingCarpet

EnemyBehavior_CheckDamagedInterrupt_SetDead:
	LDA #EnemyState_Dead
	STA zEnemyState, X
	; interrupt the previous subroutine
	PLA
	PLA

EnemyBehavior_CheckDamagedInterrupt_Exit:
	RTS


EnemyTilemap1:
	.db $D0,$D2 ; $00
	.db $D4,$D6 ; $02
	.db $F8,$F8 ; $04
	.db $FA,$FA ; $06
	.db $CC,$CE ; $08
	.db $CC,$CE ; $0A
	.db $C8,$CA ; $0C
	.db $C8,$CA ; $0E
	.db $70,$72 ; $10
	.db $74,$76 ; $12
	.db $C0,$C2 ; $14
	.db $C4,$C6 ; $16
	.db $E1,$E3 ; $18
	.db $E5,$E7 ; $1A
	.db $E1,$E3 ; $1C
	.db $E5,$E7 ; $1E
	.db $78,$7A ; $20
	.db $7C,$7E ; $22
	.db $DC,$DA ; $24
	.db $DC,$DE ; $26
	.db $FE,$FE ; $28
	.db $FC,$FC ; $2A
	.db $94,$94 ; $2C
	.db $96,$96 ; $2E
	.db $98,$98 ; $30
	.db $9A,$9A ; $32
	.db $DB,$DD ; $34
	.db $DB,$DD ; $36
	.db $7D,$7F ; $38
	.db $C1,$C3 ; $3A
	.db $8C,$8C ; $3C
	.db $8E,$8E ; $3E
	.db $E0,$E2 ; $40
	.db $6B,$6D ; $42
	.db $6D,$6F ; $44
	.db $3A,$3A ; $46
	.db $3A,$3A ; $48
	.db $38,$38 ; $4A
	.db $38,$38 ; $4C
	.db $36,$36 ; $4E
	.db $36,$36 ; $50
	.db $34,$34 ; $52
	.db $34,$34 ; $54
	.db $AE,$FB ; $56
	.db $AE,$FB ; $58
	.db $80,$82 ; $5A
	.db $84,$86 ; $5C
	.db $80,$82 ; $5E
	.db $AA,$AC ; $60
	.db $88,$8A ; $62
	.db $84,$86 ; $64
	.db $88,$8A ; $66
	.db $AA,$AC ; $68
	.db $BC,$BE ; $6A
	.db $AA,$AC ; $6C
	.db $BC,$BE ; $6E
	.db $AA,$AC ; $70
	.db $B5,$B9 ; $72
	.db $B5,$B9 ; $74
	.db $81,$83 ; $76
	.db $85,$87 ; $78
	.db $FF,$FF ; $7A
	.db $FF,$FF ; $7C
	.db $81,$83 ; $7E
	.db $F5,$87 ; $80
	.db $C5,$C7 ; $82
	.db $C9,$CB ; $84
	.db $92,$94 ; $86
	.db $29,$29 ; $88
	.db $2B,$2B ; $8A
	.db $3D,$3F ; $8C
	.db $4C,$4E ; $8E
	.db $50,$52 ; $90
	.db $4C,$4E ; $92
	.db $56,$58 ; $94
	.db $FB,$5C ; $96
	.db $FB,$5A ; $98
	.db $FB,$FB ; $9A
	.db $FB,$54 ; $9C
	.db $CF,$CF ; $9E
	.db $A5,$A5 ; $A0
	.db $B0,$B2 ; $A2
	.db $90,$90 ; $A4
	.db $CD,$CD ; $A6
	.db $A8,$A8 ; $A8
	.db $A8,$A8 ; $AA
	.db $A0,$A2 ; $AC
	.db $A4,$A4 ; $AE
	.db $A4,$A4 ; $B0
	.db $4D,$4D ; $B2
	.db $8C,$8C ; $B4
	.db $A6,$A6 ; $B6
	.db $AB,$AB ; $B8

;
; Enemy Animation table
; =====================
;
; These point to the tilemaps offset for an object's animation frames.
;
; $FF is used to make an enemy invisible
;
EnemyAnimationTable:
	.db $00 ; $00 Enemy_Heart
	.db $00 ; $01 Enemy_ShyguyRed
	.db $08 ; $02 Enemy_Tweeter
	.db $00 ; $03 Enemy_ShyguyPink
	.db $0C ; $04 Enemy_Porcupo
	.db $10 ; $05 Enemy_SnifitRed
	.db $10 ; $06 Enemy_SnifitGray
	.db $10 ; $07 Enemy_SnifitPink
	.db $40 ; $08 Enemy_Ostro
	.db $14 ; $09 Enemy_BobOmb
	.db $18 ; $0A Enemy_AlbatossCarryingBobOmb
	.db $18 ; $0B Enemy_AlbatossStartRight
	.db $18 ; $0C Enemy_AlbatossStartLeft
	.db $20 ; $0D Enemy_NinjiRunning
	.db $20 ; $0E Enemy_NinjiJumping
	.db $24 ; $0F Enemy_BeezoDiving
	.db $24 ; $10 Enemy_BeezoStraight
	.db $BE ; $11 Enemy_WartBubble
	.db $00 ; $12 Enemy_Pidgit
	.db $86 ; $13 Enemy_Trouter
	.db $88 ; $14 Enemy_Hoopstar
	.db $FF ; $15 Enemy_JarGeneratorShyguy
	.db $FF ; $16 Enemy_JarGeneratorBobOmb
	.db $8C ; $17 Enemy_Phanto
	.db $5C ; $18 Enemy_CobratJar
	.db $5C ; $19 Enemy_CobratSand
	.db $6C ; $1A Enemy_Pokey
	.db $56 ; $1B Enemy_Bullet
	.db $5A ; $1C Enemy_Birdo
	.db $14 ; $1D Enemy_Mouser
	.db $72 ; $1E Enemy_Egg
	.db $00 ; $1F Enemy_Tryclyde
	.db $A8 ; $20 Enemy_Fireball
	.db $00 ; $21 Enemy_Clawgrip
	.db $D6 ; $22 Enemy_ClawgripRock
	.db $AC ; $23 Enemy_PanserStationaryFiresAngled
	.db $AC ; $24 Enemy_PanserWalking
	.db $AC ; $25 Enemy_PanserStationaryFiresUp
	.db $74 ; $26 Enemy_Autobomb
	.db $7A ; $27 Enemy_AutobombFire
	.db $92 ; $28 Enemy_WhaleSpout
	.db $9A ; $29 Enemy_Flurry
	.db $80 ; $2A Enemy_Fryguy
	.db $90 ; $2B Enemy_FryguySplit
	.db $00 ; $2C Enemy_Wart
	.db $00 ; $2D Enemy_HawkmouthBoss
	.db $B6 ; $2E Enemy_Spark1
	.db $B6 ; $2F Enemy_Spark2
	.db $B6 ; $30 Enemy_Spark3
	.db $B6 ; $31 Enemy_Spark4
	.db $28 ; $32 Enemy_VegetableSmall
	.db $2A ; $33 Enemy_VegetableLarge
	.db $2C ; $34 Enemy_VegetableWart
	.db $2E ; $35 Enemy_Shell
	.db $30 ; $36 Enemy_Coin
	.db $34 ; $37 Enemy_Bomb
	.db $00 ; $38 Enemy_Rocket
	.db $38 ; $39 Enemy_MushroomBlock
	.db $3A ; $3A Enemy_POWBlock
	.db $42 ; $3B Enemy_FallingLogs
	.db $82 ; $3C Enemy_SubspaceDoor
	.db $82 ; $3D Enemy_Key
	.db $84 ; $3E Enemy_SubspacePotion
	.db $A0 ; $3F Enemy_Mushroom
	.db $A2 ; $40 Enemy_Mushroom1up
	.db $04 ; $41 Enemy_FlyingCarpet
	.db $8E ; $42 Enemy_HawkmouthRight
	.db $8E ; $43 Enemy_HawkmouthLeft
	.db $9E ; $44 Enemy_CrystalBall
	.db $A6 ; $45 Enemy_Starman
	.db $A4 ; $46 Enemy_Stopwatch


;
; Sets the temporary screen x- and y-position for the current object.
;
; If the object is being carried by the player (and it's not the Princess),
; this will bob the y-position along with the player animation.
;
SetSpriteTempScreenPosition:
	LDA zObjectYLo, X
	CLC
	SBC zScreenY
	LDY zHeldObjectTimer, X
	BEQ SetSpriteTempScreenPosition_Update

	LDY zPlayerAnimFrame
	BNE SetSpriteTempScreenPosition_Update

	; Skip making the carried object bob if playing as the Princess
	LDY zCurrentCharacter
	DEY
	BEQ SetSpriteTempScreenPosition_Update

	SEC
	SBC #$01

SetSpriteTempScreenPosition_Update:
	STA iSpriteTempScreenY
	LDA zObjectXLo, X
	SEC
	SBC iBoundLeftLower
	STA iSpriteTempScreenX

	RTS


RenderSprite_Birdo:
	LDA zEnemyState, X
	CMP #EnemyState_Alive
	BNE loc_BANK2_9AE2

	LDA iObjectFlashTimer, X
	BEQ loc_BANK2_9AE6

loc_BANK2_9AE2:
	LDA #$6A
	BNE loc_BANK2_9AEC

loc_BANK2_9AE6:
	LDA zSpriteTimer, X
	BEQ loc_BANK2_9AEF

	LDA #$62

loc_BANK2_9AEC:
	JMP RenderSprite_DrawObject

; ---------------------------------------------------------------------------

loc_BANK2_9AEF:
	JMP RenderSprite_NotAlbatoss


RenderSprite_Albatoss:
	LDA zee
	PHA
	JSR RenderSprite_NotAlbatoss

	PLA
	ASL A
	STA zee
	LDA zEnemyArray, X
	ORA zef
	BNE RenderSprite_Invisible

	LDA iSpriteTempScreenX
	ADC #$08
	STA z01
	LDA zEnemyTrajectory, X
	STA z02
	LDA #$01
	STA z03
	STA z05
	JSR FindSpriteSlot

	LDX #$14
	JMP loc_BANK2_9C7A


; =============== S U B R O U T I N E =======================================

;
; Renders a sprite for an object based on the enemy animation table lookup
;
; There are a lot of special cases basd on zObjectType
;
; Input
;   X = enemy index
;
RenderSprite:
	LDY zObjectType, X
	LDA EnemyAnimationTable, Y
	CMP #$FF
	BEQ RenderSprite_Invisible

	CPY #Enemy_Mouser
	BNE RenderSprite_NotMouser

	JMP RenderSprite_Mouser

RenderSprite_NotMouser:
	CPY #Enemy_Clawgrip
	BNE RenderSprite_NotClawgrip

	JMP RenderSprite_Clawgrip

RenderSprite_NotClawgrip:
	CPY #Enemy_ClawgripRock
	BNE RenderSprite_NotClawgripRock

	JMP RenderSprite_ClawgripRock

RenderSprite_NotClawgripRock:
	CPY #Enemy_HawkmouthBoss
	BNE RenderSprite_NotHawkmouthBoss

	JMP RenderSprite_HawkmouthBoss

RenderSprite_Invisible:
	RTS

RenderSprite_NotHawkmouthBoss:
	CPY #Enemy_Pidgit
	BNE RenderSprite_NotPidgit

	JMP RenderSprite_Pidgit

RenderSprite_NotPidgit:
	CPY #Enemy_Porcupo
	BNE RenderSprite_NotPorcupo

	JMP RenderSprite_Porcupo

RenderSprite_NotPorcupo:
	CPY #Enemy_VegetableLarge
	BNE RenderSprite_NotVegetableLarge

	JMP RenderSprite_VegetableLarge

RenderSprite_NotVegetableLarge:
	CPY #Enemy_Autobomb
	BNE RenderSprite_NotAutobomb

	JMP RenderSprite_Autobomb

RenderSprite_NotAutobomb:
	CPY #Enemy_Fryguy
	BNE RenderSprite_NotFryguy

	JMP RenderSprite_Fryguy

RenderSprite_NotFryguy:
	CPY #Enemy_HawkmouthLeft
	BNE RenderSprite_NotHawkmouthLeft

	JMP RenderSprite_HawkmouthLeft

RenderSprite_NotHawkmouthLeft:
	CPY #Enemy_Wart
	BNE RenderSprite_NotWart

	JMP RenderSprite_Wart

RenderSprite_NotWart:
	CPY #Enemy_WhaleSpout
	BNE RenderSprite_NotWhaleSpout

	JMP RenderSprite_WhaleSpout

RenderSprite_NotWhaleSpout:
	CPY #Enemy_Pokey
	BNE RenderSprite_NotPokey

	JMP RenderSprite_Pokey

RenderSprite_NotPokey:
	CPY #Enemy_Heart
	BNE RenderSprite_NotHeart

	; This jump appears to never be taken;
	; I don't think this code even runs with an enemy ID of 0 (heart)
	JMP RenderSprite_Heart

RenderSprite_NotHeart:
	CPY #Enemy_Ostro
	BNE RenderSprite_NotOstro

	JMP RenderSprite_Ostro

RenderSprite_NotOstro:
	CPY #Enemy_Tryclyde
	BNE RenderSprite_NotTryclyde

	JMP RenderSprite_Tryclyde

RenderSprite_NotTryclyde:
	CPY #Enemy_Birdo
	BNE RenderSprite_NotBirdo

	JMP RenderSprite_Birdo

RenderSprite_NotBirdo:
	CPY #Enemy_AlbatossCarryingBobOmb
	BCC RenderSprite_NotAlbatoss

	CPY #Enemy_NinjiRunning
	BCS RenderSprite_NotAlbatoss

	JMP RenderSprite_Albatoss

RenderSprite_NotAlbatoss:
	LDY zObjectType, X
	CPY #Enemy_Rocket
	BNE RenderSprite_NotRocket

	JMP RenderSprite_Rocket

RenderSprite_NotRocket:
	LDA EnemyAnimationTable, Y


;
; Draws an object to the screen
;
; Input
;   A = tile index
;   X = enemy index
;   zee = sprite clipping
;   zef = whether the enemy should be invisible
;   zf4 = sprite slot offset
;   iSpriteTempScreenX = screen x-position
;   iSpriteTempScreenY = screen y-position
;
RenderSprite_DrawObject:
	STA z0f
	LDA zef
	BNE RenderSprite_Invisible

	; tilemap switcher
	LDA i46e, X
	AND #%00010000
	STA z0b
	LDY zEnemyTrajectory, X
	LDA zObjectAttributes, X
	AND #ObjAttrib_FrontFacing | ObjAttrib_Mirrored
	BEQ loc_BANK2_9BD2

	LDY #$02
	LDA iSubAreaFlags
	CMP #$02
	BNE loc_BANK2_9BD2

	DEY

loc_BANK2_9BD2:
	STY z02
	LDA zObjectAttributes, X
	AND #ObjAttrib_16x32 | ObjAttrib_Horizontal
	STA z05
	LDA iSpriteTempScreenY
	STA z00
	LDA #$00
	STA z0d
	LDA iObjectShakeTimer, X
	AND #$02
	LSR A
	LDY zee
	BEQ loc_BANK2_9BEF

	LDA #$00

loc_BANK2_9BEF:
	ADC iSpriteTempScreenX
	STA z01
	LDA zObjectAttributes, X
	AND #ObjAttrib_UpsideDown | ObjAttrib_BehindBackground | ObjAttrib_Palette
	LDY iObjectFlashTimer, X
	BEQ loc_BANK2_9C07

	AND #ObjAttrib_UpsideDown | ObjAttrib_BehindBackground
	STA z08
	TYA
	LSR A
	AND #$03
	ORA z08

loc_BANK2_9C07:
	STA z03
	LDA i46e, X
	STA z0c
	ASL A
	LDA zObjectAnimTimer, X
	LDX z0f
	AND #$08
	BEQ loc_BANK2_9C31

	BCC loc_BANK2_9C1F

	LDA #$01
	STA z02
	BNE loc_BANK2_9C31

loc_BANK2_9C1F:
	INX
	INX
	LDA z05
	AND #$40
	BEQ loc_BANK2_9C31

	INX
	INX
	LDA z0c
	AND #$20
	BEQ loc_BANK2_9C31

	INX
	INX

loc_BANK2_9C31:
	LDY zf4
	LDA z05
	AND #$40
	BEQ loc_BANK2_9C7A

	LDA z05
	AND #$04
	BEQ loc_BANK2_9C53

	LDA zee
	STA z08
	LDA z02
	CMP #$01
	BNE loc_BANK2_9C53

	LDA z01
	ADC #$0F
	STA z01
	ASL zee
	ASL zee

loc_BANK2_9C53:
	JSR SetSpriteTiles

	LDA z05
	AND #$04
	BEQ loc_BANK2_9C7A

	LDA iSpriteTempScreenY
	STA z00
	LDA iSpriteTempScreenX
	STA z01
	LDA z08
	STA zee
	LDA z02
	CMP #$01
	BEQ loc_BANK2_9C7A

	LDA z01
	ADC #$0F
	STA z01
	ASL zee
	ASL zee

loc_BANK2_9C7A:
	JSR SetSpriteTiles

	LDY zf4
	LDA z05
	CMP #$40
	BNE loc_BANK2_9CD9

	LDA z03
	BPL loc_BANK2_9CD9

	LDA z0c
	AND #$20
	BEQ loc_BANK2_9CBD

	LDX z0d
	LDA iVirtualOAM + $00, X
	PHA
	LDA iVirtualOAM + $00, Y
	STA iVirtualOAM + $00, X
	PLA

loc_BANK2_9C9C:
	STA iVirtualOAM + $00, Y
	LDA iVirtualOAM + $04, X
	PHA
	LDA iVirtualOAM + $04, Y
	STA iVirtualOAM + $04, X
	PLA
	STA iVirtualOAM + $04, Y
	LDA iVirtualOAM + $08, X
	PHA
	LDA iVirtualOAM + $08, Y
	STA iVirtualOAM + $08, X
	PLA
	STA iVirtualOAM + $08, Y
	BCS loc_BANK2_9CD9

loc_BANK2_9CBD:
	LDA iVirtualOAM, Y
	PHA
	LDA iVirtualOAM + $08, Y
	STA iVirtualOAM + $00, Y
	PLA
	STA iVirtualOAM + $08, Y
	LDA iVirtualOAM + $04, Y
	PHA
	LDA iVirtualOAM + $0C, Y
	STA iVirtualOAM + $04, Y
	PLA
	STA iVirtualOAM + $0C, Y

loc_BANK2_9CD9:
	LDX z12
	LDA zObjectAttributes, X
	AND #ObjAttrib_Mirrored
	BEQ locret_BANK2_9CF1

	LDA z03
	STA iVirtualOAM + $02, Y
	STA iVirtualOAM + $0A, Y
	ORA #$40
	STA iVirtualOAM + $06, Y
	STA iVirtualOAM + $0E, Y

locret_BANK2_9CF1:
	RTS


;
; Sets tiles for an object
;
; Input
;   X = tilemap offset
;   Y = sprite slot offset
;   z00 = screen y-offset
;   z01 = screen x-offset
;   z02 = sprite direction: $00 for left, $02 for right
;   z0b = use EnemyTilemap2
;   z0c = use 24x16 mode when set to $20
;   zee = used for horizontal clipping/wrapping
; Output
;   X = next tilemap offset
;   Y = next sprite slot offset
;
SetSpriteTiles:
	LDA z0c
	AND #$20
	BNE SetSpriteTiles_24x16

	LDA z0b
	BNE SetSpriteTiles_Tilemap2

SetSpriteTiles_Tilemap1:
	LDA EnemyTilemap1, X
	STA iVirtualOAM + 1, Y
	LDA EnemyTilemap1 + 1, X
	STA iVirtualOAM + 5, Y
	BNE SetSpriteTiles_CheckDirection

SetSpriteTiles_Tilemap2:
	LDA EnemyTilemap2, X
	STA iVirtualOAM + 1, Y
	LDA EnemyTilemap2 + 1, X
	STA iVirtualOAM + 5, Y

SetSpriteTiles_CheckDirection:
	LDA z02
	LSR A
	LDA #$00
	BCC SetSpriteTiles_Left

SetSpriteTiles_Right:
	LDA iVirtualOAM + 1, Y
	PHA
	LDA iVirtualOAM + 5, Y
	STA iVirtualOAM + 1, Y
	PLA
	STA iVirtualOAM + 5, Y
	LDA #$40

SetSpriteTiles_Left:
	ORA z03
	STA iVirtualOAM + 2, Y
	STA iVirtualOAM + 6, Y
	LDA #$F8
	STA iVirtualOAM, Y
	STA iVirtualOAM + 4, Y

	LDA zee
	AND #$08
	BNE loc_BANK2_9D48

	LDA z00
	STA iVirtualOAM, Y

loc_BANK2_9D48:
	LDA zee
	AND #$04
	BNE loc_BANK2_9D53

	LDA z00
	STA iVirtualOAM + 4, Y

loc_BANK2_9D53:
	LDA z00
	CLC
	ADC #$10
	STA z00
	LDA z01
	STA iVirtualOAM + 3, Y
	CLC
	ADC #$08
	STA iVirtualOAM + 7, Y
	TYA
	CLC
	ADC #$08
	TAY
	INX
	INX
	RTS

SetSpriteTiles_24x16:
	LDA EnemyTilemap2, X
	STA iVirtualOAM + 1, Y
	LDA EnemyTilemap2 + 1, X
	STA iVirtualOAM + 5, Y
	LDA EnemyTilemap2 + 2, X
	STA iVirtualOAM + 9, Y

	LDA z02
	LSR A
	LDA #$00
	BCC SetSpriteTiles_24x16_Left

SetSpriteTiles_24x16_Right:
	LDA iVirtualOAM + 1, Y
	PHA
	LDA iVirtualOAM + 9, Y
	STA iVirtualOAM + 1, Y
	PLA
	STA iVirtualOAM + 9, Y
	LDA #$40

SetSpriteTiles_24x16_Left:
	ORA z03
	STA iVirtualOAM + 2, Y
	STA iVirtualOAM + 6, Y
	STA iVirtualOAM + $A, Y
	LDA #$F8
	STA iVirtualOAM, Y
	STA iVirtualOAM + 4, Y
	STA iVirtualOAM + 8, Y

	LDA zee
	AND #$08
	BNE loc_BANK2_9DB7

	LDA z00
	STA iVirtualOAM, Y

loc_BANK2_9DB7:
	LDA zee
	AND #$04
	BNE loc_BANK2_9DC2

	LDA z00
	STA iVirtualOAM + 4, Y

loc_BANK2_9DC2:
	LDA zee
	AND #$02
	BNE loc_BANK2_9DCD

	LDA z00
	STA iVirtualOAM + 8, Y

loc_BANK2_9DCD:
	LDA z00
	CLC
	ADC #$10
	STA z00
	LDA z01
	STA iVirtualOAM + 3, Y
	ADC #$08
	STA iVirtualOAM + 7, Y
	ADC #$08
	STA iVirtualOAM + $B, Y
	TXA
	PHA
	JSR FindSpriteSlot

	PLA
	TAX
	LDA z0d
	BNE loc_BANK2_9DF0

	STY z0d

loc_BANK2_9DF0:
	INX
	INX
	INX

	RTS


UNUSED_PorcupoOffset:
	.db $04
	.db $00
PorcupoOffsetXRight:
	.db $FF
	.db $FF
	.db $00
	.db $00
PorcupoOffsetXLeft:
	.db $01
	.db $01
	.db $00
	.db $00
PorcupoOffsetYRight:
	.db $01
	.db $00
	.db $00
	.db $01
PorcupoOffsetYLeft:
	.db $01
	.db $00
	.db $00
	.db $01


RenderSprite_Porcupo:
	JSR RenderSprite_NotAlbatoss

	LDA zee
	AND #$0C
	BNE locret_BANK2_9E3A

	LDA zObjectAnimTimer, X
	AND #$0C
	LSR A
	LSR A
	STA z00
	LDA zEnemyTrajectory, X
	TAX
	LDA PorcupoOffsetXRight - 3, X
	ADC zf4
	TAY
	TXA
	ASL A
	ASL A
	ADC z00
	TAX
	LDA iVirtualOAM, Y
	ADC PorcupoOffsetYRight - 4, X
	STA iVirtualOAM, Y
	LDA iVirtualOAM + 3, Y
	ADC PorcupoOffsetXRight - 4, X
	STA iVirtualOAM + 3, Y
	LDX z12

locret_BANK2_9E3A:
	RTS


;
; Compares our position to the player's and returns
;
; Ouput
;   Y = 1 when player is to the left, 0 when player is to the right
;
EnemyFindWhichSidePlayerIsOn:
	LDA zPlayerXLo
	SBC zObjectXLo, X
	STA z0f
	LDA zPlayerXHi
	LDY #$00
	SBC zObjectXHi, X
	BCS EnemyFindWhichSidePlayerIsOn_Exit

	INY

EnemyFindWhichSidePlayerIsOn_Exit:
	RTS


;
; Applies object physics for the y-axis
;
; Input
;   X = enemy index
;
ApplyObjectPhysicsY:
	TXA
	CLC
	ADC #$0A
	TAX

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
ApplyObjectPhysicsX:
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
	BCC ApplyObjectPhysics_StoreVelocityLo

	; Left/up: Carry negative bits through upper nybble
	ORA #$F0

ApplyObjectPhysics_StoreVelocityLo:
	STA z00

	LDY #$00
	ASL A
	BCC ApplyObjectPhysics_StoreDirection

	; Left/up
	DEY

ApplyObjectPhysics_StoreDirection:
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

	ROL z01

	; X < 10 is horizontal physics, X >= 10 is vertical physics
	CPX #$0A
	BCS ApplyObjectPhysics_PositionHi

ApplyObjectPhysics_HorizontalSpecialCases:
	LDA #$00
	STA iObjectNonSticky, X
	LDA zObjectType, X
	CMP #Enemy_Bullet
	BEQ ApplyObjectPhysics_PositionHi

	CMP #Enemy_BeezoDiving
	BEQ ApplyObjectPhysics_PositionHi

	CMP #Enemy_BeezoStraight
	BEQ ApplyObjectPhysics_PositionHi

	LDY zScrollCondition
	BEQ ApplyObjectPhysics_Exit

ApplyObjectPhysics_PositionHi:
	LSR z01
	LDA zObjectXHi, X
	ADC z02
	STA zObjectXHi, X

ApplyObjectPhysics_Exit:
	LDX z12
	RTS


EnemyBehavior_TurnAround:
	; flip x-velocity
	LDA zObjectXVelocity, X
	EOR #$FF
	CLC
	ADC #$01
	STA zObjectXVelocity, X
	; if the enemy is not moving, flip direction next
	BEQ EnemyBehavior_TurnAroundExit

	; flip enemy movement direction
	LDA zEnemyTrajectory, X
	EOR #$03 ; $01 XOR $03 = $02, $02 XOR $03 = $01
	STA zEnemyTrajectory, X

EnemyBehavior_TurnAroundExit:
	JMP ApplyObjectPhysicsX


EnemyTilemap2:
	.db $2D,$2F ; $00
	.db $2D,$2F ; $02
	.db $E0,$E2 ; $04
	.db $E4,$E6 ; $06
	.db $E0,$E2 ; $08
	.db $E4,$E6 ; $0A
	.db $E8,$EA ; $0C
	.db $EC,$EE ; $0E
	.db $E8,$EA ; $10
	.db $EC,$EE ; $12
	.db $01,$03 ; $14
	.db $09,$05 ; $16
	.db $07,$0B ; $18
	.db $0D,$0F ; $1A
	.db $15,$11 ; $1C
	.db $13,$17 ; $1E
	.db $01,$03 ; $20
	.db $09,$05 ; $22
	.db $19,$1B ; $24
	.db $01,$03 ; $26
	.db $09,$05 ; $28
	.db $19,$1B ; $2A
	.db $1D,$1F ; $2C
	.db $25,$21 ; $2E
	.db $23,$27 ; $30
	.db $1D,$1F ; $32
	.db $25,$21 ; $34
	.db $23,$27 ; $36
	.db $9C,$9E ; $38
	.db $9C,$9E ; $3A
	.db $D0,$D2 ; $3C
	.db $D4,$D6 ; $3E
	.db $F0,$F2 ; $40
	.db $F4,$F6 ; $42
	.db $F0,$F2 ; $44
	.db $F8,$FA ; $46
	.db $0F,$11 ; $48
	.db $13,$15 ; $4A
	.db $1F,$11 ; $4C
	.db $13,$15 ; $4E
	.db $17,$19 ; $50
	.db $1B,$17 ; $52
	.db $19,$1D ; $54
	.db $09,$0B ; $56
	.db $01,$03 ; $58
	.db $05,$07 ; $5A
	.db $55,$59 ; $5C
	.db $5B,$5D ; $5E
	.db $F0,$F2 ; $60
	.db $F4,$F6 ; $62
	.db $45,$59 ; $64
	.db $5B,$5D ; $66
	.db $45,$59 ; $68
	.db $5B,$5D ; $6A
	.db $E8,$EA ; $6C
	.db $EC,$EE ; $6E
	.db $EC,$EE ; $70
	.db $EC,$EE ; $72
	.db $F0,$F2 ; $74
	.db $F0,$F2 ; $76
	.db $F4,$F6 ; $78
	.db $F8,$FA ; $7A
	.db $D0,$D2 ; $7C
	.db $D4,$D6 ; $7E
	.db $01,$03 ; $80
	.db $05,$07 ; $82
	.db $09,$0B ; $84
	.db $0D,$0F ; $86
	.db $01,$11 ; $88
	.db $05,$15 ; $8A
	.db $13,$0B ; $8C
	.db $17,$0F ; $8E
	.db $19,$1B ; $90
	.db $2D,$2F ; $92
	.db $3A,$3A ; $94
	.db $E0,$E2 ; $96
	.db $E4,$E6 ; $98
	.db $E8,$EA ; $9A
	.db $EC,$EE ; $9C
	.db $01,$03 ; $9E
	.db $05,$07 ; $A0
	.db $4F,$5D ; $A2
	.db $05,$07 ; $A4
	.db $09,$0B ; $A6
	.db $0D,$0F ; $A8
	.db $27,$79 ; $AA
	.db $7B,$2D ; $AC
	.db $4F,$2F ; $AE
	.db $45,$55 ; $B0
	.db $11,$13 ; $B2
	.db $15,$17 ; $B4
	.db $1F,$21 ; $B6
	.db $23,$25 ; $B8
	.db $11,$13 ; $BA
	.db $23,$25 ; $BC
	.db $59,$59 ; $BE
	.db $5B,$5B ; $C0
	.db $01,$03 ; $C2
	.db $05,$07 ; $C4
	.db $09,$0B ; $C6
	.db $0D,$0F ; $C8
	.db $FB,$11 ; $CA
	.db $15,$17 ; $CC
	.db $13,$FB ; $CE
	.db $19,$1B ; $D0
	.db $1D,$1F ; $D2
	.db $21,$23 ; $D4
	.db $25,$27 ; $D6
	.db $25,$27 ; $D8

EnemyInit_Clawgrip:
	JSR EnemyInit_Birdo

	LDA #$04
	STA iEnemyHP, X
	LDA #$00
	STA zObjectXVelocity, X
	LDA zObjectXLo, X
	CLC
	ADC #$04
	STA zObjectXLo, X
	JMP SetEnemyAttributes


ClawgripRock_ThrowVelocityY:
	.db $C8
	.db $D0
	.db $E0
	.db $F0
	.db $00
	.db $10
	.db $20
	.db $C8

ClawgripRock_JumpVelocityY:
	.db $DC
	.db $E2
	.db $E8
	.db $F0
	.db $F8
	.db $E8
	.db $DC
	.db $DC


EnemyBehavior_Clawgrip:
	LDA iObjectFlashTimer, X
	ORA iObjectStunTimer, X
	BEQ loc_BANK3_A13B

	JMP RenderSprite

; ---------------------------------------------------------------------------

loc_BANK3_A13B:
	JSR EnemyBehavior_CheckDamagedInterrupt

	LDA zObjectYLo, X
	CMP #$70
	BCC loc_BANK3_A147

	JSR ResetObjectYVelocity

loc_BANK3_A147:
	LDA zSpriteTimer, X
	BNE loc_BANK3_A179

	LDA zObjectVariables, X
	AND #$3F
	BNE loc_BANK3_A168

	LDA iPRNGValue
	AND #$03
	BEQ loc_BANK3_A168

	LDY iBoundLeftLower
	DEY
	CPY #$80
	BCC loc_BANK3_A168

	LDA #$7F
	STA zSpriteTimer, X
	LDY #$00
	BEQ loc_BANK3_A174

loc_BANK3_A168:
	INC zObjectVariables, X
	LDY #$F0
	LDA zObjectVariables, X
	AND #$20
	BEQ loc_BANK3_A174

	LDY #$10

loc_BANK3_A174:
	STY zObjectXVelocity, X
	JMP loc_BANK3_A1CD

; ---------------------------------------------------------------------------

loc_BANK3_A179:
	CMP #$50
	BNE loc_BANK3_A17D

loc_BANK3_A17D:
	CMP #$20
	BNE loc_BANK3_A1CD

	; Set jump velocity of Clawgrip
	LDA iPRNGValue
	AND #$07
	TAY
	LDA #DPCM_ClawgripChuck
	STA iDPCMSFX
	LDA ClawgripRock_JumpVelocityY, Y
	STA zObjectYVelocity, X
	DEC zObjectYLo, X
	JSR CreateEnemy

	BMI loc_BANK3_A1CD

	; Set y-position of rock
	LDY z00
	LDA zObjectYLo, X
	SEC
	SBC #$00
	STA zObjectYLo, Y

	LDA zObjectYHi, X
	SBC #$00
	STA zObjectYHi, Y

	; Set x-position of rock
	LDA zObjectXLo, X
	CLC
	ADC #$08
	STA zObjectXLo, Y

	LDA zObjectXHi, X
	ADC #$00
	STA zObjectXHi, Y

	; Set object type of rock
	LDX z00
	LDA #Enemy_ClawgripRock
	STA zObjectType, X

	; Set y-velocity of rock
	LDA iPRNGValue
	AND #$07
	TAY
	LDA ClawgripRock_ThrowVelocityY, Y
	STA zObjectYVelocity, X

	; Set x-velocity of rock
	LDA #$D0
	STA zObjectXVelocity, X
	JSR SetEnemyAttributes

	LDX z12

loc_BANK3_A1CD:
	JSR ApplyObjectPhysicsX

	JSR ApplyObjectMovement_Vertical

loc_BANK3_A1D3:
	JMP RenderSprite


	.db $08
	.db $08

byte_BANK3_A1D8:
	.db $1C
	.db $F4
	.db $11
	.db $0F

byte_BANK3_A1DC:
	.db $04
	.db $06
	.db $08
	.db $08
	.db $08
	.db $08
	.db $06
	.db $04


RenderSprite_Clawgrip:
	LDA zf4

	STA zEnemyArray, X
	LDY zEnemyState, X
	DEY
	TYA
	ORA iObjectFlashTimer, X
	BEQ loc_BANK3_A1FA

	LDY #$D2
	LDA #$00
	STA zSpriteTimer, X
	BEQ loc_BANK3_A21C

loc_BANK3_A1FA:
	LDY #$C2
	LDA z10
	AND #$10
	BNE loc_BANK3_A204

	LDY #$C6

loc_BANK3_A204:
	LDA zSpriteTimer, X
	BEQ loc_BANK3_A21C

	LDY #$CA
	CMP #$60
	BCS loc_BANK3_A21C

	LDY #$C2
	CMP #$40
	BCS loc_BANK3_A21C

	LDY #$C6
	CMP #$20
	BCS loc_BANK3_A21C

	LDY #$C2

loc_BANK3_A21C:
	LDA #$02
	STA zEnemyTrajectory, X
	TYA
	JSR RenderSprite_DrawObject

	LDY #$C6
	LDA z10
	AND #$10
	BNE loc_BANK3_A22E

	LDY #$C2

loc_BANK3_A22E:
	LDA zSpriteTimer, X
	BEQ loc_BANK3_A246

	LDY #$CE
	CMP #$60
	BCS loc_BANK3_A246

	LDY #$C2
	CMP #$40
	BCS loc_BANK3_A246

	LDY #$C6
	CMP #$20
	BCS loc_BANK3_A246

	LDY #$C2

loc_BANK3_A246:
	LDA iObjectFlashTimer, X
	BEQ loc_BANK3_A24D

	LDY #$D2

loc_BANK3_A24D:
	LDA iSpriteTempScreenX
	CLC
	ADC #$10
	STA iSpriteTempScreenX
	ASL zee
	ASL zee
	LDA zSpriteTimer, X
	CMP #$60
	BCS loc_BANK3_A262

	LSR zEnemyTrajectory, X

loc_BANK3_A262:
	TYA
	PHA
	JSR FindSpriteSlot

	STY zf4
	PLA
	JSR RenderSprite_DrawObject

	LDA zSpriteTimer, X
	BEQ loc_BANK3_A2D2

	LSR A
	LSR A
	LSR A
	LSR A
	LSR A
	BEQ locret_BANK3_A2D1

	TAY
	LDA zObjectXLo, X
	PHA
	CLC
	ADC loc_BANK3_A1D3 + 2, Y
	STA zObjectXLo, X
	SEC
	SBC iBoundLeftLower
	STA iSpriteTempScreenX
	LDA zObjectYLo, X
	CLC
	ADC byte_BANK3_A1D8, Y
	STA iSpriteTempScreenY
	LDA zSpriteTimer, X
	CMP #$30
	BCC loc_BANK3_A2AA

	CMP #$40
	BCS loc_BANK3_A2AA

	LSR A
	AND #$07
	TAY
	LDA iSpriteTempScreenY
	SEC
	SBC byte_BANK3_A1DC, Y
	STA iSpriteTempScreenY

loc_BANK3_A2AA:
	JSR sub_BANK2_8894

	LDY #$00
	STY zf4

	LDA zObjectAttributes, X
	PHA
	LDA #$02
	STA zObjectAttributes, X
	LDA i46e, X
	PHA
	LDA #%00010000
	STA i46e, X
	LDA #$D6
	JSR RenderSprite_DrawObject

	PLA
	STA i46e, X
	PLA
	STA zObjectAttributes, X
	PLA
	STA zObjectXLo, X

locret_BANK3_A2D1:
	RTS

; ---------------------------------------------------------------------------

loc_BANK3_A2D2:
	LDA z10
	AND #$04
	BEQ loc_BANK3_A2E1

	LDX zf4

	DEC iVirtualOAM + $C, X
	LDX z12
	RTS

; ---------------------------------------------------------------------------

loc_BANK3_A2E1:
	LDA zEnemyArray, X
	TAX
	DEC iVirtualOAM + 8, X
	LDX z12
	RTS

; ---------------------------------------------------------------------------

EnemyBehavior_ClawgripRock:
	LDA #$00
	STA iObjectFlashTimer, X
	JSR EnemyBehavior_CheckDamagedInterrupt

	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

	JSR ApplyObjectPhysicsX

	JSR ApplyObjectMovement_Vertical

	JSR ObjectTileCollision

	LDA zEnemyCollision, X
	AND #CollisionFlags_Right | CollisionFlags_Left
	BEQ loc_BANK3_A30A

	JSR EnemyBehavior_TurnAround

	JSR HalfObjectVelocityX

loc_BANK3_A30A:
	LDA zEnemyCollision, X
	AND #CollisionFlags_Down
	BEQ loc_BANK3_A320

	LDA zObjectYLo, X
	AND #$F0
	STA zObjectYLo, X
	LDA zObjectYVelocity, X
	LSR A
	EOR #$FF
	CLC
	ADC #$01
	STA zObjectYVelocity, X

loc_BANK3_A320:
	JMP RenderSprite

; ---------------------------------------------------------------------------

RenderSprite_ClawgripRock:
	LDA zHeldObjectTimer , X

	ORA iObjectStunTimer, X
	BNE loc_BANK3_A362

	LDA z10
	STA z00
	LDA zObjectXVelocity, X
	BPL loc_BANK3_A338

	EOR #$FF
	CLC
	ADC #$01

loc_BANK3_A338:
	CMP #$20
	BCS loc_BANK3_A344

	LSR z00
	CMP #$08
	BCS loc_BANK3_A344

	LSR z00

loc_BANK3_A344:
	LDA z00
	CLC
	ADC #$04
	AND #$08
	LSR A
	LSR A
	LSR A
	LDY zObjectXVelocity, X
	BPL loc_BANK3_A354

	EOR #$01

loc_BANK3_A354:
	STA zEnemyTrajectory, X
	LDA z00
	AND #$08
	ASL A
	ASL A
	ASL A
	ASL A
	ORA #$02
	STA zObjectAttributes, X

loc_BANK3_A362:
	JMP RenderSprite_NotAlbatoss


FlyingCarpetSpeed:
	.db $00
	.db $15
	.db $EB
	.db $00


EnemyBehavior_FlyingCarpet:
	JSR ObjectTileCollision

	LDA z10
	AND #$03
	BNE loc_BANK3_A37C

	DEC zEnemyArray, X
	BNE loc_BANK3_A37C

	STA iIsRidingCarpet
	JMP EnemyDestroy

; ---------------------------------------------------------------------------

loc_BANK3_A37C:
	LDA iIsRidingCarpet
	BEQ loc_BANK3_A38F

	LDA zPlayerYVelocity
	BPL loc_BANK3_A38F

	LDA #$00
	STA zObjectYVelocity, X
	STA iIsRidingCarpet
	JMP RenderSprite_FlyingCarpet

; ---------------------------------------------------------------------------

loc_BANK3_A38F:
	LDA zEnemyCollision, X
	AND #$20
	STA iIsRidingCarpet
	BNE loc_BANK3_A39B

	JMP loc_BANK3_A42A

; ---------------------------------------------------------------------------

loc_BANK3_A39B:
	LDA zObjectXVelocity, X
	BEQ loc_BANK3_A3A5

	LDA zEnemyTrajectory, X
	AND #$01
	STA zPlayerFacing

loc_BANK3_A3A5:
	LDA zObjectYLo, X
	SEC
	SBC #$1A
	STA zPlayerYLo
	LDA zObjectYHi, X
	SBC #$00
	STA zPlayerYHi
	LDA zPlayerXLo
	SEC
	SBC #$08
	STA zObjectXLo, X
	LDA zPlayerXHi
	SBC #$00
	STA zObjectXHi, X
	LDY #$01
	LDA zObjectXVelocity, X
	BMI loc_BANK3_A3C7

	LDY #$FF

loc_BANK3_A3C7:
	STY wCarpetVelocity
	LDA zInputCurrentState
	AND #ControllerInput_Right | ControllerInput_Left
	TAY
	AND zPlayerCollision

	BNE loc_BANK3_A3E6

	LDA FlyingCarpetSpeed, Y
	CMP zObjectXVelocity, X
	BEQ loc_BANK3_A3E3

	LDA zObjectXVelocity, X
	CLC
	ADC wCarpetVelocity, Y
	STA zObjectXVelocity, X

loc_BANK3_A3E3:
	JMP loc_BANK3_A3EA

; ---------------------------------------------------------------------------

loc_BANK3_A3E6:
	LDA #$00
	STA zObjectXVelocity, X

loc_BANK3_A3EA:
	LDY #$01
	LDA zObjectYVelocity, X
	BMI loc_BANK3_A3F2

	LDY #$FF

loc_BANK3_A3F2:
	STY wCarpetVelocity
	LDA #$20
	CMP iSpriteTempScreenY
	LDA #$00
	ROL A
	ASL A
	ASL A
	ASL A
	AND zInputCurrentState
	BNE loc_BANK3_A417

	LDA zEnemyCollision, X
	LSR A
	LSR A
	AND #$03
	STA z00
	LDA zInputCurrentState
	LSR A
	LSR A
	AND #$03
	TAY
	AND z00
	BEQ loc_BANK3_A41B

loc_BANK3_A417:
	LDA #$00
	BEQ loc_BANK3_A428

loc_BANK3_A41B:
	LDA FlyingCarpetSpeed, Y
	CMP zObjectYVelocity, X
	BEQ loc_BANK3_A42A

	LDA zObjectYVelocity, X
	CLC
	ADC wCarpetVelocity, Y

loc_BANK3_A428:
	STA zObjectYVelocity, X

loc_BANK3_A42A:
	JSR ApplyObjectPhysicsX

	JSR ApplyObjectPhysicsY

	LDA zEnemyArray, X
	CMP #$20
	BCS EnemyBehavior_FlyingCarpet_Render

	LDA z10
	AND #$02

loc_BANK3_A43A:
	BNE EnemyBehavior_FlyingCarpet_Render

	RTS

EnemyBehavior_FlyingCarpet_Render:
	JMP RenderSprite_FlyingCarpet


CreateFlyingCarpet:
	JSR CreateEnemy_TryAllSlots

	BMI CreateFlyingCarpet_Exit

	LDX z00
	LDY z12
	LDA #$00
	STA zObjectXVelocity, X
	STA zObjectYVelocity, X
	LDA #Enemy_FlyingCarpet
	STA zObjectType, X
	LDA zObjectXLo, Y
	SEC
	SBC #$08
	STA zObjectXLo, X
	LDA zObjectXHi, Y
	SBC #$00
	STA zObjectXHi, X
	LDA zObjectYLo, Y
	CLC
	ADC #$0E
	STA zObjectYLo, X
	LDA zObjectYHi, Y
	ADC #$00
	STA zObjectYHi, X
	JSR SetEnemyAttributes

	; life of carpet
	LDA #$A0
	STA zEnemyArray, X

CreateFlyingCarpet_Exit:
	LDX z12
	RTS


FlyingCarpetMirroring:
	.db $02
	.db $02
	.db $01
	.db $01

FlyingCarpetTilemapIndex:
	.db $04
	.db $0C
	.db $0C
	.db $04

PidgitYAcceleration:
	.db $01
	.db $FF

PidgitTurnYVelocity:
	.db $08
	.db $F8

PidgitXAcceleration:
	.db $01
	.db $FF

PidgitTurnXVelocity:
	.db $20
	.db $E0

PidgitDiveXVelocity:
	.db $14
	.db $EC


EnemyBehavior_Pidgit:
	JSR EnemyBehavior_CheckDamagedInterrupt

	INC zObjectAnimTimer, X
	LDA iObjectBulletTimer, X
	BEQ EnemyBehavior_Pidgit_Alive

	LDA zObjectAttributes, X
	ORA #ObjAttrib_UpsideDown
	STA zObjectAttributes, X
	JSR RenderSprite_Pidgit

	JMP ApplyObjectMovement

; ---------------------------------------------------------------------------

EnemyBehavior_Pidgit_Alive:
	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

	LDA zEnemyArray, X
	BEQ loc_BANK3_A4C1

	DEC zObjectYVelocity, X
	BPL loc_BANK3_A4BE

	LDA zObjectYLo, X
	CMP #$30
	BCS loc_BANK3_A4BE

	LDA #$00
	STA zEnemyArray, X
	STA zObjectXVelocity, X
	STA zObjectYVelocity, X
	DEC zSpriteTimer, X

loc_BANK3_A4BE:
	JMP loc_BANK3_A502

; ---------------------------------------------------------------------------

loc_BANK3_A4C1:
	LDA zSpriteTimer, X
	BNE loc_BANK3_A4D6

	LDA #$30
	STA zObjectYVelocity, X
	JSR EnemyFindWhichSidePlayerIsOn

	LDA PidgitDiveXVelocity, Y
	STA zObjectXVelocity, X
	INC zEnemyArray, X
	JMP RenderSprite_Pidgit

; ---------------------------------------------------------------------------

loc_BANK3_A4D6:
	LDA i480, X
	AND #$01
	TAY
	LDA zObjectYVelocity, X
	CLC
	ADC PidgitYAcceleration, Y
	STA zObjectYVelocity, X
	CMP PidgitTurnYVelocity, Y
	BNE loc_BANK3_A4EC

	INC i480, X

loc_BANK3_A4EC:
	LDA i477, X
	AND #$01
	TAY
	LDA zObjectXVelocity, X
	CLC
	ADC PidgitXAcceleration, Y
	STA zObjectXVelocity, X
	CMP PidgitTurnXVelocity, Y
	BNE loc_BANK3_A502

	INC i477, X

loc_BANK3_A502:
	JSR ApplyObjectPhysicsY

	JSR ApplyObjectPhysicsX


RenderSprite_Pidgit:
	JSR RenderSprite_NotAlbatoss

	LDA zEnemyState, X
	SEC
	SBC #$01
	ORA iObjectBulletTimer, X
	ORA zHeldObjectTimer, X
	BNE RenderSprite_Pidgit_Exit

	; Render Pidgit's carpet
	JSR FindSpriteSlot

	STY zf4

	LDA #ObjAttrib_Palette1 | ObjAttrib_Horizontal | ObjAttrib_16x32
	STA zObjectAttributes, X
	LDA zObjectXLo, X
	PHA
	SEC
	SBC #$08
	STA zObjectXLo, X
	LDA zObjectXHi, X
	PHA
	SBC #$00
	STA zObjectXHi, X
	JSR sub_BANK2_8894

	PLA
	STA zObjectXHi, X
	PLA
	STA zObjectXLo, X
	LDA iSpriteTempScreenY
	CLC
	ADC #$0C
	STA iSpriteTempScreenY
	LDA iSpriteTempScreenX
	SBC #$07
	STA iSpriteTempScreenX
	JSR RenderSprite_FlyingCarpet

	LDA #ObjAttrib_Palette1 | ObjAttrib_Horizontal | ObjAttrib_FrontFacing
	STA zObjectAttributes, X

RenderSprite_Pidgit_Exit:
	RTS


RenderSprite_FlyingCarpet:
	LDA z10
	LSR A
	LSR A
	LSR A
	AND #$03
	LDY zObjectXVelocity, X
	BMI loc_BANK3_A55F

	EOR #$03

loc_BANK3_A55F:
	TAY
	LDA FlyingCarpetMirroring, Y
	STA zEnemyTrajectory, X
	LDA FlyingCarpetTilemapIndex, Y
	JMP RenderSprite_DrawObject


EnemyInit_Mouser:
	JSR EnemyInit_Birdo

	LDA #$02
	LDY iCurrentWorldTileset
	BEQ EnemyInit_Mouser_SetHP

	LDA #$04

EnemyInit_Mouser_SetHP:
	STA iEnemyHP, X
	RTS

;
; Mouser
; ======
;
; Runs back and forth, throws bombs
;
; z10 = timer used for jumping and throwing
; iObjectFlashTimer = pauses Mouser when not $00
; zSpriteTimer = counter used to time throwing (wind up and pitch)
; zEnemyArray = counter used for movement direction and non-throw pauses
;
EnemyBehavior_Mouser:
	JSR EnemyBehavior_CheckDamagedInterrupt

	LDA iObjectFlashTimer, X
	BEQ EnemyBehavior_Mouser_Active

	JMP RenderSprite

EnemyBehavior_Mouser_Active:
	JSR ObjectTileCollision

	LDA #$02
	STA zEnemyTrajectory, X
	JSR RenderSprite

	LDA zEnemyCollision, X
	AND #CollisionFlags_Down
	BEQ EnemyBehavior_Mouser_Falling

	JSR ResetObjectYVelocity

	LDA z10
	AND #$FF
	BNE EnemyBehavior_Mouser_Move

EnemyBehavior_Mouser_Jump:
	LDA #$D8
	STA zObjectYVelocity, X
	BNE EnemyBehavior_Mouser_Falling

EnemyBehavior_Mouser_Move:
	LDA z10
	AND #$3F
	BNE loc_BANK3_A5AF

	; the wind-up
	LDA #$20
	STA zSpriteTimer, X

loc_BANK3_A5AF:
	LDY zSpriteTimer, X
	BNE EnemyBehavior_Mouser_MaybeThrow

	INC zEnemyArray, X
	LDA zEnemyArray, X
	AND #$20
	BEQ EnemyBehavior_Mouser_Exit

	INC zObjectAnimTimer, X
	INC zObjectAnimTimer, X
	LDY #$18 ; right
	LDA zEnemyArray, X
	AND #$40
	BNE EnemyBehavior_Mouser_PhysicsX

	LDY #$E8 ; left

EnemyBehavior_Mouser_PhysicsX:
	STY zObjectXVelocity, X
	JMP ApplyObjectPhysicsX

EnemyBehavior_Mouser_MaybeThrow:
	; the pitch
	CPY #$10
	BNE EnemyBehavior_Mouser_Exit

EnemyBehavior_Mouser_Throw:
	JSR CreateEnemy_TryAllSlots

	BMI EnemyBehavior_Mouser_Exit

	LDX z00
	LDA #Enemy_Bomb
	STA zObjectType, X
	LDA zObjectYLo, X
	ADC #$03
	STA zObjectYLo, X
	LDA #$E0 ; throw y-velocity
	STA zObjectYVelocity, X
	JSR SetEnemyAttributes

	LDA #$FF ; bomb fuse
	STA zSpriteTimer, X
	LDA #$E0 ; throw x-velocity
	STA zObjectXVelocity, X
	LDX z12

EnemyBehavior_Mouser_Exit:
	RTS

EnemyBehavior_Mouser_Falling:
	JMP ApplyObjectMovement_Vertical


RenderSprite_Mouser:
	LDA zEnemyState, X
	CMP #EnemyState_Alive
	BNE RenderSprite_Mouser_Hurt

	LDA iObjectFlashTimer, X
	BEQ RenderSprite_Mouser_Throw

	INC zObjectAnimTimer, X
	LDA #ObjAttrib_16x32 | ObjAttrib_FrontFacing | ObjAttrib_Palette2
	STA zObjectAttributes, X

RenderSprite_Mouser_Hurt:
	LDA #%10110011
	STA i46e, X
	LDA #$2C ; hurt sprite
	BNE RenderSprite_Mouser_DrawObject

RenderSprite_Mouser_Throw:
	LDY zSpriteTimer, X
	DEY
	CPY #$10
	BCS RenderSprite_Mouser_Walk

	LDA #$20 ; throwing sprite

RenderSprite_Mouser_DrawObject:
	JSR RenderSprite_DrawObject

	JMP RenderSprite_Mouser_Exit

RenderSprite_Mouser_Walk:
	JSR RenderSprite_NotAlbatoss

	LDA zSpriteTimer, X
	CMP #$10
	BCC RenderSprite_Mouser_Exit

RenderSprite_Mouser_Bomb:
	LDA #ObjAttrib_Palette1
	STA zObjectAttributes, X
	LDA #%00010000 ; use tilemap 2
	STA i46e, X
	LDA iSpriteTempScreenX
	CLC
	ADC #$0B
	STA iSpriteTempScreenX
	ASL zee
	LDY #$00
	STY zf4
	LDA #$38 ; could have been $34 from tilemap 1 instead
	JSR RenderSprite_DrawObject

RenderSprite_Mouser_Exit:
	; restore Mouser attributes after drawing the bomb
	LDA #ObjAttrib_16x32 | ObjAttrib_Palette3
	STA zObjectAttributes, X
	LDA #%00110011
	STA i46e, X
	RTS


; ---------------------------------------------------------------------------
byte_BANK3_A652:
	.db $FB
	.db $05
; ---------------------------------------------------------------------------

RenderSprite_Ostro:
	JSR RenderSprite_NotRocket

	LDA zee
	AND #$0E
	ORA zef
	ORA zEnemyArray, X
	BNE locret_BANK3_A67C

	LDA zObjectYLo, X
	SEC
	SBC #$02
	STA z00
	LDY zEnemyTrajectory, X
	LDA z01
	CLC
	ADC byte_BANK3_A652 - 1, Y
	STA z01
	JSR FindSpriteSlot

	LDX #$3C
	JSR SetSpriteTiles

	LDX z12

locret_BANK3_A67C:
	RTS

; ---------------------------------------------------------------------------

EnemyBehavior_Ostro:
	LDA zEnemyArray, X
	BNE loc_BANK3_A6DB

	LDA zHeldObjectTimer, X
	BEQ loc_BANK3_A6BD

	LDA #Enemy_ShyguyRed
	STA zObjectType, X
	JSR SetEnemyAttributes

	JSR CreateEnemy

	BMI locret_BANK3_A6BC

	LDY z00
	LDA #Enemy_Ostro
	STA zObjectType, Y
	STA zEnemyArray, Y
	LDA zObjectXLo, X
	STA zObjectXLo, Y
	LDA zObjectXHi, X
	STA zObjectXHi, Y
	LDA iEnemyRawDataOffset, X
	STA iEnemyRawDataOffset, Y
	LDA #$FF
	STA iEnemyRawDataOffset, X
	LDA zObjectXVelocity, X
	STA zObjectXVelocity, Y
	TYA
	TAX
	JSR SetEnemyAttributes

	LDX z12

locret_BANK3_A6BC:
	RTS

; ---------------------------------------------------------------------------

loc_BANK3_A6BD:
	LDA zEnemyCollision, X
	AND #$10
	BEQ loc_BANK3_A6DB

	INC zEnemyArray, X
	STA zObjectAnimTimer, X
	JSR CreateEnemy

	BMI loc_BANK3_A6DB

	LDY z00
	LDA zObjectXVelocity, X
	STA zObjectXVelocity, Y
	LDA #$20
	STA iSpriteTimer, Y
	JMP loc_BANK3_A6E1

; ---------------------------------------------------------------------------

loc_BANK3_A6DB:
	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

	JSR EnemyBehavior_CheckDamagedInterrupt

loc_BANK3_A6E1:
	JSR ObjectTileCollision

	LDA zEnemyCollision, X
	AND zEnemyTrajectory, X
	BEQ loc_BANK3_A6ED

	JSR EnemyBehavior_TurnAround

loc_BANK3_A6ED:
	LDA zEnemyCollision, X
	AND #$04
	BEQ loc_BANK3_A70D

	LDA iObjectBulletTimer, X
	BEQ loc_BANK3_A700

	LDA #$00
	STA iObjectBulletTimer, X
	JSR EnemyInit_BasicAttributes

loc_BANK3_A700:
	LDA zObjectAnimTimer, X
	EOR #$08
	STA zObjectAnimTimer, X
	JSR ResetObjectYVelocity

	LDA #$F0
	STA zObjectYVelocity, X

loc_BANK3_A70D:
	INC i477, X
	LDA zEnemyArray, X
	BNE loc_BANK3_A71E

	LDA i477, X
	AND #$3F
	BNE loc_BANK3_A71E

	JSR EnemyInit_BasicMovementTowardPlayer

loc_BANK3_A71E:
	JSR ApplyObjectMovement

	JMP RenderSprite

; ---------------------------------------------------------------------------

EnemyInit_Tryclyde:
	JSR EnemyInit_Basic

	LDA #$40
	STA i477, X
	LDA #$02
	STA iEnemyHP, X
	JMP EnemyInit_Birdo_Exit


TryclydeHeadPosition:
	.db $00
	.db $FF
	.db $FE
	.db $FD
	.db $FC
	.db $FB
	.db $FA
	.db $F9
	.db $F8
	.db $F9
	.db $FA
	.db $FB
	.db $FC
	.db $FD
	.db $FE
	.db $FF

TryclydeFireYVelocity:
	.db $0B
	.db $0C
	.db $0D
	.db $0F
	.db $10
	.db $12
	.db $14
	.db $17
	.db $1A
	.db $1D
	.db $1F
	.db $20

TryclydeFireXVelocity:
	.db $E2
	.db $E2
	.db $E2
	.db $E3
	.db $E4
	.db $E5
	.db $E7
	.db $E9
	.db $ED
	.db $F1
	.db $F8
	.db $00


locret_BANK3_A75C:
	RTS


;
; Tryclyde
; ========
;
; Drifts back and forth slightly, spits fire
;
; i477 = counter used to determine movement direction and top head position
; zEnemyArray = counter used to determine whether or not the bottom head should move
; iObjectFlashTimer = used to determine whether Tryclyde is taking damage
; i480 = counter used to determine bottom head position
;
EnemyBehavior_Tryclyde:
	JSR EnemyBehavior_CheckDamagedInterrupt

	LDY #$00
	LDA i477, X
	ASL A
	BCC EnemyBehavior_Tryclyde_PhysicsX

	LDY #$02
	ASL A
	BCC EnemyBehavior_Tryclyde_PhysicsX

	LDY #$FE

EnemyBehavior_Tryclyde_PhysicsX:
	STY zObjectXVelocity, X
	JSR ApplyObjectPhysicsX

	INC i477, X
	LDA zEnemyArray, X
	CLC
	ADC #$D0
	STA zEnemyArray, X
	BCC RenderSprite_Tryclyde

	INC i480, X

RenderSprite_Tryclyde:
	LDA zef
	BNE locret_BANK3_A75C

	LDA #ObjAttrib_16x32 | ObjAttrib_FrontFacing | ObjAttrib_Palette1
	STA zObjectAttributes, X
	LDY #$48 ; static head regular
	LDA zEnemyState, X
	SEC
	SBC #$01
	ORA iObjectFlashTimer, X
	STA z07
	BEQ RenderSprite_Tryclyde_DrawBody

	LDY #$4C ; static head hurt

RenderSprite_Tryclyde_DrawBody:
	TYA
	LDY #$30
	STY zf4
	JSR RenderSprite_DrawObject

	LDA #ObjAttrib_Palette1 | ObjAttrib_FrontFacing
	STA zObjectAttributes, X
	LDA #%00110011
	STA i46e, X
	LDA zObjectXLo, X
	PHA
	SEC
	SBC #$08
	STA zObjectXLo, X
	JSR sub_BANK2_8894

	LDX #$50 ; tail up
	LDA z10
	AND #$20
	BNE RenderSprite_Tryclyde_DrawTail

	LDA #$04
	AND z10
	BEQ RenderSprite_Tryclyde_DrawTail

	LDX #$53 ; tail down

RenderSprite_Tryclyde_DrawTail:
	; tail
	LDA z01
	SEC
	SBC #$08
	STA z01
	LDA #$20
	STA z0c
	LDY #$E0
	JSR SetSpriteTiles

	; top head
	LDX z12
	LDA zObjectXLo, X
	SEC
	SBC #$08
	STA zObjectXLo, X
	JSR sub_BANK2_8894

	PLA
	STA zObjectXLo, X
	LDA #%00010011
	STA i46e, X
	LDA zObjectYLo, X
	STA z00
	LDA i477, X
	AND #$78
	LSR A
	LSR A
	LSR A
	TAY
	LDA TryclydeHeadPosition, Y
	ADC iSpriteTempScreenX
	ADC #$F0
	STA z01
	LDX #$56
	LDA z07
	BNE RenderSprite_Tryclyde_DrawTopHead

	LDX #$58
	DEY
	DEY
	DEY
	DEY
	CPY #$07
	BCS RenderSprite_Tryclyde_DrawTopHead

	LDX #$5A

RenderSprite_Tryclyde_DrawTopHead:
	LDY #$00
	JSR SetSpriteTiles

	; bottom head
	LDX z12
	LDA zObjectYLo, X
	CLC
	ADC #$10
	STA z00
	LDA i480, X
	AND #$78
	LSR A
	LSR A
	LSR A
	TAY
	LDA TryclydeHeadPosition, Y
	ADC iSpriteTempScreenX
	ADC #$F0
	STA z01
	LDA #$00
	STA z0c
	LDX #$56
	LDA z07
	BNE RenderSprite_Tryclyde_DrawBottomHead

	LDX #$58
	DEY
	DEY
	DEY
	DEY
	CPY #$07
	BCS RenderSprite_Tryclyde_DrawBottomHead

	LDX #$5A

RenderSprite_Tryclyde_DrawBottomHead:
	LDY #$08
	JSR SetSpriteTiles

	LDX z12
	LDA #%00010011
	STA i46e, X
	LDA zee
	BNE EnemyBehavior_Tryclyde_SpitFireballs

RenderSprite_Tryclyde_DrawBottomNeck:
	LDA zObjectYLo, X
	CLC
	ADC #$10
	STA iVirtualOAM + $58
	LDA #$0D ; neck sprite
	STA iVirtualOAM + $59
	STA iVirtualOAM + $5D ; bottom neck
	LDA iVirtualOAM + $32
	STA iVirtualOAM + $5A
	STA iVirtualOAM + $5E ; bottom neck
	LDA z01
	CLC
	ADC #$10
	STA iVirtualOAM + $5B

RenderSprite_Tryclyde_DrawTopNeck:
	LDA zObjectYLo, X
	STA iVirtualOAM + $5C
	LDA iSpriteTempScreenX
	SEC
	SBC #$08
	STA iVirtualOAM + $5F

EnemyBehavior_Tryclyde_SpitFireballs:
	LDA #$00
	STA z05
	LDA i477, X
	JSR EnemyBehavior_Tryclyde_SpitFireball

	INC z05
	LDA i480, X

EnemyBehavior_Tryclyde_SpitFireball:
	AND #$67
	CMP #$40
	BNE RenderSprite_Tryclyde_Exit

	LDA iObjectFlashTimer, X
	BNE RenderSprite_Tryclyde_Exit

	JSR CreateEnemy

	BMI RenderSprite_Tryclyde_Exit

	LDA #SoundEffect3_Autobomb
	STA iNoiseSFX
	LDY z00
	LDA #Enemy_Fireball
	STA zObjectType, Y
	STA zObjectVariables, Y
	STA zEnemyArray, Y
	LDA zObjectXLo, X
	SBC #$18
	STA zObjectXLo, Y
	LDA z05
	BEQ EnemyBehavior_Tryclyde_GetFireAngle

	LDA zObjectYLo, X
	CLC
	ADC #$10
	STA zObjectYLo, Y

EnemyBehavior_Tryclyde_GetFireAngle:
	; angle the fireball based on the player's position
	LDA zPlayerXLo
	LSR A
	LSR A
	LSR A
	LSR A
	AND #$0F
	CMP #$0B
	BCC EnemyBehavior_Tryclyde_SetFireVelocity

	LDA #$0B

EnemyBehavior_Tryclyde_SetFireVelocity:
	TAX ; These may be fireball speed pointers
	LDA TryclydeFireYVelocity, X
	STA zObjectYVelocity, Y
	LDA TryclydeFireXVelocity, X
	STA zObjectXVelocity, Y

;
; Sets enemy attributes to defaults, restores X, and exits
;
; Input
;   Y = enemy index
; Output
;   X = enemy index
;
RenderSprite_Tryclyde_ResetAttributes:
	TYA
	TAX
	JSR SetEnemyAttributes

	LDX z12

RenderSprite_Tryclyde_Exit:
	RTS


EnemyInit_Cobrats:
	JSR EnemyInit_Basic

	LDA zObjectYLo, X
	SEC
	SBC #$08
	STA zObjectVariables, X
	RTS


;
; Cobrat (Ground)
; ===============
;
; Bobs up and down until the player gets close, then jumps up, chases, and shoots bullets
;
; zObjectVariables = target y-position
; i480 = flag that gets enabled when the player gets close
; i477 = counter used to determine bobbing direction
; zObjectAnimTimer = counter used to determine how quickly Cobrat turns
; iSpriteTimer = counter used to determine when to fire a bullet
;
EnemyBehavior_CobratGround:
	JSR EnemyBehavior_CheckDamagedInterrupt

	JSR EnemyBehavior_Check42FPhysicsInterrupt

	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

	JSR ObjectTileCollision

	LDA i480, X
	BNE EnemyBehavior_CobratGround_Jump

	STA zObjectXVelocity, X
	JSR EnemyFindWhichSidePlayerIsOn

	LDA z0f
	ADC #$40
	CMP #$80
	BCS EnemyBehavior_CobratGround_Bob

	INC i480, X
	LDA #$C0
	STA zObjectYVelocity, X
	BNE EnemyBehavior_CobratGround_Jump

EnemyBehavior_CobratGround_Bob:
	INC i477, X
	LDY #$FC
	LDA i477, X
	AND #$20
	BEQ EnemyBehavior_CobratGround_BobMovement

	LDY #$04

EnemyBehavior_CobratGround_BobMovement:
	STY zObjectYVelocity, X
	JSR ApplyObjectPhysicsY

	LDA #ObjAttrib_16x32 | ObjAttrib_BehindBackground | ObjAttrib_Palette1
	STA zObjectAttributes, X
	JMP RenderSprite

EnemyBehavior_CobratGround_Jump:
	LDA zObjectYVelocity, X
	BMI EnemyBehavior_CobratGround_Movement

	LDA zObjectVariables, X
	SEC
	SBC #$18
	CMP zObjectYLo, X
	BCS EnemyBehavior_CobratGround_Movement

	STA zObjectYLo, X
	LDA #$00
	STA zObjectYVelocity, X

EnemyBehavior_CobratGround_Movement:
	JSR ApplyObjectMovement

	INC zObjectAnimTimer, X
	LDA zObjectAnimTimer, X
	PHA
	AND #$3F
	BNE EnemyBehavior_CobratGround_AfterBasicMovement

	JSR EnemyInit_BasicMovementTowardPlayer

EnemyBehavior_CobratGround_AfterBasicMovement:
	PLA
	BNE EnemyBehavior_CobratGround_CheckCollision

	LDA #$18
	STA iSpriteTimer, X

EnemyBehavior_CobratGround_CheckCollision:
	LDA zEnemyCollision, X
	AND #$03
	BEQ EnemyBehavior_CobratGround_SetAttributes

	JSR EnemyBehavior_TurnAround

EnemyBehavior_CobratGround_SetAttributes:
	LDA #ObjAttrib_16x32 | ObjAttrib_Palette1
	LDY zObjectYVelocity, X
	BPL EnemyBehavior_CobratGround_Shoot

	LDA #ObjAttrib_16x32 | ObjAttrib_BehindBackground | ObjAttrib_Palette1

EnemyBehavior_CobratGround_Shoot:
	JMP EnemyBehavior_CobratJar_Shoot


;
; Cobrat (Jar)
; ============
;
; Bobs up and down, then occasionally jumps up to shoot a bullet at the player
;
; zObjectVariables = target y-position
; zEnemyArray = flag that gets set when the Cobrat jumps
; z10 = counter used to determine when to jump and fire
; iSpriteTimer = counter used to determine when to fire a bullet
;
EnemyBehavior_CobratJar:
	JSR EnemyBehavior_CheckDamagedInterrupt

	JSR EnemyBehavior_Check42FPhysicsInterrupt

	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

	JSR ObjectTileCollision

	LDA zEnemyCollision, X
	AND #CollisionFlags_Up
	BEQ EnemyBehavior_CobratJar_Uncorked

EnemyBehavior_CobratJar_Corked:
	LDA zObjectVariables, X
	STA zObjectYLo, X
	RTS

EnemyBehavior_CobratJar_Uncorked:
	JSR EnemyFindWhichSidePlayerIsOn

	INY
	STY zEnemyTrajectory, X

	LDA zEnemyArray, X
	BNE EnemyBehavior_CobratJar_Jump

	LDA zSpriteTimer, X
	BNE EnemyBehavior_CobratJar_Bob

	LDA #$D0
	STA zObjectYVelocity, X
	INC zEnemyArray, X
	JMP EnemyBehavior_CobratJar_Movement

EnemyBehavior_CobratJar_Bob:
	LDY #$FC
	LDA z10
	AND #$20
	BEQ EnemyBehavior_CobratJar_BobMovement

	LDY #$04

EnemyBehavior_CobratJar_BobMovement:
	STY zObjectYVelocity, X
	JSR ApplyObjectPhysicsY

	JMP EnemyBehavior_CobratJar_SetAttributes

EnemyBehavior_CobratJar_Jump:
	INC zObjectAnimTimer, X
	LDA zObjectYVelocity, X
	BMI EnemyBehavior_CobratJar_Movement

	BNE EnemyBehavior_CobratJar_CheckLanding

	LDA #$10
	STA iSpriteTimer, X

EnemyBehavior_CobratJar_CheckLanding:
	LDA zObjectYVelocity, X
	BMI EnemyBehavior_CobratJar_CheckReset

	LDA zEnemyCollision, X
	AND #CollisionFlags_Down
	BEQ EnemyBehavior_CobratJar_CheckReset

	LDA z0e
	SEC
	SBC #$6F
	CMP #$06
	BCC EnemyBehavior_CobratJar_CheckReset

EnemyBehavior_CobratJar_Blocked:
	LDA #EnemyState_Dead
	STA zEnemyState, X
	LDA #$E0
	STA zObjectYVelocity, X
	; jar blocked
	LDA #DPCM_BossHurt
	STA iDPCMSFX

EnemyBehavior_CobratJar_CheckReset:
	LDA zObjectVariables, X
	CMP zObjectYLo, X
	BCS EnemyBehavior_CobratJar_Movement

	STA zObjectYLo, X
	LDA #$00
	STA zEnemyArray, X
	LDA #$A0
	STA zSpriteTimer, X

EnemyBehavior_CobratJar_Movement:
	JSR ApplyObjectMovement_Vertical

EnemyBehavior_CobratJar_SetAttributes:
	LDA #ObjAttrib_16x32 | ObjAttrib_BehindBackground | ObjAttrib_Palette1

EnemyBehavior_CobratJar_Shoot:
	STA zObjectAttributes, X
	LDA iSpriteTimer, X
	BEQ EnemyBehavior_CobratJar_Render

	CMP #$05
	BNE EnemyBehavior_CobratJar_RenderShot

	JSR CreateBullet

EnemyBehavior_CobratJar_RenderShot:
	LDA #$64 ; firing bullet
	JMP RenderSprite_DrawObject

EnemyBehavior_CobratJar_Render:
	JMP RenderSprite


EnemyInit_Pokey:
	JSR EnemyInit_Basic

	LDA #$03
	STA zObjectVariables, X
	RTS


PokeyHitbox:
	.db $02
	.db $04
	.db $0D
	.db $0E


EnemyBehavior_Pokey:
	LDA zObjectVariables, X
	BNE loc_BANK3_AA2D

	JSR EnemyBehavior_CheckDamagedInterrupt

	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

	JSR EnemyBehavior_Check42FPhysicsInterrupt

loc_BANK3_AA2D:
	LDA zEnemyCollision, X
	AND #$10
	BEQ loc_BANK3_AA3A

	JSR sub_BANK3_AA3E

	INC iObjectBulletTimer, X
	RTS

; ---------------------------------------------------------------------------

loc_BANK3_AA3A:
	LDA zHeldObjectTimer, X
	BEQ loc_BANK3_AA99

; =============== S U B R O U T I N E =======================================

sub_BANK3_AA3E:
	LDA zObjectVariables, X
	BEQ loc_BANK3_AA99

	STA i477, X
	LDA #$00
	STA zObjectVariables, X
	LDA #$02
	STA iObjectHitbox, X
	LDA iEnemyRawDataOffset, X
	STA z06
	LDA #$FF
	STA iEnemyRawDataOffset, X
	JSR CreateEnemy

	BMI loc_BANK3_AA99

	LDY z00
	LDA #Enemy_Pokey
	STA zObjectType, Y
	JSR RenderSprite_Tryclyde_ResetAttributes

	LDY z00
	LDA z06
	STA iEnemyRawDataOffset, Y
	LDA i477, X
	SEC
	SBC #$01
	STA zObjectVariables, Y
	TAY

	LDA PokeyHitbox, Y
	LDY z00
	STA iObjectHitbox, Y
	LDA zObjectXLo, X
	STA zObjectXLo, Y
	LDA zObjectXHi, X
	STA zObjectXHi, Y
	LDA zObjectYLo, X
	CLC
	ADC #$10
	STA zObjectYLo, Y
	LDA zObjectYHi, X
	ADC #$00
	STA zObjectYHi, Y

loc_BANK3_AA99:
	INC zObjectAnimTimer, X
	LDA zObjectAnimTimer, X
	AND #$3F
	BNE loc_BANK3_AAA4

	JSR EnemyInit_BasicMovementTowardPlayer

loc_BANK3_AAA4:
	JSR ApplyObjectPhysicsX

	JMP RenderSprite

; End of function sub_BANK3_AA3E


PokeyWiggleOffset:
	.db $00
	.db $01
	.db $00
	.db $FF
	.db $00
	.db $01
	.db $00


RenderSprite_Pokey:
	LDY #$00
	LDA zee
	BNE RenderSprite_Pokey_Segments

	LDA z10
	AND #$18
	LSR A
	LSR A
	LSR A
	TAY

RenderSprite_Pokey_Segments:
	STY z07
	LDA iSpriteTempScreenX
	STA iPokeyTempScreenX
	CLC
	ADC PokeyWiggleOffset, Y
	STA iSpriteTempScreenX
	JSR RenderSprite_NotAlbatoss

	LDA zObjectVariables, X
	STA z09
	BEQ RenderSprite_Pokey_Exit

	TYA
	CLC
	ADC #$10
	TAY
	LDX z07
	LDA iPokeyTempScreenX
	ADC PokeyWiggleOffset + 1, X
	STA z01
	LDX #$70
	JSR SetSpriteTiles

	DEC z09
	BEQ RenderSprite_Pokey_Exit

	JSR FindSpriteSlot

	LDX z07
	LDA iPokeyTempScreenX
	CLC
	ADC PokeyWiggleOffset + 2, X
	STA z01
	LDX #$70
	JSR SetSpriteTiles

	DEC z09
	BEQ RenderSprite_Pokey_Exit

	LDX z07
	LDA iPokeyTempScreenX
	CLC
	ADC PokeyWiggleOffset + 3, X
	STA z01
	LDX #$70
	JSR SetSpriteTiles

RenderSprite_Pokey_Exit:
	LDX z12
	RTS


EnemyBehavior_Rocket:
	LDA zEnemyArray, X
	BNE EnemyBehavior_Rocket_Flying
	JMP EnemyBehavior_Rocket_Launching

EnemyBehavior_Rocket_Flying:
	LDY #$03
	LDA zObjectYVelocity, X
	BEQ EnemyBehavior_Rocket_Slow

	CMP #$FD
	BCC EnemyBehavior_Rocket_Fast

EnemyBehavior_Rocket_Slow:
	LDY #$3F
	INC iSpriteTempScreenX
	LDA z10
	AND #$02
	BNE EnemyBehavior_Rocket_Fast

	DEC iSpriteTempScreenX
	DEC iSpriteTempScreenX

EnemyBehavior_Rocket_Fast:
	TYA
	AND z10
	BNE EnemyBehavior_Rocket_ApplyPhysics

	DEC zObjectYVelocity, X

EnemyBehavior_Rocket_ApplyPhysics:
	JSR ApplyObjectPhysicsY

	LDA i477, X
	BNE EnemyBehavior_Rocket_DroppingOff

	LDY zObjectYHi, X
	BPL EnemyBehavior_Rocket_Render

	JSR DoAreaReset

	LDA #Enemy_Rocket
	STA iObjectToUseNextRoom
	INC iAreaTransitionID
	LDA #TransitionType_Rocket
	STA iTransitionType
	LDA #$00
	STA zPlayerState
	RTS

EnemyBehavior_Rocket_DroppingOff:
	LDA zObjectYLo, X
	CMP #$30
	BCS EnemyBehavior_Rocket_Render

	LDY iIsInRocket
	BNE EnemyBehavior_Rocket_DropPlayer

	CMP #$18
	BCS EnemyBehavior_Rocket_Render

	JMP EnemyBehavior_Bomb_Explode

EnemyBehavior_Rocket_DropPlayer:
	LDA #$00
	STA iIsInRocket
	STA zHeldItem
	STA zPlayerXVelocity
	LDA zObjectYLo, X
	ADC #$20
	STA zPlayerYLo
	STA iPlayerScreenY

EnemyBehavior_Rocket_Render:
	JSR RenderSprite_Rocket

	LDA iSpriteTempScreenX
	SEC
	SBC #$04
	STA iVirtualOAM + $93
	ADC #$07
	STA iVirtualOAM + $97
	ADC #$08
	STA iVirtualOAM + $9B

	LDA #$20 ; long trail
	LDY zObjectYVelocity, X
	CPY #$FD
	BMI EnemyBehavior_Rocket_RenderTrails

	LDA #$15 ; short trail

EnemyBehavior_Rocket_RenderTrails:
	ADC iSpriteTempScreenY
	STA iVirtualOAM + $90
	STA iVirtualOAM + $94
	STA iVirtualOAM + $98
	LDA #$8C
	STA iVirtualOAM + $91
	STA iVirtualOAM + $95
	STA iVirtualOAM + $99
	LDA z10
	LSR A
	AND #$03
	STA z00
	LSR A
	ROR A
	ROR A
	AND #$C0
	ORA z00
	STA iVirtualOAM + $92
	STA iVirtualOAM + $96
	STA iVirtualOAM + $9A
	RTS

EnemyBehavior_Rocket_Launching:
	; Wait until zHeldObjectTimer reaches 1 to start the boosters
	LDA zHeldObjectTimer, X
	CMP #$01
	BNE EnemyBehavior_Rocket_Carry

	; Setting zEnemyArray puts the rocket in the area
	STA zEnemyArray, X
	STA iIsInRocket
	LDA #SoundEffect3_Rocket
	STA iNoiseSFX
	LDA #$FE
	STA zObjectYVelocity, X

EnemyBehavior_Rocket_Carry:
	JSR CarryObject

RenderSprite_Rocket:
	LDA iSpriteTempScreenY
	STA z00
	LDA iSpriteTempScreenX
	SEC
	SBC #$08
	STA z01
	LDA #$02
	STA z02
	STA z05
	STA z0c
	LDA zObjectAttributes, X
	AND #$23
	STA z03
	LDY #$00
	LDX #$96
	JSR loc_BANK2_9C53

	LDA z01
	CLC
	ADC #$10
	STA z01
	DEC z02
	LDA iSpriteTempScreenY
	STA z00
	LDY #$10
	LDX #$96
	JMP loc_BANK2_9C53


; ---------------------------------------------------------------------------
byte_BANK3_AC25:
	.db $F0

byte_BANK3_AC26:
	.db $00
	.db $F0


; =============== S U B R O U T I N E =======================================

RenderSprite_Fryguy:
	LDA #$00
	STA zee
	LDA zObjectAnimTimer, X
	AND #$08
	LSR A
	LSR A
	LSR A
	STA z07
	LDY z07
	LDA iSpriteTempScreenX
	PHA
	CLC
	ADC byte_BANK3_AC25, Y
	STA iSpriteTempScreenX
	LDA #$80
	LDY iObjectFlashTimer, X
	BEQ loc_BANK3_AC4B

	LDA #$88

loc_BANK3_AC4B:
	JSR RenderSprite_DrawObject

	JSR FindSpriteSlot

	STY zf4
	PLA
	CLC
	LDY z07
	ADC byte_BANK3_AC26, Y
	STA iSpriteTempScreenX
	LDA #$84
	LDY iObjectFlashTimer, X
	BEQ loc_BANK3_AC67

	LDA #$8C

loc_BANK3_AC67:
	JMP RenderSprite_DrawObject


; ---------------------------------------------------------------------------

EnemyInit_Fryguy:
	JSR EnemyInit_Basic

	LDA #$04
	STA iEnemyHP, X
	LDA #$00
	STA zObjectVariables, X
	RTS

; ---------------------------------------------------------------------------
byte_BANK3_AC77:
	.db $E0
	.db $20
	.db $F0
	.db $10

byte_BANK3_AC7B:
	.db $04
	.db $0C
	.db $04
	.db $0C

byte_BANK3_AC7F:
	.db $04
	.db $04
	.db $0C
	.db $0C

byte_BANK3_AC83:
	.db $01
	.db $FF

byte_BANK3_AC85:
	.db $2A
	.db $D6

byte_BANK3_AC87:
	.db $01
	.db $FF

byte_BANK3_AC89:
	.db $18
	.db $E8
; ---------------------------------------------------------------------------

EnemyBehavior_Fryguy:
	LDA #$02
	STA zEnemyTrajectory, X
	INC zObjectAnimTimer, X
	LDY iEnemyHP, X
	DEY
	BNE loc_BANK3_ACE7

	LDA #$03
	STA z09
	STA iFryguySplitFlames
	JSR EnemyDestroy

loc_BANK3_ACA1:
	JSR CreateEnemy

	BMI loc_BANK3_ACE3

	LDY z00
	LDA zObjectYHi, X
	STA iEndOfLevelDoorPage, Y
	LDA #$F0
	STA zObjectYVelocity, Y
	LDA #Enemy_FryguySplit
	STA zObjectType, Y
	LDA #$30
	STA iSpriteTimer, Y
	LDA zObjectYLo, X
	PHA
	LDX z09
	LDA byte_BANK3_AC77, X
	STA zObjectXVelocity, Y
	LDA iSpriteTempScreenX
	ADC byte_BANK3_AC7B, X
	STA zObjectXLo, Y
	PLA
	ADC byte_BANK3_AC7F, X
	STA zObjectYLo, Y
	LDA #$00
	STA zObjectXHi, Y
	TYA
	TAX
	JSR SetEnemyAttributes

	LDX z12

loc_BANK3_ACE3:
	DEC z09
	BPL loc_BANK3_ACA1

loc_BANK3_ACE7:
	LDA z10
	AND #$1F
	BNE loc_BANK3_AD07

	JSR CreateEnemy

	LDX #DPCM_Fire
	STX iDPCMSFX
	LDX z00
	LDA #Enemy_Fireball
	STA zObjectType, X
	LDA zObjectXLo, X
	SBC #$08
	STA zObjectXLo, X
	LDA zObjectYLo, X
	ADC #$18
	STA zObjectYLo, X
	JSR EnemyInit_BasicAttributes

	LDX z12

loc_BANK3_AD07:
	LDA z10
	AND #$01
	BNE loc_BANK3_AD37

	LDA zObjectVariables, X
	AND #$01
	TAY
	LDA zObjectYVelocity, X
	CLC
	ADC byte_BANK3_AC87, Y
	STA zObjectYVelocity, X
	CMP byte_BANK3_AC89, Y
	BNE loc_BANK3_AD21

	INC zObjectVariables, X

loc_BANK3_AD21:
	LDA i477, X
	AND #$01
	TAY
	LDA zObjectXVelocity, X
	CLC
	ADC byte_BANK3_AC83, Y
	STA zObjectXVelocity, X
	CMP byte_BANK3_AC85, Y
	BNE loc_BANK3_AD37

	INC i477, X

loc_BANK3_AD37:
	JSR RenderSprite_Fryguy

	JSR ApplyObjectPhysicsY

	JMP ApplyObjectPhysicsX

FryguyFlame_JumpTimeout:
	.db $3F
	.db $3F
	.db $3F
	.db $7F

FryguyFlame_JumpVelocityY:
	.db $D4
	.db $D8
	.db $DA
	.db $DE


EnemyBehavior_FryguySplit:
	LDA zEnemyCollision, X
	AND #$10
	BEQ loc_BANK3_AD59

	; fry guy split
	JSR PlayBossHurtSound

	LDA #%00000000
	STA i46e, X
	JMP TurnIntoPuffOfSmoke

; ---------------------------------------------------------------------------

loc_BANK3_AD59:
	LDA #$02
	STA zEnemyTrajectory, X
	LDA z10
	STA iObjectShakeTimer, X
	INC zObjectAnimTimer, X
	INC zObjectAnimTimer, X
	JSR ObjectTileCollision

	JSR RenderSprite

	LDA zEnemyCollision, X
	PHA
	AND #CollisionFlags_Down
	BEQ loc_BANK3_AD7A

	JSR ResetObjectYVelocity

	LDA #$00
	STA zObjectXVelocity, X

loc_BANK3_AD7A:
	PLA
	AND #CollisionFlags_Right | CollisionFlags_Left
	BEQ loc_BANK3_AD85

	JSR EnemyBehavior_TurnAround

	JSR HalfObjectVelocityX

loc_BANK3_AD85:
	TXA
	ASL A
	ASL A
	ASL A
	ADC z10
	LDY iFryguySplitFlames
	AND FryguyFlame_JumpTimeout, Y
	ORA zObjectYVelocity, X
	BNE loc_BANK3_ADAB

	LDA iPRNGValue
	AND #$1F
	ORA FryguyFlame_JumpVelocityY, Y
	STA zObjectYVelocity, X
	JSR EnemyInit_BasicMovementTowardPlayer

	LDA iFryguySplitFlames
	CMP #$02
	BCS loc_BANK3_ADAB

	; Double x-velocity for the last flame
	ASL zObjectXVelocity, X

loc_BANK3_ADAB:
IFDEF REV_A
	LDA zPlayerState
	CMP #PlayerState_ChangingSize
	BEQ +
ENDIF

	JSR ApplyObjectPhysicsX

	JMP ApplyObjectMovement_Vertical

IFDEF REV_A
	+ RTS
ENDIF

; ---------------------------------------------------------------------------

EnemyBehavior_Autobomb:
	LDA zEnemyArray, X
	BNE loc_BANK3_ADF9

	LDA zEnemyCollision, X
	AND #$10
	ORA zHeldObjectTimer, X
	BEQ loc_BANK3_ADF9

	LDA #Enemy_ShyguyRed
	STA zObjectType, X
	JSR SetEnemyAttributes

	LDA iEnemyRawDataOffset, X
	STA z06
	LDA #$FF
	STA iEnemyRawDataOffset, X
	JSR CreateEnemy

	BMI loc_BANK3_ADF9

	LDY z00
	LDA z06
	STA iEnemyRawDataOffset, Y
	LDA zObjectXLo, X
	STA zObjectXLo, Y
	LDA zObjectXHi, X
	STA zObjectXHi, Y
	LDX z00
	LDA #Enemy_Autobomb
	STA zObjectType, X
	JSR EnemyInit_BasicAttributes

	INC zEnemyArray, X
	JSR SetEnemyAttributes

	LDA #$04
	STA iObjectHitbox, X
	LDX z12

loc_BANK3_ADF9:
	JSR EnemyBehavior_CheckDamagedInterrupt

	JSR ObjectTileCollision

	LDA zEnemyCollision, X
	PHA
	AND #CollisionFlags_Down
	BEQ loc_BANK3_AE09

	JSR ResetObjectYVelocity

loc_BANK3_AE09:
	PLA
	AND #CollisionFlags_Right | CollisionFlags_Left
	BEQ loc_BANK3_AE14

	JSR EnemyBehavior_TurnAround

	JSR ApplyObjectPhysicsX

loc_BANK3_AE14:
	INC zObjectAnimTimer, X
	LDA zEnemyArray, X
	BNE loc_BANK3_AE45

	TXA
	ASL A
	ASL A
	ASL A
	ASL A
	ADC z10
	AND #$7F
	BNE loc_BANK3_AE28

	JSR EnemyInit_BasicMovementTowardPlayer

loc_BANK3_AE28:
	LDA zObjectAnimTimer, X
	AND #%01111111
	BNE loc_BANK3_AE45

	JSR EnemyInit_BasicMovementTowardPlayer

	; which bullet?
	JSR CreateBullet

	BMI loc_BANK3_AE45

	LDX z00 ; X has the new enemy index
	LDA #Enemy_AutobombFire
	; Set the enemy type and attributes
	; BUG: The subroutine overwrites RAM_0 (enemy index)
	; Should have pushed it to stack instead.
	JSR EnemyBehavior_SpitProjectile

	LDX #SoundEffect3_Autobomb
	STX iNoiseSFX
	LDX z00
	DEC zObjectYLo, X
	DEC zObjectYLo, X
	LDX z12

loc_BANK3_AE45:
	JSR ApplyObjectMovement

	JMP RenderSprite

; ---------------------------------------------------------------------------

RenderSprite_Autobomb:
	LDA zEnemyState, X
	CMP #EnemyState_Alive
	BEQ loc_BANK3_AE5C

	LDA #ObjAttrib_Palette1 | ObjAttrib_16x32 | ObjAttrib_UpsideDown
	STA zObjectAttributes, X
	STA zObjectAnimTimer, X
	LDA #$76
	JMP RenderSprite_DrawObject

; ---------------------------------------------------------------------------

loc_BANK3_AE5C:
	LDA zEnemyArray, X
	BNE loc_BANK3_AE7C

	LDA zf4
	PHA
	LDA iSpriteTempScreenY
	CLC
	ADC #$F5
	STA iSpriteTempScreenY
	JSR FindSpriteSlot

	STY zf4
	LDA #$7C
	JSR RenderSprite_DrawObject

	PLA
	STA zf4

loc_BANK3_AE7C:
	LDA zObjectYLo, X
	STA iSpriteTempScreenY
	JSR RenderSprite_NotAlbatoss

	LDA #$02
	STA zEnemyTrajectory, X
	TYA
	CLC
	ADC #$08
	STA zf4
	LDA z00
	STA iSpriteTempScreenY
	LDA #%11010000
	STA i46e, X
	LDA #$78
	JSR RenderSprite_DrawObject

	LDA #$50
	LDY zEnemyArray, X
	BEQ loc_BANK3_AEA6

	LDA #%01010010

loc_BANK3_AEA6:
	STA i46e, X
	RTS

; ---------------------------------------------------------------------------

EnemyInit_WhaleSpout:
	JSR EnemyInit_Basic

	LDA zObjectYLo, X
	STA zEnemyArray, X
	RTS

; ---------------------------------------------------------------------------

EnemyBehavior_WhaleSpout:
	INC zObjectAnimTimer, X
	INC zObjectAnimTimer, X
	INC zObjectVariables, X
	LDA zObjectVariables, X
	CMP #$40
	BCS loc_BANK3_AEC3

	LDA #$E0
	STA zObjectYLo, X

locret_BANK3_AEC2:
	RTS

; ---------------------------------------------------------------------------

loc_BANK3_AEC3:
	BNE loc_BANK3_AECD

	LDA #$D0
	STA zObjectYVelocity, X
	LDA zEnemyArray, X
	STA zObjectYLo, X

loc_BANK3_AECD:
	LDA #SoundEffect3_ShortNoise
	STA iNoiseSFX
	LDA zObjectVariables, X
	CMP #$80
	BCC loc_BANK3_AEE6

	CMP #$DC
	BCS loc_BANK3_AEE6

	LDY #$03
	AND #$10
	BEQ loc_BANK3_AEE4

	LDY #$FB

loc_BANK3_AEE4:
	STY zObjectYVelocity, X

loc_BANK3_AEE6:
	INC zObjectYVelocity, X
	JSR ApplyObjectPhysicsY

RenderSprite_WhaleSpout:
	LDA zee
	AND #$C
	BNE locret_BANK3_AEC2

	LDA zObjectVariables, X
	STA z07
	LDA #$29
	STA zObjectAttributes, X
	LDA #$92
	LDY zObjectVariables, X
	CPY #$DC
	BCC loc_BANK3_AF03

	LDA #$94

loc_BANK3_AF03:
	JSR RenderSprite_DrawObject

	JSR FindSpriteSlot

	LDA #$55
	LDX z07
	CPX #$E0
	BCC loc_BANK3_AF13

	LDA #$3A

loc_BANK3_AF13:
	STA iVirtualOAM + 1, Y
	LDA #$55
	CPX #$E8
	BCC loc_BANK3_AF1E

	LDA #$3A

loc_BANK3_AF1E:
	STA iVirtualOAM + 5, Y
	LDA #$55
	CPX #$F0
	BCC loc_BANK3_AF29

	LDA #$3A

loc_BANK3_AF29:
	STA iVirtualOAM + 9, Y
	LDA #$55
	CPX #$F8
	BCC loc_BANK3_AF34

	LDA #$3A

loc_BANK3_AF34:
	STA iVirtualOAM + $D, Y
	LDX zf4
	LDA iVirtualOAM + 2, X
	STA iVirtualOAM + 2, Y
	STA iVirtualOAM + 6, Y
	STA iVirtualOAM + $A, Y
	STA iVirtualOAM + $E, Y
	LDA iSpriteTempScreenX
	CLC
	ADC #$04
	STA iVirtualOAM + 3, Y
	STA iVirtualOAM + 7, Y
	STA iVirtualOAM + $B, Y
	STA iVirtualOAM + $F, Y
	LDX z12
	LDA zObjectYLo, X
	CLC
	ADC #$F
	STA iVirtualOAM, Y
	ADC #$10
	STA iVirtualOAM + 4, Y
	ADC #$10
	STA iVirtualOAM + 8, Y
	ADC #$10
	STA iVirtualOAM + $C, Y

locret_BANK3_AF74:
	RTS

; ---------------------------------------------------------------------------
	.db $1C
byte_BANK3_AF76:
	.db $E4

	.db $01
	.db $FF
; ---------------------------------------------------------------------------

EnemyBehavior_Flurry:
	INC zObjectAnimTimer, X
	JSR EnemyBehavior_CheckDamagedInterrupt

	JSR EnemyBehavior_CheckBeingCarriedTimerInterrupt

	JSR ObjectTileCollision

	LDA zEnemyCollision, X
	AND #CollisionFlags_Right | CollisionFlags_Left
	BEQ loc_BANK3_AF8D

	JSR EnemyBehavior_TurnAround

loc_BANK3_AF8D:
	LDA zEnemyCollision, X
	AND #CollisionFlags_Down
	BEQ loc_BANK3_AFB4

	LDA zObjectYVelocity, X
	PHA
	JSR ResetObjectYVelocity

	PLA
	LDY iObjectBulletTimer, X
	BEQ loc_BANK3_AFB4

	CMP #$18
	BMI loc_BANK3_AFAC

	JSR HalfObjectVelocityX

	LDA #$F0
	STA zObjectYVelocity, X
	BNE loc_BANK3_AFDA

loc_BANK3_AFAC:
	LDA #$00
	STA iObjectBulletTimer, X
	JSR SetEnemyAttributes

loc_BANK3_AFB4:
	LDA z0e
	CMP #$16
	BEQ loc_BANK3_AFBF

	DEC zObjectAnimTimer, X
	JMP loc_BANK2_9470

; ---------------------------------------------------------------------------

loc_BANK3_AFBF:
	JSR EnemyFindWhichSidePlayerIsOn

	INY
	STY zEnemyTrajectory, X
	LDA z10
	AND #$01
	BNE loc_BANK3_AFDA

	LDA zObjectXVelocity, X
	CMP locret_BANK3_AF74, Y
	BEQ loc_BANK3_AFDA

	CLC
	ADC byte_BANK3_AF76, Y
	STA zObjectXVelocity, X
	INC zObjectAnimTimer, X

loc_BANK3_AFDA:
	JSR ApplyObjectMovement

	INC iObjectNonSticky, X
	JMP RenderSprite

; ---------------------------------------------------------------------------

EnemyInit_HawkmouthBoss:
	JSR EnemyInit_Hawkmouth ; Falls through to EnemyInit_Stationary

	LDA #$03
	STA iEnemyHP, X
	RTS

; ---------------------------------------------------------------------------
byte_BANK3_AFEC:
	.db $01
	.db $FF
byte_BANK3_AFEE:
	.db $28
	.db $D8
byte_BANK3_AFF0:
	.db $01
	.db $FF
byte_BANK3_AFF2:
	.db $10
	.db $F0
; ---------------------------------------------------------------------------

EnemyBehavior_HawkmouthBoss:
	JSR RenderSprite_HawkmouthBoss

	LDA #%00000110
	STA i46e, X
	LDA #$02
	STA wObjectInteractionTable + Enemy_HawkmouthBoss
	LDA iMaskDoorOpenFlag
	BEQ locret_BANK3_B05F

	CMP #$01
	BNE loc_BANK3_B01C

	STA i480, X
	LDA #$90
	STA zSpriteTimer, X
	LDA #$40
	STA iObjectStunTimer, X
	STA iObjectFlashTimer, X
	STA iMaskDoorOpenFlag

loc_BANK3_B01C:
	LDA i480, X
	CMP #$02
	BCC loc_BANK3_B09B

	LDA zEnemyArray, X
	BNE loc_BANK3_B03B

	INC i480, X
	LDA i480, X
	CMP #$31
	BNE HawkmouthEat

	LDA iSpriteTimer, X
	BNE loc_BANK3_B03B

	INC zEnemyArray, X
	JSR sub_BANK3_B095

loc_BANK3_B03B:
	DEC i480, X
	LDY i480, X
	DEY
	BNE HawkmouthEat

	DEC zEnemyArray, X
	LDA zPlayerState
	CMP #PlayerState_HawkmouthEating
	BNE HawkmouthEat

	LDA #TransitionType_Door
	STA iTransitionType
	JSR DoAreaReset

	LDA #$09
	STA zPlayerXHi
	INC iAreaTransitionID
	PLA
	PLA
	PLA
	PLA

locret_BANK3_B05F:
	RTS

; ---------------------------------------------------------------------------

HawkmouthEat:
	LDA i480, X ; Hawkmouth code?
	CMP #$30
	BNE locret_BANK3_B09A

	LDA zEnemyCollision, X ; make sure the player is inside Hawkmouth
	AND #CollisionFlags_PlayerInsideMaybe
	BEQ locret_BANK3_B09A

	LDA zHeldItem ; make sure player is not holding something
	BNE locret_BANK3_B09A

	STA zPlayerCollision ; start eating player
	INC zEnemyArray, X
	INC iMaskClosingFlag
	DEC i480, X
	LDA zObjectXLo, X
	STA zPlayerXLo
	LDA zObjectXHi, X
	STA zPlayerXHi
	LDA zObjectYLo, X
	ADC #$10
	STA zPlayerYLo
	LDA #PlayerState_HawkmouthEating
	STA zPlayerState
	LDA #$60
	STA zPlayerStateTimer
	LDA #$FC
	STA zPlayerYVelocity
	LDA #SoundEffect2_HawkDown
	STA iPulse1SFX
	RTS

; =============== S U B R O U T I N E =======================================

sub_BANK3_B095:
	LDA #SoundEffect2_HawkUp
	STA iPulse1SFX

locret_BANK3_B09A:
	RTS

; End of function sub_BANK3_B095

; ---------------------------------------------------------------------------

loc_BANK3_B09B:
	LDA #%00000011
	STA i46e, X
	LDA #$00
	STA wObjectInteractionTable + Enemy_HawkmouthBoss
	LDA iEnemyHP, X
	BNE loc_BANK3_B0BA

	LDA #$03 ; Hawkmouth Boss health?
	STA iEnemyHP, X
	JSR sub_BANK3_B095

	INC i480, X
	LDA #$FF
	STA iSpriteTimer, X

loc_BANK3_B0BA:
	LDA z10
	LSR A
	BCC loc_BANK3_B0E3

	LDA zObjectVariables, X
	AND #$01
	TAY
	LDA zObjectYVelocity, X
	CLC
	ADC byte_BANK3_AFF0, Y
	STA zObjectYVelocity, X
	CMP byte_BANK3_AFF2, Y
	BNE loc_BANK3_B0D3

	INC zObjectVariables, X

loc_BANK3_B0D3:
	JSR EnemyFindWhichSidePlayerIsOn

	LDA zObjectXVelocity, X
	CMP byte_BANK3_AFEE, Y
	BEQ loc_BANK3_B0E3

	CLC
	ADC byte_BANK3_AFEC, Y
	STA zObjectXVelocity, X

loc_BANK3_B0E3:
	JMP sub_BANK2_9430

; ---------------------------------------------------------------------------
byte_BANK3_B0E6:
	.db $F8
	.db $10

; =============== S U B R O U T I N E =======================================

RenderSprite_HawkmouthBoss:
	LDA i480, X
	JSR sub_BANK2_8E13

	LDA iMaskDoorOpenFlag
	BEQ loc_BANK3_B16D

	LDA zee
	AND #$0C
	BNE loc_BANK3_B16D

	; draw the back of Hawkmouth
	LDA zSpriteTimer, X
	STA z07
	JSR FindSpriteSlot

	LDX z02
	LDA iSpriteTempScreenX
	CLC
	ADC byte_BANK3_B0E6 - 1, X
	PHA
	PHP
	DEX
	BEQ loc_BANK3_B112

	PLA
	EOR #$01
	PHA

loc_BANK3_B112:
	PLP
	PLA
	BCC loc_BANK3_B16D

	STA iVirtualOAM + 3, Y
	STA iVirtualOAM + 7, Y
	STA iVirtualOAM + $B, Y
	STA iVirtualOAM + $F, Y
	LDX iDoorAnimTimer
	BEQ loc_BANK3_B129

	LDX #$10

loc_BANK3_B129:
	LDA iVirtualOAM, X
	STA iVirtualOAM, Y
	CLC
	ADC #$10
	STA iVirtualOAM + 4, Y
	LDA z07
	BEQ loc_BANK3_B13B

	LDA #$20

loc_BANK3_B13B:
	ORA iVirtualOAM + 2, X
	STA iVirtualOAM + 2, Y
	STA iVirtualOAM + 6, Y
	STA iVirtualOAM + $A, Y
	STA iVirtualOAM + $E, Y
	LDX zf4
	LDA iVirtualOAM, X
	STA iVirtualOAM + 8, Y
	CLC
	ADC #$10
	STA iVirtualOAM + $C, Y
	LDA #$F0
	STA iVirtualOAM + 1, Y
	LDA #$F2
	STA iVirtualOAM + 5, Y
	LDA #$F4
	STA iVirtualOAM + 9, Y
	LDA #$F6
	STA iVirtualOAM + $D, Y

loc_BANK3_B16D:
	LDX z12
	RTS


VegetableThrowerOffsetX:
	.db $08
	.db $28
	.db $48
	.db $28

VegetableThrowerOffsetY:
	.db $94
	.db $84
	.db $94
	.db $84

VegetableThrowerVelocity:
	.db $F8
	.db $08
	.db $F8
	.db $08
	.db $08
	.db $F8
	.db $08
	.db $F8


Generator_VegetableThrower:
	LDA zHeldItem
	BNE locret_BANK3_B1CC

	LDA z10
	AND #$FF
	BNE locret_BANK3_B1CC

	INC iVeggieShotCounter
	JSR CreateEnemy_TryAllSlots

	BMI locret_BANK3_B1CC

	LDX z00
	LDA iVeggieShotCounter
	AND #$07
	TAY
	LDA VegetableThrowerVelocity, Y
	STA zObjectXVelocity, X
	TYA
	AND #$03
	TAY
	LDA #$02
	STA zObjectXHi, X
	LDA VegetableThrowerOffsetX, Y
	STA zObjectXLo, X
	LDA VegetableThrowerOffsetY, Y
	STA zObjectYLo, X
	LDA #$00
	STA zObjectYHi, X
	LDA iPRNGValue
	AND #$03
	CMP #$02
	BCC loc_BANK3_B1C1

	ASL A
	STA zEnemyArray, X

loc_BANK3_B1C1:
	LDY #Enemy_VegetableLarge
	STY zObjectType, X
	JSR SetEnemyAttributes

	LDA #$D0
	STA zObjectYVelocity, X

locret_BANK3_B1CC:
	RTS

; ---------------------------------------------------------------------------

EnemyInit_Wart:
	JSR EnemyInit_Basic

	LDA #$06
	STA iEnemyHP, X
	LDA zObjectXHi, X
	STA iEndOfLevelDoorPage, X
	RTS


WartBubbleYVelocity:
	.db $E0
	.db $F0
	.db $E8
	.db $E4


;
; Wart
; ====
;
; Walks back and forth, spits bubbles
;
; zSpriteTimer = counter used to determing the bubble spit distance
; zObjectVariables = counter used to pause while walking back and forth
; i480 = counter used to determine the bubble spit height
; zEnemyArray = counter for death animation
; i477 = counter used for alternating steps
; iObjectFlashTimer = counter for blinking while hurt
;
EnemyBehavior_Wart:
	LDA zEnemyArray, X
	BNE EnemyBehavior_Wart_Death

	LDA iEnemyHP, X
	BNE EnemyBehavior_Wart_Alive

	; start the death sequence
	LDA #$80
	STA zSpriteTimer, X
	STA zEnemyArray, X
	BNE EnemyBehavior_Wart_Exit

EnemyBehavior_Wart_Alive:
	INC zObjectVariables, X
	LDA z10
	AND #%11111111
	BNE EnemyBehavior_Wart_Movement

	; spit bubbles
	LDA #$5F
	STA zSpriteTimer, X
	; counter that determines which index of WartBubbleYVelocity to use
	INC i480, X

EnemyBehavior_Wart_Movement:
	LDA #$00
	STA zObjectXVelocity, X

	; pause at the end of movement
	LDA zObjectVariables, X
	AND #%01000000
	BEQ EnemyBehavior_Wart_PhysicsX

	; increment animation timer
	INC i477, X
	LDA #$F8 ; left movement
	LDY zObjectVariables, X
	BPL EnemyBehavior_Wart_SetXVelocity

	LDA #$08 ; right movement

EnemyBehavior_Wart_SetXVelocity:
	STA zObjectXVelocity, X

EnemyBehavior_Wart_PhysicsX:
	JSR ApplyObjectPhysicsX

	LDA iObjectFlashTimer, X
	BNE EnemyBehavior_Wart_Exit

	LDA zSpriteTimer, X
	BEQ EnemyBehavior_Wart_Exit

	AND #$0F
	BNE EnemyBehavior_Wart_Exit

	; try to create a new enemy for the bubble
	JSR CreateEnemy

	BMI EnemyBehavior_Wart_Exit

	LDA #SoundEffect3_Bubbles
	STA iNoiseSFX
	; determines how high to spit the bubble
	LDA i480, X
	AND #$03
	TAY
	; determines how far to spit the bubble
	LDA zSpriteTimer, X

	; set up the bubble
	LDX z00
	LSR A
	EOR #$FF
	STA zObjectXVelocity, X
	LDA WartBubbleYVelocity, Y
	STA zObjectYVelocity, X
	LDA #Enemy_WartBubble
	STA zObjectType, X
	LDA zObjectYLo, X
	ADC #$08
	STA zObjectYLo, X
	JSR SetEnemyAttributes

	LDX z12

EnemyBehavior_Wart_Exit:
	JMP RenderSprite


EnemyBehavior_Wart_Death:
	LDA zSpriteTimer, X
	BEQ EnemyBehavior_Wart_DeathFall

	; going up
	STA iObjectFlashTimer, X
	INC i477, X
	INC i477, X
	LDA #$F0
	STA zObjectYVelocity, X
	BNE EnemyBehavior_Wart_Death_Exit

EnemyBehavior_Wart_DeathFall:
	LDA #$04
	STA zObjectXVelocity, X
	JSR ApplyObjectPhysicsX

	JSR ApplyObjectPhysicsY

	; every other frame
	LDA z10
	LSR A
	BCS EnemyBehavior_Wart_CheckDeathComplete

	INC zObjectYVelocity, X
	BMI EnemyBehavior_Wart_CheckDeathComplete

	LDA z10
	AND #$1F
	BNE EnemyBehavior_Wart_CheckDeathComplete

	LDA #SoundEffect3_WartSmokePuff
	STA iNoiseSFX
	JSR CreateEnemy

	LDX z00
	LDA zObjectYLo, X
	ADC #$08
	STA zObjectYLo, X
	JSR TurnIntoPuffOfSmoke

EnemyBehavior_Wart_CheckDeathComplete:
	LDA zObjectYLo, X
	CMP #$D0
	BCC EnemyBehavior_Wart_Death_Exit

	LDA #EnemyState_Dead
	STA zEnemyState, X

EnemyBehavior_Wart_Death_Exit:
	JMP RenderSprite


EnemyBehavior_WartBubble:
	INC zObjectAnimTimer, X
	JSR ApplyObjectPhysicsX

	JSR ApplyObjectPhysicsY

	INC zObjectYVelocity, X
	JMP RenderSprite

EnemyBehavior_WartBubble_Exit:
	RTS


RenderSprite_Wart:
	LDA zf4
	STA wMamuOAMOffsets + 2
	STA wMamuOAMOffsets + 6
	LDA z10
	AND #$03
	STA z07
	TAY
	LDA wMamuOAMOffsets, Y
	STA zf4
	LDA zef
	BNE EnemyBehavior_WartBubble_Exit

	LDY iEnemyHP, X
	BNE RenderSprite_Wart_AfterObjAttrib

	; he dead
	LDA iWartDefeated
	BNE RenderSprite_Wart_ObjAttrib

	LDA #Music_WartDeath
	STA iMusic
	INC iWartDefeated

RenderSprite_Wart_ObjAttrib:
	LDA #ObjAttrib_Horizontal | ObjAttrib_FrontFacing | ObjAttrib_16x32 | ObjAttrib_Palette2
	STA zObjectAttributes, X

RenderSprite_Wart_AfterObjAttrib:
	LDA zee
	PHA
	PHA
	LDY #$AE ; top row: shocked
	LDA zEnemyArray, X ; death counter
	BNE RenderSprite_Wart_TopHurt

	LDA iObjectFlashTimer, X ; enemy timer
	BEQ RenderSprite_Wart_TopRegular

	CMP #$30
	BCS RenderSprite_Wart_TopHurt

	AND #$08
	BNE RenderSprite_Wart_TopHurt

	LDY #$9E ; top row: blinking

RenderSprite_Wart_TopHurt:
	TYA
	BNE RenderSprite_Wart_DrawTop

RenderSprite_Wart_TopRegular:
	LDA #$9E ; top row: regular
	LDY zSpriteTimer, X
	BEQ RenderSprite_Wart_DrawTop

	LDA #$A2 ; top row: spitting

RenderSprite_Wart_DrawTop:
	JSR RenderSprite_DrawObject

	LDA z00
	STA iSpriteTempScreenY
	LDY z07
	LDA wMamuOAMOffsets + 1, Y
	STA zf4
	LDY #$A6 ; middle row: regular
	LDA zEnemyArray, X
	BNE RenderSprite_Wart_MiddleHurt

	LDA iObjectFlashTimer, X
	BEQ RenderSprite_Wart_MiddleRegular

	CMP #$30
	BCS RenderSprite_Wart_MiddleHurt

	AND #$08
	BNE RenderSprite_Wart_MiddleHurt

	BEQ RenderSprite_Wart_DrawMiddle

RenderSprite_Wart_MiddleRegular:
	LDA zSpriteTimer, X
	BEQ RenderSprite_Wart_DrawMiddle

RenderSprite_Wart_MiddleHurt:
	LDY #$AA ; middle row: spitting

RenderSprite_Wart_DrawMiddle:
	PLA
	STA zee
	TYA
	JSR RenderSprite_DrawObject

	LDA z00
	STA iSpriteTempScreenY
	LDY z07
	LDA wMamuOAMOffsets + 2, Y
	STA zf4
	LDY #$BA ; bottom row: standing
	LDA zObjectXVelocity, X
	BEQ RenderSprite_Wart_DrawBottom

	LDY #$B2 ; bottom row: left foot up
	LDA i477, X
	AND #$10
	BEQ RenderSprite_Wart_DrawBottom

	LDY #$B6 ; bottom row: right foot up

RenderSprite_Wart_DrawBottom:
	PLA
	STA zee
	TYA
	JSR RenderSprite_DrawObject

	LDA zee
	BNE RenderSprite_Wart_Exit

	; draw backside
	LDY z07
	LDX wMamuOAMOffsets + 2, Y
	LDA wMamuOAMOffsets + 3, Y
	TAY
	LDA iSpriteTempScreenX
	CLC
	ADC #$20
	BCS RenderSprite_Wart_Exit

	STA iVirtualOAM + 3, Y
	STA iVirtualOAM + 7, Y
	STA iVirtualOAM + $B, Y
	LDA z00
	SBC #$2F
	STA iVirtualOAM, Y
	ADC #$0F
	STA iVirtualOAM + 4, Y
	ADC #$10
	STA iVirtualOAM + 8, Y
	LDA iVirtualOAM + 2, X
	STA iVirtualOAM + 2, Y
	STA iVirtualOAM + 6, Y
	STA iVirtualOAM + $A, Y
	LDA #$19 ; top
	STA iVirtualOAM + 1, Y
	LDA #$1B ; middle
	STA iVirtualOAM + 5, Y
	LDA #$1D ; bottom
	STA iVirtualOAM + 9, Y

RenderSprite_Wart_Exit:
	LDX z12
	RTS


byte_BANK3_B4E0:
	.db $F0
	.db $10


;
; Determine whether the Hoopstar has reached the end of its climbable range.
;
; Output
;   C = whether or not the Hoopstar is on a climbable tile
;
EnemyBehavior_Hoopstar_Climb:
	JSR ClearDirectionalCollisionFlags

	TAY
	LDA zObjectYVelocity - 1, X
	BMI EnemyBehavior_Hoopstar_ClimbUp

EnemyBehavior_Hoopstar_ClimbDown:
	INY

EnemyBehavior_Hoopstar_ClimbUp:
	JSR EnemyBehavior_Hoopstar_CheckBackgroundTile

	BCS EnemyBehavior_Hoopstar_Climb_Exit

	LDA z00
	CMP #BackgroundTile_PalmTreeTrunk
	BEQ EnemyBehavior_Hoopstar_Climb_Exit

	CLC

EnemyBehavior_Hoopstar_Climb_Exit:
	DEX
	RTS


;
; Object/background collision that treats non-sky background tiles as solid,
; such as for Sparks and Mushroom Blocks
;
ObjectTileCollision_SolidBackground:
	LDA #$04
	BNE ObjectTileCollision_Main

;
; Normal object/background collision
;
ObjectTileCollision:
	LDA #$00

;
; Object Tile Collision
; =====================
;
; Handles object collision with background tiles
;
; Input
;   A = whether or not to treat walk-through tiles as solid
;   X = enemy index
; Output
;  zEnemyCollision, X = collision flags
;
ObjectTileCollision_Main:
	STA z07
	LDA #$00
	STA z0b
	STA z0e
	JSR ClearDirectionalCollisionFlags

	STA z08
	LDA zObjectYVelocity - 1, X
	BPL ObjectTileCollision_Downward

ObjectTileCollision_Upward:
	JSR CheckEnemyTileCollision

	INC z07
	INC z08
	BNE loc_BANK3_B57B

ObjectTileCollision_Downward:
	INC z07
	INC z08
	JSR CheckEnemyTileCollision

ObjectTileCollision_CheckQuicksand:
	LDA zObjectType - 1, X
	CMP #Enemy_CobratJar
	BEQ ObjectTileCollision_CheckConveyor

	CMP #Enemy_CobratSand
	BEQ ObjectTileCollision_CheckConveyor

	LDA z00
	SEC
	SBC #BackgroundTile_QuicksandSlow
	CMP #$02
	BCS ObjectTileCollision_CheckConveyor

	ASL A
	ADC #$01
	STA zObjectYVelocity - 1, X
	LDA #EnemyState_Sinking
	STA zEnemyState - 1, X
	LDA #$FF
	STA zSpriteTimer - 1, X

ObjectTileCollision_CheckConveyor:
	LDA z00
	STA z0e

	SEC
	SBC #BackgroundTile_ConveyorLeft
	CMP #$02
	BCS loc_BANK3_B57B

	LDY iObjectStunTimer - 1, X
	BNE loc_BANK3_B57B

	LDY zObjectType - 1, X
	CPY #Enemy_VegetableSmall
	BCC loc_BANK3_B56C

	TAY
	LDA zObjectYVelocity - 1, X
	CMP #$03
	BCS loc_BANK3_B57B

	LDA z0d
	AND #$03
	BNE loc_BANK3_B57B

	LDA byte_BANK3_B4E0, Y
	STA zObjectXVelocity - 1, X
	STA z0b
	BNE loc_BANK3_B57B

loc_BANK3_B56C:
	LDY zObjectXVelocity - 1, X
	BEQ loc_BANK3_B579

	EOR zEnemyTrajectory - 1, X
	LSR A
	BCS loc_BANK3_B579

	DEC zObjectAnimTimer - 1, X
	DEC zObjectAnimTimer - 1, X

loc_BANK3_B579:
	INC zObjectAnimTimer - 1, X

loc_BANK3_B57B:
	LDA zObjectXVelocity - 1, X
	CLC
	ADC iObjectXVelocity - 1, X
	BMI loc_BANK3_B587

	INC z07
	INC z08

loc_BANK3_B587:
	JSR CheckEnemyTileCollision

	DEX
	RTS



;
; Check collision attributes for the next two tiles
;
CheckEnemyTileCollision:
	LDY z08
	JSR sub_BANK3_BB87

	LDY z07
	LDA EnemyTileCollisionTable, Y
	TAY
	LDA z00
	JSR CheckTileUsesCollisionType_Bank3

	BCC CheckEnemyTileCollision_Exit

	LDY z07
	LDA EnemyEnableCollisionFlagTable, Y
	ORA zEnemyCollision - 1, X
	STA zEnemyCollision - 1, X

CheckEnemyTileCollision_Exit:
	INC z07
	INC z08
	RTS


;
; Resets directional collision flags and loads collision data pointer
;
; Input
;   X = enemy index
; Output
;   z0d = previous collision flags
;   zEnemyCollision = collision flags with up/down/left/right disabled
;   A = collision data pointer
;   X = X + 1
;
ClearDirectionalCollisionFlags:
	INX
	LDA zEnemyCollision - 1, X
	STA z0d
	AND #CollisionFlags_Damage | CollisionFlags_PlayerOnTop | CollisionFlags_PlayerInsideMaybe | CollisionFlags_80
	STA zEnemyCollision - 1, X
	LDY i492 - 1, X
	LDA TileCollisionHitboxIndex, Y

ClearDirectionalCollisionFlags_Exit:
	RTS


EnemyTileCollisionTable:
	.db $02 ; jumpthrough bottom (y-velocity < 0)
	.db $01 ; jumpthrough top (y-velocity > 0)
	.db $02 ; jumpthrough right (x-velocity < 0)
	.db $02 ; jumpthrough left (x-velocity > 0)
	.db $00 ; treat background as solid
	.db $00 ; treat background as solid
	.db $00 ; treat background as solid
	.db $00 ; treat background as solid



EnemyEnableCollisionFlagTable:
	.db CollisionFlags_Up
	.db CollisionFlags_Down
	.db CollisionFlags_Left
	.db CollisionFlags_Right
	.db CollisionFlags_Up
	.db CollisionFlags_Down
	.db CollisionFlags_Left
	.db CollisionFlags_Right


;
; Collision detection between objects
;
CheckObjectCollision:
	LDA #$00
	STA iObjectXVelocity, X
	LDA zEnemyCollision, X
	AND #CollisionFlags_Right | CollisionFlags_Left | CollisionFlags_Down | CollisionFlags_Up
	STA zEnemyCollision, X
	LDA zEnemyState, X
	CMP #EnemyState_BombExploding
	BNE CheckObjectCollision_NotExplosion

	LDY #$06 ; bomb explosion hitbox
	BNE CheckObjectCollision_ReadHitbox

CheckObjectCollision_NotExplosion:
	CMP #EnemyState_Sinking
	BEQ CheckObjectCollision_CheckObjectBeingCarried

	LDY zObjectType, X
	CPY #Enemy_Egg
	BEQ CheckObjectCollision_CheckObjectAlive

	CPY #Enemy_Pokey
	BEQ CheckObjectCollision_CheckObjectAlive

	LDY iObjectBulletTimer, X
	BNE CheckObjectCollision_CheckObjectBeingCarried

CheckObjectCollision_CheckObjectAlive:
	CMP #EnemyState_Alive
	BNE ClearDirectionalCollisionFlags_Exit

CheckObjectCollision_CheckObjectBeingCarried:
	LDA zHeldObjectTimer, X
	BNE ClearDirectionalCollisionFlags_Exit

	LDY iObjectHitbox, X

CheckObjectCollision_ReadHitbox:
	LDA wColBoxWidth, Y
	STA z09 ; hitbox width
	LDA #$00
	STA z00
	LDA wColBoxLeft, Y
	BPL CheckObjectCollision_ReadHitbox_Left

	DEC z00

CheckObjectCollision_ReadHitbox_Left:
	CLC
	ADC zObjectXLo, X
	STA z05 ; bounding box left low
	LDA zObjectXHi, X
	ADC z00
	STA z01 ; bounding box left high
	; Vertical levels wrap horizontally, so the high X position is discarded
	LDA zScrollCondition
	BNE CheckObjectCollision_ReadHitbox_Height

	STA z01

CheckObjectCollision_ReadHitbox_Height:
	LDA wColBoxHeight, Y
	STA z0b ; hitbox height
	LDA #$00
	STA z00
	LDA wColBoxTop, Y
	BPL CheckObjectCollision_ReadHitbox_Top

	DEC z00

CheckObjectCollision_ReadHitbox_Top:
	CLC
	ADC zObjectYLo, X
	STA z07 ; bounding box top low
	LDA zObjectYHi, X
	ADC z00
	STA z03 ; bounding box top high

CheckObjectCollision_Loop:
	STX zed
	TXA
	BNE CheckObjectCollision_OtherObject

	; X = 0
	LDA iIsInRocket
	ORA iPlayerLock
	BNE CheckObjectCollision_PlayerCollisionDisabled

	LDA zPlayerState, X
	CMP #PlayerState_Lifting
	BCC CheckObjectCollision_PlayerCollisionEnabled

CheckObjectCollision_PlayerCollisionDisabled:
	JMP CheckObjectCollision_Next

CheckObjectCollision_PlayerCollisionEnabled:
	LDY z12
	LDA iObjectBulletTimer, Y
	BEQ CheckObjectCollision_ReadPlayerHitbox

	; Post-throw grace period
	CMP #$20
	BCC CheckObjectCollision_PlayerCollisionDisabled

CheckObjectCollision_ReadPlayerHitbox:
	LDY zPlayerHitBoxHeight
	JMP CheckObjectCollision_OtherObjectReadHitbox


CheckObjectCollision_OtherObject:
	LDY z12
	LDA zEnemyState, Y
	CMP #EnemyState_BombExploding
	BEQ CheckObjectCollision_CheckOtherObjectState

	; Check if collision is disabled
	LDA i46e, Y
	AND #%00000100
	BNE CheckObjectCollision_NextIfNotEqual ; effectively `JMP CheckObjectCollision_Next`

CheckObjectCollision_CheckOtherObjectState:
	LDA zEnemyState - 1, X
	CMP #EnemyState_BombExploding ; what does this mean for an enemy?
	BNE CheckObjectCollision_OtherObjectNotExplosion

	LDY #$06 ; bomb explosion hitbox
	BNE CheckObjectCollision_OtherObjectReadHitbox

CheckObjectCollision_OtherObjectNotExplosion:
	CMP #EnemyState_Sinking
	BEQ CheckObjectCollision_CheckOtherObjectBeingCarried

	LDY zObjectType - 1, X
	CPY #Enemy_Egg
	BEQ CheckObjectCollision_CheckOtherObjectAlive

	CPY #Enemy_Pokey
	BEQ CheckObjectCollision_CheckOtherObjectAlive

CheckObjectCollision_CheckOtherObjectAlive:
	CMP #EnemyState_Alive
CheckObjectCollision_NextIfNotEqual:
	BNE CheckObjectCollision_Next

CheckObjectCollision_CheckOtherObjectBeingCarried:
	LDA zHeldObjectTimer - 1, X
	BNE CheckObjectCollision_Next

	LDA zEnemyCollision - 1, X
	AND #CollisionFlags_Damage
	BNE CheckObjectCollision_Next

	LDA i46e - 1, X
	AND #$04
	BNE CheckObjectCollision_Next

	LDY iObjectHitbox - 1, X

CheckObjectCollision_OtherObjectReadHitbox:
	LDA wColBoxWidth, Y
	STA z0a ; hitbox width
	LDA #$00
	STA z00
	LDA wColBoxLeft, Y
	BPL CheckObjectCollision_OtherObjectReadHitbox_Left

	DEC z00

CheckObjectCollision_OtherObjectReadHitbox_Left:
	CLC
	ADC zObjectXLo - 1, X
	STA z06 ; bounding box left low
	LDA zObjectXHi - 1, X
	ADC z00
	STA z02 ; bounding box left high
	; Vertical levels wrap horizontally, so the high X position is discarded
	LDA zScrollCondition
	BNE CheckObjectCollision_OtherObjectReadHitbox_Height

	STA z02

CheckObjectCollision_OtherObjectReadHitbox_Height:
	LDA wColBoxHeight, Y
	STA z0c ; hitbox height
	LDA #$00
	STA z00
	LDA wColBoxTop, Y
	BPL CheckObjectCollision_OtherObjectReadHitbox_Top

	DEC z00

CheckObjectCollision_OtherObjectReadHitbox_Top:
	CLC
	ADC zObjectYLo - 1, X
	STA z08 ; bounding box top low
	LDA zObjectYHi - 1, X
	ADC z00
	STA z04 ; bounding box top high

	JSR CheckHitboxCollision

	BCS CheckObjectCollision_Next

	LDA z0b
	PHA
	JSR EnemyCollisionBehavior

	PLA
	STA z0b

CheckObjectCollision_Next:
	DEX
	BMI CheckObjectCollision_RestoreObjectSlotExit

	JMP CheckObjectCollision_Loop

CheckObjectCollision_RestoreObjectSlotExit:
	LDX z12

CheckObjectCollision_Exit:
	RTS


;
; Run the player/object collision handler
;
EnemyCollisionBehavior:
	TXA
	BNE EnemyCollisionBehavior_ReadCollisionType

	LDA zHeldItem
	BEQ EnemyCollisionBehavior_ReadCollisionType

	LDA iHeldItemIndex
	CMP z12
	BEQ CheckObjectCollision_Exit

EnemyCollisionBehavior_ReadCollisionType:
	LDY z12
	LDA zObjectType, Y
	TAY
	LDA wObjectInteractionTable, Y
	JSR JumpToTableAfterJump

	.dw EnemyCollisionBehavior_Enemy
	.dw EnemyCollisionBehavior_ProjectileItem
	.dw EnemyCollisionBehavior_Object
	.dw EnemyCollisionBehavior_POW
	.dw EnemyCollisionBehavior_Door


EnemyCollisionBehavior_Door:
	TXA
	BNE EnemyCollisionBehavior_Exit

	LDA zInputBottleneck
	AND #ControllerInput_Up
	BEQ EnemyCollisionBehavior_Exit

	LDA zPlayerCollision
	AND #CollisionFlags_Down
	BEQ EnemyCollisionBehavior_Exit

	LDA iCollisionResultX
	CMP #$FA
	BCS EnemyCollisionBehavior_Exit

	LDA iDoorAnimTimer
	ORA iSubDoorTimer
	BNE EnemyCollisionBehavior_Exit

	LDA zHeldItem
	BEQ loc_BANK3_B749

	LDY iHeldItemIndex
	LDA zObjectType, Y
	CMP #Enemy_Key
	BNE EnemyCollisionBehavior_Exit

loc_BANK3_B749:
	LDY z12
	LDA zObjectXLo, Y
	STA zPlayerXLo
	LDA zObjectXHi, Y
	STA zPlayerXHi
	JSR StashPlayerPosition

	LDA #TransitionType_SubSpace
	STA iTransitionType
	JMP DoorHandling_GoThroughDoor_Bank3

EnemyCollisionBehavior_Exit:
	RTS


EnemyCollisionBehavior_Enemy:
	LDY z12
	TXA
	BNE EnemyCollisionBehavior_FlashingTimer
	JMP CheckCollisionWithPlayer

EnemyCollisionBehavior_FlashingTimer:
	;;;
	LDA iObjectFlashTimer, Y
	ORA iObjectFlashTimer - 1, X
	BNE EnemyCollisionBehavior_Exit

	LDA iObjectBulletTimer, Y
	BNE loc_BANK3_B792

	LDA zEnemyState, Y
	CMP #EnemyState_BombExploding
	BEQ loc_BANK3_B792

	TXA
	TAY
	DEY
	LDX z12
	INX
	LDA zEnemyState, Y
	CMP #EnemyState_BombExploding
	BEQ loc_BANK3_B792

	LDA iObjectBulletTimer, Y
	BEQ loc_BANK3_B7E0

	LDA zEnemyCollision - 1, X
	AND #CollisionFlags_Damage
	BNE loc_BANK3_B7E0

loc_BANK3_B792:
	LDA iSpriteTimer, Y
	ORA iObjectFlashTimer, Y
	BNE loc_BANK3_B7D7

	LDA i46e, Y
	AND #%00001000
	BEQ loc_BANK3_B7A4

	JSR PlayBossHurtSound

loc_BANK3_B7A4:
	LDA iEnemyHP, Y
	SEC
	SBC #$01
	STA iEnemyHP, Y
	BMI loc_BANK3_B7BD

	JSR PlayBossHurtSound

	LDA #$21
	STA iObjectFlashTimer, Y
	LSR A
	STA iObjectStunTimer, Y
	BNE loc_BANK3_B7D7

loc_BANK3_B7BD:
	LDA zEnemyCollision, Y
	ORA #CollisionFlags_Damage
	STA zEnemyCollision, Y
	LDA #$E0
	STA zObjectYVelocity, Y
	LDA zObjectXVelocity, Y
	STA z00
	ASL A
	ROR z00
	LDA z00
	STA zObjectXVelocity, Y

loc_BANK3_B7D7:
	LDA zObjectType - 1, X
	CMP #Enemy_VegetableSmall
	BCS loc_BANK3_B7E0

	JSR sub_BANK3_BA5D

loc_BANK3_B7E0:
	LDX zed
	RTS

; ---------------------------------------------------------------------------
InvincibilityKill_VelocityX:
	.db $F8 ; to the left
	.db $08 ; to the right
; ---------------------------------------------------------------------------

CheckCollisionWithPlayer:
	LDA zee
	AND #CollisionFlags_Up
	BNE CheckCollisionWithPlayer_Exit

	; check if it's a heart
	LDA zObjectType, Y
	BNE CheckCollisionWithPlayer_NotHeart

	; accept the heart into your life
	STA zEnemyState, Y
	LDA #Hill_Cherry
	STA iHillSFX
	LDY iPlayerMaxHP
	LDA iPlayerHP
	CLC
	ADC #$10
	STA iPlayerHP
	CMP PlayerHealthValueByHeartCount, Y
	BCC CheckCollisionWithPlayer_Exit

	JMP RestorePlayerToFullHealth

; ---------------------------------------------------------------------------

CheckCollisionWithPlayer_NotHeart:
	CMP #Enemy_Phanto
	BNE CheckCollisionWithPlayer_NotPhanto

	LDY iPhantoTimer
	BNE CheckCollisionWithPlayer_Exit

CheckCollisionWithPlayer_NotPhanto:
	CMP #Enemy_Starman
	BNE CheckCollisionWithPlayer_NotStarman

IFNDEF STATS_TESTING_PURPOSES
	LDA #$3F
ELSE
	LDA #$FF
ENDIF
	STA iStarTimer
	LDA #Music_Invincible
	STA iMusic
	LDA #EnemyState_Inactive
	STA zEnemyState, Y

CheckCollisionWithPlayer_Exit:
	RTS

; ---------------------------------------------------------------------------

CheckCollisionWithPlayer_NotStarman:
	CMP #Enemy_WhaleSpout
	BNE CheckCollisionWithPlayer_NotWhaleSpout

	LDA zObjectVariables, Y
	CMP #$DC
	BCS CheckCollisionWithPlayer_Exit2

	LDA iStarTimer
	BEQ CheckCollisionWithPlayer_NotInvincible

	LDA #$DC
	STA zObjectVariables, Y
	LDA #$00
	STA zObjectYVelocity, Y

CheckCollisionWithPlayer_Exit2:
	RTS

; ---------------------------------------------------------------------------

CheckCollisionWithPlayer_NotWhaleSpout:
	CMP #Enemy_Wart
	BNE CheckCollisionWithPlayer_NotWart

	LDA zEnemyArray, X
	BNE CheckCollisionWithPlayer_Exit2

CheckCollisionWithPlayer_NotWart:
	LDY iStarTimer
	BEQ CheckCollisionWithPlayer_NotInvincible

	; player is invincible
	LDX z12
	CMP #Enemy_AutobombFire
	BEQ CheckCollisionWithPlayer_Poof

	CMP #Enemy_Fireball
	BNE CheckCollisionWithPlayer_KillEnemy

; turn into a puff of smoke
CheckCollisionWithPlayer_Poof:
	LDA #%00000000
	STA i46e, X
	JSR EnemyBehavior_Shell_Destroy

	JMP loc_BANK3_B878

; ---------------------------------------------------------------------------

; die and fall off
CheckCollisionWithPlayer_KillEnemy:
	JSR EnemyFindWhichSidePlayerIsOn

	LDA InvincibilityKill_VelocityX, Y
	STA zObjectXVelocity, X
	LDA #$E0
	STA zObjectYVelocity, X
	LDA zEnemyCollision, X
	ORA #CollisionFlags_Damage
	STA zEnemyCollision, X

loc_BANK3_B878:
	LDX zed
	LDY z12
	RTS

; ---------------------------------------------------------------------------

CheckCollisionWithPlayer_NotInvincible:
	LDY z12
	LDA zEnemyState, Y
	CMP #EnemyState_BombExploding
	BEQ CheckCollisionWithPlayer_HurtPlayer

	; should we damage the player for jumping on top?
	LDA i46e, Y
	AND #%00000001
	BNE CheckCollisionWithPlayer_HurtPlayer

	; let player land on top
	JSR DetermineCollisionFlags

	LDA z0f
	AND #$0B
	BEQ CheckCollisionWithPlayer_StandingOnHead

CheckCollisionWithPlayer_HurtPlayer:
	JMP DamagePlayer


CheckCollisionWithPlayer_StandingOnHead:
	LDA #$00
	STA zPlayerGrounding
	LDX z12
	LDA zEnemyCollision, X
	ORA #CollisionFlags_PlayerOnTop
	STA zEnemyCollision, X

	; can you even lift
	LDA i46e, X
	AND #%00000010
	BNE CheckCollisionWithPlayer_NoLift

	; check B button
	BIT zInputBottleneck
	BVC CheckCollisionWithPlayer_NoLift

	; bail if we already have an item or are ducking
	LDA zHeldItem
	ORA zPlayerHitBoxHeight
	BNE CheckCollisionWithPlayer_NoLift

	STA zEnemyCollision, X
	STX iHeldItemIndex
	STA iObjectShakeTimer, X
	LDA #$07
	STA zHeldObjectTimer, X
	JSR SetPlayerStateLifting

	; leave a flying carpet behind if we're picking up pidgit
	LDA zObjectType, X
	CMP #Enemy_Pidgit
	BNE CheckCollisionWithPlayer_NoLift

	JSR CreateFlyingCarpet

CheckCollisionWithPlayer_NoLift:
	LDX zed
	RTS

; End of function CheckCollisionWithPlayer_StandingOnHead

; ---------------------------------------------------------------------------

EnemyCollisionBehavior_Object:
	LDY z12
	TXA
	BEQ loc_BANK3_B905

	LDA zObjectType, Y
	CMP #Enemy_Key
	BNE loc_BANK3_B8E4

	LDA zEnemyCollision, Y
	AND #CollisionFlags_Down
	BNE locret_BANK3_B902

loc_BANK3_B8E4:
	LDA iObjectBulletTimer, Y
	BNE loc_BANK3_B8FF

	JSR DetermineCollisionFlags

	LDA z0f
	AND zEnemyTrajectory - 1, X
	BEQ loc_BANK3_B8F8

	DEX
	JSR EnemyBehavior_TurnAround

	LDX zed

loc_BANK3_B8F8:
	JSR sub_BANK3_BB31

	CPY #$00
	BEQ locret_BANK3_B902

loc_BANK3_B8FF:
	JMP loc_BANK3_B9EA

; ---------------------------------------------------------------------------

locret_BANK3_B902:
	RTS


CheckCollisionDirectionTable:
	.db CollisionFlags_Up ; down
	.db CollisionFlags_Down ; up


; collision with items that the player can stand on
loc_BANK3_B905:
	LDA zEnemyCollision, Y
	ORA #CollisionFlags_PlayerInsideMaybe
	STA zEnemyCollision, Y
	JSR DetermineCollisionFlags

	LDA z0f
	AND zPlayerTrajectory
	BEQ loc_BANK3_B919

	JSR PlayerHorizontalCollision

loc_BANK3_B919:
	LDA z0f
	AND #%00000100
	BEQ loc_BANK3_B922

	JSR CheckCollisionWithPlayer_StandingOnHead

loc_BANK3_B922:
	JSR sub_BANK3_BB31

	CPY #$01
	BNE locret_BANK3_B955

	LDY z12
	LDA zObjectYVelocity, Y
	BEQ locret_BANK3_B955

	AND #%10000000
	ASL A
	ROL A
	TAY
	LDA z0f
	AND CheckCollisionDirectionTable, Y
	BEQ locret_BANK3_B955

	; Reverse the y-velocity of the object
	LDY z12
	LDA zObjectYVelocity, Y
	EOR #$FF
	CLC
	ADC #$01
	STA zObjectYVelocity, Y

	; Force the player into a ducking position
	LDA #$01
	STA zPlayerHitBoxHeight
	LDA #$04
	STA zPlayerAnimFrame
	LDA #$10
	STA zPlayerStateTimer

locret_BANK3_B955:
	RTS

EnemyCollisionBehavior_POW:
	TXA
	BEQ locret_BANK3_B955
	JMP loc_BANK3_B9EA

EnemyCollisionBehavior_ProjectileItem:
	LDY z12
	TXA

loc_BANK3_B95F:
	BNE loc_BANK3_B993

	LDA zEnemyState, Y

loc_BANK3_B964:
	CMP #$04
	BNE loc_BANK3_B96E

	LDA iStarTimer
	BEQ loc_BANK3_B990

locret_BANK3_B96D:
	RTS

; ---------------------------------------------------------------------------

loc_BANK3_B96E:
	JSR DetermineCollisionFlags

	LDA z0f
	AND #$08
	BEQ loc_BANK3_B987

	LDA zHeldItem
	BNE locret_BANK3_B96D

	LDY z12
	STY iHeldItemIndex
	LDA #$01
	STA zHeldObjectTimer, Y
	INC zHeldItem

loc_BANK3_B987:
	LDA z0f
	AND #$04
	BEQ locret_BANK3_B96D

	JMP CheckCollisionWithPlayer_StandingOnHead

; ---------------------------------------------------------------------------

loc_BANK3_B990:
	JMP DamagePlayer

; ---------------------------------------------------------------------------

loc_BANK3_B993:
	LDA zObjectType - 1, X
	CMP #Enemy_Wart
	BNE loc_BANK3_B9B7

	LDA zSpriteTimer - 1, X
	BEQ locret_BANK3_B9F9

	LDA #$00
	STA zEnemyState, Y
	JSR sub_BANK3_BA5D

	LDA #$60
	STA iObjectFlashTimer - 1, X
	LSR A
	STA iObjectStunTimer - 1, X
	LDA iEnemyHP - 1, X
	BNE locret_BANK3_B9B6

	INC iScrollXLock

locret_BANK3_B9B6:
	RTS

; ---------------------------------------------------------------------------

loc_BANK3_B9B7:
	CMP #$32
	BCS locret_BANK3_B9B6

	CMP #$11
	BNE loc_BANK3_B9CA

	LDA #$05
	STA zEnemyState, Y
	LDA #$1E
	STA zSpriteTimer, Y
	RTS

; ---------------------------------------------------------------------------

loc_BANK3_B9CA:
	LDA zEnemyState, Y
	CMP #$04
	BEQ loc_BANK3_B9EC

	LDA zObjectType, Y
	CMP #Enemy_Shell
	BEQ loc_BANK3_B9EA

	LDA #$E8
	STA zObjectYVelocity, Y
	STX z00
	LDX zObjectXVelocity, Y
	BMI loc_BANK3_B9E5

	LDA #$18

loc_BANK3_B9E5:
	STA zObjectXVelocity, Y
	LDX z00

loc_BANK3_B9EA:
	LDY z12

loc_BANK3_B9EC:
	JSR sub_BANK3_BA5D

	BNE locret_BANK3_B9F9

	LDA zObjectXVelocity - 1, X
	ASL A
	ROR zObjectXVelocity - 1, X
	ASL A
	ROR zObjectXVelocity - 1, X

locret_BANK3_B9F9:
	RTS

; ---------------------------------------------------------------------------

DamagePlayer:
	LDA zDamageCooldown
	BNE locret_BANK3_BA31

	LDA iPlayerHP
	SEC
	SBC #$10
	BCC loc_BANK3_BA32

	STA iPlayerHP
	LDY #$7F
	STY zDamageCooldown
	LDY #$00
	STY zPlayerYVelocity
	STY zPlayerXVelocity
	CMP #$10
	BCC loc_BANK3_BA2C

	LDA iPlayerScreenX
	SEC
	SBC iSpriteTempScreenX
	ASL A
	ASL A
	STA zPlayerXVelocity
	LDA #$C0
	LDY zPlayerYVelocity
	BPL loc_BANK3_BA2A

	LDA #$00

loc_BANK3_BA2A:
	STA zPlayerYVelocity

loc_BANK3_BA2C:
	LDA #SoundEffect2_Injury
	STA iPulse1SFX

locret_BANK3_BA31:
	RTS

; ---------------------------------------------------------------------------

loc_BANK3_BA32:
	TXA

loc_BANK3_BA33:
	PHA
	LDX z12
	LDA zObjectType, X
	CMP #Enemy_BeezoDiving
	BCS loc_BANK3_BA48

	JSR EnemyFindWhichSidePlayerIsOn

	INY
	TYA
	CMP zEnemyTrajectory, X
	BEQ loc_BANK3_BA48

	JSR EnemyBehavior_TurnAround

loc_BANK3_BA48:
	PLA
	TAX
	LDA #$C0
	STA zPlayerYVelocity

loc_BANK3_BA4E:
	LDA #$20
	STA zPlayerStateTimer
	LDY z12
	BMI loc_BANK3_BA5A

	LSR A
	STA iObjectStunTimer, Y

loc_BANK3_BA5A:
	JMP KillPlayer

; =============== S U B R O U T I N E =======================================

; Damage enemy
sub_BANK3_BA5D:
	LDA iSpriteTimer - 1, X
	ORA iObjectFlashTimer - 1, X
	BNE locret_BANK3_BA94

	LDA i46e - 1, X
	AND #Enemy_Ostro
	BEQ EnemyTakeDamage

	JSR PlayBossHurtSound

EnemyTakeDamage:
	DEC iEnemyHP - 1, X ; Subtract hit point
	BMI EnemyKnockout

	LDA #$21 ; Flash
	STA iObjectFlashTimer - 1, X
	LSR A

loc_BANK3_BA7A:
	STA iObjectStunTimer - 1, X

; End of function sub_BANK3_BA5D

PlayBossHurtSound:
	LDA #DPCM_BossHurt
	STA iDPCMSFX
	STA iDPCMBossPriority
	RTS

; ---------------------------------------------------------------------------

EnemyKnockout:
	LDA zEnemyCollision - 1, X
	ORA #CollisionFlags_Damage
	STA zEnemyCollision - 1, X
	LDA #$E0
	STA zObjectYVelocity - 1, X
	LDA zObjectXVelocity, Y
	STA zObjectXVelocity - 1, X
	LDA #$00

locret_BANK3_BA94:
	RTS

;
; Determines the collision flags for two objects
;
; Input:
;   RAM_12 = main object
;   X = collision object (usually player?)
; Output:
;   z0f= collision flags
;
DetermineCollisionFlags:
	LDA #$00
	STA z0f
	LDY z12 ; stash Y
	LDA iCollisionResultY
	CMP #$F6
	BCS DetermineCollisionFlags_Y

	LDA zObjectXLo, Y
	LDY #CollisionFlags_Left
	CMP zObjectXLo - 1, X
	BMI DetermineCollisionFlags_SetFlagsX

	LDY #CollisionFlags_Right

DetermineCollisionFlags_SetFlagsX:
	STY z0f
	TYA
	AND zEnemyTrajectory - 1, X
	BEQ DetermineCollisionFlags_ExitX

	LDY z12 ; restore Y
	LDA iObjectNonSticky, Y
	BNE DetermineCollisionFlags_ExitX

	; @TODO: Looks like a way to make objects move together horizontally
	LDA zObjectXVelocity, Y
	STA iObjectXVelocity - 1, X

DetermineCollisionFlags_ExitX:
	RTS


DetermineCollisionFlags_Y:
	LDA zObjectYLo, Y
	CPX #$01
	BCS loc_BANK3_BAD1

	PHA
	LDY zPlayerHitBoxHeight
	PLA
	SEC
	SBC byte_BANK3_BB2F, Y

loc_BANK3_BAD1:
	CMP zObjectYLo - 1, X
	BMI loc_BANK3_BB02

	LDA zObjectYVelocity - 1, X
	BMI DetermineCollisionFlags_ExitY

	LDY z12
	LDA iObjectNonSticky, Y
	BNE loc_BANK3_BAE6

	LDA zObjectXVelocity, Y
	STA iObjectXVelocity - 1, X

loc_BANK3_BAE6:
	LDY #$00
	INC iCollisionResultY
	INC iCollisionResultY
	BPL loc_BANK3_BAF1

	DEY

loc_BANK3_BAF1:
	LDA iCollisionResultY
	CLC
	ADC zObjectYLo - 1, X
	STA zObjectYLo - 1, X
	TYA
	ADC zObjectYHi - 1, X
	STA zObjectYHi - 1, X
	LDY #CollisionFlags_Down
	BNE loc_BANK3_BB13

loc_BANK3_BB02:
	LDA zObjectYVelocity - 1, X
	BEQ loc_BANK3_BB11

	BPL DetermineCollisionFlags_ExitY

	LDY z12
	LDA zObjectType, Y
	CMP #Enemy_Coin
	BEQ DetermineCollisionFlags_ExitY

loc_BANK3_BB11:
	LDY #CollisionFlags_Up

loc_BANK3_BB13:
	STY z0f
	LDY z12
	LDA iObjectNonSticky, Y
	BNE loc_BANK3_BB22

	; @TODO: Looks like a way to make objects move together vertically
	LDA zObjectYVelocity, Y
	STA iObjectYVelocity - 1, X

loc_BANK3_BB22:
	LDA #$00
	STA zObjectYVelocity - 1, X
	LDA iObjectYSubpixel, Y
	STA iObjectYSubpixel - 1, X
	INC zObjectAnimTimer - 1, X

DetermineCollisionFlags_ExitY:
	RTS


byte_BANK3_BB2F:
	.db $0B
	.db $10

; =============== S U B R O U T I N E =======================================

sub_BANK3_BB31:
	LDY #$00
	LDA zEnemyCollision - 1, X
	ORA z0f
	AND #$0C
	CMP #$0C
	BEQ loc_BANK3_BB48

	LDA zEnemyCollision - 1, X
	ORA z0f
	AND #CollisionFlags_Right | CollisionFlags_Left
	CMP #CollisionFlags_Right | CollisionFlags_Left
	BNE locret_BANK3_BB49

	INY

loc_BANK3_BB48:
	INY

locret_BANK3_BB49:
	RTS

; End of function sub_BANK3_BB31

; ---------------------------------------------------------------------------
_unused_BANK3_BB4A:
	.db $FF ; May not be used, but wasn't marked as data
	.db $FF
	.db $FF
	.db $FF
	.db $FF
	.db $FF

; Hoopstar will climb up and down any of these tiles
HoopstarClimbTiles:
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


EnemyBehavior_Hoopstar_CheckBackgroundTile:
	JSR sub_BANK3_BB87

	LDA z00

	LDY #$09
EnemyBehavior_Hoopstar_CheckBackgroundTile_Loop:
	CMP HoopstarClimbTiles, Y
	BEQ EnemyBehavior_Hoopstar_CheckBackgroundTile_Exit
	DEY
	BPL EnemyBehavior_Hoopstar_CheckBackgroundTile_Loop

	CLC

EnemyBehavior_Hoopstar_CheckBackgroundTile_Exit:
	RTS


ItemCarryYOffsets:
	.db $F9
	.db $FF
	.db $00
	.db $08
	.db $0C
	.db $18
	.db $1A
	.db $01
	.db $06
	.db $0A
	.db $0C
	.db $18
	.db $1A
	.db $1C
	.db $FF
	.db $FF
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00


; =============== S U B R O U T I N E =======================================

;
; Seems to determine what kind of tile the object has collided with?
;
; Duplicate of subroutine in bank 0: sub_BANK0_924F
;
; Input
;   X = object index (0 = player)
;   Y = bounding box offset?
; Output
;   z00 = tile ID
;
sub_BANK3_BB87:
	TXA
	PHA

	LDA #$00
	STA z00
	STA z01
	LDA VerticalTileCollisionHitboxX, Y
	BPL loc_BANK3_BB96

	DEC z00

loc_BANK3_BB96:
	CLC
	ADC zObjectXLo - 1, X
	AND #$F0
	STA z05
	PHP
	LSR A
	LSR A
	LSR A
	LSR A
	STA ze5
	PLP
	LDA zObjectXHi - 1, X
	ADC z00
	STA z02
	STA z03
	LDA zScrollCondition
	BNE loc_BANK3_BBB5

	STA z02
	STA z03

loc_BANK3_BBB5:
	LDA VerticalTileCollisionHitboxY, Y
	BPL loc_BANK3_BBBC

	DEC z01

loc_BANK3_BBBC:
	CLC
	ADC zObjectYLo - 1, X
	AND #$F0
	STA z06
	STA ze6
	LDA zObjectYHi - 1, X
	ADC z01
	STA z01
	STA z04
	JSR sub_BANK3_BC2E

	BCC loc_BANK3_BBD6

	LDA #$00
	BEQ loc_BANK3_BBDD

loc_BANK3_BBD6:
	JSR SetTileOffsetAndAreaPageAddr

	LDY ze7
	LDA (z01), Y

loc_BANK3_BBDD:
	STA z00
	PLA
	TAX
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
CheckTileUsesCollisionType_Bank3:
	PHA ; stash tile ID for later

	; determine which tile table to use (0-3)
	AND #$C0
	ASL A
	ROL A
	ROL A

	; add the offset for the type of collision we're checking
	ADC TileGroupTable_Bank3, Y
	TAY

	; check which side of the tile ID pivot we're on
	PLA
	CMP TileSolidnessTable, Y
	RTS


;
; These map the two high bits of a tile to offets in TileSolidnessTable
;
TileGroupTable_Bank3:
	.db $00 ; solid to mushroom blocks
	.db $04 ; solid on top
	.db $08 ; solid on all sides


DoorHandling_GoThroughDoor_Bank3:
	INC iDoorAnimTimer
	INC iPlayerLock
	JSR SnapPlayerToTile_Bank3

	LDA #SoundEffect3_Door
	STA iNoiseSFX
	RTS


;
; Checks horizontal collision with the player and stops them if necessary
;
PlayerHorizontalCollision:
	LDX #$00
	LDY zPlayerTrajectory
	LDA zPlayerXVelocity
	EOR PlayerCollisionResultTable - 1, Y
	BPL loc_BANK3_BC10

	STX zPlayerXVelocity

loc_BANK3_BC10:
	LDA iPlayerXVelocity
	EOR PlayerCollisionResultTable - 1, Y
	BPL loc_BANK3_BC1B

	STX iPlayerXVelocity

loc_BANK3_BC1B:
	STX iPlayerXSubpixel

locret_BANK3_BC1E:
	RTS


;
; Set the player state to lifting and Kick off the lifting animation
;
SetPlayerStateLifting:
	LDA #PlayerState_Lifting
	STA zPlayerState
	LDA #$06
	STA zPlayerStateTimer
	LDA #$08
	STA zPlayerAnimFrame
	INC zHeldItem
	RTS


;
; @TODO: Figure out what this does exactly
;
sub_BANK3_BC2E:
	LDY z01
	LDA ze6
	JSR sub_BANK3_BD6B

	STY z01
	STA ze6
	LDY zScrollCondition
	LDA z01, Y
	STA ze8
	LDA z02
	CMP byte_BANK3_BC4D + 1, Y
	BCS locret_BANK3_BC4C

	LDA z01
	CMP byte_BANK3_BC4D, Y

locret_BANK3_BC4C:
	RTS


byte_BANK3_BC4D:
	.db $0A
	.db $01
	.db $0B


;
; Replaces a tile when something is thrown
;
; Input
;   A = target tile
;   X = enemy index of object being thrown
;
ReplaceTile:
	PHA
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
	BEQ ReplaceTile_StoreXHi

	ADC #$00

ReplaceTile_StoreXHi:
	STA z02
	LDA zObjectYLo, X
	CLC
	ADC #$08
	AND #$F0
	STA ze6
	LDA zObjectYHi, X
	ADC #$00
	STA z01
	JSR sub_BANK3_BC2E

	PLA
	BCS locret_BANK3_BC1E

	STX z03
	PHA
	JSR SetTileOffsetAndAreaPageAddr

	PLA
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
	BNE loc_BANK3_BCBA

	INY

loc_BANK3_BCBA:
	LDA PPUNametableHi, Y
	CLC
	ADC iPPUBuffer, X
	STA iPPUBuffer, X
	STA iPPUBuffer + 5, X
	LDA #$02
	STA iPPUBuffer + 2, X
	STA iPPUBuffer + 7, X
	PLA
	PHA
	AND #$C0
	ASL A
	ROL A
	ROL A
	TAY
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
	ADC #$A
	STA i300
	LDX z03
	RTS


; Another byte of PPU high addresses for horiz/vert levels
PPUNametableHi:
	.db $20 ; vertical, nametable A
	.db $28 ; vertical, nametable B
	.db $20 ; horizontal, nametable A
	.db $24 ; horizontal, nametable B


StashPlayerPosition:
	LDA iSubAreaFlags
	BNE StashPlayerPosition_Exit

	LDA zPlayerXHi
	STA iPlayerXHi
	LDA zPlayerXLo
	STA iPlayer_X_Lo
	LDA zPlayerYHi
	STA iPlayerYHi
	LDA zPlayerYLo
	STA iPlayerYLoBackup

StashPlayerPosition_Exit:
	RTS


;
; Updates the area page and tile placement offset @TODO
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
SetTileOffsetAndAreaPageAddr:
	LDX ze8
	JSR SetAreaPageAddr

	LDA ze6
	CLC
	ADC ze5
	STA ze7
	RTS


DecodedLevelPageStartLo:
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

DecodedLevelPageStartHi:
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
SetAreaPageAddr:
	LDA DecodedLevelPageStartLo, X
	STA z01
	LDA DecodedLevelPageStartHi, X
	STA z02
	RTS


PlayerCollisionResultTable:
	.db CollisionFlags_80
	.db CollisionFlags_00

; =============== S U B R O U T I N E =======================================

;
; Note: Door animation code copied from Bank 0
;
; Snaps the player to the closest tile (for entering doors and jars)
;
SnapPlayerToTile_Bank3:
	LDA zPlayerXLo
	CLC
	ADC #$08
	AND #$F0
	STA zPlayerXLo
	BCC SnapPlayerToTile_Exit_Bank3

	LDA zScrollCondition
	BEQ SnapPlayerToTile_Exit_Bank3

	INC zPlayerXHi

SnapPlayerToTile_Exit_Bank3:
	RTS


; =============== S U B R O U T I N E =======================================

sub_BANK3_BD6B:
	STA z0f
	TYA
	BMI locret_BANK3_BD81

	ASL A
	ASL A
	ASL A
	ASL A
	CLC
	ADC z0f
	BCS loc_BANK3_BD7D

	CMP #$F0
	BCC locret_BANK3_BD81

loc_BANK3_BD7D:
	CLC
	ADC #$10
	INY

locret_BANK3_BD81:
	RTS

; End of function sub_BANK3_BD6B


;
; Checks collision in one dimension (wrapping)
; Only run when checking horizontal collision in a vertical level
;
; ##### Input
;
; - `Y`: which dimension to compare `$00` = x, `$02` = y
; - `z05`/`z07`: bounding box A x/y offset low
; - `z06`/`z08`: bounding box B x/y offset low
; - `z09`: bounding box A width/height
; - `z0a`: bounding box B width/height
;
; ##### Output
;
; - `C`: clear if there is a collision, set if there is no collision
; - `A`: distance between bounding boxes
;
CheckHitboxCollisionDimensionWrap:
	LDA z05, Y
	SEC
	SBC z06, Y
	BPL CheckHitboxCollisionDimensionWrap_Exit

	EOR #$FF
	CLC
	ADC #$01
	DEX

CheckHitboxCollisionDimensionWrap_Exit:
	SEC
	SBC z09, X
	RTS


;
; Checks collision in one dimension
;
; ##### Input
;
; - `Y`: which dimension to compare `$00` = x, `$02` = y
; - `z01`/`z03`: bounding box A x/y offset high
; - `z02`/`z04`: bounding box B x/y offset high
; - `z05`/`z07`: bounding box A x/y offset low
; - `z06`/`z08`: bounding box B x/y offset low
; - `z09`: bounding box A width/height
; - `z0a`: bounding box B width/height
;
; ##### Output
;
; - `C`: clear if there is a collision, set if there is no collision
; - `A`: distance between bounding boxes
;
CheckHitboxCollisionDimension:
	LDA z05, Y
	SEC
	SBC z06, Y
	STA z06, Y
	LDA z01, Y
	SBC z02, Y
	BPL loc_BANK3_BDB9

	EOR #$FF
	PHA
	LDA z06, Y
	EOR #$FF
	CLC
	ADC #$01
	STA z06, Y
	PLA
	ADC #$00
	DEX

loc_BANK3_BDB9:
	CMP #$00
	BEQ CheckHitboxCollisionDimension_Exit

	SEC
	RTS

CheckHitboxCollisionDimension_Exit:
	LDA z06, Y
	SBC z09, X
	RTS


;
; Determines whether two bounding boxes collide
;
; ##### Input
;
; - `z01`: bounding box A left high
; - `z02`: bounding box B left high
; - `z03`: bounding box A top high
; - `z04`: bounding box B top high
; - `z05`: bounding box A left low
; - `z06`: bounding box B left low
; - `z07`: bounding box A top low
; - `z08`: bounding box B top low
; - `z09`: hitbox A width low
; - `z0a`: hitbox B width low
; - `z0b`: hitbox A height low
; - `z0c`: hitbox B height low
;
; ##### Output
;
; - `C`: clear if there is a collision, set if there is no collision
;
CheckHitboxCollision:
	TXA
	PHA
	LDY #$02 ; check vertical collision

CheckHitboxCollision_Loop:
	TYA
	TAX
	INX
	CPY #$00 ; check horizontal collision
	BNE CheckHitboxCollision_CheckDimensionNoWrap

	LDA zScrollCondition
	BNE CheckHitboxCollision_CheckDimensionNoWrap

	; Horizontal position wraps in a vertical level
CheckHitboxCollision_CheckDimensionWrap:
	JSR CheckHitboxCollisionDimensionWrap
	JMP CheckHitboxCollision_AfterCheckDimension

CheckHitboxCollision_CheckDimensionNoWrap:
	JSR CheckHitboxCollisionDimension

CheckHitboxCollision_AfterCheckDimension:
	BCS CheckHitboxCollision_Exit

	PHA
	TYA
	LSR A
	TAX
	PLA
	; store the result
	STA iCollisionResultX, X
	DEY
	DEY
	BPL CheckHitboxCollision_Loop

	CLC

CheckHitboxCollision_Exit:
	PLA
	TAX
	RTS


; ---------------------------------------------------------------------------
HealthBarTiles:
	.db $BA ; 0
	.db $BA
	.db $BA
	.db $BA
	.db $B8 ; 1
	.db $BA
	.db $BA
	.db $BA
	.db $B8 ; 2
	.db $B8
	.db $BA
	.db $BA
	.db $B8 ; 3
	.db $B8
	.db $B8
	.db $BA
	.db $B8 ; 4
	.db $B8
	.db $B8
	.db $B8

POWQuakeOffsets:
	.db $00
	.db $03
	.db $00
	.db $FD

SkyFlashColors:
	.db $26
	.db $2A
	.db $22
	.db $26

; =============== S U B R O U T I N E =======================================

AreaSecondaryRoutine:
	LDA iSkyFlashTimer
	BEQ AreaSecondaryRoutine_HealthBar

	; sky flash timer (ie. explosions)
	DEC iSkyFlashTimer
	LDX i300
	LDA #$3F
	STA iPPUBuffer, X
	LDA #$10
	STA iPPUBuffer + 1, X
	LDA #$04
	STA iPPUBuffer + 2, X
	LDA iSkyColor
	LDY iSkyFlashTimer
	BEQ AreaSecondaryRoutine_PlayerPalette

	TYA
	AND #$03
	TAY
	LDA SkyFlashColors, Y

AreaSecondaryRoutine_PlayerPalette:
	STA iPPUBuffer + 3, X
	LDA iBackupPlayerPal + 1
	STA iPPUBuffer + 4, X
	LDA iBackupPlayerPal + 2
	STA iPPUBuffer + 5, X
	LDA iBackupPlayerPal + 3
	STA iPPUBuffer + 6, X
	LDA #$00
	STA iPPUBuffer + 7, X
	TXA
	CLC
	ADC #$07
	STA i300

AreaSecondaryRoutine_HealthBar:
	LDA #$30
	STA z00
	JSR FindSpriteSlot

	LDA iPlayerHP
	BEQ AreaSecondaryRoutine_HealthBar_Draw

	AND #$F0
	LSR A
	LSR A
	ADC #$04 ; max health

AreaSecondaryRoutine_HealthBar_Draw:
	TAX

	LDA #$FE
	STA z03
AreaSecondaryRoutine_HealthBar_Loop:
	LDA HealthBarTiles, X
	STA iVirtualOAM + 1, Y
	LDA #$10
	STA iVirtualOAM + 3, Y
	LDA #$01
	STA iVirtualOAM + 2, Y
	LDA z00
	STA iVirtualOAM, Y
	CLC
	ADC #$10
	STA z00
	INX
	INY
	INY
	INY
	INY
	INC z03
	LDA z03
	CMP iPlayerMaxHP
	BNE AreaSecondaryRoutine_HealthBar_Loop

AreaSecondaryRoutine_POW:
	LDA iPOWTimer
	BEQ AreaSecondaryRoutine_Exit

	DEC iPOWTimer
	LSR A
	AND #$01
	TAY
	LDA zPPUScrollY
	BPL AreaSecondaryRoutine_POW_OffsetScreen

	INY
	INY

AreaSecondaryRoutine_POW_OffsetScreen:
	LDA POWQuakeOffsets, Y
	STA iBGYOffset
	JMP KillOnscreenEnemies

AreaSecondaryRoutine_Exit:
	RTS
