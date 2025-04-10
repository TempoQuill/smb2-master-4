;
; Pauses the game
;
ShowPauseScreen:
	LDA #PauseOption_Continue
	STA iStack + 1
	JSR PauseScreen_ExtraLife

	LDA #ScreenUpdateBuffer_RAM_PauseText
	STA zScreenUpdateIndex
	; used when running sound queues
	LDA #Stack100_Pause
	STA iStack
	LDA #DPCM_Pause
	STA iDPCMSFX

	JSR WaitForNMI

	LDA #ScreenUpdateBuffer_PauseOptions
	STA zScreenUpdateIndex
	JSR WaitForNMI

	; ScreenUpdateBuffer_PauseOptionsAttribute1
	INC zScreenUpdateIndex

PauseScreenLoop:
DoSuicideCheatCheck:
	JSR WaitForNMI_TurnOnPPU

	LDA zPlayerState ; Check if the player is already dying
	CMP #PlayerState_Dying
	BEQ PauseScreenExitCheck ; If so, skip the suicide code check

	LDA zInputCurrentState + 1 ; Check for suicide code
	CMP #ControllerInput_Up | ControllerInput_B | ControllerInput_A ; Up + A + B
	BNE PauseScreenExitCheck ; Not being held! Nothing to see here

	JSR KillPlayer ; KILL THYSELF

PauseScreenExitCheck:
	JSR ChooseSaveChoiceAttribute
	TYA
	CLC
	ADC #ScreenUpdateBuffer_PauseOptions + 1
	STA zScreenUpdateIndex

	LDY zInputBottleneck
	TYA
	AND #ControllerInput_Start
	BNE HidePauseScreen

	TYA
	AND #ControllerInput_A
	BEQ PauseScreenLoop

	LDY iStack + 1
	DEY
	BMI HidePauseScreen
	DEY
	BMI SaveAndHidePauseScreen
	JMP StopOperationAndReset

SaveAndHidePauseScreen:
	LDA #Stack100_PauseSave
	STA iStack

;
; Unpauses the game
;
HidePauseScreen:
	JSR WaitForNMI_TurnOffPPU

	JSR LoadWorldCHRBanks

	LDA #PRGBank_6_7
	JSR ChangeMappedPRGBank

	JSR LoadCurrentPalette

	JSR WaitForNMI

	JSR SetStack100Gameplay

	JSR HideAllSprites

	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	LDA zPlayerState ; Check if the player is already dying
	CMP #PlayerState_Dying
	BNE HidePauseScreen_SFX

	JMP HidePauseScreen_01

HidePauseScreen_SFX:
	LDA zInputCurrentState
	ORA zInputBottleneck
	AND #$7F
	BNE HidePauseScreen_SFXStart
	LDX iStack + 1
	LDA PauseSounds, X
	STA iDPCMSFX
	JMP HidePauseScreen_01

HidePauseScreen_SFXStart:
	LDA #DPCM_Pause
	STA iDPCMSFX
	JMP HidePauseScreen_01
