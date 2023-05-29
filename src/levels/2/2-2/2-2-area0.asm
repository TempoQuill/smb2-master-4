; Level 2-2, Area 0

LevelData_2_2_Area0:
	; Level Header
	;   pages (0-indexed), orientation, background palette, sprite palette, music,
	;   AX-FX type, 3X-9X type, ground setting (0-31), ground type (0-7)
	levelHeader 1, LevelDirection_Horizontal, 1, 1, LevelMusic_Underground, 0, 0, $0a, $3

	.db $8E, $81
	.db $0F, $81
	.db $F0, $B0
	.db $F1, $6F
	.db $BD, $14
	.db $04, $10
	.db $40, $81
	.db $F0, $2E
	.db $F1, $CA
	.db $FF
