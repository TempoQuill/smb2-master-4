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
	.db $08, $69
	.db $08, $8D
	.db $07, $FF
	.db $08, $69
	.db $07, $FF
	.db $08, $53
	.db $07, $FF
	.db $08, $46
	.db $08, $34
	.db $07, $FF
	.db $08, $46
	.db $07, $FF

	.db $08, $85
	.db $07, $FF
	.db $08, $69
	.db $08, $58
	.db $07, $FF
	.db $08, $42
	.db $07, $FF
	.db $08, $58
	.db $07, $FF
	.db $08, $42
	.db $08, $34
	.db $07, $FF
	.db $08, $2B
	.db $07, $FF
	.db $08, $20
	.db $07, $FF
	.db $08, $2B

	.db $08, $76
	.db $07, $FF
	.db $08, $5E
	.db $07, $FF
	.db $08, $4F
	.db $07, $FF
	.db $08, $3A
	.db $08, $4F
	.db $07, $FF
	.db $08, $3A
	.db $07, $FF
	.db $08, $2E
	.db $07, $FF
	.db $08, $27
	.db $08, $1C
	.db $07, $FF
	.db $08, $27
ELSE
	.db $08, $62
	.db $08, $83
	.db $08, $62
	.db $07, $FF
	.db $08, $4D
	.db $08, $41
	.db $07, $FF
	.db $08, $30
	.db $08, $41
	.db $07, $FF

	.db $08, $7C
	.db $08, $62
	.db $07, $FF
	.db $08, $52
	.db $08, $3D
	.db $08, $52
	.db $07, $FF
	.db $08, $3D
	.db $08, $30
	.db $07, $FF
	.db $08, $28
	.db $08, $1E
	.db $07, $FF
	.db $08, $28

	.db $08, $6E
	.db $07, $FF
	.db $08, $57
	.db $08, $49
	.db $08, $36
	.db $07, $FF
	.db $08, $49
	.db $08, $36
	.db $07, $FF
	.db $08, $2B
	.db $08, $24
	.db $07, $FF
	.db $08, $1A
	.db $08, $24
ENDIF
	.db $00

HillSFXData_LampBossDeath:
IFNDEF PAL
	.db $08, $C8
	.db $08, $BD
	.db $07, $FF
	.db $08, $B2
	.db $07, $FF
	.db $08, $A8
	.db $07, $FF
	.db $08, $9F
	.db $08, $96
	.db $07, $FF
	.db $08, $8D
	.db $07, $FF
	.db $08, $85
	.db $07, $FF
	.db $08, $9F
	.db $08, $96
	.db $07, $FF
	.db $08, $8D
	.db $07, $FF
	.db $08, $85
	.db $07, $FF
	.db $08, $9F
	.db $08, $96
	.db $07, $FF
	.db $08, $8D
	.db $07, $FF
	.db $08, $85
	.db $07, $FF
	.db $08, $9F
	.db $08, $96
	.db $07, $FF
	.db $08, $8D
	.db $07, $FF
	.db $08, $85
	.db $07, $FF
	.db $08, $9F
	.db $08, $96
	.db $07, $FF
	.db $08, $8D
	.db $07, $FF
	.db $08, $85
ELSE
	.db $08, $BA
	.db $08, $AF
	.db $08, $A5
	.db $07, $FF
	.db $08, $9C
	.db $08, $93
	.db $07, $FF
	.db $08, $8B
	.db $08, $83
	.db $07, $FF
	.db $08, $7C
	.db $08, $93
	.db $07, $FF
	.db $08, $8B
	.db $08, $83
	.db $08, $7C
	.db $07, $FF
	.db $08, $93
	.db $08, $8B
	.db $07, $FF
	.db $08, $83
	.db $08, $7C
	.db $07, $FF
	.db $08, $93
	.db $08, $8B
	.db $07, $FF
	.db $08, $83
	.db $08, $7C
	.db $08, $93
	.db $07, $FF
	.db $08, $8B
	.db $08, $83
	.db $07, $FF
	.db $08, $7C
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

HillSFXData_Throw:
IFNDEF PAL
	.db $08, $19
	.db $08, $19
	.db $07, $FF
	.db $08, $16
	.db $08, $16
	.db $07, $FF
	.db $08, $14
	.db $08, $14
	.db $07, $FF
	.db $08, $13
	.db $08, $13
	.db $07, $FF
	.db $08, $10
	.db $08, $10
ELSE
	.db $08, $17
	.db $07, $FF
	.db $08, $15
	.db $08, $15
	.db $07, $FF
	.db $08, $12
	.db $07, $FF
	.db $08, $11
	.db $08, $11
	.db $07, $FF
	.db $08, $0F
	.db $08, $0F
ENDIF
	.db $00

HillSFXData_Cherry:
IFNDEF PAL
	.db $08, $1E
	.db $07, $FF
	.db $08, $29
	.db $07, $FF
	.db $08, $20
ELSE
	.db $08, $1C
	.db $08, $26
	.db $07, $FF
	.db $08, $1E
ENDIF
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
IFNDEF PAL
	REPT 2
		.db $08, $19
		.db $07, $FF
		.db $08, $20
		.db $07, $FF
	ENDR
	.db $08, $19
	.db $07, $FF
	.db $08, $20
ELSE
	REPT 2
		.db $08, $17
		.db $07, $FF
		.db $08, $1E
		.db $07, $FF
	ENDR
	.db $08, $17
	.db $07, $FF
	.db $08, $1E
ENDIF
	.db $00
