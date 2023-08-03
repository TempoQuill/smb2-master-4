;
; Music Part Pointers
; ===================
;
; These are the pointers to various music segments used to cue those themes in
; the game as well as handle relative offsets for looping segments
;
MusicPartPointers:

; These pointers correspond to iMusic2 fanfares that temporarily interrupt
; the current background music
MusicPartPointers_Mushroom:
	musicHeaderPointer MusicHeaderMushroomBonusChance

MusicPartPointers_BossBeaten:
	musicHeaderPointer MusicHeaderBossBeaten

; This version of the crystal fanfare is unused, because special logic in
; ProcessMusicQueue uses this slot for the ending theme instead.
MusicPartPointers_CrystalUnused:
	musicHeaderPointer MusicHeaderCrystal

MusicPartPointers_Death:
	musicHeaderPointer MusicHeaderDeath

MusicPartPointers_GameOver:
	musicHeaderPointer MusicHeaderGameOver

MusicPartPointers_Crystal:
	musicHeaderPointer MusicHeaderCrystal

MusicPartPointers_BonusChance:
	musicHeaderPointer MusicHeaderMushroomBonusChance

; The rest of the pointers correspond to music that uses the pointer tables
; with support for segment-based looping.
MusicPartPointers_CharacterSelect:
	musicHeaderPointer MusicHeaderCharacterSelect1
MusicPartPointers_CharacterSelectLoop:
	musicHeaderPointer MusicHeaderCharacterSelect2
	musicHeaderPointer MusicHeaderCharacterSelect3
	musicHeaderPointer MusicHeaderCharacterSelect4
MusicPartPointers_CharacterSelectEnd:
	musicHeaderPointer MusicHeaderCharacterSelect5


MusicPartPointers_Overworld:
	musicHeaderPointer MusicHeaderOverworld1
MusicPartPointers_OverworldLoop:
	musicHeaderPointer MusicHeaderOverworld2
	musicHeaderPointer MusicHeaderOverworld3
	musicHeaderPointer MusicHeaderOverworld4
	musicHeaderPointer MusicHeaderOverworld3
MusicPartPointers_OverworldEnd:
	musicHeaderPointer MusicHeaderOverworld5


MusicPartPointers_Boss:
MusicPartPointers_BossLoop:
MusicPartPointers_BossEnd:
	musicHeaderPointer MusicHeaderBoss


MusicPartPointers_Star:
MusicPartPointers_StarLoop:
MusicPartPointers_StarEnd:
	musicHeaderPointer MusicHeaderStar


MusicPartPointers_Wart:
MusicPartPointers_WartLoop:
MusicPartPointers_WartEnd:
	musicHeaderPointer MusicHeaderWart


MusicPartPointers_TitleScreen:
MusicPartPointers_TitleScreenEnd:
	musicHeaderPointer MusicHeaderTitleScreen


MusicPartPointers_SubSpace:
MusicPartPointers_SubSpaceLoop:
MusicPartPointers_SubSpaceEnd:
	musicHeaderPointer MusicHeaderSubspace1

MusicPartPointers_Ending:
	musicHeaderPointer MusicHeaderEnding1
	musicHeaderPointer MusicHeaderEnding2
	musicHeaderPointer MusicHeaderEnding3
	musicHeaderPointer MusicHeaderEnding4
MusicPartPointers_EndingLoop:
MusicPartPointers_EndingEnd:
	musicHeaderPointer MusicHeaderEnding5

MusicPartPointers_Underground:
MusicPartPointers_UndergroundLoop:
MusicPartPointers_UndergroundEnd:
	musicHeaderPointer MusicHeaderUnderground

.pad MusicPartPointers + $100, $FF
