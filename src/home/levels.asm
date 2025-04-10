;
; This code resets the level and does whatever else is needed to transition from
; the current `iGameMode` to `GameMode_InGame`.
;
ResetAreaAndProcessGameMode:
	JSR DoAreaReset

	LDY iGameMode
ShowCardAfterTransition:
	LDA #GameMode_InGame
	STA iGameMode
	STA iStarTimer
	STA iLargeVeggieAmount
	STA iCherryAmount
	STA iWatchTimer
IFDEF SIXTEEN_BIT_WATCH_TIMER
	STA iWatchTimer + 1
ENDIF
	DEY ; Initial `iGameMode` minus 1
	BNE ResetAreaAndProcessGameMode_NotTitleCard

  ; `iGameMode` was `$01`
	; Reset from a title card
	STY iCurrentPlayerSize
	JSR LevelInitialization

	LDA #$FF
	STA iMusicID
	; Draw EXTRA LIFE text near top of card
	LDA #$25
	STA wExtraLifeDrawPointer
	LDA #$48
	STA wExtraLifeDrawPointer + 1
	LDA #ScreenUpdateBuffer_TitleCardLeftover
	STA iCardScreenID
	JSR PauseScreen_Card

AfterDeathJump:
IFNDEF CHARACTER_SELECT_AFTER_DEATH
	JMP StartLevelAfterTitleCard
ELSE
	JMP CharacterSelectMenu
ENDIF


ResetAreaAndProcessGameMode_NotTitleCard:
	LDA #PlayerHealth_2_HP
	STA iPlayerHP
	LDA #$00
	STA iPlayerMaxHP
	STA iKeyUsed
	STA iLifeUpEventFlag
	STA sLifeUpEventFlag
	STA iMushroomFlags
	STA iMushroomFlags + 1
	STA iSubspaceVisitCount
	STA iKills
	DEY ; Initial `iGameMode` minus 2
	BEQ DoGameOverStuff

	JMP ResetAreaAndProcessGameMode_NotGameOver
