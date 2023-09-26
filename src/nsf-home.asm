NUM_BITWISE_SFX = 8
NUM_TRIANGLE_TRACKS = NUM_MUSIC_TRACKS + NUM_BITWISE_SFX
NUM_DPCM_TRACKS = NUM_TRIANGLE_TRACKS + NUM_DPCM_IDS
NUM_PULSE_TRACKS = NUM_DPCM_TRACKS + NUM_BITWISE_SFX

PLAY:
	LDX #0
	CMP #NUM_MUSIC_TRACKS
	BCC PLAY_Music
	INX
	CMP #NUM_TRIANGLE_TRACKS
	BCC PLAY_Triangle
	SBC #1
	INX
	CMP #NUM_DPCM_TRACKS
	BCC PLAY_DPCM
	INX
	INX
	CMP #NUM_PULSE_TRACKS
	BCC PLAY_Pulse
	INX
	SBC #NUM_PULSE_TRACKS - NOISE_SFX
	BNE PLAY_SFX

PLAY_Music:
	ADC #1
	STA iMusicQueue
	RTS

PLAY_Triangle:
	SEC
	SBC #NUM_MUSIC_TRACKS
	TAY
	LDA BitwiseMusicIDs, Y
	BNE PLAY_SFX

PLAY_DPCM:
	ADC #2
	SEC
	SBC #NUM_TRIANGLE_TRACKS
	BPL PLAY_SFX

PLAY_Pulse:
	SEC
	SBC #NUM_DPCM_TRACKS
	TAY
	LDA BitwiseMusicIDs, Y

PLAY_SFX:
	STA iMusicQueue, X
	RTS

BitwiseMusicIDs:
	.db $01, $02, $04, $08, $10, $20, $40, $80

SetMusicBank:
	ASL A
	STA NSFBank2
	ORA #1
	STA NSFBank3
	RTS
