;
; The following four routines are for the save file menu, and the data to go
; along is mostly referenced by the local update index, with some bits of RAM
; bait thrown in, mostly just the save data presented by the menu
;
; This first one clears out the center area of the title screen, then prints
; out the menu line by line, as per VBlank rules.  A resulting quirk is that
; the template data can be seen for a few frames as the menu is being
; constructed before the save data fills in the blanks
;
InitSaveFileMenu:
	LDY #Hill_SpinJump
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
	; once we finish clearing out the title screen
	; it's time to construct the menu
	LDA #SAVE_MENU_BFR_ATTRIBUTES
	STA mLoadedDataBufferIndex
@Loop2:
; runs once a frame
	JSR WaitForNMI_SaveFileMenu
	DEC mLoadedDataBufferIndex
	BNE @Loop2
	; send the second bit of RAM bait
	LDY #SaveFileRAMBufferEnd - SaveFileRAMBuffer
@Loop3:
	LDA SaveFileRAMBuffer, Y
	STA mLoadedDataBuffer, Y
	DEY
	BPL @Loop3

;
; This is later treated as its own routine, as the initialization routine falls
; through once loading in the RAM bait to internal mapper RAM.  Our goal here's
; to fill in the blanks left by the template we've just constructed.
;
CheckSaveIfCorruptOrBlank:
	; make sure the correct RAM bank is loaded in according to the
	; corresponding number
	LDA mPRGRAMBank
	AND #$03 ; 32K mask
	STA MMC5_PRGBankSwitch1
	LDA #0
	STA mLoadedDataBufferIndex ; reference the RAM bait
	JSR LoadPreviousGame
	BCC RetrieveSaveData
	JSR ClearSaveData ; show no data if blank or corrupt!
	JMP InitNewGame

RetrieveSaveData:
; We land here if the data we load passes integrity checks, that is if data
; exists the first place.
	; get the amount of lives we have
	LDA sBackupExtraMen
	SEC ; convey as "extra men"
	SBC #1
	; retrieve two tiles for decimal equivalent
	JSR GetTwoDigitNumberTiles
	STY mLoadedLivesBCD
	STA mLoadedLivesBCD + 1
	; fetch world number, display as counting number instead of whole
	LDA sBackupWorld
	CLC
	ADC #$D1
	STA mLoadedWorld
	; fetch level number, relative to world
	LDA sBackupLvl
	SEC
	SBC sBackupWorld ; assumes three levels per world!
	SBC sBackupWorld
	SBC sBackupWorld
	CLC ; display as a counting number, not a whole number
	ADC #$D1
	STA mLoadedLevelRelative
	; load the 1up mushroom tile depending on the flag
	LDY sBackupLifeUpEventFlag
	LDA LifeUpEventFlagTiles, Y
	STA mLoaded1upFlagTile
	RTS

LifeUpEventFlagTiles:
	.db $FB
	.db $BA

;
; This routine is where we land once we press A or Start. It calls
; initialization, and then gives us a few options to work with
;
; Inputs:
; Left - previous file
; Right - next file
; Select - Copy and paste game (called "copypasta" here for humor)
; Start - New game
; B - Delete game
; A - Load game
;
SaveFileMenu:
	JSR InitSaveFileMenu

RunSaveFileMenu:
; start a fresh frame
	JSR WaitForNMI_SaveFileMenu
	; comb through inputs
	LDA zInputBottleneck
	LSR A ; right - inc file number (limit of 4, shown as 3)
	BCC RunSaveFileMenu_CheckLeft
	LDY #Hill_Fireball
	STY iHillSFX
	LDY mPRGRAMBank
	CPY #$D3
	BCS RunSaveFileMenu_CheckLeft
	INC mPRGRAMBank
RunSaveFileMenu_CheckLeft:
	LSR A ; left - dec file number
	BCC RunSaveFileMenu_CheckA
	LDY #Hill_Fireball
	STY iHillSFX
	LDY mPRGRAMBank
	CPY #$D1
	BCC RunSaveFileMenu_CheckA
	DEC mPRGRAMBank
RunSaveFileMenu_CheckA:
	LDA zInputBottleneck
	ASL A ; a - load game
	BCC RunSaveFileMenu_CheckB
	LDA #Music_StopMusic
	STA iMusicQueue
	LDA #SoundEffect2_CoinGet
	STA iPulse2SFX
	JSR CheckSaveIfCorruptOrBlank
RunSaveFileMenu_ALoop:
	JSR WaitForNMI_SaveFileMenu
	LDA iCurrentPulse2SFX
	BNE RunSaveFileMenu_ALoop
	JMP loc_BANK0_9C1F
RunSaveFileMenu_CheckB
	ASL A ; b - delete file
	BCC RunSaveFileMenu_CheckSelectStart
	PHA
	LDA #SoundEffect2_Shrinking
	STA iPulse2SFX
	JSR ClearSaveData
	PLA
RunSaveFileMenu_CheckSelectStart:
	; select - copy/paste
	; start - new game
	ASL A
	BCS SaveDataCopypasta
	BMI RunSaveFileMenu_Start
	JSR CheckSaveIfCorruptOrBlank
	JMP RunSaveFileMenu

RunSaveFileMenu_Start:
	LDA #Music_StopMusic
	STA iMusicQueue
	LDA #SoundEffect2_CoinGet
	STA iPulse2SFX
	JSR CheckSaveIfCorruptOrBlank
RunSaveFileMenu_StartLoop:
	JSR WaitForNMI_SaveFileMenu
	LDA iCurrentPulse2SFX
	BNE RunSaveFileMenu_StartLoop
	JSR InitNewGame
	JMP loc_BANK0_9C1F

;
; "Copy+Paste" function, humorously called "copypasta"
;
; We land here by pressing select on the menu. Two things can happen to start:
; If we don't have valid data, we're immediately booted back to hte menu
; If we do, we can copy that data to another bank
;
SaveDataCopypasta_Fail:
	JMP RunSaveFileMenu

SaveDataCopypasta:
	; fail sound
	LDA #Hill_LampBossDeath
	STA iHillSFX
	JSR CheckSaveIfCorruptOrBlank
	BCS SaveDataCopypasta_Fail
	; we pass integrity beyond this point
	; replace the sound
	LDA #SoundEffect3_Stomp
	STA iNoiseDrumSFX
	LDA #0
	STA iHillSFX
	; send bank to copypasta queues
	LDA mPRGRAMBank
	STA mCopypastaSource
	STA mCopypastaTarget
	; "TARGET FILE..."
	LDA #SAVE_MENU_BUFFER_INDEX_MAX
	STA mLoadedDataBufferIndex
; Inputs:
; Left - previous file
; Right - next file
; A - paste to current file
SaveDataCopypasta_Loop:
	JSR WaitForNMI_SaveFileMenu
	LDA #0
	STA mLoadedDataBufferIndex
	LDA zInputBottleneck
	AND #ControllerInput_Left | ControllerInput_Right | ControllerInput_A
	BEQ SaveDataCopypasta_Loop
	BMI SaveDataCopypasta_A
	LDY #Hill_Fireball
	STY iHillSFX
	LSR A
	BCC SaveDataCopypasta_Left
; right - maximum of 4 (shown as 3)
	LDA mCopypastaTarget
	CMP #$D3
	BCS SaveDataCopypasta_Loop
	INC mCopypastaTarget
	INC mPRGRAMBank
	BCC SaveDataCopypasta_Loop

SaveDataCopypasta_Left:
	LDA mCopypastaTarget
	CMP #$D1
	BCC SaveDataCopypasta_Loop
	DEC mCopypastaTarget
	DEC mPRGRAMBank
	BCS SaveDataCopypasta_Loop

SaveDataCopypasta_A:
	; set bank as target
	LDA mCopypastaTarget
	STA mPRGRAMBank
	; we need the source bank first
	LDA mCopypastaSource
	AND #$03
	STA MMC5_PRGBankSwitch1
	LDY #(SAVE_DATA_WIDTH * 2)
SaveDataCopypasta_ALoopIn:
	; copy to mapper RAM
	LDA sSaveData, Y
	STA mSaveDataBuffer, Y
	DEY
	BPL SaveDataCopypasta_ALoopIn
	; pause updates for one frame
	LDA #0
	STA iPPUBuffer
	STA zPPUDataBufferPointer
	JSR WaitForNMI_TitleScreen
	; now we need our target bank
	LDA mCopypastaTarget
	AND #$03
	STA MMC5_PRGBankSwitch1
	LDY #(SAVE_DATA_WIDTH * 2)
SaveDataCopypasta_ALoopOut:
	LDA mSaveDataBuffer, Y
	STA sSaveData, Y
	DEY
	BPL SaveDataCopypasta_ALoopOut
	; generate local checksums for integrity
	JSR ComputeCheckArea
	JSR ComputeBackupCheckArea
	; immediately test the generated checksums
	JSR CheckSaveIfCorruptOrBlank
	; "LOADED GAME..."
	LDA #SAVE_MENU_BFR_2
	STA mLoadedDataBufferIndex
	JSR WaitForNMI_SaveFileMenu
	; We did it! Reward the ears!
	LDA #SoundEffect2_1UP
	STA iPulse2SFX
	; flash the file number again
	LDA #0
	STA mLoadedDataBufferIndex
	JMP RunSaveFileMenu ; now back to your regularly scheduled menu code
;
; A sub that clears save data, that is if it's empty, corrupt, or the player
; just felt like deleting it for some reason.
;
ClearSaveData:
	LDA #$F4 ; dash
	STA mLoadedWorld
	STA mLoadedLevelRelative
	STA mLoadedLivesBCD
	STA mLoadedLivesBCD + 1
	LDA #$FB ; blank
	STA mLoaded1upFlagTile
	LDA #0
	LDY #SAVE_DATA_WIDTH - 1
@Loop:
	STA sBackupSaveData, Y
	STA sSaveData, Y
	DEY
	BPL @Loop
	RTS

SaveFileInit_Packet:
REPT 16
	.db $54
ENDR
	.db $50
	.db $50
	.db $50
SaveFileInit_PacketEnd:

SaveFileInit_Lo:
	.dl $22e6
	.dl $22c6
	.dl $22a6
	.dl $2286
	.dl $2266
	.dl $2246
	.dl $2226
	.dl $2206
	.dl $21e6
	.dl $21c6
	.dl $21a6
	.dl $2186
	.dl $2166
	.dl $2146
	.dl $2126
	.dl $2106
	.dl $20e8
	.dl $20c8
	.dl $20a8

SaveFileInit_Hi:
	.dh $22e6
	.dh $22c6
	.dh $22a6
	.dh $2286
	.dh $2266
	.dh $2246
	.dh $2226
	.dh $2206
	.dh $21e6
	.dh $21c6
	.dh $21a6
	.dh $2186
	.dh $2166
	.dh $2146
	.dh $2126
	.dh $2106
	.dh $20e8
	.dh $20c8
	.dh $20a8

SaveFileAttributes:
	.db $23,$C9,(+b - +a)
+a
	.db     $00,$A0,$A0,$A0,$A0,$00,$00
	.db $00,$8C,$AF,$AF,$AF,$AF,$23,$00
	.db $00,$88,$AA,$AA,$AA,$AA,$22,$00
	.db $00,$CC,$FF,$FF,$FF,$FF,$33,$00
	.db $00,$CC,$FF,$FF,$FF,$FF,$33,$00
+b
	.db $00

SaveFileCopypastaData:
	.db $21,$26,(+b - +a)
+a
	.db "TARGET"+$99
	.db $FB
	.db "FILE"+$99
	.db $F6, $F6, $F6
	.db $FB, $FB, $FB
	.db $F4
+b
	.db $00

SaveFileLayout1:
	.db $20,$CB,(+b - +a)
+a
	.db "SAVE"+$99
	.db $FB
	.db "FILES"+$99
+b
	.db $00
SaveFileLayout2:
	.db $21,$26,(+b - +a)
+a
	.db "LOADED"+$99
	.db $FB
	.db "GAME"+$99
	.db $F6, $F6, $F6
	.db $FB, $FB, $FB
	.db $F4
+b
	.db $00

SaveFileLayout3:
	.db $21,$66,(+b - +a)
+a
	.db "LEVEL"+$99
	.db $F6, $F6, $F6, $F6, $F6, $F6, $F6, $F6, $F6
	.db $FB, $FB
	.db $F4, $F4, $F4, $FB
+b
	.db $00

SaveFileLayout4:
	.db $21,$a6,(+b - +a)
+a
	.db "EXTRA"+$99
	.db $FB
	.db "MEN"+$99
	.db $F6, $F6, $F6, $F6, $F6
	.db $FB, $FB
	.db $F4, $F4, $FB, $FB
+b
	.db $00

SaveFileLayout5:
	.db $22,$26,(+b - +a)
+a
	.db "B"+$99
	.db $FB, $F4, $FB
	.db "DELETE"+$99
	.db $FB
	.db "THIS"+$99
	.db $FB
	.db "GAME"+$99
+b
	.db $00

SaveFileLayout6:
	.db $22,$66,(+b - +a)
+a
	.db "SELECT"+$99
	.db $FB, $F4, $FB
	.db "COPY"+$99
	.db $B9
	.db "PASTE"+$99
+b
	.db $00

SaveFileLayout7:
	.db $22,$a8,(+b - +a)
+a
	.db "A"+$99
	.db $FB, $F4, $FB
	.db "LOAD"+$99
	.db $FB
	.db "THIS"+$99
	.db $FB
	.db "GAME"+$99
+b
	.db $00

SaveFileLayout8:
	.db $22,$e8,(+b - +a)
+a
	.db "START"+$99
	.db $FB, $F4, $FB
	.db "NEW"+$99
	.db $FB
	.db "GAME"+$99
+b
	.db $00

SaveFileRAMBuffer:
	.db $21, $37, $01, $D0
	.db $21, $76, $04, $F4, $F4, $F4, $FB
	.db $21, $b6, $02, $f4, $f4
SaveFileRAMBufferEnd:
	.db $00

LoadPreviousGame_Corrupt:
	SEC
	RTS

LoadPreviousGame:
; integrity check, make sure backup data matches
	; make sure the backup checksum is valid before doing anything
	; byte 0
	CLC
	LDY #3
	LDA sBackupContributors + 3
LoadPreviousGame_BackupByte0:
	ADC sBackupContributors, Y
	ADC sBackupLvl, Y
	DEY
	BPL LoadPreviousGame_BackupByte0
	CMP sBackupMultiChecksum
	BNE LoadPreviousGame_Corrupt

	; byte 1
	LDA sBackupExtraMen
	CMP sBackupMultiChecksum + 1
	BNE LoadPreviousGame_Corrupt
	; byte 2 / 3
	LDA sBackupMultiChecksum
	LDY sBackupMultiChecksum + 1
	STA MMC5_Multiplier
	STY MMC5_Multiplier + 1
	LDA MMC5_Multiplier
	LDY MMC5_Multiplier + 1
	CMP sBackupMultiChecksum + 2
	BNE LoadPreviousGame_Corrupt
	CPY sBackupMultiChecksum + 3
	BNE LoadPreviousGame_Corrupt
	; checksums
	JSR ComputeCheckArea
	LDY #3
LoadPreviousGame_Checksums:
	LDA sMultiChecksum, Y
	CMP sBackupMultiChecksum, Y
	BNE RetrieveBackupData
	DEY
	BPL LoadPreviousGame_Checksums

	LDY #SAVE_DATA_WIDTH - 1
	; data
LoadPreviousGame_Data:
	LDA sSaveData, Y
	CMP sBackupSaveData, Y
	BNE RetrieveBackupData
	DEY
	BPL LoadPreviousGame_Data
	; is the life up flag out of bounds?
	LDA sLifeUpEventFlag
	AND #$fe
	BNE LoadPreviousGame_Corrupt
	; Yay!  No corruption!

RetrieveBackupData:
; Copy backup data to main save data
	LDY #SAVE_DATA_WIDTH - 1

RetrieveBackupData_Copy:
	LDA sBackupSaveData, Y
	STA sSaveData, Y
	DEY
	BPL RetrieveBackupData_Copy
	LDY #3
RetrieveBackupData_LoadContributorData:
	LDA sContributors, Y
	STA iCharacterLevelCount, Y
	DEY
	BPL RetrieveBackupData_LoadContributorData
	JSR ComputeCheckArea
	; now, if all values are zero's, generate a new game
	LDY #SAVE_DATA_WIDTH - 1
	LDA sSaveData, Y
RetrieveBackupData_Zeros:
	ORA sSaveData, Y
	DEY
	BPL RetrieveBackupData_Zeros
	TAY
	CLC
	BNE +
	SEC
+	RTS

InitNewGame:
	LDA #5
	STA sExtraMen
	LDY #7
	LDA #0
InitNewGame_Loop:
	STA sSaveData, Y
	DEY
	BPL InitNewGame_Loop
	RTS

.include "src/data/title/fade.asm"
