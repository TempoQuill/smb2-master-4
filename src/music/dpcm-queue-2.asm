
ProcessDPCMQueue2:
	LDA iDPCMSFX2
	BNE ProcessDPCMQueue2_Part2

	LDA iCurrentDPCMSFX2
	BEQ ProcessDPCMQueue2_None

ProcessDPCMQueue2_DecTimer:
	DEC iDPCMTimer1
	BNE ProcessDPCMQueue2_Exit

ProcessDPCMQueue2_None:
	LDA #$00
	STA iCurrentDPCMSFX2
	STA iDPCMBossPriority
	LDA #%00001111
	STA SND_CHN

ProcessDPCMQueue2_Exit:
	RTS

ProcessDPCMQueue2_Part2:
	LDY iDPCMBossPriority
	BEQ ProcessDPCMQueue2_Part3

	CMP iDPCMBossPriority
	BNE ProcessDPCMQueue2_DecTimer

ProcessDPCMQueue2_Part3:
	STA iCurrentDPCMSFX2
	LDY #$00

ProcessDPCMQueue2_PointerLoop:
	INY
	LSR A
	BCC ProcessDPCMQueue2_PointerLoop

IF INES_MAPPER = MAPPER_MMC5
	LDA DMCBankTable2, Y
	ORA #$80
	STA MMC5_PRGBankSwitch4
ENDIF

	LDA DMCFreqTable2 - 1, Y
	STA DMC_FREQ

	LDA DMCStartTable2 - 1, Y
	STA DMC_START
	LDA DMCLengthTable2 - 1, Y
	STA DMC_LEN
	LSR A
	LSR A
	STA iDPCMTimer1
	LDA #%00001111
	STA SND_CHN
	LDA #%00011111
	STA SND_CHN
	RTS

DMCStartTable2:
	.db $23 ; $c8c0
	.db $00 ; $c000
	.db $00 ; $c000
	.db $3C ; $cf00
	.db $00 ; $ca40
	.db $00 ; $c000
	.db $4D ; $d340
	.db $61 ; $d840

DMCLengthTable2:
	.db $a8 ; potion
	.db $EF ; phanto / rocket
	.db $a4 ; POW
	.db $7E ; door
	.db $a8 ; exit
	.db $8A ; watch
	.db $4E ; player death
	.db $34 ; unused

DMCFreqTable2:
	.db $0F
	.db $0B
	.db $0F
	.db $0F
	.db $0F
	.db $0F
	.db $0F
	.db $0F

DMCBankTable2:
	.db PRGBank_DMC_D
	.db PRGBank_DMC_B
	.db PRGBank_DMC_7
	.db PRGBank_DMC_B
	.db PRGBank_DMC_7
	.db PRGBank_DMC_D
	.db PRGBank_DMC_D
	.db PRGBank_DMC_D
