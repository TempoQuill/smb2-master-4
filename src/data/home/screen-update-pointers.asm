; PPU update buffers used to update the screen
ScreenUpdateBufferPointers:
	.dw iPPUBuffer ; Default screen update buffer
	.dw iBonusNotes
	.dw iStartingPalettes
	.dw PPUBuffer_CharacterSelect
	.dw PPUBuffer_TitleCard
	.dw PPUBuffer_Text_Game_Over
	.dw mContinueScreenBuffer
	.dw PPUBuffer_Text_Retry
	.dw wTitleCardBuffer
	.dw mLDPBonusChanceBuffer ; Doki Doki Panic leftover
	.dw mLDPBonusChanceNA
	.dw mLDPBonusChanceABtn
	.dw mLDPBonusChanceLifeDisplay
	.dw mPauseBuffer
	.dw mTextDeletionPause
	.dw mTextDeletionBonus
	.dw mTextDeletionABtn
	.dw mTextDeletionBonusUnused
	.dw wWorldWarpDestination
	.dw wContinueScreenBullets
	.dw wHawkDoorBuffer
	.dw PPUBuffer_TitleCardLeftover
	.dw PPUBuffer_PauseExtraLife
	.dw wBonusLayoutBuffer
	.dw PauseOptionData
	.dw PauseOptionPalette1
	.dw PauseOptionPalette2
	.dw PauseOptionPalette3
	.dw mLDPBonusChanceCoinService
	.dw mWarpScreenLayout
	.dw WarpPaletteDataBlack
	.dw WarpPaletteFade3
	.dw WarpPaletteFade2
	.dw WarpPaletteFade1
	.dw WarpPalettes
	.dw mBonusChanceFlashUpdate
