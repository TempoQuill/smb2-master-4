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
IsInstrumentTranspositionOkay:
Audio1_IsInstrumentTranspositionOkay:
	SEC
	RTS

InstrumentSoundData:

Audio1_InstrumentDVE_80:
InstrumentDVE_80: ; $A18D
.incbin "src/music/smas-instrument-data/audio-1-80.bin"

Audio1_InstrumentDVE_80_Short:
InstrumentDVE_80_Short: ; $A1CD
.incbin "src/music/smas-instrument-data/audio-1-80t.bin"

Audio1_InstrumentDVE_90_E0:
InstrumentDVE_90_E0: ; $A1E4
.incbin "src/music/smas-instrument-data/audio-1-90.bin"

Audio1_InstrumentDVE_90_E0_Short
InstrumentDVE_90_E0_Short: ; $A224
.incbin "src/music/smas-instrument-data/audio-1-90t.bin"

Audio1_InstrumentDVE_A0:
InstrumentDVE_A0: ; $A23B
.incbin "src/music/smas-instrument-data/audio-1-a0.bin"

Audio1_InstrumentDVE_A0_Short:
InstrumentDVE_A0_Short: ; $A27B
.incbin "src/music/smas-instrument-data/audio-1-a0t.bin"

Audio1_InstrumentDVE_B0:
InstrumentDVE_B0: ; $A293
.incbin "src/music/smas-instrument-data/audio-1-b0.bin"

Audio1_InstrumentDVE_B0_Short
InstrumentDVE_B0_Short: ; $A2D3
.incbin "src/music/smas-instrument-data/audio-1-b0t.bin"

Audio1_InstrumentDVE_C0_Short:
InstrumentDVE_C0_Short: ; $A2EA
.incbin "src/music/smas-instrument-data/audio-1-c0t.bin"

Audio1_InstrumentDVE_C0:
InstrumentDVE_C0: ; $A301
.incbin "src/music/smas-instrument-data/audio-1-c0.bin"

Audio1_InstrumentDVE_D0:
InstrumentDVE_D0: ; $A341
.incbin "src/music/smas-instrument-data/audio-1-d0.bin"

Audio1_InstrumentDVE_D0_Short:
InstrumentDVE_D0_Short: ; $A381
.incbin "src/music/smas-instrument-data/audio-1-d0t.bin"

Audio1_InstrumentDVE_F0_Short:
InstrumentDVE_F0_Short: ; $A398
.incbin "src/music/smas-instrument-data/audio-1-f0t.bin"

Audio1_InstrumentDVE_F0:
InstrumentDVE_F0: ; $A3AF
.incbin "src/music/smas-instrument-data/audio-1-f0.bin"

NoteLengthMultipliers:
Audio1_NoteLengthMultipliers:
	.db $0C, $0C, $10, $10, $18, $24, $20, $20, $30, $48, $60, $90, $C0, $04, $08, $40
