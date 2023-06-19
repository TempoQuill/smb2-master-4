;
; Channel stacks
; This data is used to determine how many bytes to use in the headers.
; $03 -> 5 Bytes -> Pulses + Hill only
; $05 -> 7 Bytes -> All five channels
;
MusicChannelStack:
	.db $04 ; Overworld
	.db $04 ; CHR Select
	.db $03 ; Inside
	.db $03 ; Boss
	.db $03 ; Inv. Star
	.db $03 ; Subspace
	.db $03 ; Mamu
	.db $05 ; Title
;	.db $05
	.db $04 ; Ending
	.db $04 ; Subcons
; Fanfares
	.db $03 ; Mushroom
	.db $03 ; Boss Vic
;	.db $05
	.db $04 ; Ending - UNUSED
	.db $03 ; Down
	.db $03 ; Game Over
	.db $03 ; Crystal 1UP
	.db $04 ; Subcons - UNUSED
