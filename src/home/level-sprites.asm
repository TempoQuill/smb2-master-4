;
; ## Tile collision bounding boxes
;
; These hitboxes are used when determining the collision between objects and background tiles.
;
; Tile collision bounding box table offsets
;
TileCollisionHitboxIndex:
	.db $00 ; $00 - player standing
	.db $08 ; $01 - player holding item
	.db $10 ; $02 - player ducking
	.db $18 ; $03 - player ducking with item
	.db $20 ; $04 - 16x16 items (vegetables, etc.)
	.db $24 ; $05 - 16x16 enemies (shyguy, etc.)
; The following four entries are used to determine whether a carried item can be thrown.
	.db $28 ; $06 - player left, standing
	.db $2A ; $07 - player left, ducking
	.db $29 ; $08 - player right, standing
	.db $2B ; $09 - player right, ducking
	.db $2C ; $0A - player climb/cherry
	.db $2E ; $0B - player climbing
	.db $30 ; $0C - 16x32 enemies (birdo, mouser)
	.db $34 ; $0D - projectile
	.db $38 ; $0E - 16x48 enemies (tryclde)
	.db $3C ; $0F - spark
	.db $40 ; $10 - flying carpet

;
; ### Tile vertical collision bounding box (x-offsets)
;
; The left boundary offset is measured from the left side of the sprite.
; The right boundary offset is measured from the right of the first tile of the sprite.
;
; Each bounding box entry is four bytes:
;
;   1. left boundary (upward velocity)
;   2. right boundary (upward velocity)
;   3. left boundary (downward velocity)
;   4. right boundary (downward velocity)
;
VerticalTileCollisionHitboxX:
	.db $06, $09, $06, $09 ; $00
	.db $01, $01, $0E, $0E ; $04
	.db $06, $09, $06, $09 ; $08
	.db $01, $01, $0E, $0E ; $0C
	.db $06, $09, $06, $09 ; $10
	.db $01, $01, $0E, $0E ; $14
	.db $06, $09, $06, $09 ; $18
	.db $01, $01, $0E, $0E ; $1C
	.db $08, $08, $00, $0F ; $20
	.db $08, $08, $03, $0C ; $24
	.db $F8, $18, $F8, $18 ; $28
	.db $08, $08, $08, $08 ; $2C
	.db $08, $08, $03, $0C ; $30
	.db $03, $03, $02, $05 ; $34
	.db $08, $08, $03, $0C ; $38
	.db $08, $08, $FF, $10 ; $3C
	.db $10, $10, $02, $1E ; $40

;
; ### Tile vertical collision bounding box (y-offsets)
;
; The upper and lower boundary offset are measured from the top of the sprite.
;
; Each bounding box entry is four bytes:
;
;   1. upper boundary (upward velocity)
;   2. lower boundary (upward velocity)
;   3. upper boundary (downward velocity)
;   4. lower boundary (downward velocity)
;
; Not totally sure why there are two bytes, but it seems to have something to do with the direction
; of movement when checking the collision.
;
VerticalTileCollisionHitboxY:
	.db $07, $07, $20, $20 ; $00
	.db $0D, $1C, $0D, $1C ; $04
	.db $FF, $FF, $20, $20 ; $08
	.db $04, $1C, $04, $1C ; $0C
	.db $0F, $0F, $20, $20 ; $10
	.db $1C, $1C, $1C, $1C ; $14
	.db $07, $07, $20, $20 ; $18
	.db $0D, $1C, $0D, $1C ; $1C
	.db $00, $10, $09, $09 ; $20
	.db $03, $10, $09, $09 ; $24
	.db $FF, $FF, $0F, $0F ; $28
	.db $0C, $14, $07, $20 ; $2C
	.db $FE, $20, $10, $10 ; $30
	.db $09, $0A, $08, $08 ; $34
	.db $03, $30, $18, $18 ; $38
	.db $FF, $10, $08, $08 ; $3C
	.db $09, $0A, $08, $08 ; $40

;
; ## Object vertical collision bounding box
;
; These hitboxes are copied to RAM and used when determining collision between objects. This allows
; the hitboxes to change dynamically, which is used when Hawkmouth (offset $0B) opens and closes.
;
ObjectCollisionHitboxLeft:
	.db $02 ; $00
	.db $02 ; $01
	.db $03 ; $02
	.db $00 ; $03
	.db $03 ; $04
	.db $03 ; $05
	.db $F8 ; $06
	.db $00 ; $07
	.db $03 ; $08
	.db $01 ; $09
	.db $F3 ; $0A
	.db $04 ; $0B
	.db $03 ; $0C
	.db $03 ; $0D
	.db $03 ; $0E
	.db $F2 ; $0F
	.db $03 ; $10
	.db $03 ; $11
	.db $05 ; $12
	.db $03 ; $13

ObjectCollisionHitboxTop:
	.db $0B ; $00
	.db $10 ; $01
	.db $03 ; $02
	.db $00 ; $03
	.db $03 ; $04
	.db $03 ; $05
	.db $F8 ; $06
	.db $00 ; $07
	.db $09 ; $08
	.db $04 ; $09
	.db $03 ; $0A
	.db $03 ; $0B
	.db $0E ; $0C
	.db $03 ; $0D
	.db $03 ; $0E
	.db $03 ; $0F
	.db $F6 ; $10
	.db $0C ; $11
	.db $02 ; $12
	.db $03 ; $13

ObjectCollisionHitboxWidth:
	.db $0B ; $00
	.db $0B ; $01
	.db $09 ; $02
	.db $10 ; $03
	.db $09 ; $04
	.db $19 ; $05
	.db $20 ; $06
	.db $20 ; $07
	.db $03 ; $08
	.db $1E ; $09
	.db $19 ; $0A
	.db $08 ; $0B
	.db $09 ; $0C
	.db $09 ; $0D
	.db $09 ; $0E
	.db $18 ; $0F
	.db $09 ; $10
	.db $1A ; $11
	.db $06 ; $12
	.db $15 ; $13

ObjectCollisionHitboxHeight:
	.db $16 ; $00
	.db $11 ; $01
	.db $0D ; $02
	.db $10 ; $03
	.db $1A ; $04
	.db $19 ; $05
	.db $24 ; $06
	.db $10 ; $07
	.db $03 ; $08
	.db $04 ; $09
	.db $2D ; $0A
	.db $30 ; $0B
	.db $0F ; $0C
	.db $2E ; $0D
	.db $3E ; $0E
	.db $1E ; $0F
	.db $28 ; $10
	.db $13 ; $11
	.db $48 ; $12
	.db $26 ; $13


NextSpriteFlickerSlot:
	DEC iObjectFlickerer
	BPL NextSpriteFlickerSlot_Exit

	LDA #$08
	STA iObjectFlickerer

NextSpriteFlickerSlot_Exit:
	RTS
