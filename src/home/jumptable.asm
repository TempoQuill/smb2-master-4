;
; Load A with an index and call this to
; jump to a pointer from the table directly
; after the call.
;
JumpToTableAfterJump:
	ASL A
	TAY
	PLA
	STA z0a
	PLA
	STA z0b
	INY
	LDA (z0a), Y
	STA z0c
	INY
	LDA (z0a), Y
	STA z0d
	JMP (z0c)
