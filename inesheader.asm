; -----------------------------------------
; Add NES header
	.db "NES", $1a ; identification of the iNES header

	.db 16 ; this can go up to 32

IFDEF EXPAND_CHR
	.db 32
ELSE
	.db 16 ; number of 8KB CHR-ROM pages
ENDIF

	.db ((INES_MAPPER & %00001111) << 4) | MIRROR_4SCREEN ; mapper (lower nybble) and mirroring
	.dsb 3, $00
	.db $70 ; flags 10
	.dsb 5, $00 ; clear the remaining bytes
