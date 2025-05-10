EndOfLevelSlotMachine_AB:
	JSR CopyBonusChanceLayoutToRAM

	LDA #ScreenUpdateBuffer_RAM_BonusChanceLayout
	STA zScreenUpdateIndex
	LDA #Stack100_Menu
	STA iStack
	JSR EnableNMI

	JSR WaitForNMI

	LDA #Stack100_Gameplay
	STA iStack
	JSR DisableNMI

	JSR ResetScrollAndSetBonusChancePalettes

	LDA #MUSIC_NONE
	STA iMusicQueue
	JSR WaitForNMI
	LDA #MUSIC_BONUS_DPCM
	STA iMusicQueue
	LDA iTotalCoins
	BEQ EndOfLevelSlotMachine_Exit
	JMP loc_BANKF_E7F2

EndOfLevelSlotMachine_Exit:
	LDA #90
	JSR DelayFrames
	JMP NoCoinsForSlotMachine

CheckForCoinService:
	; if lives weren't awarded, break out
	TYA
	BEQ CheckForCoinService_Exit

	; if 2 7's are shown, award three coins if it hasn't happened already
	LDA mCoinService
	BMI CheckForCoinService_Exit

	LDA #Slot_7
	LDX zObjectXLo + 7 ; Load reel 2
	CMP mReelBuffer + 8, X
	BNE CheckForCoinService_Exit

	LDX zObjectXLo + 8 ; Load reel 3
	CMP mReelBuffer + 16, X ; Does reel 3 match the previous two?
	BNE CheckForCoinService_Exit

	LDA #2
	STA mCoinService

CheckForCoinService_Exit:
	RTS

ExecuteCoinService:
	LDA mCoinService
	BMI ExecuteCoinService_Exit
	BEQ ExecuteCoinService_Exit

	LDA #ScreenUpdateBuffer_RAM_EraseBonusMessageText
	STA zScreenUpdateIndex

	JSR WaitForNMI

	LDA #ScreenUpdateBuffer_RAM_BonusChanceThreeCoinService
	STA zScreenUpdateIndex

	JSR WaitForNMI

ExecuteCoinService_PlaySound:
	INC iTotalCoins
	DEC mCoinService

	LDA #SFX_COIN
	STA iPulse2SFX

	LDA iTotalCoins
	JSR GetTwoDigitNumberTiles
	STY i588 - 1
	STA i588

	LDA #ScreenUpdateBuffer_RAM_BonusChanceCoinsExtraLife
	STA zScreenUpdateIndex

ExecuteCoinService_Loop:
	JSR WaitForNMI
	INC mCoinServiceTimer
	LDA mCoinServiceTimer
	CMP #$34
	BCC ExecuteCoinService_Loop

	LDA #0
	STA mCoinServiceTimer
	LDA #ScreenUpdateBuffer_RAM_BonusChanceCoinsExtraLife
	STA zScreenUpdateIndex

	LDA mCoinService
	BPL ExecuteCoinService_PlaySound

	LDA #ScreenUpdateBuffer_RAM_EraseBonusMessageText
	STA zScreenUpdateIndex

	JSR WaitForNMI

ExecuteCoinService_Exit:
	RTS
