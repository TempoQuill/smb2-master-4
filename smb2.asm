; -----------------------------------------
; -----------------------------------------
;   Super Mario Bros. 2 (USA) disassembly
;     https://github.com/xkeeper0/smb2/
; -----------------------------------------
; -----------------------------------------

.include "config.asm"
.include "constants.asm"

.ignorenl
INES_MAPPER = MAPPER_MMC3
IFDEF MMC5
	INES_MAPPER = MAPPER_MMC5
ENDIF
	MIRROR_4SCREEN = %0000
.endinl

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

; -----------------------------------------
; Add macros
.include "src/macros.asm"

; -----------------------------------------
; Add definitions
.enum $0000
.include "src/defs.asm"
.ende

; Add RAM definitions
.enum $0000
.include "src/ram.asm"
.ende

; -----------------------------------------
; Add each of the 16 banks.
; In SMB2, banks are swapped in pairs.
; The game was clearly designed originally to use the MMC1 mapper,
; and very minimal changes were made to make that work.
; These banks are still TECHNICALLY two different banks,
; but due to this little hack a lot of data runs between
; bank boundaries, and it's easier to keep together
; You should split these again if you plan on making any
; really huge modifications...

; ----------------------------------------
; Banks 0 and 1. Basically potpourri.
; Lots of crap everywhere.
; Title screen and some other stuff too.
.base $8000
.include "src/prg-0-1.asm"
.pad $c000, $00

; ----------------------------------------
; Banks 2 and 3. Enemy/object code.
.base $8000
.include "src/prg-2-3.asm"
.pad $c000, $00

; ----------------------------------------
; Banks 4 and 5. Music engine and song data.
.base $8000
.include "src/prg-4-5.asm"
.pad $c000, $00

; ----------------------------------------
; Bank 6 and 7. Level handling ode, I think.
; Hmm, I wonder how this actually works when
; dealing with the fact the level data is
; in another bank...
; Bank 7 is empty
.base $8000
.include "src/prg-6-7.asm"
.pad $c000, $00

; ----------------------------------------
; Bank 8 and 9. Entirely level data.
; Some more unused space as usual.
.base $8000
.include "src/prg-8-9.asm"
.pad $c000, $00

; ----------------------------------------
; Banks A and B. Mostly bonus chance,
; character stats, and some PPU commands.
; Lots of empty space here too
.base $8000
.include "src/prg-a-b.asm"
.pad $c000, $00

; ----------------------------------------
; Banks C and D. The first half is
; a lot of data for the credits.
; The second half is empty.
.base $8000
.include "src/prg-c-d.asm"
.pad $c000, $00

; ----------------------------------------
; extra PRG-ROM pages (5 bank pairs)
.dsb (10 * $2000), $00

; SAWTOOTH DPCM AREA
.base $c000
.incbin "src/music/dpcmsaw-octave-2-3-area.bin"
.base $c000
.incbin "src/music/dpcmsaw-octave-4-area.bin"
.base $c000
.incbin "src/music/dpcmsaw-octave-5-area.bin"
; SFX DPCM AREA
.base $c000
.incbin "src/music/ldp-dpcm-area-7.bin"
.base $c000
.incbin "src/music/ldp-dpcm-area-b.bin"
.base $c000
.incbin "src/music/ldp-dpcm-area-d.bin"

; ----------------------------------------
; Banks 1E and 1F.
; Important things like NMI and often-used
; routines.
; Bank E also contains PCM data for some samples
.base $c000    ; Technically not needed but consistent
.include "src/prg-e-f.asm"


; -----------------------------------------
; include CHR-ROM
.incbin "smb2.chr"

; ----------------------------------------
; extra CHR-ROM pages
IFDEF EXPAND_CHR
.dsb (16 * $2000), $00
ENDIF
