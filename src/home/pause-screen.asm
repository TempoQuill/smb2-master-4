;
; Displays extra life info on the pause screen
;
PauseScreen_ExtraLife:
	LDA #ScreenUpdateBuffer_PauseExtraLife
	STA iCardScreenID
	; Draw EXTRA LIFE text near bottom of card
	LDA #$26
	STA wExtraLifeDrawPointer
	LDA #$C8
	STA wExtraLifeDrawPointer + 1

;
; Loads the palette and graphics for the pause screen to display
;
PauseScreen_Card:
	JSR WaitForNMI_TurnOffPPU

	JSR ChangeTitleCardCHR

	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR StashScreenScrollPosition

	; Load title card palette
	LDY #$23
PauseScreen_Card_Loop:
	LDA TitleCardPalettes, Y
	STA iStartingPalettes, Y
	DEY
	BPL PauseScreen_Card_Loop

PauseScreen_Card_ScreenReset:
	JSR ResetScreenForTitleCard

	JSR EnableNMI_PauseTitleCard

	LDX iCurrentWorld
	LDY iCurrentLvl
	JSR DisplayLevelTitleCardText

	LDA #$FF
	STA zPPUScrollX
	JSR WaitForNMI

	LDA iCardScreenID
	STA zScreenUpdateIndex
	JSR WaitForNMI


EnableNMI:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	STA zPPUControl
	STA PPUCTRL
	RTS
