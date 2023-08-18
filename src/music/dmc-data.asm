DMCPitchTable:
;           C    C#   D    D#   E    F    F#   G    G#   A    A#   B
	.db $00, $0F, $00, $00, $4B, $4B, $4B, $4B, $4B, $4B, $4B, $4B
	.db $4B, $4B, $4E, $4E, $4E, $4E, $4E, $4F, $4F, $4F, $4F, $4F
	.db $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
	.db $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
	.db $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
	.db $00, $00, $00, $00

DMCSamplePointers:
;           C    C#   D    D#   E    F    F#   G    G#   A    A#   B
	.db $7F, $41, $7F, $7F, $00, $08, $16, $18, $1B, $21, $35, $39
	.db $3B, $3E, $00, $08, $16, $18, $1B, $00, $08, $16, $18, $1B
	.db $54, $50, $4E, $00, $03, $06, $0E, $17, $21, $24, $2B, $33
	.db $00, $15, $19, $1D, $20, $23, $27, $2A, $31, $35, $3A, $3D
	.db $00, $0A, $0E, $11, $16, $19, $1D, $21, $28, $2C, $31, $35
	.db $7F, $7F, $7F, $7F

DMCSampleLengths:
;           C    C#   D    D#   E    F    F#   G    G#   A    A#   B
	.db $00, $48, $00, $00, $1D, $37, $07, $0B, $17, $4F, $0D, $07
	.db $0A, $0B, $1D, $37, $07, $0B, $17, $1D, $37, $07, $0B, $17
	.db $4F, $0D, $07, $0A, $0B, $1F, $23, $25, $0A, $1B, $1F, $17
	.db $53, $0E, $0E, $0A, $0B, $0E, $09, $1B, $0D, $11, $0A, $0D
	.db $27, $0D, $0B, $11, $09, $0E, $0F, $1B, $0E, $11, $0D, $11
	.db $00, $00, $00, $00

DPCMOctaves:
	audio_bank PRGBank_DMC_SAW_2
	audio_bank PRGBank_DMC_SAW_2
	audio_bank PRGBank_DMC_SAW_3
	audio_bank PRGBank_DMC_SAW_4
	audio_bank PRGBank_DMC_SAW_5
	audio_bank PRGBank_DMC_SAW_2
