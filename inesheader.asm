; -----------------------------------------
; Add NES header
	.db "NES", $1a ; identification of the iNES header

	.db 16 ; this can go up to 32

	.db 32

	.db ((INES_MAPPER & $f) << 4) | MIRROR_4SCREEN | BATTERY_RAM
	.db INES_MAPPER & $f0 | INES_2_0
	.dsb 2, $00
	.db $70 ; 8K of SRAM
IFNDEF PAL
	.db 0
	.db 0 ; NTSC
ELSE
	.db 0
	.db 1 ; PAL
ENDIF
	.db 0, 0, 0 ; unused
