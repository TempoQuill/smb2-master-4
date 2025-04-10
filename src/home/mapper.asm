;
; Switches the current CHR banks
;
ChangeCHRBanks:
	CLC ; added for lag frames
	LDA iObjCHR1
	STA MMC5_CHRBankSwitch1

	LDA iObjCHR2
	STA MMC5_CHRBankSwitch2

	LDA iObjCHR3
	STA MMC5_CHRBankSwitch3

	LDA iObjCHR4
	STA MMC5_CHRBankSwitch4

	LDA iBGCHR1
	STA MMC5_CHRBankSwitch5
	ADC #$01
	STA MMC5_CHRBankSwitch6

	LDA iBGCHR2
	STA MMC5_CHRBankSwitch7
	ADC #$01
	STA MMC5_CHRBankSwitch8

	LDA iBGCHR1
	STA MMC5_CHRBankSwitch9
	ADC #$01
	STA MMC5_CHRBankSwitch10

	LDA iBGCHR2
	STA MMC5_CHRBankSwitch11
	ADC #$01
	STA MMC5_CHRBankSwitch12
	RTS


;
; Calling this one will save the changed bank
; to RAM, so if something uses the below version
; the original bank set with this can be restored.
;
ChangeMappedPRGBank:
	STA iCurrentROMBank ; See below comment.

;
; Any call to this subroutine switches the lower two banks together.
;
; For example, loading Bank 0/1:
;
; ```
; LDA #$00
; JSR ChangeMappedPRGBank
; ```
;
; Loading Bank 2/3:
;
; ```
; LDA #$01
; JSR ChangeMappedPRGBank
; ```
;
; Etc.
;
; This version changes the bank numbers without
; saving the change to RAM, so the previous bank
; can be recalled later (mostly for temporary switches,
; like music handling and such)
;
ChangeMappedPRGBankWithoutSaving:
	ASL A

	ORA #$80
	STA MMC5_PRGBankSwitch2
	ORA #$01
	STA MMC5_PRGBankSwitch3
	RTS


;
; Sets the nametable mirroring by writing `$A000`.
;
; ##### Input
; - `A`: `$00` =  vertical, `$01` = horizontal
;
ChangeNametableMirroring:
	STA MMC5_NametableMapping
	RTS
