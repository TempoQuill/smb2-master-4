DoNewWarp:
	; Show warp screen
	LDY iCurrentWorld
	LDA WarpDestinations, Y
	STA iCurrentWorld
	STA sSavedWorld
	TAY
	LDX zCurrentCharacter
	LDA WorldStartingLevel, Y
	STA iCurrentLvl
	STA sSavedLvl
	STA iCurrentLevel_Init

	LDA #Stack100_Transition
	STA iStack
	JSR InitIRQData
DoNewWarp_Loop:
	JSR IRQWarpLogic
	JSR WaitForNMI_Warp_TurnOnIRQ
	LDA mIRQIntensity
	CMP #$a0
	BCC DoNewWarp_Loop

	LSR mIRQIntensity
	JSR WaitForNMI_Warp_TurnOffPPU

	JSR SetScrollXYTo0
	JSR ClearNametablesAndSprites
	JSR SetBlackAndWhitePalette

	JSR EnableNMI_Warp

	LDA #Stack100_Menu
	STA iStack
	LDA #WarpUpdateBuffer_RAM_Screen
	STA zScreenUpdateIndex
	LDA #0
	CLC
	ADC iCurrentWorld
	ADC iCurrentWorld
	ADC iCurrentWorld
	TAY
	LDA WarpNumberTable, Y
	STA mWarpNumberTileSequence
	INY
	LDA WarpNumberTable, Y
	STA mWarpNumberTileSequence + 1
	INY
	LDA WarpNumberTable, Y
	STA mWarpNumberTileSequence + 2
	JSR WorldWarpCHR
	JSR WaitForNMI_Warp
	LDA #WarpUpdateBuffer_FinalPalettes
	STA zScreenUpdateIndex
	JSR WaitForNMI_Warp
	LDA #$80
	STA MMC5_IRQStatus
	LDA #2
	STA MMC5_IRQScanlineCompare
	LDA #0
	STA mWarpPaletteIndex
	LDA #MUSIC_BONUS_DPCM
	STA iMusicQueue
	LDY #200
	JSR DelayFrames_Warp

	LDA #Stack100_Menu
	STA iStack
	RTS

WorldWarpCHR:
	LDY #CHRBank_Warp1
	STY iBGCHR1
	STY iObjCHR1
	INY
	STY iObjCHR2
	INY
	STY iBGCHR2
	STY iObjCHR3
	INY
	STY iObjCHR4
	RTS

DelayFrames_Warp:
	PHY
	PHX
	JSR IRQWarpLogic
	JSR WaitForNMI_Warp_TurnOnIRQ
	LDA #Stack100_Transition
	STA iStack
	PLX
	PLY
	DEY
	BNE DelayFrames_Warp
	RTS

WaitForNMI_Warp_TurnOnIRQ:
	INC mIRQOffset
	CLI
	LDA #$80
	STA MMC5_IRQStatus
	BNE WaitForNMI_Warp_TurnOnPPU
WaitForNMI_Warp_TurnOffPPU:
	LDA #0
	STA zPPUMask
	STA MMC5_IRQStatus
	STA MMC5_IRQScanlineCompare
	BEQ WaitForNMI_Warp
WaitForNMI_Warp_TurnOnPPU:
	LDA #PPUMask_ShowLeft8Pixels_BG | PPUMask_ShowLeft8Pixels_SPR | PPUMask_ShowBackground | PPUMask_ShowSprites
	STA zPPUMask
WaitForNMI_Warp:
	LDA zScreenUpdateIndex
	ASL A
	TAX
	LDA WarpBufferPointers, X
	STA zPPUDataBufferPointer
	LDA WarpBufferPointers + 1, X
	STA zPPUDataBufferPointer + 1

WaitForNMI_Preset:
	LDA #$00
	STA zNMIOccurred
WaitForNMI_WarpLoop:
	LDA zNMIOccurred
	BPL WaitForNMI_WarpLoop
	RTS

WarpBufferPointers:
	.dw iPPUBuffer
	.dw mWarpScreenLayout
	.dw WarpPaletteDataBlack
	.dw WarpPaletteFade3
	.dw WarpPaletteFade2
	.dw WarpPaletteFade1
	.dw WarpPalettes

WarpNumberTable:
	hex fcfcfc
	hex fcfcfc
	hex fcfcfc
	hex 736558 ; 4
	hex d2d1d0 ; 5
	hex d5d4d3 ; 6
	hex d8d7d6 ; 7

WarpPaletteData:
WarpPaletteDataBlack:
	.db $3f,$00,$50,$0f
	.db $00
WarpPaletteFade3:
	.db $3f,$00,$10
	.db $0f,$08,$07,$06
	.db $0f,$0a,$0a,$06
	.db $0f,$00,$05,$06
	.db $0f,$08,$07,$07
	.db $00
WarpPaletteFade2:
	.db $3f,$00,$10
	.db $0f,$18,$17,$06
	.db $0f,$1a,$0a,$06
	.db $0f,$10,$15,$06
	.db $0f,$18,$07,$07
	.db $00
WarpPaletteFade1:
	.db $3f,$00,$10
	.db $0f,$28,$17,$16
	.db $0f,$1a,$1a,$16
	.db $0f,$10,$15,$16
	.db $0f,$18,$17,$07
	.db $00
WarpPalettes:
	.db $3f,$00,$10
	.db $0f,$38,$27,$16
	.db $0f,$2a,$1a,$16
	.db $0f,$30,$25,$16
	.db $0f,$28,$17,$07
	.db $00

; initializes the wave effect RAM
InitIRQData:
	LDA #MUSIC_NONE
	STA iMusicQueue
	JSR WaitForNMI
	LDY #0
	STY mIRQOffset
	STY mIRQIndex
	STY mIRQIntensity
	STY mIRQFinalScroll
	INY
	STY mActiveUntilPPUTurnsOff
	LDA #PPUCtrl_Base2400 | PPUCtrl_WriteVertical | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	STA mIRQFinalScroll + 1
	LDA #$80
	STA MMC5_IRQStatus
	INY
	STY mNextScanline
	STY MMC5_IRQScanlineCompare
	LDY #MUSIC_WARP
	STY iMusicQueue
	RTS

IRQWarpLogic:
	LDA mIRQIntensity
	ORA mActiveUntilPPUTurnsOff
	BEQ IRQWarpLogic_Quit
	LDA mIRQOffset
	AND #$01
	BEQ IRQWarpLogic_IntensityCounter
IRQWarpLogic_Quit:
	RTS

IRQWarpLogic_IntensityCounter: ; on frame
	LDY mActiveUntilPPUTurnsOff ; did we turn off the PPU?
	BEQ IRQWarpLogic_WorldScreen
	; PPU hasn't been turned off yet
	JSR IRQWarpLogic_IncDecIntensity
	CMP #$a0 ; song length is actually $132 / 2 - ($99)
	STA mIRQIntensity
	BCS IRQWarpLogic_ClearCutsceneFlag ; branch if the after 6 1/3 seconds
	RTS

IRQWarpLogic_WorldScreen:
	LDA mIRQOffset
	AND #$02
	BEQ IRQWarpLogic_Quit
	; PPU has been turned off before arriving here
	JSR IRQWarpLogic_IncDecIntensity
	STA mIRQIntensity
	BCS IRQWarpLogic_Quit ; don't clear IRQ until carry is 0
	LDA #0
	STA MMC5_IRQStatus
	STA MMC5_IRQScanlineCompare
	RTS

IRQWarpLogic_ClearCutsceneFlag:
	LDA #0
	STA mActiveUntilPPUTurnsOff
	RTS

IRQWarpLogic_IncDecIntensity:
	CLC
	LDA mIRQIntensity
	ADC IRQIntensityAdds, Y
	RTS

IRQIntensityAdds:
	.db $fd, $01

EnableNMI_Warp:
	LDA #PPUCtrl_Base2400 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	STA zPPUControl
	STA PPUCTRL
	RTS
