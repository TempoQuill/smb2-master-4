MACRO pulse_note pitch, octave, length
t = ((pitch >> octave) | $0800) - 1
	.dh t
	.dl t
	REPT length - 1
		.db $40
	ENDR
ENDM


Pulse2SFXData_StopSlot:
IFNDEF PAL
	.db $08, $46, $40, $40
	.db      $40, $40, $40, $40
	.db $08, $37, $40, $40
	.db      $40, $40, $40, $40
	.db $08, $2E, $40, $40
	.db      $40, $40, $40, $40
	.db $08, $22, $40, $40, $40
	.db      $40, $40, $40, $40, $40
	.db      $40, $40, $40, $40
	.db      $40, $40, $40, $40, $40
ELSE
	.db $08, $41, $40, $40
	.db      $40, $40, $40
	.db $08, $33, $40, $40
	.db      $40, $40, $40
	.db $08, $2B, $40, $40
	.db      $40, $40, $40
	.db $08, $20, $40, $40, $40, $40
	.db      $40, $40, $40, $40, $40
	.db      $40, $40, $40, $40, $40
ENDIF
	.db $00

Pulse2SFXData_HawkUp:
	.db $81
IFNDEF PAL
	.db $0A, $1A
	.db $0A, $15
	.db $0A, $10
	.db $0A, $0B
	.db $0A, $06
	.db $0A, $01
	.db $09, $FC
	.db $09, $F7
ENDIF
	.db $09, $F2
	.db $09, $ED
	.db $09, $E8
	.db $09, $E3
	.db $09, $DE
	.db $09, $D9
	.db $09, $D4
	.db $09, $CF
	.db $09, $CA
	.db $09, $C5
	.db $09, $C0
	.db $09, $BB
	.db $09, $B6
	.db $09, $B1
	.db $09, $AC
	.db $09, $A7
IFDEF PAL
	.db $09, $A2
	.db $09, $9D
	.db $09, $98
	.db $09, $93
	.db $09, $8E
	.db $09, $8A
ENDIF
	.db $00

Pulse2SFXData_HawkDown:
	.db $81
IFDEF PAL
	.db $09, $8A
	.db $09, $8E
	.db $09, $93
	.db $09, $98
	.db $09, $9D
	.db $09, $A2
ENDIF
	.db $09, $A7
	.db $09, $AC
	.db $09, $B1
	.db $09, $B6
	.db $09, $BB
	.db $09, $C0
	.db $09, $C5
	.db $09, $CA
	.db $09, $CF
	.db $09, $D4
	.db $09, $D9
	.db $09, $DE
	.db $09, $E3
	.db $09, $E8
	.db $09, $ED
	.db $09, $F2
IFNDEF PAL
	.db $09, $F7
	.db $09, $FC
	.db $0A, $01
	.db $0A, $06
	.db $0A, $0B
	.db $0A, $10
	.db $0A, $15
	.db $0A, $1A
ENDIF
	.db $00

Pulse2SFXData_Shrink:
	.db $A1
REPT 3
	IFNDEF PAL
		.db $08, $FE, $40
		.db $09, $7C, $40
		.db $08, $FE, $40
		.db $09, $7C, $40
		.db $0A, $3A, $40
		.db $0B, $56, $40
		.db $0D, $00, $40
	ELSE
		.db $08, $EC
		.db $09, $61, $40
		.db $08, $EC, $40
		.db $09, $61
		.db $0A, $12, $40
		.db $0B, $1A, $40
		.db $0C, $A5, $40
	ENDIF
ENDR
	.db $00

Pulse2SFXData_Throw:
IFNDEF PAL
	pulse_note RC_, 6, 3
	pulse_note RD_, 6, 3
	pulse_note RE_, 6, 3
	pulse_note RF_, 6, 3
	pulse_note RG_, 6, 3
ELSE
	pulse_note RC_, 6, 2
	pulse_note RD_, 6, 3
	pulse_note RE_, 6, 2
	pulse_note RF_, 6, 3
	pulse_note RG_, 6, 2
ENDIF
	.db $00

Pulse2SFXData_1UP:
IFNDEF PAL
	.db $08, $53, $40, $40, $40
	.db $08, $46, $40, $40, $40, $40
	.db $08, $29, $40, $40, $40
	.db $08, $34, $40, $40, $40, $40
	.db $08, $2E, $40, $40, $40
	.db $08, $22, $40, $40, $40, $40
ELSE
	.db $08, $4D, $40, $40
	.db $08, $41, $40, $40, $40
	.db $08, $26, $40, $40, $40
	.db $08, $30, $40, $40, $40
	.db $08, $2B, $40, $40
	.db $08, $20, $40, $40, $40
ENDIF
	.db $00

Pulse2SFXData_Injury:
	.db $81
IFNDEF PAL
	REPT 3
		.db $19, $FC
		.db $1A, $A6, $40
		.db $1B, $F8, $40
		.db $1D, $4D, $40
	ENDR
ELSE
	REPT 3
		.db $19, $D8
		.db $1A, $76, $40
		.db $1B, $B0
		.db $1C, $EC, $40
	ENDR
ENDIF
	.db $00

Pulse2SFXData_Coin:
IFNDEF PAL
	.db $08, $37, $40, $40, $40
	.db $08, $29, $40, $40, $40, $40
	.db      $40, $40, $40, $40
	.db      $40, $40, $40, $40, $40
	.db      $40, $40, $40, $40
ELSE
	.db $08, $33, $40, $40
	.db $08, $26, $40, $40, $40, $40
	.db      $40, $40, $40, $40, $40
	.db      $40, $40, $40, $40, $40
ENDIF
	.db $00
