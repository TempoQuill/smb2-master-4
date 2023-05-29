
DebugHook_Exit:
	JMP NMI_Exit

DoSoundProcessingAndCheckDebug:
	JSR DoSoundProcessing

	; Are you pressing select?
	LDA zInputBottleneck
	CMP #ControllerInput_Select
	BNE DebugHook_Exit

	; And you're not holding start?
	LDA zInputCurrentState
	AND #ControllerInput_Start
	BNE DebugHook_Exit

	JSR DebugHook_CheckEligibility
	BCS DebugHook_Exit

	; Hijack the NMI and show the debug menu
	LDA #>DebugHook_Hijack
	PHA
	LDA #<DebugHook_Hijack
	PHA
	PHP
	RTI


DebugHook_Hijack:
	; Stash the current bank
	LDA iCurrentROMBank
	PHA

	; Enable the debug menu flag
	LDA #$01
	STA Debug_InMenu

	; Stash a bunch of stuff
	JSR DebugHook_BackupScroll
	JSR DebugHook_BackupRAM

	; Swap to the debug/credits bank
	LDA #PRGBank_A_B
	JSR ChangeMappedPRGBank

	; And off we go
	JMP DebugMenu_Init


;
; Similar idea to JumpToTableAfterJump
;
DebugHook_ExitToAddressAfterJump:
	STA Debug_StashA
	STX Debug_StashX
	STY Debug_StashY
	PHP
	PLA
	STA Debug_StashP

	; Save the source address
	PLA
	STA z0a
	PLA
	STA z0b

	; Determine the jump address
	LDY #$01
	LDA (z0a), Y
	STA Debug_JumpAddressLo
	INY
	LDA (z0a), Y
	STA Debug_JumpAddressHi

DebugHook_ExitToJumpAddress:
	LDA #$00
	STA Debug_InMenu

	JSR DebugHook_RestoreRAM

	; Restore the previous bank
	PLA
	; JSR ChangeMappedPRGBank

	; Forget about all those registers and processor flags
	PLA
	TAY
	PLA
	TAX
	PLA
	PLP

	; Forget that RTI
	PLA
	PLA
	PLA

	; And forget whatever this address was
	PLA
	PLA

	; Restore the registers and processor flags
	LDA Debug_StashP
	PHP
	LDA Debug_StashA
	LDX Debug_StashX
	LDY Debug_StashY
	PLP

	; Jump to the destination
	JMP (Debug_JumpAddressLo)


;
; Check if the game conditions are good for entering the debug menu.
; If the menu can be accessed, carry will be clear.
;
DebugHook_CheckEligibility:
	; Not already in debug menu
	LDA Debug_InMenu
	BNE +f

	; Require current mode to be normal gameplay
	LDA iStack
	CMP #Stack100_Gameplay
	BNE +f

	; Disable while scrolling
	LDA zScrollArray
	AND #%00000100
	BNE +f

	; Disable the background is drawing
	LDA i537
	BEQ +f

	; Disable while in subspace/jar
	LDA iSubAreaFlags
	BNE +f

	; Disable while player is busy
	LDA zPlayerState
	CMP #PlayerState_ClimbingAreaTransition
	BCS +f

	CLC
	RTS

+f
	SEC
	RTS


;
; Stash the scroll information so that unpause can restore it later.
;
; Similar to StashScreenScrollPosition in Bank 0 except that it doesn't change
; the current PPU scroll position.
;
DebugHook_BackupScroll:
	LDA zPPUScrollY
	STA iPPUScrollY
	LDA zPPUScrollX
	STA iPPUScrollX
	LDA zYScrollPage
	STA iYScrollPage
	LDA zXScrollPage
	STA iXScrollPage
	LDA zScreenYPage
	STA iScreenYPage
	LDA zScreenY
	STA iScreenY
	LDA iBoundLeftUpper
	STA iBoundLeftUpper_Backup
	LDA ze1
	STA i517
	RTS


;
; The table below contains a bunch of RAM addresses to save/restore when
; entering and exiting the debug menu.
;
DebugPreserveAddresses:
	.dw iCurrentROMBank
	; .dw iCurrentMusic1
DebugPreserveAddresses_End:


DebugHook_BackupRAM:
	LDX #$00
-
	; Determine the RAM address
	TXA
	ASL
	TAY
	LDA DebugPreserveAddresses, Y
	STA z00
	LDA DebugPreserveAddresses + 1, Y
	STA z01
	; Stash the value
	LDY #$00
	LDA (z00), Y
	STA Debug_Stash, X
	; Next
	INX
	CPX #((DebugPreserveAddresses_End - DebugPreserveAddresses) / 2)
	BCC -
	RTS


DebugHook_RestoreRAM:
	LDX #$00
-
	; Determine the RAM address
	TXA
	ASL
	TAY
	LDA DebugPreserveAddresses, Y
	STA z00
	LDA DebugPreserveAddresses + 1, Y
	STA z01
	; Stash the value
	LDY #$00
	LDA Debug_Stash, X
	STA (z00), Y
	; Next
	INX
	CPX #((DebugPreserveAddresses_End - DebugPreserveAddresses) / 2)
	BCC -
	RTS

