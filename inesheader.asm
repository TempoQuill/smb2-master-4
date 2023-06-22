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
IF INES_MAPPER == MAPPER_MMC5
	.dsb 3, $00
	.db $70 ; flags 10
	.dsb 5, $00 ; clear the remaining bytes
ELSE ; INES_MAPPER == MAPPER_MMC3
	.db INES_MAPPER & %11110000 ; mapper (upper nybble)
	.dsb 8, $00 ; clear the remaining bytes
ENDIF
