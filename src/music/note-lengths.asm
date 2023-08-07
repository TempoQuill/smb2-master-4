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
; $xD: 1/16 triplet, 1/8 triplet  (underground, overworld arps, subspace arps)
; $xE: 1/8 triplet                (overworld arps)
; $xF: whole triplet, 1/8 triplet (overworld triangle long note)
;

NoteLengthTable_Death = $41
NoteLengthTable_CHR = $44
NoteLengthTable_Crystal = $48
NoteLengthTable_BossBeaten = $4C
NoteLengthTable_Ending123 = $50
NoteLengthTable_Ending4 = $54
NoteLengthTable_Subspace = $60
NoteLengthTable_Boss = $64
NoteLengthTable_Overworld = $6C
NoteLengthTable_Wart = $70
NoteLengthTable_Star = $7C
NoteLengthTable_GameOver = $88
NoteLengthTable_Underground = $90
NoteLengthTable_BonusChance = $94
NoteLengthTable_Ending5 = $A8
NoteLengthTable_Title = $B0
