;
; Channel stacks
; This data is used to determine how many bytes to use in the headers.
; $03 -> 5 Bytes -> Pulses + Hill only
; $05 -> 7 Bytes -> All five channels
;
MusicChannelStack:
	.db $05 ; Overworld
	.db $05 ; CHR Select
	.db $05 ; Inside
	.db $04 ; Boss
	.db $05 ; Inv. Star
	.db $05 ; Subspace
	.db $05 ; Mamu
	.db $05 ; Title
	.db $05 ; Ending
; Fanfares
	.db $05 ; Mushroom
	.db $05 ; Boss Vic
	.db $05 ; Ending - UNUSED
	.db $05 ; Down
	.db $05 ; Game Over
	.db $05 ; Crystal 1UP
