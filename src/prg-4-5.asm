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

.include "src/music/driver.asm"

;
; -------------------------------------------------------------------------
; Various bits of the music engine have been extracted into separate files;
; see the individual files for details on the formats within
;

; Frequency table for notes; standard between various Mario games
.include "src/music/frequency-table.asm";

; Base note lengths and TRI_LINEAR parameters
.include "src/music/note-lengths.asm"

; Pointers to music segments, padded to full length with $ff
.include "src/music/music-part-pointers.asm"

; Headers for songs (BPM, tracks to use, etc), padded to full length with $ff
.include "src/music/music-headers.asm"

; Main music pointers
.include "src/music/music-pointers.asm"

; Channels active in the music (usually all 5)
.include "src/music/music-channel-count.asm"
