; -----------------------------------------
; Add NES header
	.db "NES", $1a ; identification of the iNES header

	.db 16 ; this can go up to 32

IFDEF EXPAND_CHR
	.db 32
ELSE
	.db 16 ; number of 8KB CHR-ROM pages
ENDIF

	.db ((INES_MAPPER & $f) << 4) | MIRROR_4SCREEN | BATTERY_RAM
	.db INES_MAPPER & $f0 | INES_2_0
	.dsb 2, $00
	.db $77 ; 8K of W/SRAM
	.dsb 5, $00 ; clear the remaining bytes
