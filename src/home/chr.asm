LoadWorldCHRBanks:
	LDY #CHRBank_CommonEnemies1
	STY iObjCHR2
	INY
	STY iObjCHR3
	LDY iCurrentWorldTileset
	LDA CHRBank_WorldEnemies, Y
	STA iObjCHR4
	LDA CHRBank_WorldBossBackground, Y
	STA iBGCHR1
	LDA #CHRBank_Animated1
	STA iBGCHR2

LoadCharacterCHRBanks:
	LDA zCurrentCharacter
	ASL A
	ORA iCurrentPlayerSize
	TAY
	LDA CHRBank_CharacterSize, Y
	STA iObjCHR1
	RTS

LoadTitleScreenCHRBanks:
	LDA #CHRBank_TitleScreenBG1
	STA iObjCHR1
	STA iBGCHR1
	ORA #1
	STA iObjCHR2
	LDA #CHRBank_TitleScreenBG2
	STA iObjCHR3
	STA iBGCHR2
	ORA #1
	STA iObjCHR4
	RTS


LoadCelebrationSceneBackgroundCHR:
	LDA #CHRBank_CelebrationBG1
	STA iBGCHR1
	LDA #CHRBank_CelebrationBG2
	STA iBGCHR2
	RTS


LoadCharacterSelectCHRBanks:
	LDA #CHRBank_CharacterSelectSprites
	STA iObjCHR1
	LDA #CHRBank_CharacterSelectBG1
	STA iBGCHR1
	LDA #CHRBank_CharacterSelectBG2
	STA iBGCHR2
	RTS


TitleCardCHRBanks:
	.db CHRBank_TitleCardGrass
	.db CHRBank_TitleCardDesert
	.db CHRBank_TitleCardGrass
	.db CHRBank_TitleCardIce
	.db CHRBank_TitleCardGrass
	.db CHRBank_TitleCardDesert
	.db CHRBank_TitleCardSky


ChangeTitleCardCHR:
	LDY iCurrentWorld
	LDA TitleCardCHRBanks, Y
	STA iBGCHR2
	RTS

LoadBonusChanceCHRBanks:
	LDA #CHRBank_ChanceBG1
	STA iBGCHR1
	LDA #CHRBank_ChanceBG2
	STA iBGCHR2
	RTS


LoadMarioSleepingCHRBanks:
	LDY #CHRBank_EndingSprites
	STY iObjCHR1
	INY
	STY iObjCHR2
	LDA #CHRBank_EndingBackground1
	STA iBGCHR1
	LDA #CHRBank_EndingBackground1 + 2
	STA iBGCHR2
	RTS
