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
;   03: Triangle offset from Square 1
;   04: Square 1 offset from Square 2
;   05: Noise offset from Triangle
;   06: DPCM offset from Noise
;
; For the musicHeader macro, specifying $00 is "none", -1 for noise/pcm is "omit".
;
; This turns out to be important because the music part pointers are stored as
; offsets from MusicPartPointers, which means they can't be larger than $FF!
;
MusicHeaders:

; ----------------------------------------
; Character select segments 1 through 5
; (6 through 8 are a ways below this)
MusicHeaderCharacterSelect1:
	musicHeader NoteLengthTable_CHR, MusicDataCharacterSelect1, MusicDataCharacterSelect1_Triangle, MusicDataCharacterSelect1_Square1, MusicDataCharacterSelect1_Noise, MusicDataCharacterSelect1_DPCM

MusicHeaderCharacterSelect2:
	musicHeader NoteLengthTable_CHR, MusicDataCharacterSelect2, MusicDataCharacterSelect2_Triangle, MusicDataCharacterSelect2_Square1, MusicDataCharacterSelect2_Noise, MusicDataCharacterSelect2_DPCM

MusicHeaderCharacterSelect3:
	musicHeader NoteLengthTable_CHR, MusicDataCharacterSelect3, MusicDataCharacterSelect3_Triangle, MusicDataCharacterSelect3_Square1, MusicDataCharacterSelect3_Noise, MusicDataCharacterSelect3_DPCM

MusicHeaderCharacterSelect4:
	musicHeader NoteLengthTable_CHR, MusicDataCharacterSelect4, MusicDataCharacterSelect4_Triangle, MusicDataCharacterSelect4_Square1, MusicDataCharacterSelect4_Noise, MusicDataCharacterSelect4_DPCM

MusicHeaderCharacterSelect5:
	musicHeader NoteLengthTable_CHR, MusicDataCharacterSelect5, MusicDataCharacterSelect5_Triangle, MusicDataCharacterSelect5_Square1, MusicDataCharacterSelect5_Noise, MusicDataCharacterSelect5_DPCM

; ----------------------------------------
; Overworld music headers
MusicHeaderOverworld1:
	musicHeader NoteLengthTable_Overworld, MusicDataOverworld1, MusicDataOverworld1_Triangle, MusicDataOverworld1_Square1, MusicDataOverworld1_Noise, MusicDataOverworld1_DPCM

MusicHeaderOverworld2:
	musicHeader NoteLengthTable_Overworld, MusicDataOverworld2, MusicDataOverworld2_Triangle, MusicDataOverworld2_Square1, MusicDataOverworld2_Noise, MusicDataOverworld2_DPCM

MusicHeaderOverworld3:
	musicHeader NoteLengthTable_Overworld, MusicDataOverworld3, MusicDataOverworld3_Triangle, MusicDataOverworld3_Square1, MusicDataOverworld3_Noise, MusicDataOverworld3_DPCM

MusicHeaderOverworld4:
	musicHeader NoteLengthTable_Overworld, MusicDataOverworld4, MusicDataOverworld4_Triangle, MusicDataOverworld4_Square1, MusicDataOverworld4_Noise, MusicDataOverworld4_DPCM

MusicHeaderOverworld5:
	musicHeader NoteLengthTable_Overworld, MusicDataOverworld5, MusicDataOverworld5_Triangle, MusicDataOverworld5_Square1, MusicDataOverworld5_Noise, MusicDataOverworld5_DPCM

; ----------------------------------------
; Underground music
MusicHeaderUnderground:
	musicHeader NoteLengthTable_Underground, MusicDataUnderground, MusicDataUnderground_Triangle, MusicDataUnderground_Square1, MusicDataUnderground_Noise, MusicDataUnderground_DPCM

; ----------------------------------------
; Boss and boss area music
MusicHeaderBoss:
	musicHeader NoteLengthTable_Boss, MusicDataBoss, MusicDataBoss_Triangle, MusicDataBoss_Square1, MusicDataBoss_Noise, -1

; ----------------------------------------
; Starman music
MusicHeaderStar:
	musicHeader NoteLengthTable_Star, MusicDataStar, MusicDataStar_Triangle, MusicDataStar_Square1, MusicDataStar_Noise, MusicDataStar_DPCM

; ----------------------------------------
; Wart's final boss music
MusicHeaderWart:
	musicHeader NoteLengthTable_Wart, MusicDataWart, MusicDataWart_Triangle, MusicDataWart_Square1, MusicDataWart_Noise, MusicDataWart_DPCM

; ----------------------------------------
; Various shorter jingles, extra character select segments (8, 7, 6), and other potpourri

MusicHeaderCrystal:
	musicHeader NoteLengthTable_Crystal, MusicDataCrystal, MusicDataCrystal_Triangle, MusicDataCrystal_Square1, MusicDataCrystal_Noise, MusicDataCrystal_DPCM

MusicHeaderGameOver:
 	musicHeader NoteLengthTable_GameOver, MusicDataGameOver, MusicDataGameOver_Triangle, MusicDataGameOver_Square1, MusicDataGameOver_Noise, MusicDataGameOver_DPCM

MusicHeaderBossBeaten:
 	musicHeader NoteLengthTable_BossBeaten, MusicDataBossBeaten, MusicDataBossBeaten_Triangle, MusicDataBossBeaten_Square1, MusicDataBossBeaten_Noise, MusicDataBossBeaten_DPCM

MusicHeaderMushroomBonusChance:
 	musicHeader NoteLengthTable_BonusChance, MusicDataMushroomBonusChance, MusicDataMushroomBonusChance_Triangle, MusicDataMushroomBonusChance_Square1, MusicDataMushroomBonusChance_Noise, MusicDataMushroomBonusChance_DPCM

MusicHeaderDeath:
 	musicHeader NoteLengthTable_Death, MusicDataDeath, MusicDataDeath_Triangle, MusicDataDeath_Square1, MusicDataDeath_Noise, MusicDataDeath_DPCM

; ----------------------------------------
; Title screen segments

MusicHeaderTitleScreen:
	musicHeader NoteLengthTable_Title, MusicDataTitleScreen, MusicDataTitleScreen_Triangle, MusicDataTitleScreen_Square1, MusicDataTitleScreen_Noise, MusicDataTitleScreen_DPCM

; ----------------------------------------
; Subspace music, quite longer than normally heard

MusicHeaderSubspace1:
	musicHeader NoteLengthTable_Subspace, MusicDataSubspace, MusicDataSubspace_Triangle, MusicDataSubspace_Square1, MusicDataSubspace_Noise, MusicDataSubspace_DPCM

; ----------------------------------------
; Ending music

MusicHeaderEnding1:
	musicHeader NoteLengthTable_Ending123, MusicDataEnding1, MusicDataEnding1_Triangle, MusicDataEnding1_Square1, MusicDataEnding1_Noise, MusicDataEnding1_DPCM

MusicHeaderEnding2:
	musicHeader NoteLengthTable_Ending123, MusicDataEnding2, MusicDataEnding2_Triangle, MusicDataEnding2_Square1, MusicDataEnding2_Noise, MusicDataEnding2_DPCM

MusicHeaderEnding3:
	musicHeader NoteLengthTable_Ending123, MusicDataEnding3, MusicDataEnding3_Triangle, MusicDataEnding3_Square1, MusicDataEnding3_Noise, MusicDataEnding3_DPCM

MusicHeaderEnding4:
	musicHeader NoteLengthTable_Ending4, MusicDataEnding4, MusicDataEnding4_Triangle, MusicDataEnding4_Square1, MusicDataEnding4_Noise, MusicDataEnding4_DPCM

MusicHeaderEnding5:
	musicHeader NoteLengthTable_Ending5, MusicDataEnding5, MusicDataEnding5_Triangle, MusicDataEnding5_Square1, MusicDataEnding5_Noise, MusicDataEnding5_DPCM

.pad MusicHeaders + $100, $FF
