;
; Bank 8 & Bank 9
; ===============
;
; What's inside:
;
;   - Level and enemy data pointer tables
;   - Level data
;   - Enemy data
;

.include "src/data/level/area.asm"


; Pointers to level data
include "src/levels/level-data-pointers.asm"


; Include level data;
; see src/levels/level-data.asm for level format details
include "src/levels/level-data.asm"

LevelData_Unused:


; Pointers to enemy data
include "src/levels/enemy-data-pointers.asm"


; Include enemy data;
; see src/levels/enemy-data.asm for enemy format details
include "src/levels/enemy-data.asm"

.include "src/driver/copy-4.asm"
