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

CheckMixer:
	LDA SND_CHN
	AND #%11110011
	BNE ProcessMusicAndSfxQueues
	LDA #%00001111
	STA SND_CHN

ProcessMusicAndSfxQueues:
	JSR ProcessSoundEffectQueue2

	JSR ProcessSoundEffectQueue3

	JSR ProcessDPCMQueue1

ProcessOnlyMusicQueue2:
	JSR ProcessMusicQueue

	; Reset queues
	LDA #$00
	STA iPulse1SFX
	STA iMusic2
	STA iDPCMSFX1
	STA iDPCMSFX2
	STA iMusic1
	STA iNoiseSFX
	RTS


ProcessSoundEffectQueue2_Jump:
	LDA #$42
	LDX #$82
	LDY #$A8
	JSR PlaySquare2Sweep

	LDA #$22
	STA zPulse1Timer

ProcessSoundEffectQueue2_JumpPart2:
	LDA zPulse1Timer
	CMP #$20
	BNE ProcessSoundEffectQueue2_JumpPart3

	LDX #$DF
	LDY #$F6
	BNE ProcessSoundEffectQueue2_SetSquare2ThenDecrementTimer

ProcessSoundEffectQueue2_JumpPart3:
	CMP #$1A
	BNE ProcessSoundEffectQueue2_ThenDecrementTimer

	LDX #$C1
	LDY #$BC

ProcessSoundEffectQueue2_SetSquare2ThenDecrementTimer:
	JSR SetSquare2VolumeAndSweep

	BNE ProcessSoundEffectQueue2_ThenDecrementTimer

ProcessSoundEffectQueue2_CoinGet:
	LDA #$35
	LDX #$8D
	STA zPulse1Timer

	LDY #$7F
	LDA #$5E
	JSR PlaySquare2Sweep

ProcessSoundEffectQueue2_CoinGetPart2:
	LDA zPulse1Timer
	CMP #$30
	BNE ProcessSoundEffectQueue2_ThenDecrementTimer

	LDA #$54
	STA SQ2_LO

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
	JSR PlaySquare2Sweep

ProcessSoundEffectQueue2_DecrementTimer:
	DEC zPulse1Timer
	BNE ProcessSoundEffectQueue2_Exit

	LDX #$10
	STA SQ2_VOL
	LDX #$00
	STX SQ2_LO
	STX SQ2_HI
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
	JSR PlaySquare2Sweep

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
	JSR PlaySquare2Sweep

	JMP ProcessSoundEffectQueue2_DecrementTimer

MushroomSoundData:
	.db $6A, $74, $6A, $64, $5C, $52, $5C, $52, $4C, $44, $66, $70, $66, $60, $58, $4E
	.db $58, $4E, $48, $40, $56, $60, $56, $50, $48, $3E, $48, $3E, $38, $30 ; $10


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

ProcessDPCMQueue1:
	LDA iDPCMSFX2
	BNE ProcessDPCMQueue2_Part2

	LDA iDPCMSFX1
	BNE ProcessDPCMQueue1_Part2

	LDA iCurrentDPCMSFX2
	BNE ProcessDPCMQueue2_SoundCheck

	LDA iCurrentDPCMSFX1
	BNE ProcessDPCMQueue1_SoundCheck
	LDA iCurrentDPCMOffset
	BEQ ProcessDPCMQueue1_None
	RTS

ProcessDPCMQueue2_SoundCheck:
ProcessDPCMQueue1_SoundCheck:
	LDA SND_CHN
	AND #$10
	BNE ProcessDPCMQueue1_Exit

ProcessDPCMQueue1_None:
	LDA #$00
	STA iCurrentDPCMSFX1
	STA iCurrentDPCMSFX2
	STA iDPCMBossPriority
	LDA #%00001111
	STA SND_CHN

ProcessDPCMQueue1_Exit:
	RTS

ProcessDPCMQueue1_Part2:
	LDY iDPCMBossPriority
	BNE ProcessDPCMQueue2_SoundCheck

	STA iCurrentDPCMSFX1
	LDY #$00

ProcessDPCMQueue1_PointerLoop:
	INY
	LSR A
	BCC ProcessDPCMQueue1_PointerLoop

	LDA DMCBankTable - 1, Y
IFNDEF NSF_FILE
	IF INES_MAPPER = MAPPER_MMC5
		ORA #$80
		STA MMC5_PRGBankSwitch4
	ENDIF
ELSE
	SBC #$16
	JSR SwitchDPCMBank
ENDIF

	LDA DMCFreqTable - 1, Y
	STA DMC_FREQ

	LDA DMCStartTable - 1, Y
	STA DMC_START
	LDA DMCLengthTable - 1, Y
	STA DMC_LEN
	LDA #%00001111
	STA SND_CHN
	LDA #%00011111
	STA SND_CHN
	RTS

ProcessDPCMQueue2_Part2:
	LDY iDPCMBossPriority
	BEQ ProcessDPCMQueue2_Part3

	CMP iDPCMBossPriority
	BEQ ProcessDPCMQueue2_Part3
	JMP ProcessDPCMQueue2_SoundCheck

ProcessDPCMQueue2_Part3:
	STA iCurrentDPCMSFX2
	LDY #$00

ProcessDPCMQueue2_PointerLoop:
	INY
	LSR A
	BCC ProcessDPCMQueue2_PointerLoop

	LDA DMCBankTable2 - 1, Y
IFNDEF NSF_FILE
	IF INES_MAPPER = MAPPER_MMC5
		ORA #$80
		STA MMC5_PRGBankSwitch4
	ENDIF
ELSE
	SBC #$16
	JSR SwitchDPCMBank
ENDIF

	LDA DMCFreqTable2 - 1, Y
	STA DMC_FREQ

	LDA DMCStartTable2 - 1, Y
	STA DMC_START
	LDA DMCLengthTable2 - 1, Y
	STA DMC_LEN
	LDA #%00001111
	STA SND_CHN
	LDA #%00011111
	STA SND_CHN
	RTS

.include "src/music/dpcm-queue-2.asm"

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
	; start by checking for no music
	LDA iMusic2
	BMI ProcessMusicQueue_StopMusic

	; check for looping songs in iMusic2
	CMP #Music2_EndingAndCast
	BEQ ProcessMusicQueue_EndingAndCast

	CMP #Music2_SubconsFreed
	BEQ ProcessMusicQueue_Subcons

	; if iMusic2 != 0, branch
	LDA iMusic2
	BNE ProcessMusicQueue_Part2

	; if iMusic1 != 0, branch
	LDA iMusic1
	BNE ProcessMusicQueue_MusicQueue1

	; if any music is playing, read note data
	; else return
	LDA iCurrentMusic2
	ORA iCurrentMusic1
	BNE ProcessMusicQueue_ThenReadNoteData
	RTS

ProcessMusicQueue_Subcons:
	; subcons theme ($40) is queued up, so initialize & read pointer
	JSR ProcessMusicQueue_SpecialSong
	INY
	BNE ProcessMusicQueue_ReadFirstPointer

ProcessMusicQueue_EndingAndCast:
	; credits ($04) is queued up, so initialize & read pointer
	JSR ProcessMusicQueue_SpecialSong
	BNE ProcessMusicQueue_ReadFirstPointer

ProcessMusicQueue_MusicQueue1:
	; iMusic1 != 0, initialize
	STA iCurrentMusic1
	LDY #$00
	STY iCurrentMusic2
	LDY #$FF

ProcessMusicQueue_FirstPointerLoop:
	; iMusic1 -> Y = bit no. 0-7
	INY
	LSR A
	BCC ProcessMusicQueue_FirstPointerLoop

ProcessMusicQueue_ReadFirstPointer:
	; store the ammount of channels
	LDA MusicChannelStack, Y
	STA iMusicChannelCount
	; starting point
	LDA MusicPointersFirstPart, Y
	STA iMusicStartPoint
	; ending point
	LDA MusicPointersEndPart, Y
	CLC
	ADC #$02
	STA iMusicEndPoint
	; loop point
	LDA MusicPointersLoopPart, Y
	STA iMusicLoopPoint
	; store the beginning offset
	LDA iMusicStartPoint

ProcessMusicQueue_SetCurrentPart:
	STA iCurrentMusicOffset

ProcessMusicQueue_SetNextPart:
	; Y = music offset + 1, check if we reached the end
	INC iCurrentMusicOffset
	LDY iCurrentMusicOffset
	CPY iMusicEndPoint
	BNE ProcessMusicQueue_ReadHeader

	; reset offset to loop point if we reached the end
	LDA iMusicLoopPoint
	BNE ProcessMusicQueue_SetCurrentPart

	; we're here if there's no loop, stop the music
	JMP StopMusic

ProcessMusicQueue_Part2:
	; iMusic2 != 0, back iCurrentMusic1 up, initialize
	STA iCurrentMusic2
	LDY iCurrentMusic1
	STY iMusicStack
	LDY #$00
	STY iCurrentMusic1

ProcessMusicQueue_PointerLoop:
	; iMusic2 -> Y = bit no. 0-7
	INY
	LSR A
	BCC ProcessMusicQueue_PointerLoop

	; store the ammount of channels
	LDA MusicChannelStack + 9, Y
	STA iMusicChannelCount

ProcessMusicQueue_ReadHeader:
	; nab offset, X = channel ammount 3-5
	LDX iMusicChannelCount
	LDA MusicPartPointers - 1, Y
	TAY
	; header data
	; byte 1 - note length
	LDA MusicPartPointers, Y
	STA iNoteLengthOffset
	; byte 2-3 - music pointer, pulse 2
	LDA MusicPartPointers + 1, Y
	STA zCurrentMusicPointer
	LDA MusicPartPointers + 2, Y
	STA zCurrentMusicPointer + 1
	DEX
	; byte 4 - hill offset
	LDA MusicPartPointers + 3, Y
	STA iCurrentHillOffset
	DEX
	; byte 5 - pulse 1 offset
	LDA MusicPartPointers + 4, Y
	STA iCurrentPulse1Offset
	DEX
	BNE ProcessMusicQueue_ReadHeaderNoise

	; no noise or DPCM
	LDA #0
	STA iCurrentNoiseOffset
	STA iCurrentNoiseStartPoint
	STA iCurrentDPCMOffset
	STA iCurrentDPCMStartPoint
	BEQ ProcessMusicQueue_DefaultNotelength

ProcessMusicQueue_ReadHeaderNoise:
	; byte 6 - noise offset
	LDA MusicPartPointers + 5, Y
	STA iCurrentNoiseOffset
	STA iCurrentNoiseStartPoint
	DEX
	BNE ProcessMusicQueue_ReadHeaderDPCM

	; no DPCM
	LDA #0
	STA iCurrentDPCMOffset
	STA iCurrentDPCMStartPoint
	BEQ ProcessMusicQueue_DefaultNotelength

ProcessMusicQueue_ReadHeaderDPCM:
	; byte 7 - DPCM
	LDA MusicPartPointers + 6, Y
	STA iCurrentDPCMOffset
	STA iCurrentDPCMStartPoint

ProcessMusicQueue_DefaultNotelength:
	LDA #$01
	STA iMusicPulse2NoteLength
	STA iMusicPulse1NoteLength
	STA iMusicHillNoteLength
	STA iMusicNoiseNoteLength
	STA iDPCMNoteLengthCounter
	STA iDPCMNoteRatioLength

	; initialize pulse 2 offset
	LDA #$00
	STA iCurrentPulse2Offset
	STA iSweep

ProcessMusicQueue_ReadNoteData:
	; check note length
	; if 0, start a new note
	; else, skip to updating
	DEC iMusicPulse2NoteLength
	BEQ ProcessMusicQueue_Square2EndOfNote
	JMP ProcessMusicQueue_Square2SustainNote

ProcessMusicQueue_Square2EndOfNote:
	; new note, read next byte
	LDY iCurrentPulse2Offset
	INC iCurrentPulse2Offset
	LDA (zCurrentMusicPointer), Y
	; 0 = ret
	; + = note
	; - = instrument / note length
	BEQ ProcessMusicQueue_EndOfSegment

	BMI ProcessMusicQueue_Square2Patch
	JMP ProcessMusicQueue_Square2Note

ProcessMusicQueue_EndOfSegment:
; 0 = ret
	; check which song's playing
	; iCurrentMusic1 always loops
	LDA iCurrentMusic1
	BNE ProcessMusicQueue_ThenSetNextPart

	; iCurrentMusic2 typically plays a fanfare
	; but ending and subcon themes are segmented
	LDA iCurrentMusic2
	CMP #Music2_EndingAndCast
	BEQ ProcessMusicQueue_ThenSetNextPart

	CMP #Music2_SubconsFreed
	BEQ ProcessMusicQueue_ThenSetNextPart

	; here's an oddity: there's logic to play iMusicStack when credits and
	; cast theme ends (IT NEVER DOES)
	AND #Music2_MushroomGetJingle | Music2_EndingAndCast | Music2_CrystalGetFanfare
	BEQ StopMusic

	; non-zero after AND, song meets logic, replay last song
	LDA iMusicStack
	BNE ProcessMusicQueue_ResumeMusicQueue1

StopMusic:
; ways to access this routine:
;	iMusicStack = 0, fallthrough
;	iCurrentMusic2 does not meet logic when fanfare ends
;	Reaching the end-offset without a loop
;	iMusic2 is $80
	; check for SFX, skip channels any are playing on
	; DPCM
	LDA iCurrentDPCMSFX1
	BNE LeaveDPCMAlone
	LDA iCurrentDPCMSFX2
	BNE LeaveDPCMAlone
	JSR ProcessMusicQueue_DPCMDisable

LeaveDPCMAlone:
	; Pulse 2
	LDA iCurrentPulse1SFX
	BNE LeavePulseAlone

	LDA #$10
	STA SQ2_VOL
	LDA #$00
	STA SQ2_HI
	STA SQ2_LO
	STA SQ2_SWEEP

LeavePulseAlone:
	; Noise SFX are barely used
	; better just to clear the rest
	LDA #$10
	STA SQ1_VOL
	STA NOISE_VOL
	LDA #$00
	STA iCurrentMusic2
	STA iCurrentMusic1
	STA SQ1_HI
	STA SQ1_LO
	STA SQ1_SWEEP
	STA NOISE_HI
	STA NOISE_LO
	STA TRI_LINEAR
	STA TRI_HI
	STA TRI_LO
	RTS

ProcessMusicQueue_ThenSetNextPart:
; any song able to move their pointer offset
	JMP ProcessMusicQueue_SetNextPart

ProcessMusicQueue_ResumeMusicQueue1:
; iMusicStack != 0
	JMP ProcessMusicQueue_MusicQueue1

ProcessMusicQueue_Square2Patch:
; - = instrument / note length
	; instrument
	TAX
	AND #$F0
	STA iPulse2Ins
	; note length
	TXA
	JSR ProcessMusicQueue_PatchNoteLength

	STA iMusicPulse2NoteStartLength

	; next byte, allows higher notes
	LDY iCurrentPulse2Offset
	INC iCurrentPulse2Offset
	LDA (zCurrentMusicPointer), Y

ProcessMusicQueue_Square2Note:
; + = note
	; check if sound effects are playing
	LDX iCurrentPulse1SFX
	BNE ProcessMusicQueue_Square2ContinueNote

	; We're clear! Play the note!
	JSR PlaySquare2Note
	TAY
	BEQ ProcessMusicQueue_Square2UpdateNoteOffset
	LDA iMusicPulse2NoteStartLength
	JSR SetInstrumentStartOffset

ProcessMusicQueue_Square2UpdateNoteOffset:
	; set instruemnt offset, init sweep/gain
	STA iMusicPulse2InstrumentOffset

	JSR SetSquare2VolumeAndSweep

ProcessMusicQueue_Square2ContinueNote:
	; set note length
	LDA iMusicPulse2NoteStartLength
	STA iMusicPulse2NoteLength

ProcessMusicQueue_Square2SustainNote:
	; note update
	; SFX playing?  If yes, skip to updating Pulse 1
	LDX iCurrentPulse1SFX
	BNE ProcessMusicQueue_Square1

ProcessMusicQueue_LoadSquare2InstrumentOffset:
	; load isntrument offset
	LDY iMusicPulse2InstrumentOffset
	BEQ ProcessMusicQueue_LoadSquare2Instrument

	DEC iMusicPulse2InstrumentOffset

ProcessMusicQueue_LoadSquare2Instrument:
	; load instrument no.
	LDA iMusicPulse2NoteStartLength
	LDX iPulse2Ins
	JSR LoadSquareInstrumentDVE

	; update
	STA SQ2_VOL
	LDX #$7F
	STX SQ2_SWEEP

ProcessMusicQueue_Square1:
; if note length != 0, sustain note
	DEC iMusicPulse1NoteLength
	BNE ProcessMusicQueue_Square1SustainNote

ProcessMusicQueue_Square1Patch:
; else we start here instead
; load byte offset / data
	; 0 - set sweep to $94
	; - - instrument / note length
	; + - note
	LDY iCurrentPulse1Offset
	INC iCurrentPulse1Offset
	LDA (zCurrentMusicPointer), Y
	BPL ProcessMusicQueue_Square1AfterPatch

	; - - instrument / note length
	; instrument
	TAX
	AND #$F0
	STA iPulse1Ins
	; note length
	TXA
	JSR ProcessMusicQueue_PatchNoteLength

	STA iPulse1NoteLength

	; next byte, allows higher notes
	LDY iCurrentPulse1Offset
	INC iCurrentPulse1Offset
	LDA (zCurrentMusicPointer), Y

ProcessMusicQueue_Square1AfterPatch:
; + = note
	TAY
	BNE ProcessMusicQueue_Square1Note

	; 0 - set sweep to $94
	LDA #$83
	STA SQ1_VOL
	LDA #$94
	STA SQ1_SWEEP
	STA iSweep
	BNE ProcessMusicQueue_Square1Patch

ProcessMusicQueue_Square1Note:
	; We're clear! Play the note!
	JSR PlaySquare1Note

	BEQ ProcessMusicQueue_Square1UpdateNoteOffset
	LDA iPulse1NoteLength
	JSR SetInstrumentStartOffset

ProcessMusicQueue_Square1UpdateNoteOffset:
	; set instruemnt offset, init sweep/gain
	STA iMusicPulse1InstrumentOffset
; Sets volume/sweep on Square 1 channel
; Input
;   X = duty/volume/envelope
;   Y = sweep
	STY SQ1_SWEEP
	STX SQ1_VOL
	; set note length
	LDA iPulse1NoteLength
	STA iMusicPulse1NoteLength

ProcessMusicQueue_Square1SustainNote:
	; note update
	; load isntrument offset
	LDY iMusicPulse1InstrumentOffset
	BEQ ProcessMusicQueue_Square1AfterDecrementInstrumentOffset

	DEC iMusicPulse1InstrumentOffset

ProcessMusicQueue_Square1AfterDecrementInstrumentOffset:
	; load instrument no.
	LDA iPulse1NoteLength
	LDX iPulse1Ins
	JSR LoadSquareInstrumentDVE

	; update
	STA SQ1_VOL
	LDA iSweep
	BNE ProcessMusicQueue_Square1Sweep

	LDA #$7F

ProcessMusicQueue_Square1Sweep:
	STA SQ1_SWEEP

ProcessMusicQueue_Triangle:
	; if offset = 0, skip to next channel
	LDA iCurrentHillOffset
	BEQ ProcessMusicQueue_NoiseDPCM

	; if note length doesn't reach 0, skip to next channel
	DEC iMusicHillNoteLength
	BNE ProcessMusicQueue_NoiseDPCM

	; next byte
	; 0 = mute
	; + = note length
	; - = note
	LDY iCurrentHillOffset
	INC iCurrentHillOffset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_TriangleSetLength

	BPL ProcessMusicQueue_TriangleNote

	; + = note length
	JSR ProcessMusicQueue_PatchNoteLength

	STA iMusicHillNoteStartLength
	LDA #$1F
	STA TRI_LINEAR
	; next byte is treated like a note, or mute
	LDY iCurrentHillOffset
	INC iCurrentHillOffset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_TriangleSetLength

ProcessMusicQueue_TriangleNote:
	; - = note
	JSR PlayTriangleNote

	; iMusicHillNoteLength:
	; <10   - $18 - 6
	; 10-23 - $24 - 9
	; >=24  - $6f - 28
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
; vanilla SMB2 used to treat noise and DPCM as the same channel
; this hack lets both play with their own data sets
ProcessMusicQueue_Noise:
	; if offset = 0, skip to next channel
	LDA iCurrentNoiseOffset
	BEQ ProcessMusicQueue_ThenNoiseEnd

	; if note length doesn't reach 0, skip to next channel
	DEC iMusicNoiseNoteLength
	BNE ProcessMusicQueue_ThenNoiseEnd

ProcessMusicQueue_NoiseByte:
; next byte
	; 0 = loop
	; - = note length
	; + = note
	LDY iCurrentNoiseOffset
	INC iCurrentNoiseOffset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_NoiseLoopSegment

	BPL ProcessMusicQueue_NoiseNote

	; - = note length
	JSR ProcessMusicQueue_PatchNoteLength

	STA iMusicNoiseNoteStartLength
	; next byte - later entries allowed
	LDY iCurrentNoiseOffset
	INC iCurrentNoiseOffset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_NoiseLoopSegment

ProcessMusicQueue_NoiseNote:
; + = note
; NOTE - only $02, $04 & $06 are valid
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
	JMP ProcessMusicQueue_DPCM

ProcessMusicQueue_NoiseLoopSegment:
; 0 = loop
	LDA iCurrentNoiseStartPoint
	STA iCurrentNoiseOffset
	JMP ProcessMusicQueue_NoiseByte

ProcessMusicQueue_DPCM:
	; if offset = 0, end
	LDA iCurrentDPCMOffset
	BNE ProcessMusicQueue_DPCMlength
	JMP ProcessMusicQueue_DPCMEnd

ProcessMusicQueue_DPCMlength:
	; if note length reaches 0, read sample music data
	DEC iDPCMNoteLengthCounter
	BEQ ProcessMusicQueue_DPCMByte
	; note cuts off in advance
	LDA iDPCMNoteRatioLength
	BEQ ProcessMusicQueue_DPCMExit
	DEC iDPCMNoteRatioLength
	BNE ProcessMusicQueue_DPCMExit

	; if note length ratio remains non-zero, check for sound effects
	LDA iCurrentDPCMSFX1
	BNE ProcessMusicQueue_DPCMExit
	LDA iCurrentDPCMSFX2
	BNE ProcessMusicQueue_DPCMExit
	; Disable - no sound effects playing
	JMP ProcessMusicQueue_DPCMDisable
ProcessMusicQueue_DPCMExit:
	RTS

ProcessMusicQueue_DPCMByte:
; next byte
	; 0 = loop
	; - = note length
	; + = note
	LDY iCurrentDPCMOffset
	INC iCurrentDPCMOffset
	LDA (zCurrentMusicPointer), Y
	BNE ProcessMusicQueue_DPCMNotLoop
	JMP ProcessMusicQueue_DPCMLoopSegment

ProcessMusicQueue_DPCMNotLoop:
	BPL ProcessMusicQueue_DPCMNote

	; - = note length
	JSR ProcessMusicQueue_PatchNoteLength

	; next byte - later entries allowed
	STA iDPCMNoteLength
	LDY iCurrentDPCMOffset
	INC iCurrentDPCMOffset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_DPCMLoopSegment

ProcessMusicQueue_DPCMNote:
; check for sound effects before playing a note
	LDX #iCurrentDPCMSFX1
	BNE ProcessMusicQueue_DPCMSFXExit
	LDX #iCurrentDPCMSFX2
	BNE ProcessMusicQueue_DPCMSFXExit
	; mute for now
	; initialize X
	LDX #0
	SEC
ProcessMusicQueue_DPCMNoteLoop:
	; find octave in X
	INX
	SBC #(12 << 1)
	BCS ProcessMusicQueue_DPCMNoteLoop
	STX iOctave
	DEX

	; get octave bank
	LDA DPCMOctaves, X
IFNDEF NSF_FILE
	IF INES_MAPPER = MAPPER_MMC5
		ORA #$80
		STA MMC5_PRGBankSwitch4
	ENDIF
ELSE
	SEC
	SBC #$16
	JSR SwitchDPCMBank
ENDIF

	; relead the note for offset
	LDA (zCurrentMusicPointer), Y
	SEC
	SBC #(12 << 1)
	BCC ProcessMusicQueue_DPCMEnd
	LSR A
	TAY
	; pitch
	LDA DMCPitchTable, Y
	ORA #$40
	STA DMC_FREQ
	; address
	LDA DMCSamplePointers, Y
	STA DMC_START
	; length
	LDA DMCSampleLengths, Y
	STA DMC_LEN

	; mixer
	LDX #%00001111
	STX SND_CHN
	LDA #%00011111
	STA SND_CHN

ProcessMusicQueue_DPCMSFXExit:
	LDA iDPCMNoteLength
	STA iDPCMNoteLengthCounter
	LDX #$F0 ; pitch lasts 15 / 16 frames rounded down
	STA MMC5_Multiplier
	STX MMC5_Multiplier + 1
	LDA MMC5_Multiplier + 1
	STA iDPCMNoteRatioLength
	RTS

ProcessMusicQueue_DPCMEnd:
	; check for sound effects before disabling
	LDX #iCurrentDPCMSFX1
	BNE ProcessMusicQueue_DPCMExit
	LDX #iCurrentDPCMSFX2
	BEQ ProcessMusicQueue_DPCMDisable
	JMP ProcessMusicQueue_DPCMExit

ProcessMusicQueue_DPCMDisable:
	; Disable
	LDX #%00001111
	STX SND_CHN
	LDX #0
	STX DMC_FREQ
	STX DMC_START
	STX DMC_LEN
	RTS

ProcessMusicQueue_DPCMLoopSegment:
	; 0 = Loop
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

; DPCM sawtooth configuration data
.include "src/music/dmc-data.asm"

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
	STA zNextPitch
	LDA NoteFrequencyData + 1, Y
	STA zNextPitch + 1

PlayNote_FrequencyOctaveLoop:
	LSR zNextPitch + 1
	ROR zNextPitch
	DEC iOctave
	BNE PlayNote_FrequencyOctaveLoop

	PLA
	CMP #$38
	BCC PlayNote_CheckSquareChorus

	; tweak the frequency for notes >= $38
	DEC zNextPitch

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
	LDA zNextPitch
	STA SQ1_LO, X
	LDA zNextPitch + 1
	ORA #$08
	STA SQ1_HI, X
	RTS

PlayNote_SetFrequency_Square2Detuned:
	LDA zNextPitch
	SEC
	SBC #$02
	STA SQ2_LO
	LDA zNextPitch + 1
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

; Channels active in the music
.include "src/music/music-channel-count.asm"

; Music and track data
.include "src/music/music-data.asm"

; Instrument data and definitions
.include "src/music/ldp-instruments.asm"
