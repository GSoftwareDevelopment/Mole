/***************************************/
/*  Use MADS http://mads.atari8.info/  */
/*  Mode: DLI (char mode)              */
/***************************************/

	icl "title.h"

	org $f0

fcnt	.ds 2
fadr	.ds 2
fhlp	.ds 2
cloc	.ds 1
regA	.ds 1
regX	.ds 1
regY	.ds 1

WIDTH	= 40
HEIGHT	= 30

; ---	BASIC switch OFF
	org $2000\ mva #$ff portb\ rts\ ini $2000

; ---	MAIN PROGRAM
	org $2000
ant	dta $44,a(scr)
	dta $04,$04,$04,$04,$04,$04,$04,$04,$84,$04,$84,$84,$84,$84,$04,$04
	dta $04,$04,$04,$04,$04,$04,$04,$84,$84,$04,$04,$04,$04
	dta $41,a(ant)

scr	ins "title.scr"

	.ds 0*40

	.ALIGN $0400
fnt	ins "title.fnt"

	ift USESPRITES
	.ALIGN $0800
pmg	.ds $0300
	ift FADECHR = 0
	SPRITES
	els
	.ds $500
	eif
	eif

main
; ---	init PMG

	ift USESPRITES
	mva >pmg pmbase		;missiles and players data address
	mva #$03 pmcntl		;enable players and missiles
	eif

	ift CHANGES		;if label CHANGES defined
	jsr save_color		;then save all colors and set value 0 for all colors
	eif

	lda:cmp:req $14		;wait 1 frame

	sei			;stop IRQ interrupts
	mva #$00 nmien		;stop NMI interrupts
	sta dmactl
	mva #$fe portb		;switch off ROM to get 16k more ram

	mwa #NMI $fffa		;new NMI handler

	mva #$c0 nmien		;switch on NMI+DLI again

	ift CHANGES		;if label CHANGES defined

	jsr fade_in		;fade in colors

_lp	lda trig0		; FIRE #0
	beq stop

	lda trig1		; FIRE #1
	beq stop

	lda consol		; START
	and #1
	beq stop

	lda skctl
	and #$04
	bne _lp			;wait to press any key; here you can put any own routine

	jsr fade_out		;fade out colors

	els

null	jmp DLI.dli1		;CPU is busy here, so no more routines allowed

	eif


stop
	mva #$00 pmcntl		;PMG disabled
	tax
	sta:rne hposp0,x+

	mva #$ff portb		;ROM switch on
	mva #$40 nmien		;only NMI interrupts, DLI disabled
	cli			;IRQ enabled

	rts			;return to ... DOS

; ---	DLI PROGRAM

.local	DLI

	?old_dli = *

	ift !CHANGES

dli1	lda trig0		; FIRE #0
	beq stop

	lda trig1		; FIRE #1
	beq stop

	lda consol		; START
	and #1
	beq stop

	lda skctl
	and #$04
	beq stop

	lda vcount
	cmp #$02
	bne dli1

	:3 sta wsync

	sta wsync		;line=0
	sta wsync		;line=1
	sta wsync		;line=2
	sta wsync		;line=3
	sta wsync		;line=4
	sta wsync		;line=5
	lda #$04
	sta wsync		;line=6
	sta gtictl
	sta wsync		;line=7
c8	lda #$76
	sta wsync		;line=8
	sta colbak
	sta wsync		;line=9
	sta wsync		;line=10
	sta wsync		;line=11
	sta wsync		;line=12
	sta wsync		;line=13
	sta wsync		;line=14
	sta wsync		;line=15
	sta wsync		;line=16
	sta wsync		;line=17
	sta wsync		;line=18
	sta wsync		;line=19
	sta wsync		;line=20
	sta wsync		;line=21
	sta wsync		;line=22
	sta wsync		;line=23
c9	lda #$0E
	sta wsync		;line=24
	sta color2
	lda #$00
	sta wsync		;line=25
	sta gtictl
	sta wsync		;line=26
	sta wsync		;line=27
	sta wsync		;line=28
	sta wsync		;line=29
	sta wsync		;line=30
	sta wsync		;line=31
	sta wsync		;line=32
	sta wsync		;line=33
	sta wsync		;line=34
	sta wsync		;line=35
	sta wsync		;line=36
	sta wsync		;line=37
	sta wsync		;line=38
	sta wsync		;line=39
c10	lda #$74
	sta wsync		;line=40
	sta colbak
	sta wsync		;line=41
	lda #$01
s3	ldx #$00
x7	ldy #$84
	sta wsync		;line=42
	sta gtictl
	stx sizep0
	stx sizep1
	sty hposp0
x8	lda #$83
	sta hposp1
c11	lda #$04
	sta colpm0
c12	lda #$02
	sta colpm1
	sta wsync		;line=43
	sta wsync		;line=44
	sta wsync		;line=45
	sta wsync		;line=46
	sta wsync		;line=47
	sta wsync		;line=48
	sta wsync		;line=49
	sta wsync		;line=50
	sta wsync		;line=51
	sta wsync		;line=52
	sta wsync		;line=53
	sta wsync		;line=54
	sta wsync		;line=55
c13	lda #$12
	sta wsync		;line=56
	sta color2
	sta wsync		;line=57
	sta wsync		;line=58
	sta wsync		;line=59
	sta wsync		;line=60
	sta wsync		;line=61
	sta wsync		;line=62
	sta wsync		;line=63
	sta wsync		;line=64
	sta wsync		;line=65
	sta wsync		;line=66
	sta wsync		;line=67
	sta wsync		;line=68
	sta wsync		;line=69
	sta wsync		;line=70
	sta wsync		;line=71
c14	lda #$72
c15	ldx #$D4
	sta wsync		;line=72
	sta colbak
	stx color3
	sta wsync		;line=73
	sta wsync		;line=74
	sta wsync		;line=75
	sta wsync		;line=76
	sta wsync		;line=77
c16	lda #$1C
	sta wsync		;line=78
	sta color1
	mwa #null null+1
	jmp null

	eif

dli_start

dli2
	sta regA
	lda >fnt+$400*$01
	sta wsync		;line=80
	sta chbase
	DLINEW dli6 1 0 0

dli6
	sta regA
	stx regX
	sty regY

c17	lda #$14
c18	ldx #$1C
c19	ldy #$C4
	sta wsync		;line=96
	sta color1
	stx color2
	sty color3
	DLINEW dli7 1 1 1

dli7
	sta regA
	stx regX
	sty regY

c20	lda #$70
c21	ldx #$2A
c22	ldy #$14
	sta wsync		;line=104
	sta colbak
	stx color1
	sty color2
c23	lda #$12
	sta color3
	DLINEW dli8 1 1 1

dli8
	sta regA

c24	lda #$12
	sta wsync		;line=112
	sta colbak
	sta wsync		;line=113
c25	lda #$10
	sta wsync		;line=114
	sta colbak
	DLINEW dli3 1 0 0

dli3
	sta regA
	stx regX
	sty regY
	lda >fnt+$400*$00
c26	ldx #$04
c27	ldy #$06
	sta wsync		;line=120
	sta chbase
	stx color0
	sty color1
c28	lda #$0A
	sta color2
c29	lda #$0E
	sta color3
	DLINEW dli9 1 1 1

dli9
	sta regA
	stx regX
	sty regY

x9	lda #$30
x10	ldx #$38
x11	ldy #$C0
	sta wsync		;line=200
	sta hposp0
	stx hposp1
	sty hposp2
x12	lda #$C8
	sta hposp3
c30	lda #$2C
	sta colpm0
	sta colpm1
c31	lda #$08
	sta colpm2
c32	lda #$0E
	sta colpm3
	DLINEW dli10 1 1 1

dli10
	sta regA
	stx regX
	sty regY

c33	lda #$18
	sta wsync		;line=208
	sta colpm0
	sta colpm1
c34	lda #$28
	sta wsync		;line=209
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c35	lda #$38
	sta wsync		;line=210
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c36	lda #$48
	sta wsync		;line=211
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c37	lda #$58
	sta wsync		;line=212
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c38	lda #$68
	sta wsync		;line=213
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c39	lda #$78
	sta wsync		;line=214
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c40	lda #$88
	sta wsync		;line=215
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c41	lda #$98
	sta wsync		;line=216
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c42	lda #$A8
	sta wsync		;line=217
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c43	lda #$B8
	sta wsync		;line=218
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c44	lda #$C8
	sta wsync		;line=219
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c45	lda #$D8
	sta wsync		;line=220
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c46	lda #$E8
	sta wsync		;line=221
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c47	lda #$F8
c48	ldx #$08
c49	ldy #$0E
	sta wsync		;line=222
	sta colpm0
	sta colpm1
	stx colpm2
	sty colpm3
c50	lda #$2C
	sta wsync		;line=223
	sta colpm0
	sta colpm1

	lda regA
	ldx regX
	ldy regY
	rti

.endl

; ---

CHANGES	= 0
FADECHR	= 0

SCHR	= 127

; ---

.proc	NMI

	bit nmist
	bpl VBL

	jmp DLI.dli2
dliv	equ *-2

VBL
	sta regA
	stx regX
	sty regY

	sta nmist		;reset NMI flag

	mwa #ant dlptr		;ANTIC address program

	mva #@dmactl(standard|dma|lineX1|players|missiles) dmactl	;set new screen width

	inc cloc		;little timer

; Initial values

	lda >fnt+$400*$00
	sta chbase
c0	lda #$78
	sta colbak
c1	lda #$16
	sta color0
c2	lda #$18
	sta color1
c3	lda #$14
	sta color2
c4	lda #$1C
	sta color3
	lda #$02
	sta chrctl
	lda #$00
	sta gtictl
s0	lda #$03
	sta sizep0
	sta sizep1
x0	lda #$3A
	sta hposp0
x1	lda #$5A
	sta hposp1
c5	lda #$0E
	sta colpm0
	sta colpm1
s1	lda #$00
	sta sizep2
	sta sizep3
s2	lda #$03
	sta sizem
x2	lda #$8C
	sta hposp2
x3	lda #$8B
	sta hposp3
x4	lda #$58
	sta hposm0
x5	lda #$82
	sta hposm1
x6	lda #$94
	sta hposm2
	sta hposm3
c6	lda #$04
	sta colpm2
c7	lda #$02
	sta colpm3

	mwa #DLI.dli2 dliv	;set the first address of DLI interrupt
	mwa #DLI.dli1 null+1	;synchronization for the first screen line

;this area is for yours routines

quit
	lda regA
	ldx regX
	ldy regY
	rti

.endp

; ---
	ift CHANGES
		ift FADECHR = 0
		icl 'title.fad'
		eif
	eif

	run main
; ---

	opt l-

.MACRO	SPRITES
missiles
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 80 C0 E0 30 20 20 20 20 20 20 20 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 04 0C 08 08 0C 04 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player0
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 0C 1E 3F 3F 7F FF 5F 3F 7F FD FB 7E 7E 34 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 01 00 01 03 00
	.he 03 01 03 03 03 07 03 07 0F 07 0F 1F 0F 3F 1F 3B
	.he 3F 2D 5D 4D 5D 5D 7F D1 60 E0 E0 60 E0 60 2A 7F
	.he 3F 3F 3F 17 37 17 93 97 05 01 00 00 80 40 40 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 0D 0D 0D 0D 0D 0D 0D 0D
	.he 0D 0D 1D 19 39 F1 E1 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 70 F8 7C BC FE FE FF FF FB FE F6 BC 08 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 01
	.he 00 01 00 02 02 00 06 04 00 0C 08 00 18 00 10 02
	.he 00 29 11 19 11 51 40 17 C8 80 80 C0 80 C0 E0 C0
	.he E0 E0 E0 F4 64 74 36 14 0D 81 80 40 20 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 B0 B0 B0 B0 B0 B0 B0 B0
	.he B0 B0 B8 98 9C 8F 87 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player2
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 01 01 03 0F 1F 3F FF FF CF 9F DF FF FF
	.he F6 F2 F8 FC FC F8 F8 B0 C0 C0 C0 E0 C0 F0 E0 F0
	.he F0 F0 F8 F0 F0 F0 F8 F0 F8 70 70 70 7C FC F8 BC
	.he BE DC 9E DE DE F8 F0 F0 80 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 1D 1D 11 14 1D 1D 00
	.he 3F 00 3B 0A 22 3B 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player3
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 01 06 18 30 60 00 80 18 B0 10 00 80
	.he 04 06 02 00 00 00 00 20 10 10 18 08 1C 04 0C 04
	.he 04 06 02 06 06 04 00 04 80 44 44 04 00 00 02 20
	.he 20 11 30 10 10 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 D8 DC 14 54 DC D8 00
	.he FE 00 BA 8A A2 BA 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
.ENDM

USESPRITES = 1

.MACRO	DLINEW
	mva <:1 NMI.dliv
	ift [>?old_dli]<>[>:1]
	mva >:1 NMI.dliv+1
	eif

	ift :2
	lda regA
	eif

	ift :3
	ldx regX
	eif

	ift :4
	ldy regY
	eif

	rti

	.def ?old_dli = *
.ENDM

