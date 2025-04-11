;
; Bank E & Bank F
; ===============
;
; What's inside: Lots of game logic.
;
;   - Joypad input reading
;   - PPU update routines
;   - Game initialization routines
;   - Title card display routines
;   - Area initialization routines
;   - Music cue routines
;   - Character select (sprite data, palettes, logic)
;   - Bonus chance (sprite data, palettes, logic)
;   - Game Over / Continue screen
;   - Pause screen
;   - Health logic
;   - Bottomless pit death logic
;   - Bounding box data for collisions
;   - Save logic
;   - and more!
;

.include "src/data/home/screen-update-pointers.asm"
.include "src/data/home/character-select-layout.asm"
.include "src/data/home/title-card.asm"
.include "src/data/home/character-select-sprites.asm"
.include "src/data/home/bonus-sprites.asm"
.include "src/data/home/palettes.asm"
.include "src/home/jumptable.asm"
.include "src/home/bw-scroll-reset.asm"
.include "src/home/title-card.asm"
.include "src/home/character-select.asm"
.include "src/home/main.asm"
.include "src/home/pause.asm"
.include "src/home/mini-area.asm"
.include "src/home/levels.asm"
.include "src/home/game-over.asm"
.include "src/home/level-change.asm"
.include "src/home/bonus-slots.asm"
.include "src/home/ending.asm"
.include "src/data/home/misc.asm"
.include "src/home/pause-screen.asm"
.include "src/home/bonus-slots-2.asm"
.include "src/home/vblank.asm"
.include "src/home/reset.asm"
.include "src/home/level-sprites.asm"
.include "src/home/processing.asm"
.include "src/data/home/level-sprites.asm"
.include "src/data/home/collision-bounds.asm"
.include "src/data/home/warp.asm"
.include "src/home/joy.asm"
.include "src/home/area.asm"
.include "src/home/kill.asm"
.include "src/data/home/level.asm"
.include "src/home/chr-anim.asm"
.include "src/home/enemies.asm"
.include "src/data/home/chr.asm"
.include "src/home/chr.asm"
.include "src/home/reset-2.asm"
.include "src/home/mapper.asm"
.include "src/home/save.asm"
.include "src/home/irq.asm"
.include "src/home/bonus-flash.asm"
;
; Vectors for the NES CPU. These must ALWAYS be at $FFFA!
;
; **NMI** is the code that runs each frame during the VBlank.
;
; **RESET** is code that runs after the console starts or resets.  Serves as
; the main game loop.
;
; **IRQ** is used for the sine effect for warping.  General uses:
;	-DMC streaming via %1------- at $4010 (doesn't need HBlank)
;	-On-screen tile expansion
;	-Non-CHR parallax
;	-Independent setpiece movement (status bar, logo entrance)
;
.pad $FFFA, $00

NESVectorTables:
	.dw NMI
	.dw RESET_MMC5
	.dw IRQ
