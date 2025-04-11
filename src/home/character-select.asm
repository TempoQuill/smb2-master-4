;
; Runs the Character Select menu
;
DoCharacterSelectMenu:
	JSR WaitForNMI

	LDA #$00
	STA PPUMASK
	JSR DisableNMI

	JSR LoadCharacterSelectCHRBanks

	LDA #PRGBank_A_B
	JSR ChangeMappedPRGBank

	JSR CopyCharacterStatsAndStuff

	JSR ResetScreenForTitleCard

	LDA iCHR_A5
	CMP #$A5
	BEQ loc_BANKF_E2B2

	LDA #PRGBank_A_B
	JSR ChangeMappedPRGBank

	LDA #$A5
	STA iCHR_A5

loc_BANKF_E2B2:
	JMP LoadCHRSelect

; ---------------------------------------------------------------------------

loc_BANKF_E2E8:
	LDA zInputBottleneck
	AND #ControllerInput_Right | ControllerInput_Left
	BNE CharacterSelect_ChangeCharacter

	JMP CharacterSelectMenuLoop

; ---------------------------------------------------------------------------

CharacterSelect_ChangeCharacter:
	LDA zInputBottleneck
	AND #ControllerInput_Right
	BEQ loc_BANKF_E2FE

	DEC zCurrentCharacter
	LDA #SFX_COIN
	STA iPulse2SFX

loc_BANKF_E2FE:
	LDA zInputBottleneck
	AND #ControllerInput_Left
	BEQ loc_BANKF_E30B

	INC zCurrentCharacter
	LDA #SFX_COIN
	STA iPulse2SFX

loc_BANKF_E30B:
	LDA zCurrentCharacter
	AND #$03
	STA zCurrentCharacter
	BPL CopyArrowData

loc_BANKF_E311:
	JSR InitCharacterSelectFadeIn
CopyArrowData:
	LDY #CharacterSelectArrowData_End - CharacterSelectArrowData
CopyArrowData_Loop:
	LDA CharacterSelectArrowData, Y
	STA iPPUBuffer, Y
	DEY
	BPL CopyArrowData_Loop
	LDY zCurrentCharacter
	LDA PlayerSelectArrowTop, Y
	STA iPPUBuffer + 9
	LDA PlayerSelectArrowBottom, Y
	STA iPPUBuffer + 14
	JSR WaitForNMI

CharacterSelectMenuLoop:
	JSR DoCharacterSelectFadeIn
	JSR WaitForNMI_TurnOnPPU

	LDA zInputBottleneck
	AND #ControllerInput_A
	BNE loc_BANKF_E3AE

	JMP loc_BANKF_E2E8

CharacterSelectArrowData:
	.db $21, $C9, $4F, $FB
	.db $21, $E9, $4F, $FB
	.db $21, $00, $02, $BE, $C0
	.db $21, $00, $02, $BF, $C1
CharacterSelectArrowData_End:
	.db $00

CopyPaletteData:
	LDX #$22
	LDY #$00

CopyPaletteData_Loop:
	LDA iStartingPalettes, Y
	STA iPPUBuffer, Y
	INY
	DEX
	BPL CopyPaletteData_Loop
	LDX #$00

	LDA #$06
	STA z0a
	LDX zCurrentCharacter
	LDA PlayerSelectPaletteOffsets, X
	TAX

loc_BANKF_E391:
	LDA PlayerSelectSpritePalettes, X
	STA iPPUBuffer, Y
	INY
	INX
	DEC z0a
	BPL loc_BANKF_E391

	LDA #$00
	STA iPPUBuffer, Y
	RTS

; ---------------------------------------------------------------------------

loc_BANKF_E3AE:
	LDA #SFX_SELECT
	STA iHillSFX
	LDX iCurrentWorld
	LDY iCurrentLvl
	JSR DisplayLevelTitleCardText

	LDA #$40
	STA z10
	JSR WaitForNMI

	LDX #$F
	LDA zCurrentCharacter
	TAY
	LDA PlayerSelectSpriteIndexes, Y
	TAY

loc_BANKF_E3CC:
	LDA PlayerSelectMarioSprites2, Y
	STA iVirtualOAM + $10, Y
	INY
	DEX
	BPL loc_BANKF_E3CC

loc_BANKF_E3D6:
	JSR DoCharacterSelectFadeIn
	JSR WaitForNMI

	DEC z10
	BPL loc_BANKF_E3D6

	LDY #$3F

loc_BANKF_E3DF:
	LDA PlayerSelectMarioSprites1, Y
	STA iVirtualOAM + $10, Y
	DEY
	BPL loc_BANKF_E3DF

	LDA #$40
	STA z10

loc_BANKF_E3EC:
	JSR WaitForNMI

	DEC z10
	BPL loc_BANKF_E3EC

	LDA #MUSIC_NONE
	STA iMusicQueue
	RTS
