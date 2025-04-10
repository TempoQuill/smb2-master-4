ResetAreaAndProcessGameMode_NotGameOver:
	DEY ; Initial `iGameMode` minus 3
	BNE DoWorldWarp
	JMP EndOfLevel

DoWorldWarp:
	; Show warp screen
	JSR DoNewWarp

	JSR InitializeSomeLevelStuff

	JMP CharacterSelectMenu

; ---------------------------------------------------------------------------

EndOfLevel:
	; Stop the music
	LDA #Music_StopMusic ; Stop music
	STA iMusicQueue

	; Increase current characters "contribution" counter
	LDX zCurrentCharacter
	INC iCharacterLevelCount, X
	INC sContributors, X

	; Check if we've completed the final level
	LDA iCurrentLvl
	CMP #$13
IFNDEF DISABLE_BONUS_CHANCE
	; If not, go to bonus chance and proceed to the next level
EndOfLevelJump:
	BNE EndOfLevelSlotMachine
ENDIF
IFDEF DISABLE_BONUS_CHANCE
	STY iCurrentPlayerSize
EndOfLevelJump:
	BNE GoToNextLevel
ENDIF
	; Otherwise, display the ending
	JMP EndingSceneRoutine

EndOfLevelSlotMachine:
	STY iCurrentPlayerSize
	JSR WaitForNMI_TurnOffPPU

	JSR ClearNametablesAndSprites

	LDA #0
	STA mCoinService

	JSR EnableNMI
	JSR WaitForNMI

	JSR LoadBonusChanceCHRBanks

	LDA #PRGBank_A_B
	JSR ChangeMappedPRGBank
	JMP EndOfLevelSlotMachine_AB

; ---------------------------------------------------------------------------

loc_BANKF_E7F2:
	LDA #$03
	STA zObjectXLo + 3
	STA zObjectXLo + 4
	STA zObjectXLo + 5
	JSR WaitForNMI_TurnOnPPU

loc_BANKF_E7FD:
	LDA iTotalCoins
	BNE StartSlotMachine

GoToNextLevel:
	; Check if this is the last level before the next world
	LDY iCurrentWorld
	LDA WorldStartingLevel + 1, Y
	SEC
	SBC #$01
	CMP iCurrentLvl
	BNE GoToNextLevel_SameWorld

	JSR SetStack100Gameplay

	LDA #$FF
	STA iMusicID
	INC iCurrentWorld
	INC sSavedWorld
	LDY iCurrentWorld
	LDX WorldStartingLevel, Y
	STX sSavedLvl
	JMP GoToWorldStartingLevel

GoToNextLevel_SameWorld:
	JSR FollowCurrentAreaPointer

	; Sanity check that ensure that the world matches the level.
	; Without this, an area pointer at the end of a level that points to a
	; a different world would load incorrectly (eg. 2-1 would load as 1-4).
	; This scenario may not actually occur during normal gameplay.
	LDA iCurrentLvl
	LDY #$00
EnsureCorrectWorld_Loop:
	INY
	CMP WorldStartingLevel, Y
	BCS EnsureCorrectWorld_Loop

	DEY
	STY iCurrentWorld
	STY sSavedWorld

	; Initialize the current area and then go to the character select menu
	LDY iCurrentWorld
	LDA iCurrentLvl
	SEC
	SBC WorldStartingLevel, Y
	STA iCurrentLvlRelative
	LDA iCurrentLvl
	STA iCurrentLevel_Init
	LDA iCurrentLvlArea
	STA iCurrentLevelArea_Init
	LDA iCurrentLvlEntryPage
	STA iCurrentLevelEntryPage_Init
	LDY #$00
	STY iPlayer_State_Init
	STY iTransitionType
	STY iTransitionType_Init
	DEY
	STY iMusicID
	JSR SetStack100Gameplay

	JMP CharacterSelectMenu
