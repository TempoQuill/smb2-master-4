; @TODO: use flag
;
; This table determines the "solidness" of tiles.
;
; Solidness is broken into four tiers:
;   - background (no collisions)
;   - background to player/enemies, solid to mushroom blocks
;   - jumpthrough block (collision on top only)
;   - solid block (collision on all sides)
;
; Tiles are divided into groups of $40. For each category, the corresponding
; the groups are divided into two groups: tiles that have a collision rule and
; tiles that don't.
;
TileSolidnessTable:
	; solid to mushroom blocks unless < these values
	.db $01
	.db $43
	.db $80
	.db $C0
	; solid on top unless < these values
	.db $12
	.db $60
	.db $91
	.db $CA
	; solid on all sides unless < these values
	.db $18
	.db $69
	.db $98
	.db $D5
