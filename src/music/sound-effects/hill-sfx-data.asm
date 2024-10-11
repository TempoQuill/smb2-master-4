MACRO hill_note pitch, octave, length
	REPT length
	t = ((pitch >> octave) | $0800) - 1
		.dh t
		.dl t
	ENDR
ENDM

MACRO hill_rest length
	REPT length
		.db $07, $Ff
	ENDR
ENDM

HillSFXData_Jump:
IFNDEF PAL
	.db $08, $5B
	.db $08, $58
	.db $08, $55
	.db $08, $52
	.db $08, $4F
	.db $08, $4C
	.db $08, $49
	.db $08, $46
ELSE
	.db $08, $53
	.db $08, $50
	.db $08, $4D
	.db $08, $4A
	.db $08, $47
	.db $08, $44
	.db $08, $41
ENDIF
	.db $00

HillSFXData_Mushroom:
IFNDEF PAL
	hill_note RC_, 5, 1
	hill_note RG_, 4, 1
	hill_rest 1
	hill_note RC_, 5, 1
	hill_rest 1
	hill_note RE_, 5, 1
	hill_rest 1
	hill_note RG_, 5, 1
	hill_note RC_, 6, 1
	hill_rest 1
	hill_note RG_, 5, 1
	hill_rest 1
	hill_note RG#, 4, 1
	hill_rest 1
	hill_note RC_, 5, 1
	hill_note RD#, 5, 1
	hill_rest 1
	hill_note RG#, 5, 1
	hill_rest 1
	hill_note RD#, 5, 1
	hill_rest 1
	hill_note RG#, 5, 1
	hill_note RC_, 6, 1
	hill_rest 1
	hill_note RD#, 6, 1
	hill_rest 1
	hill_note RG#, 6, 1
	hill_rest 1
	hill_note RD#, 6, 1
	hill_note RA#, 4, 1
	hill_rest 1
	hill_note RD_, 5, 1
	hill_rest 1
	hill_note RF_, 5, 1
	hill_rest 1
	hill_note RA#, 5, 1
	hill_note RF_, 5, 1
	hill_rest 1
	hill_note RA#, 5, 1
	hill_rest 1
	hill_note RD_, 6, 1
	hill_rest 1
	hill_note RF_, 6, 1
	hill_note RA#, 6, 1
	hill_rest 1
	hill_note RF_, 6, 1
ELSE
	hill_note RC_, 5, 1
	hill_note RG_, 4, 1
	hill_note RC_, 5, 1
	hill_rest 1
	hill_note RE_, 5, 1
	hill_note RG_, 5, 1
	hill_rest 1
	hill_note RC_, 6, 1
	hill_note RG_, 5, 1
	hill_rest 1
	hill_note RG#, 4, 1
	hill_note RC_, 5, 1
	hill_rest 1
	hill_note RD#, 5, 1
	hill_note RG#, 5, 1
	hill_note RD#, 5, 1
	hill_rest 1
	hill_note RG#, 5, 1
	hill_note RC_, 6, 1
	hill_rest 1
	hill_note RD#, 6, 1
	hill_note RG#, 6, 1
	hill_rest 1
	hill_note RD#, 6, 1
	hill_note RA#, 4, 1
	hill_rest 1
	hill_note RD_, 5, 1
	hill_note RF_, 5, 1
	hill_note RA#, 5, 1
	hill_rest 1
	hill_note RF_, 5, 1
	hill_note RA#, 5, 1
	hill_rest 1
	hill_note RD_, 6, 1
	hill_note RF_, 6, 1
	hill_rest 1
	hill_note RA#, 6, 1
	hill_note RF_, 6, 1
ENDIF
	.db $00

HillSFXData_LampBossDeath:
IFNDEF PAL
	hill_note RC#, 4, 1
	hill_note RD_, 4, 1
	hill_rest 1
	hill_note RD#, 4, 1
	hill_rest 1
	hill_note RE_, 4, 1
	REPT 5
		hill_rest 1
		hill_note RF_, 4, 1
		hill_note RF#, 4, 1
		hill_rest 1
		hill_note RG_, 4, 1
		hill_rest 1
		hill_note RG#, 4, 1
	ENDR
ELSE
	hill_note RC#, 4, 1
	hill_note RD_, 4, 1
	hill_note RD#, 4, 1
	hill_rest 1
	hill_note RE_, 4, 1
	hill_note RF_, 4, 1
	hill_rest 1
	hill_note RF#, 4, 1
	hill_note RG_, 4, 1
	hill_rest 1
	hill_note RG#, 4, 1
	hill_note RF_, 4, 1
	hill_rest 1
	hill_note RF#, 4, 1
	hill_note RG_, 4, 1
	hill_note RG#, 4, 1
	hill_rest 1
	hill_note RF_, 4, 1
	hill_note RF#, 4, 1
	hill_rest 1
	hill_note RG_, 4, 1
	hill_note RG#, 4, 1
	hill_rest 1
	hill_note RF_, 4, 1
	hill_note RF#, 4, 1
	hill_rest 1
	hill_note RG_, 4, 1
	hill_note RG#, 4, 1
	hill_note RF_, 4, 1
	hill_rest 1
	hill_note RF#, 4, 1
	hill_note RG_, 4, 1
	hill_rest 1
	hill_note RG#, 4, 1
ENDIF
	.db $00

HillSFXData_Vine:
IFNDEF PAL
	.db $08, $3B
	.db $08, $38
	.db $08, $35
	.db $08, $32
	.db $08, $2F
	.db $08, $2C
ELSE
	.db $08, $36
	.db $08, $33
	.db $08, $30
	.db $08, $2D
	.db $08, $2A
	.db $08, $27
ENDIF
	.db $00

HillSFXData_Watch:
IFNDEF PAL
	hill_note RE_, 6, 3
	hill_rest 6
	hill_note RC_, 6, 3
	hill_rest 2
	hill_note RD_, 6, 3
	hill_rest 2
	hill_note RG_, 5, 3
ELSE
	hill_note RE_, 6, 2
	hill_rest 6
	hill_note RC_, 6, 2
	hill_rest 2
	hill_note RD_, 6, 2
	hill_rest 3
	hill_note RG_, 5, 3
ENDIF
	.db $00

HillSFXData_Cherry:
	hill_note RA_, 6, 1
IFNDEF PAL
	hill_rest 1
ENDIF
	hill_note RE_, 6, 1
	hill_rest 1
	hill_note RG#, 6, 1
	.db $00

HillSFXData_Fall:
IFDEF PAL
	.db $08, $17
	.db $08, $18
ENDIF
	.db $08, $19
	.db $08, $1A
	.db $08, $1B
	.db $08, $1C
	.db $08, $1D
	.db $08, $1E
	.db $08, $1F
	.db $08, $20
	.db $08, $21
	.db $08, $22
	.db $08, $23
	.db $08, $24
	.db $08, $25
	.db $08, $26
	.db $08, $27
	.db $08, $28
	.db $08, $29
	.db $08, $2A
	.db $08, $2B
	.db $08, $2C
	.db $08, $2D
	.db $08, $2E
	.db $08, $2F
	.db $08, $30
	.db $08, $31
	.db $08, $32
	.db $08, $33
	.db $08, $34
	.db $08, $35
	.db $08, $36
	.db $08, $37
	.db $08, $38
	.db $08, $39
	.db $08, $3A
	.db $08, $3B
	.db $08, $3C
	.db $08, $3D
	.db $08, $3E
	.db $08, $3F
	.db $08, $40
	.db $08, $41
	.db $08, $42
	.db $08, $43
	.db $08, $44
	.db $08, $45
	.db $08, $46
	.db $08, $47
	.db $08, $48
	.db $08, $49
	.db $08, $4A
	.db $08, $4B
	.db $08, $4C
	.db $08, $4D
	.db $08, $4E
	.db $08, $4F
	.db $08, $50
	.db $08, $51
	.db $08, $52
IFNDEF PAL
	.db $08, $53
	.db $08, $54
	.db $08, $55
	.db $08, $56
	.db $08, $57
	.db $08, $58
ENDIF
	.db $00

HillSFXData_Select:
REPT 2
	hill_note RC_, 7, 1
	hill_rest 1
	hill_note RG#, 6, 1
	hill_rest 1
ENDR
	hill_note RC_, 7, 1
	hill_rest 1
	hill_note RG#, 6, 1
	.db $00

HillSFXData_Fireball:
	hill_note RG#, 5, 1
	hill_note RC_, 6, 1
	hill_note RF#, 6, 1
	.db $00
