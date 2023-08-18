
PLAY:
	TAX
	LDA NSFMusicData, X
	PHA
	LDX #0
	TXA
	STA SND_CHN
PLAY_Loop:
	STA iMusic, X
	INX
	BNE PLAY_Loop
	PLA
	TAX
	ROR A
	ROR A
	ROR A
	AND #$1F
	TAY
	TXA
	AND #$07
	TAX
	LDA NSFIndeces, X
	STA iMusic, Y
	RTS

NSFMusicData:
	.db $00, $01, $02, $03, $04, $05, $06, $07 ; iMusic
	.db $18, $19, $1a, $1b, $1c, $1d, $1e      ; iMusic
	.db $08, $09, $0a, $0b, $0c, $0d, $0e, $0f ; iHillSFX
	.db $10, $11, $12, $13, $14, $15, $16, $17 ; iDPCMSFX
	.db $20, $21, $22, $23, $24, $25, $26, $27 ; iPulse1SFX
	.db $28, $29, $2a, $2b, $2c, $2d, $2e, $2f ; iNoiseSFX

NSFIndeces:
	.db $01, $02, $04, $08, $10, $20, $40, $80

SetMusicBank:
	SBC #$0C
	ASL A
	STA NSFBank2
	ORA #1
	STA NSFBank3
	RTS
