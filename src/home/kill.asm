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
	LDA #MUSIC_PLAYER_DOWN
	STA iMusicQueue
	LDA iStack
	CMP #Stack100_Pause
	BNE KillPlayer_Eject

	LDA #ControllerInput_Start
	STA zInputBottleneck

KillPlayer_Eject:
	RTS
