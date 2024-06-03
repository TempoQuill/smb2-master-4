.ignorenl

; ----------------------------------------
;  Super Mario Bros. 2 Disassembly Config
; ----------------------------------------
;
; By default, this repository is set up to build an identical copy
; of the original PRG0 revision of Super Mario Bros. 2 (USA).
;
; You can tweak the build settings below. To remove
; the default options, comment them out.
; (Changing the assignment to 0 won't work.)
;
; To enable them indefinitely, uncomment the definition.
;
; To enable them for a single build from the command line, use
; build -dFLAGNAME
; For example, to build a PRG1/Rev A ROM,
; build -dREV_A

; ----------------------------------------
; Preserve unused space.
; Free space in the original ROM will continue to be padded outwards,
; to the extent that it was in the original.
; Adding your own code should shrink the free space afterwards automatically.
;
; Turning this off will "squish" most banks and move free space
; within them to the end, making it easier to add your own code anywhere.
; ...but it might also cause problems if data gets relocated
; when it isn't properly pointed to.
; PRESERVE_UNUSED_SPACE = 1

; NSF Building
; NSF_FILE = 1

; ----------------------------------------
; Build PRG1 / Revision A ROM.
;
; Differences:
;
; PRG-2-3: Fixes bug where killing one of the mini FryGuy enemies
;          while changing size from taking damage would cause
;          the enemy to do the "flip over and fall off" death
;          instead of the "puff of smoke" death, which caused
;          the "number of small bosses left" number to not
;          decrease. Which meant the boss fight never ended.
;          Hope you had an extra life and a second controller...
;
; PRG-E-F: Fixes a minor issue when played on PAL consoles where
;          remarkably poor luck would cause the bonus chance screen
;          to end up rendering completely invisibly due to an NMI hitting
;          at the worst possible time.
;          The fix just waits for an NMI cycle before doing its work.
;
; REV_A = 1



; ----------------------------------------
; Patches that fix bugs or glitches


; Show all 8 frames of CHR cycling animation
FIX_CHR_CYCLE = 1

; Fixes the POW falling log glitch
FIX_POW_LOG_GLITCH = 1

; Fixes vine climbing bug when holding up and down simultaneously
FIX_CLIMB_ZIP = 1

; Fixes green platform tiles in Subspace
FIX_SUBSPACE_TILES = 1

; ----------------------------------------
; Patches that alter the game in
; interesting or useful ways


; Skips Bonus Chance after the end of a level
; DISABLE_BONUS_CHANCE = 1

; Go to the Charater Select screen after death
CHARACTER_SELECT_AFTER_DEATH = 1

; RGME audio
; RGME_AUDIO = 1

; ----------------------------------------
; Patches and enhancements largely useful
; only to people hacking the game


; Expand PRG and/or CHR to max capacity
; EXPAND_PRG = 1
; EXPAND_CHR = 1

; Use MMC5 (mapper 5) instead of MMC3 (mapper 4)
; Based on RetroRain's MMC5 patch (https://www.romhacking.net/hacks/2568)
MMC5 = 1

; Make Toad good at jumping and running for testing purposes
; STATS_TESTING_PURPOSES = 1

; extra time on the stopwatch
; SIXTEEN_BIT_WATCH_TIMER = 1

; Go straight to the Mario Sleeping Scene
; TEST_SLEEPING_SCENE = 1

; optimize for PAL regions
; PAL = 1

.endinl
