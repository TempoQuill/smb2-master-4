;
; ## Ground setting data
;
; The ground setting defines a single column (or row, for vertical areas) where each row (or column)
; can be one of four tiles. These tiles are repeated until an object changes  the ground setting or
; the renderer reaches the the end of the area.
;
; An area has its initial ground setting set in the header, but it can be changed mid-area using the
; `$F0` and `$F1` special objects.
;

;
; #### Horizontal ground set data
;
; Two bits per tile are used to select from one of the four ground appearance tiles. The tiles are
; defined from top-to-bottom, except for the last tile, which is actually the top row!
;
; Ground appearance tiles are defined xpecifically in the `WorldXGroundTilesHorizontal` lookup
; tables, but here's an example of how they apply:
;
; - `%00`: default background (ie. sky)
; - `%01`: secondary platform (eg. sand)
; - `%10`: primary platform (eg. grass)
; - `%11`: secondary background (eg. brown background in 3-2)
;
HorizontalGroundSetData:
	; The ruler here is an assumption based on the comments above,
	; so take it with a grain of salt or two
	;     1 2 3 4   5 6 7 8   9 A B C   D E F 0
	.db %00000000,%00000000,%00000000,%00100100 ; $00
	.db %00000000,%00000000,%00000010,%01010100 ; $01
	.db %00000000,%00000010,%01010101,%01010100 ; $02
	.db %00000000,%00000010,%01111111,%01010100 ; $03
	.db %00000000,%00000010,%01111111,%11010100 ; $04
	.db %00000000,%00000011,%11111111,%01010100 ; $05
	.db %00000000,%00000010,%01011111,%11111100 ; $06
	.db %00000000,%00000011,%11111111,%11111100 ; $07
	.db %00000000,%00000000,%00000000,%00000000 ; $08
	.db %01010101,%01010101,%01010101,%01111100 ; $09
	.db %11100111,%10011110,%01111001,%11100100 ; $0A
	.db %00000000,%00001110,%01111001,%11100100 ; $0B
	.db %00000000,%00000000,%00001001,%11100100 ; $0C
	.db %00000000,%00000000,%00000000,%00100100 ; $0D
	.db %11100000,%00001110,%01111001,%11100100 ; $0E
	.db %11100100,%00000000,%00001001,%11100100 ; $0F
	.db %11100100,%00000000,%00000000,%00100100 ; $10
	.db %11100111,%10010000,%00001001,%11100100 ; $11
	.db %11100111,%10011110,%01110000,%00100100 ; $12
	.db %11100111,%10011110,%01000000,%00100100 ; $13
	.db %11100111,%10011100,%00000000,%00100100 ; $14
	.db %11100000,%00001110,%01000000,%00100100 ; $15
	.db %00000000,%00000000,%00000000,%11100100 ; $16
	.db %11100100,%00000000,%00000000,%00000000 ; $17
	.db %11100111,%10011110,%01111001,%11100100 ; $18
	.db %11100111,%10010000,%00000001,%11100100 ; $19
	.db %11100000,%00000000,%00000001,%11100100 ; $1A
	.db %11100111,%10010000,%00000000,%00100100 ; $1B
	.db %11100000,%00000000,%00000000,%00100100 ; $1C
	.db %00000000,%00000000,%00000000,%00100100 ; $1D
	.db %00000000,%00000000,%00000000,%00100100 ; $1E

	; Based on the level header parsing code, $1F seems like it may have been reserved for some
	; special behavior at some point, but it doesn't appear to be implemented.

;
; #### Vertical ground set data
;
; Two bits per tile are used to select from one of the four ground appearance tiles. The tiles are
; defined from left-to-right.
;
; Ground appearance tiles are defined xpecifically in the `WorldXGroundTilesVertical` lookup
; tables, but here's an example of how they apply:
;
; - `%00`: default background (ie. sky)
; - `%01`: secondary platform (eg. bombable wall, sand)
; - `%10`: primary platform
; - `%11`: secondary background
;
VerticalGroundSetData:
	;     0 1 2 3   4 5 6 7   8 9 A B   C D E F
	.db %10101010,%10101010,%10101010,%10101010 ; $00
	.db %10000000,%00000000,%00000000,%00000010 ; $01
	.db %10101010,%00000000,%00000000,%10101010 ; $02
	.db %11111010,%00000000,%00000000,%10101111 ; $03
	.db %11111110,%00000000,%00000000,%10111111 ; $04
	.db %11111010,%10000000,%00000010,%10101111 ; $05
	.db %11101000,%00000000,%00000000,%00101011 ; $06
	.db %11100000,%00000000,%00000000,%00001011 ; $07
	.db %11111010,%10010101,%01010110,%10101111 ; $08
	.db %10010101,%00000000,%00000000,%01010110 ; $09
	.db %10100101,%01010101,%01010101,%01011010 ; $0A
	.db %10100101,%01011010,%10100101,%01011010 ; $0B
	.db %01010101,%01010101,%01010101,%01010101 ; $0C
	.db %10010101,%01010101,%01010101,%01010110 ; $0D
	.db %10010101,%01011010,%10100101,%01010110 ; $0E
	.db %10101001,%01010101,%01010101,%01101010 ; $0F
	.db %10000001,%01010101,%01010101,%01000010 ; $10
	.db %10101010,%10100101,%01010101,%01011010 ; $11
	.db %10100101,%01010101,%01011010,%10101010 ; $12
	.db %00000000,%00000000,%00000000,%00000000 ; $13
	.db %10000000,%00000000,%00000000,%00000010 ; $14
	.db %10100000,%00000000,%00000000,%00001010 ; $15
	.db %10101010,%00000000,%00000000,%10101010 ; $16
	.db %10101010,%10100000,%00001010,%10101010 ; $17
	.db %10000000,%00000000,%00001010,%10101010 ; $18
	.db %10000000,%00001010,%10101010,%10101010 ; $19
	.db %10101010,%10101010,%10100000,%00000010 ; $1A
	.db %10101010,%10100000,%00000000,%00000010 ; $1B
	.db %10100000,%00001010,%10100000,%00001010 ; $1C
	.db %10100000,%00000000,%00000000,%00000000 ; $1D
	.db %00000000,%00000000,%00000000,%00001010 ; $1E
	; Based on the level header parsing code, %00011111 seems like it may have been reserved for some
	; special behavior at some point, but it doesn't appear to be implemented.
