DMCStartTable:
	.db $3C ; $cf00
	.db $00 ; $c000
	.db $2A ; $ca80
	.db $4A ; $d280
	.db $57 ; $d5c0
	.db $61 ; $d840
	.db $00 ; $c000
	.db $00 ; $c000

DMCStartTable2:
	.db $5B ; $D6C0
	.db $23 ; $c8C0
	.db $25 ; $C940
	.db $53 ; $D4C0
	.db $30 ; $cC00
	.db $18 ; $c600
	.db $00 ; $C000
	.db $4d ; $d340

DMCLengthTable:
	.db $7E ; door
	.db $EF ; phanto / rocket
	.db $a4 ; POW
	.db $34 ; hold
	.db $0d ; injury
	.db $34 ; unused
	.db $8A ; watch
	.db $a8 ; exit

DMCLengthTable2:
	.db $34 ; egg
	.db $a8 ; potion
	.db $2b ; select
	.db $81 ; throw
	.db $67 ; boss death
	.db $34 ; boss hit / shell disappear
	.db $5f ; impact
	.db $4E ; player death

DMCFreqTable:
	.db $0F
	.db $0B
	.db $0F
	.db $0F
	.db $0F
	.db $0F
	.db $0F
	.db $0F

DMCFreqTable2:
	.db $0F
	.db $0F
	.db $0F
	.db $0F
	.db $0F
	.db $0F
	.db $0F
	.db $0F

DMCBankTable:
	.db PRGBank_DMC_1C
	.db PRGBank_DMC_1C
	.db PRGBank_DMC_1B
	.db PRGBank_DMC_1E
	.db PRGBank_DMC_1E
	.db PRGBank_DMC_1D
	.db PRGBank_DMC_1D
	.db PRGBank_DMC_1B

DMCBankTable2:
	.db PRGBank_DMC_1E
	.db PRGBank_DMC_1D
	.db PRGBank_DMC_1E
	.db PRGBank_DMC_1B
	.db PRGBank_DMC_1E
	.db PRGBank_DMC_1E
	.db PRGBank_DMC_1E
	.db PRGBank_DMC_1D
