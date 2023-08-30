DMCStartTable:
	.db $00 ; $C000
	.db $10 ; $c400
	.db $20 ; $C800
	.db $27 ; $C9C0
	.db $4B ; $D2C0
	.db $36 ; $CD80
	.db $60 ; $D800
	.db $00 ; $C000
	.db $1A ; $c680
	.db $2F ; $CBC0
	.db $44 ; $D100
	.db $6C ; $DB00
	.db $00 ; $C000
	.db $1F ; $C7C0
	.db $39 ; $CE40
	.db $5B ; $D6C0

DMCLengthTable:
	.db $3D ; egg
	.db $3E ; uproot
	.db $19 ; slot
	.db $3B ; hold
	.db $53 ; charge
	.db $52 ; boss hit
	.db $2F ; impact
	.db $65 ; shell disappear
	.db $52 ; Going down jar
	.db $52 ; Exiting jar
	.db $A8 ; Phanto
	.db $1C ; Fire
	.db $7B ; Ending prompt
	.db $67 ; Save
	.db $85 ; Pause
	.db $30 ; Clawgrip chuck

DMCBankTable:
	audio_bank PRGBank_DMC_16
	audio_bank PRGBank_DMC_16
	audio_bank PRGBank_DMC_16
	audio_bank PRGBank_DMC_16
	audio_bank PRGBank_DMC_16
	audio_bank PRGBank_DMC_16
	audio_bank PRGBank_DMC_16
	audio_bank PRGBank_DMC_15
	audio_bank PRGBank_DMC_15
	audio_bank PRGBank_DMC_15
	audio_bank PRGBank_DMC_15
	audio_bank PRGBank_DMC_16
	audio_bank PRGBank_DMC_14
	audio_bank PRGBank_DMC_14
	audio_bank PRGBank_DMC_14
	audio_bank PRGBank_DMC_14
