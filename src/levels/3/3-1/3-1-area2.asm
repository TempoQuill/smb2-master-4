; Level 3-1, Area 2

LevelData_3_1_Area2:
	; Level Header
	;   pages (0-indexed), orientation, background palette, sprite palette, music,
	;   AX-FX type, 3X-9X type, ground setting (0-31), ground type (0-7)
	levelHeader 2, LevelDirection_Horizontal, 1, 1, LevelMusic_Underground, 0, 0, $0a, $2

	.db $87, $13
	.db $06, $19
	.db $F0, $D1
	.db $F2
	.db $94, $5E
	.db $0D, $26
	.db $F2
	.db $BB, $08
	.db $0D, $0A
	.db $06, $16
	.db $F1, $10
	.db $F1, $CA
	.db $FF
