InitCharacterSelectFadeIn:
	LDA #$D0
	STA iCHRSelectPaletteFade
	RTS

DoCharacterSelectFadeIn:
	JSR CopyPaletteData
	LDA iCHRSelectPaletteFade
	BPL DoCharacterSelectFadeIn_End

	LDX #CharacterSelect_PaletteOffsetsEnd - CharacterSelect_PaletteOffsets - 1

DoCharacterSelectFadeIn_Loop:
	LDY CharacterSelect_PaletteOffsets, X
	JSR DoCharacterSelectFadeIn_Parse
	DEX
	BPL DoCharacterSelectFadeIn_Loop

	LDA iCHRSelectPaletteFade
	CLC
	ADC #$10
	STA iCHRSelectPaletteFade
	RTS

DoCharacterSelectFadeIn_End:
	LDA #0
	STA iCHRSelectPaletteFade
	RTS

DoCharacterSelectFadeIn_Parse:
	LDA iPPUBuffer, Y
	CMP #$0F ; black
	BNE DoCharacterSelectFadeIn_Color
DoCharacterSelectFadeIn_Done:
	STA iPPUBuffer, Y
	RTS

DoCharacterSelectFadeIn_Color:
	CLC
	ADC iCHRSelectPaletteFade
	BCC DoCharacterSelectFadeIn_TryCarry
	CMP #$20 ; white duplicate
	BNE DoCharacterSelectFadeIn_Done
	RTS
DoCharacterSelectFadeIn_TryCarry:
	ADC #$10
	BCC DoCharacterSelectFadeIn_TryCarry
	BCS DoCharacterSelectFadeIn_Done

CharacterSelect_PaletteOffsets:
	; 0-2 pal pointer+count
	; 3/7/B/F/13/17/1B/1F - main color
	; 23-25 player palette+count
	; 26 - main color
	.db $04, $05, $06
	.db $08, $09, $0A
	.db $0C, $0D, $0E
	.db $10, $11, $12
	.db $14, $15, $16
	.db $18, $19, $1A
	.db $1C, $1D, $1E
	.db $20, $21, $22
	.db $27, $28, $29
CharacterSelect_PaletteOffsetsEnd:
