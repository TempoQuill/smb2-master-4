DMCStartTable2:
	.db $23 ; $c8c0
	.db $00 ; $c000
	.db $29 ; $c000
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
