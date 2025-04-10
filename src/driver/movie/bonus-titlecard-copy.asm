;
; Copies the Bonus Chance PPU data
;
; This copies in two pages
;
CopyBonusChanceLayoutToRAM:
	LDY #$00
CopyBonusChanceLayoutToRAM_Loop1:
	LDA BonusChanceLayout, Y ; Blindly copy $100 bytes from $8140 to $7400
	STA wBonusLayoutBuffer, Y
	DEY
	BNE CopyBonusChanceLayoutToRAM_Loop1

	; seems $100 wasn't enough memory though, huh?
	; Y's immediate number was hacked to take on the low byte of the data range
	LDY #<(CopyBonusChanceLayoutToRAM - BonusChanceLayout) ; amount of data to copy
CopyBonusChanceLayoutToRAM_Loop2:
	; Y at 0 causes a branch, blindly adding a page to address skips $7500
	LDA BonusChanceLayout + $ff, Y
	STA wBonusLayoutBuffer + $ff, Y
	DEY
	BNE CopyBonusChanceLayoutToRAM_Loop2
	RTS

; =============== S U B R O U T I N E =======================================

DrawTitleCardWorldImage:
	LDA iCurrentWorld
	CMP #6
	BEQ loc_BANKA_8392 ; Special case for World 7's title card

	LDA #$25
	STA z00
	LDA #$C8
	STA z01
	LDY #$00

loc_BANKA_8338:
	LDX #$0F
	LDA PPUSTATUS
	LDA z00
	STA PPUADDR

loc_BANKA_8342:
	LDA z01
	STA PPUADDR

loc_BANKA_8347:
	LDA World1thru6TitleCard, Y
	STA PPUDATA
	INY
	DEX
	BPL loc_BANKA_8347

	CPY #$A0
	BCS loc_BANKA_8364

	LDA z01
	ADC #$20
	STA z01
	LDA z00
	ADC #0
	STA z00
	JMP loc_BANKA_8338

; ---------------------------------------------------------------------------

loc_BANKA_8364:
	LDA iCurrentWorld
	CMP #1
	BEQ loc_BANKA_8371

	CMP #5
	BEQ loc_BANKA_8371

	BNE loc_BANKA_8389

loc_BANKA_8371:
	AND #$80
	BNE loc_BANKA_8389

	LDA #$26
	STA z00
	LDA #$88
	STA z01
	LDA iCurrentWorld
	ORA #$80
	STA iCurrentWorld
	STA sSavedWorld
	LDY #$80
	BNE loc_BANKA_8338

loc_BANKA_8389:
	LDA iCurrentWorld
	AND #$F
	STA iCurrentWorld
	STA sSavedWorld
	RTS

; ---------------------------------------------------------------------------

loc_BANKA_8392:
	LDA #$25
	STA z00
	LDA #$C8
	STA z01
	LDY #0

loc_BANKA_839C:
	LDX #$F
	LDA PPUSTATUS
	LDA z00
	STA PPUADDR
	LDA z01
	STA PPUADDR

loc_BANKA_83AB:
	LDA World7TitleCard, Y
	STA PPUDATA
	INY
	DEX
	BPL loc_BANKA_83AB

	CPY #$A0
	BCS locret_BANKA_83C8

	LDA z01
	ADC #$20
	STA z01
	LDA z00
	ADC #0
	STA z00
	JMP loc_BANKA_839C

; ---------------------------------------------------------------------------

locret_BANKA_83C8:
	RTS

; End of function DrawTitleCardWorldImage
