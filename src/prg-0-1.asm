;
; Bank 0 & Bank 1
; ===============
;
; What's inside:
;
;   - Title screen
;   - Player controls
;   - Player state handling
;   - Enemy handling
;   - Subcon & Contributor cutscenes
;   - Save menu driver
;   - pause menu
;   - warp cutscene
;
.include "src/def/save-menu.asm"
.include "src/driver/overworld/scroll-0.asm"
.include "src/driver/overworld/player-0.asm"
.include "src/driver/overworld-0.asm"
.include "src/driver/movie/titlescreen.asm"
.include "src/driver/movie/ending-0.asm"
.include "src/driver/overworld/misc-0.asm"
.include "src/driver/menus/save.asm"
.include "src/driver/menus/pause.asm"
.include "src/driver/movie/warp.asm"
