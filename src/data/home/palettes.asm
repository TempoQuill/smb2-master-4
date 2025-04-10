PlayerSelectSpritePalettesDark:
	.db $3F, $10, $10 ; PPU Data
	.db $0F, $22, $12, $01
	.db $0F, $22, $12, $01
	.db $0F, $22, $12, $01
	.db $0F, $22, $12, $01

PlayerSelectPaletteOffsets:
	.db (PlayerSelectSpritePalettes_Mario - PlayerSelectSpritePalettes)
	.db (PlayerSelectSpritePalettes_Princess - PlayerSelectSpritePalettes)
	.db (PlayerSelectSpritePalettes_Toad - PlayerSelectSpritePalettes)
	.db (PlayerSelectSpritePalettes_Luigi - PlayerSelectSpritePalettes)

PlayerSelectSpritePalettes:
PlayerSelectSpritePalettes_Mario:
	.db $3F, $10, $04
	.db $0F, $27, $16, $01
PlayerSelectSpritePalettes_Luigi:
	.db $3F, $14, $04
	.db $0F, $36, $2A, $01
PlayerSelectSpritePalettes_Toad:
	.db $3F, $18, $04
	.db $0F, $27, $30, $01
PlayerSelectSpritePalettes_Princess:
	.db $3F, $1C, $04
	.db $0F, $36, $25, $07

TitleCardPalettes:
	.db $3F, $00, $20 ; PPU data
	.db $38, $30, $1A, $0F
	.db $38, $38, $0F, $0F
	.db $38, $17, $17, $38
	.db $38, $28, $18, $08
	.db $38, $30, $27, $01
	.db $38, $37, $27, $06
	.db $38, $25, $36, $06
	.db $38, $12, $36, $01
	.db $00

BonusChanceSpritePalettes:
	.db $0F, $37, $16, $0F
	.db $0F, $37, $16, $0F
	.db $0F, $37, $16, $0F
	.db $0F, $37, $16, $0F
