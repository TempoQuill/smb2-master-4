## Object/Enemy RAM

### `$0015`  (`zObjectXHi`)
- high byte for x-position

### `$001F`  (`zObjectYHi`)
- high byte for y-position

### `$0029`  (`zObjectXLo`)
- low byte for x-position

### `$0032`  (`zObjectYLo`)
- low byte for y-position

### `$003D`  (`zObjectXVelocity`)
- x-velocity

### `$0047`  (`zObjectYVelocity`)
- y-velocity

### `$0051`  (`zEnemyState`)
- enemy state (eg. alive/dead/puff of smoke)

### `$005B`  (`zEnemyCollision`)
- enemy collision flags

### `$0065`  (`zObjectAttributes`)
- attributes used for rendering an object (eg. mirroring, size, layering)

### `$006F`  (`zEnemyTrajectory`)
- direction of enemy movement (used for velocity lookups)

### `$0079`  (`zObjectVariables`)
- Birdo type
- Whether item is attached to Birdo
- Mushroom index
- Tweeter bounce counter
- Background tile for Mushroom Block
- Starting y-position for falling logs
- Clawgrip's movement cycle
- Cobrat target Y
- Pokey number of segments
- Fryguy's movement cycle?
- Whale spout timer?
- Wart's movement cycle

### `$0086`  (`zSpriteTimer`)
- BobOmb fuse
- Bomb fuse
- Panser spit
- Trouter jump
- Birdo spit
- Puff of smoke
- Block fizzle
- Pidgit dive
- ...

### `$0090`  (`zObjectType`)
- enemy type ID

### `$009F`  (`zObjectAnimTimer`)
- time animation frames

### `$00A8`  (`zHeldObjectTimer`)

### `$00B1`  (`zEnemyArray`)

### `$042F` (`iObjectBulletTimer`)
 - stun timer

### `$0438` (`iObjectStunTimer`)

### `$0453` (`iSpriteTimer`)

### `$045C` (`iObjectFlashTimer`)
  - flashing timer

### `$0465` (`iEnemyHP`)

### `$046E` (`i46e`)

### `$0477` (`i477`)

### `$0480` (`i480`)

### `$0489` (`iObjectHitbox`)

### `$0492` (`i492`)

### `$049B` (`iLocalBossArray`)
- if set, an end-of-level door spawns when the enemy is defeated

### `$04A4` (`iObjectNonSticky`)

### `$04CC` (`iObjectXVelocity`)

### `$04D6` (`iObjectYVelocity`)

### `$04EF` (`iEndOfLevelDoorPage`)

