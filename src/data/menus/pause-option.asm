PauseOptionData:
	; CONTINUE
	.db $25, $A6, $08
	.db $DC, $E8, $E7, $ED, $E2, $E7, $EE, $DE
	; SAVE AND CONTINUE
	.db $25, $E6, $11
	.db $EC, $DA, $EF, $DE, $FB, $DA, $E7, $DD, $FB
	.db $DC, $E8, $E7, $ED, $E2, $E7, $EE, $DE
	; SAVE AND QUIT
	.db $26, $26, $0D
	.db $EC, $DA, $EF, $DE, $FB, $DA, $E7, $DD, $FB
	.db $80, $EE, $E2, $Ed
	.db $00

PauseOptionPalette1:
	.db $27, $D9, $05
	.db $8C, $AF, $A3, $A0, $A0
	.db $27, $E1, $04
	.db $08, $0A, $0A, $0A
	.db $00

PauseOptionPalette2:
	.db $27, $D9, $05
	.db $C8, $FA, $F2, $F0, $F0
	.db $27, $E1, $04
	.db $08, $0A, $0A, $0A
	.db $00

PauseOptionPalette3:
	.db $27, $D9, $05
	.db $88, $AA, $A2, $A0, $A0
	.db $27, $E1, $04
	.db $0C, $0F, $0F, $0F
	.db $00