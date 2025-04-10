PPUBuffer_Text_Game_Over:
	.db $21, $CB, $0A
	.db $E0, $DA, $E6, $DE, $FB, $FB, $E8, $EF, $DE, $EB ; GAME OVER
	.db $00

PPUBuffer_Text_Continue:
	.db $21, $75, $01, $00 ; (Placeholder for continue count)
	.db $21, $6A, $0A, $F6, $FB, $DC, $E8, $E7, $ED, $E2, $E7, $EE, $DE ; * CONTINUE

PPUBuffer_Text_Retry:
	.db $21, $AA, $07, $F6, $FB, $EB, $DE, $ED, $EB, $F2 ; * RETRY
	.db $21, $CB, $0A, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB ; Blank, erases "GAME OVER"
	.db $00

BonusChanceUpdateBuffer_BONUS_CHANCE_Unused:
	.db ScreenUpdateBuffer_RAM_BonusChanceUnused
	.db ScreenUpdateBuffer_RAM_EraseBonusMessageText
BonusChanceUpdateBuffer_PUSH_A_BUTTON:
	.db ScreenUpdateBuffer_RAM_PushAButtonText
	.db ScreenUpdateBuffer_RAM_ErasePushAButtonText
BonusChanceUpdateBuffer_NO_BONUS:
	.db ScreenUpdateBuffer_RAM_NoBonusText
	.db ScreenUpdateBuffer_RAM_EraseBonusMessageText
BonusChanceUpdateBuffer_PLAYER_1UP:
	.db ScreenUpdateBuffer_RAM_Player1UpText
	.db ScreenUpdateBuffer_RAM_EraseBonusMessageText
