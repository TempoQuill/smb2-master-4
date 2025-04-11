; -----------------------------------------
; -----------------------------------------
;   Super Mario Bros. 2 (USA) disassembly
;     https://github.com/xkeeper0/smb2/
; -----------------------------------------
; -----------------------------------------

.include "config.asm"
.include "constants.asm"

.ignorenl
INES_MAPPER = MAPPER_MMC5
MIRROR_4SCREEN = %0000
BATTERY_RAM = 2
INES_2_0 = 8

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
.include "src/defs.asm"

; Add RAM definitions
.include "src/ram.asm"

; -----------------------------------------
; Add each of the 32 banks.
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
	; Just shy of 3K of space left
	.base $8000
	.include "src/prg-0-1.asm"
	.pad $c000, $00

	; ----------------------------------------
	; Banks 2 and 3. Enemy/object code.
	; Nearly full, more than 15K of code/data
	.base $8000
	.include "src/prg-2-3.asm"
	.pad $c000, $00
ENDIF

; ----------------------------------------
; Banks 4 and 5. Music engine and song data.
; Can only take up 8K, and really just takes up roughly 5K
.base $8000
.include "src/prg-4-5.asm"
.pad $c000, $00

IFNDEF NSF_FILE
	; Proceeding banks are quite sparce.  These
	; likely had graphics data when the MMC1 was
	; still used.  With the move to fancier
	; hardware, there was no more need for CHR RAM
	; as the chunks of graphics became smaller and
	; more numerous, and R&D4 simply migrated the
	; graphics to CHR ROM without moving PRG data

	; If so inclined, the vanilla game could have
	; its free space counted to see if a smaller
	; ROM size is possible by condensing code.
	; ----------------------------------------
	; Bank 6 and 7. Level handling code, I think.
	; Hmm, I wonder how this actually works when
	; dealing with the fact the level data is
	; in another bank...
	; Bank 7 is empty - just shy of 10K available
	.base $8000
	.include "src/prg-6-7.asm"
	.pad $c000, $00

	; ----------------------------------------
	; Bank 8 and 9. Entirely level data.
	; Some more unused space as usual.
	; Roughly 4K is available
	.base $8000
	.include "src/prg-8-9.asm"
	.pad $c000, $00

	; ----------------------------------------
	; Banks A and B. Mostly bonus chance,
	; character stats, and some PPU commands.
	; Lots of empty space here too
	; An astounding 13K+ free
	.base $8000
	.include "src/prg-a-b.asm"
	.pad $c000, $00

	; ----------------------------------------
	; Banks C and D. The first half is
	; a lot of data for the credits.
	; The second half is empty.
	; Takes up less than 6K
	.base $8000
	.include "src/prg-c-d.asm"
	.pad $c000, $00
ENDIF

; Add the music banks
; Contains instruments and music in each, so each song has one of three flavors
; depending on which bank it's nestled in
; Space was clearly no issue, as no bank comes close to using 4K.  Instead, the
; banks stem from instrument variety.
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
.include "src/music/segments/jingles/spade-game-fanfare.asm"
.pad $c000

.base $a000
.include "src/music/instruments-smas-3.asm"
.include "src/music/segments/title/title-smas.asm"
.include "src/music/segments/jingles/game-over.asm"
.include "src/music/segments/wart/wart-smas.asm"
.include "src/music/segments/subspace/subspace-smas.asm"
.include "src/music/segments/jingles/warp.asm"
.pad $c000

IFNDEF NSF_FILE
	; ----------------------------------------
	; extra PRG-ROM pages (2 banks)
	.dsb (2 * $2000), $00
ENDIF

; Add the DPCM banks.  Sound effect area
.base $c000
.incbin "src/music/smas-1-3-area-13.bin"
.pad $e000, $55
.base $c000
.incbin "src/music/smas-1-3-area-14.bin"
.base $c000
.incbin "src/music/smas-1-3-area-15.bin"
.base $c000
.incbin "src/music/smas-1-3-area-16.bin"
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
	; extra PRG-ROM pages (3 banks)
	.dsb (3 * $2000), $00
ENDIF

; ----------------------------------------
; Banks 1E and 1F.
; Important things like NMI and often-used
; routines.
.base $e000
IFNDEF NSF_FILE
	.include "src/prg-e-f.asm"


	; -----------------------------------------
	; include CHR-ROM
	.incbin "smb2.chr"

	; ----------------------------------------
	; extra CHR-ROM pages, originally planned for CHR parallax
	; abandoned due to lack of coverage in some tiles + attribute conflicts
	.dsb (128 * $400), $00
ELSE
	.include "src/nsf-home.asm"
ENDIF