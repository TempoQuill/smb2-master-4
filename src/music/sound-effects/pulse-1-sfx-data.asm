MACRO pulse_note pitch, octave, length
t = ((pitch >> octave) | $0800) - 1
	.dh t
	.dl t
	REPT length - 1
		.db $40
	ENDR
ENDM


Pulse2SFXData_StopSlot:
	pulse_note RG_, 5, 7
	pulse_note RB_, 5, 7
	pulse_note RD_, 6, 7
	pulse_note RG_, 6, 18
	.db $00

Pulse2SFXData_HawkUp:
	.db $81
	.db $0A, $1A
	.db $0A, $15
	.db $0A, $10
	.db $0A, $0B
	.db $0A, $06
	.db $0A, $01
	.db $09, $FC
	.db $09, $F7
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
	.db $00

Pulse2SFXData_HawkDown:
	.db $81
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
	.db $09, $F7
	.db $09, $FC
	.db $0A, $01
	.db $0A, $06
	.db $0A, $0B
	.db $0A, $10
	.db $0A, $15
	.db $0A, $1A
	.db $00

Pulse2SFXData_Shrink:
	.db $A1
REPT 3
	pulse_note RA_, 3, 2
	pulse_note RD_, 3, 2
	pulse_note RA_, 3, 2
	pulse_note RD_, 3, 2
	pulse_note RG_, 2, 2
	pulse_note RC_, 2, 2
	pulse_note RF_, 1, 2
ENDR
	.db $00

Pulse2SFXData_Throw:
	pulse_note RC_, 6, 3
	pulse_note RD_, 6, 3
	pulse_note RE_, 6, 3
	pulse_note RF_, 6, 3
	pulse_note RG_, 6, 3
	.db $00

Pulse2SFXData_1UP:
	pulse_note RE_, 5, 4
	pulse_note RG_, 5, 5
	pulse_note RE_, 6, 4
	pulse_note RC_, 6, 5
	pulse_note RD_, 6, 4
	pulse_note RG_, 6, 5
	.db $00

Pulse2SFXData_Injury:
	.db $81
REPT 3
	.db $19, $FC
	.db $1A, $A6, $40
	.db $1B, $F8, $40
	.db $1D, $4D, $40
ENDR
	.db $00

Pulse2SFXData_Coin:
	pulse_note RB_, 5, 4
	pulse_note RE_, 6, 18
	.db $00
