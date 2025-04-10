PPUBuffer_TitleCard:
	.db $23, $C0, $09
	.db $3E, $0E, $0E, $0E, $0E, $0E, $0E, $8E, $32
	.db $23, $CF, $01, $8C
	.db $23, $D0, $10
	.db $32, $00, $50, $50, $50, $10, $00, $8C, $32, $00, $00, $05, $01, $00, $00, $8C
	.db $23, $E0, $09
	.db $32, $00, $00, $0E, $00, $00, $00, $8C, $32
	.db $23, $EF, $01, $8C
	.db $23, $F0, $06
	.db $32, $00, $50, $50, $50, $50
	.db $23, $F7, $09
	.db $8C, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E
	.db $24, $00, $60, $FF
	.db $24, $20, $60, $FF
	.db $24, $40, $60, $FF
	.db $24, $60, $60, $FF
	.db $27, $40, $60, $FF
	.db $27, $60, $60, $FF
	.db $27, $80, $60, $FF
	.db $27, $A0, $60, $FF
	.db $24, $80, $D6, $FF
	.db $24, $81, $D6, $FF
	.db $24, $82, $D6, $FF
	.db $24, $9D, $D6, $FF
	.db $24, $9E, $D6, $FF
	.db $24, $9F, $D6, $FF
	.db $24, $83, $01, $D0
	.db $24, $9C, $01, $D8
	.db $24, $84, $58, $FB
	.db $24, $A3, $D4, $D1
	.db $24, $BC, $D4, $D7
	.db $24, $A4, $58, $FB
	.db $24, $C4, $58, $FB
	.db $24, $E4, $58, $FB
	.db $25, $04, $58, $FB
	.db $25, $24, $58, $FB
	.db $25, $44, $58, $FB
	.db $25, $64, $58, $FB
	.db $25, $84, $58, $FB
	.db $25, $A4, $58, $FB
	.db $25, $C4, $58, $FB
	.db $25, $E4, $58, $FB
	.db $26, $04, $58, $FB
	.db $26, $24, $58, $FB
	.db $26, $44, $58, $FB
	.db $26, $64, $58, $FB
	.db $26, $84, $58, $FB
	.db $26, $A4, $58, $FB
	.db $26, $C4, $58, $FB
	.db $26, $E4, $58, $FB
	.db $27, $23, $01, $D2
	.db $27, $3C, $01, $D6
	.db $27, $24, $58, $D3
	.db $27, $C8, $08
	.db $44, $FF, $BF, $AF, $AF, $AF, $FF, $11
	.db $27, $D0, $10
	.db $44, $BF, $AF, $AF, $AF, $AF, $EF, $11, $44, $FF, $FF, $FF, $FF, $FF, $FF, $11
	.db $27, $E0, $10
	.db $44, $FF, $FF, $FF, $FF, $FF, $FF, $11, $44, $FF, $FF, $FF, $FF, $FF, $AF, $11
	.db $27, $F0, $08
	.db $44, $05, $05, $05, $05, $05, $05, $01
	.db $27, $04, $58, $FB
	.db $00

; nametable attribute data
PPUBuffer_PauseExtraLife:
	.db $27, $EA, $05
	.db $AA, $AA, $AA, $AA, $AA

; This draws two columns of black tiles along the right side of the nametable to the left of the
; title card, which was the character/level select in Doki Doki Panic. In SMB2, it remains unused.
PPUBuffer_TitleCardLeftover:
	.db $20, $1E, $9E
	.db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	.db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	.db $20, $1F, $9E
	.db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	.db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	.db $23, $C7, $01, $00
	.db $23, $CF, $01, $00
	.db $23, $D7, $01, $00
	.db $23, $DF, $01, $00
	.db $23, $E7, $01, $00
	.db $23, $EF, $01, $00
	.db $23, $F7, $01, $00
	.db $23, $FF, $01, $00
	.db $00

; This table defines which level starts each world.
; The difference between the value of each world indicates how many worlds are
; in the level, which is why there is a slot for an 8th world, even though no
; such world is playable!
WorldStartingLevel:
	.db $00
	.db $03
	.db $06
	.db $09
	.db $0C
	.db $0F
	.db $12
	.db $14
