.base 0

MACRO nsf_bank_define const
	.db (const << 1)
	.db (const << 1) + 1
ENDM

	.db "NESM", $1a, $01
	.db NUM_MUSIC_TRACKS + NUM_DPCM_SFX + NUM_NOISE_SFX + (NUM_BITWISE_SFX * 2)
	.db 1  ; track offset
	.dw StartProcessingSoundQueue
	.dw PLAY
	.dw StartProcessingSoundQueue
	.db "SMB2: All-Stars Backport"
.pad $2e, $00
	.db "Koji Kondo"
.pad $4e, $00
	.db "'87-'88 Nintendo, 2023 T. Quill"
.pad $6e, $00
	.dw $411a                                  ; NTSC
	nsf_bank_define 0
	nsf_bank_define 1
	nsf_bank_define PRGBank_NSF_HOME - 1
	nsf_bank_define PRGBank_NSF_HOME
	.dw 0                                      ; PAL
	.db 0                                      ; TV option: NTSC
	; Audio is enabled to allow multiplier to work
	.db %00001000                              ; MMC5 Audio
.pad $80, $00