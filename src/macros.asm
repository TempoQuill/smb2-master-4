;
; Macros
; ======
;
;

; Include COMPATIBILITY-flag-related macros
include "src/compatibility-shims.asm"

; distTo
; Outputs distance (byte) to label
; e.g.:
; .db (+ - $)  is  distTo +
;
MACRO distTo label
	.db (label - $)
ENDM

MACRO enemy x, y, type
	.db type, x << 4 | y
ENDM

;
; LevelHeader macro
;
; The order of the parameters is slightly different than how it's encoded, but
; hopefully this order is a little more intuitive?
;
MACRO levelHeader pages, horizontal, bgPalette, spritePalette, music, objectTypeAXFX, objectType3X9X, groundSetting, groundType
	.db horizontal << 7 | bgPalette << 3 | spritePalette
	.db %11100000 | groundSetting
	.db pages << 4 | objectTypeAXFX << 2 | objectType3X9X
	.db groundType << 3 | music
ENDM

.include "src/music/macros.asm"

MACRO PHX
	TXA
	PHA
ENDM

MACRO PHY
	TYA
	PHA
ENDM

MACRO PLX
	PLA
	TAX
ENDM

MACRO PLY
	PLA
	TAY
ENDM
