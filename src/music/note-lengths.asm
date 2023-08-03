;
; Note Lengths
; ============
;
; These are lookup tables used to determine note lengths (in ticks).
;
; There are a few weird values floating around, but it's generally broken into
; groups of 13 note lengths that correspond to a tempo as follows:
;
; $x0: 1/16 note
; $x1: 1/16 note
; $x2: 1/4 note triplet
; $x3: 1/4 note triplet
; $x4: 1/8 note
; $x5: dotted 1/8 note
; $x6: 1/2 note triplet
; $x7: 1/2 note triplet
; $x8: 1/4 note
; $x9: dotted 1/4 note
; $xA: 1/2 note
; $xB: dotted 1/2 note
; $xC: whole note
; $xD: dotted 1/8 note / misc.
; $xE: double note (usually note defined)
; $xF: usually not defined
;
; 14400 is the number of ticks in a minute (4 ticks * 60 fps * 60 seconds), and
; you can work out the tempo by dividing 14400 by the length of a whole note.
;

; Character Select
; Star
; Crystal
; Game Over
; Boss Beaten
NoteLengthTable_Death = $40
NoteLengthTable_CHR = $44
NoteLengthTable_Crystal = $48
NoteLengthTable_257bpm = $4B
NoteLengthTable_BossBeaten = $4C
NoteLengthTable_Ending123 = $50
NoteLengthTable_Ending4 = $54
; Title Screen
NoteLengthTable_225bpm = $55
; Overworld
; Boss
; Wart
; Death
; Subspace
NoteLengthTable_Subspace = $60
NoteLengthTable_Boss = $64
NoteLengthTable_180bpm = $6B
NoteLengthTable_Overworld = $6B
NoteLengthTable_Wart = $70
NoteLengthTable_Star = $7B
; Bonus Chance
NoteLengthTable_150bpm = $80
NoteLengthTable_GameOver = $88
; Underground
; Ending
NoteLengthTable_Underground = $90
NoteLengthTable_129bpm = $95
NoteLengthTable_120bpm = $A0
NoteLengthTable_Ending5 = $A8
NoteLengthTable_112bpm = $AB
NoteLengthTable_Title = $B0
NoteLengthTable_106bpm = $B5
NoteLengthTable_100bpm = $C0

