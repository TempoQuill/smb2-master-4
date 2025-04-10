SpriteFlickerDMAOffset:
	.db $C0
	.db $70
	.db $80
	.db $50
	.db $A0
	.db $40
	.db $B0
	.db $60
	.db $90
	.db $C0
	.db $70
	.db $80
	.db $50
	.db $A0
	.db $40
	.db $B0
	.db $60

; Sprite display configuration
ObjectAttributeTable:
	.db ObjAttrib_Palette1 ; $00 Enemy_Heart
	.db ObjAttrib_Palette1 ; $01 Enemy_ShyguyRed
	.db ObjAttrib_Palette1 ; $02 Enemy_Tweeter
	.db ObjAttrib_Palette3 ; $03 Enemy_ShyguyPink
	.db ObjAttrib_Palette2 ; $04 Enemy_Porcupo
	.db ObjAttrib_Palette1 ; $05 Enemy_SnifitRed
	.db ObjAttrib_Palette2 ; $06 Enemy_SnifitGray
	.db ObjAttrib_Palette3 ; $07 Enemy_SnifitPink
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 ; $08 Enemy_Ostro
	.db ObjAttrib_Palette1 ; $09 Enemy_BobOmb
	.db ObjAttrib_Palette1 | ObjAttrib_Horizontal | ObjAttrib_16x32 ; $0A Enemy_AlbatossCarryingBobOmb
	.db ObjAttrib_Palette1 | ObjAttrib_Horizontal | ObjAttrib_16x32 ; $0B Enemy_AlbatossStartRight
	.db ObjAttrib_Palette1 | ObjAttrib_Horizontal | ObjAttrib_16x32 ; $0C Enemy_AlbatossStartLeft
	.db ObjAttrib_Palette1 ; $0D Enemy_NinjiRunning
	.db ObjAttrib_Palette1 ; $0E Enemy_NinjiJumping
	.db ObjAttrib_Palette1 ; $0F Enemy_BeezoDiving
	.db ObjAttrib_Palette2 ; $10 Enemy_BeezoStraight
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $11 Enemy_WartBubble
	.db ObjAttrib_Palette1 | ObjAttrib_Horizontal | ObjAttrib_FrontFacing ; $12 Enemy_Pidgit
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing ; $13 Enemy_Trouter
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $14 Enemy_Hoopstar
	.db ObjAttrib_Palette0 ; $15 Enemy_JarGeneratorShyguy
	.db ObjAttrib_Palette0 ; $16 Enemy_JarGeneratorBobOmb
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing ; $17 Enemy_Phanto
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 | ObjAttrib_UpsideDown ; $18 Enemy_CobratJar
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 ; $19 Enemy_CobratSand
	.db ObjAttrib_Palette2 | ObjAttrib_FrontFacing ; $1A Enemy_Pokey
	.db ObjAttrib_Palette2 | ObjAttrib_FrontFacing ; $1B Enemy_Bullet
	.db ObjAttrib_Palette2 | ObjAttrib_16x32 ; $1C Enemy_Birdo
	.db ObjAttrib_Palette3 | ObjAttrib_16x32 ; $1D Enemy_Mouser
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing ; $1E Enemy_Egg
	.db ObjAttrib_Palette2 | ObjAttrib_FrontFacing ; $1F Enemy_Tryclyde
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $20 Enemy_Fireball
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 ; $21 Enemy_Clawgrip
	.db ObjAttrib_Palette2 ; $22 Enemy_ClawgripRock
	.db ObjAttrib_Palette1 ; $23 Enemy_PanserStationaryFiresAngled
	.db ObjAttrib_Palette3 ; $24 Enemy_PanserWalking
	.db ObjAttrib_Palette2 ; $25 Enemy_PanserStationaryFiresUp
	.db ObjAttrib_Palette1 ; $26 Enemy_Autobomb
	.db ObjAttrib_Palette1 ; $27 Enemy_AutobombFire
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing ; $28 Enemy_WhaleSpout
	.db ObjAttrib_Palette1 ; $29 Enemy_Flurry
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 ; $2A Enemy_Fryguy
	.db ObjAttrib_Palette1 ; $2B Enemy_FryguySplit
	.db ObjAttrib_Palette3 | ObjAttrib_Horizontal | ObjAttrib_FrontFacing | ObjAttrib_16x32 ; $2C Enemy_Wart
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 ; $2D Enemy_HawkmouthBoss
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $2E Enemy_Spark1
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $2F Enemy_Spark2
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $30 Enemy_Spark3
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $31 Enemy_Spark4
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored | ObjAttrib_UpsideDown ; $32 Enemy_VegetableSmall
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored | ObjAttrib_UpsideDown ; $33 Enemy_VegetableLarge
	.db ObjAttrib_Palette2 | ObjAttrib_Mirrored | ObjAttrib_UpsideDown ; $34 Enemy_VegetableWart
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored | ObjAttrib_UpsideDown ; $35 Enemy_Shell
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored | ObjAttrib_UpsideDown ; $36 Enemy_Coin
	.db ObjAttrib_Palette1 | ObjAttrib_UpsideDown ; $37 Enemy_Bomb
	.db ObjAttrib_Palette1 | ObjAttrib_UpsideDown ; $38 Enemy_Rocket
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing ; $39 Enemy_MushroomBlock
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing | ObjAttrib_UpsideDown ; $3A Enemy_POWBlock
	.db ObjAttrib_Palette1 | ObjAttrib_Horizontal | ObjAttrib_FrontFacing | ObjAttrib_16x32 ; $3B Enemy_FallingLogs
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing ; $3C Enemy_SubspaceDoor
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing ; $3D Enemy_Key
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing | ObjAttrib_UpsideDown ; $3E Enemy_SubspacePotion
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $3F Enemy_Mushroom
	.db ObjAttrib_Palette1 | ObjAttrib_FrontFacing | ObjAttrib_UpsideDown ; $40 Enemy_Mushroom1up
	.db ObjAttrib_Palette1 | ObjAttrib_Horizontal | ObjAttrib_16x32 ; $41 Enemy_FlyingCarpet
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 ; $42 Enemy_HawkmouthRight
	.db ObjAttrib_Palette1 | ObjAttrib_16x32 ; $43 Enemy_HawkmouthLeft
	.db ObjAttrib_Palette1 | ObjAttrib_Mirrored ; $44 Enemy_CrystalBall
	.db ObjAttrib_Palette2 | ObjAttrib_Mirrored ; $45 Enemy_Starman
	.db ObjAttrib_Palette2 | ObjAttrib_Mirrored | ObjAttrib_UpsideDown ; $46 Enemy_Stopwatch

;
; Enemy Behavior 46E
;
;   bit 7 ($80) - uses mirrored sprite for animation
;   bit 6 ($40) - double speed
;   bit 5 ($20) - wider sprite? used for mouser
;   bit 4 ($10) - use tilemap 2
;   bit 3 ($08) - squawk on death (prevents despawning offscreen?)
;   bit 2 ($04) - disable collision with other enemies
;   bit 1 ($02) - unliftable
;   bit 0 ($01) - hurts when touched from above
EnemyArray_46E_Data:
	.db %00000100 ; $00 Enemy_Heart
	.db %00000000 ; $01 Enemy_ShyguyRed
	.db %00000000 ; $02 Enemy_Tweeter
	.db %00000000 ; $03 Enemy_ShyguyPink
	.db %00000011 ; $04 Enemy_Porcupo
	.db %00000000 ; $05 Enemy_SnifitRed
	.db %00000000 ; $06 Enemy_SnifitGray
	.db %00000000 ; $07 Enemy_SnifitPink
	.db %01010000 ; $08 Enemy_Ostro
	.db %01000000 ; $09 Enemy_BobOmb
	.db %01000010 ; $0A Enemy_AlbatossCarryingBobOmb
	.db %01000010 ; $0B Enemy_AlbatossStartRight
	.db %01000010 ; $0C Enemy_AlbatossStartLeft
	.db %01000000 ; $0D Enemy_NinjiRunning
	.db %01000000 ; $0E Enemy_NinjiJumping
	.db %01000000 ; $0F Enemy_BeezoDiving
	.db %01000000 ; $10 Enemy_BeezoStraight
	.db %00010011 ; $11 Enemy_WartBubble
	.db %11010000 ; $12 Enemy_Pidgit
	.db %10000000 ; $13 Enemy_Trouter
	.db %00000000 ; $14 Enemy_Hoopstar
	.db %00000110 ; $15 Enemy_JarGeneratorShyguy
	.db %00000110 ; $16 Enemy_JarGeneratorBobOmb
	.db %00000111 ; $17 Enemy_Phanto
	.db %00010000 ; $18 Enemy_CobratJar
	.db %01010000 ; $19 Enemy_CobratSand
	.db %10010000 ; $1A Enemy_Pokey
	.db %00000111 ; $1B Enemy_Bullet
	.db %00001010 ; $1C Enemy_Birdo
	.db %00111011 ; $1D Enemy_Mouser
	.db %01000000 ; $1E Enemy_Egg
	.db %00011000 ; $1F Enemy_Tryclyde
	.db %00000111 ; $20 Enemy_Fireball
	.db %00011011 ; $21 Enemy_Clawgrip
	.db %00010000 ; $22 Enemy_ClawgripRock
	.db %00000111 ; $23 Enemy_PanserStationaryFiresAngled
	.db %00000111 ; $24 Enemy_PanserWalking
	.db %00000111 ; $25 Enemy_PanserStationaryFiresUp
	.db %01010000 ; $26 Enemy_Autobomb
	.db %01010011 ; $27 Enemy_AutobombFire
	.db %10010110 ; $28 Enemy_WhaleSpout
	.db %01010000 ; $29 Enemy_Flurry
	.db %10011011 ; $2A Enemy_Fryguy
	.db %11010011 ; $2B Enemy_FryguySplit
	.db %00011011 ; $2C Enemy_Wart
	.db %00001011 ; $2D Enemy_HawkmouthBoss
	.db %00000011 ; $2E Enemy_Spark1
	.db %00000011 ; $2F Enemy_Spark2
	.db %00000011 ; $30 Enemy_Spark3
	.db %00000011 ; $31 Enemy_Spark4
	.db %00000000 ; $32 Enemy_VegetableSmall
	.db %00000000 ; $33 Enemy_VegetableLarge
	.db %00000000 ; $34 Enemy_VegetableWart
	.db %00000000 ; $35 Enemy_Shell
	.db %00000100 ; $36 Enemy_Coin
	.db %00000100 ; $37 Enemy_Bomb
	.db %00000100 ; $38 Enemy_Rocket
	.db %00000000 ; $39 Enemy_MushroomBlock
	.db %00000000 ; $3A Enemy_POWBlock
	.db %00000110 ; $3B Enemy_FallingLogs
	.db %00000100 ; $3C Enemy_SubspaceDoor
	.db %00000000 ; $3D Enemy_Key
	.db %00000100 ; $3E Enemy_SubspacePotion
	.db %00000100 ; $3F Enemy_Mushroom
	.db %00000100 ; $40 Enemy_Mushroom1up
	.db %00010110 ; $41 Enemy_FlyingCarpet
	.db %00000110 ; $42 Enemy_HawkmouthRight
	.db %00000110 ; $43 Enemy_HawkmouthLeft
	.db %00001100 ; $44 Enemy_CrystalBall
	.db %00000100 ; $45 Enemy_Starman
	.db %00000100 ; $46 Enemy_Stopwatch

;
; Index for tile collision bounding box table
;
EnemyArray_492_Data:
	.db $00 ; $00 Enemy_Heart
	.db $05 ; $01 Enemy_ShyguyRed
	.db $05 ; $02 Enemy_Tweeter
	.db $05 ; $03 Enemy_ShyguyPink
	.db $05 ; $04 Enemy_Porcupo
	.db $05 ; $05 Enemy_SnifitRed
	.db $05 ; $06 Enemy_SnifitGray
	.db $05 ; $07 Enemy_SnifitPink
	.db $0C ; $08 Enemy_Ostro
	.db $05 ; $09 Enemy_BobOmb
	.db $05 ; $0A Enemy_AlbatossCarryingBobOmb
	.db $05 ; $0B Enemy_AlbatossStartRight
	.db $05 ; $0C Enemy_AlbatossStartLeft
	.db $05 ; $0D Enemy_NinjiRunning
	.db $05 ; $0E Enemy_NinjiJumping
	.db $05 ; $0F Enemy_BeezoDiving
	.db $05 ; $10 Enemy_BeezoStraight
	.db $05 ; $11 Enemy_WartBubble
	.db $05 ; $12 Enemy_Pidgit
	.db $05 ; $13 Enemy_Trouter
	.db $05 ; $14 Enemy_Hoopstar
	.db $0D ; $15 Enemy_JarGeneratorShyguy
	.db $0D ; $16 Enemy_JarGeneratorBobOmb
	.db $05 ; $17 Enemy_Phanto
	.db $0C ; $18 Enemy_CobratJar
	.db $0C ; $19 Enemy_CobratSand
	.db $05 ; $1A Enemy_Pokey
	.db $0D ; $1B Enemy_Bullet
	.db $0C ; $1C Enemy_Birdo
	.db $0C ; $1D Enemy_Mouser
	.db $05 ; $1E Enemy_Egg
	.db $0E ; $1F Enemy_Tryclyde
	.db $0D ; $20 Enemy_Fireball
	.db $0C ; $21 Enemy_Clawgrip
	.db $05 ; $22 Enemy_ClawgripRock
	.db $05 ; $23 Enemy_PanserStationaryFiresAngled
	.db $05 ; $24 Enemy_PanserWalking
	.db $05 ; $25 Enemy_PanserStationaryFiresUp
	.db $0C ; $26 Enemy_Autobomb
	.db $05 ; $27 Enemy_AutobombFire
	.db $05 ; $28 Enemy_WhaleSpout
	.db $05 ; $29 Enemy_Flurry
	.db $05 ; $2A Enemy_Fryguy
	.db $05 ; $2B Enemy_FryguySplit
	.db $05 ; $2C Enemy_Wart
	.db $00 ; $2D Enemy_HawkmouthBoss
	.db $0F ; $2E Enemy_Spark1
	.db $0F ; $2F Enemy_Spark2
	.db $0F ; $30 Enemy_Spark3
	.db $0F ; $31 Enemy_Spark4
	.db $05 ; $32 Enemy_VegetableSmall
	.db $05 ; $33 Enemy_VegetableLarge
	.db $05 ; $34 Enemy_VegetableWart
	.db $05 ; $35 Enemy_Shell
	.db $05 ; $36 Enemy_Coin
	.db $05 ; $37 Enemy_Bomb
	.db $05 ; $38 Enemy_Rocket
	.db $04 ; $39 Enemy_MushroomBlock
	.db $04 ; $3A Enemy_POWBlock
	.db $04 ; $3B Enemy_FallingLogs
	.db $04 ; $3C Enemy_SubspaceDoor
	.db $04 ; $3D Enemy_Key
	.db $04 ; $3E Enemy_SubspacePotion
	.db $04 ; $3F Enemy_Mushroom
	.db $04 ; $40 Enemy_Mushroom1up
	.db $10 ; $41 Enemy_FlyingCarpet
	.db $00 ; $42 Enemy_HawkmouthRight
	.db $00 ; $43 Enemy_HawkmouthLeft
	.db $05 ; $44 Enemy_CrystalBall
	.db $05 ; $45 Enemy_Starman
	.db $05 ; $46 Enemy_Stopwatch

;
; Index for object collision bounding box table
;
ObjectHitbox_Data:
	.db $08 ; $00 Enemy_Heart
	.db $02 ; $01 Enemy_ShyguyRed
	.db $02 ; $02 Enemy_Tweeter
	.db $02 ; $03 Enemy_ShyguyPink
	.db $02 ; $04 Enemy_Porcupo
	.db $02 ; $05 Enemy_SnifitRed
	.db $02 ; $06 Enemy_SnifitGray
	.db $02 ; $07 Enemy_SnifitPink
	.db $04 ; $08 Enemy_Ostro
	.db $02 ; $09 Enemy_BobOmb
	.db $09 ; $0A Enemy_AlbatossCarryingBobOmb
	.db $09 ; $0B Enemy_AlbatossStartRight
	.db $09 ; $0C Enemy_AlbatossStartLeft
	.db $02 ; $0D Enemy_NinjiRunning
	.db $02 ; $0E Enemy_NinjiJumping
	.db $02 ; $0F Enemy_BeezoDiving
	.db $02 ; $10 Enemy_BeezoStraight
	.db $02 ; $11 Enemy_WartBubble
	.db $02 ; $12 Enemy_Pidgit
	.db $02 ; $13 Enemy_Trouter
	.db $02 ; $14 Enemy_Hoopstar
	.db $08 ; $15 Enemy_JarGeneratorShyguy
	.db $08 ; $16 Enemy_JarGeneratorBobOmb
	.db $02 ; $17 Enemy_Phanto
	.db $04 ; $18 Enemy_CobratJar
	.db $04 ; $19 Enemy_CobratSand
	.db $0E ; $1A Enemy_Pokey
	.db $08 ; $1B Enemy_Bullet
	.db $04 ; $1C Enemy_Birdo
	.db $04 ; $1D Enemy_Mouser
	.db $02 ; $1E Enemy_Egg
	.db $0F ; $1F Enemy_Tryclyde
	.db $02 ; $20 Enemy_Fireball
	.db $13 ; $21 Enemy_Clawgrip
	.db $02 ; $22 Enemy_ClawgripRock
	.db $02 ; $23 Enemy_PanserStationaryFiresAngled
	.db $02 ; $24 Enemy_PanserWalking
	.db $02 ; $25 Enemy_PanserStationaryFiresUp
	.db $10 ; $26 Enemy_Autobomb
	.db $02 ; $27 Enemy_AutobombFire
	.db $12 ; $28 Enemy_WhaleSpout
	.db $02 ; $29 Enemy_Flurry
	.db $0F ; $2A Enemy_Fryguy
	.db $02 ; $2B Enemy_FryguySplit
	.db $11 ; $2C Enemy_Wart
	.db $0B ; $2D Enemy_HawkmouthBoss
	.db $02 ; $2E Enemy_Spark1
	.db $02 ; $2F Enemy_Spark2
	.db $02 ; $30 Enemy_Spark3
	.db $02 ; $31 Enemy_Spark4
	.db $02 ; $32 Enemy_VegetableSmall
	.db $02 ; $33 Enemy_VegetableLarge
	.db $02 ; $34 Enemy_VegetableWart
	.db $02 ; $35 Enemy_Shell
	.db $02 ; $36 Enemy_Coin
	.db $02 ; $37 Enemy_Bomb
	.db $04 ; $38 Enemy_Rocket
	.db $03 ; $39 Enemy_MushroomBlock
	.db $03 ; $3A Enemy_POWBlock
	.db $07 ; $3B Enemy_FallingLogs
	.db $04 ; $3C Enemy_SubspaceDoor
	.db $03 ; $3D Enemy_Key
	.db $03 ; $3E Enemy_SubspacePotion
	.db $03 ; $3F Enemy_Mushroom
	.db $03 ; $40 Enemy_Mushroom1up
	.db $09 ; $41 Enemy_FlyingCarpet
	.db $0B ; $42 Enemy_HawkmouthRight
	.db $0B ; $43 Enemy_HawkmouthLeft
	.db $02 ; $44 Enemy_CrystalBall
	.db $02 ; $45 Enemy_Starman
	.db $02 ; $46 Enemy_Stopwatch

; More collision (post-throw)
EnemyPlayerCollisionTable:
	.db $00 ; $00 Enemy_Heart
	.db $00 ; $01 Enemy_ShyguyRed
	.db $00 ; $02 Enemy_Tweeter
	.db $00 ; $03 Enemy_ShyguyPink
	.db $00 ; $04 Enemy_Porcupo
	.db $00 ; $05 Enemy_SnifitRed
	.db $00 ; $06 Enemy_SnifitGray
	.db $00 ; $07 Enemy_SnifitPink
	.db $00 ; $08 Enemy_Ostro
	.db $00 ; $09 Enemy_BobOmb
	.db $00 ; $0A Enemy_AlbatossCarryingBobOmb
	.db $00 ; $0B Enemy_AlbatossStartRight
	.db $00 ; $0C Enemy_AlbatossStartLeft
	.db $00 ; $0D Enemy_NinjiRunning
	.db $00 ; $0E Enemy_NinjiJumping
	.db $00 ; $0F Enemy_BeezoDiving
	.db $00 ; $10 Enemy_BeezoStraight
	.db $00 ; $11 Enemy_WartBubble
	.db $00 ; $12 Enemy_Pidgit
	.db $00 ; $13 Enemy_Trouter
	.db $00 ; $14 Enemy_Hoopstar
	.db $00 ; $15 Enemy_JarGeneratorShyguy
	.db $00 ; $16 Enemy_JarGeneratorBobOmb
	.db $00 ; $17 Enemy_Phanto
	.db $00 ; $18 Enemy_CobratJar
	.db $00 ; $19 Enemy_CobratSand
	.db $00 ; $1A Enemy_Pokey
	.db $00 ; $1B Enemy_Bullet
	.db $00 ; $1C Enemy_Birdo
	.db $00 ; $1D Enemy_Mouser
	.db $00 ; $1E Enemy_Egg
	.db $00 ; $1F Enemy_Tryclyde
	.db $00 ; $20 Enemy_Fireball
	.db $00 ; $21 Enemy_Clawgrip
	.db $00 ; $22 Enemy_ClawgripRock
	.db $00 ; $23 Enemy_PanserStationaryFiresAngled
	.db $00 ; $24 Enemy_PanserWalking
	.db $00 ; $25 Enemy_PanserStationaryFiresUp
	.db $00 ; $26 Enemy_Autobomb
	.db $00 ; $27 Enemy_AutobombFire
	.db $00 ; $28 Enemy_WhaleSpout
	.db $00 ; $29 Enemy_Flurry
	.db $00 ; $2A Enemy_Fryguy
	.db $00 ; $2B Enemy_FryguySplit
	.db $00 ; $2C Enemy_Wart
	.db $00 ; $2D Enemy_HawkmouthBoss
	.db $00 ; $2E Enemy_Spark1
	.db $00 ; $2F Enemy_Spark2
	.db $00 ; $30 Enemy_Spark3
	.db $00 ; $31 Enemy_Spark4
	.db $01 ; $32 Enemy_VegetableSmall
	.db $01 ; $33 Enemy_VegetableLarge
	.db $01 ; $34 Enemy_VegetableWart
	.db $01 ; $35 Enemy_Shell
	.db $02 ; $36 Enemy_Coin
	.db $01 ; $37 Enemy_Bomb
	.db $00 ; $38 Enemy_Rocket
	.db $02 ; $39 Enemy_MushroomBlock
	.db $03 ; $3A Enemy_POWBlock
	.db $02 ; $3B Enemy_FallingLogs
	.db $04 ; $3C Enemy_SubspaceDoor
	.db $02 ; $3D Enemy_Key
	.db $02 ; $3E Enemy_SubspacePotion
	.db $02 ; $3F Enemy_Mushroom
	.db $02 ; $40 Enemy_Mushroom1up
	.db $02 ; $41 Enemy_FlyingCarpet
	.db $02 ; $42 Enemy_HawkmouthRight
	.db $02 ; $43 Enemy_HawkmouthLeft
	.db $02 ; $44 Enemy_CrystalBall
	.db $00 ; $45 Enemy_Starman
	.db $02 ; $46 Enemy_Stopwatch
