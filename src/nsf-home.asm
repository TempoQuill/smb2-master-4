
PLAY:
	LDX #$ff ; set X to -1
	SEC
@Loop:
	INX ; now we scroll through each of the queues
	SBC NSFMaxes, X ; subtract the max
	BCS @Loop
	SEC
	ADC NSFMaxes, X ; add back the current max
	STA iMusicQueue, X ; set the corresponding queue
	RTS

SetMusicBank:
	ASL A
	STA NSFBank2
	ORA #1
	STA NSFBank3
	RTS

NSFMaxes:
	.db NUM_MUSIC_TRACKS
	.db NUM_HILL_SFX
	.db NUM_DPCM_SFX
	.db 0
	.db NUM_PULSE_IDS
	.db NUM_NOISE_TRACKS - 1
