DoGameOverStuff:
	STY iCurrentPlayerSize
	LDA #MUSIC_GAME_OVER
	STA iMusicQueue
	JSR WaitForNMI_TurnOffPPU

	JSR ChangeTitleCardCHR

	JSR ClearNametablesAndSprites

	JSR SetBlackAndWhitePalette

	JSR SetScrollXYTo0

	JSR EnableNMI

	JSR WaitForNMI_TurnOnPPU

	LDA #ScreenUpdateBuffer_Text_Game_Over
	STA zScreenUpdateIndex
	LDA #$C0
	STA z06

loc_BANKF_E6E6:
	JSR WaitForNMI

	DEC z06
	BNE loc_BANKF_E6E6

	LDY #(BonusChanceUpdateBuffer_BONUS_CHANCE_Unused - PPUBuffer_Text_Continue - 1)
loc_BANKF_E6EF:
	LDA PPUBuffer_Text_Continue, Y
	STA mContinueScreenBuffer, Y
	DEY
	BPL loc_BANKF_E6EF

	; Hide the bullet for RETRY
	LDA #$FB
	STA mContinueScreenRetry
	; Update the number of continues
	LDA #$FB
	STA mContinueScreenContNo
	LDA #$00
	STA z08
	LDA #ScreenUpdateBuffer_RAM_ContinueRetryText
	STA zScreenUpdateIndex

loc_BANKF_E719:
	JSR WaitForNMI

	LDA zInputBottleneck
	AND #ControllerInput_Select
	BEQ loc_BANKF_E747

	LDA z08
	EOR #$01
	STA z08
	ASL A
	ASL A
	TAY
	LDA #$FB
	STA wContinueScreenBullets + 3
	STA wContinueScreenBullets + 7
	LDA #$F6
	STA wContinueScreenBullets + 3, Y
	LDA #ScreenUpdateBuffer_RAM_ContinueRetryBullets
	STA zScreenUpdateIndex

loc_BANKF_E747:
	LDA zInputBottleneck
	AND #ControllerInput_Start
	BEQ loc_BANKF_E719

	LDA z08
	BNE GameOver_Retry

	STA iTotalCoins
	LDA #5
	STA sExtraMen
	INC mContinueFlag
	LDA #Stack100_Save
	STA iStack
	JMP ContinueGame

; ---------------------------------------------------------------------------

GameOver_Retry:
	JMP StartGame
