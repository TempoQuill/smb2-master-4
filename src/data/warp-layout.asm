WarpAllStarsLayout:
	; MAIN BACKGROUND
	.db $24,$00,$6f,$fe

	.db $24,$2f,$02
	hex 857e

	.db $24,$31,$6f,$fe
	.db $24,$45,$16
	hex 18c595948b840302cecfcdcccbcecac9c8c7c6c4c3c2

	.db $24,$60,$d9,$fe
	.db $24,$61,$d9,$fe
	.db $24,$62,$d9,$fe

	.db $24,$63,$09
	hex fec1c0bfbebdbcbbba

	.db $24,$74,$09
	hex b9b8b7b6b5b4b3b2fe

	.db $24,$7d,$d9,$fe
	.db $24,$7e,$d9,$fe
	.db $24,$7f,$d9,$fe

	.db $24,$83,$04
	hex b1b0afae

	.db $24,$99,$04
	hex adacabaa

	.db $24,$a3,$04
	hex a9a8a7a6

	.db $24,$b9,$04
	hex a5a4a3a2

	.db $24,$c3,$03
	hex a1a09f

	.db $24,$da,$03
	hex 989796

	.db $24,$e3,$01,$93
	.db $24,$fc,$01,$8c
	.db $25,$03,$d2,$7f
	.db $25,$1c,$cf,$77

	.db $25,$e3,$84
	hex 7d766b5e

	.db $25,$fc,$84
	hex 796e6052

	.db $26,$02,$82
	hex 786c

	.db $26,$1d,$82
	hex 6d5f

	.db $27,$80,$60,$fe

	.db $27,$84,$05
	hex 0706fe0504

	.db $27,$97,$04
	hex 01000504

	.db $27,$a0,$60,$fe

WarpCharacterStills:
	.db $26,$c4,$84
	hex 4846433b

	.db $26,$c5,$84
	hex 4745423a

	.db $26,$fc,$01,$44

	.db $27,$14,$02
	hex 4140

	.db $27,$1a,$04
	hex 3f3e3d3c

	.db $27,$34,$0a
	hex 3938fb3736fb35343332

	.db $27,$43,$1b
	hex 31302ffbfbfb2e2dfbfb2c2b2a292827fb2625242322fb21201f1e

	.db $27,$63,$1b
	hex 1d1c1b14141a1917141615131211100f0e1414140d0c140b0a0908

	; WARP
	.db $24,$cd,$06
	hex 9e9c9d9b9a99

	.db $24,$ed,$06
	hex 9192908f8e8d

	.db $25,$0d,$06
	hex 898a88878683

	; BIRDO
	.db $25,$d4,$87
	hex 827c716356504c

	.db $25,$d5,$87
	hex 817b7062554f4b

	.db $25,$d6,$87
	hex 807a6f61544e4a

	.db $26,$13,$84
	hex 72645751

	.db $26,$57,$83
	hex 534d49

	; WORLD
	.db $26,$0a,$06
	hex 9e9cfbfb7574

	.db $26,$2a,$06
	hex 916a69686766

	.db $26,$4a,$06
	hex 895d5c5b5a59

	.db $26,$11,$83
WarpNumberTiles:
	hex fbfbfb

WarpScreenAttributes:
	.db $27,$cb,$42,$f0
	.db $27,$d3,$42,$0f
	.db $27,$dd,$01,$a0
	.db $27,$e2,$04
	hex ccffbbaa
	.db $27,$ed,$01,$0a
	.db $27,$f9,$02
	hex 0401
WarpScreenBlack:
	.db $3f,$00,$60,$0f
WarpAllStarsLayoutEND:
	.db $00

WarpPaletteEntry:
	.db $3f,$00,$60 ; mirrors BG colors for OBJs
