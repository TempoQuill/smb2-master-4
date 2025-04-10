BlackAndWhitePalette:
	.db $0F, $30, $30, $0F


SetBlackAndWhitePalette:
	LDA PPUSTATUS
	LDA #$3F
	LDY #$00
	STA PPUADDR
	STY PPUADDR

SetBlackAndWhitePalette_Loop:
	TYA
	AND #$03
	TAX
	LDA BlackAndWhitePalette, X
	STA PPUDATA
	INY
	CPY #$14
	BCC SetBlackAndWhitePalette_Loop
	RTS


SetScrollXYTo0:
	LDA #$00
	STA zPPUScrollY
	STA zPPUScrollX
	STA zYScrollPage
	STA zXScrollPage
	RTS
