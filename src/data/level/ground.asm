;
; #### Ground appearance tile definitions
;
; These are the tiles used to render the ground setting of an area.
; Each row in a world's table corresponds to the ground type.
;
; You'll notice that the first entry, which correponds to the sky/background is
; $00 instead of $40. This is skipped with a BEQ in WriteGroundSetTiles,
; presumably as an optimization, so the value doesn't matter!
;
World1GroundTilesHorizontal:
	.db $00, $99, $D5, $00 ; $00
	.db $00, $99, $99, $99 ; $01
	.db $00, $A0, $A0, $A0 ; $02
	.db $00, $A2, $A2, $A2 ; $03
	.db $00, $D6, $9B, $18 ; $04
	.db $00, $A0, $A0, $99 ; $05
	.db $00, $00, $00, $00 ; $06
	.db $00, $00, $00, $00 ; $07

World1GroundTilesVertical:
	.db $00, $9D, $9E, $C6 ; $00
	.db $00, $05, $A0, $00 ; $01
	.db $00, $00, $00, $00 ; $02
	.db $00, $00, $A2, $00 ; $03
	.db $00, $00, $C2, $00 ; $04
	.db $00, $00, $A0, $00 ; $05
	.db $00, $93, $9E, $C6 ; $06
	.db $00, $40, $9E, $C6 ; $07

World2GroundTilesHorizontal:
	.db $00, $99, $99, $99 ; $00
	.db $00, $8A, $8A, $8A ; $01
	.db $00, $8B, $8B, $8B ; $02
	.db $00, $A0, $A0, $A0 ; $03
	.db $00, $A2, $A2, $A2 ; $04
	.db $00, $D6, $9B, $18 ; $05
	.db $00, $00, $00, $00 ; $06
	.db $00, $00, $00, $00 ; $07

World2GroundTilesVertical:
	.db $00, $9D, $9E, $C6 ; $00
	.db $00, $93, $A0, $00 ; $01
	.db $00, $40, $9B, $40 ; $02
	.db $00, $93, $9E, $C6 ; $03
	.db $00, $40, $9E, $C6 ; $04
	.db $00, $00, $00, $00 ; $05
	.db $00, $00, $00, $00 ; $06
	.db $00, $00, $00, $00 ; $07

World3GroundTilesHorizontal:
	.db $00, $99, $D5, $83 ; $00
	.db $00, $99, $99, $99 ; $01
	.db $00, $A0, $A0, $A0 ; $02
	.db $00, $A2, $A2, $A2 ; $03
	.db $00, $D6, $9B, $18 ; $04
	.db $00, $A0, $A0, $99 ; $05
	.db $00, $00, $00, $00 ; $06
	.db $00, $00, $00, $00 ; $07

World3GroundTilesVertical:
	.db $00, $C6, $9E, $9D ; $00
	.db $00, $05, $A0, $00 ; $01
	.db $00, $93, $9E, $C6 ; $02
	.db $00, $00, $A2, $00 ; $03
	.db $00, $00, $C2, $00 ; $04
	.db $00, $00, $A0, $00 ; $05
	.db $00, $40, $9E, $C6 ; $06
	.db $00, $06, $A0, $00 ; $07

World4GroundTilesHorizontal:
	.db $00, $99, $D5, $00 ; $00
	.db $00, $99, $16, $00 ; $01
	.db $00, $A0, $A0, $A0 ; $02
	.db $00, $A2, $A2, $A2 ; $03
	.db $00, $D6, $9B, $18 ; $04
	.db $00, $0A, $0A, $08 ; $05
	.db $00, $1F, $1F, $1F ; $06
	.db $00, $00, $00, $00 ; $07

World4GroundTilesVertical:
	.db $00, $C6, $99, $9D ; $00
	.db $00, $A2, $A2, $A2 ; $01
	.db $00, $9B, $9B, $9B ; $02
	.db $00, $A0, $A0, $A0 ; $03
	.db $00, $D6, $D6, $D6 ; $04
	.db $00, $18, $18, $18 ; $05
	.db $00, $00, $00, $00 ; $06
	.db $00, $00, $00, $00 ; $07

World5GroundTilesHorizontal:
	.db $00, $99, $D5, $40 ; $00
	.db $00, $99, $99, $99 ; $01
	.db $00, $A0, $A0, $A0 ; $02
	.db $00, $A2, $A2, $A2 ; $03
	.db $00, $D6, $9B, $18 ; $04
	.db $00, $A0, $A0, $99 ; $05
	.db $00, $00, $00, $00 ; $06
	.db $00, $00, $00, $00 ; $07

World5GroundTilesVertical:
	.db $00, $9D, $9E, $C6 ; $00
	.db $00, $05, $A0, $00 ; $01
	.db $00, $40, $A4, $00 ; $02
	.db $00, $00, $A2, $00 ; $03
	.db $00, $00, $C2, $00 ; $04
	.db $00, $00, $A0, $00 ; $05
	.db $00, $93, $9E, $C6 ; $06
	.db $00, $40, $9E, $C6 ; $07

World6GroundTilesHorizontal:
	.db $00, $99, $99, $99 ; $00
	.db $00, $8A, $8A, $8A ; $01
	.db $00, $8B, $8B, $8B ; $02
	.db $00, $A0, $A0, $A0 ; $03
	.db $00, $A2, $A2, $A2 ; $04
	.db $00, $D6, $9B, $18 ; $05
	.db $00, $00, $00, $00 ; $06
	.db $00, $00, $00, $00 ; $07

World6GroundTilesVertical:
	.db $00, $9D, $9E, $C6 ; $00
	.db $00, $93, $A0, $00 ; $01
	.db $00, $40, $18, $40 ; $02
	.db $00, $93, $9E, $C6 ; $03
	.db $00, $40, $9E, $C6 ; $04
	.db $00, $00, $00, $00 ; $05
	.db $00, $00, $00, $00 ; $06
	.db $00, $00, $00, $00 ; $07

World7GroundTilesHorizontal:
	.db $00, $9C, $9C, $9C ; $00
	.db $00, $D7, $9C, $19 ; $01
	.db $00, $00, $00, $00 ; $02
	.db $00, $00, $00, $00 ; $03
	.db $00, $00, $00, $00 ; $04
	.db $00, $00, $00, $00 ; $05
	.db $00, $00, $00, $00 ; $06
	.db $00, $00, $00, $00 ; $07

World7GroundTilesVertical:
	.db $00, $9C, $9C, $9C ; $00
	.db $00, $05, $A0, $00 ; $01
	.db $00, $00, $00, $00 ; $02
	.db $00, $00, $9C, $00 ; $03
	.db $00, $00, $C2, $00 ; $04
	.db $00, $00, $A0, $00 ; $05
	.db $00, $00, $00, $00 ; $06
	.db $00, $00, $00, $00 ; $07
