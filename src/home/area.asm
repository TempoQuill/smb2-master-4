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
