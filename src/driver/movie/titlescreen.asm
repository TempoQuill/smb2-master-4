WaitForNMI_SoundTestMenu:
	LDA #(SoundTestPPUDataPointers - TitleScreenPPUDataPointers) / 2
	CLC
	ADC mLoadedDataBufferIndex
	STA zScreenUpdateIndex
	BNE WaitForNMI_TitleScreen

WaitForNMI_SaveFileMenu:
	LDX mLoadedDataBufferIndex
	INX
	INX
	STX zScreenUpdateIndex
	BNE WaitForNMI_TitleScreen

WaitForNMI_TitleScreen_TurnOnPPU:
	LDA #PPUMask_ShowLeft8Pixels_BG | PPUMask_ShowLeft8Pixels_SPR | PPUMask_ShowBackground | PPUMask_ShowSprites
	STA zPPUMask

WaitForNMI_TitleScreen:
	LDA zScreenUpdateIndex
	ASL A
	TAX
	LDA TitleScreenPPUDataPointers, X
	STA zPPUDataBufferPointer
	LDA TitleScreenPPUDataPointers + 1, X
	STA zPPUDataBufferPointer + 1

	LDA #$00
	STA zNMIOccurred
WaitForNMI_TitleScreenLoop:
	LDA zNMIOccurred
	BPL WaitForNMI_TitleScreenLoop
	RTS


.include "src/data/title/layout.asm"


; =============== S U B R O U T I N E =======================================

TitleScreen:
	LDY #$07 ; Does initialization of RAM.
	STY z01 ; This clears $200 to $7FF.
	LDY #$00
	STY z00
	TYA

InitMemoryLoop:
	STA (z00), Y ; I'm not sure if a different method of initializing memory
; would work better in this case.
	DEY
	BNE InitMemoryLoop

	DEC z01
	LDX z01
	CPX #$02
	BCS InitMemoryLoop ; Stop initialization after we hit $200.

	LDY #$5F
	STY z01
	LDY #$00
	STY z00
	TYA

InitMMC5MemoryLoop:
	STA (z00), Y
	DEY
	BNE InitMMC5MemoryLoop

	DEC z01
	LDX z01
	CPX #$5C
	BCS InitMMC5MemoryLoop ; Stop initialization after we hit $5c00.

loc_BANK0_9A53:
	LDA #$00
	TAY

InitMemoryLoop2:
	; Clear $0000-$00FF.
	; Notably, this leaves the stack area $0100-$01FF uninitialized.
	; This is not super important, but you might want to do it yourself to
	; track stack corruption or whatever.
	STA z00, Y
	INY
	BNE InitMemoryLoop2

	JSR LoadTitleScreenCHRBanks

	JSR ClearNametablesAndSprites

	LDA PPUSTATUS
	LDA #$3F
	LDY #$00
	STA PPUADDR
	STY PPUADDR

InitTitleBackgroundPalettesLoop:
	LDA TitleBackgroundPalettes, Y
	STA PPUDATA
	INY
	CPY #$20
	BCC InitTitleBackgroundPalettesLoop

	LDA #$01
	STA zPPUDataBufferPointer
	LDA #$03
	STA zPPUDataBufferPointer + 1
	LDA #Stack100_Menu
	STA iStack
	; PPUCtrl_Base2000
	; PPUCtrl_WriteHorizontal
	; PPUCtrl_Sprite0000
	; PPUCtrl_Background1000
	; PPUCtrl_SpriteSize8x8
	; PPUCtrl_NMIEnabled
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x8 | PPUCtrl_NMIEnabled
	STA zPPUControl
	STA PPUCTRL
	; zScreenUpdateIndex is already 0
	; wait to read from iPPUBuffer
	JSR WaitForNMI_TitleScreen

	LDA #$01 ; AKA BG Layout
	STA zScreenUpdateIndex
	JSR WaitForNMI_TitleScreen

	JSR PlaceTitleSprites

	LDA #MUSIC_TITLE_SCREEN
	STA iMusicQueue
	JSR WaitForNMI_TitleScreen_TurnOnPPU

	LDA #$03
	STA z10
	LDA #$25
	STA zTitleScreenTimer
	LDA #$20
	STA zTitleScreePPUClearAddress
	LDA #$C7
	STA zTitleScreePPUClearAddress + 1
	LDA #$52
	STA zTitleScreePPUClearSizeRLE

loc_BANK0_9AB4:
	JSR WaitForNMI_TitleScreen

	LDA zTitleScreePPUClearInc
	BNE loc_BANK0_9AF3

loc_BANK0_9ABB:
	INC z10
	LDA z10
	AND #$0F
	BEQ loc_BANK0_9AC6

	JMP HandleTitleScreenInputs

; ---------------------------------------------------------------------------

loc_BANK0_9AC6:
	DEC zTitleScreenTimer
	LDA zTitleScreenTimer
	CMP #$06
	BNE HandleTitleScreenInputs

	INC zTitleScreePPUClearInc
	LDA zTitleScreePPUClearAddress
	STA iPPUBuffer
	LDA zTitleScreePPUClearAddress + 1
	STA iPPUBuffer + 1
	LDA zTitleScreePPUClearSizeRLE
	STA iPPUBuffer + 2
	; adjust pointer
	LDA #$E6
	STA zTitleScreePPUClearAddress + 1
	; adjust rle
	LDA #$54
	STA zTitleScreePPUClearSizeRLE
	LDA #$FB ; empty tile
	STA iPPUBuffer + 3
	LDA #$00 ; terminator
	STA iPPUBuffer + 4
	BEQ HandleTitleScreenInputs

loc_BANK0_9AF3:
	LDA zTitleScreePPUClearAddress
	STA iPPUBuffer
	LDA zTitleScreePPUClearAddress + 1
	STA iPPUBuffer + 1
	LDA zTitleScreePPUClearSizeRLE
	STA iPPUBuffer + 2
	LDA #$FB ; empty tile
	STA iPPUBuffer + 3
	LDA #$00 ; terminator
	STA iPPUBuffer + 4
	LDA zTitleScreePPUClearAddress + 1
	CLC
	ADC #$20
	STA zTitleScreePPUClearAddress + 1
	LDA zTitleScreePPUClearAddress
	ADC #$00
	STA zTitleScreePPUClearAddress
	CMP #$23

loc_BANK0_9B1B:
	BCC HandleTitleScreenInputs

	LDA #$20
	STA z10
	LDX #$17 ; string length
	LDY #$00 ; string offset

loc_BANK0_9B25:
	LDA TitleAttributeData1, Y
	STA iPPUBuffer + 4, Y
	INY
	DEX
	BPL loc_BANK0_9B25

	LDA #$00 ; terminator
	STA iPPUBuffer + 4, Y
	JSR WaitForNMI_TitleScreen

	LDX #$1B ; string length
	LDY #$00 ; string offset

loc_BANK0_9B3B:
	LDA TitleAttributeData2, Y
	STA iPPUBuffer, Y
	INY
	DEX
	BPL loc_BANK0_9B3B

	LDA #$00
	STA iPPUBuffer, Y
	JMP loc_BANK0_9B59

; ---------------------------------------------------------------------------

; TODO: Find a way to check for sequential input.
HandleTitleScreenInputs:
; NOTE: Because sound test access looks for three particular holds, the target
; input state will have to be isolated first before measuring it up.  Otherwise
; the other buttons could interfere with accessing the sound test.
; Realistically though, this measure would be unnecessary for the base joypad.
	LDA zInputCurrentState
	AND #ControllerInput_Select | ControllerInput_B | ControllerInput_A
	CMP #ControllerInput_Select | ControllerInput_B | ControllerInput_A
	BEQ ToSoundTest
	LDA zInputBottleneck
	AND #ControllerInput_Start | ControllerInput_A
	BEQ loc_BANK0_9B56
	BNE LoadNewGame
ToSoundTest:
	JMP SoundTestMenu

LoadNewGame:
	JMP SaveFileMenu

; ---------------------------------------------------------------------------

loc_BANK0_9B56:
	JMP loc_BANK0_9AB4

; ---------------------------------------------------------------------------

loc_BANK0_9B59:
	JSR WaitForNMI_TitleScreen

	LDA zObjectXHi + 4
	BEQ loc_BANK0_9B63

	JMP HandleCrawlInputs

; ---------------------------------------------------------------------------

loc_BANK0_9B63:
	LDA zObjectXHi + 3
	CMP #$09
	BEQ loc_BANK0_9B93

	LDA zObjectXHi + 3
	BNE loc_BANK0_9BA3

	DEC z10
	BMI TitleScreen_WriteSTORYText

	JMP HandleCrawlInputs

; ---------------------------------------------------------------------------

TitleScreen_WriteSTORYText:
	LDA #$20 ; lookin' at $20ae (14*8, 5*8) as the base PPU address
	STA iPPUBuffer
	LDA #$AE
	STA iPPUBuffer + 1
	LDA #$05 ; Length of STORY text (5 bytes)
	STA iPPUBuffer + 2
	LDY #$04 ; Bytes to copy minus one (5-1=4)

TitleScreen_WriteSTORYTextLoop:
	LDA TitleStoryText_STORY, Y ; Copy STORY text to PPU write buffer
	STA iPPUBuffer + 3, Y
	DEY
	BPL TitleScreen_WriteSTORYTextLoop

	LDA #$00 ; Terminate STORY text in buffer
	STA iPPUBuffer + 8

loc_BANK0_9B93:
	INC zObjectXHi + 3
	LDA #$21
	STA zPlayerXHi
	LDA #$06
	STA zObjectXHi
	LDA #$40
	STA zObjectXHi + 5
	BNE HandleCrawlInputs

loc_BANK0_9BA3:
	DEC zObjectXHi + 5
	BPL HandleCrawlInputs

loc_BANK0_9BA7:
	LDA #$40
	STA zObjectXHi + 5
	LDA zPlayerXHi
	STA iPPUBuffer

loc_BANK0_9BB0:
	LDA zObjectXHi

loc_BANK0_9BB2:
	STA iPPUBuffer + 1
	LDA #$14
	STA iPPUBuffer + 2
	LDX zObjectXHi + 3
	DEX
	LDA TitleStoryTextPointersHi, X
	STA z04
	LDA TitleStoryTextPointersLo, X
	STA z03
	LDY #$00
	LDX #$13

loc_BANK0_9BCB:
	LDA (z03), Y
	STA iPPUBuffer + 3, Y
	INY
	DEX
	BPL loc_BANK0_9BCB

	LDA #$00
	STA iPPUBuffer + 3, Y
	INC zObjectXHi + 3
	LDA zObjectXHi
	CLC
	ADC #$40
	STA zObjectXHi
	LDA zPlayerXHi
	ADC #$00
	STA zPlayerXHi
	LDA zObjectXHi + 3
	CMP #$09
	BCC HandleCrawlInputs

	BNE loc_BANK0_9C0B

	LDA #$09
	STA zTitleScreenTimer
	LDA #$03
	STA z10
	LDA #$20
	STA zPlayerXHi
	LDA #$C7
	STA zObjectXHi
	LDA #$52
	STA zObjectXHi + 1
	LDA #$00
	STA zTitleScreePPUClearInc
	JMP loc_BANK0_9ABB

; ---------------------------------------------------------------------------

loc_BANK0_9C0B:
	CMP #$12
	BCC HandleCrawlInputs

	INC zObjectXHi + 4
	LDA #$25
	STA zTitleScreenTimer
	LDA #$03
	STA z10

; TODO: Find a way to check for sequential input.
HandleCrawlInputs:
; NOTE: Because sound test access looks for three particular holds, the target
; input state will have to be isolated first before measuring it up.  Otherwise
; the other buttons could interfere with accessing the sound test.
; Realistically though, this measure would be unnecessary for the base joypad.
	LDA zInputCurrentState
	AND #ControllerInput_Select | ControllerInput_B | ControllerInput_A
	CMP #ControllerInput_Select | ControllerInput_B | ControllerInput_A
	BEQ HandleCrawlInputs_ToSoundTest
	LDA zInputCurrentState
	AND #ControllerInput_Start | ControllerInput_A
	BEQ loc_BANK0_9C35
	BNE loc_BANK0_9C1C

HandleCrawlInputs_ToSoundTest:
	JMP SoundTestMenu

loc_BANK0_9C1C:
	JMP SaveFileMenu

loc_BANK0_9C1F:
	LDA #MUSIC_NONE
	STA iMusicQueue
	LDA #SAVE_MENU_FADE_1 + 2
	STA zScreenUpdateIndex
	JSR WaitForNMI_TitleScreen
	LDA #SAVE_MENU_FADE_2 + 2
	STA zScreenUpdateIndex
	JSR WaitForNMI_TitleScreen
	LDA #SAVE_MENU_FADE_3 + 2
	STA zScreenUpdateIndex
	JSR WaitForNMI_TitleScreen

	LDA #$00
	TAY

loc_BANK0_9C2A:
	STA z00, Y
	INY
	CPY #$F0
	BCC loc_BANK0_9C2A

	JSR HideAllSprites

	INC iMainGameState
	RTS

; ---------------------------------------------------------------------------

loc_BANK0_9C35:
	LDA zObjectXHi + 4
	BEQ loc_BANK0_9C4B

	INC z10
	LDA z10
	AND #$0F
	BNE loc_BANK0_9C4B

	DEC z02
	LDA z02
	CMP #$06
	BNE loc_BANK0_9C4B

	BEQ loc_BANK0_9C4E

loc_BANK0_9C4B:
	JMP loc_BANK0_9B59

; ---------------------------------------------------------------------------

loc_BANK0_9C4E:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x8 | PPUCtrl_NMIDisabled
	STA zPPUControl

loc_BANK0_9C52:
	STA PPUCTRL
	JMP loc_BANK0_9A53

; End of function TitleScreen