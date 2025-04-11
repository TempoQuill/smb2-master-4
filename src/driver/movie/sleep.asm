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


.include "src/data/ending/sleep/layout.asm"
.include "src/data/ending/sleep/animation.asm"

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
	LDA #SFX_POST_CAST_PROMPT
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
	LDA #SFX_PAUSE
	STA iDPCMSFX
	INC zMarioSleepingSceneIndex
	RTS

PostCastMenu_Up:
	LDA #1
	STA iStack + 1
	LDA #SFX_COIN
	STA iPulse2SFX
	BNE PostCastMenu_UpdatePPUBuffer

PostCastMenu_Down:
	LDA #0
	STA iStack + 1
	LDA PostCastPaletteSwap1, Y
	STA iPPUBuffer, X
	DEX
	DEY
	BPL PostCastMenu_Down
	LDA #SFX_COIN
	STA iPulse2SFX
	RTS

PostCastMenu_AStart:
	LDA #SFX_SAVE
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
