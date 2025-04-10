;
; Lookup tables for decoded level data by page
;
DecodedLevelPageStartLo_Bank6:
	.db <wLevelDataBuffer
	.db <(wLevelDataBuffer+$00F0)
	.db <(wLevelDataBuffer+$01E0)
	.db <(wLevelDataBuffer+$02D0)
	.db <(wLevelDataBuffer+$03C0)
	.db <(wLevelDataBuffer+$04B0)
	.db <(wLevelDataBuffer+$05A0)
	.db <(wLevelDataBuffer+$0690)
	.db <(wLevelDataBuffer+$0780)
	.db <(wLevelDataBuffer+$0870)
	.db <(iSubspaceLayout)

DecodedLevelPageStartHi_Bank6:
	.db >wLevelDataBuffer
	.db >(wLevelDataBuffer+$00F0)
	.db >(wLevelDataBuffer+$01E0)
	.db >(wLevelDataBuffer+$02D0)
	.db >(wLevelDataBuffer+$03C0)
	.db >(wLevelDataBuffer+$04B0)
	.db >(wLevelDataBuffer+$05A0)
	.db >(wLevelDataBuffer+$0690)
	.db >(wLevelDataBuffer+$0780)
	.db >(wLevelDataBuffer+$0870)
	.db >(iSubspaceLayout)
