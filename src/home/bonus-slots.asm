StartSlotMachine:
	DEC iTotalCoins
	JSR WaitForNMI

	JSR sub_BANKF_EA68

	LDA #7
	STA zSFXReelTimer
	LDA #$01 ; Set all reel timers
	STA zObjectXLo
	STA zObjectXLo + 1
	STA zObjectXLo + 2
	LSR A ; Set all reels to the first position
	STA zObjectXLo + 6
	STA zObjectXLo + 7
	STA zObjectXLo + 8

SpinSlots:
	JSR WaitForNMI ; $2C-$2E: Reel change timer
	; $2F-$31: Current reel icon
	DEC zSFXReelTimer
	BNE SpinSlots_Handling

	LDA #SFX_SLOT ; Play "reel sound" sound effect
	STA iHillSFX
	LDA #7
	STA zSFXReelTimer

SpinSlots_Handling:
	JSR CheckStopReel

	JSR TimedSlotIncrementation

	JSR UpdateSlotSprites

	JSR SlotMachineTextFlashIndex

	LDA BonusChanceUpdateBuffer_PUSH_A_BUTTON, Y
	STA zScreenUpdateIndex
	INC z06
	LDA zObjectXLo ; Reel 1 still active?
	ORA zObjectXLo + 1 ; Reel 2 still active?
	ORA zObjectXLo + 2 ; Reel 3 still active?
	BNE SpinSlots ; If any are still active, go back to waiting

	LDA #ScreenUpdateBuffer_RAM_ErasePushAButtonText
	STA zScreenUpdateIndex
	JSR WaitForNMI

	LDY #$00
	LDX zObjectXLo + 6 ; Load reel 1
	LDA mReelBuffer, X
	BNE CheckReel2Symbol ; Is this reel a cherry?

	INY ; Yes; add one life

CheckReel2Symbol:
	LDX zObjectXLo + 7 ; Load reel 2
	CMP mReelBuffer + 8, X
	BNE AddSlotMachineExtraLives ; Does this match the previous symbol?

	CMP #$00 ; Yes; are they both cherries?
	BNE CheckReel3Symbol ; If no, skip to third reel

	INY ; They are both cherries, add another life or something

CheckReel3Symbol:
	LDX zObjectXLo + 8 ; Load reel 3
	CMP mReelBuffer + 16, X ; Does reel 3 match the previous two?
	BNE AddSlotMachineExtraLives ; HEHE, NNNOPE

	INY ; They all match! Yay! Add 2 extra lives.
	INY
; Cherry count: 3 / Non-cherry: 1
	CMP #$00 ; Were they all cherries?
	BNE MaybeCoins ; Okay, they could be 7s

	DEY ; Yes, 3 lives total

MaybeCoins:
	CMP #$20 ; 7s?
	BNE AddSlotMachineExtraLives ; Nope, all done

	LDY #10 ; just hard code 10 lives, faster that way

AddSlotMachineExtraLives:
	TYA ; Y contains extra lives to add
	CLC
	ADC iExtraMen ; Add won extra lives to current lives
	CMP #101
	BCC loc_BANKF_E8D3 ; Check if adding extra lives has wrapped the counter

	LDA #100 ; If so, set extra lives to 100

loc_BANKF_E8D3:
; now to check for coin service
	STA iExtraMen
	STA sExtraMen
	JSR CheckForCoinService
	LDA #0
	STA iBonusDrumRoll
	TYA ; Did we actually win any lives?
	BEQ SlotMachineLoseFanfare ; No, play lose sound effect

	JSR GetTwoDigitNumberTiles
	STY mLDPBonusChanceLiveEMCount - 1
	STA mLDPBonusChanceLiveEMCount ; Update number of lives won
	JSR SlotMachine_WaitforSFX
	LDA #MUSIC_CRYSTAL ; Play winner jingle
	STA iMusicQueue
	LDA #$A0
	STA z06
	JSR WaitForNMI

	JSR sub_BANKF_EA68

loc_BANKF_E8ED:
	JSR WaitForNMI

	JSR SlotMachineTextFlashIndex

	LDA BonusChanceUpdateBuffer_PLAYER_1UP, Y
	STA zScreenUpdateIndex
	DEC z06
	BNE loc_BANKF_E8ED

	JSR ExecuteCoinService

	JMP loc_BANKF_E90C

SlotMachineLoseFanfare:
	JSR SlotMachine_WaitforSFX

	LDA #MUSIC_PLAYER_DOWN
	STA iMusicQueue
	JSR WaitForNMI

	JSR sub_BANKF_EA68

IFNDEF RGME_AUDIO
	JSR SlotMachine_WaitforJingle
ELSE
	LDA #$7c
	JSR DelayFrames
ENDIF

loc_BANKF_E90C:
	LDA #ScreenUpdateBuffer_RAM_EraseBonusMessageTextUnused
	STA zScreenUpdateIndex
	JSR WaitForNMI

	JMP loc_BANKF_E7FD

SlotMachine_WaitforSFX:
	LDA iCurrentPulse2SFX
	BEQ SlotMachine_SFXDone
	JSR WaitForNMI
	JMP SlotMachine_WaitforSFX
SlotMachine_SFXDone:
	RTS

SlotMachine_WaitforJingle:
	LDA iCurrentMusic
	BEQ SlotMachine_JingleDone
	JSR WaitForNMI
	JMP SlotMachine_WaitforJingle
SlotMachine_JingleDone:
	RTS

;
; Used for flashing text in Bonus Chance
;
; ##### Input
; - `z06`: Bonus Chance timer
;
; ##### Output
; - `Y`: 0 to show text, 1 to hide text
;
SlotMachineTextFlashIndex:
	LDA z06
	LSR A
	LSR A
	LSR A
	LSR A
	AND #$01
	TAY
	RTS


NoCoinsForSlotMachine:

	LDA #MUSIC_PLAYER_DOWN
	STA iMusicQueue

	STA z06
loc_BANKF_E92A:
	LDA z06
	AND #$01
	TAY
	LDA BonusChanceUpdateBuffer_NO_BONUS, Y
	STA zScreenUpdateIndex

	LDA #$0A
	STA z07
loc_BANKF_E938:
	JSR WaitForNMI_TurnOnPPU
	DEC z07
	BNE loc_BANKF_E938

	DEC z06
	BPL loc_BANKF_E92A

	LDA iCurrentMusic
	BNE loc_BANKF_E92A

	JMP GoToNextLevel

Delay80Frames:
	LDA #$50
	BNE DelayFrames

Delay160Frames:
	LDA #$A0

DelayFrames:
	STA z07
DelayFrames_Loop:
	JSR WaitForNMI_TurnOnPPU
	DEC z07
	BNE DelayFrames_Loop
	RTS
