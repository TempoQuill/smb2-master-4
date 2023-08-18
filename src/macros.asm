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

MACRO musicPointerOffset label, offset
	.db (label - MusicPointerOffset + offset)
ENDM

MACRO musicPart label
	.db (label - MusicPartPointers)
ENDM

MACRO musicHeaderPointer label
	.db (label - MusicHeaders)
ENDM

;
; MusicHeader macro, to replace this:
;	.db NoteLengthTable_Death
;	.dw MusicDataXXX
;	.db MusicDataXXX_Triangle - MusicDataXXX
;	.db MusicDataXXX_Square1 - MusicDataXXX
;	.db MusicDataXXX_Noise - MusicDataXXX
;	; no noise channel, using $00 from below
;
; Setting "noise" or "dpcm" to -1 will suppress output of $00 for music headers
; "reuse" the note length from the following header to save bytes.
;
MACRO musicHeader noteLengthLabel, square2, triangle, square1, noise, dpcm
	.db noteLengthLabel
	.dw square2
	.db (triangle - square1)
	.db (square1 - square2)

	IF noise > 0
		.db (noise - triangle)
	ENDIF
	IF dpcm > 0
		.db (dpcm - noise)
	ENDIF
ENDM

; audio bank macros
MACRO: audio_bank label
	.db $80 + label
ENDM
