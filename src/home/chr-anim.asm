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
