ContributorAnimationTiles:
ContributorAnimationTiles_Mario:
	.db $61
	.db $61
	.db $63
	.db $93
	.db $65
	.db $65
	.db $67
	.db $67
ContributorAnimationTiles_Luigi:
	.db $69
	.db $69
	.db $95
	.db $6B
	.db $6D
	.db $6D
	.db $97
	.db $6F
ContributorAnimationTiles_Toad:
	.db $83
	.db $85
	.db $83
	.db $85
	.db $87
	.db $89
	.db $87
	.db $89
ContributorAnimationTiles_Princess:
	.db $8B
	.db $8B
	.db $99
	.db $8D
	.db $8F
	.db $8F
	.db $91
	.db $91

ContributorAnimationTilesOffset:
	.db (ContributorAnimationTiles_Mario - ContributorAnimationTiles + 6)
	.db (ContributorAnimationTiles_Luigi - ContributorAnimationTiles + 6)
	.db (ContributorAnimationTiles_Toad - ContributorAnimationTiles + 6)
	.db (ContributorAnimationTiles_Princess - ContributorAnimationTiles + 6)
