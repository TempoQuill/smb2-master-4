;
; NES and cart RAM
; ================
;
; What's inside: some bits, some bytes. @todo: describe more
;
;   - 0000-00FF: Zero page, various things, enemies/player data
;   - 0100-01FF: Stack area
;   - 0200-02FF: Sprite OAM DMA area
;   - 0300-03FF: PPU buffers, etc.
;   - 0400-04FF: Some enemy data, other small game-state stuff
;   - 0500-05FF: PPU buffers, more game state tracking and other crap
;   - 0600-06FF: Music engine, bonus chance, more PPU buffers, etc.
;   - 0700-07FF: Tile layout for subspace/jar areas
;
;   - 2000-2007: PPU registers
;   - 4000-4017: APU and joypad registers
;   - 5000-5015: Used by MMC5 expansion
;   - 6000-7FFF: on-cart RAM; decoded level, level data, enemy data, and more
;
;   - 8000-FFFF: you're in the wrong file, pal. that's rom.
;

z00:
	.dsb 1 ; $0000
z01:
	.dsb 1 ; $0001
z02:
	.dsb 1 ; $0002
z03:
	.dsb 1 ; $0003
z04:
	.dsb 1 ; $0004
z05:
	.dsb 1 ; $0005
z06:
	.dsb 1 ; $0006
z07:
	.dsb 1 ; $0007
z08:
	.dsb 1 ; $0008
z09:
	.dsb 1 ; $0009
z0a:
	.dsb 1 ; $000a
z0b:
	.dsb 1 ; $000b
z0c:
	.dsb 1 ; $000c
z0d:
	.dsb 1 ; $000d
z0e:
	.dsb 1 ; $000e
z0f:
	.dsb 1 ; $000f
; This is used as a global counter.
; It continuouly increments during gameplay and freezes for the pause screen
; and title cards. On the character select screen, it is used to count down
; before showing the title card.
z10:
	.dsb 1 ; $0010
zScreenUpdateIndex:
	.dsb 1 ; $0011
; next object slot to use?
z12:
	.dsb 1 ; $0012
zBreakStartLevelLoop:
	.dsb 1 ; $0013

zPlayerXHi:
	.dsb 1 ; $0014
zObjectXHi:
	.dsb 1 ; $0015
	.dsb 1 ; 1                ; $0016
	.dsb 1 ; 2                ; $0017
	.dsb 1 ; 3                ; $0018
	.dsb 1 ; 4                ; $0019
	.dsb 1 ; 5                ; $001a
	.dsb 1 ; 6                ; $001b
	.dsb 1 ; 7                ; $001c
	.dsb 1 ; 8                ; $001d

zPlayerYHi:
	.dsb 1 ; $001e
zObjectYHi:
	.dsb 1 ; $001f
	.dsb 1 ; 1                ; $0020
	.dsb 1 ; 2                ; $0021
	.dsb 1 ; 3                ; $0022
	.dsb 1 ; 4                ; $0023
	.dsb 1 ; 5                ; $0024
	.dsb 1 ; 6                ; $0025
	.dsb 1 ; 7                ; $0026
	.dsb 1 ; 8                ; $0027

zPlayerXLo:
	.dsb 1 ; $0028
zObjectXLo:
	.dsb 1 ; $0029
	.dsb 1 ; 1                ; $002a
	.dsb 1 ; 2                ; $002b
	.dsb 1 ; 3                ; $002c
	.dsb 1 ; 4                ; $002d
	.dsb 1 ; 5                ; $002e
	.dsb 1 ; 6                ; $002f
	.dsb 1 ; 7                ; $0030
	.dsb 1 ; 8                ; $0031

zPlayerYLo:
	.dsb 1 ; $0032
zObjectYLo:
	.dsb 1 ; $0033
	.dsb 1 ; 1                ; $0034
	.dsb 1 ; 2                ; $0035
	.dsb 1 ; 3                ; $0036
	.dsb 1 ; 4                ; $0037
	.dsb 1 ; 5                ; $0038
	.dsb 1 ; 6                ; $0039
	.dsb 1 ; 7                ; $003a
	.dsb 1 ; 8                ; $003b

zPlayerXVelocity:
	.dsb 1 ; $003c
zObjectXVelocity:
	.dsb 1 ; $003d
	.dsb 1 ; 1                ; $003e
	.dsb 1 ; 2                ; $003f
	.dsb 1 ; 3                ; $0040
	.dsb 1 ; 4                ; $0041
	.dsb 1 ; 5                ; $0042
	.dsb 1 ; 6                ; $0043
	.dsb 1 ; 7                ; $0044
	.dsb 1 ; 8                ; $0045

zPlayerYVelocity:
	.dsb 1 ; $0046
zObjectYVelocity:
	.dsb 1 ; $0047
	.dsb 1 ; 1                ; $0048
	.dsb 1 ; 2                ; $0049
	.dsb 1 ; 3                ; $004a
	.dsb 1 ; 4                ; $004b
	.dsb 1 ; 5                ; $004c
	.dsb 1 ; 6                ; $004d
	.dsb 1 ; 7                ; $004e
	.dsb 1 ; 8                ; $004f

;
; Player and Object States
; ========================
;
; Some of these are for players, some of these are for objects/enemies
;
; $00 Normal
; $01 ?
; $02 Lifting up object
; $03 ?
; $04 Going down vase (causes warp if poked)
; $05 Exiting vase
; $06 ?
; $07 Dying (falls off screen)
; $08 Shrinking
; $09+ Crash?
; $27 @TODO object-related?
;
zPlayerState:
	.dsb 1 ; $0050
zEnemyState:
	.dsb 1 ; $0051
	.dsb 1 ; 1                ; $0052
	.dsb 1 ; 2                ; $0053
	.dsb 1 ; 3                ; $0054
	.dsb 1 ; 4                ; $0055
	.dsb 1 ; 5                ; $0056
	.dsb 1 ; 6                ; $0057
	.dsb 1 ; 7                ; $0058
	.dsb 1 ; 8                ; $0059

zPlayerCollision: ; see CollisionFlags enum for bit definitions
	.dsb 1 ; $005a
zEnemyCollision:
	.dsb 1 ; $005b
	.dsb 1 ; 1                ; $005c
	.dsb 1 ; 2                ; $005d
	.dsb 1 ; 3                ; $005e
	.dsb 1 ; 4                ; $005f
	.dsb 1 ; 5                ; $0060
	.dsb 1 ; 6                ; $0061
	.dsb 1 ; 7                ; $0062
	.dsb 1 ; 8                ; $0063

zPlayerAttributes:
	.dsb 1 ; $0064
zObjectAttributes:
	.dsb 1 ; $0065
	.dsb 1 ; 1                ; $0066
	.dsb 1 ; 2                ; $0067
	.dsb 1 ; 3                ; $0068
	.dsb 1 ; 4                ; $0069
	.dsb 1 ; 5                ; $006a
	.dsb 1 ; 6                ; $006b
	.dsb 1 ; 7                ; $006c
	.dsb 1 ; 8                ; $006d

; $02 if moving left, $01 otherwise?
zPlayerTrajectory:
	.dsb 1 ; $006e
zEnemyTrajectory:
	.dsb 1 ; $006f
	.dsb 1 ; 1                ; $0070
	.dsb 1 ; 2                ; $0071
	.dsb 1 ; 3                ; $0072
	.dsb 1 ; 4                ; $0073
	.dsb 1 ; 5                ; $0074
	.dsb 1 ; 6                ; $0075
	.dsb 1 ; 7                ; $0076
	.dsb 1 ; 8                ; $0077

; FOR RENT
	.dsb 1 ; $0078
; This is set on entering subspace, depending
; on which particular mushroom is on the screen
; (used to determine if it should show up
; and also which mushroom it marks as collected)
;
; This also seems to determine a few other things:
; - Tweeter jumps
; - Falling log height
; - Birdo subtype
; etc.
;
zObjectVariables:
	.dsb 1 ; $0079
	.dsb 1 ; 1 ; $007a
	.dsb 1 ; 2 ; $007b
	.dsb 1 ; 3 ; $007c
	.dsb 1 ; 4 ; $007d
	.dsb 1 ; 5 ; $007e
	.dsb 1 ; 6 ; $007f
	.dsb 1 ; 7 ; $0080
	.dsb 1 ; 8 ; $0081

zPlayerStateTimer:
	.dsb 1 ; $0082
zEndgameTimer:
	.dsb 1 ; $0083
zWalkCycleTimer: ; used for controlling speed of walk animation
	.dsb 1 ; $0084
zDamageCooldown:
	.dsb 1 ; $0085
zSpriteTimer:
	.dsb 1 ; $0086
	.dsb 1 ; 1                ; $0087
	.dsb 1 ; 2                ; $0088
	.dsb 1 ; 3                ; $0089
	.dsb 1 ; 4                ; $008a
	.dsb 1 ; 5                ; $008b
	.dsb 1 ; 6                ; $008c
	.dsb 1 ; 7                ; $008d
zEndgameCorkTimer:
	.dsb 1 ; $008e
; $00 Mario
; $01 Princess
; $02 Toad
; $03 Luigi
zCurrentCharacter:
	.dsb 1 ; $008f
zObjectType:
	.dsb 1 ; $0090
	.dsb 1 ; 1                ; $0091
	.dsb 1 ; 2                ; $0092
	.dsb 1 ; 3                ; $0093
	.dsb 1 ; 4                ; $0094
	.dsb 1 ; 5                ; $0095
	.dsb 1 ; 6                ; $0096
	.dsb 1 ; 7                ; $0097
	.dsb 1 ; 8                ; $0098
; $00 = on ground or enemy, $01 = in air
zPlayerGrounding:
	.dsb 1 ; $0099
zPlayerHitBoxHeight:
	.dsb 1 ; $009a
zPlayerWalkFrame:
	.dsb 1 ; $009b
zHeldItem:
	.dsb 1 ; $009c
; $00 = left, $01 = right
zPlayerFacing:
	.dsb 1 ; $009d
; This (unused?) counter increments as long as the player is standing on an
; object, including a couple frames while lifting an object.
	.dsb 1 ; $009e
zObjectAnimTimer:
	.dsb 1 ; $009f
	.dsb 1 ; $00a0
	.dsb 1 ; $00a1
	.dsb 1 ; $00a2
	.dsb 1 ; $00a3
	.dsb 1 ; $00a4
	.dsb 1 ; $00a5
	.dsb 1 ; $00a6
	.dsb 1 ; $00a7

; Set to 7 when lifting, then stays at 1
; Note that this doesn't seem to actually
; make you carry an item, it just THINKS
; it's being carried.
zHeldObjectTimer:
	.dsb 1 ; $00a8
	.dsb 1 ; $00a9
	.dsb 1 ; $00aa
	.dsb 1 ; $00ab
	.dsb 1 ; $00ac
	.dsb 1 ; $00ad
	.dsb 1 ; $00ae
	.dsb 1 ; $00af
	.dsb 1 ; $00b0

zEnemyArray:
	.dsb 1 ; $00b1
	.dsb 1 ; $00b2
	.dsb 1 ; $00b3
	.dsb 1 ; $00b4
	.dsb 1 ; $00b5
	.dsb 1 ; $00b6
	.dsb 1 ; $00b7
	.dsb 1 ; $00b8
	.dsb 1 ; $00b9

; Number of pixels to shift the camera on the next frame to get to its "ideal"
; position. The left/right bounds of the area will overrule this.
zXVelocity:
	.dsb 1 ; $00ba
zCurrentMusicPointer:
	.dsb 2 ; $00bb
zNextNoteLo:
	.dsb 1 ; $00bd
zNextNoteHi:
	.dsb 1 ; $00be
; $00BF and $00C0 are never written, but referenced by the music engine.
; Seems like they were intended to be either instrument start offets or
; duty/volume/envelope for the square channels, but it's not totally clear
; from the code, and doesn't actually function as written?
zPulseInsSize: ; (unused; read but never initialized)
	.dsb 1 ; $00bf
zPulseEnv: ; (unused; always overwritten)
	.dsb 1 ; $00c0
zPulse2Index:
	.dsb 1 ; $00c1
zPulse2RawPitch: ; (unused)
	.dsb 1 ; $00c2
zNoiseSFXOffset:
	.dsb 1 ; $00c3
zPulse1Timer:
	.dsb 1 ; $00c4
zNoiseIndexPointer:
	.dsb 2 ; $00c5
zPlayerAnimFrame:
	.dsb 1 ; $00c7
zYScrollPage:
	.dsb 1 ; $00c8
zXScrollPage:
	.dsb 1 ; $00c9
; Not sure about this, but seems to be that way
zScreenYPage:
	.dsb 1 ; $00ca
; Not sure about this either
zScreenY:
	.dsb 1 ; $00cb

zRawSpriteData:
	.dsb 1 ; $00cc
	.dsb 1 ; $00cd

; Drawing boundary table, used when scrolling in either direction
; - Upper nybble: tile offset (columns/rows)
; - Lower nybble indicates the page
zBGBuffer: ; full draw
	.dsb 1 ; $00ce
zBGBufferBackward: ; left/top
	.dsb 1 ; $00cf
zBGBufferForward: ; right/bottom
	.dsb 1 ; $00d0
zBigPPUDrawer:
	.dsb 1 ; $00d1
	.dsb 1 ; $00d2
zPPUDrawerRemains:
	.dsb 1 ; $00d3
zPPUDrawerOffset:
	.dsb 1 ; $00d4
zd5:
	.dsb 1 ; $00d5
zBGBufferSize:
	.dsb 1 ; $00d6
zLevelDataOffset:
	.dsb 1 ; $00d7

;
; %xxxxxADD
;
; - A = screen interval scrolling is active (vertical levels)
; - D = direction ($00 = none, $01 = up/left, $02 = down/right)
;
zScrollArray:
	.dsb 1 ; $00d8
; Attribute data to use for the background tiles scrolling into view.
; For vertical, this covers four rows of tiles, right-to-left.
; For horizontal area, this covers four columns of tiles, bottom-to-top.
zScrollBuffer:
	.dsb 1 ; $00d9
	.dsb 1 ; $00da
	.dsb 1 ; $00db
	.dsb 1 ; $00dc
	.dsb 1 ; $00dd
	.dsb 1 ; $00de
	.dsb 1 ; $00df
	.dsb 1 ; $00e0
; Attributes update up
ze1:
	.dsb 1 ; $00e1
; Attributes update down
ze2:
	.dsb 1 ; $00e2
zAttrUpdateIndex:
	.dsb 1 ; $00e3
ze4:
	.dsb 1 ; $00e4
ze5:
	.dsb 1 ; $00e5
ze6:
	.dsb 1 ; $00e6
ze7:
	.dsb 1 ; $00e7
ze8:
	.dsb 1 ; $00e8
zLevelDataPointer:
	.dsb 1 ; $00e9
	.dsb 1 ; $00ea
zNMIOccurred:
	.dsb 1 ; $00eb
zScrollCondition:
	.dsb 1 ; $00ec
zed:
	.dsb 1 ; $00ed
zee:
	.dsb 1 ; $00ee
zef:
	.dsb 1 ; $00ef
; Set this to the location of PPU data to be drawn
; to the screen (somehow).
;
; Common value of $0301, which is where minor
; PPU updates are stored in memory.
zPPUDataBufferPointer:
	.dsb 2 ; $00f0
zf2:
	.dsb 1 ; $00f2
zf3:
	.dsb 1 ; $00f3
zf4:
	.dsb 1 ; $00f4
zInputBottleneck:
	.dsb 1 ; $00f5
	.dsb 1 ; $00f6
zInputCurrentState:
	.dsb 1 ; $00f7
	.dsb 1 ; $00f8
	.dsb 1 ; $00f9
	.dsb 1 ; $00fa
	.dsb 1 ; $00fb
zPPUScrollY:
	.dsb 1 ; $00fc
zPPUScrollX:
	.dsb 1 ; $00fd
zPPUMask:
	.dsb 1 ; $00fe
zPPUControl:
	.dsb 1 ; $00ff


iStack:
	.dsb $100   ; $0100 - $01FF

iVirtualOAM:
	.dsb $100   ; $0200 - $02FF

;
; Arbitrary PPU updates happen using the buffer at RAM $0301 when `ScreenUpdateIndex` is zero.
; In that case, `UpdatePPUFromBufferNMI` will read whatever is in this buffer and update the PPU.
; When there is nothing to update, the first byte is `$00`, which will cause it to exit.
;
; $0300 is used as an offset when writing to the buffer, which allows multiple updates to write to
; the buffer without overwriting each other.
;
i300:
	.dsb 1 ; $0300
iPPUBuffer:
	.dsb 1 ; $0301
	.dsb 1 ; $0302
	.dsb 1 ; $0303
	.dsb 1 ; $0304
	.dsb 1 ; $0305
	.dsb 1 ; $0306
	.dsb 1 ; $0307
	.dsb 1 ; $0308
	.dsb 1 ; $0309
	.dsb 1 ; $030a
	.dsb 1 ; $030b
	.dsb 1 ; $030c
	.dsb 1 ; $030d
	.dsb 1 ; $030e
	.dsb 1 ; $030f
	.dsb 1 ; $0310
	.dsb 1 ; $0311
	.dsb 1 ; $0312
	.dsb 1 ; $0313
	.dsb 1 ; $0314
	.dsb 1 ; $0315
	.dsb 1 ; $0316
	.dsb 1 ; $0317
	.dsb 1 ; $0318
	.dsb 1 ; $0319
	.dsb 1 ; $031a
	.dsb 1 ; $031b
	.dsb 1 ; $031c
	.dsb 1 ; $031d
	.dsb 1 ; $031e
	.dsb 1 ; $031f
	.dsb 1 ; $0320
	.dsb 1 ; $0321
	.dsb 1 ; $0322
	.dsb 1 ; $0323
	.dsb 1 ; $0324
	.dsb 1 ; $0325
	.dsb 1 ; $0326
	.dsb 1 ; $0327
	.dsb 1 ; $0328
	.dsb 1 ; $0329
	.dsb 1 ; $032a
	.dsb 1 ; $032b
	.dsb 1 ; $032c
	.dsb 1 ; $032d
	.dsb 1 ; $032e
	.dsb 1 ; $032f
	.dsb 1 ; $0330
	.dsb 1 ; $0331
	.dsb 1 ; $0332
	.dsb 1 ; $0333
	.dsb 1 ; $0334
	.dsb 1 ; $0335
	.dsb 1 ; $0336
	.dsb 1 ; $0337
	.dsb 1 ; $0338
	.dsb 1 ; $0339
	.dsb 1 ; $033a
	.dsb 1 ; $033b
	.dsb 1 ; $033c
	.dsb 1 ; $033d
	.dsb 1 ; $033e
	.dsb 1 ; $033f
	.dsb 1 ; $0340
	.dsb 1 ; $0341
	.dsb 1 ; $0342
	.dsb 1 ; $0343
	.dsb 1 ; $0344
	.dsb 1 ; $0345
	.dsb 1 ; $0346
	.dsb 1 ; $0347
	.dsb 1 ; $0348
	.dsb 1 ; $0349
	.dsb 1 ; $034a
	.dsb 1 ; $034b
	.dsb 1 ; $034c
	.dsb 1 ; $034d
	.dsb 1 ; $034e
	.dsb 1 ; $034f
	.dsb 1 ; $0350
	.dsb 1 ; $0351
	.dsb 1 ; $0352
	.dsb 1 ; $0353
	.dsb 1 ; $0354
	.dsb 1 ; $0355
	.dsb 1 ; $0356
	.dsb 1 ; $0357
	.dsb 1 ; $0358
	.dsb 1 ; $0359
	.dsb 1 ; $035a
	.dsb 1 ; $035b
	.dsb 1 ; $035c
	.dsb 1 ; $035d
	.dsb 1 ; $035e
	.dsb 1 ; $035f
	.dsb 1 ; $0360
	.dsb 1 ; $0361
	.dsb 1 ; $0362
	.dsb 1 ; $0363
	.dsb 1 ; $0364
	.dsb 1 ; $0365
	.dsb 1 ; $0366
	.dsb 1 ; $0367
	.dsb 1 ; $0368
	.dsb 1 ; $0369
	.dsb 1 ; $036a
	.dsb 1 ; $036b
	.dsb 1 ; $036c
	.dsb 1 ; $036d
	.dsb 1 ; $036e
	.dsb 1 ; $036f
	.dsb 1 ; $0370
	.dsb 1 ; $0371
	.dsb 1 ; $0372
	.dsb 1 ; $0373
	.dsb 1 ; $0374
	.dsb 1 ; $0375
	.dsb 1 ; $0376
	.dsb 1 ; $0377
	.dsb 1 ; $0378
	.dsb 1 ; $0379
	.dsb 1 ; $037a
	.dsb 1 ; $037b
	.dsb 1 ; $037c
	.dsb 1 ; $037d
	.dsb 1 ; $037e
	.dsb 1 ; $037f
iScrollTileBuffer:
	.dsb 1 ; $0380
	.dsb 1 ; $0381
	.dsb 1 ; $0382
	.dsb 1 ; $0383
	.dsb 1 ; $0384
	.dsb 1 ; $0385
	.dsb 1 ; $0386
	.dsb 1 ; $0387
	.dsb 1 ; $0388
	.dsb 1 ; $0389
	.dsb 1 ; $038a
	.dsb 1 ; $038b
	.dsb 1 ; $038c
	.dsb 1 ; $038d
	.dsb 1 ; $038e
	.dsb 1 ; $038f
	.dsb 1 ; $0390
	.dsb 1 ; $0391
	.dsb 1 ; $0392
	.dsb 1 ; $0393
	.dsb 1 ; $0394
	.dsb 1 ; $0395
	.dsb 1 ; $0396
	.dsb 1 ; $0397
	.dsb 1 ; $0398
	.dsb 1 ; $0399
	.dsb 1 ; $039a
	.dsb 1 ; $039b
	.dsb 1 ; $039c
	.dsb 1 ; $039d
	.dsb 1 ; $039e
	.dsb 1 ; $039f
	.dsb 1 ; $03a0
	.dsb 1 ; $03a1
	.dsb 1 ; $03a2
	.dsb 1 ; $03a3
	.dsb 1 ; $03a4
	.dsb 1 ; $03a5
	.dsb 1 ; $03a6
	.dsb 1 ; $03a7
	.dsb 1 ; $03a8
	.dsb 1 ; $03a9
	.dsb 1 ; $03aa
	.dsb 1 ; $03ab
	.dsb 1 ; $03ac
	.dsb 1 ; $03ad
	.dsb 1 ; $03ae
	.dsb 1 ; $03af
	.dsb 1 ; $03b0
	.dsb 1 ; $03b1
	.dsb 1 ; $03b2
	.dsb 1 ; $03b3
	.dsb 1 ; $03b4
	.dsb 1 ; $03b5
	.dsb 1 ; $03b6
	.dsb 1 ; $03b7
	.dsb 1 ; $03b8
	.dsb 1 ; $03b9
	.dsb 1 ; $03ba
	.dsb 1 ; $03bb

; Used for scrolling in horizontal levels
iBigDrawerAttrPointer:
	.dsb 1 ; $03bc
	.dsb 1 ; $03bd
; Attribute data to use for the background tiles scrolling into view in
; horizontal areas.
iHorScrollBuffer:
	.dsb 1 ; $03be
	.dsb 1 ; $03bf
	.dsb 1 ; $03c0
	.dsb 1 ; $03c1
	.dsb 1 ; $03c2
	.dsb 1 ; $03c3
	.dsb 1 ; $03c4
	.dsb 1 ; $03c5

	.dsb 1 ; $03c6
	.dsb 1 ; $03c7
	.dsb 1 ; $03c8
	.dsb 1 ; $03c9
	.dsb 1 ; $03ca
	.dsb 1 ; $03cb
	.dsb 1 ; $03cc
	.dsb 1 ; $03cd
	.dsb 1 ; $03ce
	.dsb 1 ; $03cf
	.dsb 1 ; $03d0
	.dsb 1 ; $03d1
	.dsb 1 ; $03d2
	.dsb 1 ; $03d3
	.dsb 1 ; $03d4
	.dsb 1 ; $03d5
	.dsb 1 ; $03d6
	.dsb 1 ; $03d7
	.dsb 1 ; $03d8
	.dsb 1 ; $03d9
	.dsb 1 ; $03da
	.dsb 1 ; $03db
	.dsb 1 ; $03dc
	.dsb 1 ; $03dd
	.dsb 1 ; $03de
	.dsb 1 ; $03df
	.dsb 1 ; $03e0
	.dsb 1 ; $03e1
	.dsb 1 ; $03e2
	.dsb 1 ; $03e3
	.dsb 1 ; $03e4
	.dsb 1 ; $03e5
	.dsb 1 ; $03e6
	.dsb 1 ; $03e7
	.dsb 1 ; $03e8
	.dsb 1 ; $03e9
	.dsb 1 ; $03ea
	.dsb 1 ; $03eb
	.dsb 1 ; $03ec
	.dsb 1 ; $03ed
	.dsb 1 ; $03ee
	.dsb 1 ; $03ef
	.dsb 1 ; $03f0
	.dsb 1 ; $03f1
	.dsb 1 ; $03f2
	.dsb 1 ; $03f3
	.dsb 1 ; $03f4
	.dsb 1 ; $03f5
	.dsb 1 ; $03f6
	.dsb 1 ; $03f7
	.dsb 1 ; $03f8
	.dsb 1 ; $03f9
	.dsb 1 ; $03fa
	.dsb 1 ; $03fb
	.dsb 1 ; $03fc
	.dsb 1 ; $03fd
	.dsb 1 ; $03fe
	.dsb 1 ; $03ff
iObjectFlickerer:
	.dsb 1 ; $0400

; FOR RENT
	.dsb 1 ; $0401
; FOR RENT
	.dsb 1 ; $0402
; FOR RENT
	.dsb 1 ; $0403
; unused? written but never read
iCHRBackup:
	.dsb 1 ; $0404
; unused? written but never read
iWorldBackup:
	.dsb 1 ; $0405
; FOR RENT
	.dsb 1 ; $0406

iPlayerXSubpixel:
	.dsb 1 ; $0407
iObjectXSubpixel:
	.dsb 1 ; $0408
	.dsb 1 ; $0409
	.dsb 1 ; $040a
	.dsb 1 ; $040b
	.dsb 1 ; $040c
	.dsb 1 ; $040d
	.dsb 1 ; $040e
	.dsb 1 ; $040f
	.dsb 1 ; $0410

iPlayerYSubpixel:
	.dsb 1 ; $0411
iObjectYSubpixel:
	.dsb 1 ; $0412
	.dsb 1 ; $0413
	.dsb 1 ; $0414
	.dsb 1 ; $0415
	.dsb 1 ; $0416
	.dsb 1 ; $0417
	.dsb 1 ; $0418
	.dsb 1 ; $0419
	.dsb 1 ; $041a

iPlayerLock:
	.dsb 1 ; $041b
iObjectLock:
	.dsb 1 ; $041c
	.dsb 1 ; $041d
	.dsb 1 ; $041e
	.dsb 1 ; $041f
	.dsb 1 ; $0420
	.dsb 1 ; $0421
	.dsb 1 ; $0422
	.dsb 1 ; $0423
	.dsb 1 ; $0424

; $00 = none, $01 = up, $02 = down
iVerticalScrollVelocity:
	.dsb 1 ; $0425
; Distance between bounding boxes during the last check
iCollisionResultX:
	.dsb 1 ; $0426
iCollisionResultY:
	.dsb 1 ; $0427
iPlayerScreenX:
	.dsb 1 ; $0428
iSpriteTempScreenX:
	.dsb 1 ; $0429
iPlayerScreenYPage:
	.dsb 1 ; $042a
iPlayerScreenY:
	.dsb 1 ; $042b
iSpriteTempScreenY:
	.dsb 1 ; $042c
iHeldItemIndex:
	.dsb 1 ; $042d

; FOR RENT
	.dsb 1 ; $042e
iObjectBulletTimer:
	.dsb 1 ; $042f
	.dsb 1 ; $0430
	.dsb 1 ; $0431
	.dsb 1 ; $0432
	.dsb 1 ; $0433
	.dsb 1 ; $0434
	.dsb 1 ; $0435
	.dsb 1 ; $0436

; FOR RENT
	.dsb 1 ; $0437
iObjectStunTimer:
	.dsb 1 ; $0438
	.dsb 1 ; $0439
	.dsb 1 ; $043a
	.dsb 1 ; $043b
	.dsb 1 ; $043c
	.dsb 1 ; $043d
	.dsb 1 ; $043e
	.dsb 1 ; $043f

; FOR RENT
	.dsb 1 ; $0440
; Raw enemy data offset used to prevent enemy from spawning multiple times.
; A value of `$FF` indicates that the enemy is not linked to any particular level data.
iEnemyRawDataOffset:
	.dsb 1 ; $0441
	.dsb 1 ; $0442
	.dsb 1 ; $0443
	.dsb 1 ; $0444
	.dsb 1 ; $0445
	.dsb 1 ; $0446
	.dsb 1 ; $0447
	.dsb 1 ; $0448

; FOR RENT
	.dsb 1 ; $0449
iObjectShakeTimer:
	.dsb 1 ; $044a
	.dsb 1 ; $044b
	.dsb 1 ; $044c
	.dsb 1 ; $044d
	.dsb 1 ; $044e
	.dsb 1 ; $044f
	.dsb 1 ; $0450
	.dsb 1 ; $0451

; FOR RENT
	.dsb 1 ; $0452
iSpriteTimer:
	.dsb 1 ; $0453
	.dsb 1 ; $0454
	.dsb 1 ; $0455
	.dsb 1 ; $0456
	.dsb 1 ; $0457
	.dsb 1 ; $0458
	.dsb 1 ; $0459
	.dsb 1 ; $045a

; FOR RENT
	.dsb 1 ; $045b
; Flashing timer
iObjectFlashTimer:
	.dsb 1 ; $045c
	.dsb 1 ; $045d
	.dsb 1 ; $045e
	.dsb 1 ; $045f
	.dsb 1 ; $0460
	.dsb 1 ; $0461
	.dsb 1 ; $0462
	.dsb 1 ; $0463

; FOR RENT
	.dsb 1 ; $0464
iEnemyHP:
	.dsb 1 ; $0465
	.dsb 1 ; $0466
	.dsb 1 ; $0467
	.dsb 1 ; $0468
	.dsb 1 ; $0469
	.dsb 1 ; $046a
	.dsb 1 ; $046b
	.dsb 1 ; $046c

	.dsb 1 ; $046d
i46e:
	.dsb 1 ; $046e
	.dsb 1 ; $046f
	.dsb 1 ; $0470
	.dsb 1 ; $0471
	.dsb 1 ; $0472
	.dsb 1 ; $0473
	.dsb 1 ; $0474
	.dsb 1 ; $0475

; FOR RENT
	.dsb 1 ; $0476
i477:
	.dsb 1 ; $0477
	.dsb 1 ; $0478
	.dsb 1 ; $0479
	.dsb 1 ; $047a
	.dsb 1 ; $047b
	.dsb 1 ; $047c
	.dsb 1 ; $047d
	.dsb 1 ; $047e

; FOR RENT
	.dsb 1 ; $047f
i480:
	.dsb 1 ; $0480
	.dsb 1 ; $0481
	.dsb 1 ; $0482
	.dsb 1 ; $0483
	.dsb 1 ; $0484
	.dsb 1 ; $0485
	.dsb 1 ; $0486
	.dsb 1 ; $0487
	.dsb 1 ; $0488

iObjectHitbox:
	.dsb 1 ; $0489
	.dsb 1 ; $048a
	.dsb 1 ; $048b
	.dsb 1 ; $048c
	.dsb 1 ; $048d
	.dsb 1 ; $048e
	.dsb 1 ; $048f
	.dsb 1 ; $0490

	.dsb 1 ; $0491
i492:
	.dsb 1 ; $0492
	.dsb 1 ; $0493
	.dsb 1 ; $0494
	.dsb 1 ; $0495
	.dsb 1 ; $0496
	.dsb 1 ; $0497
	.dsb 1 ; $0498
	.dsb 1 ; $0499

; FOR RENT
	.dsb 1 ; $049a
iLocalBossArray:
	.dsb 1 ; $049b
	.dsb 1 ; $049c
	.dsb 1 ; $049d
	.dsb 1 ; $049e
	.dsb 1 ; $049f
	.dsb 1 ; $04a0
	.dsb 1 ; $04a1
	.dsb 1 ; $04a2

; FOR RENT
	.dsb 1 ; $04a3
; When set, the player will not move with the object while standing on it
iObjectNonSticky:
	.dsb 1 ; $04a4
	.dsb 1 ; $04a5
	.dsb 1 ; $04a6
	.dsb 1 ; $04a7
	.dsb 1 ; $04a8
	.dsb 1 ; $04a9
	.dsb 1 ; $04aa
	.dsb 1 ; $04ab

; FOR RENT
	.dsb 1 ; $04ac
iKills:
	.dsb 1 ; $04ad
iAreaInitFlag:
	.dsb 1 ; $04ae
iObjectToUseNextRoom:
	.dsb 1 ; $04af
iKeyUsed:
	.dsb 1 ; $04b0
; FOR RENT
	.dsb 1 ; $04b1
iIsRidingCarpet:
	.dsb 1 ; $04b2
iSubDoorTimer:
	.dsb 1 ; $04b3
; Probably set to 1 when Hawkmouth eats the player and starts closing
iMaskClosingFlag:
	.dsb 1 ; $04b4
; Set to 01 on crystal get, Hawkmouth opens to 30
iMaskDoorOpenFlag:
	.dsb 1 ; $04b5
; Hawkmouth won't start opening until this hits 0
iMaskPreamble:
	.dsb 1 ; $04b6
iSubTimeLeft:
	.dsb 1 ; $04b7
iVictory:
	.dsb 1 ; $04b8
iSwarmType:
	.dsb 1 ; $04b9
; FOR RENT
	.dsb 1 ; $04ba
; FOR RENT
	.dsb 1 ; $04bb
iSkyColor:
	.dsb 1 ; $04bc
iDoorAnimTimer:
	.dsb 1 ; $04bd
iBoundLeftUpper:
	.dsb 1 ; $04be
iBoundRightUpper:
	.dsb 1 ; $04bf
iBoundLeftLower:
	.dsb 1 ; $04c0
iBoundRightLower:
	.dsb 1 ; $04c1
; xF: Hearts - 1 ($0F=1HP, $1F=2HP, etc)
iPlayerHP:
	.dsb 1 ; $04c2
; $00: Max 2
; $01: Max 3
; $02: Max 4
iPlayerMaxHP:
	.dsb 1 ; $04c3
iPOWTimer:
	.dsb 1 ; $04c4
iBGYOffset:
	.dsb 1 ; $04c5
iSkyFlashTimer:
	.dsb 1 ; $04c6
iIsInRocket:
	.dsb 1 ; $04c7
	.dsb 1 ; $04c8
iFloatTimer:
	.dsb 1 ; $04c9
iCrouchJumpTimer:
	.dsb 1 ; $04ca

iPlayerXVelocity:
	.dsb 1 ; $04cb
iObjectXVelocity:
	.dsb 1 ; $04cc
	.dsb 1 ; $04cd
	.dsb 1 ; $04ce
	.dsb 1 ; $04cf
	.dsb 1 ; $04d0
	.dsb 1 ; $04d1
	.dsb 1 ; $04d2
	.dsb 1 ; $04d3

; FOR RENT
	.dsb 1 ; $04d4
iPlayerYVelocity:
	.dsb 1 ; $04d5
iObjectYVelocity:
	.dsb 1 ; $04d6
	.dsb 1 ; $04d7
	.dsb 1 ; $04d8
	.dsb 1 ; $04d9
	.dsb 1 ; $04da
	.dsb 1 ; $04db
	.dsb 1 ; $04dc
	.dsb 1 ; $04dd

; FOR RENT
	.dsb 1 ; $04de
iQuicksandDepth:
	.dsb 1 ; $04df
iStarTimer:
	.dsb 1 ; $04e0
iPlayer_X_Lo_Init:
	.dsb 1 ; $04e1
iPlayer_Y_Lo_Init:
	.dsb 1 ; $04e2
iPlayerScreenX_Init:
	.dsb 1 ; $04e3
iPlayerScreenY_Init:
	.dsb 1 ; $04e4
iPlayer_Y_Velocity_Init:
	.dsb 1 ; $04e5
iPlayer_State_Init:
	.dsb 1 ; $04e6
iCurrentLevel_Init:
	.dsb 1 ; $04e7
iCurrentLevelArea_Init:
	.dsb 1 ; $04e8
iCurrentLevelEntryPage_Init:
	.dsb 1 ; $04e9
iTransitionType_Init:
	.dsb 1 ; $04ea
; something to do with sinking in quicksand
i4eb:
	.dsb 1 ; $04eb
; $00: In game
; $01: Level title card
; $02: Game over
; $03: Bonus chance
; $04+: Warp
iGameMode:
	.dsb 1 ; $04ec
iExtraMen:
	.dsb 1 ; $04ed
; $00: None
; $01: Default jar
; $02: Pointer jar
iInJarType:
	.dsb 1 ; $04ee
iEndOfLevelDoorPage:
	.dsb 1 ; $04ef
	.dsb 1 ; $04f0
	.dsb 1 ; $04f1
	.dsb 1 ; $04f2
	.dsb 1 ; $04f3
	.dsb 1 ; $04f4
	.dsb 1 ; $04f5
	.dsb 1 ; $04f6
	.dsb 1 ; $04f7
iFryguySplitFlames:
	.dsb 1 ; $04f8
iVeggieShotCounter:
	.dsb 1 ; $04f9
iScrollXLock:
	.dsb 1 ; $04fa
iMushroomFlags:
	.dsb 1 ; $04fb
	.dsb 1 ; $04fc
iPokeyTempScreenX:
	.dsb 1 ; $04fd
; FOR RENT
	.dsb 1 ; $04fe
iWatchTimer: ; $ff (normal), $1ff (testing)
	.dsb 2 ; $04ff
; FOR RENT
	.dsb 1 ; $0501
; Flag enabled while the area is rendering on initialization
i502:
	.dsb 1 ; $0502
; FOR RENT
	.dsb 1 ; $0503
iCameraOSTiles:
	.dsb 1 ; $0504
i505:
	.dsb 1 ; $0505
iPPUBigScrollCheck:
	.dsb 2 ; $0506
; FOR RENT
	.dsb 1 ; $0508
iPPUScrollY:
	.dsb 1 ; $0509
iPPUScrollX:
	.dsb 1 ; $050a
iYScrollPage:
	.dsb 1 ; $050b
iXScrollPage:
	.dsb 1 ; $050c
i50d:
	.dsb 1 ; $050d
i50e:
	.dsb 1 ; $050e
iPlayerXHi:
	.dsb 1 ; $050f
iPlayerYHi:
	.dsb 1 ; $0510
iPlayer_X_Lo:
	.dsb 1 ; $0511
iPlayerYLoBackup:
	.dsb 1 ; $0512
iScreenYPage:
	.dsb 1 ; $0513
iBoundLeftUpper_Backup:
	.dsb 1 ; $0514
iScreenY:
	.dsb 1 ; $0515
; FOR RENT
	.dsb 1 ; $0516
i517:
	.dsb 1 ; $0517
; FOR RENT
	.dsb 1 ; $0518
iCurrentAreaBackup:
	.dsb 1 ; $0519
; FOR RENT
	.dsb 1 ; $051a
iTileID:
	.dsb 1 ; $051b
iScrollUpdateQueue:
	.dsb 1 ; $051c
iAreaAddresses:
	.dsb $14 ; $051d
iCurrentLvl:
	.dsb 1 ; $0531
iCurrentLvlArea:
	.dsb 1 ; $0532
iCurrentLvlEntryPage:
	.dsb 1 ; $0533
iTransitionType:
	.dsb 1 ; $0534
	; Seems to be set depending on how you transitioned areas last.
	; $00 = ? (Start of level?)
	; $01 = Door
	; $02 = Jar
	; $03 = Vine
iCurrentLvlPage:
	.dsb 1 ; $0535
iCurrentLvlPageX:
	.dsb 1 ; $0536
; Flag to break out of the area's initial PPU draw loop?
i537:
	.dsb 1 ; $0537
; $00 = none, $01 = left, $02 = right
iHorScrollDir:
	.dsb 1 ; $0538
iBottomRowField: ; Bottom PPU row is 16px instead of 32px
	.dsb 1 ; $0539
; Flag to enable redrawing the background?
i53a:
	.dsb 1 ; $053a
	.dsb 1 ; $053b
	.dsb 1 ; $053c
i53d:
	.dsb 1 ; $053d
i53e:
	.dsb 1 ; $053e
iCurrentLvlPages:
	.dsb 1 ; $053f
i540:
	.dsb 1 ; $0540
iGroundSetting:
	.dsb 1 ; $0541
; area object type xxOO
iSpriteTypeLo:
	.dsb 1 ; $0542
; area object type OOxx
iSpriteTypeHi:
	.dsb 1 ; $0543
iLevelMusic:
	.dsb 1 ; $0544
iMusicID:
	.dsb 1 ; $0545

iStatsRAM:
iPickupSpeed:
	.dsb 1 ; $0546
	.dsb 1 ; 1                ; $0547
	.dsb 1 ; 2                ; $0548
	.dsb 1 ; 3                ; $0549
	.dsb 1 ; 4                ; $054a
	.dsb 1 ; 5                ; $054b
iMainJumpHeights:
	.dsb 1 ; $054c
	.dsb 1 ; $054d
	.dsb 1 ; $054e
	.dsb 1 ; $054f
	.dsb 1 ; $0550
	.dsb 1 ; $0551
iSinkingJumpHeight:
	.dsb 1 ; $0552
iFloatLength:
	.dsb 1 ; $0553
iGravities:
	.dsb 1 ; $0554
	.dsb 1 ; $0555
	.dsb 1 ; $0556
iRunSpeeds:
	.dsb 1 ; $0557
	.dsb 1 ; $0558
	.dsb 1 ; $0559
	.dsb 1 ; $055a
	.dsb 1 ; $055b
	.dsb 1 ; $055c
; FOR RENT
	.dsb 1 ; $055d
iSurface:
	.dsb 1 ; $055e
iStartingPalettes:
	.dsb 1 ; $055f
	.dsb 1 ; $0560
	.dsb 1 ; $0561
	.dsb 1 ; $0562
	.dsb 1 ; $0563
	.dsb 1 ; $0564
	.dsb 1 ; $0565
	.dsb 1 ; $0566
	.dsb 1 ; $0567
	.dsb 1 ; $0568
	.dsb 1 ; $0569
	.dsb 1 ; $056a
	.dsb 1 ; $056b
	.dsb 1 ; $056c
	.dsb 1 ; $056d
	.dsb 1 ; $056e
	.dsb 1 ; $056f
	.dsb 1 ; $0570
	.dsb 1 ; $0571
	.dsb 1 ; $0572
	.dsb 1 ; $0573
	.dsb 1 ; $0574
	.dsb 1 ; $0575
	.dsb 1 ; $0576
	.dsb 1 ; $0577
	.dsb 1 ; $0578
	.dsb 1 ; $0579
	.dsb 1 ; $057a
	.dsb 1 ; $057b
	.dsb 1 ; $057c
	.dsb 1 ; $057d
	.dsb 1 ; $057e
	.dsb 1 ; $057f
	.dsb 1 ; $0580
	.dsb 1 ; $0581
	.dsb 1 ; $0582
iBonusNotes:
	.dsb 1 ; $0583
	.dsb 1 ; $0584
	.dsb 1 ; $0585
	.dsb 1 ; $0586
	.dsb 1 ; $0587
i588:
	.dsb 1 ; $0588
	.dsb 1 ; $0589
	.dsb 1 ; $058a
	.dsb 1 ; $058b
	.dsb 1 ; $058c
	.dsb 1 ; $058d
	.dsb 1 ; $058e
	.dsb 1 ; $058f
	.dsb 1 ; $0590
	.dsb 1 ; $0591
	.dsb 1 ; $0592
	.dsb 1 ; $0593
	.dsb 1 ; $0594
	.dsb 1 ; $0595
	.dsb 1 ; $0596
	.dsb 1 ; $0597
	.dsb 1 ; $0598
i599:
	.dsb 1 ; $0599
i59a:
	.dsb 1 ; $059a
	.dsb 1 ; $059b
i59C:
	.dsb 1 ; $059c
	.dsb 1 ; $059d
	.dsb 1 ; $059e
	.dsb 1 ; $059f
	.dsb 1 ; $05a0
	.dsb 1 ; $05a1
	.dsb 1 ; $05a2
	.dsb 1 ; $05a3
	.dsb 1 ; $05a4
	.dsb 1 ; $05a5
	.dsb 1 ; $05a6
	.dsb 1 ; $05a7
	.dsb 1 ; $05a8
	.dsb 1 ; $05a9
	.dsb 1 ; $05aa
	.dsb 1 ; $05ab

iPRNGSeed:
	.dsb 1 ; $05ac
	.dsb 1 ; $05ad
iPRNGValue:
	.dsb 1 ; $05ae
	.dsb 1 ; $05af

	.dsb 1 ; $05b0
	.dsb 1 ; $05b1
	.dsb 1 ; $05b2
	.dsb 1 ; $05b3
	.dsb 1 ; $05b4
	.dsb 1 ; $05b5
	.dsb 1 ; $05b6
	.dsb 1 ; $05b7
	.dsb 1 ; $05b8
	.dsb 1 ; $05b9
; initialized but never used?
i5ba:
	.dsb 1 ; $05ba
; set to $10 if a subspace door is ever created, but never used?
i5bb:
	.dsb 1 ; $05bb
iPhantoTimer:
	.dsb 1 ; $05bc
iCardScreenID:
	.dsb 1 ; $05bd
iContributors:
	.dsb 1 ; $05be
	.dsb 1 ; $05bf
	.dsb 1 ; $05c0
	.dsb 1 ; $05c1
iNumContributions:
	.dsb 1 ; $05c2
iContributorID:
	.dsb 1 ; $05c3
iContributorTimer:
	.dsb 1 ; $05c4
iNumContinues:
	.dsb 1 ; $05c5

; FOR RENT
	.dsb 1 ; $05c6
	.dsb 1 ; $05c7
	.dsb 1 ; $05c8
	.dsb 1 ; $05c9
	.dsb 1 ; $05ca
	.dsb 1 ; $05cb
	.dsb 1 ; $05cc
	.dsb 1 ; $05cd
	.dsb 1 ; $05ce
	.dsb 1 ; $05cf
	.dsb 1 ; $05d0
	.dsb 1 ; $05d1
	.dsb 1 ; $05d2
	.dsb 1 ; $05d3
	.dsb 1 ; $05d4
	.dsb 1 ; $05d5
	.dsb 1 ; $05d6
	.dsb 1 ; $05d7
	.dsb 1 ; $05d8
	.dsb 1 ; $05d9
	.dsb 1 ; $05da
	.dsb 1 ; $05db
	.dsb 1 ; $05dc
	.dsb 1 ; $05dd
	.dsb 1 ; $05de
	.dsb 1 ; $05df
	.dsb 1 ; $05e0
	.dsb 1 ; $05e1
	.dsb 1 ; $05e2
	.dsb 1 ; $05e3
	.dsb 1 ; $05e4
	.dsb 1 ; $05e5
	.dsb 1 ; $05e6
	.dsb 1 ; $05e7
	.dsb 1 ; $05e8
	.dsb 1 ; $05e9
	.dsb 1 ; $05ea
	.dsb 1 ; $05eb

iCurrentMusicOffset:
	.dsb 1 ; $05ec
iPulse1NoteLength:
	.dsb 1 ; $05ed
iMusicStartPoint:
	.dsb 1 ; $05ee
iMusicEndPoint:
	.dsb 1 ; $05ef
iMusicLoopPoint:
	.dsb 1 ; $05f0
iPulse2Ins:
	.dsb 1 ; $05f1
iPulse1Ins:
	.dsb 1 ; $05f2
iMusicStack:
	.dsb 1 ; $05f3
iOctave:
	.dsb 1 ; $05f4
iCurrentNoiseStartPoint:
	.dsb 1 ; $05f5
; FOR RENT
	.dsb 1 ; $05f6
	.dsb 1 ; $05f7
	.dsb 1 ; $05f8
iPulse1Lo:
	.dsb 1 ; $05f9 (unused; written to but not read)
iDPCMNoteLengthCounter:
	.dsb 1 ; $05fa
iDPCMNoteLength:
	.dsb 1 ; $05fb
iCurrentDPCMStartPoint:
	.dsb 1 ; $05fc
	.dsb 1 ; $05fd (unused; written to but not read)
	.dsb 1 ; $05fe
iCurrentDPCMOffset:
	.dsb 1 ; $05ff

; #01 Outside
; #02 CHR Select
; #04 Inside
; #08 Boss
; #10 Starman
; #20 Subspace
; #40 Wart
; #80 Title
iMusic1:
	.dsb 1 ; $0600

; $01 Door
; $02 Bongo A
; $04 Injury
; $08 Hold
; $10 Defeat
; $20 Bongo B
; $40 Squawk
; $80 Down
iDPCMSFX1:
	.dsb 1 ; $0601

; $01 Shot
; $02 Lamp
; $04 Select
; $08 Throw
; $10 Extra
; $20 Impact
; $40 Watch
; $80 Exit
iDPCMSFX2:
	.dsb 1 ; $0602

; $01 Warp fanfare, slot entry jingle
; $02 Boss clear fanfare
; $04 Celebration
; $08 Death jingle
; $10 Game over
; $20 Mini-fanfare (slot win, crystal get)
; $40 Same as $01
; $80 Silence (stops music)
iMusic2:
	.dsb 1 ; $0603

; $01 Jump
; $02 Vine
; $04 Coin
; $08 Shrink
; $10 Fall
; $20 Grow
; $40 -N/A-
; $80 -N/A-
iPulse1SFX:
	.dsb 1 ; $0604

; $01 Short noise
; $02 Rumbling sound (phanto, rocket)
; $04 Rumbling sound (POW)
; $08 (-N/A-) Door / Bomb
; $10 (-N/A-) Hawk / Bubbles
; $20 -N/A-
; $40 -N/A-
; $80 -N/A-
iNoiseSFX:
	.dsb 1 ; $0605

iCurrentMusic2:
	.dsb 1 ; $0606
iCurrentDPCMSFX1:
	.dsb 1 ; $0607
iCurrentDPCMSFX2:
	.dsb 1 ; $0608
iCurrentMusic1:
	.dsb 1 ; $0609
iDPCMTimer1:
	.dsb 1 ; $060a
; only ever $20, $10 or $0
; non-zero tells driver to ignore iDPCMSFX1
iDPCMBossPriority:
	.dsb 1 ; $060b
iSweep:
	.dsb 1 ; $060c
iCurrentPulse1SFX:
	.dsb 1 ; $060d
iCurrentNoiseSFX:
	.dsb 1 ; $060e
iDPCMTimer2:
	.dsb 1 ; $060f
iUsedWarps:
	.dsb 1 ; $0610
iNoiseTimer:
	.dsb 1 ; $0611
iNoteLengthOffset:
	.dsb 1 ; $0612
iCurrentPulse2Offset:
	.dsb 1 ; $0613
iCurrentPulse1Offset:
	.dsb 1 ; $0614
iCurrentHillOffset:
	.dsb 1 ; $0615
iCurrentNoiseOffset:
	.dsb 1 ; $0616
iMusicPulse2NoteStartLength:
	.dsb 1 ; $0617
iMusicPulse2NoteLength:
	.dsb 1 ; $0618
iMusicPulse2InstrumentOffset:
	.dsb 1 ; $0619
iMusicPulse1NoteLength:
	.dsb 1 ; $061a
iMusicPulse1InstrumentOffset:
	.dsb 1 ; $061b
iMusicHillNoteStartLength:
	.dsb 1 ; $061c
iMusicHillNoteLength:
	.dsb 1 ; $061d
iMusicNoiseNoteLength:
	.dsb 1 ; $061e
iMusicNoiseNoteStartLength:
	.dsb 1 ; $061f
iLifeUpEventFlag:
	.dsb 1 ; $0620
iSubspaceVisitCount:
	.dsb 1 ; $0621
iSubspaceCoinCount:
	.dsb 1 ; $0622
iSwarmTimer:
	.dsb 1 ; $0623
iFriction:
	.dsb 1 ; $0624
; FOR RENT
	.dsb 1 ; $0625
; FOR RENT
	.dsb 1 ; $0626
iAreaTransitionID:
	.dsb 1 ; $0627
iSubAreaFlags:
	.dsb 1 ; $0628
iCurrentLvlRelative:
	.dsb 1 ; $0629
iCherryAmount:
	.dsb 1 ; $062a
iTotalCoins:
	.dsb 1 ; $062b
iLargeVeggieAmount:
	.dsb 1 ; $062c
iCharacterLevelCount:
	.dsb 1 ; $062d
	.dsb 1 ; $062e
	.dsb 1 ; $062f
	.dsb 1 ; $0630
iLevelRecord:
	.dsb 1 ; $0631
; FOR RENT
	.dsb 1 ; $0632
; FOR RENT
	.dsb 1 ; $0633
; FOR RENT
	.dsb 1 ; $0634
iCurrentWorld:
iCurrentWorldTileset:
	.dsb 1 ; $0635

; gets set to $A5 in DoCharacterSelectMenu to skip the bank switch
iCHR_A5:
	.dsb 1 ; $0636
iBackupPlayerPal:
	.dsb 4 ; $0637
iReelBuffer:
	.dsb 8 ; $063b
	.dsb 8 ; $0643
	.dsb 8 ; $064b
	.dsb 40 ; $0653

iLDPBonusChanceBuffer:

iContinueScreenBuffer:
	.dsb 3 ; $067b
; Number of continues
iContinueScreenContNo:
	.dsb 4 ; $067e
; Bullet next to CONTINUE
	.dsb 13 ; $0682
; Bullet next to RETRY
iContinueScreenRetry:
	.dsb 4 ; $068f

iLDPBonucChanceNA:
	.dsb 24 ; $0693
iLDPBonucChanceABtn:
	.dsb 18 ; $06ab
iLDPBonucChanceLifeDisplay:
	.dsb 11 ; $06bd
iLDPBonucChanceLiveEMCount:
	.dsb 4 ; $06c8

iPauseBuffer:
	.dsb 14 ; $06cc

iTextDeletionBonus:
	.dsb 5 ; $06da
iTextDeletionABtn:
	.dsb 5 ; $06df
iTextDeletionBonusUnused:
	.dsb 5 ; $06e4
iTextDeletionPause:
	.dsb 9 ; $06e9

iCurrentROMBank:
	.dsb 1 ; $06f2

; Game milestone counter, probably used for debugging
;   $00 = Title screen
;   $01 = Gameplay
;   $02 = Contributors
;   $03 = Mario sleeping
iMainGameState:
	.dsb 1 ; $06f3

iExpansionInput:
	.dsb 2 ; $06f4

iCurrentPlayerSize:
	.dsb 1 ; $06f6
iBGCHR1:
	.dsb 1 ; $06f7
iBGCHR2:
	.dsb 1 ; $06f8
iObjCHR1:
	.dsb 1 ; $06f9
iObjCHR2:
	.dsb 1 ; $06fa
iObjCHR3:
	.dsb 1 ; $06fb
iObjCHR4:
	.dsb 1 ; $06fc
iBGCHR2Timer:
	.dsb 1 ; $06fd
; FOR RENT
	.dsb 1 ; $06fe
; FOR RENT
	.dsb 1 ; $06ff

; When moving into subspace,  this area is turned into a tile represenation
; of the current screen as it will be shown (e.g. reversed, like in-game)
; Not sure if anything else uses this area yet
iSubspaceLayout:
	.dsb $100   ; $0700-$07FF


;
; PPU registers
; $2000-$2007
;

PPUCTRL = $2000
PPUMASK = $2001
PPUSTATUS = $2002
OAMADDR = $2003
OAMDATA = $2004
PPUSCROLL = $2005
PPUADDR = $2006
PPUDATA = $2007

;
; APU registers and joypad registers
;  $4000-$4015         $4016-$4017
;

SQ1_VOL = $4000
SQ1_SWEEP = $4001
SQ1_LO = $4002
SQ1_HI = $4003

SQ2_VOL = $4004
SQ2_SWEEP = $4005
SQ2_LO = $4006
SQ2_HI = $4007

TRI_LINEAR = $4008
_APU_TRI_UNUSED = $4009
TRI_LO = $400a
TRI_HI = $400b

NOISE_VOL = $400c
_APU_NOISE_UNUSED = $400d
NOISE_LO = $400e
NOISE_HI = $400f

DMC_FREQ = $4010
DMC_RAW = $4011
DMC_START = $4012
DMC_LEN = $4013

OAM_DMA = $4014

SND_CHN = $4015

JOY1 = $4016
JOY2 = $4017


;
; Expansion chip stuff for MMC5 support
; $5000-$5015
;

MMC5_PULSE1_VOL = $5000
MMC5_PULSE1_SWEEP = $5001
MMC5_PULSE1_LO = $5002
MMC5_PULSE1_HI = $5003

MMC5_PULSE2_VOL = $5004
MMC5_PULSE2_SWEEP = $5005
MMC5_PULSE2_LO = $5006
MMC5_PULSE2_HI = $5007

MMC5_PCM_MODE_IRQ = $5010
MMC5_RAW_PCM = $5011

MMC5_SND_CHN = $5015

;
; MMC5 bank switching
;
MMC5_PRGMode = $5100
MMC5_CHRMode = $5101
MMC5_PRGRAMProtect1 = $5102
MMC5_PRGRAMProtect2 = $5103
MMC5_ExtendedRAMMode = $5104
MMC5_NametableMapping = $5105
MMC5_PRGBankSwitch1 = $5113
MMC5_PRGBankSwitch2 = $5114
MMC5_PRGBankSwitch3 = $5115
MMC5_PRGBankSwitch4 = $5116
MMC5_PRGBankSwitch5 = $5117
MMC5_CHRBankSwitch1 = $5120
MMC5_CHRBankSwitch2 = $5121
MMC5_CHRBankSwitch3 = $5122
MMC5_CHRBankSwitch4 = $5123
MMC5_CHRBankSwitch5 = $5124
MMC5_CHRBankSwitch6 = $5125
MMC5_CHRBankSwitch7 = $5126
MMC5_CHRBankSwitch8 = $5127
MMC5_CHRBankSwitch9 = $5128
MMC5_CHRBankSwitch10 = $5129
MMC5_CHRBankSwitch11 = $512a
MMC5_CHRBankSwitch12 = $512b
MMC5_CHRBankSwitchUpper = $5130

MMC5_IRQScanlineCompare = $5203
MMC5_IRQStatus = $5204


;
; Cartridge on-board RAM
; Decoded level data is stored in memory here,
; as well as some other junk
; $6000-$7FFF
;

wLevelDataBuffer = $6000

wColBoxLeft = $7100
wColBoxTop = $7114
wColBoxWidth = $7128
wColBoxHeight = $713c

; Copied from bank A
; Does anything read this???
w7150 = $7150

wTitleCardBuffer = $7168
wTitleCardDots = $716b
wTitleCardWorld = $717d
wTitleCardLevel = $717f
wExtraLifeDrawPointer = $7180
wExtraLifeCounter = $7191

wWorldWarpDestination = $7194
wWorldWarpDestinationNo = $71a6

wContinueScreenBullets = $71a8

; Copied from bank A
wCarpetVelocity = $71cc

; Copied from bank F
wObjectInteractionTable = $71d1

wHawkDoorBuffer = $721b

wMamuOAMOffsets = $7265

wBonusLayoutBuffer = $7400

wRawLevelData = $7800

wRawJarData = $7a00

wRawEnemyPointer = $7b00

;
; Extra enhancement support for 2P debug mode controls
; Spread around to some 'for rent' addresses
;

wHeldItemYOffsets = $7f00

MMC3_BankSelect = $8000
MMC3_BankData = $8001
MMC3_Mirroring = $a000
MMC3_PRGRamProtect = $a001
MMC3_IRQLatch = $c000
MMC3_IRQReload = $c001
MMC3_IRQDisable = $e000
MMC3_IRQEnable = $e001
