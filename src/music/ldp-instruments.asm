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
InstrumentSoundData:

InstrumentDVE_80: ; $A18D
.incbin "src/music/ldp-instrument-data/8-full.bin"

InstrumentDVE_80_Short: ; $A1CD
.incbin "src/music/ldp-instrument-data/8-trim.bin"

InstrumentDVE_90_E0: ; $A1E4
.incbin "src/music/ldp-instrument-data/9e-full.bin"

InstrumentDVE_90_E0_Short: ; $A224
.incbin "src/music/ldp-instrument-data/9e-trim.bin"

InstrumentDVE_A0: ; $A23B
.incbin "src/music/ldp-instrument-data/a-full.bin"

InstrumentDVE_A0_Short: ; $A27B
.incbin "src/music/ldp-instrument-data/a-trim.bin"

InstrumentDVE_B0: ; $A293
.incbin "src/music/ldp-instrument-data/b-full.bin"

InstrumentDVE_B0_Short: ; $A2D3
.incbin "src/music/ldp-instrument-data/b-trim.bin"

InstrumentDVE_C0_Short: ; $A2EA
.incbin "src/music/ldp-instrument-data/c-trim.bin"

InstrumentDVE_C0: ; $A301
.incbin "src/music/ldp-instrument-data/c-full.bin"

InstrumentDVE_D0: ; $A341
.incbin "src/music/ldp-instrument-data/d-full.bin"

InstrumentDVE_D0_Short: ; $A381
.incbin "src/music/ldp-instrument-data/d-trim.bin"

InstrumentDVE_F0_Short: ; $A398
.incbin "src/music/ldp-instrument-data/f-trim.bin"

InstrumentDVE_F0: ; $A3AF
.incbin "src/music/ldp-instrument-data/f-full.bin"
