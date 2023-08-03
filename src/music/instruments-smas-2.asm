;
; Instrument Sound Data
; =====================
;
; Each "instrument" is a lookup table of duty/volume/envelope values that are
; read backwards from the end
;
; The normal version of an instrument is 64 bytes
; The shorter version of an instrument is 23 bytes
;
Audio2_IsInstrumentTranspositionOkay:
	SEC
	RTS

Audio2_InstrumentDVE_80:
.incbin "src/music/smas-instrument-data/audio-2-80.bin"

Audio2_InstrumentDVE_80_Short:
.incbin "src/music/smas-instrument-data/audio-2-80t.bin"

Audio2_InstrumentDVE_90_E0:
.incbin "src/music/smas-instrument-data/audio-2-90.bin"

Audio2_InstrumentDVE_90_E0_Short
.incbin "src/music/smas-instrument-data/audio-2-90t.bin"

Audio2_InstrumentDVE_A0:
.incbin "src/music/smas-instrument-data/audio-2-a0.bin"

Audio2_InstrumentDVE_A0_Short:
.incbin "src/music/smas-instrument-data/audio-2-a0t.bin"

Audio2_InstrumentDVE_B0:
.incbin "src/music/smas-instrument-data/audio-2-b0.bin"

Audio2_InstrumentDVE_B0_Short
.incbin "src/music/smas-instrument-data/audio-2-b0t.bin"

Audio2_InstrumentDVE_C0_Short:
.incbin "src/music/smas-instrument-data/audio-2-c0t.bin"

Audio2_InstrumentDVE_C0:
.incbin "src/music/smas-instrument-data/audio-2-c0.bin"

Audio2_InstrumentDVE_D0:
.incbin "src/music/smas-instrument-data/audio-2-d0.bin"

Audio2_InstrumentDVE_D0_Short:
.incbin "src/music/smas-instrument-data/audio-2-d0t.bin"

Audio2_InstrumentDVE_F0_Short:
.incbin "src/music/smas-instrument-data/audio-2-f0t.bin"

Audio2_InstrumentDVE_F0:
.incbin "src/music/smas-instrument-data/audio-2-f0.bin"

Audio2_NoteLengthMultipliers:
	.db $0C, $0C, $10, $10, $18, $24, $20, $20, $30, $48, $60, $90, $C0, $08, $08, $08
