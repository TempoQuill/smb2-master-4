;
; Updates joypad press/held values
;
UpdateJoypadsSimple:	
	JSR ReadJoypads
	LDX #1
	JMP UpdateJoypads_Loop

UpdateJoypads:
	; Work around DPCM sample bug,
	; where some spurious inputs are read
	LDA SND_CHN
	AND #$F0
	BEQ UpdateJoypadsSimple
	JSR ReadJoypads
	LDA zInputBottleneck
	STA iBackupPlayer1Input
	LDA zInputBottleneck + 1
	STA iBackupPlayer2Input
	JSR ReadJoypads
	LDA zInputBottleneck
	STA iBackupPlayer1Input + 1
	LDA zInputBottleneck + 1
	STA iBackupPlayer2Input + 1
	LDA iBackupPlayer1Input + 1
	EOR iBackupPlayer1Input
	BEQ UpdateJoypads_CheckPlayer2
	TAX

	LDA iBackupPlayer1Input + 1
	BEQ UpdateJoypads_FoundCorrectInput
	LDA iBackupPlayer1Input
	BEQ UpdateJoypads_FoundCorrectInput

	JSR UpdateJoypads_FindDeletion

	LDA iBackupPlayer1Input, Y

UpdateJoypads_FoundCorrectInput:
	STA zInputBottleneck

UpdateJoypads_CheckPlayer2:
	LDA iBackupPlayer2Input + 1
	LDX #1
	EOR iBackupPlayer2Input
	BEQ UpdateJoypads_Loop
	TAX
	LDA iBackupPlayer2Input + 1
	BEQ UpdateJoypads_FoundCorrectPlayer2Input
	LDA iBackupPlayer2Input
	BEQ UpdateJoypads_FoundCorrectPlayer2Input

	JSR UpdateJoypads_FindDeletionPlayer2

	LDA iBackupPlayer2Input, Y

UpdateJoypads_FoundCorrectPlayer2Input:
	STA zInputBottleneck + 1

	LDX #1

UpdateJoypads_Loop:
	LDA zInputBottleneck, X ; Update the press/held values
	TAY
	EOR zInputCurrentState, X
	AND zInputBottleneck, X
	STA zInputBottleneck, X
	STY zInputCurrentState, X
	DEX
	BPL UpdateJoypads_Loop
	RTS

UpdateJoypads_FindDeletionPlayer2:
	TXA
	AND iBackupPlayer2Input
	STA iInputPatch
	TXA
	AND iBackupPlayer2Input + 1
	JMP UpdateJoypads_FindDeletion_Common

UpdateJoypads_FindDeletion:
	TXA
	AND iBackupPlayer1Input
	STA iInputPatch
	TXA
	AND iBackupPlayer1Input + 1
UpdateJoypads_FindDeletion_Common:
	STA iInputPatch + 1
	LDY #0
UpdateJoypads_FindDeletion_Loop:
	LSR iInputPatch + 1
	BCS UpdateJoypads_FindDeletion_Found
	LDY #1
	LDA iInputPatch + 1
	BEQ UpdateJoypads_FindDeletion_Found
	LSR iInputPatch
	BCS UpdateJoypads_FindDeletion_Found
	LDY #0
	LDA iInputPatch
	BNE UpdateJoypads_FindDeletion_Loop
UpdateJoypads_FindDeletion_Found:
	RTS

;
; Reads joypad pressed input
;
ReadJoypads:
	LDX #$01
	STX zInputBottleneck + 1 ; set bottleneck 2 to 1 for signal
	STX JOY1
	DEX
	STX JOY1

ReadJoypadLoop1:
	LDA JOY1 ; $4016.0 = standard controller 1 bit data
	LSR A
	ROL zInputBottleneck
	LDA JOY2 ; $4017.0 = standard controller 2 bit data
	LSR A
	ROL zInputBottleneck + 1
	BCC ReadJoypadLoop1 ; loop until signel is sent to carry
	RTS
