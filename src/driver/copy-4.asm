;
; Copies the raw level data to memory.
;
CopyLevelDataToMemory:
	; Determine the global area index from the current level and area.
	LDY iCurrentLvl
	LDA LevelAreaStartIndexes, Y
	CLC
	ADC iCurrentLvlArea
	TAY

	; Calculate the pointer for the start of the level data.
	LDA LevelDataPointersLo, Y
	STA z05
	LDA LevelDataPointersHi, Y
	STA z06

	; Blindly copy 255 bytes of data, which is presumed to contain the full area.
	LDX #$FF

	; Set the destination address in RAM for copying level data.
	LDA #>wRawLevelData
	STA z02
	LDY #<wRawLevelData
	STY z01

	; `Y = $00`
CopyLevelDataToMemory_Loop:
	LDA (z05), Y
	STA (z01), Y
	INY
	DEX
	BNE CopyLevelDataToMemory_Loop

	; We end up copying the first byte twice!
	STA (z01), Y


;
; Copies the raw enemy data to memory.
;
CopyEnemyDataToMemory:
	; Determine the address of the level's enemy pointer tables.
	LDY iCurrentLvl
	LDA EnemyPointersByLevel_HiHi, Y
	STA z01
	LDA EnemyPointersByLevel_HiLo, Y
	STA z00
	LDA EnemyPointersByLevel_LoHi, Y
	STA z03
	LDA EnemyPointersByLevel_LoLo, Y
	STA z02

	; Determine whether we want the enemy data for the area or for the jar.
	LDA iSubAreaFlags
	CMP #$01
	BNE CopyEnemyDataToMemory_Area

CopyEnemyDataToMemory_Jar:
	LDY #AreaIndex_Jar
	JMP CopyEnemyDataToMemory_SetAddress

CopyEnemyDataToMemory_Area:
	LDY iCurrentLvlArea

CopyEnemyDataToMemory_SetAddress:
	; Calculate the pointer for the start of the enemy data.
	LDA (z00), Y
	STA z01
	LDA (z02), Y
	STA z00

	; Blindly copy 255 bytes of data, which is presumed to contain the full area.
	LDX #$FF

	; Set the destination address in RAM for copying level data.
	LDA #>wRawEnemyPointer
	STA z03
	LDY #<wRawEnemyPointer
	STY z02

	; `Y = $00`
CopyEnemyDataToMemory_Loop:
	LDA (z00), Y
	STA (z02), Y
	INY
	DEX
	BNE CopyEnemyDataToMemory_Loop
	RTS


;
; Copies the raw level data for a jar to memory.
;
CopyJarDataToMemory:
	; Determine the global area index from the current level and area.
	LDY iCurrentLvl
	LDA LevelAreaStartIndexes, Y
	CLC
	ADC #AreaIndex_Jar
	TAY

	; Calculate the pointer for the start of the level data.
	LDA LevelDataPointersLo, Y
	STA z05
	LDA LevelDataPointersHi, Y
	STA z06

	; Set the destination address in RAM for copying level data.
	LDA #>wRawJarData
	STA z02
	LDY #<wRawJarData
	STY z01

	; `Y = $00`
CopyJarDataToMemory_Loop:
	LDA (z05), Y
	; Unlike `CopyLevelDataToMemory`, which always copies 255 bytes, this stops on any `$FF` read!
	;
	; This isn't technically "correct", but in practice it's not the most devastating limitation.
	; Just don't expect to use a waterfall object that is exactly 16 tiles wide inside a jar.
	;
	; Fun fact: The largest possible waterfall objects are only used in two areas of World 5!
	CMP #$FF ; This one actually terminates on any $FF read! Welp.
	BEQ CopyJarDataToMemory_Exit

	STA (z01), Y
	INY
	JMP CopyJarDataToMemory_Loop

CopyJarDataToMemory_Exit:
	STA (z01), Y
	RTS
