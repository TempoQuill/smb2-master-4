;
; ## Tile Quads
;
; Map tiles are made of 4 pattern table tiles arranged in a 2x2 block.
;
; These map tiles are broken up into four tables (`$00-$3F`, `$40-$7F`, `$80-$BF`, `$C0-$FF`) for
; addressability (the tile index is multiplied by 4 to get the first byte). Each table
; coincidentally corresponds to a background subpalette as well.
;

;
; #### Tile quad pointers
;
TileQuadPointersLo:
	.db <TileQuads1
	.db <TileQuads2
	.db <TileQuads3
	.db <TileQuads4

TileQuadPointersHi:
	.db >TileQuads1
	.db >TileQuads2
	.db >TileQuads3
	.db >TileQuads4

;
; #### Tile quad pattern table values
;
; Each subtable corresponds to `$40` tiles so that a single byte offset can be used to address each
; map tile within the table.
;
TileQuads1:
	.db $FE, $FE, $FE, $FE ; $00
	.db $B4, $B6, $B5, $B7 ; $04
	.db $B8, $FA, $B9, $FA ; $08
	.db $FA, $FA, $B2, $B3 ; $0C
	.db $BE, $BE, $BF, $BF ; $10
	.db $BF, $BF, $BF, $BF ; $14
	.db $4A, $4A, $4B, $4B ; $18
	.db $5E, $5F, $5E, $5F ; $1C
	.db $E8, $E8, $A9, $A9 ; $20
	.db $46, $FC, $46, $FC ; $24
	.db $A9, $A9, $A9, $A9 ; $28
	.db $FC, $FC, $FC, $FC ; $2C
	.db $E9, $E9, $A9, $A9 ; $30
	.db $FC, $48, $FC, $48 ; $34
	.db $11, $11, $11, $11 ; $38 ; unused
	.db $22, $22, $22, $22 ; $3C ; unused
	.db $33, $33, $33, $33 ; $40 ; unused
	.db $E8, $EB, $A9, $A9 ; $44
	.db $74, $76, $75, $77 ; $48
	.db $98, $9A, $99, $9B ; $4C
	.db $9C, $9A, $9D, $9B ; $50
	.db $9C, $9E, $9B, $9F ; $54
	.db $58, $5A, $59, $5B ; $58
	.db $5E, $5F, $5E, $5F ; $5C
	.db $8E, $8F, $8F, $8E ; $60
	.db $72, $73, $73, $72 ; $64
	.db $A6, $A6, $A7, $A7 ; $68
	.db $92, $93, $93, $92 ; $6C
	.db $74, $76, $75, $77 ; $70
	.db $70, $72, $71, $73 ; $74
	.db $71, $73, $71, $73 ; $78
	.db $24, $26, $25, $27 ; $7C
	.db $32, $34, $33, $35 ; $80
	.db $33, $35, $33, $35 ; $84
	.db $24, $26, $25, $27 ; $88

TileQuads2:
	.db $FA, $FA, $FA, $FA ; $00
	.db $FA, $FA, $FA, $FA ; $04
	.db $FA, $FA, $FA, $FA ; $08
	.db $FA, $FA, $B0, $B1 ; $0C
	.db $FA, $FA, $B0, $B1 ; $10
	.db $FA, $FA, $B0, $B1 ; $14
	.db $FA, $FA, $B0, $B1 ; $18
	.db $FA, $FA, $B0, $B1 ; $1C
	.db $FA, $FA, $B0, $B1 ; $20
	.db $FA, $FA, $B0, $B1 ; $24
	.db $FA, $FA, $B0, $B1 ; $28
	.db $FA, $FA, $B0, $B1 ; $2C
	.db $FA, $FA, $B0, $B1 ; $30
	.db $FA, $FA, $B0, $B1 ; $34
	.db $A0, $A2, $A1, $A3 ; $38
	.db $80, $82, $81, $83 ; $3C
	.db $F4, $86, $F5, $87 ; $40
	.db $84, $86, $85, $87 ; $44
	.db $FC, $FC, $FC, $FC ; $48
	.db $AD, $FB, $AC, $AD ; $4C
	.db $AC, $AC, $AC, $AC ; $50
	.db $FB, $3B, $3B, $AC ; $54
	.db $FC, $FC, $FC, $FC ; $58
	.db $F4, $86, $F5, $87 ; $5C
	.db $FB, $49, $49, $FB ; $60
	.db $FE, $FE, $FE, $FE ; $64
	.db $FE, $FE, $6D, $FE ; $68
	.db $3C, $3E, $3D, $3F ; $6C
	.db $58, $FD, $59, $5A ; $70
	.db $5B, $5A, $FD, $FD ; $74
	.db $5B, $5C, $FD, $5D ; $78
	.db $FD, $FD, $5B, $5A ; $7C
	.db $6C, $FE, $FE, $FE ; $80
	.db $FE, $FE, $FE, $FE ; $84
	.db $FE, $6E, $FE, $6F ; $88
	.db $20, $22, $21, $23 ; $8C
	.db $6E, $6F, $70, $71 ; $90
	.db $57, $57, $FB, $FB ; $94
	.db $57, $57, $FE, $FE ; $98
	.db $D3, $D3, $FB, $FB ; $9C
	.db $D2, $D2, $FB, $FB ; $A0
	.db $7C, $7E, $7D, $7F ; $A4
	.db $CA, $CC, $CB, $CD ; $A8
	.db $CA, $CC, $CB, $CD ; $AC
	.db $C0, $C2, $C1, $C3 ; $B0
	.db $2C, $2E, $2D, $2F ; $B4
	.db $8E, $8F, $8F, $8E ; $B8
	.db $88, $8A, $89, $8B ; $BC
	.db $89, $8B, $89, $8B ; $C0
	.db $89, $8B, $8C, $8D ; $C4
	.db $88, $8A, $8C, $8D ; $C8
	.db $88, $8A, $89, $8B ; $CC
	.db $88, $8A, $89, $8B ; $D0
	.db $6A, $6C, $6B, $6D ; $D4
	.db $6C, $6C, $6D, $6D ; $D8
	.db $6C, $6E, $6D, $6F ; $DC
	.db $6C, $54, $6D, $55 ; $E0
	.db $32, $34, $33, $35 ; $E4
	.db $33, $35, $33, $35 ; $E8

TileQuads3:
	.db $94, $95, $94, $95 ; $00
	.db $96, $97, $96, $97 ; $04
	.db $48, $49, $48, $49 ; $08
	.db $FE, $FE, $FE, $FE ; $0C
	.db $FB, $32, $32, $33 ; $10
	.db $33, $33, $33, $33 ; $14
	.db $FD, $FD, $FD, $FD ; $18
	.db $34, $FB, $FD, $34 ; $1C
	.db $FB, $30, $FB, $FB ; $20
	.db $FB, $FB, $31, $FB ; $24
	.db $D0, $D0, $D0, $D0 ; $28
	.db $D1, $D1, $D1, $D1 ; $2C
	.db $64, $66, $65, $67 ; $30
	.db $68, $6A, $69, $6B ; $34
	.db $FA, $6C, $FA, $6C ; $38
	.db $6D, $FA, $6D, $FA ; $3C
	.db $92, $93, $93, $92 ; $40
	.db $AE, $AF, $AE, $AF ; $44
	.db $78, $7A, $79, $7B ; $48
	.db $A8, $A8, $AF, $AE ; $4C
	.db $94, $95, $94, $95 ; $50
	.db $96, $97, $96, $97 ; $54
	.db $22, $24, $23, $25 ; $58
	.db $92, $93, $93, $92 ; $5C
	.db $50, $51, $50, $51 ; $60
	.db $AE, $AF, $AE, $AF ; $64
	.db $50, $51, $50, $51 ; $68
	.db $8E, $8F, $8F, $8E ; $6C
	.db $72, $73, $73, $72 ; $70
	.db $50, $52, $51, $53 ; $74
	.db $FD, $FD, $FD, $FD ; $78
	.db $FB, $36, $36, $4F ; $7C
	.db $4F, $4E, $4E, $4F ; $80
	.db $4E, $4F, $4F, $4E ; $84
	.db $92, $93, $93, $92 ; $88
	.db $8E, $8F, $8F, $8E ; $8C
	.db $44, $45, $45, $44 ; $90
	.db $4F, $37, $4E, $FE ; $94
	.db $4F, $3A, $4E, $FE ; $98
	.db $4F, $4E, $37, $38 ; $9C
	.db $4A, $4B, $FE, $FE ; $A0
	.db $72, $73, $4A, $4B ; $A4
	.db $40, $42, $41, $43 ; $A8
	.db $41, $43, $41, $43 ; $AC
TileQuads4:
	.db $40, $42, $41, $43 ; $00
	.db $40, $42, $41, $43 ; $04
	.db $BA, $BC, $BB, $BD ; $08
	.db $BA, $BC, $90, $91 ; $0C
	.db $FA, $FA, $FA, $FA ; $10
	.db $FA, $FA, $FA, $FA ; $14
	.db $FD, $FD, $FD, $FD ; $18
	.db $61, $63, $61, $63 ; $1C
	.db $65, $63, $65, $63 ; $20
	.db $65, $67, $65, $67 ; $24
	.db $60, $62, $61, $63 ; $28
	.db $32, $34, $33, $35 ; $2C
	.db $64, $62, $65, $63 ; $30
	.db $36, $34, $37, $35 ; $34
	.db $64, $66, $65, $67 ; $38
	.db $36, $38, $37, $39 ; $3C
	.db $68, $62, $61, $63 ; $40
	.db $64, $69, $65, $67 ; $44
	.db $46, $62, $61, $63 ; $48
	.db $64, $47, $65, $67 ; $4C
	.db $BA, $BC, $BB, $BD ; $50
	.db $70, $72, $71, $73 ; $54
	.db $8E, $8F, $8F, $8E ; $58
	.db $72, $73, $73, $72 ; $5C
	.db $44, $45, $45, $44 ; $60

EndOfLevelDoor: ; PPU data
	.db $22, $D0, $04, $FC, $FC, $AD, $FA
	.db $22, $F0, $04, $FC, $FC, $AC, $AD
	.db $23, $10, $06, $FC, $FC, $AC, $AC, $AD, $FA
	.db $23, $30, $06, $FC, $FC, $AC, $AC, $AC, $AD
	.db $00

EndOfLevelDoorRowOffsets:
	.db $00
	.db $07
	.db $0E
	.db $17

DefaultCHRAnimationSpeed_Level:
	.db $00 ; 1-1
	.db $00 ; 1-1
	.db $06 ; 3-1
	.db $06 ; 3-1
	.db $0A ; 4-2
	.db $0A ; 4-2
	.db $0B ; 4-3
	.db $0D ; 5-2
	.db $0E ; 5-3
	.db $11 ; 6-3
	.db $11 ; 6-3
	.db $12 ; 7-1
	.db $12 ; 7-1
	.db $12 ; 7-1
	.db $12 ; 7-1
	.db $13 ; 7-2

DefaultCHRAnimationSpeed_Area:
	.db $01 ; 1-1 upward climb
	.db $05 ; 1-1 birdo
	.db $01 ; 3-1 main part
	.db $03 ; 3-1 sky part
	.db $01 ; 4-2 sky ice
	.db $02 ; 4-2 whales
	.db $04 ; 4-3 tower tops
	.db $02 ; 5-2 upward climb
	.db $04 ; 5-3 miniboss birdo
	.db $03 ; 6-3 upward climb
	.db $04 ; 6-3 sky pyramid
	.db $00 ; 7-1 beginning area
	.db $01 ; 7-1 albatoss area
	.db $02 ; 7-1 cloud maze
	.db $03 ; 7-1 upward climb
	.db $00 ; 7-2 entrance

BackgroundCHRAnimationSpeedByWorld:
	.db $07 ; World 1
	.db $07 ; World 2
	.db $07 ; World 3
	.db $07 ; World 4
	.db $09 ; World 5
	.db $07 ; World 6
	.db $05 ; World 7
	.db $0B ; Default
