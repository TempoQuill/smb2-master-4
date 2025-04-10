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
