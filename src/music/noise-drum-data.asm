NoiseDrumData_ClosedHihat:
	.db $1F, $03
	.db $1E, $02
	.db $1D, $01
	.db $00

NoiseDrumData_UpperSnare:
	.db $1F, $0A
	.db      $07
	.db      $01
	.db $00

NoiseDrumData_OpenHihat:
	.db $1F, $01
	.db $18, $02
	.db $1F, $03
	.db $18, $02
	.db $14, $01
	.db $00

NoiseDrumData_Kick:
IFNDEF PAL
	.db $1F, $8D
	.db      $8E
ELSE
	.db $1F, $8E
ENDIF
	.db $40, $01, $7E, $7E
	.db $00

NoiseDrumData_DoubleSnare:
	.db $1F, $8D
	.db      $0B
IFNDEF PAL
	.db      $09
ENDIF

NoiseDrumData_Snare:
	.db $1F, $8D
	.db      $0B
	.db      $09
	.db $1C, $7E
	.db $19, $7E
	.db $16, $7E
	.db $13, $7E
	.db $12, $7E
	.db $11, $7E
	.db $00
