;
; ## Ground appearance tiles
;
; The ground setting defines a single column (or row, for vertical areas) where each row (or column)
; is be one of four tiles. That set of four tiles is the ground appearance. Each world has its own
; ground appearances defined, which are which are divided into horizontal and vertical sets.
;
; An area has its initial ground appearance set in the header, but it can be changed mid-area using
; the `$F6` special object.
;

;
; #### Ground appearance pointers
;
GroundTilesHorizontalLo:
	.db <World1GroundTilesHorizontal
	.db <World2GroundTilesHorizontal
	.db <World3GroundTilesHorizontal
	.db <World4GroundTilesHorizontal
	.db <World5GroundTilesHorizontal
	.db <World6GroundTilesHorizontal
	.db <World7GroundTilesHorizontal

GroundTilesVerticalLo:
	.db <World1GroundTilesVertical
	.db <World2GroundTilesVertical
	.db <World3GroundTilesVertical
	.db <World4GroundTilesVertical
	.db <World5GroundTilesVertical
	.db <World6GroundTilesVertical
	.db <World7GroundTilesVertical

GroundTilesHorizontalHi:
	.db >World1GroundTilesHorizontal
	.db >World2GroundTilesHorizontal
	.db >World3GroundTilesHorizontal
	.db >World4GroundTilesHorizontal
	.db >World5GroundTilesHorizontal
	.db >World6GroundTilesHorizontal
	.db >World7GroundTilesHorizontal

GroundTilesVerticalHi:
	.db >World1GroundTilesVertical
	.db >World2GroundTilesVertical
	.db >World3GroundTilesVertical
	.db >World4GroundTilesVertical
	.db >World5GroundTilesVertical
	.db >World6GroundTilesVertical
	.db >World7GroundTilesVertical
