;
; This starts the game once `RESET` has done its thing.
; We also come here after choosing "RETRY" from the game over menu.
;
StartGame:
	LDA #$00
	STA PPUMASK
	JSR DisableNMI

	LDA #PRGBank_Music_3
	ORA #$80
	STA iMusicBank
	LDA #PRGBank_0_1
	STA iMainGameState
	JSR ChangeMappedPRGBank

	JSR TitleScreen ; The whole title screen is a subroutine, lol

	LDA #0
	STA mContinueFlag

; We return here after picking "CONTINUE" from the game over menu.
ContinueGame:
	LDA sExtraMen
	STA iExtraMen

GoToWorldStartingLevel:
	LDX sSavedWorld
	STX iCurrentWorld
	LDY sLifeUpEventFlag
	STY iLifeUpEventFlag
	LDY WorldStartingLevel, X
	CPY sSavedLvl
	BEQ GoToWorldStartingLevel_SaveMatch

	LDA mContinueFlag
	BNE GoToWorldStartingLevel_SaveMatch

	LDY sSavedLvl

GoToWorldStartingLevel_SaveMatch:
	STY iCurrentLvl
	STY sSavedLvl
	STY iCurrentLevel_Init
	JSR DoCharacterSelectMenu

	JSR InitializeSomeLevelStuff

	JSR DisplayLevelTitleCardAndMore

	LDA #$FF
	STA iMusicID
	BNE StartLevel ; Branch always

CharacterSelectMenu:
	JSR DoCharacterSelectMenu

StartLevelAfterTitleCard:
	JSR DisplayLevelTitleCardAndMore

StartLevel:
	JSR WaitForNMI_TurnOffPPU

	LDA #$B0
	ORA zXScrollPage
	LDY zScrollCondition
	BNE StartLevel_SetPPUCtrlMirror

	AND #$FE
	ORA zYScrollPage

StartLevel_SetPPUCtrlMirror:
	STA zPPUControl
	STA PPUCTRL
	LDA #Stack100_Transition
	STA iStack
	LDA #PRGBank_8_9
	JSR ChangeMappedPRGBank

	JSR CopyLevelDataToMemory

	LDA #PRGBank_6_7
	JSR ChangeMappedPRGBank

	JSR GetCurrentArea

	LDA zScrollCondition
	BEQ VerticalLevel_Loop

HorizontalLevel_Loop:
	JSR WaitForNMI

	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR InitializeAreaHorizontal

	LDA zBreakStartLevelLoop
	BEQ HorizontalLevel_Loop

	LDA #$00
	STA zBreakStartLevelLoop
	JSR WaitForNMI_TurnOnPPU

HorizontalLevel_CheckScroll:
	JSR WaitForNMI

	; Disable pause detection while scrolling
	LDA zScrollArray
	AND #%00000100
	BNE HorizontalLevel_CheckSubArea

	LDA zInputBottleneck
	AND #ControllerInput_Start
	BEQ HorizontalLevel_CheckSubArea

	; Disable pause detection while in rocket
	LDA iIsInRocket
	CMP #$01
	BEQ HorizontalLevel_CheckSubArea

	; Disable pause detection while going through a door
	LDA iDoorAnimTimer
	BNE HorizontalLevel_CheckSubArea

	JMP ShowPauseScreen

HorizontalLevel_CheckSubArea:
	LDA iSubAreaFlags
	BEQ HorizontalLevel_ProcessFrame

	JMP InitializeSubArea

HorizontalLevel_ProcessFrame:
	JSR HideAllSprites

	JSR RunFrame_Horizontal

	LDY iGameMode
	BEQ HorizontalLevel_CheckTransition

	JMP ResetAreaAndProcessGameMode

HorizontalLevel_CheckTransition:
	LDA iAreaTransitionID
	BEQ HorizontalLevel_CheckScroll

	JSR FollowCurrentAreaPointer

	JSR RememberAreaInitialState

	LDA #$00
	STA iAreaTransitionID
	JMP StartLevel


VerticalLevel_Loop:
	JSR WaitForNMI

	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR InitializeAreaVertical

	LDA zBreakStartLevelLoop
	BEQ VerticalLevel_Loop

	LDA #$00
	STA zBreakStartLevelLoop
	JSR WaitForNMI_TurnOnPPU

VerticalLevel_CheckScroll:
	JSR WaitForNMI

	; Disable pause detection while scrolling
	; This is likely a work-around to avoid getting the PPU into a weird state
	; due to conflicts between the pause screen and attempting to draw the part
	; of the area scrolling into view.
	LDA zScrollArray
	AND #%00000100
	BNE VerticalLevel_ProcessFrame

	; Disable pause detection while going through a door
	LDA iDoorAnimTimer
	BNE VerticalLevel_ProcessFrame

	LDA zInputBottleneck
	AND #ControllerInput_Start
	BNE ShowPauseScreen

VerticalLevel_ProcessFrame:
	JSR HideAllSprites

	JSR RunFrame_Vertical

	LDY iGameMode
	BEQ VerticalLevel_CheckTransition

	JMP ResetAreaAndProcessGameMode

VerticalLevel_CheckTransition:
	LDA iAreaTransitionID
	BEQ VerticalLevel_CheckScroll

	JSR FollowCurrentAreaPointer

	JSR RememberAreaInitialState

	LDA #$00
	STA iAreaTransitionID
	JMP StartLevel
