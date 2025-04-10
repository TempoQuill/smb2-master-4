;
; Bank 6 & Bank 7
; ===============
;
; What's inside:
;
;   - Level palettes
;   - Groundset data
;   - Object tiles
;   - Level handling code
;
; -----
;

.include "src/data/level/palette-pointers.asm"
.include "src/data/level/palettes.asm"
.include "src/data/level/ground-pointers.asm"
.include "src/data/level/ground.asm"
.include "src/data/level/unused-quads.asm"
.include "src/driver/overworld/object-3.asm"
.include "src/data/level/ground-setting.asm"
.include "src/data/level/decoded-pages.asm"
.include "src/data/level/sub-translation.asm"
.include "src/driver/level-3.asm"
