;
; Bank A & Bank B
; ===============
;
; What's inside:
;
;   - Level title card background data and palettes
;   - Bonus chance background data and palettes
;   - Character select palettes
;   - Character data (physics, palettes, etc.)
;   - Character stats bootstrapping
;   - Character select fade
;   - "Warp to" layout
;   - 3 coins service handling
;

.include "src/data/title-cards.asm"
.include "src/data/bonus/layout.asm"
.include "src/driver/movie/bonus-titlecard-copy.asm"
.include "src/data/characters/stats.asm"
.include "src/data/characters/palettes.asm"
.include "src/driver/menus/chr-select-fade.asm"
.include "src/driver/copy-5.asm"
.include "src/data/misc.asm"
.include "src/driver/menus/chr-select.asm"
.include "src/driver/slots.asm"
.include "src/data/warp-layout.asm"
