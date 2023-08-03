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

IFNDEF NSF_FILE
	.include "inesheader.asm"
ELSE
	.include "nsf-header.asm"
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

IFNDEF NSF_FILE
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
ENDIF

; ----------------------------------------
; Banks 4 and 5. Music engine and song data.
.base $8000
.include "src/prg-4-5.asm"
.pad $c000, $00

IFNDEF NSF_FILE
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
ENDIF

.base $a000
.include "src/music/instruments-smas-1.asm"
.include "src/music/segments/jingles/crystal.asm"
.include "src/music/segments/jingles/boss-beaten.asm"
.include "src/music/segments/boss/boss.asm"
.include "src/music/segments/character-select/character-select-smas-1-3.asm"
.include "src/music/segments/character-select/character-select-smas-4-5.asm"
.include "src/music/segments/overworld/overworld-smas-1.asm"
.include "src/music/segments/overworld/overworld-smas-2.asm"
.include "src/music/segments/overworld/overworld-smas-3-4.asm"
.include "src/music/segments/overworld/overworld-smas-5.asm"
.include "src/music/segments/jingles/death.asm"
.pad $c000

.base $a000
.include "src/music/instruments-smas-2.asm"
.include "src/music/segments/jingles/mushroom-bonus-chance.asm"
.include "src/music/segments/ending/ending-smas-1-2.asm"
.include "src/music/segments/ending/ending-smas-3-4.asm"
.include "src/music/segments/ending/ending-smas-5.asm"
.include "src/music/segments/star/star-smas.asm"
.include "src/music/segments/underground/underground-smas.asm"
.pad $c000

.base $a000
.include "src/music/instruments-smas-3.asm"
.include "src/music/segments/title/title-smas.asm"
.include "src/music/segments/jingles/game-over.asm"
.include "src/music/segments/wart/wart-smas.asm"
.include "src/music/segments/subspace/subspace-smas.asm"
.pad $c000

IFNDEF NSF_FILE
	; ----------------------------------------
	; extra PRG-ROM pages (5 banks)
	.dsb (5 * $2000), $00
ENDIF

.base $c000
.incbin "src/music/smas-dmc-sfx.bin"
.base $c000
.incbin "src/music/smas-dmc-wart-death.bin"

; SAWTOOTH DPCM AREA
.base $c000
.incbin "src/music/dpcmsaw-octave-3-area.bin"
.base $c000
.incbin "src/music/dpcmsaw-octave-4-area.bin"
.base $c000
.incbin "src/music/dpcmsaw-octave-5-area.bin"
.base $c000
.incbin "src/music/dpcmsaw-octave-2-area.bin"
; SFX DPCM AREA
IFNDEF NSF_FILE
	; ----------------------------------------
	; extra PRG-ROM pages (5 banks)
	.dsb (3 * $2000), $00
ENDIF

; ----------------------------------------
; Banks 1E and 1F.
; Important things like NMI and often-used
; routines.
.base $e000    ; Technically not needed but consistent
IFNDEF NSF_FILE
	.include "src/prg-e-f.asm"


	; -----------------------------------------
	; include CHR-ROM
	.incbin "smb2.chr"

	; ----------------------------------------
	; extra CHR-ROM pages
	IFDEF EXPAND_CHR
		.dsb (16 * $2000), $00
	ENDIF
ELSE
	.include "src/nsf-home.asm"
ENDIF