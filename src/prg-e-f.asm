;
; Bank E & Bank F
; ===============
;
; What's inside: Lots of game logic.
;
;   - Joypad input reading
;   - PPU update routines
;   - Game initialization routines
;   - Title card display routines
;   - Area initialization routines
;   - Music cue routines
;   - Character select (sprite data, palettes, logic)
;   - Bonus chance (sprite data, palettes, logic)
;   - Game Over / Continue screen
;   - Pause screen
;   - Health logic
;   - Bottomless pit death logic
;   - Bounding box data for collisions
;   - Save logic
;   - and more!
;

; PPU update buffers used to update the screen
ScreenUpdateBufferPointers:
	.dw iPPUBuffer ; Default screen update buffer
	.dw iBonusNotes
	.dw iStartingPalettes
	.dw PPUBuffer_CharacterSelect
	.dw PPUBuffer_TitleCard
	.dw PPUBuffer_Text_Game_Over
	.dw mContinueScreenBuffer
	.dw PPUBuffer_Text_Retry
	.dw wTitleCardBuffer
	.dw mLDPBonusChanceBuffer ; Doki Doki Panic leftover
	.dw mLDPBonusChanceNA
	.dw mLDPBonusChanceABtn
	.dw mLDPBonusChanceLifeDisplay
	.dw mPauseBuffer
	.dw mTextDeletionPause
	.dw mTextDeletionBonus
	.dw mTextDeletionABtn
	.dw mTextDeletionBonusUnused
	.dw wWorldWarpDestination
	.dw wContinueScreenBullets
	.dw wHawkDoorBuffer
	.dw PPUBuffer_TitleCardLeftover
	.dw PPUBuffer_PauseExtraLife
	.dw wBonusLayoutBuffer
	.dw PauseOptionData
	.dw PauseOptionPalette1
	.dw PauseOptionPalette2
	.dw PauseOptionPalette3
	.dw mLDPBonusChanceCoinService
	.dw mWarpScreenLayout
	.dw WarpPaletteDataBlack
	.dw WarpPaletteFade3
	.dw WarpPaletteFade2
	.dw WarpPaletteFade1
	.dw WarpPalettes
	.dw mBonusChanceFlashUpdate

PPUBuffer_CharacterSelect:
	.db $21, $49, $06, $E9, $E5, $DE, $DA, $EC, $DE ; PLEASE
	.db $21, $50, $06, $EC, $DE, $E5, $DE, $DC, $ED ; SELECT
	.db $21, $8C, $06, $E9, $E5, $DA, $F2, $DE, $EB ; PLAYER
	.db $20, $00, $20, $B7, $B8, $B7, $B8, $B7, $B8, $B7, $B8, $B7, $B8, $B7, $B8 ; Probably the checkerboard diamonds or w/e
	.db $B7, $B8, $B7, $B8, $B7, $B8, $B7, $B8, $B7, $B8, $B7, $B8, $B7, $B8, $B7 ; $F
	.db $B8, $B7, $B8, $B7, $B8 ; $1E
	.db $20, $20, $20, $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA
	.db $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA, $B9 ; $F
	.db $BA, $B9, $BA, $B9, $BA ; $1E
	.db $23, $80, $20, $B7, $B8, $B7, $B8, $B7, $B8, $B7, $B8, $B7, $B8, $B7, $B8
	.db $B7, $B8, $B7, $B8, $B7, $B8, $B7, $B8, $B7, $B8, $B7, $B8, $B7, $B8, $B7 ; $F
	.db $B8, $B7, $B8, $B7, $B8 ; $1E
	.db $23, $A0, $20, $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA
	.db $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA, $B9, $BA, $B9 ; $F
	.db $BA, $B9, $BA, $B9, $BA ; $1E
	.db $20, $00, $9E, $B7, $B9, $B7, $B9, $B7, $B9, $B7, $B9, $B7, $B9, $B7, $B9
	.db $B7, $B9, $B7, $B9, $B7, $B9, $B7, $B9, $B7, $B9, $B7, $B9, $B7, $B9, $B7 ; $F
	.db $B9, $B7, $B9 ; $1E
	.db $20, $01, $9E, $B8, $BA, $B8, $BA, $B8, $BA, $B8, $BA, $B8, $BA, $B8, $BA
	.db $B8, $BA, $B8, $BA, $B8, $BA, $B8, $BA, $B8, $BA, $B8, $BA, $B8, $BA, $B8 ; $F
	.db $BA, $B8, $BA ; $1E
	.db $20, $1E, $9E, $B7, $B9, $B7, $B9, $B7, $B9, $B7, $B9, $B7, $B9, $B7, $B9
	.db $B7, $B9, $B7, $B9, $B7, $B9, $B7, $B9, $B7, $B9, $B7, $B9, $B7, $B9, $B7 ; $F
	.db $B9, $B7, $B9 ; $1E
	.db $20, $1F, $9E, $B8, $BA, $B8, $BA, $B8, $BA, $B8, $BA, $B8, $BA, $B8, $BA
	.db $B8, $BA, $B8, $BA, $B8, $BA, $B8, $BA, $B8, $BA, $B8, $BA, $B8, $BA, $B8 ; $F
	.db $BA, $B8, $BA ; $1E
	.db $20, $42, $5C, $FD
	.db $20, $62, $5C, $FD
	.db $20, $47, $05, $00, $01, $02, $03,4
	.db $20, $54, $05, $05, $06, $07, $08,9
	.db $20, $63, $0A, $A,$0B, $C,$0D, $E,$0F, $10, $11, $12, $13
	.db $20, $73, $0A, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D
	.db $20, $82, $1C, $1E, $1F, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29
	.db $FD, $FD, $FD, $FD, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34 ; $F
	.db $35 ; $1E
	.db $20, $A2, $06, $36, $37, $38, $39, $3A, $3B
	.db $20, $AB, $0A, $3C, $3D, $3E, $3F, $40, $43, $44, $45, $46, $47
	.db $20, $B8, $06, $48, $49, $4A, $4B, $4C, $4D
	.db $20, $C2, $05, $4E, $4F, $50, $51, $52
	.db $20, $D9, $05, $53, $54, $55, $56, $57
	.db $20, $E2, $04, $58, $59, $5A, $5B
	.db $20, $E6, $CD, $5C
	.db $20, $F9, $CD, $5C
	.db $20, $FA, $04, $5D, $5E, $5F, $60
	.db $21, $02, $83, $61, $64, $67
	.db $21, $03, $8B, $62, $65, $68, $6A, $6C, $6F, $72, $75, $78, $7B, $7E
	.db $21, $04, $94, $63, $66, $69, $6B, $6D, $70, $73, $76, $79, $7C, $7F, $81
	.db $82, $83, $84, $85, $86, $87, $88, $89 ; $F
	.db $21, $85, $89, $6E, $71, $74, $77, $7A, $7D, $80, $6E, $6E
	.db $21, $9A, $89, $97, $9A, $9D, $BB, $A0, $A3, $A6, $A9, $AB
	.db $21, $1B, $94, $8C, $8F, $92, $95, $98, $9B, $9E, $BC, $A1, $A4, $A7, $AA
	.db $AC, $AD, $AE, $B0, $B1, $B2, $B3, $B4 ; $F
	.db $21, $1C, $8B, $8D, $90, $93, $96, $99, $9C, $9F, $BD, $A2, $A5, $A8
	.db $21, $1D, $83, $8E, $91, $94
	.db $21, $62, $D1, $FD
	.db $21, $7D, $D1, $FD
	.db $22, $63, $C9, $FD, $22, $7C, $C9, $FD, $22, $86, $82, $8A, $8B, $22, $99
	.db $82, $8A, $8B ; $F
	.db $00

PPUBuffer_TitleCard:
	.db $23, $C0, $09
	.db $3E, $0E, $0E, $0E, $0E, $0E, $0E, $8E, $32
	.db $23, $CF, $01, $8C
	.db $23, $D0, $10
	.db $32, $00, $50, $50, $50, $10, $00, $8C, $32, $00, $00, $05, $01, $00, $00, $8C
	.db $23, $E0, $09
	.db $32, $00, $00, $0E, $00, $00, $00, $8C, $32
	.db $23, $EF, $01, $8C
	.db $23, $F0, $06
	.db $32, $00, $50, $50, $50, $50
	.db $23, $F7, $09
	.db $8C, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E
	.db $24, $00, $60, $FF
	.db $24, $20, $60, $FF
	.db $24, $40, $60, $FF
	.db $24, $60, $60, $FF
	.db $27, $40, $60, $FF
	.db $27, $60, $60, $FF
	.db $27, $80, $60, $FF
	.db $27, $A0, $60, $FF
	.db $24, $80, $D6, $FF
	.db $24, $81, $D6, $FF
	.db $24, $82, $D6, $FF
	.db $24, $9D, $D6, $FF
	.db $24, $9E, $D6, $FF
	.db $24, $9F, $D6, $FF
	.db $24, $83, $01, $D0
	.db $24, $9C, $01, $D8
	.db $24, $84, $58, $FB
	.db $24, $A3, $D4, $D1
	.db $24, $BC, $D4, $D7
	.db $24, $A4, $58, $FB
	.db $24, $C4, $58, $FB
	.db $24, $E4, $58, $FB
	.db $25, $04, $58, $FB
	.db $25, $24, $58, $FB
	.db $25, $44, $58, $FB
	.db $25, $64, $58, $FB
	.db $25, $84, $58, $FB
	.db $25, $A4, $58, $FB
	.db $25, $C4, $58, $FB
	.db $25, $E4, $58, $FB
	.db $26, $04, $58, $FB
	.db $26, $24, $58, $FB
	.db $26, $44, $58, $FB
	.db $26, $64, $58, $FB
	.db $26, $84, $58, $FB
	.db $26, $A4, $58, $FB
	.db $26, $C4, $58, $FB
	.db $26, $E4, $58, $FB
	.db $27, $23, $01, $D2
	.db $27, $3C, $01, $D6
	.db $27, $24, $58, $D3
	.db $27, $C8, $08
	.db $44, $FF, $BF, $AF, $AF, $AF, $FF, $11
	.db $27, $D0, $10
	.db $44, $BF, $AF, $AF, $AF, $AF, $EF, $11, $44, $FF, $FF, $FF, $FF, $FF, $FF, $11
	.db $27, $E0, $10
	.db $44, $FF, $FF, $FF, $FF, $FF, $FF, $11, $44, $FF, $FF, $FF, $FF, $FF, $AF, $11
	.db $27, $F0, $08
	.db $44, $05, $05, $05, $05, $05, $05, $01
	.db $27, $04, $58, $FB
	.db $00

; nametable attribute data
PPUBuffer_PauseExtraLife:
	.db $27, $EA, $05
	.db $AA, $AA, $AA, $AA, $AA

; This draws two columns of black tiles along the right side of the nametable to the left of the
; title card, which was the character/level select in Doki Doki Panic. In SMB2, it remains unused.
PPUBuffer_TitleCardLeftover:
	.db $20, $1E, $9E
	.db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	.db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	.db $20, $1F, $9E
	.db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	.db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	.db $23, $C7, $01, $00
	.db $23, $CF, $01, $00
	.db $23, $D7, $01, $00
	.db $23, $DF, $01, $00
	.db $23, $E7, $01, $00
	.db $23, $EF, $01, $00
	.db $23, $F7, $01, $00
	.db $23, $FF, $01, $00
	.db $00

; This table defines which level starts each world.
; The difference between the value of each world indicates how many worlds are
; in the level, which is why there is a slot for an 8th world, even though no
; such world is playable!
WorldStartingLevel:
	.db $00
	.db $03
	.db $06
	.db $09
	.db $0C
	.db $0F
	.db $12
	.db $14

PlayerSelectMarioSprites1:
	.db $8F, $00, $00, $48
	.db $8F, $00, $40, $50
	.db $9F, $02, $00, $48
	.db $9F, $02, $40, $50

PlayerSelectLuigiSprites1:
	.db $8F, $04, $01, $68
	.db $8F, $04, $41, $70
	.db $9F, $06, $01, $68
	.db $9F, $06, $41, $70

PlayerSelectToadSprites1:
	.db $8F, $08, $02, $88
	.db $8F, $08, $42, $90
	.db $9F, $0A, $02, $88
	.db $9F, $0A, $42, $90

PlayerSelectPrincessSprites1:
	.db $8F, $0C, $03, $A8
	.db $8F, $0C, $43, $B0
	.db $9F, $0E, $03, $A8
	.db $9F, $0E, $43, $B0

PlayerSelectMarioSprites2:
	.db $8F, $10, $00, $48
	.db $8F, $12, $00, $50
	.db $9F, $14, $00, $48
	.db $9F, $16, $00, $50

PlayerSelectLuigiSprites2:
	.db $8F, $18, $01, $68
	.db $8F, $1A, $01, $70
	.db $9F, $1C, $01, $68
	.db $9F, $1E, $01, $70

PlayerSelectToadSprites2:
	.db $8F, $20, $02, $88
	.db $8F, $22, $02, $90
	.db $9F, $24, $02, $88
	.db $9F, $26, $02, $90

PlayerSelectPrincessSprites2:
	.db $8F, $28, $03, $A8
	.db $8F, $2A, $03, $B0
	.db $9F, $2C, $03, $A8
	.db $9F, $2E, $03, $B0

PlayerSelectSpriteIndexes:
	.db $00, $30, $20, $10

BonusChanceCherrySprite:
	.db $5F, $05, $01, $58
	.db $5F, $07, $01, $60

BonusChanceStarSprite:
	.db $5F, $09, $01, $58
	.db $5F, $09, $41, $60

BonusChanceVeggieSprite:
	.db $5F, $0B, $01, $58
	.db $5F, $0B, $41, $60

BonusChanceSnifitSprite:
	.db $5F, $A7, $81, $58
	.db $5F, $A9, $81, $60

BonusChanceSlotCoinSprite:
	.db $5F, $01, $01, $58
	.db $5F, $03, $01, $60

PlayerSelectSpritePalettesDark:
	.db $3F, $10, $10 ; PPU Data
	.db $0F, $22, $12, $01
	.db $0F, $22, $12, $01
	.db $0F, $22, $12, $01
	.db $0F, $22, $12, $01

PlayerSelectPaletteOffsets:
	.db (PlayerSelectSpritePalettes_Mario - PlayerSelectSpritePalettes)
	.db (PlayerSelectSpritePalettes_Princess - PlayerSelectSpritePalettes)
	.db (PlayerSelectSpritePalettes_Toad - PlayerSelectSpritePalettes)
	.db (PlayerSelectSpritePalettes_Luigi - PlayerSelectSpritePalettes)

PlayerSelectSpritePalettes:
PlayerSelectSpritePalettes_Mario:
	.db $3F, $10, $04
	.db $0F, $27, $16, $01
PlayerSelectSpritePalettes_Luigi:
	.db $3F, $14, $04
	.db $0F, $36, $2A, $01
PlayerSelectSpritePalettes_Toad:
	.db $3F, $18, $04
	.db $0F, $27, $30, $01
PlayerSelectSpritePalettes_Princess:
	.db $3F, $1C, $04
	.db $0F, $36, $25, $07

TitleCardPalettes:
	.db $3F, $00, $20 ; PPU data
	.db $38, $30, $1A, $0F
	.db $38, $38, $0F, $0F
	.db $38, $17, $17, $38
	.db $38, $28, $18, $08
	.db $38, $30, $27, $01
	.db $38, $37, $27, $06
	.db $38, $25, $36, $06
	.db $38, $12, $36, $01
	.db $00

BonusChanceSpritePalettes:
	.db $0F, $37, $16, $0F
	.db $0F, $37, $16, $0F
	.db $0F, $37, $16, $0F
	.db $0F, $37, $16, $0F


;
; Load A with an index and call this to
; jump to a pointer from the table directly
; after the call.
;
JumpToTableAfterJump:
	ASL A
	TAY
	PLA
	STA z0a
	PLA
	STA z0b
	INY
	LDA (z0a), Y
	STA z0c
	INY
	LDA (z0a), Y
	STA z0d
	JMP (z0c)


BlackAndWhitePalette:
	.db $0F, $30, $30, $0F


SetBlackAndWhitePalette:
	LDA PPUSTATUS
	LDA #$3F
	LDY #$00
	STA PPUADDR
	STY PPUADDR

SetBlackAndWhitePalette_Loop:
	TYA
	AND #$03
	TAX
	LDA BlackAndWhitePalette, X
	STA PPUDATA
	INY
	CPY #$14
	BCC SetBlackAndWhitePalette_Loop
	RTS


SetScrollXYTo0:
	LDA #$00
	STA zPPUScrollY
	STA zPPUScrollX
	STA zYScrollPage
	STA zXScrollPage
	RTS


;
; Clears the screen and resets the scroll position for the title card
;
; This is used for the character select screen as well, but that has a few PPU
; changes of its own.
;
ResetScreenForTitleCard:
	JSR EnableNMI

	JSR WaitForNMI_TurnOffPPU

	JSR SetScrollXYTo0

	LDA #ScreenUpdateBuffer_RAM_TitleCardPalette
	STA zScreenUpdateIndex
	JSR WaitForNMI

	LDA #VMirror
	JSR ChangeNametableMirroring

	JMP ClearNametablesAndSprites


;
; Enables NMI and draws the background of the pause screen
;
EnableNMI_PauseTitleCard:
	JSR EnableNMI

	JSR WaitForNMI_TurnOffPPU

	LDA #Stack100_Menu
	STA iStack
	LDA #ScreenUpdateBuffer_CharacterSelect
	STA zScreenUpdateIndex
	JSR WaitForNMI

	LDA #ScreenUpdateBuffer_TitleCard
	STA zScreenUpdateIndex

	JMP WaitForNMI


;
; Draws world info for the title card and pause screens
;
; ##### Input
; - `X`: iCurrentWorld / sSavedWorld
; - `Y`: iCurrentLvl (not actually used)
;
DisplayLevelTitleCardText:
	; Level number (unused)
	; In Doki Doki Panic, this was displayed as a page number, keeping with
	; the storybook motif.
	INY
	TYA
	JSR GetTwoDigitNumberTiles

	; World number
	INX
	TXA
	ORA #$D0
	STA wTitleCardWorld

	; Extra Life number
	LDY iExtraMen
	DEY
	TYA
	JSR GetTwoDigitNumberTiles
	STY wExtraLifeCounter
	STA wExtraLifeCounter + 1

	; Reset level dots
	LDY #$06
	LDA #$FB
DisplayLevelTitleCardText_ResetLevelDotsLoop:
	STA wTitleCardDots, Y ; writes to $7171
	DEY
	BPL DisplayLevelTitleCardText_ResetLevelDotsLoop

	; Level number
	LDY iCurrentWorld
	LDA iCurrentLvl
	SEC
	SBC WorldStartingLevel, Y
	STA iCurrentLvlRelative
	CLC
	ADC #$D1
	STA wTitleCardLevel

	; Use the difference between the starting level of the next world and this
	; world to determine how many dots to show for the levels in the world.
	LDA WorldStartingLevel + 1, Y
	SEC
	SBC WorldStartingLevel, Y
	STA z03

	; Level dots
	LDX #$00
	LDY #$00
DisplayLevelTitleCardText_DrawLevelDotsLoop:
	LDA #$FD ; other level
	CPX iCurrentLvlRelative
	BNE DisplayLevelTitleCardText_DrawLevelDot

	LDA #$F6 ; current level

DisplayLevelTitleCardText_DrawLevelDot:
	STA wTitleCardDots, Y
	INY
	INY
	INX
	CPX z03
	BCC DisplayLevelTitleCardText_DrawLevelDotsLoop

	; Draw the card
	LDA #ScreenUpdateBuffer_RAM_TitleCardText
	STA zScreenUpdateIndex
	RTS


;
; It's game time, pal
;
SetStack100Gameplay:
	LDA #Stack100_Gameplay
	STA iStack
	RTS


;
; Resets various level-related variables to $00
;
InitializeSomeLevelStuff:
	LDA #$00
	STA iCurrentLvlArea
	STA iCurrentLevelArea_Init
	STA iCurrentLvlEntryPage
	STA sSavedLvlEntryPage
	STA iCurrentLevelEntryPage_Init
	STA iTransitionType
	STA iTransitionType_Init
	STA zPlayerState
	STA iPlayer_State_Init
	STA iSubAreaFlags
	STA iInJarType
	STA iWatchTimer
IFDEF SIXTEEN_BIT_WATCH_TIMER
	STA iWatchTimer + 1
ENDIF
	STA iCurrentPlayerSize
	RTS


PlayerSelectArrowTop:
	.db $C9
	.db $D5
	.db $D1
	.db $CD
PlayerSelectArrowBottom:
	.db $E9
	.db $F5
	.db $F1
	.db $ED


;
; Displays the level title card and prepares the level to start by loading
; the world tiles, PRG banks A/B, and copying character data
;
DisplayLevelTitleCardAndMore:
	JSR WaitForNMI_TurnOffPPU

	JSR DisableNMI

	; Set the scrolling mirror over to the right side...
	; This Isn't quiiite correct, and causes a bunch of
	; crud to show on the very left pixel -- residue
	; from the character select screen
	LDA #$FF
	STA zPPUScrollX
	JSR ChangeTitleCardCHR

	LDA #PRGBank_A_B
	JSR ChangeMappedPRGBank

	JSR CopyCharacterStatsAndStuff

	JSR EnableNMI

	JSR HideAllSprites

	JSR PreLevelTitleCard

	JSR LoadWorldCHRBanks

	LDA #PRGBank_A_B
	JSR ChangeMappedPRGBank

	JSR CopyCharacterStatsAndStuff

	JMP EnableNMI


;
; Runs the Character Select menu
;
DoCharacterSelectMenu:
	JSR WaitForNMI

	LDA #$00
	STA PPUMASK
	JSR DisableNMI

	JSR LoadCharacterSelectCHRBanks

	LDA #PRGBank_A_B
	JSR ChangeMappedPRGBank

	JSR CopyCharacterStatsAndStuff

	JSR ResetScreenForTitleCard

	LDA iCHR_A5
	CMP #$A5
	BEQ loc_BANKF_E2B2

	LDA #PRGBank_A_B
	JSR ChangeMappedPRGBank

	LDA #$A5
	STA iCHR_A5

loc_BANKF_E2B2:
	JMP LoadCHRSelect

; ---------------------------------------------------------------------------

loc_BANKF_E2E8:
	LDA zInputBottleneck
	AND #ControllerInput_Right | ControllerInput_Left
	BNE CharacterSelect_ChangeCharacter

	JMP CharacterSelectMenuLoop

; ---------------------------------------------------------------------------

CharacterSelect_ChangeCharacter:
	LDA zInputBottleneck
	AND #ControllerInput_Right
	BEQ loc_BANKF_E2FE

	DEC zCurrentCharacter
	LDA #SoundEffect2_CoinGet
	STA iPulse2SFX

loc_BANKF_E2FE:
	LDA zInputBottleneck
	AND #ControllerInput_Left
	BEQ loc_BANKF_E30B

	INC zCurrentCharacter
	LDA #SoundEffect2_CoinGet
	STA iPulse2SFX

loc_BANKF_E30B:
	LDA zCurrentCharacter
	AND #$03
	STA zCurrentCharacter

loc_BANKF_E311:
	LDY #$00
	LDA #$21
	STA iPPUBuffer
	LDA #$C9
	STA iPPUBuffer + 1
	LDA #$4F
	STA iPPUBuffer + 2
	LDA #$FB
	STA iPPUBuffer + 3
	LDA #$21
	STA iPPUBuffer + 4
	LDA #$E9
	STA iPPUBuffer + 5
	LDA #$4F
	STA iPPUBuffer + 6
	LDA #$FB
	STA iPPUBuffer + 7
	LDY zCurrentCharacter
	LDA #$21
	STA iPPUBuffer + 8
	LDA PlayerSelectArrowTop, Y
	STA iPPUBuffer + 9
	LDA #$02
	STA iPPUBuffer + 10
	LDA #$BE
	STA iPPUBuffer + 11
	LDA #$C0
	STA iPPUBuffer + 12
	LDA #$21
	STA iPPUBuffer + 13
	LDA PlayerSelectArrowBottom, Y
	STA iPPUBuffer + 14
	LDA #$02
	STA iPPUBuffer + 15
	LDA #$BF
	STA iPPUBuffer + 16
	LDA #$C1
	STA iPPUBuffer + 17
	LDA #$00
	STA iPPUBuffer + 18
	JSR WaitForNMI_TurnOnPPU

	LDX #$12
	LDY #$00

loc_BANKF_E37D:
	LDA PlayerSelectSpritePalettesDark, Y
	STA iPPUBuffer, Y
	INY
	DEX
	BPL loc_BANKF_E37D

	LDA #$06
	STA z0a
	LDX zCurrentCharacter
	LDA PlayerSelectPaletteOffsets, X
	TAX

loc_BANKF_E391:
	LDA PlayerSelectSpritePalettes, X
	STA iPPUBuffer, Y
	INY
	INX
	DEC z0a
	BPL loc_BANKF_E391

	LDA #$00
	STA iPPUBuffer, Y

CharacterSelectMenuLoop:
	JSR WaitForNMI_TurnOnPPU

	LDA zInputBottleneck
	AND #ControllerInput_A
	BNE loc_BANKF_E3AE

	JMP loc_BANKF_E2E8

; ---------------------------------------------------------------------------

loc_BANKF_E3AE:
	LDA #Hill_Select
	STA iHillSFX
	LDX iCurrentWorld
	LDY iCurrentLvl
	JSR DisplayLevelTitleCardText

	LDA #$40
	STA z10
	JSR WaitForNMI

	LDX #$F
	LDA zCurrentCharacter
	TAY
	LDA PlayerSelectSpriteIndexes, Y
	TAY

loc_BANKF_E3CC:
	LDA PlayerSelectMarioSprites2, Y
	STA iVirtualOAM + $10, Y
	INY
	DEX
	BPL loc_BANKF_E3CC

loc_BANKF_E3D6:
	JSR WaitForNMI

	DEC z10
	BPL loc_BANKF_E3D6

	LDY #$3F

loc_BANKF_E3DF:
	LDA PlayerSelectMarioSprites1, Y
	STA iVirtualOAM + $10, Y
	DEY
	BPL loc_BANKF_E3DF

	LDA #$40
	STA z10

loc_BANKF_E3EC:
	JSR WaitForNMI

	DEC z10
	BPL loc_BANKF_E3EC

	LDA #Music_StopMusic
	STA iMusicQueue
	RTS


;
; This starts the game once `RESET` has done its thing.
; We also come here after choosing "RETRY" from the game over menu.
;
StartGame:
	LDA #$00
	STA PPUMASK
	JSR DisableNMI

	LDA #PRGBank_Music_3
	ORA #$80
	STA iMusicBank
	LDA #PRGBank_0_1
	STA iMainGameState
	JSR ChangeMappedPRGBank

	JSR TitleScreen ; The whole title screen is a subroutine, lol

	LDA #0
	STA mContinueFlag

; We return here after picking "CONTINUE" from the game over menu.
ContinueGame:
	LDA sExtraMen
	STA iExtraMen

GoToWorldStartingLevel:
	LDX sSavedWorld
	STX iCurrentWorld
	LDY sLifeUpEventFlag
	STY iLifeUpEventFlag
	LDY WorldStartingLevel, X
	CPY sSavedLvl
	BEQ GoToWorldStartingLevel_SaveMatch

	LDA mContinueFlag
	BNE GoToWorldStartingLevel_SaveMatch

	LDY sSavedLvl

GoToWorldStartingLevel_SaveMatch:
	STY iCurrentLvl
	STY sSavedLvl
	STY iCurrentLevel_Init
	JSR DoCharacterSelectMenu

	JSR InitializeSomeLevelStuff

	JSR DisplayLevelTitleCardAndMore

	LDA #$FF
	STA iMusicID
	BNE StartLevel ; Branch always

CharacterSelectMenu:
	JSR DoCharacterSelectMenu

StartLevelAfterTitleCard:
	JSR DisplayLevelTitleCardAndMore

StartLevel:
	JSR WaitForNMI_TurnOffPPU

	LDA #$B0
	ORA zXScrollPage
	LDY zScrollCondition
	BNE StartLevel_SetPPUCtrlMirror

	AND #$FE
	ORA zYScrollPage

StartLevel_SetPPUCtrlMirror:
	STA zPPUControl
	STA PPUCTRL
	LDA #Stack100_Transition
	STA iStack
	LDA #PRGBank_8_9
	JSR ChangeMappedPRGBank

	JSR CopyLevelDataToMemory

	LDA #PRGBank_6_7
	JSR ChangeMappedPRGBank

	JSR GetCurrentArea

	LDA zScrollCondition
	BEQ VerticalLevel_Loop

HorizontalLevel_Loop:
	JSR WaitForNMI

	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR InitializeAreaHorizontal

	LDA zBreakStartLevelLoop
	BEQ HorizontalLevel_Loop

	LDA #$00
	STA zBreakStartLevelLoop
	JSR WaitForNMI_TurnOnPPU

HorizontalLevel_CheckScroll:
	JSR WaitForNMI

	; Disable pause detection while scrolling
	LDA zScrollArray
	AND #%00000100
	BNE HorizontalLevel_CheckSubArea

	LDA zInputBottleneck
	AND #ControllerInput_Start
	BEQ HorizontalLevel_CheckSubArea

	; Disable pause detection while in rocket
	LDA iIsInRocket
	CMP #$01
	BEQ HorizontalLevel_CheckSubArea

	; Disable pause detection while going through a door
	LDA iDoorAnimTimer
	BNE HorizontalLevel_CheckSubArea

	JMP ShowPauseScreen

HorizontalLevel_CheckSubArea:
	LDA iSubAreaFlags
	BEQ HorizontalLevel_ProcessFrame

	JMP InitializeSubArea

HorizontalLevel_ProcessFrame:
	JSR HideAllSprites

	JSR RunFrame_Horizontal

	LDY iGameMode
	BEQ HorizontalLevel_CheckTransition

	JMP ResetAreaAndProcessGameMode

HorizontalLevel_CheckTransition:
	LDA iAreaTransitionID
	BEQ HorizontalLevel_CheckScroll

	JSR FollowCurrentAreaPointer

	JSR RememberAreaInitialState

	LDA #$00
	STA iAreaTransitionID
	JMP StartLevel


VerticalLevel_Loop:
	JSR WaitForNMI

	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR InitializeAreaVertical

	LDA zBreakStartLevelLoop
	BEQ VerticalLevel_Loop

	LDA #$00
	STA zBreakStartLevelLoop
	JSR WaitForNMI_TurnOnPPU

VerticalLevel_CheckScroll:
	JSR WaitForNMI

	; Disable pause detection while scrolling
	; This is likely a work-around to avoid getting the PPU into a weird state
	; due to conflicts between the pause screen and attempting to draw the part
	; of the area scrolling into view.
	LDA zScrollArray
	AND #%00000100
	BNE VerticalLevel_ProcessFrame

	; Disable pause detection while going through a door
	LDA iDoorAnimTimer
	BNE VerticalLevel_ProcessFrame

	LDA zInputBottleneck
	AND #ControllerInput_Start
	BNE ShowPauseScreen

VerticalLevel_ProcessFrame:
	JSR HideAllSprites

	JSR RunFrame_Vertical

	LDY iGameMode
	BEQ VerticalLevel_CheckTransition

	JMP ResetAreaAndProcessGameMode

VerticalLevel_CheckTransition:
	LDA iAreaTransitionID
	BEQ VerticalLevel_CheckScroll

	JSR FollowCurrentAreaPointer

	JSR RememberAreaInitialState

	LDA #$00
	STA iAreaTransitionID
	JMP StartLevel


;
; Pauses the game
;
ShowPauseScreen:
	LDA #PauseOption_Continue
	STA iStack + 1
	JSR PauseScreen_ExtraLife

	LDA #ScreenUpdateBuffer_RAM_PauseText
	STA zScreenUpdateIndex
	; used when running sound queues
	LDA #Stack100_Pause
	STA iStack
	LDA #DPCM_Pause
	STA iDPCMSFX

	JSR WaitForNMI

	LDA #ScreenUpdateBuffer_PauseOptions
	STA zScreenUpdateIndex
	JSR WaitForNMI

	; ScreenUpdateBuffer_PauseOptionsAttribute1
	INC zScreenUpdateIndex

PauseScreenLoop:
DoSuicideCheatCheck:
	JSR WaitForNMI_TurnOnPPU

	LDA zPlayerState ; Check if the player is already dying
	CMP #PlayerState_Dying
	BEQ PauseScreenExitCheck ; If so, skip the suicide code check

	LDA zInputCurrentState + 1 ; Check for suicide code
	CMP #ControllerInput_Up | ControllerInput_B | ControllerInput_A ; Up + A + B
	BNE PauseScreenExitCheck ; Not being held! Nothing to see here

	JSR KillPlayer ; KILL THYSELF

PauseScreenExitCheck:
	JSR ChooseSaveChoiceAttribute
	TYA
	CLC
	ADC #ScreenUpdateBuffer_PauseOptions + 1
	STA zScreenUpdateIndex

	LDY zInputBottleneck
	TYA
	AND #ControllerInput_Start
	BNE HidePauseScreen

	TYA
	AND #ControllerInput_A
	BEQ PauseScreenLoop

	LDY iStack + 1
	DEY
	BMI HidePauseScreen
	DEY
	BMI SaveAndHidePauseScreen
	JMP StopOperationAndReset

SaveAndHidePauseScreen:
	LDA #Stack100_PauseSave
	STA iStack

;
; Unpauses the game
;
HidePauseScreen:
	JSR WaitForNMI_TurnOffPPU

	JSR LoadWorldCHRBanks

	LDA #PRGBank_6_7
	JSR ChangeMappedPRGBank

	JSR LoadCurrentPalette

	JSR WaitForNMI

	JSR SetStack100Gameplay

	JSR HideAllSprites

	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	LDA zPlayerState ; Check if the player is already dying
	CMP #PlayerState_Dying
	BNE HidePauseScreen_SFX

	JMP HidePauseScreen_01

HidePauseScreen_SFX:
	LDA zInputCurrentState
	ORA zInputBottleneck
	AND #$7F
	BNE HidePauseScreen_SFXStart
	LDX iStack + 1
	LDA PauseSounds, X
	STA iDPCMSFX
	JMP HidePauseScreen_01

HidePauseScreen_SFXStart:
	LDA #DPCM_Pause
	STA iDPCMSFX
	JMP HidePauseScreen_01



InitializeSubArea:
	JSR ClearNametablesAndSprites

	LDA #PRGBank_6_7
	JSR ChangeMappedPRGBank

	LDA #$00
	STA iSubspaceCoinCount
	LDA iSubAreaFlags
	CMP #$02
	BEQ InitializeSubspace

InitializeJar:
	LDA #PRGBank_8_9
	JSR ChangeMappedPRGBank

	JSR CopyJarDataToMemory

	JSR CopyEnemyDataToMemory

	LDA #PRGBank_6_7
	JSR ChangeMappedPRGBank

	JMP ClearLayoutAndPokeMusic

InitializeSubspace:
	JSR SubspaceGeneration

loc_BANKF_E5E1:
	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR UseSubareaScreenBoundaries

	JSR EnableNMI

SubArea_Loop:
	JSR WaitForNMI

	JSR sub_BANK0_87AA

	LDA i537
	BEQ SubArea_Loop

	LDA iSubAreaFlags
	CMP #$02
	BEQ loc_BANKF_E606

	LDA #PRGBank_6_7
	JSR ChangeMappedPRGBank

	JSR LoadCurrentPalette

loc_BANKF_E606:
	JSR WaitForNMI_TurnOnPPU

; subspace
loc_BANKF_E609:
	JSR WaitForNMI

	JSR HideAllSprites

	JSR sub_BANKF_F0F9

	LDY iGameMode
	BEQ loc_BANKF_E61A

	JMP ResetAreaAndProcessGameMode

; ---------------------------------------------------------------------------

loc_BANKF_E61A:
	LDA iSubAreaFlags
	BNE loc_BANKF_E609

	LDA iSubspaceCoinCount
	BEQ loc_BANKF_E627

	INC iSubspaceVisitCount

loc_BANKF_E627:
	LDA iCurrentAreaBackup
	STA iCurrentLvlArea
	LDA #PRGBank_6_7
	JSR ChangeMappedPRGBank

	JSR LoadCurrentPalette

	JSR WaitForNMI_TurnOffPPU

	JSR HideAllSprites

	LDY iLevelMusic
	STY iMusicID
	LDA iStarTimer
	BNE loc_BANKF_E64C

	LDA LevelMusicIndexes, Y
	STA iMusicQueue

loc_BANKF_E64C:
	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JMP ExitSubArea


;
; This code resets the level and does whatever else is needed to transition from
; the current `iGameMode` to `GameMode_InGame`.
;
ResetAreaAndProcessGameMode:
	JSR DoAreaReset

	LDY iGameMode
ShowCardAfterTransition:
	LDA #GameMode_InGame
	STA iGameMode
	STA iStarTimer
	STA iLargeVeggieAmount
	STA iCherryAmount
	STA iWatchTimer
IFDEF SIXTEEN_BIT_WATCH_TIMER
	STA iWatchTimer + 1
ENDIF
	DEY ; Initial `iGameMode` minus 1
	BNE ResetAreaAndProcessGameMode_NotTitleCard

  ; `iGameMode` was `$01`
	; Reset from a title card
	STY iCurrentPlayerSize
	JSR LevelInitialization

	LDA #$FF
	STA iMusicID
	; Draw EXTRA LIFE text near top of card
	LDA #$25
	STA wExtraLifeDrawPointer
	LDA #$48
	STA wExtraLifeDrawPointer + 1
	LDA #ScreenUpdateBuffer_TitleCardLeftover
	STA iCardScreenID
	JSR PauseScreen_Card

AfterDeathJump:
IFNDEF CHARACTER_SELECT_AFTER_DEATH
	JMP StartLevelAfterTitleCard
ELSE
	JMP CharacterSelectMenu
ENDIF


ResetAreaAndProcessGameMode_NotTitleCard:
	LDA #PlayerHealth_2_HP
	STA iPlayerHP
	LDA #$00
	STA iPlayerMaxHP
	STA iKeyUsed
	STA iLifeUpEventFlag
	STA sLifeUpEventFlag
	STA iMushroomFlags
	STA iMushroomFlags + 1
	STA iSubspaceVisitCount
	STA iKills
	DEY ; Initial `iGameMode` minus 2
	BEQ DoGameOverStuff

	JMP ResetAreaAndProcessGameMode_NotGameOver


DoGameOverStuff:
	STY iCurrentPlayerSize
	LDA #Music_GameOver
	STA iMusicQueue
	JSR WaitForNMI_TurnOffPPU

	JSR ChangeTitleCardCHR

	JSR ClearNametablesAndSprites

	JSR SetBlackAndWhitePalette

	JSR SetScrollXYTo0

	JSR EnableNMI

	JSR WaitForNMI_TurnOnPPU

	LDA #ScreenUpdateBuffer_Text_Game_Over
	STA zScreenUpdateIndex
	LDA #$C0
	STA z06

loc_BANKF_E6E6:
	JSR WaitForNMI

	DEC z06
	BNE loc_BANKF_E6E6

	LDY #(BonusChanceUpdateBuffer_BONUS_CHANCE_Unused - PPUBuffer_Text_Continue - 1)
loc_BANKF_E6EF:
	LDA PPUBuffer_Text_Continue, Y
	STA mContinueScreenBuffer, Y
	DEY
	BPL loc_BANKF_E6EF

	; Hide the bullet for RETRY
	LDA #$FB
	STA mContinueScreenRetry
	; Update the number of continues
	LDA #$FB
	STA mContinueScreenContNo
	LDA #$00
	STA z08
	LDA #ScreenUpdateBuffer_RAM_ContinueRetryText
	STA zScreenUpdateIndex

loc_BANKF_E719:
	JSR WaitForNMI

	LDA zInputBottleneck
	AND #ControllerInput_Select
	BEQ loc_BANKF_E747

	LDA z08
	EOR #$01
	STA z08
	ASL A
	ASL A
	TAY
	LDA #$FB
	STA wContinueScreenBullets + 3
	STA wContinueScreenBullets + 7
	LDA #$F6
	STA wContinueScreenBullets + 3, Y
	LDA #ScreenUpdateBuffer_RAM_ContinueRetryBullets
	STA zScreenUpdateIndex

loc_BANKF_E747:
	LDA zInputBottleneck
	AND #ControllerInput_Start
	BEQ loc_BANKF_E719

	LDA z08
	BNE GameOver_Retry

	STA iTotalCoins
	LDA #5
	STA sExtraMen
	INC mContinueFlag
	LDA #Stack100_Save
	STA iStack
	JMP ContinueGame

; ---------------------------------------------------------------------------

GameOver_Retry:
	JMP StartGame


ResetAreaAndProcessGameMode_NotGameOver:
	DEY ; Initial `iGameMode` minus 3
	BNE DoWorldWarp
	JMP EndOfLevel

DoWorldWarp:
	; Show warp screen
	JSR DoNewWarp

	JSR InitializeSomeLevelStuff

	JMP CharacterSelectMenu

; ---------------------------------------------------------------------------

EndOfLevel:
	; Stop the music
	LDA #Music_StopMusic ; Stop music
	STA iMusicQueue

	; Increase current characters "contribution" counter
	LDX zCurrentCharacter
	INC iCharacterLevelCount, X
	INC sContributors, X

	; Check if we've completed the final level
	LDA iCurrentLvl
	CMP #$13
IFNDEF DISABLE_BONUS_CHANCE
	; If not, go to bonus chance and proceed to the next level
EndOfLevelJump:
	BNE EndOfLevelSlotMachine
ENDIF
IFDEF DISABLE_BONUS_CHANCE
	STY iCurrentPlayerSize
EndOfLevelJump:
	BNE GoToNextLevel
ENDIF
	; Otherwise, display the ending
	JMP EndingSceneRoutine

EndOfLevelSlotMachine:
	STY iCurrentPlayerSize
	JSR WaitForNMI_TurnOffPPU

	JSR ClearNametablesAndSprites

	LDA #0
	STA mCoinService

	JSR EnableNMI
	JSR WaitForNMI

	JSR LoadBonusChanceCHRBanks

	LDA #PRGBank_A_B
	JSR ChangeMappedPRGBank
	JMP EndOfLevelSlotMachine_AB

; ---------------------------------------------------------------------------

loc_BANKF_E7F2:
	LDA #$03
	STA zObjectXLo + 3
	STA zObjectXLo + 4
	STA zObjectXLo + 5
	JSR WaitForNMI_TurnOnPPU

loc_BANKF_E7FD:
	LDA iTotalCoins
	BNE StartSlotMachine

GoToNextLevel:
	; Check if this is the last level before the next world
	LDY iCurrentWorld
	LDA WorldStartingLevel + 1, Y
	SEC
	SBC #$01
	CMP iCurrentLvl
	BNE GoToNextLevel_SameWorld

	JSR SetStack100Gameplay

	LDA #$FF
	STA iMusicID
	INC iCurrentWorld
	INC sSavedWorld
	LDY iCurrentWorld
	LDX WorldStartingLevel, Y
	STX sSavedLvl
	JMP GoToWorldStartingLevel

GoToNextLevel_SameWorld:
	JSR FollowCurrentAreaPointer

	; Sanity check that ensure that the world matches the level.
	; Without this, an area pointer at the end of a level that points to a
	; a different world would load incorrectly (eg. 2-1 would load as 1-4).
	; This scenario may not actually occur during normal gameplay.
	LDA iCurrentLvl
	LDY #$00
EnsureCorrectWorld_Loop:
	INY
	CMP WorldStartingLevel, Y
	BCS EnsureCorrectWorld_Loop

	DEY
	STY iCurrentWorld
	STY sSavedWorld

	; Initialize the current area and then go to the character select menu
	LDY iCurrentWorld
	LDA iCurrentLvl
	SEC
	SBC WorldStartingLevel, Y
	STA iCurrentLvlRelative
	LDA iCurrentLvl
	STA iCurrentLevel_Init
	LDA iCurrentLvlArea
	STA iCurrentLevelArea_Init
	LDA iCurrentLvlEntryPage
	STA iCurrentLevelEntryPage_Init
	LDY #$00
	STY iPlayer_State_Init
	STY iTransitionType
	STY iTransitionType_Init
	DEY
	STY iMusicID
	JSR SetStack100Gameplay

	JMP CharacterSelectMenu


StartSlotMachine:
	DEC iTotalCoins
	JSR WaitForNMI

	JSR sub_BANKF_EA68

	LDA #7
	STA zSFXReelTimer
	LDA #$01 ; Set all reel timers
	STA zObjectXLo
	STA zObjectXLo + 1
	STA zObjectXLo + 2
	LSR A ; Set all reels to the first position
	STA zObjectXLo + 6
	STA zObjectXLo + 7
	STA zObjectXLo + 8

SpinSlots:
	JSR WaitForNMI ; $2C-$2E: Reel change timer
	; $2F-$31: Current reel icon
	DEC zSFXReelTimer
	BNE SpinSlots_Handling

	LDA #DPCM_Slot ; Play "reel sound" sound effect
	STA iDPCMSFX
	LDA #7
	STA zSFXReelTimer

SpinSlots_Handling:
	JSR CheckStopReel

	JSR TimedSlotIncrementation

	JSR UpdateSlotSprites

	JSR SlotMachineTextFlashIndex

	LDA BonusChanceUpdateBuffer_PUSH_A_BUTTON, Y
	STA zScreenUpdateIndex
	INC z06
	LDA zObjectXLo ; Reel 1 still active?
	ORA zObjectXLo + 1 ; Reel 2 still active?
	ORA zObjectXLo + 2 ; Reel 3 still active?
	BNE SpinSlots ; If any are still active, go back to waiting

	LDA #ScreenUpdateBuffer_RAM_ErasePushAButtonText
	STA zScreenUpdateIndex
	JSR WaitForNMI

	LDY #$00
	LDX zObjectXLo + 6 ; Load reel 1
	LDA mReelBuffer, X
	BNE CheckReel2Symbol ; Is this reel a cherry?

	INY ; Yes; add one life

CheckReel2Symbol:
	LDX zObjectXLo + 7 ; Load reel 2
	CMP mReelBuffer + 8, X
	BNE AddSlotMachineExtraLives ; Does this match the previous symbol?

	CMP #$00 ; Yes; are they both cherries?
	BNE CheckReel3Symbol ; If no, skip to third reel

	INY ; They are both cherries, add another life or something

CheckReel3Symbol:
	LDX zObjectXLo + 8 ; Load reel 3
	CMP mReelBuffer + 16, X ; Does reel 3 match the previous two?
	BNE AddSlotMachineExtraLives ; HEHE, NNNOPE

	INY ; They all match! Yay! Add 2 extra lives.
	INY
; Cherry count: 3 / Non-cherry: 1
	CMP #$00 ; Were they all cherries?
	BNE MaybeCoins ; Okay, they could be 7s

	DEY ; Yes, 3 lives total

MaybeCoins:
	CMP #$20 ; 7s?
	BNE AddSlotMachineExtraLives ; Nope, all done

	LDY #10 ; just hard code 10 lives, faster that way

AddSlotMachineExtraLives:
	TYA ; Y contains extra lives to add
	CLC
	ADC iExtraMen ; Add won extra lives to current lives
	CMP #101
	BCC loc_BANKF_E8D3 ; Check if adding extra lives has wrapped the counter

	LDA #100 ; If so, set extra lives to 100

loc_BANKF_E8D3:
; now to check for coin service
	STA iExtraMen
	STA sExtraMen
	JSR CheckForCoinService
	LDA #0
	STA iBonusDrumRoll
	TYA ; Did we actually win any lives?
	BEQ SlotMachineLoseFanfare ; No, play lose sound effect

	JSR GetTwoDigitNumberTiles
	STY mLDPBonusChanceLiveEMCount - 1
	STA mLDPBonusChanceLiveEMCount ; Update number of lives won
	JSR SlotMachine_WaitforSFX
	LDA #Music_CrystalGetFanfare ; Play winner jingle
	STA iMusicQueue
	LDA #$A0
	STA z06
	JSR WaitForNMI

	JSR sub_BANKF_EA68

loc_BANKF_E8ED:
	JSR WaitForNMI

	JSR SlotMachineTextFlashIndex

	LDA BonusChanceUpdateBuffer_PLAYER_1UP, Y
	STA zScreenUpdateIndex
	DEC z06
	BNE loc_BANKF_E8ED

	JSR ExecuteCoinService

	JMP loc_BANKF_E90C

SlotMachineLoseFanfare:
	JSR SlotMachine_WaitforSFX

	LDA #Music_DeathJingle
	STA iMusicQueue
	JSR WaitForNMI

	JSR sub_BANKF_EA68

IFNDEF RGME_AUDIO
	JSR SlotMachine_WaitforJingle
ELSE
	LDA #$7c
	JSR DelayFrames
ENDIF

loc_BANKF_E90C:
	LDA #ScreenUpdateBuffer_RAM_EraseBonusMessageTextUnused
	STA zScreenUpdateIndex
	JSR WaitForNMI

	JMP loc_BANKF_E7FD

SlotMachine_WaitforSFX:
	LDA iCurrentPulse2SFX
	BEQ SlotMachine_SFXDone
	JSR WaitForNMI
	JMP SlotMachine_WaitforSFX
SlotMachine_SFXDone:
	RTS

SlotMachine_WaitforJingle:
	LDA iCurrentMusic
	BEQ SlotMachine_JingleDone
	JSR WaitForNMI
	JMP SlotMachine_WaitforJingle
SlotMachine_JingleDone:
	RTS

;
; Used for flashing text in Bonus Chance
;
; ##### Input
; - `z06`: Bonus Chance timer
;
; ##### Output
; - `Y`: 0 to show text, 1 to hide text
;
SlotMachineTextFlashIndex:
	LDA z06
	LSR A
	LSR A
	LSR A
	LSR A
	AND #$01
	TAY
	RTS


NoCoinsForSlotMachine:

	LDA #Music_DeathJingle
	STA iMusicQueue

	STA z06
loc_BANKF_E92A:
	LDA z06
	AND #$01
	TAY
	LDA BonusChanceUpdateBuffer_NO_BONUS, Y
	STA zScreenUpdateIndex

	LDA #$0A
	STA z07
loc_BANKF_E938:
	JSR WaitForNMI_TurnOnPPU
	DEC z07
	BNE loc_BANKF_E938

	DEC z06
	BPL loc_BANKF_E92A

	LDA iCurrentMusic
	BNE loc_BANKF_E92A

	JMP GoToNextLevel


Delay80Frames:
	LDA #$50
	BNE DelayFrames

Delay160Frames:
	LDA #$A0

DelayFrames:
	STA z07
DelayFrames_Loop:
	JSR WaitForNMI_TurnOnPPU
	DEC z07
	BNE DelayFrames_Loop
	RTS


;
; Do the ending!
;
EndingSceneRoutine:
	JSR SetScrollXYTo0

	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR FreeSubconsScene

	JSR WaitForNMI_TurnOffPPU

	JSR DisableNMI

	JSR LoadCelebrationSceneBackgroundCHR

	JSR EnableNMI

	JSR WaitForNMI

	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR ContributorScene

	JSR WaitForNMI_TurnOffPPU

	JSR DisableNMI

SetupMarioSleepingScene:
	JSR LoadMarioSleepingCHRBanks

	JSR EnableNMI

	JSR WaitForNMI

	LDA #PRGBank_C_D
	JSR ChangeMappedPRGBank

	JMP MarioSleepingScene


DisableNMI:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIDisabled
	STA PPUCTRL
	STA zPPUControl
	RTS


PPUBuffer_Text_Game_Over:
	.db $21, $CB, $0A
	.db $E0, $DA, $E6, $DE, $FB, $FB, $E8, $EF, $DE, $EB ; GAME OVER
	.db $00

PPUBuffer_Text_Continue:
	.db $21, $75, $01, $00 ; (Placeholder for continue count)
	.db $21, $6A, $0A, $F6, $FB, $DC, $E8, $E7, $ED, $E2, $E7, $EE, $DE ; * CONTINUE

PPUBuffer_Text_Retry:
	.db $21, $AA, $07, $F6, $FB, $EB, $DE, $ED, $EB, $F2 ; * RETRY
	.db $21, $CB, $0A, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB ; Blank, erases "GAME OVER"
	.db $00

BonusChanceUpdateBuffer_BONUS_CHANCE_Unused:
	.db ScreenUpdateBuffer_RAM_BonusChanceUnused
	.db ScreenUpdateBuffer_RAM_EraseBonusMessageText
BonusChanceUpdateBuffer_PUSH_A_BUTTON:
	.db ScreenUpdateBuffer_RAM_PushAButtonText
	.db ScreenUpdateBuffer_RAM_ErasePushAButtonText
BonusChanceUpdateBuffer_NO_BONUS:
	.db ScreenUpdateBuffer_RAM_NoBonusText
	.db ScreenUpdateBuffer_RAM_EraseBonusMessageText
BonusChanceUpdateBuffer_PLAYER_1UP:
	.db ScreenUpdateBuffer_RAM_Player1UpText
	.db ScreenUpdateBuffer_RAM_EraseBonusMessageText


;
; Displays extra life info on the pause screen
;
PauseScreen_ExtraLife:
	LDA #ScreenUpdateBuffer_PauseExtraLife
	STA iCardScreenID
	; Draw EXTRA LIFE text near bottom of card
	LDA #$26
	STA wExtraLifeDrawPointer
	LDA #$C8
	STA wExtraLifeDrawPointer + 1

;
; Loads the palette and graphics for the pause screen to display
;
PauseScreen_Card:
	JSR WaitForNMI_TurnOffPPU

	JSR ChangeTitleCardCHR

	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR StashScreenScrollPosition

	; Load title card palette
	LDY #$23
PauseScreen_Card_Loop:
	LDA TitleCardPalettes, Y
	STA iStartingPalettes, Y
	DEY
	BPL PauseScreen_Card_Loop

PauseScreen_Card_ScreenReset:
	JSR ResetScreenForTitleCard

	JSR EnableNMI_PauseTitleCard

	LDX iCurrentWorld
	LDY iCurrentLvl
	JSR DisplayLevelTitleCardText

	LDA #$FF
	STA zPPUScrollX
	JSR WaitForNMI

	LDA iCardScreenID
	STA zScreenUpdateIndex
	JSR WaitForNMI


EnableNMI:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	STA zPPUControl
	STA PPUCTRL
	RTS


; =============== S U B R O U T I N E =======================================

ResetScrollAndSetBonusChancePalettes:
	JSR SetScrollXYTo0

	LDA PPUSTATUS
	LDY #$00
	LDA #$3F
	STA PPUADDR
	STY PPUADDR

loc_BANKF_EA43:
	LDA iBonusChanceBGPal, Y
	STA PPUDATA
	INY
	CPY #$10
	BCC loc_BANKF_EA43

	LDY #$00
	LDA PPUSTATUS
	LDA #$3F
	STA PPUADDR
	LDA #$10
	STA PPUADDR

SetBonusChancePalette:
	LDA BonusChanceSpritePalettes, Y
	STA PPUDATA
	INY
	CPY #$10
	BCC SetBonusChancePalette

; End of function ResetScrollAndSetBonusChancePalettes

; =============== S U B R O U T I N E =======================================

sub_BANKF_EA68:
	LDY iExtraMen
	DEY
	TYA
	JSR GetTwoDigitNumberTiles
	STY i599
	STA i59a

	LDA iTotalCoins
	JSR GetTwoDigitNumberTiles
	STY i588 - 1
	STA i588

	LDA #ScreenUpdateBuffer_RAM_BonusChanceCoinsExtraLife
	STA zScreenUpdateIndex
	LDA #Stack100_Menu
	STA iStack
	JSR EnableNMI

	JMP WaitForNMI

; End of function sub_BANKF_EA68


;
; Converts a number to numerical tiles with space for 2 digits
;
; ##### Input
; - `A` = number to display
;
; ##### Output
; - `A`: second digit of the number (ones)
; - `Y`: first digit of the number (tens)
;
GetTwoDigitNumberTiles:
	LDY #$D0 ; zero

GetTwoDigitNumberTiles_TensLoop:
	; Count up the tens digit until A < 10
	CMP #$0A
	BCC GetTwoDigitNumberTiles_Ones

	SBC #$0A
	INY
	JMP GetTwoDigitNumberTiles_TensLoop

GetTwoDigitNumberTiles_Ones:
	ORA #$D0
	CPY #$D0
	BNE GetTwoDigitNumberTiles_Exit

	LDY #$FB

GetTwoDigitNumberTiles_Exit:
	RTS


WaitForNMI_TurnOffPPU:
	LDA #$00
	BEQ _WaitForNMI_StuffPPUMask ; Branch always

WaitForNMI_TurnOnPPU:
	LDA #PPUMask_ShowLeft8Pixels_BG | PPUMask_ShowLeft8Pixels_SPR | PPUMask_ShowBackground | PPUMask_ShowSprites

_WaitForNMI_StuffPPUMask:
	STA zPPUMask

WaitForNMI:
	LDA zScreenUpdateIndex
	ASL A
	TAX
	LDA ScreenUpdateBufferPointers, X
	STA zPPUDataBufferPointer
	LDA ScreenUpdateBufferPointers + 1, X
	STA zPPUDataBufferPointer + 1

	LDA #$00
	STA zNMIOccurred ; Start waiting for NMI to finish
WaitForNMILoop:
	LDA zNMIOccurred ; Has the NMI routine set the flag yet?
	BPL WaitForNMILoop ; If no, wait some more
	RTS ; If yes, go back to what we were doing


; =============== S U B R O U T I N E =======================================

CheckStopReel:
	LDA zInputBottleneck
	BPL locret_BANKF_EAD1

	LDX #$00

loc_BANKF_EAC8:
	LDA zObjectXLo, X
	BNE loc_BANKF_EAD2

	INX
	CPX #$03
	BCC loc_BANKF_EAC8

locret_BANKF_EAD1:
	; eject if noise is playing
	LDA iCurrentNoiseSFX
	ORA iBonusDrumRoll
	BNE CheckStopReel_Eject

	; eject if reels 1 or 2 are active
	LDA zObjectXLo
	ORA zObjectXLo + 1
	BNE CheckStopReel_Eject

	; eject if reels 1 and 2 don't match
	LDX zObjectXLo + 6
	LDA mReelBuffer, X
	LDX zObjectXLo + 7
	CMP mReelBuffer + 8, X
	BNE CheckStopReel_Eject

	; Play the drum roll!
	LDX #SoundEffect3_DrumRoll
	STX iNoiseDrumSFX
	INC iBonusDrumRoll

CheckStopReel_Eject:
	RTS

; ---------------------------------------------------------------------------

loc_BANKF_EAD2:
	LDA #$00
	STA zObjectXLo, X
	LDA #SoundEffect2_StopSlot
	STA iPulse2SFX
	CPX #$02
	BEQ TrancateDrumRoll
	RTS

TrancateDrumRoll:
	LDA zNoiseSFXOffset
	CMP #$dd
	BCS PreserveDrumRoll

	LDA #$dd
	STA zNoiseSFXOffset

PreserveDrumRoll:
	RTS

; End of function CheckStopReel

; =============== S U B R O U T I N E =======================================

TimedSlotIncrementation:
	LDX #$02

loc_BANKF_EADE:
	LDA zObjectXLo, X
	BEQ loc_BANKF_EAF2

	DEC zObjectXLo + 3, X
	BNE loc_BANKF_EAF2

	LDA #$07
	STA zObjectXLo + 3, X
	DEC zObjectXLo + 6, X
	BPL loc_BANKF_EAF2

	LDA #$07
	STA zObjectXLo + 6, X

loc_BANKF_EAF2:
	DEX
	BPL loc_BANKF_EADE
	RTS

; End of function TimedSlotIncrementation

; =============== S U B R O U T I N E =======================================

UpdateSlotSprites:
	LDA #$02
	STA z00

loc_BANKF_EAFA:
	LDA z00
	TAY
	ASL A
	ASL A
	ASL A
	TAX
	ADC zObjectXLo + 6, Y
	TAY
	LDA mReelBuffer, Y
	TAY
	LDA #$07
	STA z01

loc_BANKF_EB0D:
	LDA BonusChanceCherrySprite, Y
	STA iVirtualOAM + $10, X
	INX
	INY
	DEC z01
	BPL loc_BANKF_EB0D

	DEC z00
	BPL loc_BANKF_EAFA

	LDX #$17

loc_BANKF_EB1F:
	TXA
	AND #$18
	ASL A
	ASL A
	ADC iVirtualOAM + $10, X
	STA iVirtualOAM + $10, X
	DEX
	DEX
	DEX
	DEX
	BPL loc_BANKF_EB1F
	RTS

; End of function UpdateSlotSprites

;
; NMI logic for during a transition
;
NMI_Transition:
	LDA #$00
	STA OAMADDR
	LDA #$02
	STA OAM_DMA
	JSR ChangeCHRBanks

	LDA zPPUMask
	STA PPUMASK
	JSR DoSoundProcessing
	JSR EngageSave

	LDA zPPUControl
	STA PPUCTRL
	DEC zNMIOccurred
	JMP NMI_Exit


;
; NMI logic for during the pause menu
;
NMI_PauseSaveOrMenu:
	LDA #$00
	STA PPUMASK
	STA OAMADDR
	LDA #$02
	STA OAM_DMA
	JSR ChangeCHRBanks

	JSR UpdatePPUFromBufferWithOptions

	JSR ResetPPUAddress

	LDA zPPUScrollX
	STA PPUSCROLL
	LDA #$00
	STA PPUSCROLL
	LDA zPPUMask
	STA PPUMASK
	JMP NMI_CheckScreenUpdateIndex


;
; When waiting for an NMI, just run the audio engine
;
NMI_Waiting:
	LDA zPPUMask
	STA PPUMASK
	JMP NMI_DoSoundProcessing


;
; Public NMI: where dreams come true!
;
; The NMI runs every frame during vertical blanking and is responsible for
; tasks that should occur on each frame of gameplay, such as drawing tiles and
; sprites, scrolling, and reading input.
;
; It also runs the audio engine, allowing music to play continuously no matter
; how busy the rest of the game happens to be.
;
; The NMI is actually separated into several distinct behaviors depending on the
; game state, as dictated by flags in stack `$100`.
;
; For normal gameplay, here is the general flow of the NMI:
;
;  1. Push registers and processor flags so that we can restore them later.
;  2. Check to see whether we're in a menu or transitioning. If so, use those
;     divert to that code instead.
;  3. Hide the sprites/background and update the sprite OAM.
;  4. Load the current CHR banks.
;  5. Check the `zNMIOccurred`. If it's nonzero, restore `PPUMASK` and skip to
;     handling the sound processing.
;  6. Handle any horizontal or vertical scrolling tile updates.
;  7. Update PPU using the current screen update buffer.
;  8. Write PPU control register, scroll position, and mask.
;  9. Increment the global frame counter.
; 10. Reset PPU buffer 301 if we just used it for the screen update.
; 11. Read joypad input.
; 12. Decrement `zNMIOccurred`, unblocking any code that was waiting for the NMI.
; 13. Run the audio engine.
; 14. Restore registers and processor flags, yield back to the game loop.
;
; The game loop is synchronized with rendering using `JSR WaitForNMI`, which
; sets `zNMIOccurred` to `$00` until the NMI completes and decrements it.
;
; Although the NMI itself doesn't lag (ie. the NMI itself is not interrupted
; by another NMI), there are some parts of the game that can feel sluggish.
; This is due to sluggishness in the game loop itself.
;
NMI:
	PHP
	PHA
	TXA
	PHA
	TYA
	PHA

	BIT iStack
	BPL NMI_PauseSaveOrMenu ; branch if bit 7 was 0

	BVC NMI_Transition ; branch if bit 6 was 0

	LDA #$00
	STA PPUMASK
	STA OAMADDR
	LDA #$02
	STA OAM_DMA

	JSR ChangeCHRBanks

NMI_CheckWaitFlag:
	LDA zNMIOccurred
	BNE NMI_Waiting

NMI_Gameplay:
	; `UpdatePPUFromBufferNMI` draws in a row-oriented fashion, which makes it
	; unsuitable for horizontal levels where scrolling the screen means drawing
	; columns of new tiles. As a result, we need special logic to draw the
	; background in horizontal levels!
	LDA zScrollCondition
	BEQ NMI_AfterBackgroundAttributesUpdate

	LDA iScrollUpdateQueue
	BEQ NMI_AfterBackgroundTilesUpdate

	; Update nametable tiles in horizontal level
	LDA #$00
	STA iScrollUpdateQueue
	LDX #$1E
	LDY #$00
	LDA PPUSTATUS
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteVertical | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	STA PPUCTRL

NMI_DrawBackgroundTilesOuterLoop:
	LDA zBigPPUDrawer
	STA PPUADDR
	LDA zBigPPUDrawer + 1
	STA PPUADDR

NMI_DrawBackgroundTilesInnerLoop:
	LDA iScrollTileBuffer, Y
	STA PPUDATA
	INY
	DEX
	BNE NMI_DrawBackgroundTilesInnerLoop

	LDX #$1E
	INC zBigPPUDrawer + 1

	CPY #$3C
	BNE NMI_DrawBackgroundTilesOuterLoop

NMI_AfterBackgroundTilesUpdate:
	LDA iBigDrawerAttrPointer
	BEQ NMI_AfterBackgroundAttributesUpdate

	; Update nametable attributes in horizontal level
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteVertical | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	STA PPUCTRL
	LDY #$00
	LDX #$04

NMI_DrawBackgroundAttributesOuterLoop:
	LDA PPUSTATUS
	LDA iBigDrawerAttrPointer
	STA PPUADDR
	LDA iBigDrawerAttrPointer + 1
	STA PPUADDR

NMI_DrawBackgroundAttributesInnerLoop:
	LDA iHorScrollBuffer, Y
	STA PPUDATA
	INY
	TYA
	LSR A
	BCS NMI_DrawBackgroundAttributesInnerLoop

	LDA iBigDrawerAttrPointer + 1
	CLC
	ADC #$08
	STA iBigDrawerAttrPointer + 1
	DEX
	BNE NMI_DrawBackgroundAttributesOuterLoop

	STX iBigDrawerAttrPointer

NMI_AfterBackgroundAttributesUpdate:
	JSR UpdatePPUFromBufferNMI

	JSR ResetPPUAddress

	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	ORA zXScrollPage
	LDY zScrollCondition
	BNE NMI_UpdatePPUScroll

	AND #$FE
	ORA zYScrollPage

NMI_UpdatePPUScroll:
	STA PPUCTRL
	STA zPPUControl
	LDA zPPUScrollX
	STA PPUSCROLL
	LDA zPPUScrollY
	CLC
	ADC iBGYOffset
	STA PPUSCROLL
	LDA zPPUMask
	STA PPUMASK

NMI_IncrementGlobalCounter:
	INC z10

NMI_CheckScreenUpdateIndex:
	LDA zScreenUpdateIndex
	BNE NMI_ResetScreenUpdateIndex

	; Turn off PPU buffer 301 update
	STA i300
	STA iPPUBuffer

NMI_ResetScreenUpdateIndex:
	LDA #ScreenUpdateBuffer_RAM_301
	STA zScreenUpdateIndex
	JSR UpdateJoypads

	DEC zNMIOccurred

NMI_DoSoundProcessing:
	JSR DoSoundProcessing

NMI_CheckSave:
	JSR EngageSave

NMI_Exit:
	PLA
	TAY
	PLA
	TAX
	PLA
	PLP
	RTI

; End of function NMI

;
; Sets the PPU address to `$3f00`, then immediatley to `$0000`
;
; Speculation is that this ritual comes from a recommendation in some Nintendo
; documentation, but isn't actually necessary.
;
; See: https://forums.nesdev.com/viewtopic.php?f=2&t=16721
;
ResetPPUAddress:
	LDA PPUSTATUS
	LDA #$3F
	STA PPUADDR
	LDA #$00
	STA PPUADDR
	STA PPUADDR
	STA PPUADDR
	RTS


DoSoundProcessing:
	LDA #PRGBank_4_5
	ASL A
	ORA #$80
	STA MMC5_PRGBankSwitch2
	LDA iMusicBank
	STA MMC5_PRGBankSwitch3

	JSR StartProcessingSoundQueue

	LDA iCurrentROMBank
	JMP ChangeMappedPRGBank


ClearNametablesAndSprites:
	LDA #$00
	STA zPPUMask
	STA PPUMASK
	LDA #$20
	JSR ClearNametableChunk

	LDA #$24
	JSR ClearNametableChunk

	LDA #$28
	JSR ClearNametableChunk


HideAllSprites:
	LDY #$00
	LDA #$F8

HideAllSpritesLoop:
	STA iVirtualOAM, Y
	DEY
	DEY
	DEY
	DEY
	BNE HideAllSpritesLoop
	RTS


ClearNametableChunk:
	LDY PPUSTATUS ; Reset PPU address latch
	LDY #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIDisabled
	STY PPUCTRL ; Turn off NMI
	STY zPPUControl
	LDY #$00
	; A contains the high byte of the PPU address (generally $20, $24, $28)
	STA PPUADDR
	STY PPUADDR ; And Y has the low byte ($00)
	LDX #$03 ; Do $300 bytes for this loop.
	LDA #$FB

ClearNametableChunk_Loop:
	STA PPUDATA ; Store the blank tile $300 times
	INY
	BNE ClearNametableChunk_Loop ; (Loop falls through every $100 bytes)

	DEX
	BNE ClearNametableChunk_Loop ; Loop falls through after $300 bytes

ClearNametableChunk_Loop2:
	; Do another loop of $C0 bytes to clear the
	; rest of the nametable chunk
	STA PPUDATA
	INY
	CPY #$C0
	BNE ClearNametableChunk_Loop2

	LDA #$00 ; Load A with $00 for clearing the attribute tables

ClearNametableChunk_AttributeTableLoop:
	STA PPUDATA ; Clear attribute table...
	INY ; Y was $C0 on entry, so write $40 bytes...
	BNE ClearNametableChunk_AttributeTableLoop

PPUBufferUpdatesComplete:
	RTS ; Whew!


;
; Used to update the PPU nametable / palette data during NMI.
;
; This function can only handle $100 bytes of data
; (actually less).
;
; Unlike `UpdatePPUFromBufferWithOptions`, this one does not support
; $80 or $40 as options, instead treating them as direct length.
; It also does not increment the buffer pointer, only using Y
; to read further data.
;
; If Y overflows, it will resume copying again from the beginning,
; and can get into an infinite loop if it doesn't encounter
; a terminating $00. Welp!
;
UpdatePPUFromBufferNMI:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	STA PPUCTRL
	LDY #$00

UpdatePPUFromBufferNMI_CheckForBuffer:
	LDA (zPPUDataBufferPointer), Y
	BEQ PPUBufferUpdatesComplete

	LDX PPUSTATUS
	STA PPUADDR
	INY
	LDA (zPPUDataBufferPointer), Y
	STA PPUADDR
	INY
	LDA (zPPUDataBufferPointer), Y
	TAX

UpdatePPUFromBufferNMI_CopyLoop:
	INY
	LDA (zPPUDataBufferPointer), Y
	STA PPUDATA
	DEX
	BNE UpdatePPUFromBufferNMI_CopyLoop

	INY
	JMP UpdatePPUFromBufferNMI_CheckForBuffer


;
; This reads from $F0/$F1 to determine where a "buffer" is.
; Basically, a buffer is like this:
;
; PPUADDR  LEN DATA ......
; $20 $04  $03 $E9 $F0 $FB
; $25 $5F  $4F $FB
; $21 $82  $84 $00 $01 $02 $03
; $00
;
; PPUADDR is two bytes (hi,lo) for the address to send to PPUADDR.
; LEN is the length, with the following two bitmasks:
;
;  - $80: Set the "draw vertically" option
;  - $40: Use ONE tile instead of a string
;
; DATA is either (LEN) bytes or one byte.
;
; After (LEN) bytes have been written, the buffer pointer
; is incremented to (LEN+2) and the function restarts.
; A byte of $00 terminates execution and returns.
;
; There is a similar function, `UpdatePPUFromBufferNMI`,
; that is called during NMI, but unlike this one,
; that one does NOT use bitmasks, nor increment the pointer.
;
UpdatePPUFromBufferWithOptions:
	; First, check if we have anything to send to the PPU
	LDY #$00
	LDA (zPPUDataBufferPointer), Y
	; If the first byte at the buffer address is #$00, we have nothing. We're done here!
	BEQ PPUBufferUpdatesComplete

	; Clear address latch
	LDX PPUSTATUS
	; Set the PPU address to the
	; address from the PPU buffer
	STA PPUADDR
	INY
	LDA (zPPUDataBufferPointer), Y
	STA PPUADDR
	INY
	LDA (zPPUDataBufferPointer), Y ; Data segment length byte...
	ASL A
	PHA
	; Enable NMI + Vertical increment + whatever else was already set...
	LDA zPPUControl
	ORA #PPUCtrl_Base2000 | PPUCtrl_WriteVertical | PPUCtrl_Sprite0000 | PPUCtrl_Background0000 | PPUCtrl_SpriteSize8x8 | PPUCtrl_NMIEnabled
	; ...but only if $80 was set in the length byte. Otherwise, turn vertical incrementing back off.
	BCS UpdatePPUFBWO_EnableVerticalIncrement

	AND #PPUCtrl_Base2C00 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite1000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled | $40

UpdatePPUFBWO_EnableVerticalIncrement:
	STA PPUCTRL
	PLA
	; Check if the second bit ($40) in the length has been set
	ASL A
	; If not, we are copying a string of data
	BCC UpdatePPUFBWO_CopyStringOfTiles

	; Length (A) is now (A << 2).
	; OR in #$02 now if we are copying a single tile;
	; This will be rotated out into register C momentarily
	ORA #$02
	INY

UpdatePPUFBWO_CopyStringOfTiles:
	; Restore the data length.
	; A = (Length & #$3F)
	LSR A

	; This moves the second bit (used above to signal
	; "one tile mode") into the Carry register
	LSR A
	TAX ; Copy the length into register X

UpdatePPUFBWO_CopyLoop:
	; If Carry is set (from above), we're only copying one tile.
	; Do not increment Y to advance copying index
	BCS UpdatePPUFBWO_CopySingleTileSkip

	INY

UpdatePPUFBWO_CopySingleTileSkip:
	LDA (zPPUDataBufferPointer), Y ; Load data from buffer...
	STA PPUDATA ; ...store it to the PPU.
	DEX ; Decrease remaining length.
	BNE UpdatePPUFBWO_CopyLoop ; Are we done? If no, copy more stuff

	INY ; Y contains the amount of copied data now
	TYA ; ...and now A does
	CLC ; Clear carry bit (from earlier)
	ADC zPPUDataBufferPointer ; Add the length to the PPU data buffer
	STA zPPUDataBufferPointer
	LDA zPPUDataBufferPointer + 1
	; If the length overflowed (carry set),
	; add that to the hi byte of the pointer
	ADC #$00
	STA zPPUDataBufferPointer + 1
	; Start the cycle over again.
	; (If the PPU buffer points to a 0, it will terminate after this jump)
	JMP UpdatePPUFromBufferWithOptions


RESET_MMC5:
	; Set PRG mode 3 and CHR mode 3
	LDA #$03
	STA MMC5_PRGMode
	STA MMC5_CHRMode

	; Enable PRG RAM writing
	LDA #$02
	STA MMC5_PRGRAMProtect1
	STA MMC5_ExtendedRAMMode
	LDA #$01
	STA MMC5_PRGRAMProtect2

	; Set nametable mapping
	LDA #%01010000
	STA MMC5_NametableMapping

	LDA #$00
	STA MMC5_PRGBankSwitch1
	STA MMC5_CHRBankSwitchUpper

	; MMC5 Pulse channels
	LDA #$0F
	STA MMC5_SND_CHN

	; PRG bank 0
	LDA #$80 ; ROM bank 0
	STA MMC5_PRGBankSwitch2 ; $8000-$9FFF

	; PRG bank 1
	LDA #$81 ; ROM bank 1
	STA MMC5_PRGBankSwitch3 ; $A000-$BFFF

	; PRG bank 2
	LDA #$9E ; ROM bank 1E
	STA MMC5_PRGBankSwitch4 ; $C000-$DFFF

	; PRG bank 3
	LDA #$9F ; ROM bank 1F
	STA MMC5_PRGBankSwitch5 ; $E000-$FFFF

	JMP RESET

;
; ## Tile collision bounding boxes
;
; These hitboxes are used when determining the collision between objects and background tiles.
;
; Tile collision bounding box table offsets
;
TileCollisionHitboxIndex:
	.db $00 ; $00 - player standing
	.db $08 ; $01 - player holding item
	.db $10 ; $02 - player ducking
	.db $18 ; $03 - player ducking with item
	.db $20 ; $04 - 16x16 items (vegetables, etc.)
	.db $24 ; $05 - 16x16 enemies (shyguy, etc.)
; The following four entries are used to determine whether a carried item can be thrown.
	.db $28 ; $06 - player left, standing
	.db $2A ; $07 - player left, ducking
	.db $29 ; $08 - player right, standing
	.db $2B ; $09 - player right, ducking
	.db $2C ; $0A - player climb/cherry
	.db $2E ; $0B - player climbing
	.db $30 ; $0C - 16x32 enemies (birdo, mouser)
	.db $34 ; $0D - projectile
	.db $38 ; $0E - 16x48 enemies (tryclde)
	.db $3C ; $0F - spark
	.db $40 ; $10 - flying carpet

;
; ### Tile vertical collision bounding box (x-offsets)
;
; The left boundary offset is measured from the left side of the sprite.
; The right boundary offset is measured from the right of the first tile of the sprite.
;
; Each bounding box entry is four bytes:
;
;   1. left boundary (upward velocity)
;   2. right boundary (upward velocity)
;   3. left boundary (downward velocity)
;   4. right boundary (downward velocity)
;
VerticalTileCollisionHitboxX:
	.db $06, $09, $06, $09 ; $00
	.db $01, $01, $0E, $0E ; $04
	.db $06, $09, $06, $09 ; $08
	.db $01, $01, $0E, $0E ; $0C
	.db $06, $09, $06, $09 ; $10
	.db $01, $01, $0E, $0E ; $14
	.db $06, $09, $06, $09 ; $18
	.db $01, $01, $0E, $0E ; $1C
	.db $08, $08, $00, $0F ; $20
	.db $08, $08, $03, $0C ; $24
	.db $F8, $18, $F8, $18 ; $28
	.db $08, $08, $08, $08 ; $2C
	.db $08, $08, $03, $0C ; $30
	.db $03, $03, $02, $05 ; $34
	.db $08, $08, $03, $0C ; $38
	.db $08, $08, $FF, $10 ; $3C
	.db $10, $10, $02, $1E ; $40

;
; ### Tile vertical collision bounding box (y-offsets)
;
; The upper and lower boundary offset are measured from the top of the sprite.
;
; Each bounding box entry is four bytes:
;
;   1. upper boundary (upward velocity)
;   2. lower boundary (upward velocity)
;   3. upper boundary (downward velocity)
;   4. lower boundary (downward velocity)
;
; Not totally sure why there are two bytes, but it seems to have something to do with the direction
; of movement when checking the collision.
;
VerticalTileCollisionHitboxY:
	.db $07, $07, $20, $20 ; $00
	.db $0D, $1C, $0D, $1C ; $04
	.db $FF, $FF, $20, $20 ; $08
	.db $04, $1C, $04, $1C ; $0C
	.db $0F, $0F, $20, $20 ; $10
	.db $1C, $1C, $1C, $1C ; $14
	.db $07, $07, $20, $20 ; $18
	.db $0D, $1C, $0D, $1C ; $1C
	.db $00, $10, $09, $09 ; $20
	.db $03, $10, $09, $09 ; $24
	.db $FF, $FF, $0F, $0F ; $28
	.db $0C, $14, $07, $20 ; $2C
	.db $FE, $20, $10, $10 ; $30
	.db $09, $0A, $08, $08 ; $34
	.db $03, $30, $18, $18 ; $38
	.db $FF, $10, $08, $08 ; $3C
	.db $09, $0A, $08, $08 ; $40

;
; ## Object vertical collision bounding box
;
; These hitboxes are copied to RAM and used when determining collision between objects. This allows
; the hitboxes to change dynamically, which is used when Hawkmouth (offset $0B) opens and closes.
;
ObjectCollisionHitboxLeft:
	.db $02 ; $00
	.db $02 ; $01
	.db $03 ; $02
	.db $00 ; $03
	.db $03 ; $04
	.db $03 ; $05
	.db $F8 ; $06
	.db $00 ; $07
	.db $03 ; $08
	.db $01 ; $09
	.db $F3 ; $0A
	.db $04 ; $0B
	.db $03 ; $0C
	.db $03 ; $0D
	.db $03 ; $0E
	.db $F2 ; $0F
	.db $03 ; $10
	.db $03 ; $11
	.db $05 ; $12
	.db $03 ; $13

ObjectCollisionHitboxTop:
	.db $0B ; $00
	.db $10 ; $01
	.db $03 ; $02
	.db $00 ; $03
	.db $03 ; $04
	.db $03 ; $05
	.db $F8 ; $06
	.db $00 ; $07
	.db $09 ; $08
	.db $04 ; $09
	.db $03 ; $0A
	.db $03 ; $0B
	.db $0E ; $0C
	.db $03 ; $0D
	.db $03 ; $0E
	.db $03 ; $0F
	.db $F6 ; $10
	.db $0C ; $11
	.db $02 ; $12
	.db $03 ; $13

ObjectCollisionHitboxWidth:
	.db $0B ; $00
	.db $0B ; $01
	.db $09 ; $02
	.db $10 ; $03
	.db $09 ; $04
	.db $19 ; $05
	.db $20 ; $06
	.db $20 ; $07
	.db $03 ; $08
	.db $1E ; $09
	.db $19 ; $0A
	.db $08 ; $0B
	.db $09 ; $0C
	.db $09 ; $0D
	.db $09 ; $0E
	.db $18 ; $0F
	.db $09 ; $10
	.db $1A ; $11
	.db $06 ; $12
	.db $15 ; $13

ObjectCollisionHitboxHeight:
	.db $16 ; $00
	.db $11 ; $01
	.db $0D ; $02
	.db $10 ; $03
	.db $1A ; $04
	.db $19 ; $05
	.db $24 ; $06
	.db $10 ; $07
	.db $03 ; $08
	.db $04 ; $09
	.db $2D ; $0A
	.db $30 ; $0B
	.db $0F ; $0C
	.db $2E ; $0D
	.db $3E ; $0E
	.db $1E ; $0F
	.db $28 ; $10
	.db $13 ; $11
	.db $48 ; $12
	.db $26 ; $13


NextSpriteFlickerSlot:
	DEC iObjectFlickerer
	BPL NextSpriteFlickerSlot_Exit

	LDA #$08
	STA iObjectFlickerer

NextSpriteFlickerSlot_Exit:
	RTS


LevelMusicIndexes:
	.db Music_Overworld
	.db Music_Inside ; 1 ; Music indexes.
	.db Music_Boss ; 2
	.db Music_Wart ; 3
	.db Music_Subspace ; 4


; =============== S U B R O U T I N E =======================================

sub_BANKF_F0F9:
	JSR NextSpriteFlickerSlot

	LDA iIsInRocket
	BNE loc_BANKF_F11B

	; boss clear fanfare locks player movement
	LDA iCurrentMusic
	CMP #Music_BossClearFanfare
	BEQ loc_BANKF_F115

	LDA iPlayerLock
	BNE loc_BANKF_F115

	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR HandlePlayerState

loc_BANKF_F115:
	JSR SetPlayerScreenPosition

	JSR RenderPlayer

loc_BANKF_F11B:
	JMP RunFrame_Common

; End of function sub_BANKF_F0F9

;
; Does a lot of important stuff in horizontal levels
;
RunFrame_Horizontal:
	JSR NextSpriteFlickerSlot

	; If the player is in a rocket, cut to the chase
	LDA iIsInRocket
	BNE RunFrame_Common

	; Switch to banks 0/1 for the scrolling logic
	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	; If the boss clear fanfare is playing or `iPlayerLock` is set, skip the
	; player state update subroutine
	LDA iCurrentMusic
	CMP #Music_BossClearFanfare
	BEQ RunFrame_Horizontal_AfterPlayerState

	LDA iPlayerLock
	BNE RunFrame_Horizontal_AfterPlayerState

	JSR HandlePlayerState

RunFrame_Horizontal_AfterPlayerState:
	JSR GetMoveCameraX

	JSR ApplyHorizontalScroll

	JSR SetPlayerScreenPosition

	JSR RenderPlayer

; back to the shared stuff
RunFrame_Common:
	LDA #PRGBank_2_3
	JSR ChangeMappedPRGBank

	JSR AreaMainRoutine

	JSR AreaSecondaryRoutine

	JSR AnimateCHRRoutine

	JSR SetAreaStartPage

	; Decrement player state timers
	LDX #$03
DecrementPlayerStateTimers_Loop:
	LDA zPlayerStateTimer, X
	BEQ DecrementPlayerStateTimers_Zero

	DEC zPlayerStateTimer, X

DecrementPlayerStateTimers_Zero:
	DEX
	BPL DecrementPlayerStateTimers_Loop

	; If invincible, decrement timer every 8 frames
	LDY iStarTimer
	BEQ RunFrame_Exit

	LDA z10
	AND #$07
	BNE RunFrame_Exit

	; When the invincibility timer hits 8, restore the regular level music
	DEC iStarTimer
	CPY #$08
	BNE RunFrame_Exit

	LDY iMusicID
	LDA LevelMusicIndexes, Y
	STA iMusicQueue

RunFrame_Exit:
	RTS


;
; Does a lot of important stuff in vertical levels
;
RunFrame_Vertical:
	JSR NextSpriteFlickerSlot

	JSR DetermineVerticalScroll

	; If the player is in a rocket, cut to the chase
	LDA iIsInRocket
	BNE RunFrame_Vertical_Common

	; If the boss clear fanfare is playing or `iPlayerLock` is set, skip the
	; player state update subroutine
	LDA iCurrentMusic
	CMP #Music_BossClearFanfare
	BEQ RunFrame_Vertical_AfterPlayerState

	LDA iPlayerLock
	BNE RunFrame_Vertical_AfterPlayerState

	; Switch to banks 0/1 for the scrolling logic
	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR HandlePlayerState

RunFrame_Vertical_AfterPlayerState:
	LDA #PRGBank_0_1
	JSR ChangeMappedPRGBank

	JSR ApplyVerticalScroll

	JSR SetPlayerScreenPosition

	JSR RenderPlayer

RunFrame_Vertical_Common:
	JMP RunFrame_Common


;
; Stores the current level/area and player state in the `Init` variables so that they can be
; to restart the area from the previous transition after the player dies.
;
RememberAreaInitialState:
	LDA iAreaTransitionID
	CMP #$02 ; Skip if the player is going into a pointer jar
	BEQ RememberAreaInitialState_Exit

	LDY #$03
RememberAreaInitialState_Loop:
	LDA iCurrentLvl, Y
	STA iCurrentLevel_Init, Y
	DEY
	BPL RememberAreaInitialState_Loop

	LDA zPlayerXLo
	STA iPlayer_X_Lo_Init
	LDA zPlayerYLo
	STA iPlayer_Y_Lo_Init
	LDA iPlayerScreenX
	STA iPlayerScreenX_Init
	LDA iPlayerScreenY
	STA iPlayerScreenY_Init
	LDA zPlayerYVelocity
	STA iPlayer_Y_Velocity_Init
	LDA zPlayerState
	STA iPlayer_State_Init

RememberAreaInitialState_Exit:
	RTS


;
; Level Initialization
; ====================
;
; Sets up in-level gameplay (eg. after level card)
;
LevelInitialization:
	LDY #$03
	LDA iCurrentLevel_Init
	STA sSavedLvl

; Loop through and set level, area, page, and transition from RAM
LevelInitialization_AreaSetupLoop:
	LDA iCurrentLevel_Init, Y
	STA iCurrentLvl, Y
	DEY
	BPL LevelInitialization_AreaSetupLoop

	; position the player
	LDA iPlayer_X_Lo_Init
	STA zPlayerXLo
	LDA iPlayer_Y_Lo_Init
	STA zPlayerYLo
	LDA iPlayerScreenX_Init
	STA iPlayerScreenX
	LDA iPlayerScreenY_Init
	STA iPlayerScreenY
	LDA iPlayer_Y_Velocity_Init
	STA zPlayerYVelocity
	LDA iPlayer_State_Init
	STA zPlayerState
	LDA #$00
	STA iSubAreaFlags
	STA iInJarType
	STA zPlayerGrounding
	STA zDamageCooldown


RestorePlayerToFullHealth:
	LDY iPlayerMaxHP ; Get player's current max HP
	LDA PlayerHealthValueByHeartCount, Y ; Get the health value for this amount of hearts
	STA iPlayerHP
	RTS


PlayerHealthValueByHeartCount:
	.db PlayerHealth_2_HP
	.db PlayerHealth_3_HP
	.db PlayerHealth_4_HP
; Max hearts = (hearts - 2), value is 0,$01,2
; This table determines what the player's HP is set to
IFNDEF PAL
ClimbSpeed:
	.db $00
ClimbSpeedDown:
	.db $20
ClimbSpeedUp:
	.db $F0
ELSE
ClimbSpeed:
	.db $00
ClimbSpeedDown:
	.db $26
ClimbSpeedUp:
	.db $ED
ENDIF
; Bug: The climb speed index is determined by checking the up/down flags in
; zInputCurrentState. If both are enabled, the index it out of bounds and uses
; the LDA ($A5) below, which zips the player up the vine!
IFDEF FIX_CLIMB_ZIP
	.db $00
ENDIF

;
; Calculates the player's position onscreen.
;
; The screen position is also used for the jump-out-of-a-jar screen transition
; and bottomless pit checks, which works because of the assumption that the
; camera can always keep up with the player in normal gameplay.
;
SetPlayerScreenPosition:
	LDA zPlayerXLo
	SEC
	SBC iBoundLeftLower
	STA iPlayerScreenX
	LDA zPlayerYLo
	CLC
	SBC zScreenY
	STA iPlayerScreenY
	LDA zPlayerYHi
	SBC zScreenYPage
	STA iPlayerScreenYPage

	; Exit if the player state is not standing/jumping or climbing
	LDA zPlayerState
	CMP #PlayerState_Lifting
	BCS SetPlayerScreenPosition_Exit

	LDA iPlayerScreenYPage
	BEQ SetPlayerScreenPosition_CheckClimbing

	BMI SetPlayerScreenPosition_Above

; If the player falls below the screen, they are in a bottomless pit.
SetPlayerScreenPosition_Below:
	LDA #$00
	STA zPlayerStateTimer
	JMP KillPlayer

; If the player is above the screen, they might be jumping out of a jar.
SetPlayerScreenPosition_Above:
	; Verify that the y-position is above the first page of the area
	LDA zPlayerYHi
	BPL SetPlayerScreenPosition_Exit

	; We're above the top of the area, so check if we're in a jar
	LDA iInJarType
	BEQ SetPlayerScreenPosition_CheckClimbing

	; Check if the player is far enough above the top of the area
	LDA zPlayerYLo
	CMP #$F0
	BCS SetPlayerScreenPosition_Exit

	; Exit the jar!
	JSR DoAreaReset

	; Break out of the previous subroutine
	PLA
	PLA

	; Put the player in a crouching stance
	LDY #$00
	STY zPlayerHitBoxHeight
	STY zPlayerYVelocity
	STY zPlayerXVelocity
	LDA #DPCM_ExitingJar
	STA iDPCMSFX
	LDA #PlayerState_ExitingJar
	STA zPlayerState
	LDA #SpriteAnimation_Ducking
	STA zPlayerAnimFrame
	LDA iInJarType
	STY iInJarType
	CMP #$02
	BNE SetPlayerScreenPosition_ExitSubAreaJar

SetPlayerScreenPosition_ExitPointerJar:
	STA iAreaTransitionID
	RTS

SetPlayerScreenPosition_ExitSubAreaJar:
	STY iSubAreaFlags
	LDA iCurrentAreaBackup
	STA iCurrentLvlArea
	LDA #PRGBank_8_9
	JSR ChangeMappedPRGBank

	JMP CopyEnemyDataToMemory

SetPlayerScreenPosition_Exit:
	RTS

SetPlayerScreenPosition_CheckClimbing:
	LDA zPlayerState
	CMP #PlayerState_Climbing
	BNE SetPlayerScreenPosition_Exit

	; No climbing transitions from subspace
	LDA iSubAreaFlags
	CMP #$02
	BEQ SetPlayerScreenPosition_Exit

	; Climbing upwards
	LDA ClimbSpeedUp
	LDY zPlayerYHi
	BMI SetPlayerScreenPosition_DoClimbingTransition

	; Climbing downwards
	LDA iPlayerScreenY
	CMP #$B8
	BCC SetPlayerScreenPosition_Exit

	; Set y-position to an odd number
	LSR zPlayerYLo
	SEC
	ROL zPlayerYLo
	LDA ClimbSpeedDown

SetPlayerScreenPosition_DoClimbingTransition:
	STA zPlayerYVelocity
	LDA #PlayerState_ClimbingAreaTransition
	STA zPlayerState
	RTS


;
; Calculate the x-velocity of the camera based on the distance between the player
; and the center of the screen.
;
GetMoveCameraX:
	LDA #$00
	LDY iScrollXLock
	BNE GetMoveCameraX_Exit

	LDA zPlayerXLo
	SEC
	SBC #$78
	SEC
	SBC iBoundLeftLower

GetMoveCameraX_Exit:
	STA zXVelocity
	RTS


; Tiles to use for eye sprite. If $00, this will use the character-specific table
CharacterFrameEyeTiles:
	.db $00 ; Walk1
	.db $00 ; Carry1
	.db $00 ; Walk2
	.db $00 ; Carry2
	.db $FB ; Duck
	.db $FB ; DuckCarry
	.db $00 ; Jump
	.db $FB ; Death
	.db $FB ; Lift
	.db $00 ; Throw
	.db $FB ; Climb

; Specific to each character
CharacterEyeTiles:
	.db $D5 ; Mario
	.db $D9 ; Luigi
	.db $FB ; Toad
	.db $D7 ; Princess

CharacterTiles_Walk1:
	.db $00
	.db $02
	.db $04 ; $00 - start of relative character tile offets, for some reason
	.db $06 ; $01

CharacterTiles_Carry1:
	.db $0C ; $02
	.db $0E ; $03
	.db $10 ; $04
	.db $12 ; $05

CharacterTiles_Walk2:
	.db $00 ; $06
	.db $02 ; $07
	.db $08 ; $08
	.db $0A ; $09

CharacterTiles_Carry2:
	.db $0C ; $0a
	.db $0E ; $0b
	.db $14 ; $0c
	.db $16 ; $0d

CharacterTiles_Duck:
	.db $FB ; $0e
	.db $FB ; $0f
	.db $2C ; $10
	.db $2C ; $11

CharacterTiles_DuckCarry:
	.db $FB ; $12
	.db $FB ; $13
	.db $2E ; $14
	.db $2E ; $15

CharacterTiles_Jump:
	.db $0C ; $16
	.db $0E ; $17
	.db $10 ; $18
	.db $12 ; $19

CharacterTiles_Death:
	.db $30 ; $1a
	.db $30 ; $1b
	.db $32 ; $1c
	.db $32 ; $1d

CharacterTiles_Lift:
	.db $20 ; $1e
	.db $22 ; $1f
	.db $24 ; $20
	.db $26 ; $21

CharacterTiles_Throw:
	.db $00 ; $22
	.db $02 ; $23
	.db $28 ; $24
	.db $2A ; $25

CharacterTiles_Climb:
	.db $18 ; $26
	.db $1A ; $27
	.db $1C ; $28
	.db $1E ; $29

CharacterTiles_PrincessJumpBody:
	.db $B4 ; $2a
	.db $B6 ; $2b

DamageInvulnBlinkFrames:
	.db $01, $01, $01, $02, $02, $04, $04, $04


;
; Renders the player sprite
;
RenderPlayer:
	LDY zPlayerState
	CPY #PlayerState_ChangingSize
	BEQ loc_BANKF_F337

	LDY iStarTimer
	BNE loc_BANKF_F337

	LDA zDamageCooldown ; Determine if the player is invincible from damage,
; and if so, if they should be visible
	BEQ loc_BANKF_F345

	LSR A
	LSR A
	LSR A
	LSR A
	TAY
	LDA zDamageCooldown
	AND DamageInvulnBlinkFrames, Y
	BNE loc_BANKF_F345
	RTS

; ---------------------------------------------------------------------------

loc_BANKF_F337:
	LDA z10
	CPY #$18
	BCS loc_BANKF_F33F

	LSR A
	LSR A

loc_BANKF_F33F:
	AND #ObjAttrib_Palette
	ORA zPlayerAttributes
	STA zPlayerAttributes

loc_BANKF_F345:
	LDA iQuicksandDepth
	BEQ loc_BANKF_F350

	LDA #ObjAttrib_BehindBackground
	ORA zPlayerAttributes
	STA zPlayerAttributes

loc_BANKF_F350:
	LDA iPlayerScreenX
	STA iVirtualOAM + $23
	STA iVirtualOAM + $2B
	CLC
	ADC #$08
	STA iVirtualOAM + $27
	STA iVirtualOAM + $2F
	LDA iPlayerScreenY
	STA z00
	LDA iPlayerScreenYPage
	STA z01
	LDY zPlayerAnimFrame
	CPY #$04
	BEQ loc_BANKF_F382

	LDA iCurrentPlayerSize
	BEQ loc_BANKF_F382

	LDA z00
	CLC
	ADC #$08
	STA z00
	BCC loc_BANKF_F382

	INC z01

loc_BANKF_F382:
	LDA zCurrentCharacter
	CMP #Character_Princess
	BEQ loc_BANKF_F394

	CPY #$00
	BNE loc_BANKF_F394

	LDA z00
	BNE loc_BANKF_F392

	DEC z01

loc_BANKF_F392:
	DEC z00

loc_BANKF_F394:
	JSR FindSpriteSlot

	LDA z01
	BNE loc_BANKF_F3A6

	LDA z00
	STA iVirtualOAM, Y
	STA iVirtualOAM + $20
	STA iVirtualOAM + $24

loc_BANKF_F3A6:
	LDA z00
	CLC
	ADC #$10
	STA z00
	LDA z01
	ADC #$00
	BNE loc_BANKF_F3BB

	LDA z00
	STA iVirtualOAM + $28
	STA iVirtualOAM + $2C

loc_BANKF_F3BB:
	LDA iCrouchJumpTimer
	CMP #$3C
	BCC loc_BANKF_F3CA

	LDA z10
	AND #ObjAttrib_Palette1
	ORA zPlayerAttributes
	STA zPlayerAttributes

loc_BANKF_F3CA:
	LDA zPlayerFacing
	LSR A
	ROR A
	ROR A
	ORA zPlayerAttributes
	AND #%11111100
	ORA #ObjAttrib_Palette1
	STA iVirtualOAM + 2, Y
	LDX zPlayerAnimFrame
	CPX #$07
	BEQ loc_BANKF_F3E2

	CPX #$04
	BNE loc_BANKF_F3EE

loc_BANKF_F3E2:
	LDA zPlayerAttributes
	STA iVirtualOAM + $22
	STA iVirtualOAM + $2A
	ORA #$40
	BNE loc_BANKF_F3F8

loc_BANKF_F3EE:
	AND #$FC
	ORA zPlayerAttributes
	STA iVirtualOAM + $22
	STA iVirtualOAM + $2A

loc_BANKF_F3F8:
	STA iVirtualOAM + $26
	STA iVirtualOAM + $2E
	LDA CharacterFrameEyeTiles, X
	BNE loc_BANKF_F408

	LDX zCurrentCharacter
	LDA CharacterEyeTiles, X

loc_BANKF_F408:
	STA iVirtualOAM + 1, Y

	LDA zPlayerAnimFrame
	CMP #$06
	BCS loc_BANKF_F413

	ORA zHeldItem

loc_BANKF_F413:
	ASL A
	ASL A
	TAX
	LDA zPlayerFacing
	BNE loc_BANKF_F44A

	LDA iVirtualOAM + $23
	STA iVirtualOAM + 3, Y
	LDA CharacterTiles_Walk1, X
	STA iVirtualOAM + $21
	LDA CharacterTiles_Walk1 + 1, X
	STA iVirtualOAM + $25
	LDA iCurrentPlayerSize
	BNE loc_BANKF_F43F

	LDA zCurrentCharacter
	CMP #Character_Princess
	BNE loc_BANKF_F43F

	LDA zPlayerAnimFrame
	CMP #SpriteAnimation_Jumping
	BNE loc_BANKF_F43F

	LDX #$2A

loc_BANKF_F43F:
	LDA CharacterTiles_Walk1 + 2, X
	STA iVirtualOAM + $29
	LDA CharacterTiles_Walk1 + 3, X
	BNE loc_BANKF_F478

loc_BANKF_F44A:
	LDA iVirtualOAM + $27
	STA iVirtualOAM + 3, Y
	LDA CharacterTiles_Walk1 + 1, X
	STA iVirtualOAM + $21
	LDA CharacterTiles_Walk1, X
	STA iVirtualOAM + $25
	LDA iCurrentPlayerSize
	BNE loc_BANKF_F46F

	LDA zCurrentCharacter
	CMP #Character_Princess
	BNE loc_BANKF_F46F

	LDA zPlayerAnimFrame
	CMP #SpriteAnimation_Jumping
	BNE loc_BANKF_F46F

	LDX #$2A

loc_BANKF_F46F:
	LDA CharacterTiles_Walk1 + 3, X
	STA iVirtualOAM + $29
	LDA CharacterTiles_Walk1 + 2, X

loc_BANKF_F478:
	STA iVirtualOAM + $2D
	RTS


; =============== S U B R O U T I N E =======================================

SetAreaStartPage:
	LDA zScrollCondition
	BNE SetAreaStartPage_HorizontalLevel

	LDY zPlayerYHi
	LDA zPlayerYLo
	JSR GetVerticalAreaStartPage

	TYA
	BPL SetAreaStartPage_SetAndExit
	LDA #$00
	BEQ SetAreaStartPage_SetAndExit

SetAreaStartPage_HorizontalLevel:
	LDA zPlayerXHi

SetAreaStartPage_SetAndExit:
	STA iCurrentLvlPage
	RTS

;
; Check if the player position requires vertical scrolling
;
DetermineVerticalScroll:
	; Exit if vertical scrolling is already happening
	LDX zScrollArray
	BNE DetermineVerticalScroll_Exit

	; Exit if the player is doing any kind of transition
	LDA zPlayerState
	CMP #PlayerState_Lifting
	BCS DetermineVerticalScroll_Exit

	; Use the player's position to detmine how to scroll
	LDA iPlayerScreenY
	LDY iPlayerScreenYPage
	BMI DetermineVerticalScroll_ScrollUpOnGround ; eg. `iPlayerScreenYPage == $FF`
	BNE DetermineVerticalScroll_ScrollDown ; eg. `iPlayerScreenYPage == $01`

	; Scroll down if player is near the bottom
	CMP #$B4
	BCS DetermineVerticalScroll_ScrollDown

	; Scroll up if the player is near the top
	CMP #$21
	BCS DetermineVerticalScroll_StartFromStationary

; Don't start scrolling for offscreen player until they're standing or climbing
DetermineVerticalScroll_ScrollUpOnGround:
	LDY zPlayerGrounding
	BNE DetermineVerticalScroll_StartFromStationary ; Player is in the air
	BEQ DetermineVerticalScroll_ScrollUp ; Player is NOT in the air

DetermineVerticalScroll_ScrollDown:
	; Set X = $02, scroll down
	INX

DetermineVerticalScroll_ScrollUp:
	; Set X = $01, scroll up
	INX

DetermineVerticalScroll_StartFromStationary:
	LDA iVerticalScrollVelocity
	STX iVerticalScrollVelocity
	BNE DetermineVerticalScroll_Exit

	; We weren't already vertically scrolling, but we need to start
	STX zScrollArray

DetermineVerticalScroll_Exit:
	RTS


; Determines start page for vertical area
GetVerticalAreaStartPage:
	STA z0f
	TYA
	BMI locret_BANKF_F4D9

	ASL A
	ASL A
	ASL A
	ASL A
	CLC
	ADC z0f
	BCS loc_BANKF_F4D5

	CMP #$F0
	BCC locret_BANKF_F4D9

loc_BANKF_F4D5:
	CLC
	ADC #$10
	INY

locret_BANKF_F4D9:
	RTS

; End of function GetVerticalAreaStartPage


SpriteFlickerDMAOffset:
	.db $C0
	.db $70
	.db $80
	.db $50
	.db $A0
	.db $40
	.db $B0
	.db $60
	.db $90
	.db $C0
	.db $70
	.db $80
	.db $50
	.db $A0
	.db $40
	.db $B0
	.db $60

; Sprite display configuration
ObjectAttributeTable:
	.db ObjAttrib_Palette1 ; $00 Enemy_Heart
	.db ObjAttrib_Palette1 ; $01 Enemy_ShyguyRed
	.db ObjAttrib_Palette1 ; $02 Enemy_Tweeter
	.db ObjAttrib_Palette3 ; $03 Enemy_ShyguyPink
	.db ObjAttrib_Palette2 ; $04 Enemy_Porcupo
	.db ObjAttrib_Palette1 ; $05 Enemy_SnifitRed
	.db ObjAttrib_Palette2 ; $06 Enemy_SnifitGray
	.db ObjAttrib_Palette3 ; $07 Enemy_SnifitPink
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 ; $08 Enemy_Ostro
	.db ObjAttrib_Palette1 ; $09 Enemy_BobOmb
	.db ObjAttrib_Palette1 | ObjAttrib_Horizontal | ObjAttrib_16x32 ; $0A Enemy_AlbatossCarryingBobOmb
	.db ObjAttrib_Palette1 | ObjAttrib_Horizontal | ObjAttrib_16x32 ; $0B Enemy_AlbatossStartRight
	.db ObjAttrib_Palette1 | ObjAttrib_Horizontal | ObjAttrib_16x32 ; $0C Enemy_AlbatossStartLeft
	.db ObjAttrib_Palette1 ; $0D Enemy_NinjiRunning
	.db ObjAttrib_Palette1 ; $0E Enemy_NinjiJumping
	.db ObjAttrib_Palette1 ; $0F Enemy_BeezoDiving
	.db ObjAttrib_Palette2 ; $10 Enemy_BeezoStraight
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $11 Enemy_WartBubble
	.db ObjAttrib_Palette1 | ObjAttrib_Horizontal | ObjAttrib_FrontFacing ; $12 Enemy_Pidgit
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing ; $13 Enemy_Trouter
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $14 Enemy_Hoopstar
	.db ObjAttrib_Palette0 ; $15 Enemy_JarGeneratorShyguy
	.db ObjAttrib_Palette0 ; $16 Enemy_JarGeneratorBobOmb
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing ; $17 Enemy_Phanto
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 | ObjAttrib_UpsideDown ; $18 Enemy_CobratJar
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 ; $19 Enemy_CobratSand
	.db ObjAttrib_Palette2 | ObjAttrib_FrontFacing ; $1A Enemy_Pokey
	.db ObjAttrib_Palette2 | ObjAttrib_FrontFacing ; $1B Enemy_Bullet
	.db ObjAttrib_Palette2 | ObjAttrib_16x32 ; $1C Enemy_Birdo
	.db ObjAttrib_Palette3 | ObjAttrib_16x32 ; $1D Enemy_Mouser
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing ; $1E Enemy_Egg
	.db ObjAttrib_Palette2 | ObjAttrib_FrontFacing ; $1F Enemy_Tryclyde
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $20 Enemy_Fireball
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 ; $21 Enemy_Clawgrip
	.db ObjAttrib_Palette2 ; $22 Enemy_ClawgripRock
	.db ObjAttrib_Palette1 ; $23 Enemy_PanserStationaryFiresAngled
	.db ObjAttrib_Palette3 ; $24 Enemy_PanserWalking
	.db ObjAttrib_Palette2 ; $25 Enemy_PanserStationaryFiresUp
	.db ObjAttrib_Palette1 ; $26 Enemy_Autobomb
	.db ObjAttrib_Palette1 ; $27 Enemy_AutobombFire
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing ; $28 Enemy_WhaleSpout
	.db ObjAttrib_Palette1 ; $29 Enemy_Flurry
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 ; $2A Enemy_Fryguy
	.db ObjAttrib_Palette1 ; $2B Enemy_FryguySplit
	.db ObjAttrib_Palette3 | ObjAttrib_Horizontal | ObjAttrib_FrontFacing | ObjAttrib_16x32 ; $2C Enemy_Wart
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 ; $2D Enemy_HawkmouthBoss
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $2E Enemy_Spark1
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $2F Enemy_Spark2
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $30 Enemy_Spark3
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $31 Enemy_Spark4
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored | ObjAttrib_UpsideDown ; $32 Enemy_VegetableSmall
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored | ObjAttrib_UpsideDown ; $33 Enemy_VegetableLarge
	.db ObjAttrib_Palette2 | ObjAttrib_Mirrored | ObjAttrib_UpsideDown ; $34 Enemy_VegetableWart
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored | ObjAttrib_UpsideDown ; $35 Enemy_Shell
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored | ObjAttrib_UpsideDown ; $36 Enemy_Coin
	.db ObjAttrib_Palette1 | ObjAttrib_UpsideDown ; $37 Enemy_Bomb
	.db ObjAttrib_Palette1 | ObjAttrib_UpsideDown ; $38 Enemy_Rocket
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing ; $39 Enemy_MushroomBlock
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing | ObjAttrib_UpsideDown ; $3A Enemy_POWBlock
	.db ObjAttrib_Palette1 | ObjAttrib_Horizontal | ObjAttrib_FrontFacing | ObjAttrib_16x32 ; $3B Enemy_FallingLogs
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing ; $3C Enemy_SubspaceDoor
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing ; $3D Enemy_Key
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing | ObjAttrib_UpsideDown ; $3E Enemy_SubspacePotion
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $3F Enemy_Mushroom
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing | ObjAttrib_UpsideDown ; $40 Enemy_Mushroom1up
	.db ObjAttrib_Palette1 | ObjAttrib_Horizontal | ObjAttrib_16x32 ; $41 Enemy_FlyingCarpet
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 ; $42 Enemy_HawkmouthRight
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 ; $43 Enemy_HawkmouthLeft
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $44 Enemy_CrystalBall
	.db ObjAttrib_Palette2 | ObjAttrib_Mirrored ; $45 Enemy_Starman
	.db ObjAttrib_Palette2 | ObjAttrib_Mirrored | ObjAttrib_UpsideDown ; $46 Enemy_Stopwatch

;
; Enemy Behavior 46E
;
;   bit 7 ($80) - uses mirrored sprite for animation
;   bit 6 ($40) - double speed
;   bit 5 ($20) - wider sprite? used for mouser
;   bit 4 ($10) - use tilemap 2
;   bit 3 ($08) - squawk on death (prevents despawning offscreen?)
;   bit 2 ($04) - disable collision with other enemies
;   bit 1 ($02) - unliftable
;   bit 0 ($01) - hurts when touched from above
EnemyArray_46E_Data:
	.db %00000100 ; $00 Enemy_Heart
	.db %00000000 ; $01 Enemy_ShyguyRed
	.db %00000000 ; $02 Enemy_Tweeter
	.db %00000000 ; $03 Enemy_ShyguyPink
	.db %00000011 ; $04 Enemy_Porcupo
	.db %00000000 ; $05 Enemy_SnifitRed
	.db %00000000 ; $06 Enemy_SnifitGray
	.db %00000000 ; $07 Enemy_SnifitPink
	.db %01010000 ; $08 Enemy_Ostro
	.db %01000000 ; $09 Enemy_BobOmb
	.db %01000010 ; $0A Enemy_AlbatossCarryingBobOmb
	.db %01000010 ; $0B Enemy_AlbatossStartRight
	.db %01000010 ; $0C Enemy_AlbatossStartLeft
	.db %01000000 ; $0D Enemy_NinjiRunning
	.db %01000000 ; $0E Enemy_NinjiJumping
	.db %01000000 ; $0F Enemy_BeezoDiving
	.db %01000000 ; $10 Enemy_BeezoStraight
	.db %00010011 ; $11 Enemy_WartBubble
	.db %11010000 ; $12 Enemy_Pidgit
	.db %10000000 ; $13 Enemy_Trouter
	.db %00000000 ; $14 Enemy_Hoopstar
	.db %00000110 ; $15 Enemy_JarGeneratorShyguy
	.db %00000110 ; $16 Enemy_JarGeneratorBobOmb
	.db %00000111 ; $17 Enemy_Phanto
	.db %00010000 ; $18 Enemy_CobratJar
	.db %01010000 ; $19 Enemy_CobratSand
	.db %10010000 ; $1A Enemy_Pokey
	.db %00000111 ; $1B Enemy_Bullet
	.db %00001010 ; $1C Enemy_Birdo
	.db %00111011 ; $1D Enemy_Mouser
	.db %01000000 ; $1E Enemy_Egg
	.db %00011000 ; $1F Enemy_Tryclyde
	.db %00000111 ; $20 Enemy_Fireball
	.db %00011011 ; $21 Enemy_Clawgrip
	.db %00010000 ; $22 Enemy_ClawgripRock
	.db %00000111 ; $23 Enemy_PanserStationaryFiresAngled
	.db %00000111 ; $24 Enemy_PanserWalking
	.db %00000111 ; $25 Enemy_PanserStationaryFiresUp
	.db %01010000 ; $26 Enemy_Autobomb
	.db %01010011 ; $27 Enemy_AutobombFire
	.db %10010110 ; $28 Enemy_WhaleSpout
	.db %01010000 ; $29 Enemy_Flurry
	.db %10011011 ; $2A Enemy_Fryguy
	.db %11010011 ; $2B Enemy_FryguySplit
	.db %00011011 ; $2C Enemy_Wart
	.db %00001011 ; $2D Enemy_HawkmouthBoss
	.db %00000011 ; $2E Enemy_Spark1
	.db %00000011 ; $2F Enemy_Spark2
	.db %00000011 ; $30 Enemy_Spark3
	.db %00000011 ; $31 Enemy_Spark4
	.db %00000000 ; $32 Enemy_VegetableSmall
	.db %00000000 ; $33 Enemy_VegetableLarge
	.db %00000000 ; $34 Enemy_VegetableWart
	.db %00000000 ; $35 Enemy_Shell
	.db %00000100 ; $36 Enemy_Coin
	.db %00000100 ; $37 Enemy_Bomb
	.db %00000100 ; $38 Enemy_Rocket
	.db %00000000 ; $39 Enemy_MushroomBlock
	.db %00000000 ; $3A Enemy_POWBlock
	.db %00000110 ; $3B Enemy_FallingLogs
	.db %00000100 ; $3C Enemy_SubspaceDoor
	.db %00000000 ; $3D Enemy_Key
	.db %00000100 ; $3E Enemy_SubspacePotion
	.db %00000100 ; $3F Enemy_Mushroom
	.db %00000100 ; $40 Enemy_Mushroom1up
	.db %00010110 ; $41 Enemy_FlyingCarpet
	.db %00000110 ; $42 Enemy_HawkmouthRight
	.db %00000110 ; $43 Enemy_HawkmouthLeft
	.db %00001100 ; $44 Enemy_CrystalBall
	.db %00000100 ; $45 Enemy_Starman
	.db %00000100 ; $46 Enemy_Stopwatch

;
; Index for tile collision bounding box table
;
EnemyArray_492_Data:
	.db $00 ; $00 Enemy_Heart
	.db $05 ; $01 Enemy_ShyguyRed
	.db $05 ; $02 Enemy_Tweeter
	.db $05 ; $03 Enemy_ShyguyPink
	.db $05 ; $04 Enemy_Porcupo
	.db $05 ; $05 Enemy_SnifitRed
	.db $05 ; $06 Enemy_SnifitGray
	.db $05 ; $07 Enemy_SnifitPink
	.db $0C ; $08 Enemy_Ostro
	.db $05 ; $09 Enemy_BobOmb
	.db $05 ; $0A Enemy_AlbatossCarryingBobOmb
	.db $05 ; $0B Enemy_AlbatossStartRight
	.db $05 ; $0C Enemy_AlbatossStartLeft
	.db $05 ; $0D Enemy_NinjiRunning
	.db $05 ; $0E Enemy_NinjiJumping
	.db $05 ; $0F Enemy_BeezoDiving
	.db $05 ; $10 Enemy_BeezoStraight
	.db $05 ; $11 Enemy_WartBubble
	.db $05 ; $12 Enemy_Pidgit
	.db $05 ; $13 Enemy_Trouter
	.db $05 ; $14 Enemy_Hoopstar
	.db $0D ; $15 Enemy_JarGeneratorShyguy
	.db $0D ; $16 Enemy_JarGeneratorBobOmb
	.db $05 ; $17 Enemy_Phanto
	.db $0C ; $18 Enemy_CobratJar
	.db $0C ; $19 Enemy_CobratSand
	.db $05 ; $1A Enemy_Pokey
	.db $0D ; $1B Enemy_Bullet
	.db $0C ; $1C Enemy_Birdo
	.db $0C ; $1D Enemy_Mouser
	.db $05 ; $1E Enemy_Egg
	.db $0E ; $1F Enemy_Tryclyde
	.db $0D ; $20 Enemy_Fireball
	.db $0C ; $21 Enemy_Clawgrip
	.db $05 ; $22 Enemy_ClawgripRock
	.db $05 ; $23 Enemy_PanserStationaryFiresAngled
	.db $05 ; $24 Enemy_PanserWalking
	.db $05 ; $25 Enemy_PanserStationaryFiresUp
	.db $0C ; $26 Enemy_Autobomb
	.db $05 ; $27 Enemy_AutobombFire
	.db $05 ; $28 Enemy_WhaleSpout
	.db $05 ; $29 Enemy_Flurry
	.db $05 ; $2A Enemy_Fryguy
	.db $05 ; $2B Enemy_FryguySplit
	.db $05 ; $2C Enemy_Wart
	.db $00 ; $2D Enemy_HawkmouthBoss
	.db $0F ; $2E Enemy_Spark1
	.db $0F ; $2F Enemy_Spark2
	.db $0F ; $30 Enemy_Spark3
	.db $0F ; $31 Enemy_Spark4
	.db $05 ; $32 Enemy_VegetableSmall
	.db $05 ; $33 Enemy_VegetableLarge
	.db $05 ; $34 Enemy_VegetableWart
	.db $05 ; $35 Enemy_Shell
	.db $05 ; $36 Enemy_Coin
	.db $05 ; $37 Enemy_Bomb
	.db $05 ; $38 Enemy_Rocket
	.db $04 ; $39 Enemy_MushroomBlock
	.db $04 ; $3A Enemy_POWBlock
	.db $04 ; $3B Enemy_FallingLogs
	.db $04 ; $3C Enemy_SubspaceDoor
	.db $04 ; $3D Enemy_Key
	.db $04 ; $3E Enemy_SubspacePotion
	.db $04 ; $3F Enemy_Mushroom
	.db $04 ; $40 Enemy_Mushroom1up
	.db $10 ; $41 Enemy_FlyingCarpet
	.db $00 ; $42 Enemy_HawkmouthRight
	.db $00 ; $43 Enemy_HawkmouthLeft
	.db $05 ; $44 Enemy_CrystalBall
	.db $05 ; $45 Enemy_Starman
	.db $05 ; $46 Enemy_Stopwatch

;
; Index for object collision bounding box table
;
ObjectHitbox_Data:
	.db $08 ; $00 Enemy_Heart
	.db $02 ; $01 Enemy_ShyguyRed
	.db $02 ; $02 Enemy_Tweeter
	.db $02 ; $03 Enemy_ShyguyPink
	.db $02 ; $04 Enemy_Porcupo
	.db $02 ; $05 Enemy_SnifitRed
	.db $02 ; $06 Enemy_SnifitGray
	.db $02 ; $07 Enemy_SnifitPink
	.db $04 ; $08 Enemy_Ostro
	.db $02 ; $09 Enemy_BobOmb
	.db $09 ; $0A Enemy_AlbatossCarryingBobOmb
	.db $09 ; $0B Enemy_AlbatossStartRight
	.db $09 ; $0C Enemy_AlbatossStartLeft
	.db $02 ; $0D Enemy_NinjiRunning
	.db $02 ; $0E Enemy_NinjiJumping
	.db $02 ; $0F Enemy_BeezoDiving
	.db $02 ; $10 Enemy_BeezoStraight
	.db $02 ; $11 Enemy_WartBubble
	.db $02 ; $12 Enemy_Pidgit
	.db $02 ; $13 Enemy_Trouter
	.db $02 ; $14 Enemy_Hoopstar
	.db $08 ; $15 Enemy_JarGeneratorShyguy
	.db $08 ; $16 Enemy_JarGeneratorBobOmb
	.db $02 ; $17 Enemy_Phanto
	.db $04 ; $18 Enemy_CobratJar
	.db $04 ; $19 Enemy_CobratSand
	.db $0E ; $1A Enemy_Pokey
	.db $08 ; $1B Enemy_Bullet
	.db $04 ; $1C Enemy_Birdo
	.db $04 ; $1D Enemy_Mouser
	.db $02 ; $1E Enemy_Egg
	.db $0F ; $1F Enemy_Tryclyde
	.db $02 ; $20 Enemy_Fireball
	.db $13 ; $21 Enemy_Clawgrip
	.db $02 ; $22 Enemy_ClawgripRock
	.db $02 ; $23 Enemy_PanserStationaryFiresAngled
	.db $02 ; $24 Enemy_PanserWalking
	.db $02 ; $25 Enemy_PanserStationaryFiresUp
	.db $10 ; $26 Enemy_Autobomb
	.db $02 ; $27 Enemy_AutobombFire
	.db $12 ; $28 Enemy_WhaleSpout
	.db $02 ; $29 Enemy_Flurry
	.db $0F ; $2A Enemy_Fryguy
	.db $02 ; $2B Enemy_FryguySplit
	.db $11 ; $2C Enemy_Wart
	.db $0B ; $2D Enemy_HawkmouthBoss
	.db $02 ; $2E Enemy_Spark1
	.db $02 ; $2F Enemy_Spark2
	.db $02 ; $30 Enemy_Spark3
	.db $02 ; $31 Enemy_Spark4
	.db $02 ; $32 Enemy_VegetableSmall
	.db $02 ; $33 Enemy_VegetableLarge
	.db $02 ; $34 Enemy_VegetableWart
	.db $02 ; $35 Enemy_Shell
	.db $02 ; $36 Enemy_Coin
	.db $02 ; $37 Enemy_Bomb
	.db $04 ; $38 Enemy_Rocket
	.db $03 ; $39 Enemy_MushroomBlock
	.db $03 ; $3A Enemy_POWBlock
	.db $07 ; $3B Enemy_FallingLogs
	.db $04 ; $3C Enemy_SubspaceDoor
	.db $03 ; $3D Enemy_Key
	.db $03 ; $3E Enemy_SubspacePotion
	.db $03 ; $3F Enemy_Mushroom
	.db $03 ; $40 Enemy_Mushroom1up
	.db $09 ; $41 Enemy_FlyingCarpet
	.db $0B ; $42 Enemy_HawkmouthRight
	.db $0B ; $43 Enemy_HawkmouthLeft
	.db $02 ; $44 Enemy_CrystalBall
	.db $02 ; $45 Enemy_Starman
	.db $02 ; $46 Enemy_Stopwatch

; More collision (post-throw)
EnemyPlayerCollisionTable:
	.db $00 ; $00 Enemy_Heart
	.db $00 ; $01 Enemy_ShyguyRed
	.db $00 ; $02 Enemy_Tweeter
	.db $00 ; $03 Enemy_ShyguyPink
	.db $00 ; $04 Enemy_Porcupo
	.db $00 ; $05 Enemy_SnifitRed
	.db $00 ; $06 Enemy_SnifitGray
	.db $00 ; $07 Enemy_SnifitPink
	.db $00 ; $08 Enemy_Ostro
	.db $00 ; $09 Enemy_BobOmb
	.db $00 ; $0A Enemy_AlbatossCarryingBobOmb
	.db $00 ; $0B Enemy_AlbatossStartRight
	.db $00 ; $0C Enemy_AlbatossStartLeft
	.db $00 ; $0D Enemy_NinjiRunning
	.db $00 ; $0E Enemy_NinjiJumping
	.db $00 ; $0F Enemy_BeezoDiving
	.db $00 ; $10 Enemy_BeezoStraight
	.db $00 ; $11 Enemy_WartBubble
	.db $00 ; $12 Enemy_Pidgit
	.db $00 ; $13 Enemy_Trouter
	.db $00 ; $14 Enemy_Hoopstar
	.db $00 ; $15 Enemy_JarGeneratorShyguy
	.db $00 ; $16 Enemy_JarGeneratorBobOmb
	.db $00 ; $17 Enemy_Phanto
	.db $00 ; $18 Enemy_CobratJar
	.db $00 ; $19 Enemy_CobratSand
	.db $00 ; $1A Enemy_Pokey
	.db $00 ; $1B Enemy_Bullet
	.db $00 ; $1C Enemy_Birdo
	.db $00 ; $1D Enemy_Mouser
	.db $00 ; $1E Enemy_Egg
	.db $00 ; $1F Enemy_Tryclyde
	.db $00 ; $20 Enemy_Fireball
	.db $00 ; $21 Enemy_Clawgrip
	.db $00 ; $22 Enemy_ClawgripRock
	.db $00 ; $23 Enemy_PanserStationaryFiresAngled
	.db $00 ; $24 Enemy_PanserWalking
	.db $00 ; $25 Enemy_PanserStationaryFiresUp
	.db $00 ; $26 Enemy_Autobomb
	.db $00 ; $27 Enemy_AutobombFire
	.db $00 ; $28 Enemy_WhaleSpout
	.db $00 ; $29 Enemy_Flurry
	.db $00 ; $2A Enemy_Fryguy
	.db $00 ; $2B Enemy_FryguySplit
	.db $00 ; $2C Enemy_Wart
	.db $00 ; $2D Enemy_HawkmouthBoss
	.db $00 ; $2E Enemy_Spark1
	.db $00 ; $2F Enemy_Spark2
	.db $00 ; $30 Enemy_Spark3
	.db $00 ; $31 Enemy_Spark4
	.db $01 ; $32 Enemy_VegetableSmall
	.db $01 ; $33 Enemy_VegetableLarge
	.db $01 ; $34 Enemy_VegetableWart
	.db $01 ; $35 Enemy_Shell
	.db $02 ; $36 Enemy_Coin
	.db $01 ; $37 Enemy_Bomb
	.db $00 ; $38 Enemy_Rocket
	.db $02 ; $39 Enemy_MushroomBlock
	.db $03 ; $3A Enemy_POWBlock
	.db $02 ; $3B Enemy_FallingLogs
	.db $04 ; $3C Enemy_SubspaceDoor
	.db $02 ; $3D Enemy_Key
	.db $02 ; $3E Enemy_SubspacePotion
	.db $02 ; $3F Enemy_Mushroom
	.db $02 ; $40 Enemy_Mushroom1up
	.db $02 ; $41 Enemy_FlyingCarpet
	.db $02 ; $42 Enemy_HawkmouthRight
	.db $02 ; $43 Enemy_HawkmouthLeft
	.db $02 ; $44 Enemy_CrystalBall
	.db $00 ; $45 Enemy_Starman
	.db $02 ; $46 Enemy_Stopwatch

; @TODO: use flag
;
; This table determines the "solidness" of tiles.
;
; Solidness is broken into four tiers:
;   - background (no collisions)
;   - background to player/enemies, solid to mushroom blocks
;   - jumpthrough block (collision on top only)
;   - solid block (collision on all sides)
;
; Tiles are divided into groups of $40. For each category, the corresponding
; the groups are divided into two groups: tiles that have a collision rule and
; tiles that don't.
;
TileSolidnessTable:
	; solid to mushroom blocks unless < these values
	.db $01
	.db $43
	.db $80
	.db $C0
	; solid on top unless < these values
	.db $12
	.db $60
	.db $91
	.db $CA
	; solid on all sides unless < these values
	.db $18
	.db $69
	.db $98
	.db $D5

;
; ### Warp destination lookup table
;
; The row is the (0-indexed) world that you're on, the value is the destination.
;
WarpDestinations:
	.db $03
	.db $01
	.db $04
	.db $05
	.db $06
	.db $05
	.db $06


;
; Updates joypad press/held values
;
UpdateJoypads:
	; Work around DPCM sample bug,
	; where some spurious inputs are read
	JSR ReadJoypads
	LDA zInputBottleneck
	STA iBackupInput
	JSR ReadJoypads
	LDA zInputBottleneck
	STA iBackupInput + 1
	LDX #1
	EOR iBackupInput
	BEQ UpdateJoypads_Loop
	TAX

	LDA iBackupInput + 1
	BEQ UpdateJoypads_FoundCorrectInput
	LDA iBackupInput
	BEQ UpdateJoypads_FoundCorrectInput

	JSR UpdateJoypads_FindDeletion

	LDA iBackupInput, Y

UpdateJoypads_FoundCorrectInput:
	STA zInputBottleneck
	LDX #1

UpdateJoypads_Loop:
	LDA zInputBottleneck, X ; Update the press/held values
	TAY
	EOR zInputCurrentState, X
	AND zInputBottleneck, X
	STA zInputBottleneck, X
	STY zInputCurrentState, X
	DEX
	BPL UpdateJoypads_Loop
	RTS

UpdateJoypads_FindDeletion:
	TXA
	AND iBackupInput
	STA iBackupInput + 2
	TXA
	AND iBackupInput + 1
	STA iBackupInput + 3
	LDY #0
UpdateJoypads_FindDeletion_Loop:
	LSR iBackupInput + 3
	BCS UpdateJoypads_FindDeletion_Found
	LDY #1
	LDA iBackupInput + 3
	BEQ UpdateJoypads_FindDeletion_Found
	LSR iBackupInput + 2
	BCS UpdateJoypads_FindDeletion_Found
	LDY #0
	LDA iBackupInput + 2
	BNE UpdateJoypads_FindDeletion_Loop
UpdateJoypads_FindDeletion_Found:
	RTS

;
; Reads joypad pressed input
;
ReadJoypads:
	LDX #$01
	STX JOY1
	DEX
	STX JOY1

	LDX #$08
ReadJoypadLoop:
	LDA JOY1
	LSR A
	; Read D0 standard controller data
	ROL zInputBottleneck
	LSR A
	; Read D1 expansion port controller data
	;
	; Before you get too excited, keep in mind that this code is basically ported from the FDS bios.
	; Code to mux D1 and D0 isn't present, so even if you had an expansion port controller that used
	; D1, the game wouldn't use it!
	ROL iExpansionInput

	LDA JOY2
	LSR A
	ROL zInputBottleneck + 1
	LSR A
	ROL iExpansionInput + 1
	DEX
	BNE ReadJoypadLoop
	RTS


;
; Load the area specified by the area pointer at the current page
;
FollowCurrentAreaPointer:
	LDA iCurrentLvlPage
	ASL A
	TAY
	LDA iAreaAddresses, Y
	STA iCurrentLvl
	STA sSavedLvl
	INY
	LDA iAreaAddresses, Y
	LSR A
	LSR A
	LSR A
	LSR A
	STA iCurrentLvlArea
	LDA iAreaAddresses, Y
	AND #$0F
	STA iCurrentLvlEntryPage
	STA sSavedLvlEntryPage
	RTS




DoAreaReset:
	LDA #$00
	STA iAreaInitFlag
	STA iObjectToUseNextRoom
	STA iSubTimeLeft
	STA iSubDoorTimer
	LDX #$08

DoAreaReset_EnemyLoop:
	LDA zEnemyState, X
	BEQ DoAreaReset_EnemyLoopEnd

	LDA zHeldObjectTimer, X
	BEQ DoAreaReset_AfterCarryOver

	LDA zObjectType, X
	CMP #Enemy_MushroomBlock
	BEQ DoAreaReset_AfterCarryOver

	STA iObjectToUseNextRoom

DoAreaReset_AfterCarryOver:
	JSR AreaResetEnemyDestroy

DoAreaReset_EnemyLoopEnd:
	DEX
	BPL DoAreaReset_EnemyLoop

	LDX z12
	RTS

; End of function DoAreaReset

; =============== S U B R O U T I N E =======================================

AreaResetEnemyDestroy:
	; load raw enemy data offset so we can allow the level object to respawn
	LDY iEnemyRawDataOffset, X
	; nothing to reset if offset is invalid
	BMI AreaResetEnemyDestroy_AfterAllowRespawn

	; disabling bit 7 allows the object to respawn
	LDA (zRawSpriteData), Y
	AND #$7F
	STA (zRawSpriteData), Y

AreaResetEnemyDestroy_AfterAllowRespawn:
	LDA #EnemyState_Inactive
	STA zEnemyState, X
	RTS

; End of function AreaResetEnemyDestroy

; =============== S U B R O U T I N E =======================================

KillPlayer:
	LDA #PlayerState_Dying ; Mark player as dead
	STA zPlayerState
	LDA #$00 ; Clear some variables
	STA iPlayerHP
	STA iCrouchJumpTimer
	STA iStarTimer
	LDA #SpriteAnimation_Dead ; Set player animation to dead?
	STA zPlayerAnimFrame
	LDA zHeldItem
	BEQ loc_BANKF_F749

	; Probably something to throw away
	; a held item on death
	DEC zHeldItem
	LDY iHeldItemIndex
	STA iObjectBulletTimer, Y
	LSR A
	STA zHeldObjectTimer, Y
	STA zObjectXVelocity, Y
	LDA #$E0
	STX z0d
	LDX zEnemyState, Y
	CPX #EnemyState_Sinking
	BEQ loc_BANKF_F747

	STA zObjectYVelocity, Y

loc_BANKF_F747:
	LDX z0d

loc_BANKF_F749:
	; Set music to death jingle
	LDA #Music_DeathJingle
	STA iMusicQueue
	LDA iStack
	CMP #Stack100_Pause
	BNE KillPlayer_Eject

	LDA #ControllerInput_Start
	STA zInputBottleneck

KillPlayer_Eject:
	RTS


;
; ## Tile Quads
;
; Map tiles are made of 4 pattern table tiles arranged in a 2x2 block.
;
; These map tiles are broken up into four tables (`$00-$3F`, `$40-$7F`, `$80-$BF`, `$C0-$FF`) for
; addressability (the tile index is multiplied by 4 to get the first byte). Each table
; coincidentally corresponds to a background subpalette as well.
;

;
; #### Tile quad pointers
;
TileQuadPointersLo:
	.db <TileQuads1
	.db <TileQuads2
	.db <TileQuads3
	.db <TileQuads4

TileQuadPointersHi:
	.db >TileQuads1
	.db >TileQuads2
	.db >TileQuads3
	.db >TileQuads4

;
; #### Tile quad pattern table values
;
; Each subtable corresponds to `$40` tiles so that a single byte offset can be used to address each
; map tile within the table.
;
TileQuads1:
	.db $FE, $FE, $FE, $FE ; $00
	.db $B4, $B6, $B5, $B7 ; $04
	.db $B8, $FA, $B9, $FA ; $08
	.db $FA, $FA, $B2, $B3 ; $0C
	.db $BE, $BE, $BF, $BF ; $10
	.db $BF, $BF, $BF, $BF ; $14
	.db $4A, $4A, $4B, $4B ; $18
	.db $5E, $5F, $5E, $5F ; $1C
	.db $E8, $E8, $A9, $A9 ; $20
	.db $46, $FC, $46, $FC ; $24
	.db $A9, $A9, $A9, $A9 ; $28
	.db $FC, $FC, $FC, $FC ; $2C
	.db $E9, $E9, $A9, $A9 ; $30
	.db $FC, $48, $FC, $48 ; $34
	.db $11, $11, $11, $11 ; $38 ; unused
	.db $22, $22, $22, $22 ; $3C ; unused
	.db $33, $33, $33, $33 ; $40 ; unused
	.db $E8, $EB, $A9, $A9 ; $44
	.db $74, $76, $75, $77 ; $48
	.db $98, $9A, $99, $9B ; $4C
	.db $9C, $9A, $9D, $9B ; $50
	.db $9C, $9E, $9B, $9F ; $54
	.db $58, $5A, $59, $5B ; $58
	.db $5E, $5F, $5E, $5F ; $5C
	.db $8E, $8F, $8F, $8E ; $60
	.db $72, $73, $73, $72 ; $64
	.db $A6, $A6, $A7, $A7 ; $68
	.db $92, $93, $93, $92 ; $6C
	.db $74, $76, $75, $77 ; $70
	.db $70, $72, $71, $73 ; $74
	.db $71, $73, $71, $73 ; $78
	.db $24, $26, $25, $27 ; $7C
	.db $32, $34, $33, $35 ; $80
	.db $33, $35, $33, $35 ; $84
	.db $24, $26, $25, $27 ; $88

TileQuads2:
	.db $FA, $FA, $FA, $FA ; $00
	.db $FA, $FA, $FA, $FA ; $04
	.db $FA, $FA, $FA, $FA ; $08
	.db $FA, $FA, $B0, $B1 ; $0C
	.db $FA, $FA, $B0, $B1 ; $10
	.db $FA, $FA, $B0, $B1 ; $14
	.db $FA, $FA, $B0, $B1 ; $18
	.db $FA, $FA, $B0, $B1 ; $1C
	.db $FA, $FA, $B0, $B1 ; $20
	.db $FA, $FA, $B0, $B1 ; $24
	.db $FA, $FA, $B0, $B1 ; $28
	.db $FA, $FA, $B0, $B1 ; $2C
	.db $FA, $FA, $B0, $B1 ; $30
	.db $FA, $FA, $B0, $B1 ; $34
	.db $A0, $A2, $A1, $A3 ; $38
	.db $80, $82, $81, $83 ; $3C
	.db $F4, $86, $F5, $87 ; $40
	.db $84, $86, $85, $87 ; $44
	.db $FC, $FC, $FC, $FC ; $48
	.db $AD, $FB, $AC, $AD ; $4C
	.db $AC, $AC, $AC, $AC ; $50
	.db $FB, $3B, $3B, $AC ; $54
	.db $FC, $FC, $FC, $FC ; $58
	.db $F4, $86, $F5, $87 ; $5C
	.db $FB, $49, $49, $FB ; $60
	.db $FE, $FE, $FE, $FE ; $64
	.db $FE, $FE, $6D, $FE ; $68
	.db $3C, $3E, $3D, $3F ; $6C
	.db $58, $FD, $59, $5A ; $70
	.db $5B, $5A, $FD, $FD ; $74
	.db $5B, $5C, $FD, $5D ; $78
	.db $FD, $FD, $5B, $5A ; $7C
	.db $6C, $FE, $FE, $FE ; $80
	.db $FE, $FE, $FE, $FE ; $84
	.db $FE, $6E, $FE, $6F ; $88
	.db $20, $22, $21, $23 ; $8C
	.db $6E, $6F, $70, $71 ; $90
	.db $57, $57, $FB, $FB ; $94
	.db $57, $57, $FE, $FE ; $98
	.db $D3, $D3, $FB, $FB ; $9C
	.db $D2, $D2, $FB, $FB ; $A0
	.db $7C, $7E, $7D, $7F ; $A4
	.db $CA, $CC, $CB, $CD ; $A8
	.db $CA, $CC, $CB, $CD ; $AC
	.db $C0, $C2, $C1, $C3 ; $B0
	.db $2C, $2E, $2D, $2F ; $B4
	.db $8E, $8F, $8F, $8E ; $B8
	.db $88, $8A, $89, $8B ; $BC
	.db $89, $8B, $89, $8B ; $C0
	.db $89, $8B, $8C, $8D ; $C4
	.db $88, $8A, $8C, $8D ; $C8
	.db $88, $8A, $89, $8B ; $CC
	.db $88, $8A, $89, $8B ; $D0
	.db $6A, $6C, $6B, $6D ; $D4
	.db $6C, $6C, $6D, $6D ; $D8
	.db $6C, $6E, $6D, $6F ; $DC
	.db $6C, $54, $6D, $55 ; $E0
	.db $32, $34, $33, $35 ; $E4
	.db $33, $35, $33, $35 ; $E8

TileQuads3:
	.db $94, $95, $94, $95 ; $00
	.db $96, $97, $96, $97 ; $04
	.db $48, $49, $48, $49 ; $08
	.db $FE, $FE, $FE, $FE ; $0C
	.db $FB, $32, $32, $33 ; $10
	.db $33, $33, $33, $33 ; $14
	.db $FD, $FD, $FD, $FD ; $18
	.db $34, $FB, $FD, $34 ; $1C
	.db $FB, $30, $FB, $FB ; $20
	.db $FB, $FB, $31, $FB ; $24
	.db $D0, $D0, $D0, $D0 ; $28
	.db $D1, $D1, $D1, $D1 ; $2C
	.db $64, $66, $65, $67 ; $30
	.db $68, $6A, $69, $6B ; $34
	.db $FA, $6C, $FA, $6C ; $38
	.db $6D, $FA, $6D, $FA ; $3C
	.db $92, $93, $93, $92 ; $40
	.db $AE, $AF, $AE, $AF ; $44
	.db $78, $7A, $79, $7B ; $48
	.db $A8, $A8, $AF, $AE ; $4C
	.db $94, $95, $94, $95 ; $50
	.db $96, $97, $96, $97 ; $54
	.db $22, $24, $23, $25 ; $58
	.db $92, $93, $93, $92 ; $5C
	.db $50, $51, $50, $51 ; $60
	.db $AE, $AF, $AE, $AF ; $64
	.db $50, $51, $50, $51 ; $68
	.db $8E, $8F, $8F, $8E ; $6C
	.db $72, $73, $73, $72 ; $70
	.db $50, $52, $51, $53 ; $74
	.db $FD, $FD, $FD, $FD ; $78
	.db $FB, $36, $36, $4F ; $7C
	.db $4F, $4E, $4E, $4F ; $80
	.db $4E, $4F, $4F, $4E ; $84
	.db $92, $93, $93, $92 ; $88
	.db $8E, $8F, $8F, $8E ; $8C
	.db $44, $45, $45, $44 ; $90
	.db $4F, $37, $4E, $FE ; $94
	.db $4F, $3A, $4E, $FE ; $98
	.db $4F, $4E, $37, $38 ; $9C
	.db $4A, $4B, $FE, $FE ; $A0
	.db $72, $73, $4A, $4B ; $A4
	.db $40, $42, $41, $43 ; $A8
	.db $41, $43, $41, $43 ; $AC
TileQuads4:
	.db $40, $42, $41, $43 ; $00
	.db $40, $42, $41, $43 ; $04
	.db $BA, $BC, $BB, $BD ; $08
	.db $BA, $BC, $90, $91 ; $0C
	.db $FA, $FA, $FA, $FA ; $10
	.db $FA, $FA, $FA, $FA ; $14
	.db $FD, $FD, $FD, $FD ; $18
	.db $61, $63, $61, $63 ; $1C
	.db $65, $63, $65, $63 ; $20
	.db $65, $67, $65, $67 ; $24
	.db $60, $62, $61, $63 ; $28
	.db $32, $34, $33, $35 ; $2C
	.db $64, $62, $65, $63 ; $30
	.db $36, $34, $37, $35 ; $34
	.db $64, $66, $65, $67 ; $38
	.db $36, $38, $37, $39 ; $3C
	.db $68, $62, $61, $63 ; $40
	.db $64, $69, $65, $67 ; $44
	.db $46, $62, $61, $63 ; $48
	.db $64, $47, $65, $67 ; $4C
	.db $BA, $BC, $BB, $BD ; $50
	.db $70, $72, $71, $73 ; $54
	.db $8E, $8F, $8F, $8E ; $58
	.db $72, $73, $73, $72 ; $5C
	.db $44, $45, $45, $44 ; $60

EndOfLevelDoor: ; PPU data
	.db $22, $D0, $04, $FC, $FC, $AD, $FA
	.db $22, $F0, $04, $FC, $FC, $AC, $AD
	.db $23, $10, $06, $FC, $FC, $AC, $AC, $AD, $FA
	.db $23, $30, $06, $FC, $FC, $AC, $AC, $AC, $AD
	.db $00

EndOfLevelDoorRowOffsets:
	.db $00
	.db $07
	.db $0E
	.db $17

DefaultCHRAnimationSpeed_Level:
	.db $00 ; 1-1
	.db $00 ; 1-1
	.db $06 ; 3-1
	.db $06 ; 3-1
	.db $0A ; 4-2
	.db $0A ; 4-2
	.db $0B ; 4-3
	.db $0D ; 5-2
	.db $0E ; 5-3
	.db $11 ; 6-3
	.db $11 ; 6-3
	.db $12 ; 7-1
	.db $12 ; 7-1
	.db $12 ; 7-1
	.db $12 ; 7-1
	.db $13 ; 7-2

DefaultCHRAnimationSpeed_Area:
	.db $01 ; 1-1 upward climb
	.db $05 ; 1-1 birdo
	.db $01 ; 3-1 main part
	.db $03 ; 3-1 sky part
	.db $01 ; 4-2 sky ice
	.db $02 ; 4-2 whales
	.db $04 ; 4-3 tower tops
	.db $02 ; 5-2 upward climb
	.db $04 ; 5-3 miniboss birdo
	.db $03 ; 6-3 upward climb
	.db $04 ; 6-3 sky pyramid
	.db $00 ; 7-1 beginning area
	.db $01 ; 7-1 albatoss area
	.db $02 ; 7-1 cloud maze
	.db $03 ; 7-1 upward climb
	.db $00 ; 7-2 entrance

BackgroundCHRAnimationSpeedByWorld:
	.db $07 ; World 1
	.db $07 ; World 2
	.db $07 ; World 3
	.db $07 ; World 4
	.db $09 ; World 5
	.db $07 ; World 6
	.db $05 ; World 7
	.db $0B ; Default


;
; Increments the frame of the CHR animation using the world/area speed
;
AnimateCHRRoutine:
	DEC iBGCHR2Timer
	BPL AnimateCHRRoutine_Exit

	LDX #$07 ; default index for animation speed table

	; Certain level/area combinations use a fixed animation speed.
	; It seems to be used in areas that prominently feature cloud platforms.
	; This loop performs the lookup to see if that should happen.
	LDY #(DefaultCHRAnimationSpeed_Area - DefaultCHRAnimationSpeed_Level - 1)
AnimateCHRRoutine_DefaultSpeedLoop:
	LDA iCurrentLevel_Init
	CMP DefaultCHRAnimationSpeed_Level, Y
	BNE AnimateCHRRoutine_DefaultSpeedNext

	LDA iCurrentLevelArea_Init
	CMP DefaultCHRAnimationSpeed_Area, Y
	BEQ AnimateCHRRoutine_SetSpeed

AnimateCHRRoutine_DefaultSpeedNext:
	DEY
	BPL AnimateCHRRoutine_DefaultSpeedLoop

	LDX iCurrentWorldTileset

AnimateCHRRoutine_SetSpeed:
	LDA BackgroundCHRAnimationSpeedByWorld, X
	STA iBGCHR2Timer
	LDY iBGCHR2
	INY
	INY

AnimatedCHRCheck:
IFDEF FIX_CHR_CYCLE
	CPY #CHRBank_Animated8 + 1
ELSE
	; Bug: This is in the original game
	; The last frame of the animation is effectively skipped because
	; we immediately reset to the first frame when we hit it.
	CPY #CHRBank_Animated8
ENDIF

	BCC AnimateCHRRoutine_SetCHR

	LDY #CHRBank_Animated1

AnimateCHRRoutine_SetCHR:
	STY iBGCHR2

AnimateCHRRoutine_Exit:
	RTS


;
; Looks for an unused sprite slot
;
; ##### Input
; - `X`: enemy slot
;
; ##### Output
; - `X`: z12
; - `Y`: sprite slot
;
FindSpriteSlot:
	LDX #$08

FindSpriteSlot_Loop:
	LDA zEnemyState, X
	BEQ FindSpriteSlot_CheckInactiveSlot

FindSpriteSlot_LoopNext:
	DEX
	BPL FindSpriteSlot_Loop

FindSpriteSlot_Default:
	; Check that both halves of the default sprite slot are unused
	LDY #$00
	LDA iVirtualOAM, Y
	CMP #$F8
	BNE FindSpriteSlot_FallbackExit

	LDA iVirtualOAM + 4, Y
	CMP #$F8
	BEQ FindSpriteSlot_Exit

FindSpriteSlot_FallbackExit:
	; If all else fails, here's $10
	LDY #$10

FindSpriteSlot_Exit:
	LDX z12
	RTS

; The object slot is inactive, so check that something else hasn't claimed the
; corresponding sprite slot.
FindSpriteSlot_CheckInactiveSlot:
	; Calculate the sprite slot using the flicker offset
	TXA
	CLC
	ADC iObjectFlickerer
	TAY
	LDA SpriteFlickerDMAOffset, Y

	; Check that both halves of the object's sprite slot are unused
	TAY
	LDA iVirtualOAM, Y
	CMP #$F8
	BNE FindSpriteSlot_LoopNext
	LDA iVirtualOAM + 4, Y
	CMP #$F8
	BNE FindSpriteSlot_LoopNext
	BEQ FindSpriteSlot_Exit

CHRBank_WorldEnemies:
	.db CHRBank_EnemiesGrass
	.db CHRBank_EnemiesDesert
	.db CHRBank_EnemiesGrass
	.db CHRBank_EnemiesIce
	.db CHRBank_EnemiesGrass
	.db CHRBank_EnemiesDesert
	.db CHRBank_EnemiesSky

CHRBank_WorldBossBackground:
	.db CHRBank_BackgroundGrass
	.db CHRBank_BackgroundDesert
	.db CHRBank_BackgroundGrass
	.db CHRBank_BackgroundIce
	.db CHRBank_BackgroundGrassClawgrip
	.db CHRBank_BackgroundDesert
	.db CHRBank_BackgroundSky

CHRBank_CharacterSize:
	.db CHRBank_Mario
	.db CHRBank_MarioSmall
	.db CHRBank_Princess
	.db CHRBank_PrincessSmall
	.db CHRBank_Toad
	.db CHRBank_ToadSmall
	.db CHRBank_Luigi
	.db CHRBank_LuigiSmall


LoadWorldCHRBanks:
	LDY #CHRBank_CommonEnemies1
	STY iObjCHR2
	INY
	STY iObjCHR3
	LDY iCurrentWorldTileset
	LDA CHRBank_WorldEnemies, Y
	STA iObjCHR4
	LDA CHRBank_WorldBossBackground, Y
	STA iBGCHR1
	LDA #CHRBank_Animated1
	STA iBGCHR2

LoadCharacterCHRBanks:
	LDA zCurrentCharacter
	ASL A
	ORA iCurrentPlayerSize
	TAY
	LDA CHRBank_CharacterSize, Y
	STA iObjCHR1
	RTS

LoadTitleScreenCHRBanks:
	LDA #CHRBank_TitleScreenBG1
	STA iObjCHR1
	STA iBGCHR1
	ORA #1
	STA iObjCHR2
	LDA #CHRBank_TitleScreenBG2
	STA iObjCHR3
	STA iBGCHR2
	ORA #1
	STA iObjCHR4
	RTS


LoadCelebrationSceneBackgroundCHR:
	LDA #CHRBank_CelebrationBG1
	STA iBGCHR1
	LDA #CHRBank_CelebrationBG2
	STA iBGCHR2
	RTS


LoadCharacterSelectCHRBanks:
	LDA #CHRBank_CharacterSelectSprites
	STA iObjCHR1
	LDA #CHRBank_CharacterSelectBG1
	STA iBGCHR1
	LDA #CHRBank_CharacterSelectBG2
	STA iBGCHR2
	RTS


TitleCardCHRBanks:
	.db CHRBank_TitleCardGrass
	.db CHRBank_TitleCardDesert
	.db CHRBank_TitleCardGrass
	.db CHRBank_TitleCardIce
	.db CHRBank_TitleCardGrass
	.db CHRBank_TitleCardDesert
	.db CHRBank_TitleCardSky


ChangeTitleCardCHR:
	LDY iCurrentWorld
	LDA TitleCardCHRBanks, Y
	STA iBGCHR2
	RTS

LoadBonusChanceCHRBanks:
	LDA #CHRBank_ChanceBG1
	STA iBGCHR1
	LDA #CHRBank_ChanceBG2
	STA iBGCHR2
	RTS


LoadMarioSleepingCHRBanks:
	LDY #CHRBank_EndingSprites
	STY iObjCHR1
	INY
	STY iObjCHR2
	LDA #CHRBank_EndingBackground1
	STA iBGCHR1
	LDA #CHRBank_EndingBackground1 + 2
	STA iBGCHR2
	RTS


;
; Public RESET
;
; This code is called when the NES is reset and handles some boilerplate
; initialization before starting the game loop.
;
; The NMI handles frame rendering.
;
RESET:
	SEI
	CLD
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background0000 | PPUCtrl_SpriteSize8x8 | PPUCtrl_Background0000 | PPUCtrl_NMIDisabled
	STA PPUCTRL
	LDX #$FF ; Reset stack pointer
	TXS

RESET_VBlankLoop:
	; Wait for first VBlank
	LDA PPUSTATUS
	AND #PPUStatus_VBlankHit
	BEQ RESET_VBlankLoop

RESET_VBlank2Loop:
	; Wait for second VBlank
	LDA PPUSTATUS
	BPL RESET_VBlank2Loop

	LDA #MMC5_VMirror
	STA MMC5_NametableMapping
	JMP StartGame


;
; Switches the current CHR banks
;
ChangeCHRBanks:
	CLC ; added for lag frames
	LDA iObjCHR1
	STA MMC5_CHRBankSwitch1

	LDA iObjCHR2
	STA MMC5_CHRBankSwitch2

	LDA iObjCHR3
	STA MMC5_CHRBankSwitch3

	LDA iObjCHR4
	STA MMC5_CHRBankSwitch4

	LDA iBGCHR1
	STA MMC5_CHRBankSwitch5
	ADC #$01
	STA MMC5_CHRBankSwitch6

	LDA iBGCHR2
	STA MMC5_CHRBankSwitch7
	ADC #$01
	STA MMC5_CHRBankSwitch8

	LDA iBGCHR1
	STA MMC5_CHRBankSwitch9
	ADC #$01
	STA MMC5_CHRBankSwitch10

	LDA iBGCHR2
	STA MMC5_CHRBankSwitch11
	ADC #$01
	STA MMC5_CHRBankSwitch12
	RTS


;
; Calling this one will save the changed bank
; to RAM, so if something uses the below version
; the original bank set with this can be restored.
;
ChangeMappedPRGBank:
	STA iCurrentROMBank ; See below comment.

;
; Any call to this subroutine switches the lower two banks together.
;
; For example, loading Bank 0/1:
;
; ```
; LDA #$00
; JSR ChangeMappedPRGBank
; ```
;
; Loading Bank 2/3:
;
; ```
; LDA #$01
; JSR ChangeMappedPRGBank
; ```
;
; Etc.
;
; This version changes the bank numbers without
; saving the change to RAM, so the previous bank
; can be recalled later (mostly for temporary switches,
; like music handling and such)
;
ChangeMappedPRGBankWithoutSaving:
	ASL A

	ORA #$80
	STA MMC5_PRGBankSwitch2
	ORA #$01
	STA MMC5_PRGBankSwitch3
	RTS


;
; Sets the nametable mirroring by writing `$A000`.
;
; ##### Input
; - `A`: `$00` =  vertical, `$01` = horizontal
;
ChangeNametableMirroring:
	STA MMC5_NametableMapping
	RTS

;
; Save logic
;
; 
BackUpSaveData:
	LDY #SAVE_DATA_WIDTH - 1

BackUpSaveData_Loop:
	LDA sSaveData, Y
	STA sBackupSaveData, Y
	DEY
	BPL BackUpSaveData_Loop
	RTS

;
; Save data checksum
;
; Up to v1.5, the checksum routine adds all relevant data into one value,
; except for lives, which is stashed separately to avoid setting carry,
; then the sum and life stash is multiplied into the following two bytes.
;
GenerateChecksum:
	; 2 3-byte strings
	LDY #3
	; start with Luigi's saved contributor number
	LDA sContributors + 3
	CLC

GenerateChecksum_Loop:
	; + Toad's SCN + World
	; + Peach's SCN + Level Area
	; + Mario's SCN + Level
	ADC sContributors, Y
	ADC sSavedLvl, Y
	DEY
	BPL GenerateChecksum_Loop
	; stash the sum in byte 0, transfer to Y as well
	STA sMultiChecksum
	TAY
	; put extra men in byte 1
	LDA sExtraMen
	STA sMultiChecksum + 1
	; poke the multiplier
	STY MMC5_Multiplier
	STA MMC5_Multiplier + 1
	; we can now pull the resulting product and stash it
	LDA MMC5_Multiplier
	LDY MMC5_Multiplier + 1
	STA sMultiChecksum + 2
	STY sMultiChecksum + 3
	RTS

GenerateBackupChecksum:
	; do the backup save
	; 2 3-byte strings
	LDY #3
	; start with Luigi's backup contributor number
	LDA sBackupContributors + 3
	CLC
GenerateBackupChecksum_Loop:
	; + Toad's BCN + World
	; + Peach's BCN + Level Area
	; + Mario's BCN + Level
	ADC sBackupContributors, Y
	ADC sBackupLvl, Y
	DEY
	BPL GenerateBackupChecksum_Loop
	; stash the sum in byte 0, transfer to Y as well
	STA sBackupMultiChecksum
	TAY
	; put extra men in byte 1
	LDA sBackupExtraMen
	STA sBackupMultiChecksum + 1
	; poke the multiplier
	STY MMC5_Multiplier
	STA MMC5_Multiplier + 1
	; we can now pull the resulting product and stash it
	LDA MMC5_Multiplier
	LDY MMC5_Multiplier + 1
	STA sBackupMultiChecksum + 2
	STY sBackupMultiChecksum + 3
	RTS

EngageSave:
	LDA iStack
	CMP #Stack100_PauseSave
	BEQ EngageSave_Save
	CMP #Stack100_Save
	BNE EngageSave_Exit
EngageSave_Save:
	JSR BackUpSaveData
	JSR GenerateChecksum
	JMP GenerateBackupChecksum
EngageSave_Exit:
	RTS

PauseSounds:
	.db DPCM_Pause
	.db DPCM_Save
	.db DPCM_Save ; unused

StopOperationAndReset:
	LDA #DPCM_Save
	STA iDPCMSFX
	LDA #Stack100_Save
	STA iStack
StopOperationAndReset_Loop:
	LDA #1
	JSR DelayFrames
	LDA iCurrentDPCMSFX
	BNE StopOperationAndReset_Loop
	JSR ClearNametablesAndSprites
	TAX
StopOperationAndReset_ClearStack:
	STA iStack, X
	DEX
	BNE StopOperationAndReset_ClearStack
	JMP RESET

;
; Public IRQ
;
; ***Used for the wave effect during the warp cutscene***
;
; ***Screen tearing might occur with mIRQIntensity***
IRQ:
	PHA				; 3 3
	; index
	LDA MMC5_IRQStatus
	STY mTempReg ; preserve Y	; 4 29
	STX mTempReg + 1
	INC mIRQIndex			; 6 35
	LDA mIRQIndex			; 4 39
	AND #$0f			; 2 47
	TAY				; 2 49
	; scanline X position
	LDA SineData, Y			; 5 69
	STA MMC5_Multiplier		; 4 73
	LDA mIRQIntensity		; 4 77
	STA MMC5_Multiplier + 1		; 4 81
	LDA MMC5_Multiplier + 1		; 4 85
	EOR SineXORs, Y
	STA mIRQFinalScroll		; 4 89
	TAX
	; nametable
	LDA SineControls, Y
	STA mIRQFinalScroll + 1
	LDY $00
	DEY
	DEY
	DEY
	DEY
	LDY PPUSTATUS
	LDY #0
	STA PPUCTRL			; 4 11
	STX PPUSCROLL			; 4 19
	STY PPUSCROLL			; 4 25
	; next scanline
	LDY mNextScanline		; 4 93
	INY				; 2 95
	INY				; 2 97
	CPY #$f0			; 2 99
	BCS IRQ_PrepNextFrame		; 2 105	3 106
	STY mNextScanline		; 4 109
	STY MMC5_IRQScanlineCompare	; 4 113
	PLA				; 4 103
	LDY mTempReg			; 4 117
	LDX mTempReg + 1
	RTI				; 6 123

IRQ_PrepNextFrame:
	; next scanline
	LDY #2				; 2 108
	STY mNextScanline		; 4 112
	STY MMC5_IRQScanlineCompare	; 4 116
	; offset
	LDA mIRQOffset
	LSR A
	LSR A
	AND #$0f
	STA mIRQIndex
	PLA				; 4 103
	LDY mTempReg			; 4 126
	LDX mTempReg + 1
	RTI				; 6 132

SineData:
	.db $00, $61, $b4, $ec, $ff, $ec, $b4, $61
	.db $00, $60, $b3, $eb, $fe, $eb, $b3, $60
SineXORs:
	.db $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff
SineControls:
	.db $b5, $b5, $b5, $b5, $b5, $b5, $b5, $b5
	.db $b5, $b4, $b4, $b4, $b4, $b4, $b4, $b4

CopyBonusChanceFlashOffset:
	RAY
	LDA BonusChanceFlashOffsetsLO, Y
	STA z00
	LDA BonusChanceFlashOffsetsHI, Y
	STA z01
	LDY #$13
CopyBonusChanceFlashOffset_Loop:
	LDA (z00), Y
	STA mBonusChanceFlashUpdate, Y
	DEY
	BPL CopyBonusChanceFlashOffset_Loop
	LDA #ScreenUpdateBuffer_RAM_BonusChanceFlash
	STA zScreenUpdateIndex
	RTS

BonusChanceFlashOffsetsHI:
	.dh BonusChanceBackgroundFlashPalettes0
	.dh BonusChanceBackgroundFlashPalettes1
	.dh BonusChanceBackgroundFlashPalettes2
	.dh BonusChanceBackgroundFlashPalettes3
	.dh BonusChanceBackgroundFlashPalettes2

BonusChanceFlashOffsetsLO:
	.dh BonusChanceBackgroundFlashPalettes0
	.dl BonusChanceBackgroundFlashPalettes1
	.dl BonusChanceBackgroundFlashPalettes2
	.dl BonusChanceBackgroundFlashPalettes3
	.dl BonusChanceBackgroundFlashPalettes2

BonusChanceBackgroundFlashPalettes1:
	.db $3F, $00, $10
	.db $0F, $37, $16, $07 ; Most of screen, outline, etc.
	.db $0F, $27, $38, $08 ; 2
	.db $0F, $28, $28, $08 ; Logo
	.db $0F, $28, $28, $08 ; Copyright, Story, Sclera
	.db $00

BonusChanceBackgroundFlashPalettes2:
	.db $3F, $00, $10
	.db $0F, $37, $16, $07 ; Most of screen, outline, etc.
	.db $0F, $27, $38, $08 ; 2
	.db $0F, $21, $21, $01 ; Logo
	.db $0F, $21, $21, $01 ; Copyright, Story, Sclera
	.db $00

BonusChanceBackgroundFlashPalettes3:
	.db $3F, $00, $10
	.db $0F, $37, $36, $07 ; Most of screen, outline, etc.
	.db $0F, $27, $38, $08 ; 2
	.db $0F, $21, $21, $01 ; Logo
	.db $0F, $21, $21, $01 ; Copyright, Story, Sclera
	.db $00

BonusChanceBackgroundFlashPalettes0:
	.db $3F, $00, $10
	.db $0F, $37, $16, $07 ; Most of screen, outline, etc.
	.db $0F, $27, $38, $08 ; 2
	.db $0F, $30, $27, $01 ; Logo
	.db $0F, $37, $27, $30 ; Copyright, Story, Sclera
	.db $00

;
; Vectors for the NES CPU. These must ALWAYS be at $FFFA!
;
; **NMI** is the code that runs each frame during the VBlank.
;
; **RESET** is code that runs after the console starts or resets.
;
; **IRQ** is not used, but would handle things like `BRK` or scanline counter
; interrupts. Note that the MMC3 scanline counter is clocked incorrectly due to
; the use of both sides of the nametable for sprites as well as using the right
; rather than left nametable for backgrounds, which effectively prevents using
; the scanline counter for things like precise screen splits.
;
.pad $FFFA, $00

NESVectorTables:
	.dw NMI
	.dw RESET_MMC5
	.dw IRQ
