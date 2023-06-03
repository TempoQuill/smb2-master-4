; inside CheckCollisionWithPlayer_NotInvincible
IFDEF JUMP_STOMPS
	LDA zObjectType, Y
	CMP #Enemy_ShyguyRed
	BMI CheckCollisionWithPlayer_NoStompEnemy
	CMP #Enemy_Ostro
	BPL CheckCollisionWithPlayer_NoStompEnemy

	LDA z0f
	AND #$0B
	BEQ CheckCollisionWithPlayer_StompEnemy
CheckCollisionWithPlayer_NoStompEnemy:
ENDIF

; new subroutine
IFDEF JUMP_STOMPS
CheckCollisionWithPlayer_StompEnemy:
	LDA zPlayerYVelocity
	BMI CheckCollisionWithPlayer_ExitStompEnemy

	LDA #EnemyState_Dead
	STA zEnemyState, Y

	LDA zEnemyCollision, Y
	ORA #CollisionFlags_Damage
	STA zEnemyCollision, Y

	; stash Y
	TYA
	PHA

	LDY #$02
	; INY

	LDA iMainJumpHeights, Y
	AND #$7F
	ASL A
	ORA #$80
	STA zPlayerYVelocity
	LDA iFloatLength
	STA iFloatTimer

	; restore Y
	PLA
	TAY

	LDA #DPCM_Impact
	STA iDPCMSFX2

CheckCollisionWithPlayer_ExitStompEnemy:
	RTS
ENDIF
