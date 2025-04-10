;
; NMI logic for during a transition
;
NMI_Transition:
	LDA #$00
	STA OAMADDR
	LDA #$02
	STA OAM_DMA
	JSR ChangeCHRBanks

	LDA zPPUMask
	STA PPUMASK
	JSR DoSoundProcessing
	JSR EngageSave

	LDA zPPUControl
	STA PPUCTRL
	DEC zNMIOccurred
	JMP NMI_Exit


;
; NMI logic for during the pause menu
;
NMI_PauseSaveOrMenu:
	LDA #$00
	STA PPUMASK
	STA OAMADDR
	LDA #$02
	STA OAM_DMA
	JSR ChangeCHRBanks

	JSR UpdatePPUFromBufferWithOptions

	JSR ResetPPUAddress

	LDA zPPUScrollX
	STA PPUSCROLL
	LDA #$00
	STA PPUSCROLL
	LDA zPPUMask
	STA PPUMASK
	JMP NMI_CheckScreenUpdateIndex


;
; When waiting for an NMI, just run the audio engine
;
NMI_Waiting:
	LDA zPPUMask
	STA PPUMASK
	JMP NMI_DoSoundProcessing


;
; Public NMI: where dreams come true!
;
; The NMI runs every frame during vertical blanking and is responsible for
; tasks that should occur on each frame of gameplay, such as drawing tiles and
; sprites, scrolling, and reading input.
;
; It also runs the audio engine, allowing music to play continuously no matter
; how busy the rest of the game happens to be.
;
; The NMI is actually separated into several distinct behaviors depending on the
; game state, as dictated by flags in stack `$100`.
;
; For normal gameplay, here is the general flow of the NMI:
;
;  1. Push registers and processor flags so that we can restore them later.
;  2. Check to see whether we're in a menu or transitioning. If so, use those
;     divert to that code instead.
;  3. Hide the sprites/background and update the sprite OAM.
;  4. Load the current CHR banks.
;  5. Check the `zNMIOccurred`. If it's nonzero, restore `PPUMASK` and skip to
;     handling the sound processing.
;  6. Handle any horizontal or vertical scrolling tile updates.
;  7. Update PPU using the current screen update buffer.
;  8. Write PPU control register, scroll position, and mask.
;  9. Increment the global frame counter.
; 10. Reset PPU buffer 301 if we just used it for the screen update.
; 11. Read joypad input.
; 12. Decrement `zNMIOccurred`, unblocking any code that was waiting for the NMI.
; 13. Run the audio engine.
; 14. Restore registers and processor flags, yield back to the game loop.
;
; The game loop is synchronized with rendering using `JSR WaitForNMI`, which
; sets `zNMIOccurred` to `$00` until the NMI completes and decrements it.
;
; Although the NMI itself doesn't lag (ie. the NMI itself is not interrupted
; by another NMI), there are some parts of the game that can feel sluggish.
; This is due to sluggishness in the game loop itself.
;
NMI:
	PHP
	PHA
	TXA
	PHA
	TYA
	PHA

	BIT iStack
	BPL NMI_PauseSaveOrMenu ; branch if bit 7 was 0

	BVC NMI_Transition ; branch if bit 6 was 0

	LDA #$00
	STA PPUMASK
	STA OAMADDR
	LDA #$02
	STA OAM_DMA

	JSR ChangeCHRBanks

NMI_CheckWaitFlag:
	LDA zNMIOccurred
	BNE NMI_Waiting

NMI_Gameplay:
	; `UpdatePPUFromBufferNMI` draws in a row-oriented fashion, which makes it
	; unsuitable for horizontal levels where scrolling the screen means drawing
	; columns of new tiles. As a result, we need special logic to draw the
	; background in horizontal levels!
	LDA zScrollCondition
	BEQ NMI_AfterBackgroundAttributesUpdate

	LDA iScrollUpdateQueue
	BEQ NMI_AfterBackgroundTilesUpdate

	; Update nametable tiles in horizontal level
	LDA #$00
	STA iScrollUpdateQueue
	LDX #$1E
	LDY #$00
	LDA PPUSTATUS
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteVertical | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	STA PPUCTRL

NMI_DrawBackgroundTilesOuterLoop:
	LDA zBigPPUDrawer
	STA PPUADDR
	LDA zBigPPUDrawer + 1
	STA PPUADDR

NMI_DrawBackgroundTilesInnerLoop:
	LDA iScrollTileBuffer, Y
	STA PPUDATA
	INY
	DEX
	BNE NMI_DrawBackgroundTilesInnerLoop

	LDX #$1E
	INC zBigPPUDrawer + 1

	CPY #$3C
	BNE NMI_DrawBackgroundTilesOuterLoop

NMI_AfterBackgroundTilesUpdate:
	LDA iBigDrawerAttrPointer
	BEQ NMI_AfterBackgroundAttributesUpdate

	; Update nametable attributes in horizontal level
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteVertical | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	STA PPUCTRL
	LDY #$00
	LDX #$04

NMI_DrawBackgroundAttributesOuterLoop:
	LDA PPUSTATUS
	LDA iBigDrawerAttrPointer
	STA PPUADDR
	LDA iBigDrawerAttrPointer + 1
	STA PPUADDR

NMI_DrawBackgroundAttributesInnerLoop:
	LDA iHorScrollBuffer, Y
	STA PPUDATA
	INY
	TYA
	LSR A
	BCS NMI_DrawBackgroundAttributesInnerLoop

	LDA iBigDrawerAttrPointer + 1
	CLC
	ADC #$08
	STA iBigDrawerAttrPointer + 1
	DEX
	BNE NMI_DrawBackgroundAttributesOuterLoop

	STX iBigDrawerAttrPointer

NMI_AfterBackgroundAttributesUpdate:
	JSR UpdatePPUFromBufferNMI

	JSR ResetPPUAddress

	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	ORA zXScrollPage
	LDY zScrollCondition
	BNE NMI_UpdatePPUScroll

	AND #$FE
	ORA zYScrollPage

NMI_UpdatePPUScroll:
	STA PPUCTRL
	STA zPPUControl
	LDA zPPUScrollX
	STA PPUSCROLL
	LDA zPPUScrollY
	CLC
	ADC iBGYOffset
	STA PPUSCROLL
	LDA zPPUMask
	STA PPUMASK

NMI_IncrementGlobalCounter:
	INC z10

NMI_CheckScreenUpdateIndex:
	LDA zScreenUpdateIndex
	BNE NMI_ResetScreenUpdateIndex

	; Turn off PPU buffer 301 update
	STA i300
	STA iPPUBuffer

NMI_ResetScreenUpdateIndex:
	LDA #ScreenUpdateBuffer_RAM_301
	STA zScreenUpdateIndex
	JSR UpdateJoypads

	DEC zNMIOccurred

NMI_DoSoundProcessing:
	JSR DoSoundProcessing

NMI_CheckSave:
	JSR EngageSave

NMI_Exit:
	PLA
	TAY
	PLA
	TAX
	PLA
	PLP
	RTI

; End of function NMI

;
; Sets the PPU address to `$3f00`, then immediatley to `$0000`
;
; Speculation is that this ritual comes from a recommendation in some Nintendo
; documentation, but isn't actually necessary.
;
; See: https://forums.nesdev.com/viewtopic.php?f=2&t=16721
;
ResetPPUAddress:
	LDA PPUSTATUS
	LDA #$3F
	STA PPUADDR
	LDA #$00
	STA PPUADDR
	STA PPUADDR
	STA PPUADDR
	RTS


DoSoundProcessing:
	LDA #PRGBank_4_5
	ASL A
	ORA #$80
	STA MMC5_PRGBankSwitch2
	LDA iMusicBank
	STA MMC5_PRGBankSwitch3

	JSR StartProcessingSoundQueue

	LDA iCurrentROMBank
	JMP ChangeMappedPRGBank


ClearNametablesAndSprites:
	LDA #$00
	STA zPPUMask
	STA PPUMASK
	LDA #$20
	JSR ClearNametableChunk

	LDA #$24
	JSR ClearNametableChunk

	LDA #$28
	JSR ClearNametableChunk


HideAllSprites:
	LDY #$00
	LDA #$F8

HideAllSpritesLoop:
	STA iVirtualOAM, Y
	DEY
	DEY
	DEY
	DEY
	BNE HideAllSpritesLoop
	RTS


ClearNametableChunk:
	LDY PPUSTATUS ; Reset PPU address latch
	LDY #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIDisabled
	STY PPUCTRL ; Turn off NMI
	STY zPPUControl
	LDY #$00
	; A contains the high byte of the PPU address (generally $20, $24, $28)
	STA PPUADDR
	STY PPUADDR ; And Y has the low byte ($00)
	LDX #$03 ; Do $300 bytes for this loop.
	LDA #$FB

ClearNametableChunk_Loop:
	STA PPUDATA ; Store the blank tile $300 times
	INY
	BNE ClearNametableChunk_Loop ; (Loop falls through every $100 bytes)

	DEX
	BNE ClearNametableChunk_Loop ; Loop falls through after $300 bytes

ClearNametableChunk_Loop2:
	; Do another loop of $C0 bytes to clear the
	; rest of the nametable chunk
	STA PPUDATA
	INY
	CPY #$C0
	BNE ClearNametableChunk_Loop2

	LDA #$00 ; Load A with $00 for clearing the attribute tables

ClearNametableChunk_AttributeTableLoop:
	STA PPUDATA ; Clear attribute table...
	INY ; Y was $C0 on entry, so write $40 bytes...
	BNE ClearNametableChunk_AttributeTableLoop

PPUBufferUpdatesComplete:
	RTS ; Whew!


;
; Used to update the PPU nametable / palette data during NMI.
;
; This function can only handle $100 bytes of data
; (actually less).
;
; Unlike `UpdatePPUFromBufferWithOptions`, this one does not support
; $80 or $40 as options, instead treating them as direct length.
; It also does not increment the buffer pointer, only using Y
; to read further data.
;
; If Y overflows, it will resume copying again from the beginning,
; and can get into an infinite loop if it doesn't encounter
; a terminating $00. Welp!
;
UpdatePPUFromBufferNMI:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	STA PPUCTRL
	LDY #$00

UpdatePPUFromBufferNMI_CheckForBuffer:
	LDA (zPPUDataBufferPointer), Y
	BEQ PPUBufferUpdatesComplete

	LDX PPUSTATUS
	STA PPUADDR
	INY
	LDA (zPPUDataBufferPointer), Y
	STA PPUADDR
	INY
	LDA (zPPUDataBufferPointer), Y
	TAX

UpdatePPUFromBufferNMI_CopyLoop:
	INY
	LDA (zPPUDataBufferPointer), Y
	STA PPUDATA
	DEX
	BNE UpdatePPUFromBufferNMI_CopyLoop

	INY
	JMP UpdatePPUFromBufferNMI_CheckForBuffer


;
; This reads from $F0/$F1 to determine where a "buffer" is.
; Basically, a buffer is like this:
;
; PPUADDR  LEN DATA ......
; $20 $04  $03 $E9 $F0 $FB
; $25 $5F  $4F $FB
; $21 $82  $84 $00 $01 $02 $03
; $00
;
; PPUADDR is two bytes (hi,lo) for the address to send to PPUADDR.
; LEN is the length, with the following two bitmasks:
;
;  - $80: Set the "draw vertically" option
;  - $40: Use ONE tile instead of a string
;
; DATA is either (LEN) bytes or one byte.
;
; After (LEN) bytes have been written, the buffer pointer
; is incremented to (LEN+2) and the function restarts.
; A byte of $00 terminates execution and returns.
;
; There is a similar function, `UpdatePPUFromBufferNMI`,
; that is called during NMI, but unlike this one,
; that one does NOT use bitmasks, nor increment the pointer.
;
UpdatePPUFromBufferWithOptions:
	; First, check if we have anything to send to the PPU
	LDY #$00
	LDA (zPPUDataBufferPointer), Y
	; If the first byte at the buffer address is #$00, we have nothing. We're done here!
	BEQ PPUBufferUpdatesComplete

	; Clear address latch
	LDX PPUSTATUS
	; Set the PPU address to the
	; address from the PPU buffer
	STA PPUADDR
	INY
	LDA (zPPUDataBufferPointer), Y
	STA PPUADDR
	INY
	LDA (zPPUDataBufferPointer), Y ; Data segment length byte...
	ASL A
	PHA
	; Enable NMI + Vertical increment + whatever else was already set...
	LDA zPPUControl
	ORA #PPUCtrl_Base2000 | PPUCtrl_WriteVertical | PPUCtrl_Sprite0000 | PPUCtrl_Background0000 | PPUCtrl_SpriteSize8x8 | PPUCtrl_NMIEnabled
	; ...but only if $80 was set in the length byte. Otherwise, turn vertical incrementing back off.
	BCS UpdatePPUFBWO_EnableVerticalIncrement

	AND #PPUCtrl_Base2C00 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite1000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled | $40

UpdatePPUFBWO_EnableVerticalIncrement:
	STA PPUCTRL
	PLA
	; Check if the second bit ($40) in the length has been set
	ASL A
	; If not, we are copying a string of data
	BCC UpdatePPUFBWO_CopyStringOfTiles

	; Length (A) is now (A << 2).
	; OR in #$02 now if we are copying a single tile;
	; This will be rotated out into register C momentarily
	ORA #$02
	INY

UpdatePPUFBWO_CopyStringOfTiles:
	; Restore the data length.
	; A = (Length & #$3F)
	LSR A

	; This moves the second bit (used above to signal
	; "one tile mode") into the Carry register
	LSR A
	TAX ; Copy the length into register X

UpdatePPUFBWO_CopyLoop:
	; If Carry is set (from above), we're only copying one tile.
	; Do not increment Y to advance copying index
	BCS UpdatePPUFBWO_CopySingleTileSkip

	INY

UpdatePPUFBWO_CopySingleTileSkip:
	LDA (zPPUDataBufferPointer), Y ; Load data from buffer...
	STA PPUDATA ; ...store it to the PPU.
	DEX ; Decrease remaining length.
	BNE UpdatePPUFBWO_CopyLoop ; Are we done? If no, copy more stuff

	INY ; Y contains the amount of copied data now
	TYA ; ...and now A does
	CLC ; Clear carry bit (from earlier)
	ADC zPPUDataBufferPointer ; Add the length to the PPU data buffer
	STA zPPUDataBufferPointer
	LDA zPPUDataBufferPointer + 1
	; If the length overflowed (carry set),
	; add that to the hi byte of the pointer
	ADC #$00
	STA zPPUDataBufferPointer + 1
	; Start the cycle over again.
	; (If the PPU buffer points to a 0, it will terminate after this jump)
	JMP UpdatePPUFromBufferWithOptions
