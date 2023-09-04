;
; Bank C & Bank D
; ===============
;
; What's inside:
;
;   - The ending sequence with Mario sleeping and the cast roll
;

MarioDream_Pointers:
	.dw iPPUBuffer
	.dw MarioDream_Bed
	.dw MarioDream_Bubble
	.dw MarioDream_DoNothing
	.dw MarioDream_EraseBubble1
	.dw MarioDream_EraseBubble2
	.dw MarioDream_EraseBubble3
	.dw MarioDream_EraseBubble4
	.dw MarioDream_EraseBubble5
	.dw MarioDream_Palettes

; =============== S U B R O U T I N E =======================================

sub_BANKC_8014:
	LDA #0
	BEQ loc_BANKC_801A

; End of function sub_BANKC_8014

; =============== S U B R O U T I N E =======================================

sub_BANKC_8018:
	LDA #PPUMask_ShowLeft8Pixels_BG | PPUMask_ShowLeft8Pixels_SPR | PPUMask_ShowBackground | PPUMask_ShowSprites

loc_BANKC_801A:
	STA zPPUMask

; End of function sub_BANKC_8018

; =============== S U B R O U T I N E =======================================

sub_BANKC_801C:
	LDA zScreenUpdateIndex
	ASL A
	TAX
	LDA MarioDream_Pointers, X
	STA zPPUDataBufferPointer
	LDA MarioDream_Pointers + 1, X
	STA zPPUDataBufferPointer + 1

	LDA #$00
	STA zNMIOccurred
loc_BANKC_802E:
	LDA zNMIOccurred
	BPL loc_BANKC_802E
	RTS

; End of function sub_BANKC_801C


EnableNMI_BankC:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIEnabled
	STA zPPUControl
	STA PPUCTRL
	RTS


DisableNMI_BankC:
	LDA #PPUCtrl_Base2000 | PPUCtrl_WriteHorizontal | PPUCtrl_Sprite0000 | PPUCtrl_Background1000 | PPUCtrl_SpriteSize8x16 | PPUCtrl_NMIDisabled
	STA PPUCTRL
	STA zPPUControl
	RTS


MarioDream_Palettes:
	.db $3F, $00, $20
	.db $02, $22, $12, $0F
	.db $02, $30, $16, $0F
	.db $02, $30, $16, $28
	.db $02, $22, $31, $0F
	.db $02, $27, $16, $0F
	.db $02, $27, $2A, $0F
	.db $02, $27, $25, $0F
	.db $02, $27, $3C, $0F
	.db $00

MarioDream_Bed:
	.db $20, $00, $60, $FF
	.db $20, $20, $60, $FF
	.db $20, $40, $60, $FF
	.db $20, $60, $60, $FF
	.db $23, $40, $60, $FF
	.db $23, $60, $60, $FF
	.db $23, $80, $60, $FF
	.db $23, $A0, $60, $FF
	.db $20, $80, $D6, $FF
	.db $20, $81, $D6, $FF
	.db $20, $82, $D6, $FF
	.db $20, $83, $D6, $FF
	.db $20, $9C, $D6, $FF
	.db $20, $9D, $D6, $FF
	.db $20, $9E, $D6, $FF
	.db $20, $9F, $D6, $FF
	.db $20, $84, $58, $FC
	.db $20, $A4, $58, $FC
	.db $20, $C4, $58, $FC
	.db $20, $E4, $58, $FC
	.db $21, $04, $58, $FC
	.db $21, $24, $58, $FC
	.db $21, $44, $58, $FC
	.db $21, $64, $58, $FC
	.db $21, $84, $58, $FC
	.db $21, $A4, $58, $FC
	.db $21, $C4, $58, $FC
	.db $21, $E4, $58, $FC
	.db $22, $04, $58, $FC
	.db $22, $24, $58, $FC
	.db $22, $44, $58, $FC
	.db $22, $64, $58, $FC
	.db $22, $84, $58, $FC
	.db $22, $A4, $58, $FC
	.db $22, $C4, $58, $FC
	.db $21, $4E, $02, $60, $61
	.db $21, $6E, $02, $70, $71
	.db $21, $8E, $02, $80, $81
	.db $21, $AC, $06, $36, $37, $38, $39, $3A, $3B
	.db $21, $CA, $0C, $36, $37, $35, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F
	.db $21, $E8, $0E, $36, $37, $35, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D
	.db $5E, $5F ; $F
	.db $22, $06, $10, $36, $37, $35, $FC, $64, $65, $66, $67, $68, $69, $6A, $6B
	.db $6C, $6D, $6E, $6F ; $F
	.db $22, $24, $12, $36, $37, $35, $FC, $FC, $FC, $74, $75, $76, $77, $78, $79
	.db $7A, $7B, $7C, $7D, $7E, $7F ; $F
	.db $22, $44, $18, $35, $FC, $FC, $FC, $82, $83, $84, $85, $86, $87, $88, $89
	.db $8A, $8B, $8C, $8D, $8E, $8F, $00, $01, $02, $03, $04, $05 ; $F
	.db $22, $68, $14, $92, $93, $94, $95, $96, $97, $98, $99, $9A, $9B, $9C, $9D
	.db $9E, $9F, $10, $11, $12, $13, $14, $15 ; $F
	.db $22, $88, $14, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD
	.db $AE, $AF, $FE, $FE, $FE, $FE, $FE, $FE ; $F
	.db $22, $A7, $15, $B1, $B2, $B3, $B4, $B5, $B6, $B7, $B8, $B9, $BA, $BB, $BC
	.db $BD, $BE, $BF, $FE, $FE, $FE, $FE, $FE, $FE ; $F
	.db $22, $C6, $16, $C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9, $CA, $CB
	.db $CC, $CD, $FE, $FE, $FE, $FE, $FE, $FE, $FE, $FE ; $F
	.db $22, $E4, $18, $B1, $F1, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9
	.db $DA, $DB, $FE, $FE, $FE, $FE, $FE, $FE, $FE, $FE, $FE, $FE ; $F
	.db $23, $04, $18, $F0, $FE, $FE, $FE, $E2, $E3, $E4, $E5, $E6, $E7, $E8, $E9
	.db $EA, $FE, $FE, $FE, $FE, $FE, $FE, $FE, $FE, $FE, $FE, $FE ; $F
	.db $23, $24, $18, $FE, $FE, $FE, $FE, $F2, $F3, $F4, $F5, $F6, $F7, $F8, $F9
	.db $FA, $FE, $FE, $FE, $FE, $FE, $FE, $FE, $FE, $FE, $FE, $FE ; $F
	.db $00

MarioDream_Bubble:
	.db $20, $8F, $84, $06, $16, $07, $17
	.db $20, $D0, $85, $08, $18, $09, $19, $1D
	.db $20, $90, $4C, $FD
	.db $20, $B0, $4C, $FD
	.db $20, $D1, $4B, $FD
	.db $20, $F1, $0B, $FD, $FD, $FD, $28, $29, $29, $29, $29, $2A, $FD, $FD
	.db $21, $11, $0B, $FD, $FD, $FD, $FD, $27, $FD, $FD, $27, $FD, $FD, $FD
	.db $21, $31, $0B, $FD, $FD, $FD, $FD, $27, $FD, $FD, $27, $FD, $FD, $FD
	.db $21, $51, $0B, $FD, $FD, $23, $24, $25, $22, $23, $24, $25, $25, $FD
	.db $21, $71, $0B, $0B, $0C, $0D, $0E, $0F, $FD, $FD, $FD, $FD, $FD, $FD
	.db $21, $95, $07, $1F, $1A, $30, $31, $32, $33, $1B
	.db $21, $B5, $06, $53, $FC, $40, $41, $42, $43
	.db $21, $D7, $03, $50, $51, $52
	.db $21, $F6, $02, $20, $21
	.db $23, $CB, $04, $44, $55, $A5, $65 ; Attribute table changes
	.db $23, $D4, $03, $55, $5A, $56
	.db $23, $DD, $02, $45, $15
	.db $23, $E4, $01, $3F
	.db $00

; This is pointed to, but the very first byte
; is the terminating 0, so nothing gets drawn.
; This would have undone the attribute changes
; done in the above PPU writing, but I guess
; Nintendo realized they were never going to
; use that part of the screen again
MarioDream_DoNothing:
	.db $00
	.db $23, $CB, $44, $00
	.db $23, $D4, $43, $00
	.db $23, $DD, $42, $00
	.db $00

MarioDream_EraseBubble1:
	.db $20, $8F, $4D, $FC
	.db $20, $AF, $4D, $FC
	.db $00

MarioDream_EraseBubble2:
	.db $20, $CF, $4D, $FC
	.db $20, $EF, $4D, $FC
	.db $00

MarioDream_EraseBubble3:
	.db $21, $10, $4C, $FC
	.db $21, $30, $4C, $FC
	.db $00

MarioDream_EraseBubble4:
	.db $21, $50, $4C, $FC
	.db $21, $71, $4B, $FC
	.db $00

MarioDream_EraseBubble5:
	.db $21, $95, $47, $FC
	.db $21, $B5, $46, $FC
	.db $21, $D7, $43, $FC
	.db $21, $F6, $42, $FC
	.db $00

MarioDream_BubbleSprites:
	.db $28, $00, $00, $A8
	.db $28, $04, $01, $B0
	.db $28, $08, $02, $C0
	.db $28, $0C, $03, $B8

byte_BANKC_8308:
	.db $28, $02, $00, $A8
	.db $28, $06, $01, $B0

byte_BANKC_8310:
	.db $28, $0A, $02, $C0
	.db $28, $0E, $03, $B8

MarioDream_SnoringFrameCounts:
	.db $20
	.db $0A
	.db $0A
	.db $0A
	.db $0A
	.db $0A
	.db $0A
	.db $20
	.db $0A
	.db $0A
	.db $0A
	.db $0A
	.db $0A
	.db $0A

MarioDream_WakingFrameCounts:
	.db $08
	.db $08
	.db $50
	.db $40
	.db $30
	.db $10
	.db $10

MarioDream_SnoringFrames:
	.db CHRBank_EndingBackground1
	.db CHRBank_EndingBackground2
	.db CHRBank_EndingBackground3
	.db CHRBank_EndingBackground4
	.db CHRBank_EndingBackground5
	.db CHRBank_EndingBackground6
	.db CHRBank_EndingBackground7
	.db CHRBank_EndingBackground8
	.db CHRBank_EndingBackground7
	.db CHRBank_EndingBackground6
	.db CHRBank_EndingBackground5
	.db CHRBank_EndingBackground4
	.db CHRBank_EndingBackground3
	.db CHRBank_EndingBackground2

MarioDream_WakingFrames:
	.db CHRBank_EndingBackground11
	.db CHRBank_EndingBackground10
	.db CHRBank_EndingBackground9
	.db CHRBank_EndingBackground12
	.db CHRBank_EndingBackground9
	.db CHRBank_EndingBackground10
	.db CHRBank_EndingBackground11


MarioSleepingScene:
	INC iMainGameState
	JSR sub_BANKC_8014

	LDA #VMirror
	JSR ChangeNametableMirroring

	JSR ClearNametablesAndSprites

	LDA #Stack100_Menu
	STA iStack
	JSR EnableNMI_BankC

	JSR sub_BANKC_801C

	LDA #9
	STA zScreenUpdateIndex
	JSR sub_BANKC_801C

	LDA #1
	STA zScreenUpdateIndex
	JSR sub_BANKC_801C

	LDA #2
	STA zScreenUpdateIndex
	JSR sub_BANKC_801C

	LDA #$10
	STA zObjectXHi + 3
	LDA #4
	STA zPlayerXHi

loc_BANKC_8375:
	LDA #0
	STA zObjectXHi
	LDA #$D
	STA zObjectXHi + 1
	LDA #0
	STA zObjectXHi + 2
	JSR sub_BANKC_8493

	JSR sub_BANKC_8018

loc_BANKC_8387:
	LDY zObjectXHi
	LDA MarioDream_SnoringFrames, Y
	STA iBGCHR1
	CLC
	ADC #$02
	STA iBGCHR2
	LDA MarioDream_SnoringFrameCounts, Y
	STA z10

loc_BANKC_839A:
	DEC zObjectXHi + 3
	BPL loc_BANKC_83A7

	LDA #$10
	STA zObjectXHi + 3
	INC zObjectXHi + 2
	JSR sub_BANKC_8493

loc_BANKC_83A7:
	JSR sub_BANKC_801C

	DEC z10
	BPL loc_BANKC_839A

	INC zObjectXHi
	DEC zObjectXHi + 1
	BPL loc_BANKC_8387

	DEC zPlayerXHi
	BMI loc_BANKC_83BB

	JMP loc_BANKC_8375

; ---------------------------------------------------------------------------

loc_BANKC_83BB:
	LDA #3
	STA zScreenUpdateIndex
	LDA #$F8
	STA iVirtualOAM
	STA iVirtualOAM + 4
	STA iVirtualOAM + 8
	STA iVirtualOAM + $C
	JSR sub_BANKC_801C

	LDA #4
	STA zScreenUpdateIndex
	JSR sub_BANKC_801C

	LDA #5
	STA zScreenUpdateIndex
	JSR sub_BANKC_801C

	LDA #6
	STA zScreenUpdateIndex
	JSR sub_BANKC_801C

	LDA #7
	STA zScreenUpdateIndex
	JSR sub_BANKC_801C

	LDA #8
	STA zScreenUpdateIndex
	JSR sub_BANKC_801C

	LDA #0
	STA zObjectXHi
	LDA #6
	STA zObjectXHi + 1
	LDA #0
	STA zPlayerXHi
	JSR sub_BANKC_8018

loc_BANKC_8402:
	LDY zObjectXHi
	LDA MarioDream_WakingFrames, Y
	STA iBGCHR1
	CLC
	ADC #$02
	STA iBGCHR2
	LDA MarioDream_WakingFrameCounts, Y
	STA z10

loc_BANKC_8415:
	JSR sub_BANKC_801C

	DEC z10
	BPL loc_BANKC_8415

	INC zObjectXHi
	DEC zObjectXHi + 1
	BPL loc_BANKC_8402

	LDA #$10
	STA zObjectXHi + 3
	LDA #1
	STA zPlayerXHi

loc_BANKC_842A:
	LDA #0
	STA zObjectXHi
	LDA #$D
	STA zObjectXHi + 1
	JSR sub_BANKC_8018

loc_BANKC_8435:
	LDY zObjectXHi
	LDA MarioDream_SnoringFrames, Y
	STA iBGCHR1
	CLC
	ADC #$02
	STA iBGCHR2
	LDA MarioDream_SnoringFrameCounts, Y
	STA z10

loc_BANKC_8448:
	JSR sub_BANKC_801C

	DEC z10
	BPL loc_BANKC_8448

	INC zObjectXHi

loc_BANKC_8451:
	DEC zObjectXHi + 1
	BPL loc_BANKC_8435

	DEC zPlayerXHi
	BMI loc_BANKC_845C

	JMP loc_BANKC_842A

; ---------------------------------------------------------------------------

loc_BANKC_845C:
	JSR sub_BANKC_84FB

	JSR sub_BANKC_801C

loc_BANKC_8462:
	LDA #0
	STA zObjectXHi
	LDA #$D
	STA zObjectXHi + 1
	JSR sub_BANKC_8018

loc_BANKC_846D:
	LDY zObjectXHi
	LDA MarioDream_SnoringFrames, Y
	STA iBGCHR1
	CLC
	ADC #$02
	STA iBGCHR2
	LDA MarioDream_SnoringFrameCounts, Y
	STA z10

loc_BANKC_8480:
	JSR loc_BANKC_84B2

	JSR sub_BANKC_801C

	DEC z10
	BPL loc_BANKC_8480

	INC zObjectXHi
	DEC zObjectXHi + 1

loc_BANKC_848E:
	BPL loc_BANKC_846D

loc_BANKC_8490:
	JMP loc_BANKC_8462

; =============== S U B R O U T I N E =======================================

sub_BANKC_8493:
	LDY #$F
	LDA zObjectXHi + 2
	AND #1
	BNE loc_BANKC_84A5

loc_BANKC_849B:
	LDA MarioDream_BubbleSprites, Y
	STA iVirtualOAM, Y
	DEY
	BPL loc_BANKC_849B
	RTS

; ---------------------------------------------------------------------------

loc_BANKC_84A5:
	LDA byte_BANKC_8308, Y
	STA iVirtualOAM, Y
	DEY
	BPL loc_BANKC_84A5
	RTS

; End of function sub_BANKC_8493

; ---------------------------------------------------------------------------
CastRoll_PaletteFadeIn:
	.db $22

	.db $32
	.db $30
; ---------------------------------------------------------------------------

loc_BANKC_84B2:
	INC zObjectXLo + 5
	LDA zObjectXLo + 5
	AND #1
	BNE loc_BANKC_84C0

	DEC zObjectYLo + 6
	DEC zObjectYLo + 7
	DEC zObjectYLo + 8

loc_BANKC_84C0:
	LDA zMarioSleepingSceneIndex
	JSR JumpToTableAfterJump

; ---------------------------------------------------------------------------
	.dw loc_BANKC_8593
	.dw loc_BANKC_85D6
	.dw loc_BANKC_85E7
	.dw loc_BANKC_861C
	.dw loc_BANKC_8898
	.dw loc_BANKC_88D7
	.dw loc_BANKC_89B6
	.dw loc_BANKC_8A04
	.dw loc_BANKC_8A37
	.dw InitEndingCursive
	.dw WriteEndingCursive
	.dw DoPostCastPrompt
	.dw PostCastMenu
; ---------------------------------------------------------------------------
	RTS

; ---------------------------------------------------------------------------
CastRoll_CASTText:
	.db $60,$D4,$00,$28
	.db $60,$D0,$00,$38 ; 4
	.db $60,$F4,$00,$48 ; 8
	.db $60,$F6,$00,$58 ; $C

; =============== S U B R O U T I N E =======================================

sub_BANKC_84EC:
	LDY zObjectXLo + 2
	LDA CastRoll_SpritePointersLo, Y
	STA zObjectXLo + 6
	LDA CastRoll_SpritePointersHi, Y
	STA zObjectXLo + 7
	INC zObjectXLo + 2
	RTS

; End of function sub_BANKC_84EC

; =============== S U B R O U T I N E =======================================

sub_BANKC_84FB:
	LDY #CHRBank_EndingCast1
	STY iObjCHR1

loc_BANKC_8500:
	INY
	STY iObjCHR2
	INY
	STY iObjCHR3
	INY
	STY iObjCHR4
	LDX #$07
	LDA #$20
	STA zPlayerYHi
	LDY #$00

loc_BANKC_8514:
	LDA #$0F
	STA iVirtualOAM, Y
	INY
	LDA #$3E
	STA iVirtualOAM, Y
	INY
	LDA #$00
	STA iVirtualOAM, Y
	INY
	LDA zPlayerYHi
	STA iVirtualOAM, Y
	INY
	CLC
	ADC #$08
	STA zPlayerYHi
	DEX
	BPL loc_BANKC_8514

	LDX #$07
	LDA #$20
	STA zPlayerYHi

loc_BANKC_853A:
	LDA #$D0
	STA iVirtualOAM, Y
	INY
	LDA #$3E
	STA iVirtualOAM, Y
	INY
	LDA #$00
	STA iVirtualOAM, Y
	INY
	LDA zPlayerYHi
	STA iVirtualOAM, Y
	INY
	CLC
	ADC #$08
	STA zPlayerYHi
	DEX
	BPL loc_BANKC_853A

	LDX #$0F

loc_BANKC_855C:
	LDA CastRoll_CASTText, X
	STA iVirtualOAM + $40, X
	DEX
	BPL loc_BANKC_855C

	LDA #$3F
	STA iPPUBuffer
	LDA #$11
	STA iPPUBuffer + 1
	LDA #$01
	STA iPPUBuffer + 2
	LDA #$12
	STA iPPUBuffer + 3
	LDA #$00
	STA iPPUBuffer + 4
	LDA #$10
	STA zPlayerXLo
	LDA #$00
	STA zMarioSleepingSceneIndex
	STA zObjectXLo + 1
	LDY #$40

loc_BANKC_858A:
	LDA #EnemyState_27 ; @TODO what is this
	STA zEnemyState - 1, Y
	DEY
	BPL loc_BANKC_858A
	RTS

; End of function sub_BANKC_84FB

; ---------------------------------------------------------------------------

loc_BANKC_8593:
	DEC zPlayerXLo
	BPL locret_BANKC_85D5

	LDA #$10
	STA zPlayerXLo
	LDA #$3F
	STA iPPUBuffer
	LDA #$11
	STA iPPUBuffer + 1
	LDA #$01
	STA iPPUBuffer + 2
	LDY zObjectXLo + 1
	LDA CastRoll_PaletteFadeIn, Y
	STA iPPUBuffer + 3

loc_BANKC_85B2:
	LDA #$00
	STA iPPUBuffer + 4
	INC zObjectXLo + 1
	LDA zObjectXLo + 1
	CMP #$03
	BNE locret_BANKC_85D5

	INC zMarioSleepingSceneIndex
	LDA #$80
	STA zPlayerXLo
	LDA #$60
	STA zObjectYHi
	LDA #$01
	STA zObjectYLo + 2
	STA zObjectYLo + 5
	LDA #$00
	STA zObjectYLo + 3
	STA zObjectYLo + 4

locret_BANKC_85D5:
	RTS

; ---------------------------------------------------------------------------

loc_BANKC_85D6:
	DEC zPlayerXLo
	BPL locret_BANKC_85E6

	INC zMarioSleepingSceneIndex
	LDA #0
	STA zObjectXLo + 2
	STA zObjectXVelocity + 2
	LDA #1
	STA zObjectYLo + 7

locret_BANKC_85E6:
	RTS

; ---------------------------------------------------------------------------

loc_BANKC_85E7:
	LDA zObjectXLo + 5
	AND #1

loc_BANKC_85EB:
	BEQ loc_BANKC_861C

	LDA zObjectYHi
	SEC
	SBC #1
	STA zObjectYHi
	STA iVirtualOAM + $40
	STA iVirtualOAM + $44
	STA iVirtualOAM + $48
	STA iVirtualOAM + $4C
	LDA zObjectYHi
	CMP #$10
	BNE loc_BANKC_861C

	LDA #$F8
	STA iVirtualOAM + $40
	STA iVirtualOAM + $44
	STA iVirtualOAM + $48
	STA iVirtualOAM + $4A
	INC zMarioSleepingSceneIndex
	LDA #0
	STA zObjectYLo + 5
	STA zObjectYLo + 2

loc_BANKC_861C:
	LDA zObjectYLo + 2
	BNE loc_BANKC_8641

	LDA zObjectYLo + 6
	BNE loc_BANKC_8641

	JSR sub_BANKC_84EC

	LDY #$3F

loc_BANKC_8629:
	LDA (zObjectXLo+6), Y
	STA iVirtualOAM + $40, Y
	DEY
	BPL loc_BANKC_8629

	LDA #1
	STA zObjectYLo + 2
	LDA #$D0
	STA zObjectYHi
	LDA #$E0
	STA zObjectYHi + 1
	LDA #$F8
	STA zObjectYHi + 2

loc_BANKC_8641:
	LDA zObjectYLo + 3
	BNE loc_BANKC_8666

	LDA zObjectYLo + 7
	BNE loc_BANKC_8666

	JSR sub_BANKC_84EC

	LDY #$3F

loc_BANKC_864E:
	LDA (zObjectXLo+6), Y
	STA iVirtualOAM + $80, Y
	DEY
	BPL loc_BANKC_864E

	LDA #1
	STA zObjectYLo + 3
	LDA #$D0
	STA zObjectYHi + 3
	LDA #$E0
	STA zObjectYHi + 4
	LDA #$F8
	STA zObjectYHi + 5

loc_BANKC_8666:
	LDA zObjectYLo + 4
	BNE loc_BANKC_8693

	LDA zObjectYLo + 8
	BNE loc_BANKC_8693

	JSR sub_BANKC_84EC

	LDY #$3F

loc_BANKC_8673:
	LDA (zObjectXLo+6), Y
	STA iVirtualOAM + $C0, Y
	DEY
	BPL loc_BANKC_8673

	LDA #1
	STA zObjectYLo + 4
	LDA #$D0
	STA zObjectYHi + 6
	LDA #$E0
	STA zObjectYHi + 7
	LDY #$F8
	LDA zObjectXLo + 2
	CMP #$1D
	BNE loc_BANKC_8691

	LDY #$F0

loc_BANKC_8691:
	STY zObjectYHi + 8

loc_BANKC_8693:
	LDA zObjectYLo + 5
	BEQ loc_BANKC_869A

	JMP loc_BANKC_873A

; ---------------------------------------------------------------------------

loc_BANKC_869A:
	LDA zObjectXLo + 5
	AND #1
	BNE loc_BANKC_86A3

	JMP loc_BANKC_873A

; ---------------------------------------------------------------------------

loc_BANKC_86A3:
	LDA iVirtualOAM + $40
	CMP #$F8
	BEQ loc_BANKC_86C3

	LDA zObjectYHi
	SEC
	SBC #1
	CMP #$10
	BNE loc_BANKC_86B5

	LDA #$F8

loc_BANKC_86B5:
	STA zObjectYHi
	STA iVirtualOAM + $40
	STA iVirtualOAM + $44
	STA iVirtualOAM + $48
	STA iVirtualOAM + $4C

loc_BANKC_86C3:
	LDA iVirtualOAM + $50
	CMP #$F8
	BEQ loc_BANKC_86F2

	DEC zObjectYHi + 1
	CMP #$F9
	BNE loc_BANKC_86D6

	LDA zObjectYHi + 1
	CMP #$D0
	BNE loc_BANKC_86F2

loc_BANKC_86D6:
	LDA zObjectYHi + 1
	CMP #$10
	BNE loc_BANKC_86E6

	LDA zObjectXLo + 2
	CMP #$FF
	BNE loc_BANKC_86E4

	INC zMarioSleepingSceneIndex

loc_BANKC_86E4:
	LDA #$F8

loc_BANKC_86E6:
	STA iVirtualOAM + $50
	STA iVirtualOAM + $54
	STA iVirtualOAM + $58
	STA iVirtualOAM + $5C

loc_BANKC_86F2:
	LDA iVirtualOAM + $60
	CMP #$F8
	BEQ loc_BANKC_873A

	DEC zObjectYHi + 2
	CMP #$F9
	BNE loc_BANKC_870C

	LDA zObjectYHi + 2
	CMP #$D0
	BNE loc_BANKC_873A

	LDY zObjectXLo + 2
	LDA zEnemyState - 1, Y
	STA zObjectYLo + 7

loc_BANKC_870C:
	LDA zObjectYHi + 2
	CMP #$10
	BNE loc_BANKC_8722

	LDA #0
	STA zObjectYLo + 2
	LDA zObjectXLo + 2
	CMP #$FF
	BNE loc_BANKC_8720

	LDA #$FF
	STA zObjectYLo + 2

loc_BANKC_8720:
	LDA #$F8

loc_BANKC_8722:
	STA iVirtualOAM + $60
	STA iVirtualOAM + $64
	STA iVirtualOAM + $68
	STA iVirtualOAM + $6C
	STA iVirtualOAM + $70
	STA iVirtualOAM + $74
	STA iVirtualOAM + $78
	STA iVirtualOAM + $7C

loc_BANKC_873A:
	LDA zObjectXLo + 5
	AND #1
	BNE loc_BANKC_8743

	JMP loc_BANKC_87D2

; ---------------------------------------------------------------------------

loc_BANKC_8743:
	LDA iVirtualOAM + $80
	CMP #$F8
	BEQ loc_BANKC_8763

	LDA zObjectYHi + 3

loc_BANKC_874C:
	SEC
	SBC #1
	CMP #$10
	BNE loc_BANKC_8755

	LDA #$F8

loc_BANKC_8755:
	STA zObjectYHi + 3
	STA iVirtualOAM + $80
	STA iVirtualOAM + $84
	STA iVirtualOAM + $88
	STA iVirtualOAM + $8C

loc_BANKC_8763:
	LDA iVirtualOAM + $90
	CMP #$F8
	BEQ loc_BANKC_878A

	DEC zObjectYHi + 4
	CMP #$F9
	BNE loc_BANKC_8776

	LDA zObjectYHi + 4
	CMP #$D0
	BNE loc_BANKC_878A

loc_BANKC_8776:
	LDA zObjectYHi + 4
	CMP #$10
	BNE loc_BANKC_877E

	LDA #$F8

loc_BANKC_877E:
	STA iVirtualOAM + $90
	STA iVirtualOAM + $94

loc_BANKC_8784:
	STA iVirtualOAM + $98
	STA iVirtualOAM + $9C

loc_BANKC_878A:
	LDA iVirtualOAM + $A0
	CMP #$F8
	BEQ loc_BANKC_87D2

	DEC zObjectYHi + 5
	CMP #$F9
	BNE loc_BANKC_87A4

	LDA zObjectYHi + 5
	CMP #$D0
	BNE loc_BANKC_87D2

	LDY zObjectXLo + 2
	LDA zEnemyState - 1, Y
	STA zObjectYLo + 8

loc_BANKC_87A4:
	LDA zObjectYHi + 5
	CMP #$10
	BNE loc_BANKC_87BA

loc_BANKC_87AA:
	LDA #0
	STA zObjectYLo + 3
	LDA zObjectXLo + 2
	CMP #$FF
	BNE loc_BANKC_87B8

	LDA #$FF
	STA zObjectYLo + 3

loc_BANKC_87B8:
	LDA #$F8

loc_BANKC_87BA:
	STA iVirtualOAM + $A0
	STA iVirtualOAM + $A4
	STA iVirtualOAM + $A8
	STA iVirtualOAM + $AC
	STA iVirtualOAM + $B0
	STA iVirtualOAM + $B4
	STA iVirtualOAM + $B8
	STA iVirtualOAM + $BC

loc_BANKC_87D2:
	LDA zObjectXLo + 5
	AND #1
	BNE loc_BANKC_87DB

	JMP locret_BANKC_8897

; ---------------------------------------------------------------------------

loc_BANKC_87DB:
	LDA iVirtualOAM + $C0
	CMP #$F8
	BEQ loc_BANKC_87FB

	LDA zObjectYHi + 6
	SEC
	SBC #1
	CMP #$10
	BNE loc_BANKC_87ED

	LDA #$F8

loc_BANKC_87ED:
	STA zObjectYHi + 6
	STA iVirtualOAM + $C0
	STA iVirtualOAM + $C4
	STA iVirtualOAM + $C8
	STA iVirtualOAM + $CC

loc_BANKC_87FB:
	LDA iVirtualOAM + $D0
	CMP #$F8
	BEQ loc_BANKC_8822

	DEC zObjectYHi + 7
	CMP #$F9
	BNE loc_BANKC_880E

	LDA zObjectYHi + 7
	CMP #$D0
	BNE loc_BANKC_8822

loc_BANKC_880E:
	LDA zObjectYHi + 7
	CMP #$10
	BNE loc_BANKC_8816

	LDA #$F8

loc_BANKC_8816:
	STA iVirtualOAM + $D0
	STA iVirtualOAM + $D4
	STA iVirtualOAM + $D8
	STA iVirtualOAM + $DC

loc_BANKC_8822:
	LDA iVirtualOAM + $E0
	CMP #$F8
	BEQ locret_BANKC_8897

	DEC zObjectYHi + 8
	CMP #$F9
	BNE loc_BANKC_883C

	LDA zObjectYHi + 8
	CMP #$D0
	BNE locret_BANKC_8897

	LDY zObjectXLo + 2
	LDA zEnemyState - 1, Y
	STA zObjectYLo + 6

loc_BANKC_883C:
	LDA zObjectXLo + 2
	CMP #$1D
	BNE loc_BANKC_884C

	LDA zObjectYHi + 8
	CMP #$B8
	BNE loc_BANKC_884C

	LDA #1
	STA zObjectXVelocity + 2

loc_BANKC_884C:
	LDA zObjectYHi + 8
	CMP #$10
	BNE loc_BANKC_8862

	LDA #0
	STA zObjectYLo + 4
	LDA zObjectXLo + 2
	CMP #$FF
	BNE loc_BANKC_8860

	LDA #$FF
	STA zObjectYLo + 4

loc_BANKC_8860:
	LDA #$F8

loc_BANKC_8862:
	STA iVirtualOAM + $E0
	STA iVirtualOAM + $E4
	STA iVirtualOAM + $E8
	STA iVirtualOAM + $EC
	STA iVirtualOAM + $F0
	STA iVirtualOAM + $F4
	STA iVirtualOAM + $F8
	STA iVirtualOAM + $FC
	LDA zObjectXVelocity + 2
	BEQ locret_BANKC_8897

	LDY #$1F

loc_BANKC_8880:
	LDA CastRoll_TriclydeText, Y
	STA iVirtualOAM + $40, Y
	DEY
	BPL loc_BANKC_8880

	LDA #$D0
	STA zObjectYHi
	STA zObjectYHi + 1
	LDA #0
	STA zObjectXVelocity + 2

loc_BANKC_8893:
	LDA #$FF
	STA zObjectXLo + 2

locret_BANKC_8897:
	RTS

; ---------------------------------------------------------------------------

loc_BANKC_8898:
	LDY #CHRBank_EndingSprites
	STY iObjCHR1
	INY
	STY iObjCHR2
	INY
	STY iObjCHR3
	INY
	STY iObjCHR4
	LDY #$5B

loc_BANKC_88AB:
	LDA CastRoll_Wart, Y
	STA iVirtualOAM + $40, Y
	DEY
	BPL loc_BANKC_88AB

	INC zMarioSleepingSceneIndex
	LDY #0
	LDX #$F
	LDA #$C0

loc_BANKC_88BC:
	STA iVirtualOAM + 1, Y
	INY
	INY
	INY
	INY
	DEX
	BPL loc_BANKC_88BC

	LDA #$D0
	STA zObjectYHi
	LDA #$E0
	STA zObjectYHi + 1
	LDA #$F0
	STA zObjectYHi + 2
	LDA #8
	STA zObjectYHi + 3
	RTS

; ---------------------------------------------------------------------------

loc_BANKC_88D7:
	LDA zObjectXLo + 5
	AND #1
	BNE loc_BANKC_88E0

	JMP loc_BANKC_898D

; ---------------------------------------------------------------------------

loc_BANKC_88E0:
	LDA iVirtualOAM + $40
	CMP #$F8
	BEQ loc_BANKC_8906

	LDA zObjectYHi
	SEC
	SBC #1
	CMP #$50
	BNE loc_BANKC_88F5

	INC zMarioSleepingSceneIndex
	JMP loc_BANKC_898D

; ---------------------------------------------------------------------------

loc_BANKC_88F5:
	STA zObjectYHi
	STA iVirtualOAM + $40
	STA iVirtualOAM + $44
	STA iVirtualOAM + $48
	STA iVirtualOAM + $4C
	STA iVirtualOAM + $50

loc_BANKC_8906:
	LDA iVirtualOAM + $54
	CMP #$F8
	BEQ loc_BANKC_8930

	DEC zObjectYHi + 1
	CMP #$F9
	BNE loc_BANKC_8919

	LDA zObjectYHi + 1
	CMP #$D0
	BNE loc_BANKC_8930

loc_BANKC_8919:
	LDA zObjectYHi + 1
	CMP #$10
	BNE loc_BANKC_8921

	LDA #$F8

loc_BANKC_8921:
	STA iVirtualOAM + $54
	STA iVirtualOAM + $58
	STA iVirtualOAM + $5C
	STA iVirtualOAM + $60
	STA iVirtualOAM + $64

loc_BANKC_8930:
	LDA iVirtualOAM + $68
	CMP #$F8
	BEQ loc_BANKC_895A

	DEC zObjectYHi + 2
	CMP #$F9
	BNE loc_BANKC_8943

	LDA zObjectYHi + 2
	CMP #$D0
	BNE loc_BANKC_895A

loc_BANKC_8943:
	LDA zObjectYHi + 2
	CMP #$10
	BNE loc_BANKC_894B

	LDA #$F8

loc_BANKC_894B:
	STA iVirtualOAM + $68
	STA iVirtualOAM + $6C
	STA iVirtualOAM + $70
	STA iVirtualOAM + $74
	STA iVirtualOAM + $78

loc_BANKC_895A:
	LDA iVirtualOAM + $7C
	CMP #$F8
	BEQ loc_BANKC_898D

	DEC zObjectYHi + 3
	CMP #$F9
	BNE loc_BANKC_896D

	LDA zObjectYHi + 3
	CMP #$D0
	BNE loc_BANKC_898D

loc_BANKC_896D:
	LDA zObjectYHi + 3
	CMP #$10
	BNE loc_BANKC_8975

	LDA #$F8

loc_BANKC_8975:
	STA iVirtualOAM + $7C
	STA iVirtualOAM + $80
	STA iVirtualOAM + $84
	STA iVirtualOAM + $88
	STA iVirtualOAM + $8C
	STA iVirtualOAM + $90
	STA iVirtualOAM + $94
	STA iVirtualOAM + $98

loc_BANKC_898D:
	LDA #0
	STA zObjectXVelocity
	STA zPlayerXVelocity
	LDA #$C
	STA zObjectXVelocity + 1
	RTS

; ---------------------------------------------------------------------------
byte_BANKC_8998:
	.db $9E

	.db $A0
	.db $A2
	.db $A4
	.db $88
	.db $A6
	.db $A8
	.db $AA
	.db $AC
	.db $92
	.db $94
	.db $96
	.db $98
	.db $9A
	.db $9C
byte_BANKC_89A7:
	.db $AE

	.db $B0
byte_BANKC_89A9:
	.db $B2
	.db $B4
	.db $BE
	.db $B6
	.db $B8
	.db $BA
	.db $BC
	.db $92
	.db $94
	.db $96
	.db $98
	.db $9A
	.db $9C
; ---------------------------------------------------------------------------

loc_BANKC_89B6:
	DEC zPlayerXVelocity
	BPL locret_BANKC_8A00

	LDA #8
	STA zPlayerXVelocity
	DEC zObjectXVelocity + 1
	BPL loc_BANKC_89CD

	INC zMarioSleepingSceneIndex
	LDA #0
	STA zPlayerXLo
	STA zObjectXLo + 1
	JMP locret_BANKC_8A00

; ---------------------------------------------------------------------------

loc_BANKC_89CD:
	LDA zObjectXVelocity
	AND #1
	BNE loc_BANKC_89EB

	LDY #0
	LDX #0

loc_BANKC_89D7:
	INC zObjectXVelocity
	LDA byte_BANKC_8998, X
	STA iVirtualOAM + $41, Y
	INY
	INY
	INY
	INY
	INX
	CPX #$F
	BNE loc_BANKC_89D7

	JMP locret_BANKC_8A00

; ---------------------------------------------------------------------------

loc_BANKC_89EB:
	INC zObjectXVelocity
	LDX #0
	LDY #0

loc_BANKC_89F1:
	LDA byte_BANKC_89A7, X
	STA iVirtualOAM + $41, Y
	INY
	INY
	INY
	INY
	INX
	CPX #$F
	BNE loc_BANKC_89F1

locret_BANKC_8A00:
	RTS

; ---------------------------------------------------------------------------
CastRoll_PaletteFadeOut:
	.db $32

byte_BANKC_8A02:
	.db $22
	.db $12
; ---------------------------------------------------------------------------

loc_BANKC_8A04:
	DEC zPlayerXLo
	BPL locret_BANKC_8A36

	LDA #$10
	STA zPlayerXLo
	LDA #$3F
	STA iPPUBuffer
	LDA #$11
	STA iPPUBuffer + 1
	LDA #$01
	STA iPPUBuffer + 2
	LDY zObjectXLo + 1
	LDA CastRoll_PaletteFadeOut, Y
	STA iPPUBuffer + 3
	LDA #$00
	STA iPPUBuffer + 4
	INC zObjectXLo + 1
	LDA zObjectXLo + 1
	CMP #$03
	BNE locret_BANKC_8A36

	INC zMarioSleepingSceneIndex
	LDA #$16
	STA zPlayerXLo

locret_BANKC_8A36:
	RTS

; ---------------------------------------------------------------------------

loc_BANKC_8A37:
	DEC zPlayerXLo
	BPL locret_BANKC_8A51

	LDX #$16
	LDY #0
	LDA #$F8

loc_BANKC_8A41:
	STA iVirtualOAM + $40, Y
	INY
	INY
	INY
	INY
	DEX
	BPL loc_BANKC_8A41

	LDA #$30
	STA zPlayerXLo

loc_BANKC_8A4F:
	INC zMarioSleepingSceneIndex

locret_BANKC_8A51:
	RTS

; ---------------------------------------------------------------------------

InitEndingCursive:
	DEC zPlayerXLo
	BPL InitEndingCursive_Quit

	LDA #$00
	STA zCursiveDataOffset
	STA zENDTimer
	STA zCursiveDataBlock

	LDA #$05
	STA zCursiveFrameTimer

	LDA #NumFrames_THE - 1
	STA zCursiveFramesLeft

	LDA #$3F ; HI($3f11)
	STA iPPUBuffer
	LDA #$11 ; LO($3f11)
	STA iPPUBuffer + 1
	LDA #$01 ; Number of bytes
	STA iPPUBuffer + 2
	LDA #$30 ; White
	STA iPPUBuffer + 3
	LDA #$00 ; End
	STA iPPUBuffer + 4

	INC zMarioSleepingSceneIndex

InitEndingCursive_Quit:
	RTS

; ---------------------------------------------------------------------------

; Write "The End" in cursive
WriteEndingCursive:
	; did the timer reach $80
	LDA zENDTimer
	AND #$80
	BNE WriteEndingCursive_Quit1

	; no
	; are we on the second word?
	LDA zENDTimer
	BNE WriteEndingCursive_END

	; no
	; did we hit a new frame?
	DEC zCursiveFrameTimer
	BPL WriteEndingCursive_Quit1

	; cursive's frame rate = 12 hz
	LDA #5
	STA zCursiveFrameTimer
	; data block width = 8 / 2 - 1
	LDA #3
	STA zCursiveDataBlock
	; start reading
	LDX #0
	LDY zCursiveDataOffset

WriteEndingCursive_THE:
	; Y position
	LDA #$40
	STA iVirtualOAM, X
	INX
	; tile no.
	LDA THECursiveAnimationOAMData, Y
	STA iVirtualOAM, X
	INY
	INX
	; attribute
	LDA #0
	STA iVirtualOAM, X
	INX
	; X position
	LDA THECursiveAnimationOAMData, Y
	STA iVirtualOAM, X
	INY
	INX
	DEC zCursiveDataBlock
	BPL WriteEndingCursive_THE

	; stash Y for next frame
	STY zCursiveDataOffset
	; we've fininshed a frame!
	DEC zCursiveFramesLeft
	BPL WriteEndingCursive_Quit1

	; start the END timer
	INC zENDTimer
	; number of proceeding frames
	LDA #NumFrames_END - 1
	STA zCursiveFramesLeft
	; reset the data offset
	LDA #0
	STA zCursiveDataOffset

WriteEndingCursive_Quit1:
	; Voila!  Execution done!
	RTS

; ---------------------------------------------------------------------------

WriteEndingCursive_END:
	; did we hit a new frame?
	DEC zCursiveFrameTimer
	BPL WriteEndingCursive_Quit2

	; 60 fps / 5 = 12 fps
	LDA #5
	STA zCursiveFrameTimer
	; data block width = 8 / 2 - 1
	LDA #3
	STA zCursiveDataBlock
	; start reading
	LDX #0
	LDY zCursiveDataOffset

WriteEndingCursive_Loop:
	; Y position
	LDA #$40
	STA iVirtualOAM + $10, X
	INX
	; tile no.
	LDA ENDCursiveAnimationOAMData, Y
	STA iVirtualOAM + $10, X
	INY
	INX
	; attribute
	LDA #0
	STA iVirtualOAM + $10, X
	INX
	; X position
	LDA ENDCursiveAnimationOAMData, Y
	STA iVirtualOAM + $10, X
	INY
	INX
	DEC zCursiveDataBlock
	BPL WriteEndingCursive_Loop

	; stash Y for next frame
	STY zCursiveDataOffset
	; we finished a frame!
	DEC zCursiveFramesLeft
	BPL WriteEndingCursive_Quit2

	; animation is done
	; max out the END timer
	LDA #$FF
	STA zENDTimer

	INC zMarioSleepingSceneIndex

WriteEndingCursive_Quit2:
	RTS


DoPostCastPrompt:
	LDA zENDTimer
	BPL DoPostCastPrompt_WaitForStart
	LDY #PostCreditsMenuSprites - EndingPromptOAMData - 1
DoPostCastPrompt_PromptSpriteData:
	LDA EndingPromptOAMData, Y
	STA iVirtualOAM + $20, Y
	DEY
	BPL DoPostCastPrompt_PromptSpriteData
	LDA #DPCM_EndingPrompt
	STA iDPCMSFX
	INC zENDTimer
	LDA #1
	STA iStack + 1
	RTS

DoPostCastPrompt_WaitForStart:
	LDA zInputBottleneck
	AND #ControllerInput_Start
	BNE DoPostCastPrompt_Pressed
	RTS

DoPostCastPrompt_Pressed:
	LDA #DPCM_Pause
	STA iDPCMSFX
	INC zMarioSleepingSceneIndex
	RTS

PostCastMenu_Up:
	LDA #1
	STA iStack + 1
	LDA #SoundEffect2_CoinGet
	STA iPulse1SFX
	BNE PostCastMenu_UpdatePPUBuffer

PostCastMenu_Down:
	LDA #0
	STA iStack + 1
	LDA PostCastPaletteSwap1, Y
	STA iPPUBuffer, X
	DEX
	DEY
	BPL PostCastMenu_Down
	LDA #SoundEffect2_CoinGet
	STA iPulse1SFX
	RTS

PostCastMenu_AStart:
	LDA #DPCM_Save
	STA iDPCMSFX
	LDA iStack + 1
	BEQ PostCastMenu_ThenStop

	LDA #Stack100_Save
	STA iStack

PostCastMenu_ThenStop:
	BPL PostCastMenu_StopOperationAndReset

PostCastMenu:
	LDX #PostCastPaletteSwap2 - PostCastPaletteSwap1
	LDY #PostCastPaletteSwapEnd - PostCastPaletteSwap1
	LDA zENDTimer
	BPL PostCastMenu_Update

	LDA zInputBottleneck
	AND #ControllerInput_Up
	BNE PostCastMenu_Up

	LDA zInputBottleneck
	AND #ControllerInput_Down
	BNE PostCastMenu_Down

	LDA zInputBottleneck
	AND #ControllerInput_A + ControllerInput_Start
	BNE PostCastMenu_AStart
	RTS

PostCastMenu_Update:
	JSR PostCastMenu_UpdatePPUBuffer
	LDX #PostCastPaletteSwap1 - PostCreditsMenuSprites

PostCastMenu_UpdateOAM:
	LDA PostCreditsMenuSprites, X
	STA iVirtualOAM + $20, X
	DEX
	BPL PostCastMenu_UpdateOAM
	DEC zENDTimer
	RTS

PostCastMenu_UpdatePPUBuffer:
	LDA PostCastPaletteSwap1, X
	STA iPPUBuffer, X
	DEX
	BPL PostCastMenu_UpdatePPUBuffer
	RTS

PostCastMenu_StopOperationAndReset:
	LDA #1
	JSR DelayFrames
	LDA iCurrentDPCMSFX
	BNE PostCastMenu_StopOperationAndReset
	JSR ClearNametablesAndSprites
	TAX
PostCastMenu_ClearStack:
	STA iStack, X
	DEX
	BNE PostCastMenu_ClearStack
	JMP RESET

; ---------------------------------------------------------------------------
CastRoll_SpritePointersHi:
	.db >CastRoll_Mario
	.db >CastRoll_Luigi
	.db >CastRoll_Princess
	.db >CastRoll_Toad
	.db >CastRoll_Shyguy
	.db >CastRoll_Snifit
	.db >CastRoll_Ninji
	.db >CastRoll_Beezo
	.db >CastRoll_Porcupo
	.db >CastRoll_Tweeter
	.db >CastRoll_BobOmb
	.db >CastRoll_Hoopstar
	.db >CastRoll_Trouter
	.db >CastRoll_Pidgit
	.db >CastRoll_Panser
	.db >CastRoll_Flurry
	.db >CastRoll_Albatoss
	.db >CastRoll_Phanto
	.db >CastRoll_Spark
	.db >CastRoll_Subcon
	.db >CastRoll_Pokey
	.db >CastRoll_Birdo
	.db >CastRoll_Ostro
	.db >CastRoll_Autobomb
	.db >CastRoll_Cobrat
	.db >CastRoll_Mouser
	.db >CastRoll_Fryguy
	.db >CastRoll_Clawglip
	.db >CastRoll_Triclyde
CastRoll_SpritePointersLo:
	.db <CastRoll_Mario
	.db <CastRoll_Luigi
	.db <CastRoll_Princess
	.db <CastRoll_Toad
	.db <CastRoll_Shyguy
	.db <CastRoll_Snifit
	.db <CastRoll_Ninji
	.db <CastRoll_Beezo
	.db <CastRoll_Porcupo
	.db <CastRoll_Tweeter
	.db <CastRoll_BobOmb
	.db <CastRoll_Hoopstar
	.db <CastRoll_Trouter
	.db <CastRoll_Pidgit
	.db <CastRoll_Panser
	.db <CastRoll_Flurry
	.db <CastRoll_Albatoss
	.db <CastRoll_Phanto
	.db <CastRoll_Spark
	.db <CastRoll_Subcon
	.db <CastRoll_Pokey
	.db <CastRoll_Birdo
	.db <CastRoll_Ostro
	.db <CastRoll_Autobomb
	.db <CastRoll_Cobrat
	.db <CastRoll_Mouser
	.db <CastRoll_Fryguy
	.db <CastRoll_Clawglip
	.db <CastRoll_Triclyde
CastRoll_Mario:
	.db $D0, $3E, $00, $30
	.db $D0, $00, $00, $38 ; 4
	.db $D0, $02, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $04, $00, $38 ; $14
	.db $F9, $06, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $24 ; $20
	.db $F9, $E8, $00, $2C ; $24
	.db $F9, $D0, $00, $34 ; $28
	.db $F9, $F2, $00, $3C ; $2C
	.db $F9, $E0, $00, $44 ; $30
	.db $F9, $EC, $00, $4C ; $34
	.db $F9, $3E, $00, $54 ; $38
	.db $F9, $3E, $00, $5C ; $3C
CastRoll_Luigi:
	.db $D0, $3E, $00, $30
	.db $D0, $08, $00, $38 ; 4
	.db $D0, $0A, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $0C, $00, $38 ; $14
	.db $F9, $0E, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $24 ; $20
	.db $F9, $E6, $00, $2C ; $24
	.db $F9, $F8, $00, $34 ; $28
	.db $F9, $E0, $00, $3C ; $2C
	.db $F9, $DC, $00, $44 ; $30
	.db $F9, $E0, $00, $4C ; $34
	.db $F9, $3E, $00, $54 ; $38
	.db $F9, $3E, $00, $5C ; $3C
CastRoll_Princess:
	.db $D0, $3E, $00, $30
	.db $D0, $10, $00, $38 ; 4
	.db $D0, $12, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $14, $00, $38 ; $14
	.db $F9, $16, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $EE, $00, $20 ; $20
	.db $F9, $F2, $00, $28 ; $24
	.db $F9, $E0, $00, $30 ; $28
	.db $F9, $EA, $00, $38 ; $2C
	.db $F9, $D4, $00, $40 ; $30
	.db $F9, $D8, $00, $48 ; $34
	.db $F9, $F4, $00, $50 ; $38
	.db $F9, $F4, $00, $58 ; $3C
CastRoll_Toad:
	.db $D0, $3E, $00, $30 ; $00
	.db $D0, $18, $00, $38 ; $04
	.db $D0, $1A, $00, $40 ; $08
	.db $D0, $3E, $00, $48 ; $0C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $1C, $00, $38 ; $14
	.db $F9, $1E, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $20 ; $20
	.db $F9, $3E, $00, $28 ; $24
	.db $F9, $F6, $00, $30 ; $28
	.db $F9, $EC, $00, $38 ; $2C
	.db $F9, $D0, $00, $40 ; $30
	.db $F9, $D6, $00, $48 ; $34
	.db $F9, $3E, $00, $50 ; $38
	.db $F9, $3E, $00, $58 ; $3C
CastRoll_Shyguy:
	.db $D0, $3E, 0, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $20, $00, $38 ; $14
	.db $F9, $22, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $20 ; $20
	.db $F9, $F4, $00, $28 ; $24
	.db $F9, $DE, $00, $30 ; $28
	.db $F9, $CC, $00, $38 ; $2C
	.db $F9, $DC, $00, $40 ; $30
	.db $F9, $F8, $00, $48 ; $34
	.db $F9, $CC, $00, $50 ; $38
	.db $F9, $3E, $00, $58 ; $3C
CastRoll_Snifit:
	.db $D0, $3E, 0, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $24, $00, $38 ; $14
	.db $F9, $26, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $20 ; $20
	.db $F9, $F4, $00, $28 ; $24
	.db $F9, $EA, $00, $30 ; $28
	.db $F9, $E0, $00, $38 ; $2C
	.db $F9, $DA, $00, $40 ; $30
	.db $F9, $E0, $00, $48 ; $34
	.db $F9, $F6, $00, $50 ; $38
	.db $F9, $3E, $00, $58 ; $3C
CastRoll_Ninji:
	.db $D0, $3E, $00, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $28, $00, $38 ; $14
	.db $F9, $2A, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $24 ; $20
	.db $F9, $EA, $00, $2C ; $24
	.db $F9, $E0, $00, $34 ; $28
	.db $F9, $EA, $00, $3C ; $2C
	.db $F9, $E2, $00, $44 ; $30
	.db $F9, $E0, $00, $4C ; $34
	.db $F9, $3E, $00, $54 ; $38
	.db $F9, $3E, $00, $5C ; $3C
CastRoll_Beezo:
	.db $D0, $3E, $00, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $2C, $00, $38 ; $14
	.db $F9, $2E, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $24 ; $20
	.db $F9, $D2, $00, $2C ; $24
	.db $F9, $D8, $00, $34 ; $28
	.db $F9, $D8, $00, $3C ; $2C
	.db $F9, $CE, $00, $44 ; $30
	.db $F9, $EC, $00, $4C ; $34
	.db $F9, $3E, $00, $54 ; $38
	.db $F9, $3E, $00, $5C ; $3C
CastRoll_Porcupo:
	.db $D0, $3E, $00, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $30, $00, $38 ; $14
	.db $F9, $32, $00, $40 ; $18
	.db $F9 ; $1C
byte_BANKC_8D5F:
	.db $3E, $00, $48, $F9
	.db $EE, $00, $24, $F9 ; 4
	.db $EC, $00, $2C, $F9 ; 8
	.db $F2, $00, $34, $F9 ; $C
	.db $D4, $00, $3C, $F9 ; $10
	.db $F8, $00, $44, $F9 ; $14
	.db $EE, $00, $4C, $F9 ; $18
	.db $EC, $00, $54, $F9 ; $1C
	.db $3E, $00, $5C ; $20
CastRoll_Tweeter:
	.db $D0, $3E, $00, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $34, $00, $38 ; $14
	.db $F9, $36, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $F6, $00, $24 ; $20
	.db $F9, $FC, $00, $2C ; $24
	.db $F9, $D8, $00, $34 ; $28
	.db $F9, $D8, $00, $3C ; $2C
	.db $F9, $F6, $00, $44 ; $30
	.db $F9, $D8, $00, $4C ; $34
	.db $F9, $F2, $00, $54 ; $38
	.db $F9, $3E, $00, $5C ; $3C
CastRoll_BobOmb:
	.db $D0, $3E, 0, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $38, $00, $38 ; $14
	.db $F9, $3A, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $D2, $00, $24 ; $20
	.db $F9, $EC, $00, $2C ; $24
	.db $F9, $D2, $00, $34 ; $28
	.db $F9, $3E, $00, $3C ; $2C
	.db $F9, $EC, $00, $44 ; $30
	.db $F9, $E8, $00, $4C ; $34
	.db $F9, $D2, $00, $54 ; $38
	.db $F9, $3E, $00, $5C ; $3C
CastRoll_Hoopstar:
	.db $D0, $3E, $00, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $3C, $00, $38 ; $14
	.db $F9, $3C, $40, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $DE, $00, $20 ; $20
	.db $F9, $EC, $00, $28 ; $24
	.db $F9, $EC, $00, $30 ; $28
	.db $F9, $EE, $00, $38 ; $2C
	.db $F9, $F4, $00, $40 ; $30
	.db $F9, $F6, $00, $48 ; $34
	.db $F9, $D0, $00, $50 ; $38
	.db $F9, $F2, $00, $58 ; $3C
CastRoll_Trouter:
	.db $D0, $3E, $00, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $40, $00, $38 ; $14
	.db $F9, $42, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $F6, $00, $24 ; $20
	.db $F9, $F2, $00, $2C ; $24
	.db $F9, $EC, $00, $34 ; $28
	.db $F9, $F8, $00, $3C ; $2C
	.db $F9, $F6, $00, $44 ; $30
	.db $F9, $D8, $00, $4C ; $34
	.db $F9, $F2, $00, $54 ; $38
	.db $F9, $3E, $00, $5C ; $3C
CastRoll_Pidgit:
	.db $D0, $3E, 0, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $44, $00, $38 ; $14
	.db $F9, $46, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $20 ; $20
	.db $F9, $EE, $00, $28 ; $24
	.db $F9, $E0, $00, $30 ; $28
	.db $F9, $D6, $00, $38 ; $2C
	.db $F9, $DC, $00, $40 ; $30
	.db $F9, $E0, $00, $48 ; $34
	.db $F9, $F6, $00, $50 ; $38
	.db $F9, $3E, $00, $58 ; $3C
CastRoll_Panser:
	.db $D0, $3E, 0, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $48, $00, $38 ; $14
	.db $F9, $4A, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $20 ; $20
	.db $F9, $EE, $00, $28 ; $24
	.db $F9, $D0, $00, $30 ; $28
	.db $F9, $EA, $00, $38 ; $2C
	.db $F9, $F4, $00, $40 ; $30
	.db $F9, $D8, $00, $48 ; $34
	.db $F9, $F2, $00, $50 ; $38
	.db $F9, $3E, $00, $58 ; $3C
CastRoll_Flurry:
	.db $D0, $3E, 0, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $4C, $00, $38 ; $14
	.db $F9, $4E, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $20 ; $20
	.db $F9, $DA, $00, $28 ; $24
	.db $F9, $E6, $00, $30 ; $28
	.db $F9, $F8, $00, $38 ; $2C
	.db $F9, $F2, $00, $40 ; $30
	.db $F9, $F2, $00, $48 ; $34
	.db $F9, $CC, $00, $50 ; $38
	.db $F9, $3E, $00, $58 ; $3C
CastRoll_Albatoss:
	.db $D0, $3E, $00, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $50, $00, $30 ; $10
	.db $F9, $52, $00, $38 ; $14
	.db $F9, $54, $00, $40 ; $18
	.db $F9, $56, $00, $48 ; $1C
	.db $F9, $D0, $00, $20 ; $20
	.db $F9, $E6, $00, $28 ; $24
	.db $F9, $D2, $00, $30 ; $28
	.db $F9, $D0, $00, $38 ; $2C
	.db $F9, $F6, $00, $40 ; $30
	.db $F9, $EC, $00, $48 ; $34
	.db $F9, $F4, $00, $50 ; $38
	.db $F9, $F4, $00, $58 ; $3C
CastRoll_Phanto:
	.db $D0, $3E, 0, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $68, $00, $38 ; $14
	.db $F9, $68, $40, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $20 ; $20
	.db $F9, $EE, $00, $28 ; $24
	.db $F9, $DE, $00, $30 ; $28
	.db $F9, $D0, $00, $38 ; $2C
	.db $F9, $EA, $00, $40 ; $30
	.db $F9, $F6, $00, $48 ; $34
	.db $F9, $EC, $00, $50 ; $38
	.db $F9, $3E, $00, $58 ; $3C
CastRoll_Spark:
	.db $D0, $3E, $00, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $6A, $00, $38 ; $14
	.db $F9, $6A, $40, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $24 ; $20
	.db $F9, $F4, $00, $2C ; $24
	.db $F9, $EE, $00, $34 ; $28
	.db $F9, $D0, $00, $3C ; $2C
	.db $F9, $F2, $00, $44 ; $30
	.db $F9, $E4, $00, $4C ; $34
	.db $F9, $3E, $00, $54 ; $38
	.db $F9, $3E, $00, $5C ; $3C
CastRoll_Subcon:
	.db $D0, $3E, 0, $30
	.db $D0, $3E, $00, $38 ; 4
	.db $D0, $3E, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $6C, $00, $38 ; $14
	.db $F9, $6E, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $24 ; $20
	.db $F9, $F4, $00, $2C ; $24
	.db $F9, $F8, $00, $34 ; $28
	.db $F9, $D2, $00, $3C ; $2C
	.db $F9, $D4, $00, $44 ; $30
	.db $F9, $EC, $00, $4C ; $34
	.db $F9, $EA, $00, $54 ; $38
	.db $F9, $3E, $00, $5C ; $3C
CastRoll_Pokey:
	.db $D0, $3E, $00, $30
	.db $D0, $60, $00, $38 ; 4
	.db $D0, $62, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $64, $00, $38 ; $14
	.db $F9, $66, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $24 ; $20
	.db $F9, $EE, $00, $2C ; $24
	.db $F9, $EC, $00, $34 ; $28
	.db $F9, $E4, $00, $3C ; $2C
	.db $F9, $D8, $00, $44 ; $30
	.db $F9, $CC, $00, $4C ; $34
	.db $F9, $3E, $00, $54 ; $38
	.db $F9, $3E, $00, $5C ; $3C
CastRoll_Birdo:
	.db $D0, $3E, $00, $30
	.db $D0, $70, $00, $38 ; 4
	.db $D0, $72, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $74, $00, $38 ; $14
	.db $F9, $76, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $24 ; $20
	.db $F9, $D2, $00, $2C ; $24
	.db $F9, $E0, $00, $34 ; $28
	.db $F9, $F2, $00, $3C ; $2C
	.db $F9, $D6, $00, $44 ; $30
	.db $F9, $EC, $00, $4C ; $34
	.db $F9, $3E, $00, $54 ; $38
	.db $F9, $3E, $00, $5C ; $3C
CastRoll_Ostro:
	.db $D0, $3E, $00, $30
	.db $D0, $78, $00, $38 ; 4
	.db $D0, $7A, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $7C, $00, $38 ; $14
	.db $F9, $7E, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $24 ; $20
	.db $F9, $EC, $00, $2C ; $24
	.db $F9, $F4, $00, $34 ; $28
	.db $F9, $F6, $00, $3C ; $2C
	.db $F9, $F2, $00, $44 ; $30
	.db $F9, $EC, $00, $4C ; $34
	.db $F9, $3E, $00, $54 ; $38
	.db $F9, $3E, $00, $5C ; $3C
CastRoll_Autobomb:
	.db $D0, $3E, $00, $30
	.db $D0, $80, $00, $38 ; 4
	.db $D0, $82, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $84, $00, $38 ; $14
	.db $F9, $86, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $D0, $00, $20 ; $20
	.db $F9, $F8, $00, $28 ; $24
	.db $F9, $F6, $00, $30 ; $28
	.db $F9, $EC, $00, $38 ; $2C
	.db $F9, $D2, $00, $40 ; $30
	.db $F9, $EC, $00, $48 ; $34
	.db $F9, $E8, $00, $50 ; $38
	.db $F9, $D2, $00, $58 ; $3C
CastRoll_Cobrat:
	.db $D0, $3E, $00, $30
	.db $D0, $58, $00, $38 ; 4
	.db $D0, $5A, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $3E, $00, $30 ; $10
	.db $F9, $5C, $00, $38 ; $14
	.db $F9, $5E, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $20 ; $20
	.db $F9, $D4, $00, $28 ; $24
	.db $F9, $EC, $00, $30 ; $28
	.db $F9, $D2, $00, $38 ; $2C
	.db $F9, $F2, $00, $40 ; $30
	.db $F9, $D0, $00, $48 ; $34
	.db $F9, $F6, $00, $50 ; $38
	.db $F9, $3E, $00, $58 ; $3C
CastRoll_Mouser:
	.db $D0, $88, 0, $30
	.db $D0, $8A, $00, $38 ; 4
	.db $D0, $8C, $00, $40 ; 8
	.db $D0, $3E, $00, $48 ; $C
	.db $F9, $8E, $00, $30 ; $10
	.db $F9, $90, $00, $38 ; $14
	.db $F9, $92, $00, $40 ; $18
	.db $F9, $3E, $00, $48 ; $1C
	.db $F9, $3E, $00, $1C ; $20
	.db $F9, $E8, $00, $24 ; $24
	.db $F9, $EC, $00, $2C ; $28
	.db $F9, $F8, $00, $34 ; $2C
	.db $F9, $F4, $00, $3C ; $30
	.db $F9, $D8, $00, $44 ; $34
	.db $F9, $F2, $00, $4C ; $38
	.db $F9, $3E, $00, $54 ; $3C
CastRoll_Fryguy:
	.db $D0, $AA, 0, $30
	.db $D0, $AC, $00, $38 ; 4
	.db $D0, $AE, $00, $40 ; 8
	.db $D0, $B0, $00, $48 ; $C
	.db $F9, $B2, $00, $30 ; $10
	.db $F9, $B4, $00, $38 ; $14
	.db $F9, $B6, $00, $40 ; $18
	.db $F9, $B8, $00, $48 ; $1C
	.db $F9, $3E, $00, $20 ; $20
	.db $F9, $DA, $00, $28 ; $24
	.db $F9, $F2, $00, $30 ; $28
	.db $F9, $CC, $00, $38 ; $2C
	.db $F9, $DC, $00, $40 ; $30
	.db $F9, $F8, $00, $48 ; $34
	.db $F9, $CC, $00, $50 ; $38
	.db $F9, $3E, $00, $58 ; $3C
CastRoll_Clawglip:
	.db $D0, $BA, $00, $30
	.db $D0, $BC, $00, $38 ; 4
	.db $D0, $BE, $00, $40 ; 8
	.db $D0, $C0, $00, $48 ; $C
	.db $F9, $C2, $00, $30 ; $10
	.db $F9, $C4, $00, $38 ; $14
	.db $F9, $C6, $00, $40 ; $18
	.db $F9, $C8, $00, $48 ; $1C
	.db $F9, $D4, $00, $20 ; $20
	.db $F9, $E6, $00, $28 ; $24
	.db $F9, $D0, $00, $30 ; $28
	.db $F9, $FC, $00, $38 ; $2C
	.db $F9, $DC, $00, $40 ; $30
	.db $F9, $E6, $00, $48 ; $34
	.db $F9, $E0, $00, $50 ; $38
	.db $F9, $EE, $00, $58 ; $3C
CastRoll_Triclyde:
	.db $D0, $94, $00, $30
	.db $D0, $96, $00, $38 ; 4
	.db $D0, $98, $00, $40 ; 8
	.db $D0, $9A, $00, $48 ; $C
	.db $F9, $9C, $00, $30 ; $10
	.db $F9, $9E, $00, $38 ; $14
	.db $F9, $A0, $00, $40 ; $18
	.db $F9, $A2, $00, $48 ; $1C
	.db $F9, $3E, $00, $30 ; $20
	.db $F9, $A4, $00, $38 ; $24
	.db $F9, $A6, $00, $40 ; $28
	.db $F9, $A8, $00, $48 ; $2C
	.db $F9, $3E, $00, $50 ; $30
	.db $F9, $3E, $00, $58 ; $34
	.db $F9, $3E, $00, $60 ; $38
	.db $F9, $3E, $00, $68 ; $3C
CastRoll_TriclydeText:
	.db $D0, $F6, $00, $20
	.db $D0, $F2, $00, $28 ; 4
	.db $D0, $E0, $00, $30 ; 8
	.db $D0, $D4, $00, $38 ; $C
	.db $D0, $E6, $00, $40 ; $10
	.db $D0, $CC, $00, $48 ; $14
	.db $D0, $D6, $00, $50 ; $18
	.db $D0, $D8, $00, $58 ; $1C
CastRoll_Wart:
	.db $D0, $80, $00, $28
	.db $D0, $82, $00, $30 ; 4
	.db $D0, $84, $00, $38 ; 8
	.db $D0, $86, $00, $40 ; $C
	.db $D0, $88, $00, $48 ; $10
	.db $F9, $8A, $00, $28 ; $14
	.db $F9, $8C, $00, $30 ; $18
	.db $F9, $8E, $00, $38 ; $1C
	.db $F9, $90, $00, $40 ; $20
	.db $F9, $92, $00, $48 ; $24
	.db $F9, $94, $00, $28 ; $28
	.db $F9, $96, $00, $30 ; $2C
	.db $F9, $98, $00, $38 ; $30
	.db $F9, $9A, $00, $40 ; $34
	.db $F9, $9C, $00, $48 ; $38
	.db $F9, $C0, $00, $20 ; $3C
	.db $F9, $C0, $00, $20 ; $40
	.db $F9, $FC, $00, $2C ; $44
	.db $F9, $D0, $00, $34 ; $48
	.db $F9, $F2, $00, $3C ; $4C
	.db $F9, $F6, $00, $44 ; $50
	.db $F9, $C0, $00, $50 ; $54
	.db $F9, $C0, $00, $58 ; $58
;
; "The End" OAM Data
;
; Each frame is split into 8 bytes, four slots each frame
; Byte 0: Tile number
; Byte 1: X Coordinate (144-200)
THECursiveAnimationOAMData:
	.db $10, $90 ; 0
	.db $7C, $98
	.db $7C, $A0
	.db $7C, $A8

	.db $12, $90 ; 1
	.db $7C, $98
	.db $7C, $A0
	.db $7C, $A8

	.db $14, $90 ; 2
	.db $7C, $98
	.db $7C, $A0
	.db $7C, $A8

	.db $16, $90 ; 3
	.db $7C, $98
	.db $7C, $A0
	.db $7C, $A8

	.db $16, $90 ; 4
	.db $18, $98
	.db $7C, $A0
	.db $7C, $A8

	.db $16, $90 ; 5
	.db $1A, $98
	.db $7C, $A0
	.db $7C, $A8

	.db $16, $90 ; 6
	.db $1C, $98
	.db $7C, $A0
	.db $7C, $A8

	.db $16, $90 ; 7
	.db $1E, $98
	.db $7C, $A0
	.db $7C, $A8

	.db $20, $90 ; 8
	.db $1E, $98
	.db $7C, $A0
	.db $7C, $A8

	.db $24, $90 ; 9
	.db $1E, $98
	.db $7C, $A0
	.db $7C, $A8

	.db $24, $90 ; 10
	.db $28, $98
	.db $7C, $A0
	.db $7C, $A8

	.db $24, $90 ; 11
	.db $2A, $98
	.db $7C, $A0
	.db $7C, $A8

	.db $24, $90 ; 12
	.db $2A, $98
	.db $2C, $A0
	.db $7C, $A8

	.db $24, $90 ; 13
	.db $2A, $98
	.db $2E, $A0
	.db $7C, $A8

	.db $24, $90 ; 14
	.db $30, $98
	.db $32, $A0
	.db $7C, $A8

	.db $24, $90 ; 15
	.db $30, $98
	.db $34, $A0
	.db $7C, $A8

	.db $24, $90 ; 16
	.db $30, $98
	.db $36, $A0
	.db $7C, $A8

	.db $24, $90 ; 17
	.db $30, $98
	.db $36, $A0
	.db $38, $A8

	.db $24, $90 ; 18
	.db $30, $98
	.db $3A, $A0
	.db $3C, $A8

	.db $24, $90 ; 19
	.db $30, $98
	.db $3E, $A0
	.db $40, $A8

	.db $24, $90 ; 20
	.db $30, $98
	.db $3E, $A0
	.db $42, $A8
ENDCursiveAnimationOAMData:
	.db $44, $B0 ; 0
	.db $46, $B8
	.db $7C, $C0
	.db $7C, $C8

	.db $48, $B0 ; 1
	.db $4A, $B8
	.db $7C, $C0
	.db $7C, $C8

	.db $4C, $B0 ; 2
	.db $4E, $B8
	.db $7C, $C0
	.db $7C, $C8

	.db $50, $B0 ; 3
	.db $52, $B8
	.db $7C, $C0
	.db $7C, $C8

	.db $54, $B0 ; 4
	.db $56, $B8
	.db $7C, $C0
	.db $7C, $C8

	.db $58, $B0 ; 5
	.db $5A, $B8
	.db $7C, $C0
	.db $7C, $C8

	.db $5C, $B0 ; 6
	.db $5E, $B8
	.db $7C, $C0
	.db $7C, $C8

	.db $5C, $B0 ; 7
	.db $60, $B8
	.db $7C, $C0
	.db $7C, $C8

	.db $5C, $B0 ; 8
	.db $62, $B8
	.db $7C, $C0
	.db $7C, $C8

	.db $5C, $B0 ; 9
	.db $64, $B8
	.db $66, $C0
	.db $7C, $C8

	.db $5C, $B0 ; 10
	.db $64, $B8
	.db $68, $C0
	.db $7C, $C8

	.db $5C, $B0 ; 11
	.db $64, $B8
	.db $6A, $C0
	.db $7C, $C8

	.db $5C, $B0 ; 12
	.db $64, $B8
	.db $6C, $C0
	.db $6E, $C8

	.db $5C, $B0 ; 13
	.db $64, $B8
	.db $6C, $C0
	.db $70, $C8

	.db $5C, $B0 ; 14
	.db $64, $B8
	.db $6C, $C0
	.db $72, $C8

	.db $5C, $B0 ; 15
	.db $64, $B8
	.db $6C, $C0
	.db $74, $C8

	.db $5C, $B0 ; 16
	.db $64, $B8
	.db $6C, $C0
	.db $76, $C8

	.db $5C, $B0 ; 17
	.db $64, $B8
	.db $6C, $C0
	.db $78, $C8

	.db $5C, $B0 ; 18
	.db $64, $B8
	.db $6C, $C0
	.db $7A, $C8

	; Unreferenced
	RTS

EndingPromptOAMData:
;           Y,   tile, attr., X
	.db $CF, $EE,  $00,   $58 ; P
	.db $CF, $F8,  $00,   $60 ; U
	.db $CF, $F4,  $00,   $68 ; S
	.db $CF, $DE,  $00,   $70 ; H

	.db $DF, $F4,  $00,   $80 ; S
	.db $DF, $F6,  $00,   $88 ; T
	.db $DF, $D0,  $00,   $90 ; A
	.db $DF, $F2,  $00,   $98 ; R
	.db $DF, $F6,  $00,   $A0 ; T

PostCreditsMenuSprites:
;           Y,   tile, attr., X
	.db $CF, $F4,  $01,   $70 ; S
	.db $CF, $D0,  $01,   $78 ; A
	.db $CF, $FA,  $01,   $80 ; V
	.db $CF, $D8,  $01,   $88 ; E


	.db $DF, $E2,  $02,   $5E ; J
	.db $DF, $F8,  $02,   $66 ; U
	.db $DF, $F4,  $02,   $6E ; S
	.db $DF, $F6,  $02,   $76 ; T

	.db $DF, $F0,  $02,   $82 ; Q
	.db $DF, $F8,  $02,   $8A ; U
	.db $DF, $E0,  $02,   $92 ; I
	.db $DF, $F6,  $02,   $9A ; T

PostCastPaletteSwap1:
	.db $3f, $15, $01, $28
	.db $3f, $19, $01, $30, $00
PostCastPaletteSwap2:
	.db $3f, $15, $01, $30
	.db $3f, $19, $01, $28, $00
PostCastPaletteSwapEnd:
