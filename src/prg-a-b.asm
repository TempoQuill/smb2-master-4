;
; Bank A & Bank B
; ===============
;
; What's inside:
;
;   - Level title card background data and palettes
;   - Bonus chance background data and palettes
;   - Character select palettes
;   - Character data (physics, palettes, etc.)
;   - Character stats bootstrapping
;

;
; This title card is used for every world from 1 to 6.
; The only difference is the loaded CHR banks.
;
World1thru6TitleCard:
	.db $FB, $FB, $B0, $B2, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB
	.db $FB, $FB, $B1, $B3, $FB, $FB, $FB, $FB, $FB, $FB, $C0, $C1, $FB, $FB, $FB, $FB ; $10
	.db $FB, $FB, $B4, $B5, $FB, $FB, $FB, $FB, $B6, $B8, $BA, $B8, $BA, $BC, $FB, $FB ; $20
	.db $FB, $FB, $B4, $B5, $FB, $FB, $FB, $FB, $B7, $B9, $BB, $B9, $BB, $BD, $FB, $FB ; $30
	.db $FB, $FB, $B4, $B5, $FB, $FB, $FB, $FB, $B7, $B9, $BB, $B9, $BB, $BD, $FB, $FB ; $40
	.db $FB, $FB, $B4, $B5, $C0, $C1, $FB, $FB, $B7, $B9, $BB, $B9, $BB, $BD, $FB, $FB ; $50
	.db $CA, $CC, $CA, $CC, $CA, $CC, $CA, $CC, $CA, $CC, $CA, $CC, $CA, $CC, $CA, $CC ; $60
	.db $CB, $CD, $CB, $CD, $CB, $CD, $CB, $CD, $CB, $CD, $CB, $CD, $CB, $CD, $CB, $CD ; $70
	.db $CE, $CF, $CE, $CF, $CE, $CF, $CE, $CF, $CE, $CF, $CE, $CF, $CE, $CF, $CE, $CF ; $80
	.db $CF, $CE, $CF, $CE, $CF, $CE, $CF, $CE, $CF, $CE, $CF, $CE, $CF, $CE, $CF, $CE ; $90

;
; This one is the special one used for World 7
;
World7TitleCard:
	.db $FB, $FB, $B0, $B2, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB
	.db $FB, $FB, $B1, $B3, $FB, $FB, $FB, $FB, $FB, $FB, $C0, $C1, $FB, $FB, $FB, $FB ; $10
	.db $FB, $FB, $B1, $B3, $FB, $FB, $FB, $FB, $B6, $B8, $BA, $B8, $BA, $BC, $FB, $FB ; $20
	.db $FB, $FB, $B1, $B3, $FB, $FB, $FB, $FB, $B7, $B9, $BB, $B9, $BB, $BD, $FB, $FB ; $30
	.db $FB, $FB, $B1, $B3, $FB, $FB, $FB, $FB, $CA, $FC, $FC, $FC, $FC, $CC, $FB, $FB ; $40
	.db $FB, $FB, $B1, $B3, $C0, $C1, $FB, $FB, $CA, $FC, $FC, $FC, $FC, $CC, $FB, $FB ; $50
	.db $A8, $AC, $AA, $AC, $AA, $AC, $AA, $AC, $AA, $AC, $AA, $AC, $AA, $AC, $AA, $AE ; $60
	.db $A9, $AD, $AB, $AD, $AB, $AD, $AB, $AD, $AB, $AD, $AB, $AD, $AB, $AD, $AB, $AF ; $70
	.db $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB ; $80
	.db $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB ; $90

BonusChanceLayout:
	.db $20, $00, $60, $FD
	.db $20, $20, $60, $FD
	.db $20, $40, $60, $FD
	.db $20, $60, $60, $FD
	.db $23, $40, $60, $FD
	.db $23, $60, $60, $FD
	.db $23, $80, $60, $FD
	.db $23, $A0, $60, $FD
	.db $20, $80, $D6, $FD
	.db $20, $81, $D6, $FD
	.db $20, $82, $D6, $FD
	.db $20, $9D, $D6, $FD
	.db $20, $9E, $D6, $FD
	.db $20, $9F, $D6, $FD

	.db $20, $68, $10
	.db $48, $4A, $4C, $4E, $50, $51, $52, $53, $54, $55, $56, $57, $58, $5A, $5C, $5E

	.db $20, $83, $09, $FD, $FD, $22, $23, $24, $49, $4B, $4D, $4F
	.db $20, $94, $09, $59, $5B, $5D, $5F, $2E, $2F, $30, $FD, $FD
	.db $20, $A3, $04, $FD, $25, $26, $27
	.db $20, $B9, $04, $31, $32, $33, $FD
	.db $20, $C3, $04, $FD, $28, $29, $2A
	.db $20, $D9, $04, $34, $35, $36, $FD
	.db $20, $E3, $03, $2B, $2C, $2D
	.db $20, $FA, $03, $37, $38, $39
	.db $21, $03, $02, $3A, $3B
	.db $21, $1B, $02, $40, $41
	.db $21, $23, $D0, $3C
	.db $21, $3C, $D0, $42
	.db $22, $02, $02, $3E, $3F
	.db $22, $1C, $02, $61, $62
	.db $22, $22, $02, $43, $44
	.db $22, $3C, $02, $63, $64
	.db $22, $43, $01, $45
	.db $22, $5C, $01, $65
	.db $22, $C4, $02, $A6, $A8
	.db $22, $E4, $02, $A7, $A9
	.db $22, $FA, $04, $80, $82, $88, $8A
	.db $23, $04, $02, $90, $92
	.db $23, $14, $02, $9E, $A0
	.db $23, $1A, $04, $81, $83, $89, $8B
	.db $23, $23, $03, $46, $91, $93
	.db $23, $2A, $02, $A2, $A4

	.db $23, $2E, $10
	.db $67, $6C, $6E, $70, $72, $69, $9F, $A1, $75, $98, $9A, $FB, $84, $86, $8C, $8E

	.db $23, $43, $1B
	.db $47, $94, $96, $74, $74, $74, $74, $A3, $A5, $74, $66, $68, $6D, $6F, $71, $73
	.db $6A, $6B, $74, $74, $99, $9B, $74, $85, $87, $8D, $8F

	.db $23, $64, $05, $95, $97, $FD, $AA, $AB
	.db $23, $77, $05, $9C, $9D, $AA, $AB, $AB
	.db $23, $89, $02, $AA, $AB
	.db $20, $C9, $0E, $78, $AC, $B0, $B4, $B7, $BA, $FB, $BC, $BE, $C1, $C4, $C7, $CB, $7C

	.db $20, $E8, $10
	.db $1C, $79, $AD, $B1, $B5, $B8, $BB, $FB, $BD, $BF, $C2, $C5, $C8, $CC, $7D, $1E

	.db $21, $08, $10
	.db $1D, $7A, $AE, $B2, $B6, $B9, $FB, $FB, $FB, $C0, $C3, $C6, $C9, $CD, $7E, $1F

	.db $21, $29, $03, $7B, $AF, $B3
	.db $21, $34, $03, $CA, $CE, $7F
	.db $21, $6A, $0C, $14, $10, $10, $16, $14, $10, $10, $16, $14, $10, $10, $16
	.db $21, $8A, $0C, $11, $FC, $FC, $12, $11, $FC, $FC, $12, $11, $FC, $FC, $12
	.db $21, $AA, $0C, $11, $FC, $FC, $12, $11, $FC, $FC, $12, $11, $FC, $FC, $12
	.db $21, $CA, $0C, $15, $13, $13, $17, $15, $13, $13, $17, $15, $13, $13, $17
	.db $22, $0D, $02, $18, $1A
	.db $22, $2D, $02, $19, $1B
	.db $23, $CA, $04, $F0, $F0, $F0, $F0
	.db $23, $D2, $04, $8F, $AF, $AF, $2F
	.db $23, $DA, $04, $88, $AA, $AA, $22
	.db $23, $E3, $02, $0F, $0A
	.db $23, $E9, $06, $04, $A5, $A5, $A5, $A5, $25
	.db $00


;
; Copies the Bonus Chance PPU data
;
; This copies in two pages
;
CopyBonusChanceLayoutToRAM:
	LDY #$00
CopyBonusChanceLayoutToRAM_Loop1:
	LDA BonusChanceLayout, Y ; Blindly copy $100 bytes from $8140 to $7400
	STA wBonusLayoutBuffer, Y
	DEY
	BNE CopyBonusChanceLayoutToRAM_Loop1

	; seems $100 wasn't enough memory though, huh?
	; Y's immediate number was hacked to take on the low byte of the data range
	LDY #<(CopyBonusChanceLayoutToRAM - BonusChanceLayout) ; amount of data to copy
CopyBonusChanceLayoutToRAM_Loop2:
	; Y at 0 causes a branch, blindly adding a page to address skips $7500
	LDA BonusChanceLayout + $ff, Y
	STA wBonusLayoutBuffer + $ff, Y
	DEY
	BNE CopyBonusChanceLayoutToRAM_Loop2
	RTS

; =============== S U B R O U T I N E =======================================

DrawTitleCardWorldImage:
	LDA iCurrentWorld
	CMP #6
	BEQ loc_BANKA_8392 ; Special case for World 7's title card

	LDA #$25
	STA z00
	LDA #$C8
	STA z01
	LDY #$00

loc_BANKA_8338:
	LDX #$0F
	LDA PPUSTATUS
	LDA z00
	STA PPUADDR

loc_BANKA_8342:
	LDA z01
	STA PPUADDR

loc_BANKA_8347:
	LDA World1thru6TitleCard, Y
	STA PPUDATA
	INY
	DEX
	BPL loc_BANKA_8347

	CPY #$A0
	BCS loc_BANKA_8364

	LDA z01
	ADC #$20
	STA z01
	LDA z00
	ADC #0
	STA z00
	JMP loc_BANKA_8338

; ---------------------------------------------------------------------------

loc_BANKA_8364:
	LDA iCurrentWorld
	CMP #1
	BEQ loc_BANKA_8371

	CMP #5
	BEQ loc_BANKA_8371

	BNE loc_BANKA_8389

loc_BANKA_8371:
	AND #$80
	BNE loc_BANKA_8389

	LDA #$26
	STA z00
	LDA #$88
	STA z01
	LDA iCurrentWorld
	ORA #$80
	STA iCurrentWorld
	STA sSavedWorld
	LDY #$80
	BNE loc_BANKA_8338

loc_BANKA_8389:
	LDA iCurrentWorld
	AND #$F
	STA iCurrentWorld
	STA sSavedWorld
	RTS

; ---------------------------------------------------------------------------

loc_BANKA_8392:
	LDA #$25
	STA z00
	LDA #$C8
	STA z01
	LDY #0

loc_BANKA_839C:
	LDX #$F
	LDA PPUSTATUS
	LDA z00
	STA PPUADDR
	LDA z01
	STA PPUADDR

loc_BANKA_83AB:
	LDA World7TitleCard, Y
	STA PPUDATA
	INY
	DEX
	BPL loc_BANKA_83AB

	CPY #$A0
	BCS locret_BANKA_83C8

	LDA z01
	ADC #$20
	STA z01
	LDA z00
	ADC #0
	STA z00
	JMP loc_BANKA_839C

; ---------------------------------------------------------------------------

locret_BANKA_83C8:
	RTS

; End of function DrawTitleCardWorldImage

StatOffsets:
	.db (MarioStats - CharacterStats)
	.db (PrincessStats - CharacterStats)
	.db (ToadStats - CharacterStats)
	.db (LuigiStats - CharacterStats)

CharacterStats:
MarioStats:
IFNDEF PAL
	.db $00 ; Pick-up Speed, frame 1/6 - pulling
	.db $04 ; Pick-up Speed, frame 2/6 - pulling
	.db $02 ; Pick-up Speed, frame 3/6 - ducking
	.db $01 ; Pick-up Speed, frame 4/6 - ducking
	.db $04 ; Pick-up Speed, frame 5/6 - ducking
	.db $07 ; Pick-up Speed, frame 6/6 - ducking
	.db $B0 ; Jump Speed, still - no object
	.db $B0 ; Jump Speed, still - with object
	.db $98 ; Jump Speed, charged - no object
	.db $98 ; Jump Speed, charged - with object
	.db $A6 ; Jump Speed, running - no object
	.db $AA ; Jump Speed, running - with object
	.db $E0 ; Jump Speed - in quicksand
	.db $00 ; Floating Time
	.db $07 ; Gravity without Jump button pressed
	.db $04 ; Gravity with Jump button pressed
	.db $08 ; Gravity in quicksand
	.db $18 ; Running Speed, right - no object
	.db $18 ; Running Speed, right - with object
	.db $04 ; Running Speed, right - in quicksand
	.db $E8 ; Running Speed, left - no object
	.db $E8 ; Running Speed, left - with object
	.db $FC ; Running Speed, left - in quicksand
ELSE
	.db $00 ; Pick-up Speed, frame 1/6 - pulling
	.db $03 ; Pick-up Speed, frame 2/6 - pulling
	.db $02 ; Pick-up Speed, frame 3/6 - ducking
	.db $01 ; Pick-up Speed, frame 4/6 - ducking
	.db $03 ; Pick-up Speed, frame 5/6 - ducking
	.db $06 ; Pick-up Speed, frame 6/6 - ducking
	.db $A0 ; Jump Speed, still - no object
	.db $A0 ; Jump Speed, still - with object
	.db $84 ; Jump Speed, charged - no object
	.db $84 ; Jump Speed, charged - with object
	.db $94 ; Jump Speed, running - no object
	.db $99 ; Jump Speed, running - with object
	.db $DA ; Jump Speed - in quicksand
	.db $00 ; Floating Time
	.db $09 ; Gravity without Jump button pressed
	.db $06 ; Gravity with Jump button pressed
	.db $0B ; Gravity in quicksand
	.db $1D ; Running Speed, right - no object
	.db $1D ; Running Speed, right - with object
	.db $05 ; Running Speed, right - in quicksand
	.db $E3 ; Running Speed, left - no object
	.db $E3 ; Running Speed, left - with object
	.db $FB ; Running Speed, left - in quicksand
ENDIF

ToadStats:
IFNDEF PAL
	.db $00 ; Pick-up Speed, frame 1/6 - pulling
	.db $01 ; Pick-up Speed, frame 2/6 - pulling
	.db $01 ; Pick-up Speed, frame 3/6 - ducking
	.db $01 ; Pick-up Speed, frame 4/6 - ducking
	.db $01 ; Pick-up Speed, frame 5/6 - ducking
	.db $02 ; Pick-up Speed, frame 6/6 - ducking
	.db $B2 ; Jump Speed, still - no object
	.db $B2 ; Jump Speed, still - with object
	.db $98 ; Jump Speed, charged - no object
	.db $98 ; Jump Speed, charged - with object
	.db $AD ; Jump Speed, running - no object
	.db $AD ; Jump Speed, running - with object
	.db $E0 ; Jump Speed - in quicksand
	.db $00 ; Floating Time
	.db $07 ; Gravity without Jump button pressed
	.db $04 ; Gravity with Jump button pressed
	.db $08 ; Gravity in quicksand
	.db $18 ; Running Speed, right - no object
	.db $1D ; Running Speed, right - with object
	.db $04 ; Running Speed, right - in quicksand
	.db $E8 ; Running Speed, left - no object
	.db $E3 ; Running Speed, left - with object
	.db $FC ; Running Speed, left - in quicksand
ELSE
	.db $00 ; Pick-up Speed, frame 1/6 - pulling
	.db $01 ; Pick-up Speed, frame 2/6 - pulling
	.db $01 ; Pick-up Speed, frame 3/6 - ducking
	.db $01 ; Pick-up Speed, frame 4/6 - ducking
	.db $01 ; Pick-up Speed, frame 5/6 - ducking
	.db $01 ; Pick-up Speed, frame 6/6 - ducking
	.db $A2 ; Jump Speed, still - no object
	.db $A2 ; Jump Speed, still - with object
	.db $84 ; Jump Speed, charged - no object
	.db $84 ; Jump Speed, charged - with object
	.db $98 ; Jump Speed, running - no object
	.db $98 ; Jump Speed, running - with object
	.db $DA ; Jump Speed - in quicksand
	.db $00 ; Floating Time
	.db $09 ; Gravity without Jump button pressed
	.db $06 ; Gravity with Jump button pressed
	.db $0B ; Gravity in quicksand
	.db $1D ; Running Speed, right - no object
	.db $23 ; Running Speed, right - with object
	.db $05 ; Running Speed, right - in quicksand
	.db $E3 ; Running Speed, left - no object
	.db $DD ; Running Speed, left - with object
	.db $FB ; Running Speed, left - in quicksand
ENDIF

LuigiStats:
	.db $00 ; Pick-up Speed, frame 1/6 - pulling
	.db $04 ; Pick-up Speed, frame 2/6 - pulling
	.db $02 ; Pick-up Speed, frame 3/6 - ducking
	.db $01 ; Pick-up Speed, frame 4/6 - ducking
	.db $04 ; Pick-up Speed, frame 5/6 - ducking
	.db $07 ; Pick-up Speed, frame 6/6 - ducking
	.db $D6 ; Jump Speed, still - no object
	.db $D6 ; Jump Speed, still - with object
	.db $C9 ; Jump Speed, charged - no object
	.db $C9 ; Jump Speed, charged - with object
	.db $D0 ; Jump Speed, running - no object
	.db $D4 ; Jump Speed, running - with object
	.db $E0 ; Jump Speed - in quicksand
	.db $00 ; Floating Time
	.db $02 ; Gravity without Jump button pressed
	.db $01 ; Gravity with Jump button pressed
	.db $08 ; Gravity in quicksand
	.db $18 ; Running Speed, right - no object
	.db $16 ; Running Speed, right - with object
	.db $04 ; Running Speed, right - in quicksand
	.db $E8 ; Running Speed, left - no object
	.db $EA ; Running Speed, left - with object
	.db $FC ; Running Speed, left - in quicksand

PrincessStats:
	.db $00 ; Pick-up Speed, frame 1/6 - pulling
	.db $06 ; Pick-up Speed, frame 2/6 - pulling
	.db $04 ; Pick-up Speed, frame 3/6 - ducking
	.db $02 ; Pick-up Speed, frame 4/6 - ducking
	.db $06 ; Pick-up Speed, frame 5/6 - ducking
	.db $0C ; Pick-up Speed, frame 6/6 - ducking
	.db $B3 ; Jump Speed, still - no object
	.db $B3 ; Jump Speed, still - with object
	.db $98 ; Jump Speed, charged - no object
	.db $98 ; Jump Speed, charged - with object
	.db $AC ; Jump Speed, running - no object
	.db $B3 ; Jump Speed, running - with object
	.db $E0 ; Jump Speed - in quicksand
	.db $3C ; Floating Time
	.db $07 ; Gravity without Jump button pressed
	.db $04 ; Gravity with Jump button pressed
	.db $08 ; Gravity in quicksand
	.db $18 ; Running Speed, right - no object
	.db $15 ; Running Speed, right - with object
	.db $04 ; Running Speed, right - in quicksand
	.db $E8 ; Running Speed, left - no object
	.db $EB ; Running Speed, left - with object
	.db $FC ; Running Speed, left - in quicksand

CharacterPalette:
MarioPalette:
	.db $0F, $01, $16, $27
PrincessPalette:
	.db $0F, $06, $25, $36
ToadPalette:
	.db $0F, $01, $30, $27
LuigiPalette:
	.db $0F, $01, $2A, $36

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


FlyingCarpetAcceleration:
	.db $00
	.db $01
	.db $FF
	.db $00

WartOAMOffsets:
	.db $00
	.db $E0
	.db $FF ; Cycled in code ($7267)
	.db $D0
	.db $00
	.db $E0
	.db $FF ; Cycled in code ($726B)

PlayerSelectPalettes:
	.db $3F, $00, $20
	.db $0F, $28, $16, $06
	.db $0F, $30, $26, $16
	.db $0F, $30, $16, $12
	.db $0F, $30, $12, $16
	.db $0F, $22, $12, $01
	.db $0F, $22, $12, $01
	.db $0F, $22, $12, $01
	.db $0F, $22, $12, $01
	.db $00

BonusChanceText_X_1:
	.db $22, $30, $03
	.db $EA, $FB, $D1
BonusChanceText_EXTRA_LIFE_1:
	.db $22, $C9, $0F
	.db $DE, $F1, $ED, $EB, $DA, $FB, $E5, $E2, $DF, $DE ; EXTRA LIFE
	.db $F9, $F9, $F9, $FB, $D1 ; ... 1
	.db $00

BonusChanceBackgroundPalettes:
	.db $0F, $37, $16, $07 ; Most of screen, outline, etc.
	.db $0F, $36, $26, $08 ; 2
	.db $0F, $30, $27, $01 ; Logo
	.db $0F, $37, $27, $06 ; Copyright, Story, Sclera

BonusChanceReel1Order:
	.db Slot_Turnip ; $03
	.db Slot_Star   ; $02
	.db Slot_7      ; $01 ; Graphics exist for a mushroom (not used)
	.db Slot_Cherry ; $06
	.db Slot_Turnip ; $07
	.db Slot_Star   ; $05
	.db Slot_Snifit ; $00
	.db Slot_Cherry ; $04
BonusChanceReel2Order:
	.db Slot_Snifit ; $03
	.db Slot_Star   ; $00
	.db Slot_Turnip ; $04
	.db Slot_Cherry ; $02
	.db Slot_Snifit ; $06
	.db Slot_Star   ; $05
	.db Slot_Turnip ; $07
	.db Slot_7      ; $01
BonusChanceReel3Order:
	.db Slot_Turnip ; $03
	.db Slot_Snifit ; $01
	.db Slot_Star   ; $02
	.db Slot_7      ; $00
	.db Slot_Turnip ; $06
	.db Slot_Snifit ; $07
	.db Slot_Star   ; $04
	.db Slot_Cherry ; $05

BonusChanceUnusedCoinSprite:
	.db $F8, $19, $01, $60, $F8, $1B, $01, $68
BonusChanceUnusedImajinHead:
	.db $CB, $B0, $00, $A0, $CB, $B0, $40, $A8
BonusChanceUnusedLinaHead:
	.db $CB, $B2, $00, $A0, $CB, $B2, $40, $A8
BonusChanceUnusedMamaHead:
	.db $CB, $B6, $00, $A0, $CB, $B6, $40, $A8
BonusChanceUnusedPapaHead:
	.db $CB, $B4, $00, $A0, $CB, $B4, $40, $A8

;
; Based on the position and the number of tiles, this probably used to say...
;
; --- BONUS CHANCE ---
;
BonusChanceUnused_BONUS_CHANCE:
	.db $20, $C6, $14
	.db $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB
	.db $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB
	.db $00

BonusChanceText_NO_BONUS:
	.db $22, $86, $14
	.db $FB, $FB, $FB, $FB, $FB, $FB
	.db $E7, $E8, $FB, $DB, $E8, $E7, $EE, $EC ; NO BONUS
	.db $FB, $FB, $FB, $FB, $FB, $FB
	.db $00

BonusChanceText_PUSH_A_BUTTON:
	.db $22, $89, $0E
	.db $E9, $EE, $EC, $E1, $FB, $0E, $0F, $FB, $DB, $EE, $ED, $ED, $E8, $E7 ; PUSH (A) BUTTON
	.db $00

BonusChanceText_ThreeCoinsService:
	.db $22, $89, $0F
	.db $D3, $FB
	.db $DC, $E8, $E2, $E7, $EC, $FB
	.DB $EC, $DE, $EB, $EF, $E2, $DC, $DE
	.db $00

BonusChanceText_PLAYER_1UP:
	.db $22, $8B, $0B
	.db $E9, $E5, $DA, $F2, $DE, $EB, $FB, $FB, $D1, $EE, $E9 ; PLAYER  1UP
	.db $00

Text_PAUSE:
	.db $25, $6D, $05
	.db $E9, $DA, $EE, $EC, $DE ; PAUSE
	.db $27, $CB, $02, $AA, $AA ; attribute data
	.db $00

; Erases NO BONUS / PUSH (A) BUTTON / PLAYER 1UP / THREE COINS SERVICE
BonusChanceText_Message_Erase:
	.db $22, $86, $54, $FB
	.db $00

; This would erase the "PUSH (A) BUTTON" text, but the placement is wrong.
; The placement matches the original Doki Doki Panic Bonus Chance screen.
BonusChanceText_PUSH_A_BUTTON_Erase:
	.db $22, $AA, $4D, $FB
	.db $00

; More leftovers. The placement matches the original Doki Doki Panic Bonus Chance screen's placement
; of the "PLAYER  1UP" message.
BonusChanceText_Message_Erase_Unused:
	.db $22, $EB, $4B, $FB
	.db $00

Text_PAUSE_Erase:
	.db $25, $6D, $05
	.db $FB, $FB, $FB, $FB, $FB
	.db $00

TitleCardText:
	; Level indicator dots
	.db $25, $0E, $07
	.db $FB, $FB, $FB, $FB, $FB, $FB, $FB
	; WORLD  1-1
	.db $24, $CA, $0B
	.db $FB, $F0, $E8, $EB, $E5, $DD, $FB, $FB, $D1, $F3, $D1
	; EXTRA LIFE...  0
	.db $23, $48, $10
	.db $DE, $F1, $ED, $EB, $DA, $FB, $E5, $E2, $DF, $DE
	.db $F9, $F9, $F9, $FB, $FB, $D0
	.db $00

Text_WARP:
	.db $21, $8E, $04, $F0, $DA, $EB, $E9

; Doki Doki Panic pseudo-leftover
; This actually has extra spaces on either end:
; "-WORLD-" ... It originally said "CHAPTER"
Text_WORLD_1:
	.db $22, $0C, $09
	.db $FB, $F0, $E8, $EB, $E5, $DD, $FB, $FB, $D1
	.db $00
Text_Unknown6:
	.db $21, $6A, $01, $FB
Text_Unknown7:
	.db $21, $AA, $01, $FB
	.db $00
Text_Unknown8:
	.db $21, $97, $C6, $FB
	.db $00
UnusedText_THANK_YOU:
	.db $21, $0C, $09
	.db $ED, $E1, $3A, $E7, $E4, $FB, $F2, $E8, $EE
UnusedText_Blank214D:
	.db $21, $4D, $06
	.db $FB, $FB, $FB, $FB, $FB, $FB
	.db $00

PreLevelTitleCard:
	LDY #$23
PreLevelTitleCard_PaletteLoop:
	LDA TitleCardPalettes, Y
	STA iStartingPalettes, Y
	DEY
	BPL PreLevelTitleCard_PaletteLoop

	LDA #ScreenUpdateBuffer_RAM_TitleCardPalette ; Then tell it to dump that into the PPU
	STA zScreenUpdateIndex
	JSR WaitForNMI

	LDA #ScreenUpdateBuffer_TitleCardLeftover
	STA zScreenUpdateIndex
	JSR WaitForNMI

	JSR DrawTitleCardWorldImage

	JSR WaitForNMI_TurnOnPPU

	JSR RestorePlayerToFullHealth

	; Pause for the title card
	LDA #$50
	STA z02
PreLevelTitleCard_PauseLoop:
	JSR WaitForNMI
	DEC z02
	BPL PreLevelTitleCard_PauseLoop

PreStartLevel:
	JSR SetStack100Gameplay

	JSR WaitForNMI_TurnOffPPU

	JMP DisableNMI

LoadCHRSelect:
	JSR EnableNMI_PauseTitleCard

	JSR DisableNMI

	LDA #Music_CharacterSelect
	STA iMusicQueue

	LDY #$3F
loc_BANKF_E2CA:
	LDA PlayerSelectMarioSprites1, Y
	STA iVirtualOAM + $10, Y
	DEY
	BPL loc_BANKF_E2CA

	JSR EnableNMI

	JSR WaitForNMI

	LDX iCurrentWorld
	LDY iCurrentLvl
	JSR DisplayLevelTitleCardText

	JSR WaitForNMI

	JMP loc_BANKF_E311

EndOfLevelSlotMachine_AB:
	JSR CopyBonusChanceLayoutToRAM

	LDA #ScreenUpdateBuffer_RAM_BonusChanceLayout
	STA zScreenUpdateIndex
	LDA #Stack100_Menu
	STA iStack
	JSR EnableNMI

	JSR WaitForNMI

	LDA #Stack100_Gameplay
	STA iStack
	JSR DisableNMI

	JSR ResetScrollAndSetBonusChancePalettes

	LDA #Music_StopMusic
	STA iMusicQueue
	JSR WaitForNMI
	LDA #Music_WarpWorld
	STA iMusicQueue
	LDA #90
	JSR DelayFrames
	LDA iTotalCoins
	BEQ EndOfLevelSlotMachine_Exit
	JMP loc_BANKF_E7F2

EndOfLevelSlotMachine_Exit:
	JMP NoCoinsForSlotMachine

CheckForCoinService:
	; if lives weren't awarded, break out
	TYA
	BEQ CheckForCoinService_Exit

	; if 2 7's are shown, award three coins if it hasn't happened already
	LDA mCoinService
	BMI CheckForCoinService_Exit

	LDA #Slot_7
	LDX zObjectXLo + 7 ; Load reel 2
	CMP mReelBuffer + 8, X
	BNE CheckForCoinService_Exit

	LDX zObjectXLo + 8 ; Load reel 3
	CMP mReelBuffer + 16, X ; Does reel 3 match the previous two?
	BNE CheckForCoinService_Exit

	LDA #2
	STA mCoinService

CheckForCoinService_Exit:
	RTS

ExecuteCoinService:
	LDA mCoinService
	BMI ExecuteCoinService_Exit
	BEQ ExecuteCoinService_Exit

	LDA #ScreenUpdateBuffer_RAM_EraseBonusMessageText
	STA zScreenUpdateIndex

	JSR WaitForNMI

	LDA #ScreenUpdateBuffer_RAM_BonusChanceThreeCoinService
	STA zScreenUpdateIndex

	JSR WaitForNMI

ExecuteCoinService_PlaySound:
	INC iTotalCoins
	DEC mCoinService

	LDA #SoundEffect2_CoinGet
	STA iPulse2SFX

	LDA iTotalCoins
	JSR GetTwoDigitNumberTiles
	STY i588 - 1
	STA i588

	LDA #ScreenUpdateBuffer_RAM_BonusChanceCoinsExtraLife
	STA zScreenUpdateIndex

ExecuteCoinService_Loop:
	JSR WaitForNMI
	INC mCoinServiceTimer
	LDA mCoinServiceTimer
	CMP #$34
	BCC ExecuteCoinService_Loop

	LDA #0
	STA mCoinServiceTimer
	LDA #ScreenUpdateBuffer_RAM_BonusChanceCoinsExtraLife
	STA zScreenUpdateIndex

	LDA mCoinService
	BPL ExecuteCoinService_PlaySound

	LDA #ScreenUpdateBuffer_RAM_EraseBonusMessageText
	STA zScreenUpdateIndex

	JSR WaitForNMI

ExecuteCoinService_Exit:
	RTS

WarpAllStarsLayout:
	; MAIN BACKGROUND
	.db $24,$00,$6f,$fe

	.db $24,$2f,$02
	hex 857e

	.db $24,$31,$6f,$fe
	.db $24,$45,$16
	hex 18c595948b840302cecfcdcccbcecac9c8c7c6c4c3c2

	.db $24,$60,$d9,$fe
	.db $24,$61,$d9,$fe
	.db $24,$62,$d9,$fe

	.db $24,$63,$09
	hex fec1c0bfbebdbcbbba

	.db $24,$74,$09
	hex b9b8b7b6b5b4b3b2fe

	.db $24,$7d,$d9,$fe
	.db $24,$7e,$d9,$fe
	.db $24,$7f,$d9,$fe

	.db $24,$83,$04
	hex b1b0afae

	.db $24,$99,$04
	hex adacabaa

	.db $24,$a3,$04
	hex a9a8a7a6

	.db $24,$b9,$04
	hex a5a4a3a2

	.db $24,$c3,$03
	hex a1a09f

	.db $24,$da,$03
	hex 989796

	.db $24,$e3,$01,$93
	.db $24,$fc,$01,$8c
	.db $25,$03,$d2,$7f
	.db $25,$1c,$cf,$77

	.db $25,$e3,$84
	hex 7d766b5e

	.db $25,$fc,$84
	hex 796e6052

	.db $26,$02,$82
	hex 786c

	.db $26,$1d,$82
	hex 6d5f

	.db $27,$80,$60,$fe

	.db $27,$84,$05
	hex 0706fe0504

	.db $27,$97,$04
	hex 01000504

	.db $27,$a0,$60,$fe

WarpCharacterStills:
	.db $26,$c4,$84
	hex 4846433b

	.db $26,$c5,$84
	hex 4745423a

	.db $26,$fc,$01,$44

	.db $27,$14,$02
	hex 4140

	.db $27,$1a,$04
	hex 3f3e3d3c

	.db $27,$34,$0a
	hex 3938fb3736fb35343332

	.db $27,$43,$1b
	hex 31302ffbfbfb2e2dfbfb2c2b2a292827fb2625242322fb21201f1e

	.db $27,$63,$1b
	hex 1d1c1b14141a1917141615131211100f0e1414140d0c140b0a0908

	; WARP
	.db $24,$cd,$06
	hex 9e9c9d9b9a99

	.db $24,$ed,$06
	hex 9192908f8e8d

	.db $25,$0d,$06
	hex 898a88878683

	; BIRDO
	.db $25,$d4,$87
	hex 827c716356504c

	.db $25,$d5,$87
	hex 817b7062554f4b

	.db $25,$d6,$87
	hex 807a6f61544e4a

	.db $26,$13,$84
	hex 72645751

	.db $26,$57,$83
	hex 534d49

	; WORLD
	.db $26,$0a,$06
	hex 9e9cfbfb7574

	.db $26,$2a,$06
	hex 916a69686766

	.db $26,$4a,$06
	hex 895d5c5b5a59

	.db $26,$11,$83
WarpNumberTiles:
	hex fbfbfb

WarpScreenAttributes:
	.db $27,$cb,$42,$f0
	.db $27,$d3,$42,$0f
	.db $27,$dd,$01,$a0
	.db $27,$e2,$04
	hex ccffbbaa
	.db $27,$ed,$01,$0a
	.db $27,$f9,$02
	hex 0401
WarpScreenBlack:
	.db $3f,$00,$60,$0f
WarpAllStarsLayoutEND:
	.db $00

WarpPaletteEntry:
	.db $3f,$00,$60 ; mirrors BG colors for OBJs
