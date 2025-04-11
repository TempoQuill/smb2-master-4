PreLevelTitleCard:
	LDY #$23
PreLevelTitleCard_PaletteLoop:
	LDA TitleCardPalettes, Y
	STA iStartingPalettes, Y
	DEY
	BPL PreLevelTitleCard_PaletteLoop

	LDA #ScreenUpdateBuffer_RAM_TitleCardPalette ; Then tell it to dump that into the PPU
	STA zScreenUpdateIndex
	JSR WaitForNMI

	LDA #ScreenUpdateBuffer_TitleCardLeftover
	STA zScreenUpdateIndex
	JSR WaitForNMI

	JSR DrawTitleCardWorldImage

	JSR WaitForNMI_TurnOnPPU

	JSR RestorePlayerToFullHealth

	; Pause for the title card
	LDA #$50
	STA z02
PreLevelTitleCard_PauseLoop:
	JSR WaitForNMI
	DEC z02
	BPL PreLevelTitleCard_PauseLoop

PreStartLevel:
	JSR SetStack100Gameplay

	JSR WaitForNMI_TurnOffPPU

	JMP DisableNMI

LoadCHRSelect:
	JSR EnableNMI_PauseTitleCard

	JSR DisableNMI

	LDA #MUSIC_CHR_SELECT
	STA iMusicQueue

	LDY #$3F
loc_BANKF_E2CA:
	LDA PlayerSelectMarioSprites1, Y
	STA iVirtualOAM + $10, Y
	DEY
	BPL loc_BANKF_E2CA

	JSR EnableNMI

	JSR WaitForNMI

	LDX iCurrentWorld
	LDY iCurrentLvl
	JSR DisplayLevelTitleCardText

	JSR WaitForNMI

	JMP loc_BANKF_E311
