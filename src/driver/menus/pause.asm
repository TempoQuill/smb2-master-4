ChooseSaveChoiceAttribute:
; Decide the attributes to send
; Output:
;	Y: Option offset
;		0 - Continue
;		1 - Save & Continue
;		2 - Save & Quit
	; up or down?
	LDA #SoundEffect2_CoinGet
	STA iPulse2SFX
	LDY zInputBottleneck
	TYA
	AND #ControllerInput_Down
	BNE ChooseSaveChoiceAttribute_Down
	TYA
	AND #ControllerInput_Up
	BNE ChooseSaveChoiceAttribute_Up
	; nothing was pressed
	LDY iStack + 1
	LDA #0
	STA iPulse2SFX
	RTS

ChooseSaveChoiceAttribute_Up:
	DEC iStack + 1
	BMI ChooseSaveChoiceAttribute_Min
	; Option number > $ff
	LDY iStack + 1
	RTS

ChooseSaveChoiceAttribute_Down:
	LDY iStack + 1
	CPY #PauseOption_SaveNQuit
	BCS ChooseSaveChoiceAttribute_Max
	; Option number < 2
	INY
	STY iStack + 1
	RTS

ChooseSaveChoiceAttribute_Min:
	LDA #PauseOption_Continue
	STA iStack + 1
	TAY
ChooseSaveChoiceAttribute_Max:
	RTS


PauseOptionData:
	; CONTINUE
	.db $25, $A6, $08
	.db $DC, $E8, $E7, $ED, $E2, $E7, $EE, $DE
	; SAVE AND CONTINUE
	.db $25, $E6, $11
	.db $EC, $DA, $EF, $DE, $FB, $DA, $E7, $DD, $FB
	.db $DC, $E8, $E7, $ED, $E2, $E7, $EE, $DE
	; SAVE AND QUIT
	.db $26, $26, $0D
	.db $EC, $DA, $EF, $DE, $FB, $DA, $E7, $DD, $FB
	.db $80, $EE, $E2, $Ed
	.db $00

PauseOptionPalette1:
	.db $27, $D9, $05
	.db $8C, $AF, $A3, $A0, $A0
	.db $27, $E1, $04
	.db $08, $0A, $0A, $0A
	.db $00

PauseOptionPalette2:
	.db $27, $D9, $05
	.db $C8, $FA, $F2, $F0, $F0
	.db $27, $E1, $04
	.db $08, $0A, $0A, $0A
	.db $00

PauseOptionPalette3:
	.db $27, $D9, $05
	.db $88, $AA, $A2, $A0, $A0
	.db $27, $E1, $04
	.db $0C, $0F, $0F, $0F
	.db $00
