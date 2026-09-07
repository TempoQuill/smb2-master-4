
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
;	.db TickLength_XXX
;	.dw MusicDataXXX
;	.db MusicDataXXX_Triangle - MusicDataXXX_Square1
;	.db MusicDataXXX_Square1 - MusicDataXXX
;	.db MusicDataXXX_Noise - MusicDataXXX_Triangle
;	.db MusicDataXXX_DPCM - MusicDataXXX_Noise
;	; no noise channel, using $00 from below
;
; Setting "noise" or "dpcm" to -1 will suppress output of $00 for music headers
; "reuse" the note length from the following header to save bytes.
;
MACRO musicHeader noteTickLength, square2, triangle, square1, noise, dpcm
	.db noteTickLength
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
MACRO audio_bank label
IFNDEF NSF_FILE
	.db $80 + label
ELSE
	.db label
ENDIF
ENDM

MACRO note_type ins, length
i = (ins - 1) << 4
	.db $80 + i + length
ENDM

MACRO note pitch, oct
o = (oct - 1) * $18
	.db pitch + o
ENDM

MACRO rest
	.db $7E
ENDM

MACRO sound_ret
	.db $00
ENDM

MACRO toggle_sweep
	.db $00
ENDM

MACRO sound_loop
	.db $00
ENDM

MACRO drum_note id
	.db id * 2
ENDM

MACRO drum_rest
	.db $01
ENDM
