SoundTestMenu:
	JSR InitSoundTest

RunSoundTestMenu:
; start a fresh frame
	JSR WaitForNMI_SoundTestMenu
	; comb through inputs
	; up/down - queue sift
	LDA zInputBottleneck
	AND #DPad_Up | DPad_Down
	BEQ @LR
	; do nothing if both are pressed (somehow)
	CMP #DPad_Up | DPad_Down
	BEQ @LR
	LDX mSoundTestOffset
	AND #DPad_Up
	BEQ @Down
	TXA
	DEX
	BEQ @LR
	STX mSoundTestOffset
	BNE @LR
@Down:
	CPX #SOUND_TEST_OFFSET_MAX
	BCS @LR
	INX
	STX mSoundTestOffset
@LR:
	; left/right - sound ID sift
	LDA zInputBottleneck
	AND #DPad_Left | DPad_Right
	BEQ @AStart
	; do nothing if both are pressed (somehow)
	CMP #DPad_Left | DPad_Right
	BEQ @AStart
	LDX mSoundTestOffset
	AND #DPad_Left
	BEQ @Right
	LDA mSoundTestIndex, X
	SEC
	SBC #1
	BCC @AStart
	STA mSoundTestIndex, X
	BCS @AStart
@Right:
	LDA mSoundTestIndex, X
	CMP SoundTestMaxes, X
	BCS @AStart
	INC mSoundTestIndex, X
@AStart:
	; A/Start - play
	LDA zInputBottleneck
	AND #ControllerInput_A | ControllerInput_Start
	BEQ @B
	LDX mSoundTestOffset
	LDA mSoundTestIndex, X
	PHA
	LDA SoundTestQueueOffsets, X
	TAX
	PLA
	STA iMusicQueue, X
@B:
	; B - exit
	LDA zInputBottleneck
	AND #ControllerInput_B
	BNE @Exit
	LDA mSoundTestIndex + SOUND_TEST_DATA_MUSIC
	JSR GetTwoDigitNumberTiles
	STY mLoadedMusicBCD
	STA mLoadedMusicBCD + 1
	LDA mSoundTestIndex + SOUND_TEST_DATA_PULSE
	JSR GetTwoDigitNumberTiles
	STY mLoadedPulseBCD
	STA mLoadedPulseBCD + 1
	LDA mSoundTestIndex + SOUND_TEST_DATA_HILL
	JSR GetTwoDigitNumberTiles
	STY mLoadedHillBCD
	STA mLoadedHillBCD + 1
	LDA mSoundTestIndex + SOUND_TEST_DATA_STATIC
	JSR GetTwoDigitNumberTiles
	STY mLoadedStaticBCD
	STA mLoadedStaticBCD + 1
	LDA mSoundTestIndex + SOUND_TEST_DATA_SNIPPETS
	JSR GetTwoDigitNumberTiles
	STY mLoadedSnippetBCD
	STA mLoadedSnippetBCD + 1
	LDY #$90
	LDA mSoundTestOffset
	ASL A
	ASL A
	ASL A
	ASL A
	CLC
	ADC #$37
	STA iVirtualOAM, Y
	INY
	LDA #$BA
	STA iVirtualOAM, Y
	INY
	LDA #$01
	STA iVirtualOAM, Y
	INY
	LDA #$B0
	STA iVirtualOAM, Y
	JMP RunSoundTestMenu

@Exit:
	LDA #SFX_COIN
	STA iPulse2SFX
	LDA #MUSIC_NONE
	STA iMusicQueue
@ExitLoop:
	JSR WaitForNMI_SoundTestMenu
	LDA iCurrentPulse2SFX
	BNE @ExitLoop
	JSR ClearNametablesAndSprites
	TYA
	TAX
@Stack:
	STA iStack, X
	DEX
	BNE @Stack
	JMP RESET

InitSoundTest:
	LDY #SFX_SPIN_JUMP
	STY iHillSFX
	LDY #SAVE_MENU_INIT_INDEX_MAX - 1
	STY mSaveFileInitIndex
@Loop1:
; send RAM bait to clear title screen, one entry at a time
; this loop runs once a frame
	LDY mSaveFileInitIndex
	LDX #0
	LDA SaveFileInit_Hi, Y
	STA iPPUBuffer, X
	INX
	LDA SaveFileInit_Lo, Y
	STA iPPUBuffer, X
	INX
	LDA SaveFileInit_Packet, Y
	STA iPPUBuffer, X
	INX
	LDA #$FB
	STA iPPUBuffer, X
	INX
	LDA #$00
	STA iPPUBuffer, X
	STA zScreenUpdateIndex
	JSR WaitForNMI_TitleScreen
	DEC mSaveFileInitIndex
	BPL @Loop1
	LDA #SOUND_TEST_BFR_ATTRIBUTES
	STA mLoadedDataBufferIndex
@Loop2:
; runs once a frame
	JSR WaitForNMI_SoundTestMenu
	DEC mLoadedDataBufferIndex
	BNE @Loop2
	; send the second bit of RAM bait
	LDY #SoundTestRAMBufferEnd - SoundTestRAMBuffer
@Loop3:
	LDA SoundTestRAMBuffer, Y
	STA mSoundTestDataBuffer, Y
	DEY
	BPL @Loop3
	LDA #SOUND_TEST_DATA_MUSIC
	STA mSoundTestOffset
	LDA #0
	STA mLoadedDataBufferIndex
	RTS

.include "src/data/menus/sound-test.asm"
