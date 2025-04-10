;
; Looks for an unused sprite slot
;
; ##### Input
; - `X`: enemy slot
;
; ##### Output
; - `X`: z12
; - `Y`: sprite slot
;
FindSpriteSlot:
	LDX #$08

FindSpriteSlot_Loop:
	LDA zEnemyState, X
	BEQ FindSpriteSlot_CheckInactiveSlot

FindSpriteSlot_LoopNext:
	DEX
	BPL FindSpriteSlot_Loop

FindSpriteSlot_Default:
	; Check that both halves of the default sprite slot are unused
	LDY #$00
	LDA iVirtualOAM, Y
	CMP #$F8
	BNE FindSpriteSlot_FallbackExit

	LDA iVirtualOAM + 4, Y
	CMP #$F8
	BEQ FindSpriteSlot_Exit

FindSpriteSlot_FallbackExit:
	; If all else fails, here's $10
	LDY #$10

FindSpriteSlot_Exit:
	LDX z12
	RTS

; The object slot is inactive, so check that something else hasn't claimed the
; corresponding sprite slot.
FindSpriteSlot_CheckInactiveSlot:
	; Calculate the sprite slot using the flicker offset
	TXA
	CLC
	ADC iObjectFlickerer
	TAY
	LDA SpriteFlickerDMAOffset, Y

	; Check that both halves of the object's sprite slot are unused
	TAY
	LDA iVirtualOAM, Y
	CMP #$F8
	BNE FindSpriteSlot_LoopNext
	LDA iVirtualOAM + 4, Y
	CMP #$F8
	BNE FindSpriteSlot_LoopNext
	BEQ FindSpriteSlot_Exit
