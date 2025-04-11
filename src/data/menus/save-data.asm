SaveFileInit_Packet:
REPT 16
	.db $54
ENDR
	.db $50
	.db $50
	.db $50
SaveFileInit_PacketEnd:

SaveFileInit_Lo:
	.dl $22e6
	.dl $22c6
	.dl $22a6
	.dl $2286
	.dl $2266
	.dl $2246
	.dl $2226
	.dl $2206
	.dl $21e6
	.dl $21c6
	.dl $21a6
	.dl $2186
	.dl $2166
	.dl $2146
	.dl $2126
	.dl $2106
	.dl $20e8
	.dl $20c8
	.dl $20a8

SaveFileInit_Hi:
	.dh $22e6
	.dh $22c6
	.dh $22a6
	.dh $2286
	.dh $2266
	.dh $2246
	.dh $2226
	.dh $2206
	.dh $21e6
	.dh $21c6
	.dh $21a6
	.dh $2186
	.dh $2166
	.dh $2146
	.dh $2126
	.dh $2106
	.dh $20e8
	.dh $20c8
	.dh $20a8

SaveFileAttributes:
	.db $23,$C9,(+b - +a)
+a
	.db     $00,$A0,$A0,$A0,$A0,$00,$00
	.db $00,$8C,$AF,$AF,$AF,$AF,$23,$00
	.db $00,$88,$AA,$AA,$AA,$AA,$22,$00
	.db $00,$CC,$FF,$FF,$FF,$FF,$33,$00
	.db $00,$CC,$FF,$FF,$FF,$FF,$33,$00
+b
	.db $00

SaveFileCopypastaData:
	.db $21,$26,(+b - +a)
+a
	.db "TARGET"+$99
	.db $FB
	.db "FILE"+$99
	.db $F6, $F6, $F6
	.db $FB, $FB, $FB
	.db $F4
+b
	.db $00

SaveFileLayout1:
	.db $20,$CB,(+b - +a)
+a
	.db "SAVE"+$99
	.db $FB
	.db "FILES"+$99
+b
	.db $00
SaveFileLayout2:
	.db $21,$26,(+b - +a)
+a
	.db "LOADED"+$99
	.db $FB
	.db "GAME"+$99
	.db $F6, $F6, $F6
	.db $FB, $FB, $FB
	.db $F4
+b
	.db $00

SaveFileLayout3:
	.db $21,$66,(+b - +a)
+a
	.db "LEVEL"+$99
	.db $F6, $F6, $F6, $F6, $F6, $F6, $F6, $F6, $F6
	.db $FB, $FB
	.db $F4, $F4, $F4, $FB
+b
	.db $00

SaveFileLayout4:
	.db $21,$a6,(+b - +a)
+a
	.db "EXTRA"+$99
	.db $FB
	.db "MEN"+$99
	.db $F6, $F6, $F6, $F6, $F6
	.db $FB, $FB
	.db $F4, $F4, $FB, $FB
+b
	.db $00

SaveFileLayout5:
	.db $22,$26,(+b - +a)
+a
	.db "B"+$99
	.db $FB, $F4, $FB
	.db "DELETE"+$99
	.db $FB
	.db "THIS"+$99
	.db $FB
	.db "GAME"+$99
+b
	.db $00

SaveFileLayout6:
	.db $22,$66,(+b - +a)
+a
	.db "SELECT"+$99
	.db $FB, $F4, $FB
	.db "COPY"+$99
	.db $B9
	.db "PASTE"+$99
+b
	.db $00

SaveFileLayout7:
	.db $22,$a8,(+b - +a)
+a
	.db "A"+$99
	.db $FB, $F4, $FB
	.db "LOAD"+$99
	.db $FB
	.db "THIS"+$99
	.db $FB
	.db "GAME"+$99
+b
	.db $00

SaveFileLayout8:
	.db $22,$e8,(+b - +a)
+a
	.db "START"+$99
	.db $FB, $F4, $FB
	.db "NEW"+$99
	.db $FB
	.db "GAME"+$99
+b
	.db $00

SaveFileRAMBuffer:
	.db $21, $37, $01, $D0
	.db $21, $76, $04, $F4, $F4, $F4, $FB
	.db $21, $b6, $02, $f4, $f4
SaveFileRAMBufferEnd:
	.db $00
