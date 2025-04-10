;
; This copies the selected character's stats
; into memory for use later, but also a bunch
; of other unrelated crap like the
; Bonus Chance slot reels (???) and
; god knows what else.
;
CopyCharacterStatsAndStuff:

	LDX zCurrentCharacter
	LDY StatOffsets, X
	LDX #$00
loc_BANKA_8458:
	LDA CharacterStats, Y
	STA iStatsRAM, X
	INY
	INX
	CPX #$17
	BCC loc_BANKA_8458

	LDA zCurrentCharacter
	ASL A
	ASL A
	TAY
	LDX #$00
loc_BANKA_846B:
	LDA CharacterPalette, Y
	STA iBackupPlayerPal, X
	INY
	INX
	CPX #$04
	BCC loc_BANKA_846B

	LDY #$4C
loc_BANKA_8479:
	LDA PlayerSelectPalettes, Y
	STA iStartingPalettes, Y
	DEY
	CPY #$FF
	BNE loc_BANKA_8479

	LDY #(TitleCardText - BonusChanceReel1Order) - 1
loc_BANKA_8486:
	LDA BonusChanceReel1Order, Y
	STA mReelBuffer, Y
	DEY
	CPY #$FF
	BNE loc_BANKA_8486

	LDY #$63
loc_BANKA_8493:
	LDA TitleCardText, Y
	STA wTitleCardBuffer, Y
	DEY
	CPY #$FF
	BNE loc_BANKA_8493

	; Copy object collision hitbox table
	LDY #$4F
loc_BANKA_84AB:
	LDA ObjectCollisionHitboxLeft, Y
	STA wColBoxLeft, Y
	DEY
	BPL loc_BANKA_84AB

	; Copy flying carpet acceleration table
	LDY #$03
loc_BANKA_84B6:
	LDA FlyingCarpetAcceleration, Y
	STA wCarpetVelocity, Y
	DEY
	BPL loc_BANKA_84B6

	; Copy object collision type table
	LDY #$49
loc_BANKA_84C1:
	LDA EnemyPlayerCollisionTable, Y
	STA wObjectInteractionTable, Y
	DEY
	BPL loc_BANKA_84C1

	; Copy end of level door PPU data to RAM
	;
	; The fact that it's in RAM is actually taken advantage of when defeating Clawgrip, since the
	; door needs to be drawn in a slightly different spot.
	LDY #$20
loc_BANKA_84CC:
	LDA EndOfLevelDoor, Y
	STA wHawkDoorBuffer, Y
	DEY
	BPL loc_BANKA_84CC

	; Copy Wart's OAM address table
	LDY #$06
loc_BANKA_84D7:
	LDA WartOAMOffsets, Y
	STA wMamuOAMOffsets, Y
	DEY
	BPL loc_BANKA_84D7
; only arrive here if we flag hasn't been set since corruption/build date
NeedToCopyWarpScreen:
	LDY #WarpCharacterStills - WarpAllStarsLayout - 1
CopyWarpScreenPage1:
	LDA WarpAllStarsLayout, Y
	STA mWarpScreenLayout, Y
	DEY
	CPY #$ff
	BNE CopyWarpScreenPage1
	LDY #WarpAllStarsLayoutEND - WarpCharacterStills
CopyWarpScreenPage2:
	LDA WarpCharacterStills, Y
	STA mWarpCharacterStills, Y
	DEY
	CPY #$ff
	BNE CopyWarpScreenPage2
CopyPalettes:
	LDY #$02
CopyWarpPalEntry:
	LDA WarpPaletteEntry, Y
	STA mWarpPalettes, Y
	DEY
	BPL CopyWarpPalEntry
	LDA #0
	LDY #mWarpObjPals - mWarpBGPals
CopyWarpPals:
	DEY
	STA mWarpPalettes, Y
	BNE CopyWarpPals
	STA mWarpPalTerminator
	RTS
