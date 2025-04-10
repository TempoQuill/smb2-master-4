EndingCorkJarRoom:
	; palettes
	.db $3F, $00, $10
	.db $30, $31, $21, $0F ; $50
	.db $30, $27, $16, $0F ; $54
	.db $30, $38, $13, $0F ; $58
	.db $30, $27, $2A, $0F ; $5C
	.db $3F, $14, $0C
	.db $FF, $37, $16, $0F ; $1C
	.db $FF, $30, $10, $0F ; $20
	.db $30, $26, $16, $06 ; $54

	; layout
	; upper left wall
	.db $20, $00, $9E, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72, $73
	.db $20, $01, $9E, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73, $72
	; lower left wall
	.db $22, $02, $8E, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73
	.db $22, $03, $8E, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72
	; floor
	.db $23, $44, $18, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $23, $64, $18, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $23, $84, $18, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $23, $A4, $18, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	; lower right wall
	.db $22, $1C, $8E, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73
	.db $22, $1D, $8E, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72
	; upper right wall
	.db $20, $1E, $9E, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72, $73
	.db $20, $1F, $9E, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72
	.db $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	.db $72, $73, $72
	; door
	.db $22, $C6, $84, $80, $82, $84, $86
	.db $22, $C7, $84, $81, $83, $85, $87
	; jar platform
	.db $23, $0E, $06, $74, $76, $74, $76, $74, $76
	.db $23, $2E, $06, $75, $77, $75, $77, $75, $77

	; upper back wall (above stain glass window)
	.db $20, $02, $5C, $92
	.db $20, $22, $5C, $92
	; stain glass windows
	.db $20, $42, $1C ; row 1
	.db $A8, $A9, $A9, $A9, $A9, $AA
	.db $A8, $A9, $A9, $A9, $A9, $AA
	.db $A8, $A9, $A9, $A9, $A9, $AA
	.db $A8, $A9, $A9, $A9, $A9, $AA
	.db $A8, $A9, $A9, $A9
	.db $20, $62, $1C ; row 2
	.db $AF, $B0, $B1, $B2, $B3, $AB
	.db $AF, $B3, $B0, $B1, $B2, $AB
	.db $AF, $B2, $B3, $B0, $B1, $AB
	.db $AF, $B1, $B2, $B3, $B0, $AB
	.db $AF, $B0, $B1, $B2
	.db $20, $82, $1C ; row 3
	.db $AF, $BB, $BC, $BD, $B4, $AB
	.db $AF, $B4, $BB, $BC, $BD, $AB
	.db $AF, $BD, $B4, $BB, $BC, $AB
	.db $AF, $BC, $BD, $B4, $BB, $AB
	.db $AF, $BB, $BC, $BD
	.db $20, $A2, $1C ; row 4
	.db $AF, $BA, $BE, $BF, $B5, $AB
	.db $AF, $B5, $BA, $BE, $BF, $AB
	.db $AF, $BF, $B5, $BA, $BE, $AB
	.db $AF, $BE, $BF, $B5, $BA, $AB
	.db $AF, $BA, $BE, $BF
	.db $20, $C2, $1C ; row 5
	.db $AF, $B9, $B8, $B7, $B6, $AB
	.db $AF, $B6, $B9, $B8, $B7, $AB
	.db $AF, $B7, $B6, $B9, $B8, $AB
	.db $AF, $B8, $B7, $B6, $B9, $AB
	.db $AF, $B9, $B8, $B7
	.db $20, $E2, $1C ; row 6
	.db $AE, $AD, $AD, $AD, $AD, $AC
	.db $AE, $AD, $AD, $AD, $AD, $AC
	.db $AE, $AD, $AD, $AD, $AD, $AC
	.db $AE, $AD, $AD, $AD, $AD, $AC
	.db $AE, $AD, $AD, $AD

	; lower back wall (below stain glass window)
	.db $21, $02, $C8, $92
	.db $21, $03, $C8, $92
	.db $21, $1C, $C8, $92
	.db $21, $1D, $C8, $92
	.db $21, $04, $58, $92
	.db $21, $24, $58, $92
	.db $21, $44, $58, $92
	.db $21, $64, $58, $92
	.db $21, $84, $58, $92

	; each side of the lower part of the room
	; left
	.db $21, $A4, $CD, $92
	.db $21, $A5, $CD, $92
	.db $21, $A6, $C9, $92 ; above door
	.db $21, $A7, $C9, $92
	.db $21, $A8, $CD, $92
	.db $21, $A9, $CD, $92
	.db $21, $AA, $CD, $92
	; right
	.db $21, $B7, $CD, $92
	.db $21, $B8, $CD, $92
	.db $21, $B9, $CD, $92
	.db $21, $BA, $CD, $92
	.db $21, $BB, $CD, $92

	; window to sky
	; left frame
	.db $21, $AB, $85, $92, $92, $92, $95, $93
	.db $22, $4B, $C8, $90
	.db $21, $AC, $85, $92, $92, $9B, $96, $94
	.db $21, $AD, $83, $92, $9B, $9C
	; right frame
	.db $21, $B4, $83, $92, $9D, $9E
	.db $21, $B5, $85, $92, $92, $9D, $9A, $98
	.db $21, $B6, $85, $92, $92, $92, $99, $97
	.db $22, $56, $C8, $91
	; center frame
	.db $21, $AE, $06, $9B, $9F, $A6, $A7, $9F, $9D
	.db $21, $CE, $06, $9C, $FD, $FD, $FD, $FD, $9E

	; the sky itself
	.db $21, $EE, $46, $FD
	.db $22, $0D, $48, $FD
	.db $22, $2D, $48, $FD
	.db $22, $4C, $4A, $FD
	.db $22, $6C, $4A, $A0
	.db $22, $8C, $0A, $A1, $A2, $A1, $A2, $00, $00, $A1, $A2, $A1, $A2
	.db $22, $AC, $0A, $A3, $A4, $A5, $A4, $00, $00, $A5, $A4, $A3, $A4

	; attributes
	.db $23, $C0, $20
	.db $E2, $D0, $70, $F0, $D0, $70, $F0, $98
	.db $E6, $D6, $71, $FD, $F6, $F3, $F5, $9A
	.db $22, $00, $00, $00, $00, $00, $00, $88
	.db $22, $00, $00, $00, $00, $00, $00, $88
	.db $23, $E0, $20
	.db $AA, $00, $00, $00, $00, $00, $00, $AA
	.db $AA, $40, $00, $00, $00, $00, $00, $AA
	.db $AA, $A4, $A0, $A8, $AA, $A0, $A0, $AA
	.db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A

	.db $00

EndingCelebrationUnusedText_THANK_YOU:
	.db $21, $0C, $09, $ED, $E1, $DA, $E7, $E4, $FB, $F2, $E8, $EE
	.db $00

CorkRoomSpriteStartX:
	.db $30 ; player
	.db $80 ; subcon 8
	.db $80 ; subcon 7
	.db $80 ; subcon 6
	.db $80 ; subcon 5
	.db $80 ; subcon 4
	.db $80 ; subcon 3
	.db $80 ; subcon 2
	.db $80 ; subcon 1
	.db $80 ; cork

CorkRoomSpriteStartY:
	.db $B0 ; player
	.db $A0 ; subcon 8
	.db $A0 ; subcon 7
	.db $A0 ; subcon 6
	.db $A0 ; subcon 5
	.db $A0 ; subcon 4
	.db $A0 ; subcon 3
	.db $A0 ; subcon 2
	.db $A0 ; subcon 1
	.db $95 ; cork

CorkRoomSpriteTargetX:
	.db $10 ; player
	.db $F4 ; subcon 8
	.db $0C ; subcon 7
	.db $E8 ; subcon 6
	.db $18 ; subcon 5
	.db $EC ; subcon 4
	.db $14 ; subcon 3
	.db $F8 ; subcon 2
	.db $08 ; subcon 1
	.db $00 ; cork

CorkRoomSpriteTargetY:
	.db $00 ; player
	.db $C4 ; subcon 8
	.db $C4 ; subcon 7
	.db $B8 ; subcon 6
	.db $B8 ; subcon 5
	.db $A8 ; subcon 4
	.db $A8 ; subcon 3
	.db $A0 ; subcon 2
	.db $A0 ; subcon 1
	.db $00 ; cork

CorkRoomSpriteDelay:
	.db $00 ; player
	.db $E0 ; subcon 8
	.db $D0 ; subcon 7
	.db $B0 ; subcon 6
	.db $90 ; subcon 5
	.db $70 ; subcon 4
	.db $50 ; subcon 3
	.db $30 ; subcon 2
	.db $10 ; subcon 1
	.db $00 ; cork

CorkRoomSpriteAttributes:
	.db $00 ; player
	.db $01 ; subcon 8
	.db $41 ; subcon 7
	.db $01 ; subcon 6
	.db $41 ; subcon 5
	.db $01 ; subcon 4
	.db $41 ; subcon 3
	.db $01 ; subcon 2
	.db $41 ; subcon 1
	.db $02 ; cork

CorkRoomJarOAMData:
;           Y    Tile Attr X
	.db $9F, $88, $03, $80
	.db $9F, $8A, $03, $88
	.db $AF, $8C, $03, $80
	.db $AF, $8E, $03, $88
	.db $00
