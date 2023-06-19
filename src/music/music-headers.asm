;
; Music Headers
; =============
;
; These are broken down by song segment and point to the note length table and
; and individual channel data. Square 2 is the main pointer, and triangle,
; square 1, and noise are stored as offets relative to the main pointer.
;
; Bytes:
;   00: Note length table (from $8F00)
;   01: Main address / Square 2 (lo)
;   02: Main address / Square 2 (hi)
;   03: Triangle offset from main
;   04: Square 1 offset from main
;   05: Noise/DPCM offset from main
;
; For the musicHeader macro, specifying $00 is "none", -1 for noise/pcm is "omit".
; Some of the music headers use the $00 from the next header's note length table,
; to save one byte (in a ROM /full/ of unused space...)
;
; This turns out to be important because the music part pointers are stored as
; offsets from MusicPartPointers, which means they can't be larger than $FF!
;
MusicPartHeaders:

; ----------------------------------------
; Character select segments 1 through 5
; (6 through 8 are a ways below this)
MusicHeaderCharacterSelect1:
	musicHeader NoteLengthTable_300bpm, MusicDataCharacterSelect1, MusicDataCharacterSelect1_Triangle, MusicDataCharacterSelect1_Square1, MusicDataCharacterSelect1_Noise, -1

MusicHeaderCharacterSelect2:
	musicHeader NoteLengthTable_300bpm, MusicDataCharacterSelect2, MusicDataCharacterSelect2_Triangle, MusicDataCharacterSelect2_Square1, MusicDataCharacterSelect2_Noise, -1

MusicHeaderCharacterSelect3:
	musicHeader NoteLengthTable_300bpm, MusicDataCharacterSelect3, MusicDataCharacterSelect3_Triangle, MusicDataCharacterSelect3_Square1, MusicDataCharacterSelect3_Noise, -1

; ----------------------------------------
; Overworld music headers
MusicHeaderOverworld1:
	musicHeader NoteLengthTable_200bpm, MusicDataOverworld1, MusicDataOverworld1_Triangle, MusicDataOverworld1_Square1, MusicDataOverworld1_Noise, -1

MusicHeaderOverworld2:
	musicHeader NoteLengthTable_200bpm, MusicDataOverworld2, MusicDataOverworld2_Triangle, MusicDataOverworld2_Square1, MusicDataOverworld2_Noise, -1

MusicHeaderOverworld3:
	musicHeader NoteLengthTable_200bpm, MusicDataOverworld3, MusicDataOverworld3_Triangle, MusicDataOverworld3_Square1, MusicDataOverworld3_Noise, -1

MusicHeaderOverworld4:
	musicHeader NoteLengthTable_200bpm, MusicDataOverworld4, MusicDataOverworld4_Triangle, MusicDataOverworld4_Square1, MusicDataOverworld4_Noise, -1

MusicHeaderOverworld5:
	musicHeader NoteLengthTable_200bpm, MusicDataOverworld5, MusicDataOverworld5_Triangle, MusicDataOverworld5_Square1, MusicDataOverworld5_Noise, -1

; ----------------------------------------
; Underground music
MusicHeaderUnderground:
	musicHeader NoteLengthTable_150bpm, MusicDataUnderground, MusicDataUnderground_Triangle, MusicDataUnderground_Square1, -1, -1

; ----------------------------------------
; Boss and boss area music
MusicHeaderBoss:
	musicHeader NoteLengthTable_200bpm, MusicDataBoss, MusicDataBoss_Triangle, MusicDataBoss_Square1, -1, -1

; ----------------------------------------
; Starman music
MusicHeaderStar:
	musicHeader NoteLengthTable_200bpm, MusicDataStar, MusicDataStar_Triangle, MusicDataStar_Square1, -1, -1

; ----------------------------------------
; Wart's final boss music
MusicHeaderWart:
	musicHeader NoteLengthTable_200bpm, MusicDataWart, MusicDataWart_Triangle, MusicDataWart_Square1, -1, -1

; ----------------------------------------
; Various shorter jingles, extra character select segments (8, 7, 6), and other potpourri

MusicHeaderCrystal:
	musicHeader NoteLengthTable_300bpm, MusicDataCrystal, MusicDataCrystal_Triangle, MusicDataCrystal_Square1, -1, -1

MusicHeaderGameOver:
 	musicHeader NoteLengthTable_300bpm, MusicDataGameOver, MusicDataGameOver_Triangle, MusicDataGameOver_Square1, -1, -1

MusicHeaderBossBeaten:
 	musicHeader NoteLengthTable_300bpm, MusicDataBossBeaten, MusicDataBossBeaten_Triangle, MusicDataBossBeaten_Square1, -1, -1

MusicHeaderMushroomBonusChance:
 	musicHeader NoteLengthTable_150bpm, MusicDataMushroomBonusChance, $00, MusicDataMushroomBonusChance_Square1, -1, -1

MusicHeaderDeath:
 	musicHeader NoteLengthTable_200bpm, MusicDataDeath, MusicDataDeath_Triangle, MusicDataDeath_Square1, -1, -1

; ----------------------------------------
; Title screen segments

MusicHeaderTitleScreen2:
	musicHeader NoteLengthTable_164bpm, MusicDataTitleScreen2, MusicDataTitleScreen2_Triangle, MusicDataTitleScreen2_Square1, MusicDataTitleScreen2_Noise, MusicDataTitleScreen2_DPCM

MusicHeaderTitleScreen1:
	musicHeader NoteLengthTable_164bpm, MusicDataTitleScreen1, MusicDataTitleScreen1_Triangle, MusicDataTitleScreen1_Square1, MusicDataTitleScreen1_Noise, MusicDataTitleScreen1_DPCM

MusicHeaderTitleScreen3:
	musicHeader NoteLengthTable_164bpm, MusicDataTitleScreen3, MusicDataTitleScreen3_Triangle, MusicDataTitleScreen3_Square1, MusicDataTitleScreen3_Noise, MusicDataTitleScreen3_DPCM

; ----------------------------------------
; Subspace music, quite longer than normally heard

MusicHeaderSubspace1:
	musicHeader NoteLengthTable_200bpm, MusicDataSubspace, 0, MusicDataSubspace_Square1, -1, -1

; ----------------------------------------
; Ending music

MusicHeaderEnding1:
	musicHeader NoteLengthTable_129bpm, MusicDataEnding1, MusicDataEnding1_Triangle, MusicDataEnding1_Square1, MusicDataEnding1_Noise, -1

MusicHeaderEnding3:
	musicHeader NoteLengthTable_129bpm, MusicDataEnding3, MusicDataEnding3_Triangle, MusicDataEnding3_Square1, MusicDataEnding3_Noise, -1

MusicHeaderEnding2:
	musicHeader NoteLengthTable_129bpm, MusicDataEnding2, MusicDataEnding2_Triangle, MusicDataEnding2_Square1, MusicDataEnding2_Noise, -1

MusicHeaderEnding5:
	musicHeader NoteLengthTable_150bpm, MusicDataEnding5, MusicDataEnding5_Triangle, MusicDataEnding5_Square1, MusicDataEnding5_Noise, -1

MusicHeaderEnding4:
	musicHeader NoteLengthTable_150bpm, MusicDataEnding4, MusicDataEnding4_Triangle, MusicDataEnding4_Square1, MusicDataEnding4_Noise, -1

MusicHeaderEnding6:
	musicHeader NoteLengthTable_150bpm, MusicDataEnding6, MusicDataEnding6_Triangle, MusicDataEnding6_Square1, MusicDataEnding6_Noise, -1

MusicHeaderEnding7:
	musicHeader NoteLengthTable_150bpm, MusicDataEnding7, MusicDataEnding7_Triangle, MusicDataEnding7_Square1, MusicDataEnding7_Noise, -1

MusicHeaderEnding8:
	musicHeader NoteLengthTable_150bpm, MusicDataEnding8, MusicDataEnding8_Triangle, MusicDataEnding8_Square1, MusicDataEnding8_Noise, -1

;
; Subcons Freed Music
; Uses new custom note lengths
;

MusicHeaderSubcons1:
	musicHeader NoteLengthTable_150bpm, MusicDataSubcons1, MusicDataSubcons1_Triangle, MusicDataSubcons1_Square1, MusicDataSubcons1_Noise, -1

MusicHeaderSubcons2:
	musicHeader NoteLengthTable_150bpm, MusicDataSubcons2, MusicDataSubcons2_Triangle, MusicDataSubcons2_Square1, MusicDataSubcons2_Noise, -1

MusicHeaderSubcons3:
	musicHeader NoteLengthTable_150bpm, MusicDataSubcons3, MusicDataSubcons3_Triangle, MusicDataSubcons3_Square1, MusicDataSubcons3_Noise, -1

MusicHeaderSubcons4:
	musicHeader NoteLengthTable_150bpm, MusicDataSubcons4, MusicDataSubcons4_Triangle, MusicDataSubcons4_Square1, MusicDataSubcons4_Noise, -1
