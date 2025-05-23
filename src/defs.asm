.enum $0000
.ignorenl

MMC5_VMirror = %01000100
MMC5_HMirror = %01010000

VMirror = MMC5_VMirror
HMirror = MMC5_HMirror

CHR_A12_INVERSION = $80

; ---------------------------------------------------------------------------

; Each level has a maximum of 10 ($00~$09) areas.
; Extra ones are generally empty or pointers to the last 'real' area.
; "Common jars", if used in a level, occupy area $04.
; but if common jars aren't used, it can (and often is) a regular area.
AreaIndex_Start = $00
AreaIndex_Jar = $04

; enum PlayerStates (width 1 byte)
PlayerState_Normal = $00
PlayerState_Climbing = $01
PlayerState_Lifting = $02
PlayerState_ClimbingAreaTransition = $03
PlayerState_GoingDownJar = $04
PlayerState_ExitingJar = $05
PlayerState_HawkmouthEating = $06
PlayerState_Dying = $07
PlayerState_ChangingSize = $08

; enum TransitionTypes (width 1 byte)
TransitionType_Reset = $00
TransitionType_Door = $01
TransitionType_Jar = $02
TransitionType_Vine = $03
TransitionType_SubSpace = $04
TransitionType_Rocket = $05

; ---------------------------------------------------------------------------

; enum Characters
Character_Mario = $00
Character_Princess = $01
Character_Toad = $02
Character_Luigi = $03
.ende

; ---------------------------------------------------------------------------

.enum $0000

; enum APUOffset
APUOffset_Square1 = $00
APUOffset_Square2 = $04
APUOffset_Triangle = $08
APUOffset_Noise = $0C
.ende

RC_ = $0d5b
RC# = $0c9c
RD_ = $0be6
RD# = $0b3b
RE_ = $0a9a
RF_ = $0a01
RF# = $0972
RG_ = $08ea
RG# = $086a
RA_ = $07f1
RA# = $077f
RB_ = $0713

.enum $0001
; enum Music
MUSIC_OVERWORLD:	.dsb 1 ; 00
MUSIC_CHR_SELECT:	.dsb 1 ; 01
MUSIC_INSIDE:		.dsb 1 ; 02
MUSIC_BOSS:		.dsb 1 ; 03
MUSIC_STARMAN:		.dsb 1 ; 04
MUSIC_SUBSPACE:		.dsb 1 ; 05
MUSIC_WART:		.dsb 1 ; 06
MUSIC_TITLE_SCREEN:	.dsb 1 ; 07
MUSIC_BONUS_UNUSED:	.dsb 1 ; 08
MUSIC_BOSS_CLEAR:	.dsb 1 ; 09
MUSIC_ENDING:		.dsb 1 ; 0A
MUSIC_PLAYER_DOWN:	.dsb 1 ; 0B
MUSIC_GAME_OVER:	.dsb 1 ; 0C
MUSIC_CRYSTAL:		.dsb 1 ; 0D
MUSIC_WART_DEATH:	.dsb 1 ; 0E
MUSIC_SPADE_GAME:	.dsb 1 ; 0F
MUSIC_WARP:		.dsb 1 ; 10
MUSIC_BONUS_DPCM:              ; 11
NUM_MUSIC_TRACKS:
MUSIC_NONE = $FF
.ende

; pitches
.enum $0000
C_:	.dsb 2
C#:	.dsb 2
D_:	.dsb 2
D#:	.dsb 2
E_:	.dsb 2
F_:	.dsb 2
F#:	.dsb 2
G_:	.dsb 2
G#:	.dsb 2
A_:	.dsb 2
A#:	.dsb 2
B_:
.ende

; note lengths
.enum $0000
SIXTEENTH:		.dsb 2 ; 0
QUARTER_TRIPLET:	.dsb 2 ; 2
EIGHTH:			.dsb 1 ; 4
DOTTED_EIGHTH:		.dsb 1 ; 5
HALF_TRIPLET:		.dsb 1 ; 6
QRT_HF_TIE:		.dsb 1 ; 7
QUARTER:		.dsb 1 ; 8
DOTTED_QUARTER:		.dsb 1 ; 9
HALF:			.dsb 1 ; a
DOTTED_HALF:		.dsb 1 ; b
WHOLE:			.dsb 1 ; c
SIXTEENTH_TRIPLET:	.dsb 1 ; d
EIGHTH_TRIPLET:		.dsb 1 ; e
WHOLE_TRIPLET:                 ; f
.ende

; ---------------------------------------------------------------------------

.enum $0000
; enum ControllerInput (bitfield) (width 1 byte)
ControllerInput_Right = %00000001
ControllerInput_Left = %00000010
ControllerInput_Down = %00000100
ControllerInput_Up =  %00001000
ControllerInput_Start = %00010000
ControllerInput_Select = %00100000
ControllerInput_B = %01000000
ControllerInput_A = %10000000
.ende

; ---------------------------------------------------------------------------
; enum Hill (width 1 byte)
.enum $0001
SFX_JUMP:		.dsb 1 ; 00
SFX_VINE:		.dsb 1 ; 01
SFX_COLLECT:		.dsb 1 ; 02
SFX_WATCH:		.dsb 1 ; 03
SFX_FALL:		.dsb 1 ; 04
SFX_GROW:		.dsb 1 ; 05
SFX_DEFEAT_BOSS:	.dsb 1 ; 06
SFX_SELECT:		.dsb 1 ; 07
SFX_FLOWER_FIREBALL:	.dsb 1 ; 08
SFX_SPIN_JUMP:		.dsb 1 ; 09
SFX_SLOT:                      ; 0A
NUM_HILL_SFX:
NUM_HILL_IDS = NUM_HILL_SFX - 1
.ende

; ---------------------------------------------------------------------------

.enum $0001
; enum DPCM (width 1 byte)
SFX_EGG:		.dsb 1 ; 00
SFX_UPROOT:		.dsb 1 ; 01
	.dsb 1 ; 02
SFX_HELD_ITEM:		.dsb 1 ; 03
SFX_JUMP_CHARGE:	.dsb 1 ; 04
SFX_PLAYER_HIT:		.dsb 1 ; 05
	.dsb 1 ; 06
SFX_SHELL:		.dsb 1 ; 07
SFX_JAR_DOWN:		.dsb 1 ; 08
SFX_JAR_UP:		.dsb 1 ; 09
SFX_PHANTO:		.dsb 1 ; 0A
SFX_PANSER_FIREBALL:	.dsb 1 ; 0B
SFX_POST_CAST_PROMPT:	.dsb 1 ; 0C
SFX_SAVE:		.dsb 1 ; 0D
SFX_PAUSE:		.dsb 1 ; 0E
	.dsb 1 ; 0F
	.dsb 2
NUM_DPCM_SFX:
NUM_DPCM_IDS = NUM_DPCM_SFX - 1
.ende

; ---------------------------------------------------------------------------

.enum $0000
; enum PRGBank (width 1 byte)
IFNDEF NSF_FILE
PRGBank_0_1:
	.dsb 1
PRGBank_2_3:
	.dsb 1
ENDIF
PRGBank_4_5:
	.dsb 1
IFNDEF NSF_FILE
PRGBank_6_7:
	.dsb 1
PRGBank_8_9:
	.dsb 1
PRGBank_A_B:
	.dsb 1
PRGBank_C_D:
	.dsb 7
ENDIF
	.dsb 1

PRGBank_Music_1:
	.dsb 1
PRGBank_Music_2:
	.dsb 1
PRGBank_Music_3:
	.dsb 1
IFNDEF NSF_FILE
	.dsb 2
ENDIF
PRGBank_DMC_13:
	.dsb 1
PRGBank_DMC_14:
	.dsb 1
PRGBank_DMC_15:
	.dsb 1
PRGBank_DMC_16:
	.dsb 1
PRGBank_DMC_17:
	.dsb 1
PRGBank_DMC_SAW_3:
	.dsb 1
PRGBank_DMC_SAW_4:
	.dsb 1
PRGBank_DMC_SAW_5:
	.dsb 1
PRGBank_DMC_SAW_2:
	.dsb 1
PRGBank_NSF_HOME:
.ende


; ---------------------------------------------------------------------------

.enum $0000
; enum ScreenUpdateBuffer
ScreenUpdateBuffer_RAM_301 = $00
ScreenUpdateBuffer_RAM_BonusChanceCoinsExtraLife = $01
ScreenUpdateBuffer_RAM_TitleCardPalette = $02
ScreenUpdateBuffer_CharacterSelect = $03
ScreenUpdateBuffer_TitleCard = $04
ScreenUpdateBuffer_Text_Game_Over = $05
ScreenUpdateBuffer_RAM_ContinueRetryText = $06
ScreenUpdateBuffer_Text_Retry = $07
ScreenUpdateBuffer_RAM_TitleCardText = $08
ScreenUpdateBuffer_RAM_BonusChanceUnused = $09
ScreenUpdateBuffer_RAM_NoBonusText = $0A
ScreenUpdateBuffer_RAM_PushAButtonText = $0B
ScreenUpdateBuffer_RAM_Player1UpText = $0C
ScreenUpdateBuffer_RAM_PauseText = $0D
ScreenUpdateBuffer_RAM_ErasePauseText = $0E
ScreenUpdateBuffer_RAM_EraseBonusMessageText = $0F
ScreenUpdateBuffer_RAM_ErasePushAButtonText = $10
ScreenUpdateBuffer_RAM_EraseBonusMessageTextUnused = $11
ScreenUpdateBuffer_WarpToWorld = $12
ScreenUpdateBuffer_RAM_ContinueRetryBullets = $13
ScreenUpdateBuffer_RAM_EndOfLevelDoor = $14
ScreenUpdateBuffer_TitleCardLeftover = $15
ScreenUpdateBuffer_PauseExtraLife = $16
ScreenUpdateBuffer_RAM_BonusChanceLayout = $17
ScreenUpdateBuffer_PauseOptions = $18
ScreenUpdateBuffer_PauseOptionsAttribute1 = $19
ScreenUpdateBuffer_PauseOptionsAttribute2 = $1A
ScreenUpdateBuffer_PauseOptionsAttribute3 = $1B
ScreenUpdateBuffer_RAM_BonusChanceThreeCoinService = $1C
ScreenUpdateBuffer_RAM_WarpScreen = $1D
ScreenUpdateBuffer_WarpPalBlack = $1E
ScreenUpdateBuffer_WarpFade1 = $1F
ScreenUpdateBuffer_WarpFade2 = $20
ScreenUpdateBuffer_WarpFade3 = $21
ScreenUpdateBuffer_WarpFinalPalettes = $22
ScreenUpdateBuffer_RAM_BonusChanceFlash = $22


; ---------------------------------------------------------------------------
; enum options (width 1 byte)
PauseOption_Continue = 0
PauseOption_SaveNContinue = 1
PauseOption_SaveNQuit = 2

; ---------------------------------------------------------------------------

; enum EndingUpdateBuffer (width 1 byte)
EndingUpdateBuffer_RAM_301 = $00
EndingUpdateBuffer_JarRoom = $01
EndingUpdateBuffer_CeilingTextAndPodium = $02
EndingUpdateBuffer_FloorAndSubconParade = $03
EndingUpdateBuffer_PaletteFade1 = $04
EndingUpdateBuffer_PaletteFade2 = $05
EndingUpdateBuffer_PaletteFade3 = $06
EndingUpdateBuffer_SubconStandStill = $07
EndingUpdateBuffer_Unused_THE_END = $08
EndingUpdateBuffer_Text_MARIO = $09
EndingUpdateBuffer_Text_PRINCESS = $0A
EndingUpdateBuffer_Text_TOAD = $0B
EndingUpdateBuffer_Text_LUIGI = $0C
EndingUpdateBuffer_Debug = $0D

; ---------------------------------------------------------------------------

WarpUpdateBuffer_RAM_301 = $00
WarpUpdateBuffer_RAM_Screen = $01
WarpUpdateBuffer_PalBlack = $02
WarpUpdateBuffer_Fade1 = $03
WarpUpdateBuffer_Fade2 = $04
WarpUpdateBuffer_Fade3 = $05
WarpUpdateBuffer_FinalPalettes = $06
.ende

; ---------------------------------------------------------------------------

; enum SoundEffect2 (width 1 byte)
.enum $0001
SFX_STOP_SLOT:		.dsb 1
SFX_1UP:		.dsb 1
SFX_COIN:		.dsb 1
SFX_SHRINK:		.dsb 1
SFX_LOSE_HEART:		.dsb 1
SFX_TOSS:		.dsb 1
SFX_HAWK_OPEN:		.dsb 1
SFX_HAWK_CLOSE:		.dsb 1
SFX_CLAWGRIP_CHUCK:	.dsb 1
SFX_IMPACT:

; ---------------------------------------------------------------------------

; enum PPUStatus (bitfield) (width 1 byte)
PPUStatus_SpriteOverflow = %100000
PPUStatus_Sprite0Hit = %1000000
PPUStatus_VBlankHit = %10000000
.ende
; ---------------------------------------------------------------------------

; enum SoundEffect3
.enum $0001
Noise_ClosedHihat:		.dsb 1 ; 00
Noise_UpperSnare:		.dsb 1 ; 01
Noise_OpenHihat:		.dsb 1 ; 02
Noise_Kick:			.dsb 1 ; 03
Noise_Snare:			.dsb 1 ; 04
Noise_DoubleSnare:		.dsb 1 ; 05
Noise_OWClosedHihat:		.dsb 1 ; 06
Noise_OWOpenHihat:		.dsb 1 ; 07
Noise_OWKick:			.dsb 1 ; 08
Noise_OWSnare:			.dsb 1 ; 09
Noise_StarSnare:		.dsb 1 ; 0A
NOISE_SFX:
SFX_WHALE_SPOUT:		.dsb 1 ; 0B
SFX_ROCKET_RUMBLE:		.dsb 1 ; 0C
SFX_POW_LAND:			.dsb 1 ; 0D
SFX_THROUGH_DOOR:		.dsb 1 ; 0E
SFX_EXPLOSION:			.dsb 1 ; 0F
SFX_AUTOBOMB_TRICLYDE_FIREBALL:	.dsb 1 ; 10
SFX_BUBBLE_FIRING:		.dsb 1 ; 11
SFX_SMOKE_PUFF:			.dsb 1 ; 12
SFX_DRUM_ROLL:			.dsb 1 ; 13
SFX_ROCKET_HISS:		.dsb 1 ; 14
SFX_ENEMY_STOMP:		.dsb 1 ; 15
NUM_NOISE_TRACKS:
NUM_NOISE_SFX = NUM_NOISE_TRACKS - NOISE_SFX

; ---------------------------------------------------------------------------

; enum SlotMachineSymbols (width 1 byte)
Slot_Cherry = $00
Slot_Star = $08
Slot_Turnip = $10
Slot_Snifit = $18
Slot_7 = $20

; ---------------------------------------------------------------------------

; enum SpriteAnimations
SpriteAnimation_Walking = $00
SpriteAnimation_WalkingCarrying = $01
SpriteAnimation_Standing = $02
SpriteAnimation_StandingCarrying = $03
SpriteAnimation_Ducking = $04
SpriteAnimation_5 = $05
SpriteAnimation_Jumping = $06
SpriteAnimation_Dead = $07
SpriteAnimation_Pulling = $08
SpriteAnimation_Throwing = $09
SpriteAnimation_Climbing = $0A

; ---------------------------------------------------------------------------

; enum iPlayerHPValues
PlayerHealth_1_HP = $0F
PlayerHealth_2_HP = $1F
PlayerHealth_3_HP = $2F
PlayerHealth_4_HP = $3F

; ---------------------------------------------------------------------------

; enum PPUMaskBitmask (bitfield) (width 1 byte)
PPUMask_Grayscale = %00000001
PPUMask_ShowLeft8Pixels_BG = %00000010
PPUMask_ShowLeft8Pixels_SPR = %00000100
PPUMask_ShowBackground = %00001000
PPUMask_ShowSprites = %00010000
PPUMask_RedEmphasis = %00100000
PPUMask_GreenEmphasis = %01000000
PPUMask_BlueEmphasis = %10000000

; ---------------------------------------------------------------------------

; enum PPUTileDataLength (bitfield) (width 1 byte)
PPUData_Length = $00
PPUTileData_RepeatOneTile = $40
PPUData_Horizontal = $00
PPUData_Vertical = $80

; ---------------------------------------------------------------------------

; enum GameModes
GameMode_InGame = $00
GameMode_TitleCard = $01
GameMode_GameOver = $02
GameMode_BonusChance = $03
GameMode_Warp = $04

; enum Stack100
Stack100_Menu = %01000000 ; static screens (eg. character select)
Stack100_Pause = %01000001 ; static screen (pause)
Stack100_Save = %01000010 ; static screen (saving during Sleeping Mario scene)
Stack100_PauseSave = %01000011 ; static screen (saving while paused)
Stack100_Transition = %10000000 ; used for transitions, disable input and mirroring
Stack100_Gameplay = %11000000 ; normal gameplay

; ---------------------------------------------------------------------------

; enum PPUControl (bitfield) (width 1 byte)
PPUCtrl_BaseAddress = $03
PPUCtrl_Base2000 = $00
PPUCtrl_Base2400 = $01
PPUCtrl_Base2800 = $02
PPUCtrl_Base2C00 = $03
PPUCtrl_WriteHorizontal = $00
PPUCtrl_WriteVertical = $04
PPUCtrl_Sprite0000 = $00
PPUCtrl_Sprite1000 = $08
PPUCtrl_Background0000 = $00
PPUCtrl_Background1000 = $10
PPUCtrl_SpriteSize8x8 = $00
PPUCtrl_SpriteSize8x16 = $20
PPUCtrl_NMIDisabled = $00
PPUCtrl_NMIEnabled = $80

; ---------------------------------------------------------------------------

; enum EnemyStates
EnemyState_Inactive = $00
EnemyState_Alive = $01
EnemyState_Dead = $02
EnemyState_BlockFizzle = $03
EnemyState_BombExploding = $04
EnemyState_PuffOfSmoke = $05
EnemyState_Sand = $06
EnemyState_Sinking = $07
EnemyState_27 = $27

; ---------------------------------------------------------------------------

; enum ObjectAttribute (bitfield)
ObjAttrib_Palette = %00000011
ObjAttrib_Palette0 = $00
ObjAttrib_Palette1 = $01
ObjAttrib_Palette2 = $02
ObjAttrib_Palette3 = $03
ObjAttrib_Horizontal = %00000100 ; use with ObjAttrib_16x32 for 32x16
ObjAttrib_FrontFacing = %00001000 ; no direction-based mirroring
ObjAttrib_Mirrored = %00010000
ObjAttrib_BehindBackground = %00100000
ObjAttrib_16x32 = %01000000
ObjAttrib_UpsideDown = %10000000 ; appears behind background when pulling

; ---------------------------------------------------------------------------

; enum BackgroundTileIds
; quads 1
BackgroundTile_Black = $00
BackgroundTile_BgCloudLeft = $01
BackgroundTile_BgCloudRight = $02
BackgroundTile_BgCloudSmall = $03
BackgroundTile_WaterfallTop = $04
BackgroundTile_Waterfall = $05
BackgroundTile_WaterfallSplash = $06
BackgroundTile_Chain = $07
BackgroundTile_WaterTop = $08
BackgroundTile_HouseLeft = $09
BackgroundTile_Water = $0A
BackgroundTile_HouseMiddle = $0B
BackgroundTile_WaterWhale = $0C
BackgroundTile_HouseRight = $0D
BackgroundTile_Unused0E = $0E
BackgroundTile_Unused0F = $0F
BackgroundTile_Unused10 = $10
BackgroundTile_WaterWhaleTail = $11
BackgroundTile_JumpThroughBlock = $12
BackgroundTile_CloudLeft = $13
BackgroundTile_CloudMiddle = $14
BackgroundTile_CloudRight = $15
BackgroundTile_JumpThroughIce = $16
BackgroundTile_ChainStandable = $17
BackgroundTile_SolidBrick0 = $18
BackgroundTile_GroundBrick0 = $19
BackgroundTile_Spikes = $1A
BackgroundTile_SolidRoundBrick0 = $1B
BackgroundTile_SolidBlock = $1C
BackgroundTile_CactusTop = $1D
BackgroundTile_CactusMiddle = $1E
BackgroundTile_FrozenRock = $1F
BackgroundTile_LogPillarTop0 = $20
BackgroundTile_LogPillarMiddle0 = $21
BackgroundTile_ClawGripRock = $22
BackgroundTile_Unused23 = $23 ; These are just solid palette-swapped mirrors of $40
BackgroundTile_Unused24 = $24
BackgroundTile_Unused25 = $25
BackgroundTile_Unused26 = $26
BackgroundTile_Unused27 = $27
BackgroundTile_Unused28 = $28
BackgroundTile_Unused29 = $29
BackgroundTile_Unused2A = $2A
BackgroundTile_Unused2B = $2B
BackgroundTile_Unused2C = $2C
BackgroundTile_Unused2D = $2D
BackgroundTile_Unused2E = $2E
BackgroundTile_Unused2F = $2F
BackgroundTile_Unused30 = $30
BackgroundTile_Unused31 = $31
BackgroundTile_Unused32 = $32
BackgroundTile_Unused33 = $33
BackgroundTile_Unused34 = $34
BackgroundTile_Unused35 = $35
BackgroundTile_Unused36 = $36
BackgroundTile_Unused37 = $37
BackgroundTile_Unused38 = $38
BackgroundTile_Unused39 = $39
BackgroundTile_Unused3A = $3A
BackgroundTile_Unused3B = $3B
BackgroundTile_Unused3C = $3C
BackgroundTile_Unused3D = $3D
BackgroundTile_Unused3E = $3E
BackgroundTile_Unused3F = $3F
; quads 2
BackgroundTile_Sky = $40
BackgroundTile_SubspaceMushroom1 = $41
BackgroundTile_SubspaceMushroom2 = $42
BackgroundTile_GrassCoin = $43
BackgroundTile_GrassLargeVeggie = $44
BackgroundTile_GrassSmallVeggie = $45
BackgroundTile_GrassRocket = $46
BackgroundTile_GrassShell = $47
BackgroundTile_GrassBomb = $48
BackgroundTile_GrassPotion = $49
BackgroundTile_Grass1UP = $4A
BackgroundTile_GrassPow = $4B
BackgroundTile_GrassBobOmb = $4C
BackgroundTile_GrassInactive = $4D
BackgroundTile_Cherry = $4E
BackgroundTile_DoorTop = $4F
BackgroundTile_DoorBottomLock = $50
BackgroundTile_DoorBottom = $51
BackgroundTile_LightDoor = $52
BackgroundTile_LightTrailRight = $53
BackgroundTile_LightTrail = $54
BackgroundTile_LightTrailLeft = $55
BackgroundTile_LightDoorEndLevel = $56
BackgroundTile_DoorBottomLockStuck = $57
BackgroundTile_DrawBridgeChain = $58
BackgroundTile_Whale = $59
BackgroundTile_WhaleEye = $5A
BackgroundTile_Phanto = $5B
BackgroundTile_TreeBackgroundLeft = $5C
BackgroundTile_TreeBackgroundMiddleLeft = $5D
BackgroundTile_TreeBackgroundRight = $5E
BackgroundTile_TreeBackgroundMiddleRight = $5F
BackgroundTile_WhaleTopLeft = $60
BackgroundTile_WhaleTop = $61
BackgroundTile_WhaleTopRight = $62
BackgroundTile_WhaleTail = $63
BackgroundTile_JumpThroughMachineBlock = $64
BackgroundTile_Bridge = $65
BackgroundTile_BridgeShadow = $66
BackgroundTile_ConveyorLeft = $67
BackgroundTile_ConveyorRight = $68
BackgroundTile_MushroomBlock = $69
BackgroundTile_Unused6AMushroomBlock = $6A
BackgroundTile_Unused6BMushroomBlock = $6B
BackgroundTile_POWBlock = $6C
BackgroundTile_Unused6D = $6D ; Used to mark where the liftable blocks end
BackgroundTile_SolidBrick1 = $6E
BackgroundTile_JarTopPointer = $6F
BackgroundTile_JarMiddle = $70
BackgroundTile_JarBottom = $71
BackgroundTile_JarSmall = $72
BackgroundTile_JarTopGeneric = $73
BackgroundTile_JarTopNonEnterable = $74
BackgroundTile_LogLeft = $75
BackgroundTile_LogMiddle = $76
BackgroundTile_LogRight = $77
BackgroundTile_LogRightTree = $78
BackgroundTile_LogPillarTop1 = $79
BackgroundTile_LogPillarMiddle1 = $7A
BackgroundTile_Unused7B = $7B
BackgroundTile_Unused7C = $7C
BackgroundTile_Unused7D = $7D
BackgroundTile_Unused7E = $7E
BackgroundTile_Unused7F = $7F
; quads 3
BackgroundTile_Ladder = $80
BackgroundTile_LadderShadow = $81
BackgroundTile_PalmTreeTrunk = $82
BackgroundTile_DarkDoor = $83
BackgroundTile_PyramidLeftAngle = $84
BackgroundTile_PyramidLeft = $85
BackgroundTile_PyramidRight = $86
BackgroundTile_PyramidRightAngle = $87
BackgroundTile_StarBg1 = $88
BackgroundTile_StarBg2 = $89
BackgroundTile_QuicksandSlow = $8A
BackgroundTile_QuicksandFast = $8B
BackgroundTile_HornTopLeft = $8C
BackgroundTile_HornTopRight = $8D
BackgroundTile_HornBottomLeft = $8E
BackgroundTile_HornBottomRight = $8F
BackgroundTile_BackgroundBrick = $90
BackgroundTile_JumpthroughSand = $91
BackgroundTile_JumpthroughWoodBlock = $92
BackgroundTile_DiggableSand = $93
BackgroundTile_LadderStandable = $94
BackgroundTile_LadderStandableShadow = $95
BackgroundTile_JumpthroughSandBlock = $96
BackgroundTile_JumpthroughBrick = $97
BackgroundTile_98 = $98
BackgroundTile_SolidSand = $99
BackgroundTile_9A = $9A
BackgroundTile_SolidBrick2 = $9B
BackgroundTile_GroundBrick2 = $9C
BackgroundTile_BombableBrick = $9D
BackgroundTile_JarWall = $9E ; solid color, solid wall
BackgroundTile_RockWallAngle = $9F
BackgroundTile_RockWall = $A0
BackgroundTile_RockWallOffset = $A1
BackgroundTile_SolidRoundBrick2 = $A2
BackgroundTile_SolidBrick2Wall = $A3
BackgroundTile_SolidWood = $A4
BackgroundTile_RockWallEyeLeft = $A5 ; World 6
BackgroundTile_RockWallEyeRight = $A6 ; World 6
BackgroundTile_RockWallMouth = $A7 ; World 6
BackgroundTile_WindowTop = $A8 ; World 7
BackgroundTile_DoorwayTop = $A9 ; World 7
BackgroundTile_ColumnPillarTop2 = $AA
BackgroundTile_ColumnPillarMiddle2 = $AB
BackgroundTile_UnusedAC = $AC
BackgroundTile_UnusedAD = $AD
BackgroundTile_UnusedAE = $AE
BackgroundTile_UnusedAF = $AF
BackgroundTile_UnusedB0 = $B0 ; These are just solid palette-swapped mirrors of $C4
BackgroundTile_UnusedB1 = $B1
BackgroundTile_UnusedB2 = $B2
BackgroundTile_UnusedB3 = $B3 ; SolidPlatformLeft2
BackgroundTile_UnusedB4 = $B4 ; SolidPlatformMiddle2
BackgroundTile_UnusedB5 = $B5 ; SolidPlatformRight2
BackgroundTile_UnusedB6 = $B6 ; SolidPlatformTopLeft2
BackgroundTile_UnusedB7 = $B7
BackgroundTile_UnusedB8 = $B8 ; SolidPlatformTop2
BackgroundTile_UnusedB9 = $B9
BackgroundTile_UnusedBA = $BA ; SolidPlatformTopRight2
BackgroundTile_UnusedBB = $BB
BackgroundTile_UnusedBC = $BC ; SolidPlatformTopLeftOverlap2
BackgroundTile_UnusedBD = $BD ; SolidPlatformTopRightOverlap2
BackgroundTile_UnusedBE = $BE ; SolidPlatformTopLeftOverlapEdge2
BackgroundTile_UnusedBF = $BF ; SolidPlatformTopRightOverlapEdge2
; quads 4
BackgroundTile_PalmTreeTop = $C0
BackgroundTile_VineTop = $C1
BackgroundTile_Vine = $C2
BackgroundTile_VineBottom = $C3
BackgroundTile_ClimbableSky = $C4
BackgroundTile_UnusedC5 = $C5
BackgroundTile_JarOutsideBackground = $C6 ; solid color, background
BackgroundTile_GreenPlatformLeft = $C7
BackgroundTile_GreenPlatformMiddle = $C8
BackgroundTile_GreenPlatformRight = $C9
BackgroundTile_GreenPlatformTopLeft = $CA
BackgroundTile_MushroomTopLeft = $CB
BackgroundTile_GreenPlatformTop = $CC
BackgroundTile_MushroomTopMiddle = $CD
BackgroundTile_GreenPlatformTopRight = $CE
BackgroundTile_MushroomTopRight = $CF
BackgroundTile_GreenPlatformTopLeftOverlap = $D0
BackgroundTile_GreenPlatformTopRightOverlap = $D1
BackgroundTile_GreenPlatformTopLeftOverlapEdge = $D2
BackgroundTile_GreenPlatformTopRightOverlapEdge = $D3
BackgroundTile_VineStandable = $D4
BackgroundTile_SolidGrass = $D5
BackgroundTile_SolidBrick3 = $D6
BackgroundTile_GroundBrick3 = $D7 ; World 7
BackgroundTile_UnusedD8 = $D8
BackgroundTile_UnusedD9 = $D9
BackgroundTile_UnusedDA = $DA
BackgroundTile_UnusedDB = $DB
BackgroundTile_UnusedDC = $DC
BackgroundTile_UnusedDD = $DD
BackgroundTile_UnusedDE = $DE
BackgroundTile_UnusedDF = $DF
BackgroundTile_UnusedE0 = $E0
BackgroundTile_UnusedE1 = $E1
BackgroundTile_UnusedE2 = $E2
BackgroundTile_UnusedE3 = $E3
BackgroundTile_UnusedE4 = $E4
BackgroundTile_UnusedE5 = $E5
BackgroundTile_UnusedE6 = $E6
BackgroundTile_UnusedE7 = $E7
BackgroundTile_UnusedE8 = $E8
BackgroundTile_UnusedE9 = $E9
BackgroundTile_UnusedEA = $EA
BackgroundTile_UnusedEB = $EB
BackgroundTile_UnusedEC = $EC
BackgroundTile_UnusedED = $ED
BackgroundTile_UnusedEE = $EE
BackgroundTile_UnusedEF = $EF
BackgroundTile_UnusedF0 = $F0
BackgroundTile_UnusedF1 = $F1
BackgroundTile_UnusedF2 = $F2
BackgroundTile_UnusedF3 = $F3
BackgroundTile_UnusedF4 = $F4
BackgroundTile_UnusedF5 = $F5
BackgroundTile_UnusedF6 = $F6
BackgroundTile_UnusedF7 = $F7
BackgroundTile_UnusedF8 = $F8
BackgroundTile_UnusedF9 = $F9
BackgroundTile_UnusedFA = $FA
BackgroundTile_UnusedFB = $FB
BackgroundTile_UnusedFC = $FC
BackgroundTile_UnusedFD = $FD
BackgroundTile_UnusedFE = $FE
BackgroundTile_UnusedFF = $FF

; enum EnemyIds
Enemy_Heart = $00
Enemy_ShyguyRed = $01
Enemy_Tweeter = $02
Enemy_ShyguyPink = $03
Enemy_Porcupo = $04
Enemy_SnifitRed = $05
Enemy_SnifitGray = $06
Enemy_SnifitPink = $07
Enemy_Ostro = $08
Enemy_BobOmb = $09
Enemy_AlbatossCarryingBobOmb = $0A
Enemy_AlbatossStartRight = $0B
Enemy_AlbatossStartLeft = $0C
Enemy_NinjiRunning = $0D
Enemy_NinjiJumping = $0E
Enemy_BeezoDiving = $0F
Enemy_BeezoStraight = $10
Enemy_WartBubble = $11
Enemy_Pidgit = $12
Enemy_Trouter = $13
Enemy_Hoopstar = $14
Enemy_JarGeneratorShyguy = $15
Enemy_JarGeneratorBobOmb = $16
Enemy_Phanto = $17
Enemy_CobratJar = $18
Enemy_CobratSand = $19
Enemy_Pokey = $1A
Enemy_Bullet = $1B
Enemy_Birdo = $1C
Enemy_Mouser = $1D
Enemy_Egg = $1E
Enemy_Tryclyde = $1F
Enemy_Fireball = $20
Enemy_Clawgrip = $21
Enemy_ClawgripRock = $22
Enemy_PanserStationaryFiresAngled = $23
Enemy_PanserWalking = $24
Enemy_PanserStationaryFiresUp = $25
Enemy_Autobomb = $26
Enemy_AutobombFire = $27
Enemy_WhaleSpout = $28
Enemy_Flurry = $29
Enemy_Fryguy = $2A
Enemy_FryguySplit = $2B
Enemy_Wart = $2C
Enemy_HawkmouthBoss = $2D
Enemy_Spark1 = $2E ; clockwise, slow
Enemy_Spark2 = $2F ; clockwise, fast
Enemy_Spark3 = $30 ; counter-clockwise, slow
Enemy_Spark4 = $31 ; counter-clockwise, fast
Enemy_VegetableSmall = $32
Enemy_VegetableLarge = $33
Enemy_VegetableWart = $34
Enemy_Shell = $35
Enemy_Coin = $36
Enemy_Bomb = $37
Enemy_Rocket = $38
Enemy_MushroomBlock = $39
Enemy_POWBlock = $3A
Enemy_FallingLogs = $3B
Enemy_SubspaceDoor = $3C
Enemy_Key = $3D
Enemy_SubspacePotion = $3E
Enemy_Mushroom = $3F
Enemy_Mushroom1up = $40
Enemy_FlyingCarpet = $41
Enemy_HawkmouthRight = $42
Enemy_HawkmouthLeft = $43
Enemy_CrystalBall = $44
Enemy_Starman = $45
Enemy_Stopwatch = $46
Enemy_AttackAlbatossCarryingBobOmb = $47
Enemy_AttackBeezo = $48
Enemy_StopAttack = $49
Enemy_VegetableThrower = $4A ; Used in Wart's room
Enemy_4B = $4B ; crash
Enemy_4C = $4C ; weird! makes game think you can always jump and pick up an enemy
Enemy_4D = $4D ; crash
Enemy_4E = $4E ; hangs, forces background scroll?
Enemy_4F = $4F ; hangs, forces background scroll?
Enemy_50 = $50 ; crash, b+w palette?
Enemy_51 = $51 ; crash
Enemy_52 = $52 ; hangs, forces background scroll?
Enemy_53 = $53 ; hangs, forces background scroll?
Enemy_54 = $54 ; weird invisible thing that doesn't quite crash
Enemy_55 = $55 ; seems to mess up player physics
Enemy_56 = $56 ; crash
Enemy_57 = $57 ; seems to mess up player physics
Enemy_58 = $58 ; seems to mess up player physics
Enemy_59 = $59 ; crash
Enemy_5A = $5A ; crash
Enemy_5B = $5B ; hangs, forces background scroll?
Enemy_BossBirdo = $5C
Enemy_BossMouser = $5D
Enemy_BossEgg = $5E
Enemy_BossTryclyde = $5F
Enemy_BossFireball = $60
Enemy_BossClawgrip = $61
Enemy_BossClawgripRock = $62
Enemy_BossPanserStationaryFiresAngled = $63
Enemy_BossPanserWalking = $64
Enemy_BossPanserStationaryFiresUp = $65
Enemy_BossAutobomb = $66
Enemy_BossAutobombFire = $67
Enemy_BossWhaleSpout = $68
Enemy_BossFlurry = $69
Enemy_BossFryguy = $6A
Enemy_BossFryguySplit = $6B
Enemy_BossWart = $6C
Enemy_BossHawkmouthBoss = $6D
Enemy_BossSpark1 = $6E
Enemy_BossSpark2 = $6F
Enemy_BossSpark3 = $70
Enemy_BossSpark4 = $71
Enemy_BossVegetableSmall = $72
Enemy_BossVegetableLarge = $73
Enemy_BossVegetableWart = $74
Enemy_BossShell = $75
Enemy_BossCoin = $76
Enemy_BossBomb = $77
Enemy_BossRocket = $78
Enemy_BossMushroomBlock = $79
Enemy_BossPOWBlock = $7A
Enemy_BossFallingLogs = $7B
Enemy_BossSubspaceDoor = $7C
Enemy_BossKey = $7D
Enemy_BossSubspacePotion = $7E
Enemy_BossMushroom = $7F

; ---------------------------------------------------------------------------
; Mario Sleeping Definitions
NumFrames_THE = $15
NumFrames_END = $13

; ---------------------------------------------------------------------------

LevelDirection_Horizontal = 1
LevelDirection_Vertical = 0

LevelMusic_Overworld = 0
LevelMusic_Underground = 1
LevelMusic_Boss = 2
LevelMusic_Wart = 3

; ---------------------------------------------------------------------------

; enum CollisionFlags (bitfield) (width 1 byte)
CollisionFlags_00 = %00000000
CollisionFlags_Right = %00000001
CollisionFlags_Left = %00000010
CollisionFlags_Down = %00000100
CollisionFlags_Up = %00001000
CollisionFlags_Damage = %00010000
CollisionFlags_PlayerOnTop = %00100000
CollisionFlags_PlayerInsideMaybe = %01000000
CollisionFlags_80 = %10000000

; enum CHRBank (width 1 byte)

CHRBank_Mario = $00
CHRBank_Luigi = $01
CHRBank_Princess = $02
CHRBank_Toad = $03
CHRBank_MarioSmall = $04
CHRBank_LuigiSmall = $05
CHRBank_PrincessSmall = $06
CHRBank_ToadSmall = $07

CHRBank_CommonEnemies1 = $08
CHRBank_CommonEnemies2 = $09

CHRBank_BackgroundGrassClawgrip = $0A

CHRBank_EnemiesGrass = $0C
CHRBank_EnemiesDesert = $0D
CHRBank_EnemiesIce = $0E
CHRBank_EnemiesSky = $0F

CHRBank_BackgroundGrass = $10
CHRBank_BackgroundDesert = $12
CHRBank_BackgroundIce = $14
CHRBank_BackgroundSky = $16

CHRBank_Animated1 = $18
CHRBank_Animated2 = $1A
CHRBank_Animated3 = $1C
CHRBank_Animated4 = $1E
CHRBank_Animated5 = $20
CHRBank_Animated6 = $22
CHRBank_Animated7 = $24
CHRBank_Animated8 = $26

CHRBank_TitleScreenBG1 = $28
CHRBank_TitleScreenBG2 = $2A

CHRBank_CharacterSelectBG1 = $2C
CHRBank_CharacterSelectBG2 = $2E
CHRBank_CharacterSelectSprites = $30

CHRBank_SubconEndingTiles = $32

CHRBank_ChanceBG1 = $34
CHRBank_ChanceBG2 = $36

CHRBank_CelebrationBG1 = $38
CHRBank_CelebrationBG2 = $3A

CHRBank_Warp1 = $3C
CHRBank_Warp2 = $3E

CHRBank_TitleCardGrass = $40
CHRBank_TitleCardDesert = $42
CHRBank_TitleCardIce = $44
CHRBank_TitleCardSky = $46

CHRBank_EndingSprites = $48
CHRBank_EndingCast1 = $4C
CHRBank_EndingCast2 = $4D
CHRBank_EndingCast3 = $4E
CHRBank_EndingCast4 = $4F
CHRBank_EndingBackground1 = $50
CHRBank_EndingBackground2 = $54
CHRBank_EndingBackground3 = $58
CHRBank_EndingBackground4 = $5C
CHRBank_EndingBackground5 = $60
CHRBank_EndingBackground6 = $64
CHRBank_EndingBackground7 = $68
CHRBank_EndingBackground8 = $6C
CHRBank_EndingBackground9 = $70
CHRBank_EndingBackground10 = $74
CHRBank_EndingBackground11 = $78
CHRBank_EndingBackground12 = $7C

CHRBank_PlaxGrass = $80
CHRBank_PlaxDesert = $a0
CHRBank_PlaxIce = $c0
CHRBank_PlaxSky = $e0

NSFBank0 = $5ff8
NSFBank1 = $5ff9
NSFBank2 = $5ffa
NSFBank3 = $5ffb
NSFBank4 = $5ffc
NSFBank5 = $5ffd
NSFBank6 = $5ffe
NSFBank7 = $5fff

.endinl

.ende