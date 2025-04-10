;
; Clears the screen and resets the scroll position for the title card
;
; This is used for the character select screen as well, but that has a few PPU
; changes of its own.
;
ResetScreenForTitleCard:
	JSR EnableNMI

	JSR WaitForNMI_TurnOffPPU

	JSR SetScrollXYTo0

	LDA #ScreenUpdateBuffer_RAM_TitleCardPalette
	STA zScreenUpdateIndex
	JSR WaitForNMI

	LDA #VMirror
	JSR ChangeNametableMirroring

	JMP ClearNametablesAndSprites


;
; Enables NMI and draws the background of the pause screen
;
EnableNMI_PauseTitleCard:
	JSR EnableNMI

	JSR WaitForNMI_TurnOffPPU

	LDA #Stack100_Menu
	STA iStack
	LDA #ScreenUpdateBuffer_CharacterSelect
	STA zScreenUpdateIndex
	JSR WaitForNMI

	LDA #ScreenUpdateBuffer_TitleCard
	STA zScreenUpdateIndex

	JMP WaitForNMI


;
; Draws world info for the title card and pause screens
;
; ##### Input
; - `X`: iCurrentWorld / sSavedWorld
; - `Y`: iCurrentLvl (not actually used)
;
DisplayLevelTitleCardText:
	; Level number (unused)
	; In Doki Doki Panic, this was displayed as a page number, keeping with
	; the storybook motif.
	INY
	TYA
	JSR GetTwoDigitNumberTiles

	; World number
	INX
	TXA
	ORA #$D0
	STA wTitleCardWorld

	; Extra Life number
	LDY iExtraMen
	DEY
	TYA
	JSR GetTwoDigitNumberTiles
	STY wExtraLifeCounter
	STA wExtraLifeCounter + 1

	; Reset level dots
	LDY #$06
	LDA #$FB
DisplayLevelTitleCardText_ResetLevelDotsLoop:
	STA wTitleCardDots, Y ; writes to $7171
	DEY
	BPL DisplayLevelTitleCardText_ResetLevelDotsLoop

	; Level number
	LDY iCurrentWorld
	LDA iCurrentLvl
	SEC
	SBC WorldStartingLevel, Y
	STA iCurrentLvlRelative
	CLC
	ADC #$D1
	STA wTitleCardLevel

	; Use the difference between the starting level of the next world and this
	; world to determine how many dots to show for the levels in the world.
	LDA WorldStartingLevel + 1, Y
	SEC
	SBC WorldStartingLevel, Y
	STA z03

	; Level dots
	LDX #$00
	LDY #$00
DisplayLevelTitleCardText_DrawLevelDotsLoop:
	LDA #$FD ; other level
	CPX iCurrentLvlRelative
	BNE DisplayLevelTitleCardText_DrawLevelDot

	LDA #$F6 ; current level

DisplayLevelTitleCardText_DrawLevelDot:
	STA wTitleCardDots, Y
	INY
	INY
	INX
	CPX z03
	BCC DisplayLevelTitleCardText_DrawLevelDotsLoop

	; Draw the card
	LDA #ScreenUpdateBuffer_RAM_TitleCardText
	STA zScreenUpdateIndex
	RTS


;
; It's game time, pal
;
SetStack100Gameplay:
	LDA #Stack100_Gameplay
	STA iStack
	RTS


;
; Resets various level-related variables to $00
;
InitializeSomeLevelStuff:
	LDA #$00
	STA iCurrentLvlArea
	STA iCurrentLevelArea_Init
	STA iCurrentLvlEntryPage
	STA sSavedLvlEntryPage
	STA iCurrentLevelEntryPage_Init
	STA iTransitionType
	STA iTransitionType_Init
	STA zPlayerState
	STA iPlayer_State_Init
	STA iSubAreaFlags
	STA iInJarType
	STA iWatchTimer
IFDEF SIXTEEN_BIT_WATCH_TIMER
	STA iWatchTimer + 1
ENDIF
	STA iCurrentPlayerSize
	RTS

PlayerSelectArrowTop:
	.db $C9
	.db $D5
	.db $D1
	.db $CD
PlayerSelectArrowBottom:
	.db $E9
	.db $F5
	.db $F1
	.db $ED


;
; Displays the level title card and prepares the level to start by loading
; the world tiles, PRG banks A/B, and copying character data
;
DisplayLevelTitleCardAndMore:
	JSR WaitForNMI_TurnOffPPU

	JSR DisableNMI

	; Set the scrolling mirror over to the right side...
	; This Isn't quiiite correct, and causes a bunch of
	; crud to show on the very left pixel -- residue
	; from the character select screen
	LDA #$FF
	STA zPPUScrollX
	JSR ChangeTitleCardCHR

	LDA #PRGBank_A_B
	JSR ChangeMappedPRGBank

	JSR CopyCharacterStatsAndStuff

	JSR EnableNMI

	JSR HideAllSprites

	JSR PreLevelTitleCard

	JSR LoadWorldCHRBanks

	LDA #PRGBank_A_B
	JSR ChangeMappedPRGBank

	JSR CopyCharacterStatsAndStuff

	JMP EnableNMI
