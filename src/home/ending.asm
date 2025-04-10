;
; Do the ending!
;
EndingSceneRoutine:
	JSR SetScrollXYTo0

	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR FreeSubconsScene

	JSR WaitForNMI_TurnOffPPU

	JSR DisableNMI

	JSR LoadCelebrationSceneBackgroundCHR

	JSR EnableNMI

	JSR WaitForNMI

	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR ContributorScene

	JSR WaitForNMI_TurnOffPPU

	JSR DisableNMI

SetupMarioSleepingScene:
	JSR LoadMarioSleepingCHRBanks

	JSR EnableNMI

	JSR WaitForNMI

	LDA #PRGBank_C_D
	JSR ChangeMappedPRGBank

	JMP MarioSleepingScene

DisableNMI:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIDisabled
	STA PPUCTRL
	STA zPPUControl
	RTS
