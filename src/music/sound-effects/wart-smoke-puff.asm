NoiseSFX_WartSmokePuff:
IFNDEF PAL
	.db $1F, $0D, $7E
	.db      $0C, $7E
	.db $17, $0D, $7E
	.db      $0C, $7E
	.db $13, $0D, $7E

	.db $1F, $0E, $7E
	.db      $0D, $7E
	.db $17, $0E, $7E
	.db      $0D, $7E
	.db $13, $0E, $7E

	.db $1F, $0F, $7E
	.db      $0E, $7E
	.db $17, $0F, $7E
	.db      $0E, $7E
	.db $13, $0F, $7E
ELSE
	.db $1F, $0D
	.db      $0C, $7E
	.db $17, $0D, $7E
	.db      $0C
	.db $13, $0D, $7E

	.db $1F, $0E, $7E
	.db      $0D
	.db $17, $0E, $7E
	.db      $0D, $7E
	.db $13, $0E

	.db $1F, $0F, $7E
	.db      $0E, $7E
	.db $17, $0F
	.db      $0E, $7E
	.db $13, $0F, $7E
ENDIF
	.db $00
