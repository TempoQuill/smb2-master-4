;
; Note Lengths
; ============
;
; These are lookup tables used to determine note lengths (in ticks).
;
; There are a few weird values floating around, but it's generally broken into
; groups of 13 note lengths that correspond to a tempo as follows:
;
; $x0: 1/16 note
; $x1: 1/16 note
; $x2: 1/4 note triplet
; $x3: 1/4 note triplet
; $x4: 1/8 note
; $x5: dotted 1/8 note
; $x6: 1/2 note triplet
; $x7: 1/2 triplet-1/4 tied note (bank 1), 1/2 note triplet (bank 2-3)
; $x8: 1/4 note
; $x9: dotted 1/4 note
; $xA: 1/2 note
; $xB: dotted 1/2 note
; $xC: whole note
; $xD: 1/16 triplet (bank 1), 1/8 triplet (bank 2-3)
; $xE: 1/8 triplet
; $xF: whole triplet (bank 1), 1/8 triplet (bank 2-3)
;
TickLength_Warp = $22
TickLength_SpadeGame = $3C
TickLength_Death = $42
TickLength_CHR = $44 ; $43
TickLength_Crystal = $48
TickLength_BossBeaten = $4E
TickLength_Ending12 = $50
TickLength_Ending34 = $54
TickLength_Subspace = $5C
TickLength_Boss = $64
TickLength_Overworld = $6C
TickLength_Wart = $70
TickLength_Star = $78
TickLength_GameOver = $88
TickLength_Underground = $8C
TickLength_BonusChance = $94
TickLength_Ending5 = $A8
TickLength_Title = $B0 ; $af

;
; Triangle Linearity Indeces
; ==========================
;
; The triangle channel goes by two linearity ratios that both max out at $7F
;
; $80 / $A0 - 15/16 RATIO
; The more common of the two, particularly useful for prevalant bass and leads
;
; $B0-$F0 - 4/7 RATIO
; Used for staccato, used by the Wart and title themes
;

Triangle15Outta16Lengths:
	.db $00
	.db $03, $07, $0B, $0F, $12, $16, $1A, $1E
	.db $21, $25, $29, $2D, $30, $34, $38, $3C
	.db $3F, $43, $47, $4B, $4E, $52, $56, $5A
	.db $5D, $61, $65, $69, $6C, $70, $74, $78
	.db $7B, $7F, $7F, $7F, $7F, $7F, $7F, $7F
	.db $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F
	.db $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F

Triangle4Outta7Lengths:
	.db $00
	.db $02, $04, $06, $09, $0B, $0D, $10, $12
	.db $14, $16, $19, $1B, $1D, $20, $22, $24
	.db $26, $29, $2B, $2D, $30, $32, $34, $36
	.db $39, $3B, $3D, $40, $42, $44, $46, $49
	.db $4B, $4D, $50, $52, $54, $56, $59, $5B
	.db $5D, $60, $62, $64, $66, $69, $6B, $6D
	.db $70, $72, $74, $76, $79, $7B, $7D, $7F