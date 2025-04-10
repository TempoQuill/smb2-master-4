
InitializeSubArea:
	JSR ClearNametablesAndSprites

	LDA #PRGBank_6_7
	JSR ChangeMappedPRGBank

	LDA #$00
	STA iSubspaceCoinCount
	LDA iSubAreaFlags
	CMP #$02
	BEQ InitializeSubspace

InitializeJar:
	LDA #PRGBank_8_9
	JSR ChangeMappedPRGBank

	JSR CopyJarDataToMemory

	JSR CopyEnemyDataToMemory

	LDA #PRGBank_6_7
	JSR ChangeMappedPRGBank

	JMP ClearLayoutAndPokeMusic

InitializeSubspace:
	JSR SubspaceGeneration

loc_BANKF_E5E1:
	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR UseSubareaScreenBoundaries

	JSR EnableNMI

SubArea_Loop:
	JSR WaitForNMI

	JSR sub_BANK0_87AA

	LDA i537
	BEQ SubArea_Loop

	LDA iSubAreaFlags
	CMP #$02
	BEQ loc_BANKF_E606

	LDA #PRGBank_6_7
	JSR ChangeMappedPRGBank

	JSR LoadCurrentPalette

loc_BANKF_E606:
	JSR WaitForNMI_TurnOnPPU

; subspace
loc_BANKF_E609:
	JSR WaitForNMI

	JSR HideAllSprites

	JSR sub_BANKF_F0F9

	LDY iGameMode
	BEQ loc_BANKF_E61A

	JMP ResetAreaAndProcessGameMode

; ---------------------------------------------------------------------------

loc_BANKF_E61A:
	LDA iSubAreaFlags
	BNE loc_BANKF_E609

	LDA iSubspaceCoinCount
	BEQ loc_BANKF_E627

	INC iSubspaceVisitCount

loc_BANKF_E627:
	LDA iCurrentAreaBackup
	STA iCurrentLvlArea
	LDA #PRGBank_6_7
	JSR ChangeMappedPRGBank

	JSR LoadCurrentPalette

	JSR WaitForNMI_TurnOffPPU

	JSR HideAllSprites

	LDY iLevelMusic
	STY iMusicID
	LDA iStarTimer
	BNE loc_BANKF_E64C

	LDA LevelMusicIndexes, Y
	STA iMusicQueue

loc_BANKF_E64C:
	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JMP ExitSubArea
