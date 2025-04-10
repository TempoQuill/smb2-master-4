;
; Public IRQ
;
; ***Used for the wave effect during the warp cutscene***
;
; ***Screen tearing might occur with mIRQIntensity***
IRQ:
	PHA				; 3 3
	; index
	LDA MMC5_IRQStatus
	STY mTempReg ; preserve Y	; 4 29
	STX mTempReg + 1
	INC mIRQIndex			; 6 35
	LDA mIRQIndex			; 4 39
	AND #$0f			; 2 47
	TAY				; 2 49
	; scanline X position
	LDA SineData, Y			; 5 69
	STA MMC5_Multiplier		; 4 73
	LDA mIRQIntensity		; 4 77
	STA MMC5_Multiplier + 1		; 4 81
	LDA MMC5_Multiplier + 1		; 4 85
	EOR SineXORs, Y
	STA mIRQFinalScroll		; 4 89
	TAX
	; nametable
	LDA SineControls, Y
	STA mIRQFinalScroll + 1
	LDY $00
	DEY
	DEY
	DEY
	DEY
	LDY PPUSTATUS
	LDY #0
	STA PPUCTRL			; 4 11
	STX PPUSCROLL			; 4 19
	STY PPUSCROLL			; 4 25
	; next scanline
	LDY mNextScanline		; 4 93
	INY				; 2 95
	INY				; 2 97
	CPY #$f0			; 2 99
	BCS IRQ_PrepNextFrame		; 2 105	3 106
	STY mNextScanline		; 4 109
	STY MMC5_IRQScanlineCompare	; 4 113
	PLA				; 4 103
	LDY mTempReg			; 4 117
	LDX mTempReg + 1
	RTI				; 6 123

IRQ_PrepNextFrame:
	; next scanline
	LDY #2				; 2 108
	STY mNextScanline		; 4 112
	STY MMC5_IRQScanlineCompare	; 4 116
	; offset
	LDA mIRQOffset
	LSR A
	LSR A
	AND #$0f
	STA mIRQIndex
	PLA				; 4 103
	LDY mTempReg			; 4 126
	LDX mTempReg + 1
	RTI				; 6 132

SineData:
	.db $00, $61, $b4, $ec, $ff, $ec, $b4, $61
	.db $00, $60, $b3, $eb, $fe, $eb, $b3, $60
SineXORs:
	.db $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff
SineControls:
	.db $b5, $b5, $b5, $b5, $b5, $b5, $b5, $b5
	.db $b5, $b4, $b4, $b4, $b4, $b4, $b4, $b4
