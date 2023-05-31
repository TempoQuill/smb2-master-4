;
; Bank 4 & Bank 5
; ===============
;
; What's inside:
;
;   - Music engine
;   - Sound effects engine
;   - Sound effect pointers and data
;   - Song pointers and data
;   - Note length tables (tempos)
;   - Instrument tables and data
;

StartProcessingSoundQueue:
	LDA #$FF
	STA JOY2
	LDA iStack
	CMP #Stack100_Pause
	BNE MusicAndSFXProcessing

	LDA #%00001100 ; Mute the two square channels
	STA SND_CHN
	; You would think you could skip processing,
	; since if the game is paused, nothing should
	; be setting new music or whatever.
	;
	; You would be correct, except for the suicide code!
	; That sets iMusic2.
	;
	; If not for processing it, the music would not
	; change (or stop) when you used the code. Welp!
	JMP ProcessOnlyMusicQueue2

MusicAndSFXProcessing:

IFDEF FIX_MIXER_CODE
CheckMixer:
	LDA SND_CHN
	AND #%11110011
	BNE ProcessMusicAndSfxQueues
	LDA #%00001111
	STA SND_CHN
ENDIF
ProcessMusicAndSfxQueues:
	JSR ProcessSoundEffectQueue2

	JSR ProcessSoundEffectQueue1

	JSR ProcessSoundEffectQueue3

	JSR ProcessDPCMQueue

ProcessOnlyMusicQueue2:
	JSR ProcessMusicQueue

	; Reset queues
	LDA #$00
	STA iPulse1SFX
	STA iMusic2
	STA iPulse2SFX
	STA iDPCMSFX
	STA iMusic1
	STA iNoiseSFX
	RTS


ProcessSoundEffectQueue2_Jump:
	LDA #$42
	LDX #$82
	LDY #$A8
	JSR PlaySquare1Sweep

	LDA #$22
	STA zPulse1Timer

ProcessSoundEffectQueue2_JumpPart2:
	LDA zPulse1Timer
	CMP #$20
	BNE ProcessSoundEffectQueue2_JumpPart3

	LDX #$DF
	LDY #$F6
	BNE ProcessSoundEffectQueue2_SetSquare1ThenDecrementTimer

ProcessSoundEffectQueue2_JumpPart3:
	CMP #$1A
	BNE ProcessSoundEffectQueue2_ThenDecrementTimer

	LDX #$C1
	LDY #$BC

ProcessSoundEffectQueue2_SetSquare1ThenDecrementTimer:
	JSR SetSquare1VolumeAndSweep

	BNE ProcessSoundEffectQueue2_ThenDecrementTimer

ProcessSoundEffectQueue2_CoinGet:
	LDA #$35
	LDX #$8D
	STA zPulse1Timer

	LDY #$7F
	LDA #$5E
	JSR PlaySquare1Sweep

ProcessSoundEffectQueue2_CoinGetPart2:
	LDA zPulse1Timer
	CMP #$30
	BNE ProcessSoundEffectQueue2_ThenDecrementTimer

	LDA #$54
	STA SQ1_LO

ProcessSoundEffectQueue2_ThenDecrementTimer:
	BNE ProcessSoundEffectQueue2_DecrementTimer

ProcessSoundEffectQueue2:
	LDA iCurrentPulse1SFX
	CMP #SoundEffect2_Climbing
	BEQ ProcessSoundEffectQueue2_DecrementTimer

	LDY iPulse1SFX
	BEQ ProcessSoundEffectQueue2_None

	STY iCurrentPulse1SFX
	LSR iPulse1SFX
	BCS ProcessSoundEffectQueue2_Jump

	LSR iPulse1SFX
	BCS ProcessSoundEffectQueue2_Climbing

	LSR iPulse1SFX
	BCS ProcessSoundEffectQueue2_CoinGet

	LSR iPulse1SFX
	BCS ProcessSoundEffectQueue2_Shrinking

	LSR iPulse1SFX
	BCS ProcessSoundEffectQueue2_IntroFallSlide

	LSR iPulse1SFX
	BCS ProcessSoundEffectQueue2_Growing

ProcessSoundEffectQueue2_None:
	LDA iCurrentPulse1SFX
	BEQ ProcessSoundEffectQueue2_NoneExit

	; Jumping
	LSR A
	BCS ProcessSoundEffectQueue2_JumpPart2

	; Climbing
	LSR A
	BCS ProcessSoundEffectQueue2_DecrementTimer

	; CoinGet
	LSR A
	BCS ProcessSoundEffectQueue2_CoinGetPart2

	; Shrinking
	LSR A
	BCS ProcessSoundEffectQueue2_ShrinkingPart2

	; IntroFallSlide
	LSR A
	BCS ProcessSoundEffectQueue2_DecrementTimer

	; Growing
	LSR A
	BCS ProcessSoundEffectQueue2_GrowingPart2

ProcessSoundEffectQueue2_NoneExit:
	RTS

ProcessSoundEffectQueue2_IntroFallSlide:
	LDA #$60
	LDY #$A5
	BNE ProcessSoundEffectQueue2_SingleSweep

ProcessSoundEffectQueue2_Climbing:
	STY iCurrentPulse1SFX
	LDA #$05
	LDY #$9C

; A = timer
; Y = sweep
ProcessSoundEffectQueue2_SingleSweep:
	LDX #$9E
	STA zPulse1Timer
	LDA #$60
	JSR PlaySquare1Sweep

ProcessSoundEffectQueue2_DecrementTimer:
	DEC zPulse1Timer
	BNE ProcessSoundEffectQueue2_Exit

IFNDEF FIX_MIXER_CODE
	LDX #%00001110
	STX SND_CHN
	LDX #%00001111
	STX SND_CHN
ELSE
	LDX #$10
	STA SQ1_VOL
ENDIF
	LDX #$00
IFDEF FIX_MIXER_CODE
	STX SQ1_LO
	STX SQ1_HI
ENDIF
	STX iCurrentPulse1SFX

ProcessSoundEffectQueue2_Exit:
	RTS

ProcessSoundEffectQueue2_Shrinking:
	LDA #$2F
	STA zPulse1Timer

ProcessSoundEffectQueue2_ShrinkingPart2:
	LDA zPulse1Timer
	LSR A
	BCS ProcessSoundEffectQueue2_ShrinkingPart3

	LSR A
	BCS ProcessSoundEffectQueue2_ShrinkingPart3

	AND #$02
	BEQ ProcessSoundEffectQueue2_ShrinkingPart3

	LDY #$91
	LDX #$9A
	LDA #$68
	JSR PlaySquare1Sweep

ProcessSoundEffectQueue2_ShrinkingPart3:
	JMP ProcessSoundEffectQueue2_DecrementTimer

ProcessSoundEffectQueue2_Growing:
	LDA #$36
	STA zPulse1Timer

ProcessSoundEffectQueue2_GrowingPart2:
	LDA zPulse1Timer
	LSR A
	BCS ProcessSoundEffectQueue2_DecrementTimer

	TAY
	LDA MushroomSoundData - 1, Y
	LDX #$5D
	LDY #$7F
	JSR PlaySquare1Sweep

	JMP ProcessSoundEffectQueue2_DecrementTimer

MushroomSoundData:
	.db $6A, $74, $6A, $64, $5C, $52, $5C, $52, $4C, $44, $66, $70, $66, $60, $58, $4E
	.db $58, $4E, $48, $40, $56, $60, $56, $50, $48, $3E, $48, $3E, $38, $30 ; $10


ProcessSoundEffectQueue1:
	LDA iPulse2SFX
	BEQ ProcessSoundEffectQueue1_None

	CMP #SoundEffect1_StopwatchTick
	BNE ProcessSoundEffectQueue1_Part2

	LDX iCurrentPulse2SFX
	BEQ ProcessSoundEffectQueue1_Part2

ProcessSoundEffectQueue1_None:
	LDA iCurrentPulse2SFX
	BNE ProcessSoundEffectQueue1_Part3
	RTS

ProcessSoundEffectQueue1_Part2:
	STA iCurrentPulse2SFX
	LDY #$00

ProcessSoundEffectQueue1_PointerLoop:
	INY
	LSR A
	BCC ProcessSoundEffectQueue1_PointerLoop

	LDA SoundEffectPointers - 1, Y
	STA zPulse2Index

ProcessSoundEffectQueue1_Part3:
	LDY zPulse2Index
	INC zPulse2Index
	LDA SoundEffectPointers, Y
	BMI ProcessSoundEffectQueue1_Patch

	BNE ProcessSoundEffectQueue1_Note

	; if it was $00, we're at the end of the data for this sound effect
	LDX #$90
	STX SQ2_VOL
	LDX #$18
	STX SQ2_HI
	LDX #$00
	STX SQ2_LO
	STX iCurrentPulse2SFX
	RTS

ProcessSoundEffectQueue1_Patch:
	STA SQ2_VOL
	LDY zPulse2Index
	INC zPulse2Index
	LDA SoundEffectPointers, Y

ProcessSoundEffectQueue1_Note:
	CMP #$7E
	BEQ ProcessSoundEffectQueue1_Exit

	JSR PlaySquare2Note

ProcessSoundEffectQueue1_Exit:
	LDA #$7F
	STA SQ2_SWEEP
	RTS


;
; Sound effect data
;
.include "src/music/sound-effect-data.asm"

;
; Noise Channel SFX Queue
;
ProcessSoundEffectQueue3:
	LDA iNoiseSFX
	BEQ ProcessSoundEffectQueue3_None

	; iNoiseSFX is non-zero
	LDX iCurrentNoiseSFX
	BEQ ProcessSoundEffectQueue3_Part2

ProcessSoundEffectQueue3_None:
	LDA iCurrentNoiseSFX
	BNE ProcessSoundEffectQueue3_Part3
	RTS

ProcessSoundEffectQueue3_Part2:
	; start a new sound effect
	STA iCurrentNoiseSFX
	LDY #$00
	STY zNoiseSFXOffset
	LSR A ; start looking now
	BCS ProcessSoundEffectQueue3_SkipPointerLoop

; from here, loop until C is tripped, skipped if it already was
ProcessSoundEffectQueue3_PointerLoop:
	INY
	INY
	LSR A
	BCC ProcessSoundEffectQueue3_PointerLoop

ProcessSoundEffectQueue3_SkipPointerLoop:
	; load pointer for us to access
	LDA NoiseSFXPointers, Y
	STA zNoiseIndexPointer
	LDA NoiseSFXPointers + 1, Y
	STA zNoiseIndexPointer + 1

ProcessSoundEffectQueue3_Part3:
	; load offset and increment it
	LDY zNoiseSFXOffset
	INC zNoiseSFXOffset
	; examine data
	LDA (zNoiseIndexPointer), Y
	; 00 = ret
	BEQ ProcessSoundEffectQueue3_Done
	; 7e = rest
	CMP #$7e
	BEQ ProcessSoundEffectQueue3_Exit
	; 10-7f = patch
	AND #$70
	BNE ProcessSoundEffectQueue3_Patch
	; 00-0f / 80-8f = note
	BEQ ProcessSoundEffectQueue3_Note

ProcessSoundEffectQueue3_Done:
	; if it was $00, we're at the end of the data for this sound effect
	LDX #$90
	STX NOISE_VOL
	LDX #$18
	STX NOISE_HI
	LDX #$00
	STX NOISE_LO
	STX iCurrentNoiseSFX
	RTS

ProcessSoundEffectQueue3_Patch:
	; apply patch
	LDA (zNoiseIndexPointer), Y
	STA NOISE_VOL
	LDY zNoiseSFXOffset
	INC zNoiseSFXOffset

ProcessSoundEffectQueue3_Note:
	; apply note
	LDA (zNoiseIndexPointer), Y
	STA NOISE_LO
	LDA #$08
	STA NOISE_HI

ProcessSoundEffectQueue3_Exit:
	RTS

.include "src/music/noise-sfx-pointers.asm"
.include "src/music/sound-effects/whale.asm"
.include "src/music/sound-effects/pow-door.asm"
.include "src/music/sound-effects/hawk-noise.asm"
.include "src/music/sound-effects/rocket.asm"

NoiseSFX_None:
	.db $00

ProcessDPCMQueue_BossPriority:
	LDA iCurrentDPCMSFX
	BNE ProcessDPCMQueue_DecTimer
	LDA iDPCMSFX
	JMP ProcessDPCMQueue_Part2

ProcessDPCMQueue:
	LDA iDPCMBossPriority
	BNE ProcessDPCMQueue_BossPriority

	LDA iDPCMSFX
	BNE ProcessDPCMQueue_Part2

	LDA iCurrentDPCMSFX
	BEQ ProcessDPCMQueue_None

ProcessDPCMQueue_DecTimer:
	DEC iDPCMTimer
	BNE ProcessDPCMQueue_Exit

ProcessDPCMQueue_None:
	LDA #$00
	STA iCurrentDPCMSFX
	STA iDPCMBossPriority
	LDA #%00001111
	STA SND_CHN

ProcessDPCMQueue_Exit:
	RTS

ProcessDPCMQueue_Part2:
	STA iCurrentDPCMSFX
	LDY #$00

ProcessDPCMQueue_PointerLoop:
	INY
	LSR A
	BCC ProcessDPCMQueue_PointerLoop

	LDA DMCFreqTable - 1, Y
	STA DMC_FREQ

	LDA DMCStartTable - 1, Y
	STA DMC_START
	LDA DMCLengthTable - 1, Y
	STA DMC_LEN
	LDA #$A0
	STA iDPCMTimer
	LDA #%00001111
	STA SND_CHN
	LDA #%00011111
	STA SND_CHN
	RTS


DMCStartTable:
	.db $68 ; $da00
	.db $5b ; $d6c0
	.db $57 ; $d5c0
	.db $4a ; $d280
	.db $30 ; $cc00
	.db $25 ; $c940
	.db $18 ; $c600
	.db $00 ; $c000

DMCLengthTable:
	.db $81 ; door -> throw
	.db $34 ; bongo short -> egg
	.db $0d ; injury
	.db $34 ; hold
	.db $67 ; boss death
	.db $2b ; bongo -> select
	.db $34 ; boss hit / shell disappear
	.db $5f ; player death -> impact

DMCFreqTable:
	.db $0F
	.db $0F
	.db $0F
	.db $0F
	.db $0F
	.db $0F
	.db $0F
	.db $0F

ProcessMusicQueue_SpecialSong:
	STA iCurrentMusic2
	LDY #$00
	STY iCurrentMusic1
	LDY #$08 ; index of ending music pointer
	RTS

ProcessMusicQueue_ThenReadNoteData:
	JMP ProcessMusicQueue_ReadNoteData

ProcessMusicQueue_StopMusic:
	JMP StopMusic

ProcessMusicQueue:
	LDA iMusic2
	BMI ProcessMusicQueue_StopMusic

	CMP #Music2_EndingAndCast
	BEQ ProcessMusicQueue_EndingAndCast

	CMP #Music2_SubconsFreed
	BEQ ProcessMusicQueue_Subcons

	LDA iMusic2
	BNE ProcessMusicQueue_Part2

	LDA iMusic1
	BNE ProcessMusicQueue_MusicQueue1

	LDA iCurrentMusic2
	ORA iCurrentMusic1
	BNE ProcessMusicQueue_ThenReadNoteData
	RTS

ProcessMusicQueue_Subcons:
	JSR ProcessMusicQueue_SpecialSong
	INY
	BNE ProcessMusicQueue_ReadFirstPointer

ProcessMusicQueue_EndingAndCast:
	JSR ProcessMusicQueue_SpecialSong
	BNE ProcessMusicQueue_ReadFirstPointer

ProcessMusicQueue_MusicQueue1:
	STA iCurrentMusic1
	LDY #$00
	STY iCurrentMusic2
	LDY #$FF

ProcessMusicQueue_FirstPointerLoop:
	INY
	LSR A
	BCC ProcessMusicQueue_FirstPointerLoop

ProcessMusicQueue_ReadFirstPointer:
	LDA MusicPointersFirstPart, Y
	STA iMusicStartPoint
	LDA MusicPointersEndPart, Y
	CLC
	ADC #$02
	STA iMusicEndPoint
	LDA MusicPointersLoopPart, Y
	STA iMusicLoopPoint
	LDA iMusicStartPoint

ProcessMusicQueue_SetCurrentPart:
	STA iCurrentMusicOffset

ProcessMusicQueue_SetNextPart:
	INC iCurrentMusicOffset
	LDY iCurrentMusicOffset
	CPY iMusicEndPoint
	BNE ProcessMusicQueue_ReadHeader

	LDA iMusicLoopPoint
	BNE ProcessMusicQueue_SetCurrentPart

	JMP StopMusic

ProcessMusicQueue_Part2:
	STA iCurrentMusic2
	LDY iCurrentMusic1
	STY iMusicStack
	LDY #$00
	STY iCurrentMusic1

ProcessMusicQueue_PointerLoop:
	INY
	LSR A
	BCC ProcessMusicQueue_PointerLoop

ProcessMusicQueue_ReadHeader:
	LDA MusicPartPointers - 1, Y
	TAY
	LDA MusicPartPointers, Y
	STA iNoteLengthOffset
	LDA MusicPartPointers + 1, Y
	STA zCurrentMusicPointer
	LDA MusicPartPointers + 2, Y
	STA zCurrentMusicPointer + 1
	LDA MusicPartPointers + 3, Y
	STA iCurrentHillOffset
	LDA MusicPartPointers + 4, Y
	STA iCurrentPulse1Offset
	LDA MusicPartPointers + 5, Y
	STA iCurrentNoiseOffset
	STA iCurrentNoiseStartPoint
	STA iCurrentDPCMOffset
	STA iCurrentDPCMStartPoint

	LDA #$01
	STA iMusicPulse2NoteLength
	STA iMusicPulse1NoteLength
	STA iMusicHillNoteLength
	STA iMusicNoiseNoteLength
	STA iDPCMNoteLengthCounter

	LDA #$00
	STA iCurrentPulse2Offset
	STA iSweep

IFNDEF FIX_MIXER_CODE
	LDA #%00001011
	STA SND_CHN
	LDA #%00001111
	STA SND_CHN
ENDIF

ProcessMusicQueue_ReadNoteData:
	DEC iMusicPulse2NoteLength
	BNE ProcessMusicQueue_Square2SustainNote

	LDY iCurrentPulse2Offset
	INC iCurrentPulse2Offset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_EndOfSegment

	BPL ProcessMusicQueue_Square2Note

	BNE ProcessMusicQueue_Square2Patch

ProcessMusicQueue_EndOfSegment:
	LDA iCurrentMusic1
	BNE ProcessMusicQueue_ThenSetNextPart

	LDA iCurrentMusic2
	CMP #Music2_EndingAndCast
	BEQ ProcessMusicQueue_ThenSetNextPart

	AND #Music1_Overworld | Music1_Inside | Music1_Subspace
	BEQ StopMusic

	LDA iMusicStack
	BNE ProcessMusicQueue_ResumeMusicQueue1

StopMusic:
	LDA #$00
	STA iCurrentMusic2
	STA iCurrentMusic1
	STA SND_CHN
	LDX #%00001111
	STX SND_CHN
	RTS

ProcessMusicQueue_ThenSetNextPart:
	JMP ProcessMusicQueue_SetNextPart

ProcessMusicQueue_ResumeMusicQueue1:
	JMP ProcessMusicQueue_MusicQueue1

ProcessMusicQueue_Square2Patch:
	TAX
	AND #$F0
	STA iPulse2Ins
	TXA
	JSR ProcessMusicQueue_PatchNoteLength

	STA iMusicPulse2NoteStartLength

ProcessMusicQueue_Square2NextOffset:
	LDY iCurrentPulse2Offset
	INC iCurrentPulse2Offset
	LDA (zCurrentMusicPointer), Y

ProcessMusicQueue_Square2Note:
	LDX iCurrentPulse2SFX
	BNE ProcessMusicQueue_Square2ContinueNote

	JSR PlaySquare2Note

	TAY
	BNE ProcessMusicQueue_Square2StartNote

	LDA zPulseInsSize
	JMP ProcessMusicQueue_Square2UpdateNoteOffset

ProcessMusicQueue_Square2StartNote:
	LDA iMusicPulse2NoteStartLength
	; seems like the next line should be LDX zPulseEnv based on the equivalent code for square 1?
	LDX zPulseInsSize ; always overridden in the following subroutine...?
	JSR SetInstrumentStartOffset

ProcessMusicQueue_Square2UpdateNoteOffset:
	STA iMusicPulse2InstrumentOffset

	JSR SetSquare2VolumeAndSweep

ProcessMusicQueue_Square2ContinueNote:
	LDA iMusicPulse2NoteStartLength
	STA iMusicPulse2NoteLength

ProcessMusicQueue_Square2SustainNote:
	LDX iCurrentPulse2SFX
	BNE ProcessMusicQueue_Square1

ProcessMusicQueue_LoadSquare2InstrumentOffset:
	LDY iMusicPulse2InstrumentOffset
	BEQ ProcessMusicQueue_LoadSquare2Instrument

	DEC iMusicPulse2InstrumentOffset

ProcessMusicQueue_LoadSquare2Instrument:
	LDA iMusicPulse2NoteStartLength
	LDX iPulse2Ins
	JSR LoadSquareInstrumentDVE

	STA SQ2_VOL
	LDX #$7F
	STX SQ2_SWEEP

ProcessMusicQueue_Square1:
	DEC iMusicPulse1NoteLength
	BNE ProcessMusicQueue_Square1SustainNote

ProcessMusicQueue_Square1Patch:
	LDY iCurrentPulse1Offset
	INC iCurrentPulse1Offset
	LDA (zCurrentMusicPointer), Y
	BPL ProcessMusicQueue_Square1AfterPatch

	TAX
	AND #$F0
	STA iPulse1Ins
	TXA
	JSR ProcessMusicQueue_PatchNoteLength

	STA iPulse1NoteLength

ProcessMusicQueue_Square1NextOffset:
	LDY iCurrentPulse1Offset
	INC iCurrentPulse1Offset
	LDA (zCurrentMusicPointer), Y

ProcessMusicQueue_Square1AfterPatch:
	TAY
	BNE ProcessMusicQueue_Square1Note

	LDA #$83
	STA SQ1_VOL
	LDA #$94
	STA SQ1_SWEEP
	STA iSweep
	BNE ProcessMusicQueue_Square1Patch

ProcessMusicQueue_Square1Note:
	LDY iCurrentPulse1SFX
	BNE ProcessMusicQueue_Square1ContinueNote

	JSR PlaySquare1Note

	BNE ProcessMusicQueue_Square1StartNote

	LDA zPulseInsSize
	JMP ProcessMusicQueue_Square1UpdateNoteOffset

ProcessMusicQueue_Square1StartNote:
	LDA iPulse1NoteLength
	LDX zPulseEnv ; always overridden in the following subroutine...?
	JSR SetInstrumentStartOffset

ProcessMusicQueue_Square1UpdateNoteOffset:
	STA iMusicPulse1InstrumentOffset

	JSR SetSquare1VolumeAndSweep

ProcessMusicQueue_Square1ContinueNote:
	LDA iPulse1NoteLength
	STA iMusicPulse1NoteLength

ProcessMusicQueue_Square1SustainNote:
	LDA iCurrentPulse1SFX
	BNE ProcessMusicQueue_Triangle

ProcessMusicQueue_LoadSquare1InstrumentOffset:
	LDY iMusicPulse1InstrumentOffset
	BEQ ProcessMusicQueue_Square1AfterDecrementInstrumentOffset

	DEC iMusicPulse1InstrumentOffset

ProcessMusicQueue_Square1AfterDecrementInstrumentOffset:
	LDA iPulse1NoteLength
	LDX iPulse1Ins
	JSR LoadSquareInstrumentDVE

	STA SQ1_VOL
	LDA iSweep
	BNE ProcessMusicQueue_Square1Sweep

	LDA #$7F

ProcessMusicQueue_Square1Sweep:
	STA SQ1_SWEEP

ProcessMusicQueue_Triangle:
	LDA iCurrentHillOffset
	BEQ ProcessMusicQueue_NoiseDPCM

	DEC iMusicHillNoteLength
	BNE ProcessMusicQueue_NoiseDPCM

	LDY iCurrentHillOffset
	INC iCurrentHillOffset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_TriangleSetLength

	BPL ProcessMusicQueue_TriangleNote

	JSR ProcessMusicQueue_PatchNoteLength

	STA iMusicHillNoteStartLength
	LDA #$1F
	STA TRI_LINEAR
	LDY iCurrentHillOffset
	INC iCurrentHillOffset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_TriangleSetLength

ProcessMusicQueue_TriangleNote:
	JSR PlayTriangleNote

	LDX iMusicHillNoteStartLength
	STX iMusicHillNoteLength
	TXA
	CMP #$0A
	BCC ProcessMusicQueue_TriangleNoteShort

	CMP #$1E
	BCS ProcessMusicQueue_TriangleNoteLong

ProcessMusicQueue_TriangleNoteMedium:
	LDA #$24
	BNE ProcessMusicQueue_TriangleSetLength

ProcessMusicQueue_TriangleNoteShort:
	LDA #$18
	BNE ProcessMusicQueue_TriangleSetLength

ProcessMusicQueue_TriangleNoteLong:
	LDA #$6F

ProcessMusicQueue_TriangleSetLength:
	STA TRI_LINEAR

ProcessMusicQueue_NoiseDPCM:
	; skip to DPCM for underground/invincibility music
	LDA iCurrentMusic1
	AND #Music1_Inside | Music1_Invincible
	BNE ProcessMusicQueue_DPCM

ProcessMusicQueue_Noise:
	LDA iCurrentNoiseOffset
	BEQ ProcessMusicQueue_ThenNoiseEnd

	DEC iMusicNoiseNoteLength
	BNE ProcessMusicQueue_ThenNoiseEnd

ProcessMusicQueue_NoiseByte:
	LDY iCurrentNoiseOffset
	INC iCurrentNoiseOffset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_NoiseLoopSegment

	BPL ProcessMusicQueue_NoiseNote

	JSR ProcessMusicQueue_PatchNoteLength

	STA iMusicNoiseNoteStartLength
	LDY iCurrentNoiseOffset
	INC iCurrentNoiseOffset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_NoiseLoopSegment

ProcessMusicQueue_NoiseNote:
	LSR A
	TAY
	LDA NoiseVolTable, Y
	STA NOISE_VOL
	LDA NoiseLoTable, Y
	STA NOISE_LO
	LDA NoiseHiTable, Y
	STA NOISE_HI
	LDA iMusicNoiseNoteStartLength
	STA iMusicNoiseNoteLength

ProcessMusicQueue_ThenNoiseEnd:
	JMP ProcessMusicQueue_NoiseEnd

ProcessMusicQueue_NoiseLoopSegment:
	LDA iCurrentNoiseStartPoint
	STA iCurrentNoiseOffset
	JMP ProcessMusicQueue_NoiseByte

ProcessMusicQueue_NoiseEnd:
	LDA iCurrentMusic1
	AND #Music1_Inside | Music1_Invincible
	BNE ProcessMusicQueue_DPCM
	RTS

ProcessMusicQueue_DPCM:
	LDA iCurrentDPCMOffset
	BEQ ProcessMusicQueue_DPCMEnd

	DEC iDPCMNoteLengthCounter
	BNE ProcessMusicQueue_DPCMEnd

ProcessMusicQueue_DPCMByte:
	LDY iCurrentDPCMOffset
	INC iCurrentDPCMOffset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_DPCMLoopSegment

	BPL ProcessMusicQueue_DPCMNote

	JSR ProcessMusicQueue_PatchNoteLength

	STA iDPCMNoteLength
	LDY iCurrentDPCMOffset
	INC iCurrentDPCMOffset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_DPCMLoopSegment

ProcessMusicQueue_DPCMNote:
	; POI: This left shift precludes using the first DPCM sample (bomb explosion) in the DPCM track.
	; This could be to allow $80 for a "rest" note on the DPCM track, but none of the in-game music
	; takes advantage of that.
	ASL A
	STA iDPCMSFX
	JSR ProcessDPCMQueue

	LDA iDPCMNoteLength
	STA iDPCMNoteLengthCounter

ProcessMusicQueue_DPCMEnd:
	RTS

ProcessMusicQueue_DPCMLoopSegment:
	LDA iCurrentDPCMStartPoint
	STA iCurrentDPCMOffset
	JMP ProcessMusicQueue_DPCMByte


NoiseVolTable:
	.db $10
	.db $1E
	.db $1F
	.db $16

NoiseLoTable:
	.db $00
	.db $03
	.db $0A
	.db $02

NoiseHiTable:
	.db $00
	.db $18
	.db $18
	.db $58


; Input
;   A = full patch byte
; Output
;   A = new note length
ProcessMusicQueue_PatchNoteLength:
	AND #$0F
	CLC
	ADC iNoteLengthOffset
	TAY
	LDA NoteLengthTable, Y
	RTS

; Input
;   A = note start length, >= $13 for table A, < $13 for instrument table B
; Ouput
;   A = starting instrument offset ($16 for short, $3F for long)
;   X = duty/volume/envelope ($82)
;   Y = sweep ($7F)
;
SetInstrumentStartOffset:
	CMP #$13
	BCC SetInstrumentStartOffset_Short
	LDA #$3F
	BNE SetInstrumentStartOffset_Exit
SetInstrumentStartOffset_Short:
	LDA #$16
SetInstrumentStartOffset_Exit:
	LDX #$82
	LDY #$7F
	RTS

;
; Loads instrument data for a square channel
;
; Each instrument has two lookup tables based on the note length.
;
; Input
;   A = note length, >= $13 for table A, < $13 for instrument table B
;   X = instrument patch
;   Y = instrument offset
; Output
;   A = duty/volume/envelope
;
LoadSquareInstrumentDVE:
	CPX #$90
	BEQ LoadSquareInstrumentDVE_90_E0

	CPX #$E0
	BEQ LoadSquareInstrumentDVE_90_E0

	CPX #$A0
	BEQ LoadSquareInstrumentDVE_A0

	CPX #$B0
	BEQ LoadSquareInstrumentDVE_B0

	CPX #$C0
	BEQ LoadSquareInstrumentDVE_C0

	CPX #$D0
	BEQ LoadSquareInstrumentDVE_D0

	CPX #$F0
	BEQ LoadSquareInstrumentDVE_F0

LoadSquareInstrumentDVE_80:
	CMP #$13
	BCC LoadSquareInstrumentDVE_80_Short
	LDA InstrumentDVE_80, Y
	BNE LoadSquareInstrumentDVE_80_Exit
LoadSquareInstrumentDVE_80_Short:
	LDA InstrumentDVE_80_Short, Y
LoadSquareInstrumentDVE_80_Exit:
	RTS

LoadSquareInstrumentDVE_90_E0:
	CMP #$13
	BCC LoadSquareInstrumentDVE_90_E0_Short
	LDA InstrumentDVE_90_E0, Y
	BNE LoadSquareInstrumentDVE_90_E0_Exit
LoadSquareInstrumentDVE_90_E0_Short:
	LDA InstrumentDVE_90_E0_Short, Y
LoadSquareInstrumentDVE_90_E0_Exit:
	RTS

LoadSquareInstrumentDVE_A0:
	CMP #$13
	BCC LoadSquareInstrumentDVE_A0_Short
	LDA InstrumentDVE_A0, Y
	BNE LoadSquareInstrumentDVE_A0_Exit
LoadSquareInstrumentDVE_A0_Short:
	LDA InstrumentDVE_A0_Short, Y
LoadSquareInstrumentDVE_A0_Exit:
	RTS

LoadSquareInstrumentDVE_B0:
	CMP #$13
	BCC LoadSquareInstrumentDVE_B0_Short
	LDA InstrumentDVE_B0, Y
	BNE LoadSquareInstrumentDVE_B0_Exit
LoadSquareInstrumentDVE_B0_Short:
	LDA InstrumentDVE_B0_Short, Y
LoadSquareInstrumentDVE_B0_Exit:
	RTS

LoadSquareInstrumentDVE_C0:
	CMP #$13
	BCC LoadSquareInstrumentDVE_C0_Short
	LDA InstrumentDVE_C0, Y
	BNE LoadSquareInstrumentDVE_C0_Exit
LoadSquareInstrumentDVE_C0_Short:
	LDA InstrumentDVE_C0_Short, Y
LoadSquareInstrumentDVE_C0_Exit:
	RTS

LoadSquareInstrumentDVE_F0:
	CMP #$13
	BCC LoadSquareInstrumentDVE_F0_Short
	LDA InstrumentDVE_F0, Y
	BNE LoadSquareInstrumentDVE_F0_Exit
LoadSquareInstrumentDVE_F0_Short:
	LDA InstrumentDVE_F0_Short, Y
LoadSquareInstrumentDVE_F0_Exit:
	RTS

LoadSquareInstrumentDVE_D0:
	CMP #$13
	BCC LoadSquareInstrumentDVE_D0_Short
	LDA InstrumentDVE_D0, Y
	BNE LoadSquareInstrumentDVE_D0_Exit
LoadSquareInstrumentDVE_D0_Short:
	LDA InstrumentDVE_D0_Short, Y
LoadSquareInstrumentDVE_D0_Exit:
	RTS


; Sets volume/sweep on Square 1 channel
;
; Input
;   X = duty/volume/envelope
;   Y = sweep
SetSquare1VolumeAndSweep:
	STY SQ1_SWEEP
	STX SQ1_VOL
	RTS

; Sets volume/sweep on Square 2 channel
;
; Input
;   X = duty/volume/envelope
;   Y = sweep
SetSquare2VolumeAndSweep:
	STX SQ2_VOL
	STY SQ2_SWEEP
	RTS

; Sets volume/sweep on Square 1 channel and plays a note
;
; Input
;   A = note
;   X = duty/volume/envelope
;   Y = sweep
PlaySquare1Sweep:
	STX SQ1_VOL
	STY SQ1_SWEEP

; Play a note on the Square 1 channel
;
; Input
;   A = note
PlaySquare1Note:
	LDX #$00

; Plays a note
;
; Input
;   A = note
;   X = channel
;       $00: square 1
;       $04: square 2
;       $08: triangle
;       $0C: noise
; Output
;   A = $00 for rest, hi frequency otherwise
PlayNote:
	CMP #$7E
	BNE PlayNote_NotRest

	LDA #$10
	STA SQ1_VOL, X
	LDA #$00
	RTS

PlayNote_NotRest:
	LDY #$01
	STY iOctave
	PHA
	TAY
	BMI PlayNote_LoadFrequencyData

PlayNote_IncrementOctave:
	INC iOctave
	SEC
	SBC #$18
	BPL PlayNote_IncrementOctave

PlayNote_LoadFrequencyData:
	CLC
	ADC #$18
	TAY
	LDA NoteFrequencyData, Y
	STA zNextNoteLo
	LDA NoteFrequencyData + 1, Y
	STA zNextNoteHi

PlayNote_FrequencyOctaveLoop:
	LSR zNextNoteHi
	ROR zNextNoteLo
	DEC iOctave
	BNE PlayNote_FrequencyOctaveLoop

	PLA
	CMP #$38
	BCC PlayNote_CheckSquareChorus

	; tweak the frequency for notes >= $38
	DEC zNextNoteLo

;
; Square 2 plays slightly detuned when Square 1 is using instrument E0
;
; This can be used to achieve a honky tonk piano effect, which is used for the
; title screen as well as the bridge of the overworld theme.
;
PlayNote_CheckSquareChorus:
	TXA
	CMP #APUOffset_Square2
	BNE PlayNote_SetFrequency

	LDA iPulse1Ins
	CMP #$E0
	BEQ PlayNote_SetFrequency_Square2Detuned

PlayNote_SetFrequency:
	LDA zNextNoteLo
	STA SQ1_LO, X
	STA iPulse1Lo, X ; unused
	LDA zNextNoteHi
	ORA #$08
	STA SQ1_HI, X
	RTS

PlayNote_SetFrequency_Square2Detuned:
	LDA zNextNoteLo
	SEC
	SBC #$02
	STA SQ2_LO
	STA zPulse2RawPitch
	LDA zNextNoteHi
	ORA #$08
	STA SQ2_HI
	RTS

; (not referenced)
; Sets volume/sweep on Square 2 channel and plays a note
;
; Input
;   A = note
;   X = duty/volume/envelope
;   Y = sweep
PlaySquare2Sweep:
	STX SQ2_VOL
	STY SQ2_SWEEP

; Play a note on the Square 2 channel
;
; Input
;   A = note
PlaySquare2Note:
	LDX #APUOffset_Square2
	BNE PlayNote

; Play a note on the Triangle channel
;
; Input
;   A = note
PlayTriangleNote:
	LDX #APUOffset_Triangle
	BNE PlayNote


;
; -------------------------------------------------------------------------
; Various bits of the music engine have been extracted into separate files;
; see the individual files for details on the formats within
;

; Frequency table for notes; standard between various Mario games
.include "src/music/frequency-table.asm";

; Note lengths for various BPM settings
.include "src/music/note-lengths.asm";

; Pointers to music segments
.include "src/music/music-part-pointers.asm"

; Headers for songs (BPM, tracks to use, etc)
.include "src/music/music-headers.asm"

; More music pointers
.include "src/music/music-pointers.asm"

; Music and track data
.include "src/music/music-data.asm"

; Instrument data and definitions
.include "src/music/ldp-instruments.asm"
