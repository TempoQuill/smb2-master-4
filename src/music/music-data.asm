;
; Music Data
; ==========
;
; Each segment of music is broken down into tracks for individual instruments.
;
; Square 2:
;   $00: End of segment
;   $01-$7D: Note On
;   $7E: Rest
;   $80-$FE: first nybble is the instrument, second nybble is the note length
;            as determined by the note length lookup table. The next byte is
;            expected to be a Note On.
;   $FF: activate bend if used after a Note On
;
; Square 1 is the same as Square 2, except for the following:
;   $00: Activate a ramp effect
;
; Triangle is the same as Square 2, except for the following:
;   $00: Mute output (triangle channel is constant volume otherwise)
;   $80-$FF: second nybble is the note length from the note length lookup table
;
; Noise:
;   $00: Restart (used for looping percussion within a segment)
;   $01: Rest
;   $02-$7F: Various note-on values, low bit is ignored
;   $02: Closed Hi-Hat
;   $04: Kick
;   $06: Open Hi-Hat
;   $80-$FF: second nybble is the note length from the note length lookup table
;
; The SMB3 disassembly is a good reference, since the format is the same:
; http://sonicepoch.com/sm3mix/disassembly.html#TRACK
;
MusicData:

;
; Ending music
; Segment 1-3 are at a different tempo than 4-8
;
.include "src/music/segments/ending/ending-1.asm"
.include "src/music/segments/ending/ending-3.asm"
.include "src/music/segments/ending/ending-4.asm"
.include "src/music/segments/ending/ending-2.asm"
.include "src/music/segments/ending/ending-5.asm"
.include "src/music/segments/ending/ending-6.asm"

;
; Invincible Star music
;
.include "src/music/segments/ldp-exclusive/inv-star.asm"

;
; Inside music
; (including prototype version)
;
.include "src/music/segments/ldp-exclusive/inside.asm"

;
; Subspace music
;
.include "src/music/segments/ldp-exclusive/lamp.asm"

;
; Title screen music
;
.include "src/music/segments/ldp-exclusive/title-1.asm"
.include "src/music/segments/ldp-exclusive/title-2.asm"
.include "src/music/segments/ldp-exclusive/title-3.asm"

;
; Character Select screen music
;
.include "src/music/segments/ldp-exclusive/chr-1.asm"
.include "src/music/segments/ldp-exclusive/chr-2.asm"
.include "src/music/segments/ldp-exclusive/chr-3.asm"

;
; Overworld music segments
;
.include "src/music/segments/ldp-exclusive/outside-1.asm"
.include "src/music/segments/ldp-exclusive/outside-2.asm"
.include "src/music/segments/ldp-exclusive/outside-3.asm"
.include "src/music/segments/ldp-exclusive/outside-4.asm"
.include "src/music/segments/ldp-exclusive/outside-5.asm"

;
; Boss music segment...
;
.include "src/music/segments/boss/boss.asm"

;
; Mamu's final boss music segment
;
.include "src/music/segments/ldp-exclusive/mamu.asm"

;
; Various sound effect jingles; not really full songs...
;
.include "src/music/segments/jingles/mushroom-bonus-chance.asm"
.include "src/music/segments/ldp-exclusive/over.asm"
.include "src/music/segments/ldp-exclusive/vic.asm"
.include "src/music/segments/ldp-exclusive/extra.asm"
.include "src/music/segments/jingles/death.asm"
