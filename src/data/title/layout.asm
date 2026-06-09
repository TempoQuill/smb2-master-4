TitleLayout:
	; red lines, vertical, left
	.db $20, $00, $DE, $FD
	.db $20, $01, $DE, $FD
	.db $20, $02, $DE, $FD
	.db $20, $03, $DE, $FD
	; red lines, vertical, right
	.db $20, $1C, $DE, $FD
	.db $20, $1D, $DE, $FD
	.db $20, $1E, $DE, $FD
	.db $20, $1F, $DE, $FD
	; red lines, horizontal, top
	.db $20, $03, $5D, $FD
	.db $20, $23, $5D, $FD
	.db $20, $43, $5D, $FD
	.db $20, $63, $5D, $FD
	; red lines, vertical, bottom
	.db $23, $63, $5D, $FD
	.db $23, $83, $5D, $FD
	.db $23, $A3, $5D, $FD

	; ornate frame, top
	.db $20, $68, $10, $48, $4A, $4C, $4E, $50, $51, $52, $53, $54, $55, $56, $57, $58, $5A, $5C, $5E
	.db $20, $84, $08, $FD, $22, $23, $24, $49, $4B, $4D, $4F
	.db $20, $94, $08, $59, $5B, $5D, $5F, $2E, $2F, $30, $FD
	.db $20, $A4, $03, $25, $26, $27
	.db $20, $B9, $03, $31, $32, $33
	.db $20, $C4, $03, $28, $29, $2A
	.db $20, $D9, $03, $34, $35, $36
	.db $20, $E3, $03, $2B, $2C, $2D
	.db $20, $FA, $03, $37, $38, $39
	.db $21, $03, $02, $3A, $3B
	.db $21, $1B, $02, $40, $41
	; ornate frame, lines down, top
	.db $21, $23, $C6, $3C
	.db $21, $3C, $C6, $42
	; ornate frame, middle
	.db $21, $E3, $01, $3D
	.db $21, $FC, $01, $60
	.db $22, $02, $02, $3E, $3F
	.db $22, $1C, $02, $61, $62
	.db $22, $22, $02, $43, $44
	.db $22, $3C, $02, $63, $64
	.db $22, $43, $01, $45
	.db $22, $5C, $01, $65
	; ornate frame, lines down, bottom
	.db $22, $63, $C6, $3C
	.db $22, $7C, $C4, $42
	; ornate frame, bottom, characters
;                          Snifit
	.db $22, $C4, $02, $A6, $A8
	.db $22, $E4, $02, $A7, $A9
;                          Mario,    Princess
	.db $22, $FA, $04, $80, $82, $88, $8A
;                          Luigi
	.db $23, $04, $02, $FF, $AF
;                          Radish
	.db $23, $14, $02, $9E, $A0
;                          Mario,    Princess
	.db $23, $1A, $04, $AC, $FF, $89, $8B
;                               Luigi
	.db $23, $23, $03, $46, $FF, $FF
;                          Shyguy
	.db $23, $2A, $02, $A2, $A4
;                                                        Radish,  Wind, Toad
	.db $23, $2E, $0B, $67, $6C, $6E, $70, $72, $69, $9F, $A1, $75, $98, $9A
;                          Mario,    Princess
	.db $23, $3A, $04, $FF, $FF, $8C, $8E
;                               Luigi,                        Shyguy
	.db $23, $43, $1B, $47, $94, $96, $74, $74, $74, $74, $A3, $A5, $74, $66, $68
;                                                   Toad           Mario,    Princess
	.db $6D, $6F, $71, $73, $6A, $6B, $74, $74, $99, $9B, $74, $85, $87, $8D, $8F
;                          Luigi,         Grass
	.db $23, $64, $05, $95, $97, $FD, $FD, $FD
;                          Toad,     Grass
	.db $23, $77, $04, $9C, $9D, $FD, $FD
;                          Grass
	.db $23, $89, $02, $FD, $FD

	; SUPER
	;                  SSSSSSSS  UUUUUUUU  PPPPPPPP  EEEEEEEE  RRRRRRRR
	.db $20, $CB, $0A, $00, $01, $08, $08, $FC, $01, $FC, $08, $FC, $01
	.db $20, $EB, $0A, $02, $03, $08, $08, $0A, $05, $0B, $0C, $0A, $0D
	.db $21, $0B, $0A, $04, $7B, $04, $7B, $0E, $07, $FD, $7C, $0E, $7C
	.db $21, $2B, $05, $06, $07, $06, $07, $09
	.db $21, $31, $04, $76, $09, $09, $09

	; TM
	;                  TTT  MMM
	.db $21, $38, $02, $F9, $FA

	; MARIO
	;                  MMMMMMMMMMMMM  AAAAAAAA  RRRRRRRR  III  OOOOOOOO
	.db $21, $46, $0A, $00, $0F, $01, $00, $01, $FC, $01, $08, $00, $01
	.db $21, $66, $0A, $10, $10, $08, $10, $08, $10, $08, $08, $10, $08
	.db $21, $86, $0A, $08, $08, $08, $08, $08, $13, $0D, $08, $08, $08
	.db $21, $A6, $0A, $7C, $7C, $7C, $FD, $7C, $0E, $7C, $7C, $7C, $7C
	.db $21, $C6, $0A, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $04, $7B
	.db $21, $E6, $0A, $09, $09, $09, $09, $09, $09, $09, $09, $06, $07

	; BROS
	;                  BBBBBBBB  RRRRRRRR  OOOOOOOO  SSSSSSSS
	.db $21, $51, $08, $FC, $01, $FC, $01, $00, $01, $00, $01 ; BROS
	.db $21, $71, $08, $10, $08, $10, $08, $10, $08, $10, $08
	.db $21, $91, $08, $13, $0D, $13, $0D, $08, $08, $77, $03
	.db $21, $B1, $08, $0E, $7C, $0E, $7C, $7C, $7C, $12, $7C
	.db $21, $D1, $09, $7D, $7B, $7C, $7C, $04, $7B, $04, $7B, $7C
	.db $21, $F1, $09, $11, $07, $09, $09, $06, $07, $06, $07, $09

	; 2
	;             22222222222222222222222
	.db $22, $0E, $04, $14, $15, $16, $17
	.db $22, $2E, $04, $18, $19, $1A, $1B
	.db $22, $4E, $04, $1C, $1D, $1E, $1F
	.db $22, $6E, $04, $78, $79, $7A, $20
	.db $22, $8E, $04, $76, $76, $76, $21

	; (C) 1988
	;                  (C)  111  999  888  888
	.db $22, $E9, $05, $F8, $D1, $D9, $D8, $D8 ; (C) 1988

	; NINTENDO
	;                  NNN  III  NNN  TTT  EEE  NNN  DDD  OOO
	.db $22, $EF, $08, $E7, $E2, $E7, $ED, $DE, $E7, $DD, $E8

	.db $23, $CA, $04, $80, $A0, $A0, $20
	.db $23, $D1, $0E, $80, $A8, $AA, $AA, $A2, $22, $00, $00, $88, $AA, $AA, $AA, $AA, $22
	.db $23, $E3, $02, $44, $11
	.db $23, $EA, $04, $F0, $F4, $F1, $F0
	.db $23, $F1, $01, $03
	.db $23, $F6, $01, $0C
	.db $00

TitleBackgroundPalettes:
	.db $0F, $37, $16, $07 ; Most of screen, outline, etc.
	.db $0F, $27, $38, $08 ; 2
	.db $0F, $31, $2C, $01 ; Logo
	.db $0F, $37, $27, $30 ; Copyright, Story, Sclera

TitleSpritePalettes:
	.db $0F, $01, $16, $27 ; Mario, Grass
	.db $0F, $36, $25, $06 ; Princess, Snifit
	.db $0F, $30, $27, $01 ; Toad, Radish
	.db $0F, $36, $2A, $01 ; Luigi

TitleOAM:
;           Y    Tile Attr X
	; Snifit - 4
	.db $AF, $A6, $01, $20 ; 22C4
	.db $AF, $A8, $01, $28 ; 22C5
	.db $B7, $A7, $01, $20 ; 22E4
	.db $B7, $A9, $01, $28 ; 22E5
	; Mario - 8
	.db $B7, $80, $00, $D0 ; 22FA
	.db $B7, $82, $00, $D8 ; 22FB
	.db $BF, $81, $00, $D0 ; 231A
	.db $BF, $83, $00, $D8 ; 231B
	.db $C7, $84, $00, $D0 ; 233A
	.db $C7, $86, $00, $D8 ; 233B
	.db $CF, $AD, $00, $D0 ; 235A
	.db $CF, $AE, $00, $D8 ; 235B
	; Luigi - 8
	.db $BF, $90, $03, $20 ; 2304
	.db $BF, $92, $03, $28 ; 2305
	.db $C7, $B0, $03, $20 ; 2324
	.db $C7, $93, $03, $28 ; 2325
	.db $CF, $B1, $03, $20 ; 2344
	.db $CF, $B2, $03, $28 ; 2345
	.db $D7, $B3, $03, $20 ; 2364
	.db $D7, $B4, $03, $28 ; 2365
	; Radish - 4
	.db $BF, $9E, $01, $A0 ; 2314
	.db $BF, $A0, $01, $A8 ; 2315
	.db $C7, $9F, $01, $A0 ; 2334
	.db $C7, $A1, $01, $A8 ; 2335
	; Toad - 6
	.db $C7, $98, $02, $B8 ; 2337
	.db $C7, $9A, $02, $C0 ; 2338
	.db $CF, $B5, $02, $B8 ; 2357
	.db $CF, $B6, $02, $C0 ; 2358
	.db $D7, $B7, $02, $B8 ; 2377
	.db $D7, $B8, $02, $C0 ; 2378
	; Grass - 2
	.db $D7, $AA, $03, $38 ; 2367
	.db $D7, $AB, $03, $40 ; 2368
	; Grass - 2
	.db $D7, $AA, $03, $C8 ; 2379
	.db $D7, $AB, $03, $D0 ; 237A
	; Grass - 2
	.db $DF, $AA, $03, $48 ; 2389
	.db $DF, $AB, $03, $50 ; 238A
	.db $00

TitleStoryText_STORY:
	.db $EC, $ED, $E8, $EB, $F2 ; STORY

TitleStoryTextPointersHi:
	.db >TitleStoryText_Line01
	.db >TitleStoryText_Line02
	.db >TitleStoryText_Line03
	.db >TitleStoryText_Line04
	.db >TitleStoryText_Line05
	.db >TitleStoryText_Line06
	.db >TitleStoryText_Line07
	.db >TitleStoryText_Line08
	.db >TitleStoryText_Line08 ; For some reason line 8 is referenced twice here, but not used
	.db >TitleStoryText_Line09
	.db >TitleStoryText_Line10
	.db >TitleStoryText_Line11
	.db >TitleStoryText_Line12
	.db >TitleStoryText_Line13
	.db >TitleStoryText_Line14
	.db >TitleStoryText_Line15
	.db >TitleStoryText_Line16

TitleStoryTextPointersLo:
	.db <TitleStoryText_Line01
	.db <TitleStoryText_Line02
	.db <TitleStoryText_Line03
	.db <TitleStoryText_Line04
	.db <TitleStoryText_Line05
	.db <TitleStoryText_Line06
	.db <TitleStoryText_Line07
	.db <TitleStoryText_Line08
	.db <TitleStoryText_Line08
	.db <TitleStoryText_Line09
	.db <TitleStoryText_Line10
	.db <TitleStoryText_Line11
	.db <TitleStoryText_Line12
	.db <TitleStoryText_Line13
	.db <TitleStoryText_Line14
	.db <TitleStoryText_Line15
	.db <TitleStoryText_Line16

TitleStoryText_Line01:
	.db $F0, $E1, $DE, $E7, $FB, $FB, $E6, $DA, $EB, $E2, $E8, $FB, $E8, $E9, $DE, $E7
	.db $DE, $DD, $FB, $DA ; WHEN MARIO OPENED A

TitleStoryText_Line02:
	.db $DD, $E8, $E8, $EB, $FB, $DA, $DF, $ED, $DE, $EB, $FB, $FB, $DC, $E5, $E2, $E6
	.db $DB, $E2, $E7, $E0 ; DOOR AFTER CLIMBING

TitleStoryText_Line03:
	.db $DA, $FB, $E5, $E8, $E7, $E0, $FB, $EC, $ED, $DA, $E2, $EB, $FB, $E2, $E7, $FB
	.db $FB, $E1, $E2, $EC ; A LONG STAIR IN HIS

TitleStoryText_Line04:
	.db $DD, $EB, $DE, $DA, $E6, $F7, $FB, $DA, $E7, $E8, $ED, $E1, $DE, $EB, $FB, $F0
	.db $E8, $EB, $E5, $DD ; DREAM, ANOTHER WORLD

TitleStoryText_Line05:
	.db $EC, $E9, $EB, $DE, $DA, $DD, $FB, $FB, $FB, $DB, $DE, $DF, $E8, $EB, $DE, $FB
	.db $FB, $E1, $E2, $E6 ; SPREAD BEFORE HIM

TitleStoryText_Line06:
	.db $DA, $E7, $DD, $FB, $E1, $DE, $FB, $E1, $DE, $DA, $EB, $DD, $FB, $DA, $FB, $EF
	.db $E8, $E2, $DC, $DE ; AND HE HEARD A VOICE

TitleStoryText_Line07:
	.db $DC, $DA, $E5, $E5, $FB, $DF, $E8, $EB, $FB, $E1, $DE, $E5, $E9, $FB, $ED, $E8
	.db $FB, $FB, $DB, $DE ; CALL FOR HELP TO BE

TitleStoryText_Line08:
	.db $FB, $DF, $EB, $DE, $DE, $DD, $FB, $FB, $DF, $EB, $E8, $E6, $FB, $DA, $FB, $EC
	.db $E9, $DE, $E5, $E5 ; FREED FROM A SPELL

TitleStoryText_Line09:
	.db $DA, $DF, $ED, $DE, $EB, $FB, $FB, $DA, $F0, $DA, $E4, $DE, $E7, $E2, $E7, $E0
	.db $F7, $FB, $FB, $FB ; AFTER AWAKENING,

TitleStoryText_Line10:
	.db $E6, $DA, $EB, $E2, $E8, $FB, $FB, $F0, $DE, $E7, $ED, $FB, $ED, $E8, $FB, $FB
	.db $DA, $FB, $FB, $FB ; MARIO WENT TO A

TitleStoryText_Line11:
	.db $DC, $DA, $EF, $DE, $FB, $FB, $E7, $DE, $DA, $EB, $DB, $F2, $FB, $DA, $E7, $DD
	.db $FB, $FB, $ED, $E8 ; CAVE NEARBY AND TO

TitleStoryText_Line12:
	.db $E1, $E2, $EC, $FB, $FB, $EC, $EE, $EB, $E9, $EB, $E2, $EC, $DE, $FB, $E1, $DE
	.db $FB, $EC, $DA, $F0 ; HIS SURPRISE HE SAW

TitleStoryText_Line13:
	.db $DE, $F1, $DA, $DC, $ED, $E5, $F2, $FB, $FB, $F0, $E1, $DA, $ED, $FB, $E1, $DE
	.db $FB, $EC, $DA, $F0 ; EXACTLY WHAT HE SAW

TitleStoryText_Line14:
	.db $E2, $E7, $FB, $E1, $E2, $EC, $FB, $DD, $EB, $DE, $DA, $E6, $CF, $CF, $CF, $CF
	.db $FB, $FB, $FB, $FB ; IN HIS DREAM....

TitleStoryText_Line15:
	.db $ED, $E8, $FB, $E9, $EB, $E8, $DC, $DE, $DE, $DD, $F7, $FB, $E9, $EB, $DE, $EC
	.db $EC, $FB, $DA, $FB ; TO PROCEED, PRESS A

TitleStoryText_Line16:
	.db $FB, $E8, $EB, $FB, $EC, $ED, $DA, $EB, $ED, $F6, $FB, $FB, $FB, $FB, $FB, $FB
	.db $FB, $FB, $FB, $FB ; OR START

TitleAttributeData1:
	.db $23, $CB, $42, $FF
	.db $23, $D1, $01, $CC
	.db $23, $D2, $44, $FF
	.db $23, $D6, $01, $33
	.db $23, $D9, $01, $CC
	.db $23, $DA, $44, $FF

TitleAttributeData2:
	.db $23, $DE, $01, $33
	.db $23, $E1, $01, $CC
	.db $23, $E2, $44, $FF
	.db $23, $E6, $01, $33
	.db $23, $EA, $44, $FF
	.db $23, $E9, $01, $CC
	.db $23, $EE, $01, $33
