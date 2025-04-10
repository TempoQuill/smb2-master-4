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


.include "src/data/menus/pause-option.asm"
