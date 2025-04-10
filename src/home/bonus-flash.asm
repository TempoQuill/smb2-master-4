CopyBonusChanceFlashOffset:
	RAY
	LDA BonusChanceFlashOffsetsLO, Y
	STA z00
	LDA BonusChanceFlashOffsetsHI, Y
	STA z01
	LDY #$13
CopyBonusChanceFlashOffset_Loop:
	LDA (z00), Y
	STA mBonusChanceFlashUpdate, Y
	DEY
	BPL CopyBonusChanceFlashOffset_Loop
	LDA #ScreenUpdateBuffer_RAM_BonusChanceFlash
	STA zScreenUpdateIndex
	RTS

BonusChanceFlashOffsetsHI:
	.dh BonusChanceBackgroundFlashPalettes0
	.dh BonusChanceBackgroundFlashPalettes1
	.dh BonusChanceBackgroundFlashPalettes2
	.dh BonusChanceBackgroundFlashPalettes3
	.dh BonusChanceBackgroundFlashPalettes2

BonusChanceFlashOffsetsLO:
	.dh BonusChanceBackgroundFlashPalettes0
	.dl BonusChanceBackgroundFlashPalettes1
	.dl BonusChanceBackgroundFlashPalettes2
	.dl BonusChanceBackgroundFlashPalettes3
	.dl BonusChanceBackgroundFlashPalettes2

BonusChanceBackgroundFlashPalettes1:
	.db $3F, $00, $10
	.db $0F, $37, $16, $07 ; Most of screen, outline, etc.
	.db $0F, $27, $38, $08 ; 2
	.db $0F, $28, $28, $08 ; Logo
	.db $0F, $28, $28, $08 ; Copyright, Story, Sclera
	.db $00

BonusChanceBackgroundFlashPalettes2:
	.db $3F, $00, $10
	.db $0F, $37, $16, $07 ; Most of screen, outline, etc.
	.db $0F, $27, $38, $08 ; 2
	.db $0F, $21, $21, $01 ; Logo
	.db $0F, $21, $21, $01 ; Copyright, Story, Sclera
	.db $00

BonusChanceBackgroundFlashPalettes3:
	.db $3F, $00, $10
	.db $0F, $37, $36, $07 ; Most of screen, outline, etc.
	.db $0F, $27, $38, $08 ; 2
	.db $0F, $21, $21, $01 ; Logo
	.db $0F, $21, $21, $01 ; Copyright, Story, Sclera
	.db $00

BonusChanceBackgroundFlashPalettes0:
	.db $3F, $00, $10
	.db $0F, $37, $16, $07 ; Most of screen, outline, etc.
	.db $0F, $27, $38, $08 ; 2
	.db $0F, $30, $27, $01 ; Logo
	.db $0F, $37, $27, $30 ; Copyright, Story, Sclera
	.db $00
