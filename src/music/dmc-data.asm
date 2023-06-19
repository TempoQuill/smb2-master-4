DMCPitchTable:
;           C    C#   D    D#   E    F    F#   G    G#   A    A#   B
	.db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0E, $0E
	.db $0E, $0E, $0E, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F
	.db $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F
	.db $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F
	.db $00, $00, $00, $00

DMCSamplePointers:
;           C    C#   D    D#   E    F    F#   G    G#   A    A#   B
	.db $00, $03, $06, $0E, $17, $21, $24, $2B, $33, $39, $00, $03
	.db $06, $0E, $17, $00, $03, $06, $0E, $17, $21, $24, $2B, $33
	.db $00, $15, $19, $1D, $20, $23, $27, $2A, $31, $35, $3A, $3D
	.db $00, $0A, $0E, $11, $16, $19, $1D, $21, $28, $2C, $31, $35
	.db $7F, $7F, $7F, $7F

DMCSampleLengths:
;           C    C#   D    D#   E    F    F#   G    G#   A    A#   B
	.db $0A, $0B, $1F, $23, $25, $0A, $1B, $1F, $17, $53, $0A, $0B
	.db $1F, $23, $25, $0A, $0B, $1F, $23, $25, $0A, $1B, $1F, $17
	.db $53, $0E, $0E, $0A, $0B, $0E, $09, $1B, $0D, $11, $0A, $0D
	.db $27, $0D, $0B, $11, $09, $0E, $0F, $1B, $0E, $11, $0D, $11
	.db $01, $01, $01, $01

DPCMOctaves:
	.db PRGBank_DMC_SAW_23
	.db PRGBank_DMC_SAW_23
	.db PRGBank_DMC_SAW_23
	.db PRGBank_DMC_SAW_4
	.db PRGBank_DMC_SAW_5
	.db PRGBank_DMC_SAW_23
