ResetScrollAndSetBonusChancePalettes:
	JSR SetScrollXYTo0

	LDA PPUSTATUS
	LDY #$00
	LDA #$3F
	STA PPUADDR
	STY PPUADDR

loc_BANKF_EA43:
	LDA iBonusChanceBGPal, Y
	STA PPUDATA
	INY
	CPY #$10
	BCC loc_BANKF_EA43

	LDY #$00
	LDA PPUSTATUS
	LDA #$3F
	STA PPUADDR
	LDA #$10
	STA PPUADDR

SetBonusChancePalette:
	LDA BonusChanceSpritePalettes, Y
	STA PPUDATA
	INY
	CPY #$10
	BCC SetBonusChancePalette

; End of function ResetScrollAndSetBonusChancePalettes

; =============== S U B R O U T I N E =======================================

sub_BANKF_EA68:
	LDY iExtraMen
	DEY
	TYA
	JSR GetTwoDigitNumberTiles
	STY i599
	STA i59a

	LDA iTotalCoins
	JSR GetTwoDigitNumberTiles
	STY i588 - 1
	STA i588

	LDA #ScreenUpdateBuffer_RAM_BonusChanceCoinsExtraLife
	STA zScreenUpdateIndex
	LDA #Stack100_Menu
	STA iStack
	JSR EnableNMI

	JMP WaitForNMI

; End of function sub_BANKF_EA68


;
; Converts a number to numerical tiles with space for 2 digits
;
; ##### Input
; - `A` = number to display
;
; ##### Output
; - `A`: second digit of the number (ones)
; - `Y`: first digit of the number (tens)
;
GetTwoDigitNumberTiles:
	LDY #$D0 ; zero

GetTwoDigitNumberTiles_TensLoop:
	; Count up the tens digit until A < 10
	CMP #$0A
	BCC GetTwoDigitNumberTiles_Ones

	SBC #$0A
	INY
	JMP GetTwoDigitNumberTiles_TensLoop

GetTwoDigitNumberTiles_Ones:
	ORA #$D0
	CPY #$D0
	BNE GetTwoDigitNumberTiles_Exit

	LDY #$FB

GetTwoDigitNumberTiles_Exit:
	RTS


WaitForNMI_TurnOffPPU:
	LDA #$00
	BEQ _WaitForNMI_StuffPPUMask ; Branch always

WaitForNMI_TurnOnPPU:
	LDA #PPUMask_ShowLeft8Pixels_BG | PPUMask_ShowLeft8Pixels_SPR | PPUMask_ShowBackground | PPUMask_ShowSprites

_WaitForNMI_StuffPPUMask:
	STA zPPUMask

WaitForNMI:
	LDA zScreenUpdateIndex
	ASL A
	TAX
	LDA ScreenUpdateBufferPointers, X
	STA zPPUDataBufferPointer
	LDA ScreenUpdateBufferPointers + 1, X
	STA zPPUDataBufferPointer + 1

	LDA #$00
	STA zNMIOccurred ; Start waiting for NMI to finish
WaitForNMILoop:
	LDA zNMIOccurred ; Has the NMI routine set the flag yet?
	BPL WaitForNMILoop ; If no, wait some more
	RTS ; If yes, go back to what we were doing


; =============== S U B R O U T I N E =======================================

CheckStopReel:
	LDA zInputBottleneck
	BPL locret_BANKF_EAD1

	LDX #$00

loc_BANKF_EAC8:
	LDA zObjectXLo, X
	BNE loc_BANKF_EAD2

	INX
	CPX #$03
	BCC loc_BANKF_EAC8

locret_BANKF_EAD1:
	; eject if noise is playing
	LDA iCurrentNoiseSFX
	ORA iBonusDrumRoll
	BNE CheckStopReel_Eject

	; eject if reels 1 or 2 are active
	LDA zObjectXLo
	ORA zObjectXLo + 1
	BNE CheckStopReel_Eject

	; eject if reels 1 and 2 don't match
	LDX zObjectXLo + 6
	LDA mReelBuffer, X
	LDX zObjectXLo + 7
	CMP mReelBuffer + 8, X
	BNE CheckStopReel_Eject

	; Play the drum roll!
	LDX #SoundEffect3_DrumRoll
	STX iNoiseDrumSFX
	INC iBonusDrumRoll

CheckStopReel_Eject:
	RTS

; ---------------------------------------------------------------------------

loc_BANKF_EAD2:
	LDA #$00
	STA zObjectXLo, X
	LDA #SoundEffect2_StopSlot
	STA iPulse2SFX
	CPX #$02
	BEQ TrancateDrumRoll
	RTS

TrancateDrumRoll:
	LDA zNoiseSFXOffset
	CMP #$dd
	BCS PreserveDrumRoll

	LDA #$dd
	STA zNoiseSFXOffset

PreserveDrumRoll:
	RTS

; End of function CheckStopReel

; =============== S U B R O U T I N E =======================================

TimedSlotIncrementation:
	LDX #$02

loc_BANKF_EADE:
	LDA zObjectXLo, X
	BEQ loc_BANKF_EAF2

	DEC zObjectXLo + 3, X
	BNE loc_BANKF_EAF2

	LDA #$07
	STA zObjectXLo + 3, X
	DEC zObjectXLo + 6, X
	BPL loc_BANKF_EAF2

	LDA #$07
	STA zObjectXLo + 6, X

loc_BANKF_EAF2:
	DEX
	BPL loc_BANKF_EADE
	RTS

; End of function TimedSlotIncrementation

; =============== S U B R O U T I N E =======================================

UpdateSlotSprites:
	LDA #$02
	STA z00

loc_BANKF_EAFA:
	LDA z00
	TAY
	ASL A
	ASL A
	ASL A
	TAX
	ADC zObjectXLo + 6, Y
	TAY
	LDA mReelBuffer, Y
	TAY
	LDA #$07
	STA z01

loc_BANKF_EB0D:
	LDA BonusChanceCherrySprite, Y
	STA iVirtualOAM + $10, X
	INX
	INY
	DEC z01
	BPL loc_BANKF_EB0D

	DEC z00
	BPL loc_BANKF_EAFA

	LDX #$17

loc_BANKF_EB1F:
	TXA
	AND #$18
	ASL A
	ASL A
	ADC iVirtualOAM + $10, X
	STA iVirtualOAM + $10, X
	DEX
	DEX
	DEX
	DEX
	BPL loc_BANKF_EB1F
	RTS
