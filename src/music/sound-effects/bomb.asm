NoiseSFX_Bomb:
	.db $1F
	.db $0E
	.db $0F
IFNDEF PAL
	.db $10, $7E, $7E
ELSE
	.db $10, $7E
ENDIF
	.db $1F
	.db $0D
	.db $0B
	.db $0A
	.db $0C
IFNDEF PAL
	.db $0A
ENDIF
	.db $0D
	.db $0B
	.db $0E
	.db $0C
IFNDEF PAL
	.db $1E
	.db $0E
ENDIF
	.db $1D
	.db $0D
	.db $1C
	.db $0F
	.db $1B
	.db $0E
	.db $1A
	.db $0D
IFNDEF PAL
	.db $19, $7E
ENDIF
	.db $18, $7E
	.db $17, $7E
	.db $16, $7E
	.db $15, $7E
IFNDEF PAL
	.db $14, $7E
ENDIF
	.db $13, $7E
	.db $12, $7E
	.db $11, $7E
	.db $00
