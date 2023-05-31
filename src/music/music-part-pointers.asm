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
	musicPart MusicHeaderMushroomBonusChance

MusicPartPointers_BossBeaten:
	musicPart MusicHeaderBossBeaten

; This version of the crystal fanfare is unused, because special logic in
; ProcessMusicQueue uses this slot for the ending theme instead.
MusicPartPointers_CrystalUnused:
	musicPart MusicHeaderCrystal

MusicPartPointers_Death:
	musicPart MusicHeaderDeath

MusicPartPointers_GameOver:
	musicPart MusicHeaderGameOver

MusicPartPointers_Crystal:
	musicPart MusicHeaderCrystal

MusicPartPointers_BonusChance:
	musicPart MusicHeaderMushroomBonusChance

; The rest of the pointers correspond to music that uses the pointer tables
; with support for segment-based looping.
MusicPartPointers_CharacterSelect:
	musicPart MusicHeaderCharacterSelect1
MusicPartPointers_CharacterSelectLoop:
	musicPart MusicHeaderCharacterSelect2
MusicPartPointers_CharacterSelectEnd:
	musicPart MusicHeaderCharacterSelect3


MusicPartPointers_Overworld:
	musicPart MusicHeaderOverworld1
MusicPartPointers_OverworldLoop:
	musicPart MusicHeaderOverworld2
	musicPart MusicHeaderOverworld3
	musicPart MusicHeaderOverworld4
	musicPart MusicHeaderOverworld3
MusicPartPointers_OverworldEnd:
	musicPart MusicHeaderOverworld5


MusicPartPointers_Boss:
MusicPartPointers_BossLoop:
MusicPartPointers_BossEnd:
	musicPart MusicHeaderBoss


MusicPartPointers_Star:
MusicPartPointers_StarLoop:
MusicPartPointers_StarEnd:
	musicPart MusicHeaderStar


MusicPartPointers_Wart:
MusicPartPointers_WartLoop:
MusicPartPointers_WartEnd:
	musicPart MusicHeaderWart


MusicPartPointers_TitleScreen:
	musicPart MusicHeaderTitleScreen1
	musicPart MusicHeaderTitleScreen2
MusicPartPointers_TitleScreenEnd:
	musicPart MusicHeaderTitleScreen3


MusicPartPointers_SubSpace:
MusicPartPointers_SubSpaceLoop:
MusicPartPointers_SubSpaceEnd:
	musicPart MusicHeaderSubspace1

MusicPartPointers_Ending:
	musicPart MusicHeaderEnding1
	musicPart MusicHeaderEnding2
	musicPart MusicHeaderEnding3
	musicPart MusicHeaderEnding4
MusicPartPointers_EndingLoop:
	musicPart MusicHeaderEnding5
	musicPart MusicHeaderEnding6
	musicPart MusicHeaderEnding5
	musicPart MusicHeaderEnding7
MusicPartPointers_EndingEnd:
	musicPart MusicHeaderEnding8

MusicPartPointers_Underground:
MusicPartPointers_UndergroundLoop:
MusicPartPointers_UndergroundEnd:
	musicPart MusicHeaderUnderground
