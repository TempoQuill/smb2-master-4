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

NoiseDrumData_StarSnare:
	.db $1F, $89
	.db      $06
	.db $1C, $7E
	.db $19, $7E
	.db $17, $7E
	.db $16, $7E
	.db $15, $7E
	.db $14, $7E
	.db $13, $7E
	.db $12, $7E
	.db $11, $7E
	.db $00

NoiseDrumData_Snare:
	.db $1F, $88
	.db      $0A
	.db $1C, $7E
	.db      $7E
	.db      $7E
	.db $19, $7E
	.db $17, $7E
	.db $16, $7E
	.db $15, $7E
	.db      $7E
	.db $14, $7E
	.db      $7E
	.db $13, $7E
	.db      $7E
	.db $12, $7E
	.db      $7E
	.db $11, $7E
	.db      $7E
	.db $00

NoiseDrumData_OWClosedHihat:
	.db $1A, $03
	.db $19, $02
	.db $19, $01
	.db $00

NoiseDrumData_OWOpenHihat:
	.db $1A, $01
	.db $15, $02
	.db $1A, $03
	.db $15, $02
	.db $13, $01
	.db $00

NoiseDrumData_OWKick:
IFNDEF PAL
	.db $1A, $8D
	.db      $8E
ELSE
	.db $1A, $8E
ENDIF
	.db $1A, $01
	.db $17, $7E
	.db $14, $7E
	.db $00

NoiseDrumData_DoubleSnare:
	.db $1B, $08
	.db $19, $09
IFNDEF PAL
	.db $16, $7E
ENDIF

NoiseDrumData_OWSnare:
	.db $1B, $08
	.db $19, $09
	.db $16, $7E
	.db $15, $7E
	.db $14, $7E
	.db $13, $7E
	.db $12, $7E
	.db $11, $7E
	.db $00
