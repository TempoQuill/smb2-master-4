SoundTestAttributes:
	.db $23,$C9,(+b - +a)
+a
	.db     $00,$A0,$A0,$A0,$A0,$00,$00
	.db $00,$CC,$FF,$FF,$FF,$FF,$33,$00
	.db $00,$CC,$FF,$FF,$FF,$FF,$33,$00
	.db $00,$CC,$FF,$FF,$FF,$FF,$33,$00
	.db $00,$CC,$FF,$FF,$FF,$FF,$33,$00
+b
	.db $00

SoundTestTitle:
	.db $20,$CB,(+b - +a)
+a
	.db "SOUND"+$99
	.db $FB
	.db "TEST"+$99
+b
	.db $00

SoundTestMusic:
	.db $21,$27,(+b - +a)
+a
	.db "MUSIC"+$99
	.db $F6, $F6, $F6, $F6, $F6, $F6, $F6, $F6
+b
	.db $00

SoundTestPulseSFX:
	.db $21,$67,(+b - +a)
+a
	.db "PULSE"+$99
	.db $FB
	.db "SFX"+$99
	.db $F6, $F6, $F6, $F6
+b
	.db $00

SoundTestHillSFX:
	.db $21,$A7,(+b - +a)
+a
	.db "HILL"+$99
	.db $FB
	.db "SFX"+$99
	.db $F6, $F6, $F6, $F6, $F6
+b
	.db $00

SoundTestStaticSFX:
	.db $21,$E7,(+b - +a)
+a
	.db "STATIC"+$99
	.db $FB
	.db "SFX"+$99
	.db $F6, $F6, $F6
+b
	.db $00

SoundTestSnippets:
	.db $22,$27,(+b - +a)
+a
	.db "SNIPPETS"+$99
	.db $F6, $F6, $F6, $F6, $F6
+b
	.db $00

SoundTestSTARTATest:
	; START+A  TEST
	.db $22,$67,(+b - +a)
+a
	.db "START"+$99
	.db $FB
	.db "OR"+$99
	.db $FB
	.db "A"+$99
	.db $FB, $FB, $FB, $FB, $FB
	.db "TEST"+$99
+b
	.db $00

SoundTestLRID:
	; L+R        ID
	.db $22,$87,(+b - +a)
+a
	.db "LEFT"+$99
	.db $FB
	.db "OR"+$99
	.db $FB
	.db "RIGHT"+$99
	.db $FB, $FB, $FB, $FB
	.db "ID"+$99
+b
	.db $00

SoundTestUDCursor:
	; U+D    CURSOR
	.db $22,$a7,(+b - +a)
+a
	.db "UP"+$99
	.db $FB
	.db "OR"+$99
	.db $FB
	.db "DOWN"+$99
	.db $FB, $FB, $FB, $FB
	.db "QUEUE"+$99
+b
	.db $00

SoundTestBExit:
	; B        EXIT
	.db $22,$c7,(+b - +a)
+a
	.db "B"+$99
	.db $FB, $FB, $FB, $FB, $FB, $FB, $FB
	.db $FB, $FB, $FB, $FB, $FB, $FB, $FB
	.db "EXIT"+$99
+b
	.db $00

SoundTestRAMBuffer:
	.db $21,$37,$02,$FB,$D0
	.db $21,$77,$02,$FB,$D0
	.db $21,$B7,$02,$FB,$D0
	.db $21,$F7,$02,$FB,$D0
	.db $22,$37,$02,$FB,$D0
SoundTestRAMBufferEnd:
	.db $00

SoundTestQueueOffsets:
	.db iMusicQueue - iMusicQueue
	.db iMusicQueue - iMusicQueue
	.db iPulse2SFX - iMusicQueue
	.db iHillSFX - iMusicQueue
	.db iNoiseDrumSFX - iMusicQueue
	.db iDPCMSFX - iMusicQueue

SoundTestMaxes:
	.db 0
	.db NUM_MUSIC_TRACKS
	.db NUM_PULSE_IDS
	.db NUM_HILL_SFX
	.db NUM_NOISE_TRACKS - 1
	.db NUM_DPCM_SFX
