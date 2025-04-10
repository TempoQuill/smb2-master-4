
RESET_MMC5:
	; Set PRG mode 3 and CHR mode 3
	LDA #$03
	STA MMC5_PRGMode
	STA MMC5_CHRMode

	; Enable PRG RAM writing
	LDA #$02
	STA MMC5_PRGRAMProtect1
	STA MMC5_ExtendedRAMMode
	LDA #$01
	STA MMC5_PRGRAMProtect2

	; Set nametable mapping
	LDA #%01010000
	STA MMC5_NametableMapping

	LDA #$00
	STA MMC5_PRGBankSwitch1
	STA MMC5_CHRBankSwitchUpper

	; MMC5 Pulse channels
	LDA #$0F
	STA MMC5_SND_CHN

	; PRG bank 0
	LDA #$80 ; ROM bank 0
	STA MMC5_PRGBankSwitch2 ; $8000-$9FFF

	; PRG bank 1
	LDA #$81 ; ROM bank 1
	STA MMC5_PRGBankSwitch3 ; $A000-$BFFF

	; PRG bank 2
	LDA #$9E ; ROM bank 1E
	STA MMC5_PRGBankSwitch4 ; $C000-$DFFF

	; PRG bank 3
	LDA #$9F ; ROM bank 1F
	STA MMC5_PRGBankSwitch5 ; $E000-$FFFF

	JMP RESET
