.base 0
	.db "NESM", $1a, $01
	.db 42 ; total sounds
	.db 1  ; track offset
	.dw StartProcessingSoundQueue
	.dw PLAY
	.dw StartProcessingSoundQueue
	.db "SMB2: Disk System Accurate Sound"
	.db "Koji Kondo"
.pad $4e, $00
	.db "'87-'88 Nintendo, 2023 T. Quill"
.pad $6e, $00
	.dw $411a                                  ; NTSC
	.db $00, $01, $02, $03, $10, $11, $12, $13 ; Banks
	.dw 0                                      ; PAL
	.db 0                                      ; TV option: NTSC
	; Audio is enabled to allow multiplier to work
	.db %00001000                              ; MMC5 Audio
.pad $80, $00