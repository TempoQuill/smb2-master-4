NoteFrequencyData:
IFNDEF PAL
	.dw $1AB8 ; C
	.dw $1938 ; C# / Db
	.dw $17CC ; D
	.dw $1678 ; D# / Eb
	.dw $1534 ; E
	.dw $1404 ; F
	.dw $12E4 ; F# / Gb
	.dw $11D4 ; G
	.dw $10D4 ; G# / Ab
	.dw $0FE0 ; A
	.dw $0EFC ; A# / Bb
	.dw $0E24 ; B
ELSE
	.dw $18A8 ; C
	.dw $1744 ; C# / Db
	.dw $15F4 ; D
	.dw $14BC ; D# / Eb
	.dw $1390 ; E
	.dw $1278 ; F
	.dw $1170 ; F# / Gb
	.dw $1074 ; G
	.dw $0F88 ; G# / Ab
	.dw $0EA4 ; A
	.dw $0DD4 ; A# / Bb
	.dw $0D0C ; B
ENDIF
