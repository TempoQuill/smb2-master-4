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
Audio3_IsInstrumentTranspositionOkay:
	.db $00

Audio3_InstrumentDVE_80:
.incbin "src/music/smas-instrument-data/audio-3-80.bin"

Audio3_InstrumentDVE_80_Short:
.incbin "src/music/smas-instrument-data/audio-3-80t.bin"

Audio3_InstrumentDVE_90_E0:
.incbin "src/music/smas-instrument-data/audio-3-90.bin"

Audio3_InstrumentDVE_90_E0_Short
.incbin "src/music/smas-instrument-data/audio-3-90t.bin"

Audio3_InstrumentDVE_A0:
.incbin "src/music/smas-instrument-data/audio-3-a0.bin"

Audio3_InstrumentDVE_A0_Short:
.incbin "src/music/smas-instrument-data/audio-3-a0t.bin"

Audio3_InstrumentDVE_B0:
.incbin "src/music/smas-instrument-data/audio-3-b0.bin"

Audio3_InstrumentDVE_B0_Short
.incbin "src/music/smas-instrument-data/audio-3-b0t.bin"

Audio3_InstrumentDVE_C0_Short:
.incbin "src/music/smas-instrument-data/audio-3-c0t.bin"

Audio3_InstrumentDVE_C0:
.incbin "src/music/smas-instrument-data/audio-3-c0.bin"

Audio3_InstrumentDVE_D0:
.incbin "src/music/smas-instrument-data/audio-3-d0.bin"

Audio3_InstrumentDVE_D0_Short:
.incbin "src/music/smas-instrument-data/audio-3-d0t.bin"

Audio3_InstrumentDVE_F0_Short:
.incbin "src/music/smas-instrument-data/audio-3-f0t.bin"

Audio3_InstrumentDVE_F0:
.incbin "src/music/smas-instrument-data/audio-3-f0.bin"

Audio3_NoteLengthMultipliers:
	.db $0C, $0C, $10, $10, $18, $24, $20, $20, $30, $48, $60, $90, $C0, $08, $08, $08
