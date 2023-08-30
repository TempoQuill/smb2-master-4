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

	LDA SND_CHN
	CMP #$10
	LDA iPauseTrack
	BCS ApplyPauseChannels

	AND SND_CHN

ApplyPauseChannels:
	STA SND_CHN
	; You would think you could skip processing,
	; since if the game is paused, nothing should
	; be setting new music or whatever.
	;
	; You would be correct, except for the suicide code!
	; That sets iMusic.
	;
	; If not for processing it, the music would not
	; change (or stop) when you used the code. Welp!
	JMP ProcessOnlyMusicQueue2

MusicAndSFXProcessing:

CheckMixer:
	LDA SND_CHN
	EOR #$FF
	AND iPauseTrack
	EOR #$FF
	BNE ProcessMusicAndSfxQueues
	LDA #%00001111
	STA SND_CHN

ProcessMusicAndSfxQueues:
	JSR ProcessSoundEffectQueue2

	JSR ProcessSoundEffectQueue3

	JSR ProcessDPCMQueue

ProcessOnlyMusicQueue2:
	JSR ProcessMusicQueue
	JSR ProcessHillQueue

	; Reset queues
	LDA #$00
	STA iPulse1SFX
	STA iHillSFX
	STA iDPCMSFX
	STA iMusic
	STA iNoiseSFX
	RTS


ProcessSoundEffectQueue2:
	LDA iPulse1SFX
	BNE ProcessSoundEffectQueue2_Part2
	LDA iCurrentPulse1SFX
	BNE ProcessSoundEffectQueue2_Part3
ProcessSoundEffectQueue2_Exit:
	RTS

ProcessSoundEffectQueue2_Part2:
	STA iCurrentPulse1SFX
	LDY #0
	STY zPulse1SFXOffset
	STY iPulse1SFXSweep
	LSR A
	BCS ProcessSoundEffectQueue2_DesignatePointer

ProcessSoundEffectQueue2_PointerLoop:
	INY
	LSR A
	BCC ProcessSoundEffectQueue2_PointerLoop

ProcessSoundEffectQueue2_DesignatePointer:
	LDA Pulse1SFXVolumes, Y
	STA iPulse1SFXVolume
	LDA Pulse1SFXEnvelopes, Y
	STA iPulse1SFXVolume + 1
	LDA Pulse1SFXPointersLo, Y
	STA zPulse1IndexPointer
	LDA Pulse1SFXPointersHi, Y
	STA zPulse1IndexPointer + 1

ProcessSoundEffectQueue2_Part3:
	LDY zPulse1SFXOffset
	LDA (zPulse1IndexPointer), Y
	BEQ ProcessSoundEffectQueue2_End
	BPL ProcessSoundEffectQueue2_Note

	INY
	STA iPulse1SFXSweep
	LDA (zPulse1IndexPointer), Y

ProcessSoundEffectQueue2_Note:
	INY
	CMP #$40
	BCS ProcessSoundEffectQueue2_Tie
	CMP #$08
	LDX #$10
	BCC ProcessSoundEffectQueue2_Volume
	LDX iPulse1SFXVolume
ProcessSoundEffectQueue2_Volume:
	STX SQ2_VOL
	TAX
	LDA (zPulse1IndexPointer), Y
	INY
	STA SQ2_LO
	STX SQ2_HI
	LDA SND_CHN
	ORA #$02
	STA SND_CHN
	CPX #$08
	BCC ProcessSoundEffectQueue2_Tie
	LDA iPulse1SFXSweep
	STA SQ2_SWEEP
	LDA iPulse1SFXVolume + 1
	STA SQ2_VOL
ProcessSoundEffectQueue2_Tie:
	STY zPulse1SFXOffset
	RTS

ProcessSoundEffectQueue2_End:
	STA iCurrentPulse1SFX
	STA iPulse1SFXSweep
	STA zPulse1IndexPointer
	STA zPulse1IndexPointer + 1
	STA zPulse1SFXOffset
	LDA #$10
	STX SQ2_VOL
	LDA #0
	STA SQ2_LO
	STA SQ2_HI
	STA SQ2_SWEEP
	RTS

Pulse1SFXPointersLo:
	.db <Pulse1SFXData_StopSlot
	.db <Pulse1SFXData_1UP
	.db <Pulse1SFXData_Coin
	.db <Pulse1SFXData_Shrink
	.db <Pulse1SFXData_Injury
	.db <Pulse1SFXData_Watch
	.db <Pulse1SFXData_HawkUp
	.db <Pulse1SFXData_HawkDown

Pulse1SFXPointersHi:
	.db >Pulse1SFXData_StopSlot
	.db >Pulse1SFXData_1UP
	.db >Pulse1SFXData_Coin
	.db >Pulse1SFXData_Shrink
	.db >Pulse1SFXData_Injury
	.db >Pulse1SFXData_Watch
	.db >Pulse1SFXData_HawkUp
	.db >Pulse1SFXData_HawkDown

Pulse1SFXVolumes:
	.db $99, $9F, $9F, $1F, $1F, $9F, $1F, $1F

Pulse1SFXEnvelopes:
	.db $87, $81, $84, $00, $00, $82, $00, $00

.include "src/music/sound-effects/pulse-1-sfx-data.asm"

ProcessHillQueue:
	LDA iHillSFX
	BNE ProcessHillQueue_Part2
	LDA iCurrentHillSFX
	BNE ProcessHillQueue_Part3
	RTS

ProcessHillQueue_Part2:
	STA iCurrentHillSFX
	LDY #0
	STY iHillSFXOffset
	LSR A
	BCS ProcessHillQueue_DesignatePointer

ProcessHillQueue_PointerLoop:
	INY
	LSR A
	BCC ProcessHillQueue_PointerLoop

ProcessHillQueue_DesignatePointer:
	LDA HillSFXPointersLo, Y
	STA zHillIndexPointer
	LDA HillSFXPointersHi, Y
	STA zHillIndexPointer + 1

ProcessHillQueue_Part3:
	LDY iHillSFXOffset
	LDA (zHillIndexPointer), Y
	BEQ ProcessHillQueue_Done
	INY
	TAX
	CPX #8
	LDA #0
	BCC ProcessHillQueue_Linear:
	LDA #$81
ProcessHillQueue_Linear:
	STA TRI_LINEAR
	LDA (zHillIndexPointer), Y
	INY
	STA TRI_LO
	STX TRI_HI
	STY iHillSFXOffset
	RTS

ProcessHillQueue_Done:
	STA iHillSFXOffset
	STA zHillIndexPointer
	STA zHillIndexPointer + 1
	STA iCurrentHillSFX
	STA TRI_LINEAR
	STA TRI_LO
	STA TRI_HI
	RTS

HillSFXPointersLo:
	.db <HillSFXData_Jump
	.db <HillSFXData_Vine
	.db <HillSFXData_Cherry
	.db <HillSFXData_Throw
	.db <HillSFXData_Fall
	.db <HillSFXData_Mushroom
	.db <HillSFXData_LampBossDeath
	.db <HillSFXData_Select

HillSFXPointersHi:
	.db >HillSFXData_Jump
	.db >HillSFXData_Vine
	.db >HillSFXData_Cherry
	.db >HillSFXData_Throw
	.db >HillSFXData_Fall
	.db >HillSFXData_Mushroom
	.db >HillSFXData_LampBossDeath
	.db >HillSFXData_Select

.include "src/music/sound-effects/hill-sfx-data.asm"

;
; Noise Channel SFX Queue
;
ProcessSoundEffectQueue3:
	LDA iNoiseSFX
	BEQ ProcessSoundEffectQueue3_None

	LDX #0
	STX zNoiseSFXOffset
	BEQ ProcessSoundEffectQueue3_Part2

ProcessSoundEffectQueue3_None:
	LDX iCurrentNoiseSFX
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
	LSR A
	BCC ProcessSoundEffectQueue3_PointerLoop

ProcessSoundEffectQueue3_SkipPointerLoop:
	; load pointer for us to access
	LDA NoiseSFXPointersLo, Y
	STA zNoiseIndexPointer
	LDA NoiseSFXPointersHi, Y
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
.include "src/music/sound-effects/bomb.asm"
.include "src/music/sound-effects/rocket.asm"
.include "src/music/sound-effects/fireball.asm"
.include "src/music/sound-effects/wart-bubble.asm"
.include "src/music/sound-effects/wart-smoke-puff.asm"

NoiseSFX_None:
	.db $00

ProcessDPCMQueue:
	LDA iDPCMSFX
	BNE ProcessDPCMQueue_Part2

	LDA iCurrentDPCMSFX
	BNE ProcessDPCMQueue_SoundCheck

	LDA iCurrentDPCMOffset
	BEQ ProcessDPCMQueue_None
	RTS

ProcessDPCMQueue_SoundCheck:
	LDA SND_CHN
	AND #$10
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
	LDY iDPCMBossPriority
	BEQ ProcessDPCMQueue_Part3

	CMP iDPCMBossPriority
	BEQ ProcessDPCMQueue_Part3
	JMP ProcessDPCMQueue_SoundCheck

ProcessDPCMQueue_Part3:
	STA iCurrentDPCMSFX
	TAY
	DEY

	LDA DMCBankTable, Y
IFNDEF NSF_FILE
	IF INES_MAPPER = MAPPER_MMC5
		STA MMC5_PRGBankSwitch4
	ENDIF
ELSE
	ASL A
	STA NSFBank4
	ORA #1
	STA NSFBank5
ENDIF

	LDA #$0F
	STA DMC_FREQ

	LDA DMCStartTable, Y
	STA DMC_START
	LDA DMCLengthTable, Y
	STA DMC_LEN
	LDA #%00001111
	STA SND_CHN
	LDA #%00011111
	STA SND_CHN
	RTS

.include "src/music/dpcm-queue-2.asm"

PlayWartDeathSound:
	LDA #0
	STA iMusicPulse2NoteLength
	STA iMusicPulse1NoteLength
	STA iMusicHillNoteLength
	STA iMusicNoiseNoteLength
	STA iDPCMNoteLengthCounter
	STA iDPCMNoteRatioLength
	LDA #PRGBank_DMC_17
IFNDEF NSF_FILE
	IF INES_MAPPER = MAPPER_MMC5
		ORA #$80
		STA MMC5_PRGBankSwitch4
	ENDIF
ELSE
	ASL A
	STA NSFBank4
	ORA #1
	STA NSFBank5
ENDIF
	LDA #$0E
	STA DMC_FREQ
	LDA #0
	STA DMC_START
	LDA #$FC
	STA DMC_LEN
	LDA #$0f
	STA SND_CHN
	LDA #$10
	STA SND_CHN

RunWartDeathSound:
	LDA SND_CHN
	BNE RunWartDeathSound_Running
	STA iCurrentMusic
	LDA #$0f
	STA SND_CHN
RunWartDeathSound_Running:
	RTS

ProcessMusicQueue_WartDeath:
	STA iCurrentMusic
	JMP PlayWartDeathSound

ProcessMusicQueue_ThenReadNoteData:
	JMP ProcessMusicQueue_ReadNoteData

ProcessMusicQueue_StopMusic:
	JMP StopMusic

ProcessMusicQueue:
	; start by checking for no music
	LDY iMusic
	TYA
	INY
	BEQ ProcessMusicQueue_StopMusic

	CMP #Music_WartDeath
	BEQ ProcessMusicQueue_WartDeath

	; if iMusic != 0, branch
	LDA iMusic
	BNE ProcessMusicQueue_MusicQueue1

	; if any music is playing, read note data
	; else return
	LDA iCurrentMusic
	CMP #Music_WartDeath
	BEQ RunWartDeathSound
	AND #$FF
	BNE ProcessMusicQueue_ThenReadNoteData
	RTS

ProcessMusicQueue_MusicQueue1:
	; iMusic != 0, initialize
	LDA iCurrentMusic
	STA iMusicStack
	JSR StopMusic
	LDY iMusic
	STY iCurrentMusic
	LDA MusicStackPermission, Y
	BNE ProcessMusicQueue_ReadFirstPointer

	LDA #Music_StopMusic
	STA iMusicStack

ProcessMusicQueue_ReadFirstPointer:
	DEY
	LDA SongBanks, Y
IFNDEF NSF_FILE
	IF INES_MAPPER = MAPPER_MMC5
		STA iMusicBank
		STA MMC5_PRGBankSwitch3
	ENDIF
ELSE
	JSR SetMusicBank
ENDIF
	; store the amount of channels
	LDA PauseTracks1, Y
	STA iPauseTrack
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

ProcessMusicQueue_ReadHeader:
	; nab offset, X = channel amount 3-5
	LDX iMusicChannelCount
	LDA MusicPartPointers - 1, Y
	TAY
	; header data
	; byte 1 - base note length
	LDA MusicHeaders, Y
	STA iTempo
	; byte 2-3 - music pointer, pulse 2
	LDA MusicHeaders + 1, Y
	STA zCurrentMusicPointer
	STA iMusicPulse2BigPointer + 1
	LDA MusicHeaders + 2, Y
	STA zCurrentMusicPointer + 1
	STA iMusicPulse2BigPointer
	DEX
	; byte 5 - pulse 1 offset
	LDA MusicHeaders + 4, Y
	CLC
	ADC iMusicPulse2BigPointer + 1
	STA iMusicPulse1BigPointer + 1
	LDA #0
	ADC iMusicPulse2BigPointer
	STA iMusicPulse1BigPointer
	DEX
	; byte 4 - hill offset
	LDA MusicHeaders + 3, Y
	CLC
	ADC iMusicPulse1BigPointer + 1
	STA iMusicHillBigPointer + 1
	LDA #0
	ADC iMusicPulse1BigPointer
	STA iMusicHillBigPointer
	DEX
	BNE ProcessMusicQueue_ReadHeaderNoise

	LDA #0
	STA iMusicNoiseBigPointer + 1
	STA iMusicNoiseBigPointer
	STA iMusicDPCMBigPointer + 1
	STA iMusicDPCMBigPointer
	BEQ ProcessMusicQueue_DefaultNotelength

ProcessMusicQueue_ReadHeaderNoise:
	; byte 6 - noise offset
	LDA MusicHeaders + 5, Y
	CLC
	ADC iMusicHillBigPointer + 1
	STA iMusicNoiseBigPointer + 1
	LDA #0
	ADC iMusicHillBigPointer
	STA iMusicNoiseBigPointer
	DEX
	BNE ProcessMusicQueue_ReadHeaderDPCM

	LDA #0
	STA iMusicDPCMBigPointer + 1
	STA iMusicDPCMBigPointer
	BEQ ProcessMusicQueue_DefaultNotelength

ProcessMusicQueue_ReadHeaderDPCM:
	; byte 7 - DPCM
	LDA MusicHeaders + 6, Y
	CLC
	ADC iMusicNoiseBigPointer + 1
	STA iMusicDPCMBigPointer + 1
	LDA #0
	ADC iMusicNoiseBigPointer
	STA iMusicDPCMBigPointer

ProcessMusicQueue_DefaultNotelength:
	LDA #$01
	STA iMusicPulse2NoteLength
	STA iMusicPulse1NoteLength
	STA iMusicHillNoteLength
	STA iMusicNoiseNoteLength
	STA iDPCMNoteLengthCounter
	STA iDPCMNoteRatioLength

	; initialize offsets / fractions
	LDA #$00
	STA iCurrentPulse2Offset
	STA iCurrentHillOffset
	STA iCurrentPulse1Offset
	STA iCurrentNoiseOffset
	STA iCurrentDPCMOffset
	STA iMusicPulse2NoteLengthFraction
	STA iMusicPulse1NoteLengthFraction
	STA iMusicHillNoteLengthFraction
	STA iMusicNoiseNoteLengthFraction
	STA iMusicDPCMNoteLengthFraction
	STA iSweep

ProcessMusicQueue_ReadNoteData:
	; check note length
	; if 0, start a new note
	; else, skip to updating
	DEC iMusicPulse2NoteLength
	BEQ ProcessMusicQueue_Square2EndOfNote
	JMP ProcessMusicQueue_Square2SustainNote

ProcessMusicQueue_Square2EndOfNote:
	LDA iMusicPulse2BigPointer
	STA zCurrentMusicPointer + 1
	LDA iMusicPulse2BigPointer + 1
	STA zCurrentMusicPointer
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
	; iCurrentMusic always loops
	LDY iCurrentMusic
	LDA MusicStackPermission, Y
	BEQ ProcessMusicQueue_ThenSetNextPart

	; non-zero value, song meets permission, replay last song
	LDA iMusicStack
	BEQ StopMusic

	; iMusicStack != 0
	STA iMusic
	JMP ProcessMusicQueue_MusicQueue1

StopMusic:
; ways to access this routine:
;	iMusicStack = 0, fallthrough
;	iCurrentMusic does not meet logic when fanfare ends
;	Reaching the end-offset without a loop
;	iMusic is $80
;	initializing the sound engine for a new song
	LDA #$10
	STA SQ1_VOL
	LDA #$00
	STA iCurrentMusic
	STA SQ1_HI
	STA SQ1_LO
	STA SQ1_SWEEP

	LDA iCurrentPulse1SFX
	BNE ClearChannelTriangle
	STA SQ2_HI
	STA SQ2_LO
	STA SQ2_SWEEP
	LDA #$10
	STA SQ2_VOL

ClearChannelTriangle:
	LDA iCurrentHillSFX
	BNE ClearChannelNoise
	STA TRI_LINEAR
	STA TRI_HI
	STA TRI_LO

ClearChannelNoise:
	LDA iCurrentNoiseSFX
	BNE ClearChannelDPCM
	STA NOISE_HI
	STA NOISE_LO
	LDA #$10
	STA NOISE_VOL

ClearChannelDPCM:
	LDA iCurrentDPCMSFX
	BNE ClearChannelDone
	JMP ProcessMusicQueue_DPCMDisable

ClearChannelDone:
	RTS

ProcessMusicQueue_ThenSetNextPart:
; any song able to move their pointer offset
	JMP ProcessMusicQueue_SetNextPart

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
	STY iMusicPulse2NoteSubFrames

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
	LDX #APUOffset_Square2
	JSR PlayNote
	TAY
	BEQ ProcessMusicQueue_Square2UpdateNoteOffset

	LDA iMusicPulse2NoteStartLength
	JSR SetInstrumentStartOffset

ProcessMusicQueue_Square2UpdateNoteOffset:
	; set instruemnt offset, init sweep/gain
	STA iMusicPulse2InstrumentOffset

; Sets volume/sweep on Square 2 channel
;
; Input
;   X = duty/volume/envelope
;   Y = sweep
	STX SQ2_VOL
	STY SQ2_SWEEP

ProcessMusicQueue_Square2ContinueNote:
	; set note length
	LDA iMusicPulse2NoteSubFrames
	CLC
	ADC iMusicPulse2NoteLengthFraction
	STA iMusicPulse2NoteLengthFraction
	LDA iMusicPulse2NoteStartLength
	ADC #0
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

; else we start here instead
; load byte offset / data
	LDA iMusicPulse1BigPointer
	STA zCurrentMusicPointer + 1
	LDA iMusicPulse1BigPointer + 1
	STA zCurrentMusicPointer
ProcessMusicQueue_Square1Patch:
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
	STY iMusicPulse1NoteSubFrames

	; next byte, allows higher notes
	LDY iCurrentPulse1Offset
	INC iCurrentPulse1Offset
	LDA (zCurrentMusicPointer), Y

ProcessMusicQueue_Square1AfterPatch:
; + = note
	TAY
	BNE ProcessMusicQueue_Square1Note

	LDA iSweep
	BEQ ProcessMusicQueue_HandleSweep

	LDA #0
	STA iSweep
	BEQ ProcessMusicQueue_Square1Patch

ProcessMusicQueue_HandleSweep
	; 0 - set sweep to $8C
	LDA #$8C
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
	LDA iMusicPulse1NoteSubFrames
	CLC
	ADC iMusicPulse1NoteLengthFraction
	STA iMusicPulse1NoteLengthFraction
	LDA iPulse1NoteLength
	ADC #0
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

	LDA iMusicHillBigPointer
	ORA iMusicHillBigPointer + 1
	BNE ProcessMusicQueue_TriangleStart
	JMP ProcessMusicQueue_NoiseDPCM

ProcessMusicQueue_TriangleStart:
	LDA iMusicHillBigPointer
	STA zCurrentMusicPointer + 1
	LDA iMusicHillBigPointer + 1
	STA zCurrentMusicPointer

	LDA iHillIns
	CMP #$90
	BNE ProcessMusicQueue_TriangleDecrementNL

	LDA iHillPercussionState
	BMI ProcessMusicQueue_TriangleDecrementNL

	DEC iHillPercussionState
	BEQ ProcessMusicQueue_TriangleBongoNote
	BPL ProcessMusicQueue_TriangleDecrementNL

	LDA #0
	STA TRI_LINEAR
	STA TRI_LO
	STA TRI_HI
	BEQ ProcessMusicQueue_TriangleDecrementNL

ProcessMusicQueue_TriangleBongoNote:
	LDA iHillPitch
	LDX #APUOffset_Triangle
	JSR PlayNote

ProcessMusicQueue_TriangleDecrementNL:
	; if note length doesn't reach 0, skip to next channel
	DEC iMusicHillNoteLength
	BEQ ProcessMusicQueue_TriangleByte
	JMP ProcessMusicQueue_NoiseDPCM

ProcessMusicQueue_TriangleByte:
	; next byte
	; 0 = loop
	; + = note length
	; - = note
	LDY iCurrentHillOffset
	INC iCurrentHillOffset
	LDA #1
	STA iHillPercussionState
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_TriangleLoopSegment

	BPL ProcessMusicQueue_TriangleNote

	; - = note length
	; instrument
	TAX
	AND #$F0
	STA iHillIns
	CMP #$90
	BEQ ProcessMusicQueue_TriangleNoteLength
	LDA #0
	STA iHillPercussionState
ProcessMusicQueue_TriangleNoteLength:
	; note length
	TXA
	JSR ProcessMusicQueue_PatchNoteLength

	STA iMusicHillNoteStartLength
	STY iMusicHillNoteSubFrames
	LDA #$1F
	STA TRI_LINEAR
	TYA

	; next byte is treated like a note, or mute
	LDY iCurrentHillOffset
	INC iCurrentHillOffset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_TriangleSetLength

ProcessMusicQueue_TriangleNote:
	LDX iCurrentHillSFX
	BNE ProcessMusicQueue_TriangleSkipPitch
	; - = note
	LDX #APUOffset_Triangle
	STA iHillPitch
	JSR PlayNote

ProcessMusicQueue_TriangleSkipPitch:
	; iMusicHillNoteLength:
	LDA iMusicHillNoteSubFrames
	CLC
	ADC iMusicHillNoteLengthFraction
	STA iMusicHillNoteLengthFraction
	LDA iMusicHillNoteStartLength
	ADC #0
	STA iMusicHillNoteLength
	BMI ProcessMusicQueue_TriangleMax

	TAY
	CPY #$38
	BCS ProcessMusicQueue_TriangleMax

	LDA iHillIns
	CMP #$B0
	LDA Triangle15Outta16Lengths, Y
	BCC ProcessMusicQueue_TriangleSetLength
	LDA Triangle4Outta7Lengths, Y
	BCS ProcessMusicQueue_TriangleSetLength

ProcessMusicQueue_TriangleMax:
	LDA #$7F

ProcessMusicQueue_TriangleSetLength:
	STA TRI_LINEAR
	JMP ProcessMusicQueue_NoiseDPCM

ProcessMusicQueue_TriangleLoopSegment:
	STA iCurrentHillOffset
	JMP ProcessMusicQueue_TriangleByte

ProcessMusicQueue_NoiseDPCM:
; vanilla SMB2 used to treat noise and DPCM as the same channel
; this hack lets both play with their own data sets
ProcessMusicQueue_Noise:
	; if offset = 0, skip to next channel
	LDA iMusicNoiseBigPointer
	BEQ ProcessMusicQueue_ThenNoiseEnd
	STA zCurrentMusicPointer + 1
	LDA iMusicNoiseBigPointer + 1
	STA zCurrentMusicPointer

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
	STY iMusicNoiseNoteSubFrames
	; next byte - later entries allowed
	LDY iCurrentNoiseOffset
	INC iCurrentNoiseOffset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_NoiseLoopSegment

ProcessMusicQueue_NoiseNote:
; + = note
; NOTE - only $02-$0C are valid
; $01 is a rest note
	LDY iCurrentNoiseSFX
	BNE ProcessMusicQueue_NoiseLengthCarry
	LSR A
	BEQ ProcessMusicQueue_NoiseLengthCarry
	TAY

	LDA SND_CHN
	ORA #$0C
	STA SND_CHN

	LDA NoiseVolTable, Y
	STA NOISE_VOL
	LDA NoiseLoTable, Y
	STA NOISE_LO
	LDA NoiseHiTable, Y
	STA NOISE_HI

ProcessMusicQueue_NoiseLengthCarry:
	LDA iMusicNoiseNoteSubFrames
	CLC
	ADC iMusicNoiseNoteLengthFraction
	STA iMusicNoiseNoteLengthFraction
	LDA iMusicNoiseNoteStartLength
	ADC #0
	STA iMusicNoiseNoteLength

ProcessMusicQueue_ThenNoiseEnd:
	JMP ProcessMusicQueue_DPCM

ProcessMusicQueue_NoiseLoopSegment:
; 0 = loop
	STA iCurrentNoiseOffset
	JMP ProcessMusicQueue_NoiseByte

ProcessMusicQueue_DPCM:
	; if offset = 0, end
	LDA iMusicDPCMBigPointer
	BNE ProcessMusicQueue_DPCMlength
	JMP ProcessMusicQueue_DPCMEnd

ProcessMusicQueue_DPCMlength:
	STA zCurrentMusicPointer + 1
	LDA iMusicDPCMBigPointer + 1
	STA zCurrentMusicPointer
	; if note length reaches 0, read sample music data
	DEC iDPCMNoteLengthCounter
	BEQ ProcessMusicQueue_DPCMByte
	; note cuts off in advance
	LDA iDPCMNoteRatioLength
	BEQ ProcessMusicQueue_DPCMExit11
	DEC iDPCMNoteRatioLength
	BNE ProcessMusicQueue_DPCMExit11

	; if note length ratio remains non-zero, check for sound effects
	LDA iCurrentDPCMSFX
	BNE ProcessMusicQueue_DPCMExit11
	; Disable - no sound effects playing
	LDX #%00001111
	STX SND_CHN
	LDX #0
	STX DMC_FREQ
	STX DMC_START
	STX DMC_LEN
ProcessMusicQueue_DPCMExit11:
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
	STY iMusicDPCMNoteSubFrames

	LDY iCurrentDPCMOffset
	INC iCurrentDPCMOffset
	LDA (zCurrentMusicPointer), Y
	BEQ ProcessMusicQueue_DPCMLoopSegment

ProcessMusicQueue_DPCMNote:
; check for sound effects before playing a note
	LDX #iCurrentDPCMSFX
	BNE ProcessMusicQueue_DPCMSFXExit
	; mute for now
	; initialize X
	LDX #$FF
	SEC
ProcessMusicQueue_DPCMNoteLoop:
	; find octave in X
	INX
	SBC #(12 << 1)
	BCS ProcessMusicQueue_DPCMNoteLoop

	; get octave bank
	LDA DPCMOctaves, X
IFNDEF NSF_FILE
	IF INES_MAPPER = MAPPER_MMC5
		STA MMC5_PRGBankSwitch4
	ENDIF
ELSE
	ASL A
	STA NSFBank4
	ORA #1
	STA NSFBank5
ENDIF

	; relead the note for offset
	LDA (zCurrentMusicPointer), Y
	LSR A
	TAY
	; pitch
	LDA DMCPitchTable, Y
	BEQ ProcessMusicQueue_DPCMSFXExit
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
	LDA iMusicDPCMNoteSubFrames
	CLC
	ADC iMusicDPCMNoteLengthFraction
	STA iMusicDPCMNoteLengthFraction
	LDA iDPCMNoteLength
	ADC #0
	STA iDPCMNoteLengthCounter
	LDX #$F0 ; pitch lasts 15 / 16 frames rounded down
	STA MMC5_Multiplier
	STX MMC5_Multiplier + 1
	LDA MMC5_Multiplier + 1
	STA iDPCMNoteRatioLength
	RTS

ProcessMusicQueue_DPCMEnd:
	; check for sound effects before disabling
	LDX #iCurrentDPCMSFX
	BNE ProcessMusicQueue_DPCMExit2

ProcessMusicQueue_DPCMDisable:
	; Disable
	LDX #%00001111
	STX SND_CHN
	LDX #0
	STX DMC_FREQ
	STX DMC_START
	STX DMC_LEN
ProcessMusicQueue_DPCMExit2:
	RTS

ProcessMusicQueue_DPCMLoopSegment:
	; 0 = Loop
	STA iCurrentDPCMOffset
	JMP ProcessMusicQueue_DPCMByte


NoiseVolTable:
	.db $10
	.db $01
	.db $00
	.db $01
	.db $00
	.db $01
	.db $00

NoiseLoTable:
	.db $00
	.db $01
	.db $08
	.db $01
	.db $8E
	.db $09
	.db $09

NoiseHiTable:
	.db $00
	.db $18
	.db $08
	.db $08
	.db $08
	.db $08
	.db $08

; DPCM sawtooth configuration data
.include "src/music/dmc-data.asm"

; Input
;   A = full patch byte
; Output
;   A = new note length
ProcessMusicQueue_PatchNoteLength:
	AND #$0F
	TAY
	LDA NoteLengthMultipliers, Y
	LDY iTempo
	STY MMC5_Multiplier
	STA MMC5_Multiplier + 1
	LDA MMC5_Multiplier
	TAY
	LDA MMC5_Multiplier + 1
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

; Play a note on the Square 1 channel
;
; Input
;   A = note
PlaySquare1Note:
	LDX #0

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

	CPX #APUOffset_Triangle
	LDA #$00
	BCS PlayNote_TriangleRest

	LDA #$10

PlayNote_TriangleRest:
	STA SQ1_VOL, X
	LDA #$00
	RTS

PlayNote_NotRest:
	LDY #$01
	STY iOctave
	TAY
	BMI PlayNote_LoadFrequencyData

	SEC

PlayNote_IncrementOctave:
	INC iOctave
	SBC #$18
	BCS PlayNote_IncrementOctave

	; 0 or 1?
	STA iBasePitchComplement
	LDA IsInstrumentTranspositionOkay
	BEQ PlayNote_LoadFrequencyData
	TXA
	LSR A
	TAY
	LDA InstrumentRAMPointers, Y
	STA zInstrumentPointer
	LDA InstrumentRAMPointers + 1, Y
	STA zInstrumentPointer + 1

	LDY #0
	LDA (zInstrumentPointer), Y
	CMP #$A0
	BNE PlayNote_LoadFrequencyData

	INC iOctave

PlayNote_LoadFrequencyData:
	CLC
	LDA iBasePitchComplement
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

	; tweak the frequency
	DEC zNextPitch

	CPX #APUOffset_Triangle
	BNE PlayNote_SetFrequency

	LDA iHillIns
	CMP #$90
	BNE PlayNote_SetFrequency

	LDA iHillPercussionState
	BEQ PlayNote_SetFrequency
	BMI PlayNote_SetFrequency

	LDA #$FF
	STA TRI_LO
	LDA #$0B
	STA TRI_HI
	RTS

PlayNote_SetFrequency:
	LDA zNextPitch
	STA SQ1_LO, X
	LDA zNextPitch + 1
	ORA #$08
	STA SQ1_HI, X
	RTS

SongBanks:
	audio_bank PRGBank_Music_1
	audio_bank PRGBank_Music_1
	audio_bank PRGBank_Music_2
	audio_bank PRGBank_Music_1
	audio_bank PRGBank_Music_2
	audio_bank PRGBank_Music_3
	audio_bank PRGBank_Music_3
	audio_bank PRGBank_Music_3
	audio_bank PRGBank_Music_2
	audio_bank PRGBank_Music_1
	audio_bank PRGBank_Music_2
	audio_bank PRGBank_Music_1
	audio_bank PRGBank_Music_3
	audio_bank PRGBank_Music_1
	audio_bank PRGBank_Music_3
	audio_bank PRGBank_Music_2
	audio_bank PRGBank_Music_3

PauseTracks1:
	.db $18
	.db $18
	.db $14
	.db $0C
	.db $1C
	.db $18
	.db $0C
	.db $0C
	.db $10
	.db $04
	.db $18
	.db $10
	.db $14
	.db $14
	.db $10
	.db $04
	.db $01

InstrumentRAMPointers:
	.dw iPulse1Ins
	.dw iPulse2Ins
	.dw iHillIns

MusicStackPermission:
	.db $FF
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $01
	.db $00
	.db $00
	.db $00
	.db $00
	.db $01
	.db $00
	.db $01
	.db $00

;
; -------------------------------------------------------------------------
; Various bits of the music engine have been extracted into separate files;
; see the individual files for details on the formats within
;

; Frequency table for notes; standard between various Mario games
.include "src/music/frequency-table.asm";

; Base note lengths and TRI_LINEAR parameters
.include "src/music/note-lengths.asm";

; Pointers to music segments, padded to full length with $ff
.include "src/music/music-part-pointers.asm"

; Headers for songs (BPM, tracks to use, etc), padded to full length with $ff
.include "src/music/music-headers.asm"

; Main music pointers
.include "src/music/music-pointers.asm"

; Channels active in the music (usually all 5)
.include "src/music/music-channel-count.asm"
