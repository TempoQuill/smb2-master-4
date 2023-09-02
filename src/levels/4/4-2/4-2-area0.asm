; Level 4-2, Area 0

LevelData_4_2_Area0:
	; Level Header
	;   pages (0-indexed), orientation, background palette, sprite palette, music,
	;   AX-FX type, 3X-9X type, ground setting (0-31), ground type (0-7)
	levelHeader 1, LevelDirection_Horizontal, 2, 1, LevelMusic_Underground, 0, 0, $0a, $2

	.db $AC, $3C
	.db $F0, $8C
	.db $F1, $88
	.db $C8, $12
	.db $F5, $0A, $10
	.db $F1, $2A
	.db $FF
