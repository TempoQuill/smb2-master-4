;
; Save logic
;
; 
BackUpSaveData:
	LDY #SAVE_DATA_WIDTH - 1

BackUpSaveData_Loop:
	LDA sSaveData, Y
	STA sBackupSaveData, Y
	DEY
	BPL BackUpSaveData_Loop
	RTS

;
; Save data checksum
;
; Up to v1.5, the checksum routine adds all relevant data into one value,
; except for lives, which is stashed separately to avoid setting carry,
; then the sum and life stash is multiplied into the following two bytes.
;
ComputeCheckArea:
	; 2 3-byte strings
	LDY #3
	; start with Luigi's saved contributor number
	LDA sContributors + 3
	CLC

ComputeCheckArea_Loop:
	; + Toad's SCN + World
	; + Peach's SCN + Level Area
	; + Mario's SCN + Level
	ADC sContributors, Y
	ADC sSavedLvl, Y
	DEY
	BPL ComputeCheckArea_Loop
	; stash the sum in byte 0, transfer to Y as well
	STA sMultiChecksum
	TAY
	; put extra men in byte 1
	LDA sExtraMen
	STA sMultiChecksum + 1
	; poke the multiplier
	STY MMC5_Multiplier
	STA MMC5_Multiplier + 1
	; we can now pull the resulting product and stash it
	LDA MMC5_Multiplier
	LDY MMC5_Multiplier + 1
	STA sMultiChecksum + 2
	STY sMultiChecksum + 3
	RTS

ComputeBackupCheckArea:
	; do the backup save
	; 2 3-byte strings
	LDY #3
	; start with Luigi's backup contributor number
	LDA sBackupContributors + 3
	CLC
ComputeBackupCheckArea_Loop:
	; + Toad's BCN + World
	; + Peach's BCN + Level Area
	; + Mario's BCN + Level
	ADC sBackupContributors, Y
	ADC sBackupLvl, Y
	DEY
	BPL ComputeBackupCheckArea_Loop
	; stash the sum in byte 0, transfer to Y as well
	STA sBackupMultiChecksum
	TAY
	; put extra men in byte 1
	LDA sBackupExtraMen
	STA sBackupMultiChecksum + 1
	; poke the multiplier
	STY MMC5_Multiplier
	STA MMC5_Multiplier + 1
	; we can now pull the resulting product and stash it
	LDA MMC5_Multiplier
	LDY MMC5_Multiplier + 1
	STA sBackupMultiChecksum + 2
	STY sBackupMultiChecksum + 3
	RTS

EngageSave:
	LDA iStack
	CMP #Stack100_PauseSave
	BEQ EngageSave_Save
	CMP #Stack100_Save
	BNE EngageSave_Exit
EngageSave_Save:
	JSR BackUpSaveData
	JSR ComputeCheckArea
	JMP ComputeBackupCheckArea
EngageSave_Exit:
	RTS

PauseSounds:
	.db DPCM_Pause
	.db DPCM_Save
	.db DPCM_Save ; unused

StopOperationAndReset:
	LDA #DPCM_Save
	STA iDPCMSFX
	LDA #Stack100_Save
	STA iStack
StopOperationAndReset_Loop:
	LDA #1
	JSR DelayFrames
	LDA iCurrentDPCMSFX
	BNE StopOperationAndReset_Loop
	JSR ClearNametablesAndSprites
	TAX
StopOperationAndReset_ClearStack:
	STA iStack, X
	DEX
	BNE StopOperationAndReset_ClearStack
	JMP RESET
