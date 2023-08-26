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
	dta $04,$04,$04,$84,$04,$04,$04,$84,$04,$04,$84,$04,$84,$84,$04,$04
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

	DLINEW dli7

	eif

dli_start

dli7
	sta regA

	sta wsync		;line=40
	sta wsync		;line=41
	lda #$21
	sta wsync		;line=42
	sta gtictl
	DLINEW DLI.dli2 1 0 0

dli2
	sta regA
	stx regX
	lda >fnt+$400*$01
c9	ldx #$D4
	sta wsync		;line=72
	sta chbase
	stx color3
	sta wsync		;line=73
	sta wsync		;line=74
	sta wsync		;line=75
	sta wsync		;line=76
	sta wsync		;line=77
c10	lda #$1C
	sta wsync		;line=78
	sta color1
	DLINEW dli8 1 1 0

dli8
	sta regA
	stx regX
	sty regY

c11	lda #$14
c12	ldx #$1C
c13	ldy #$C4
	sta wsync		;line=96
	sta color1
	stx color2
	sty color3
	sta wsync		;line=97
	sta wsync		;line=98
	sta wsync		;line=99
	sta wsync		;line=100
	sta wsync		;line=101
	sta wsync		;line=102
	lda #$01
	sta wsync		;line=103
	sta gtictl
c14	lda #$2A
c15	ldx #$14
c16	ldy #$12
	sta wsync		;line=104
	sta color1
	stx color2
	sty color3
	DLINEW dli3 1 1 1

dli3
	sta regA
	lda >fnt+$400*$02
	sta wsync		;line=112
	sta chbase
	DLINEW dli4 1 0 0

dli4
	sta regA
	stx regX
	sty regY
	lda >fnt+$400*$00
c17	ldx #$04
c18	ldy #$06
	sta wsync		;line=120
	sta chbase
	stx color0
	sty color1
c19	lda #$0A
	sta color2
c20	lda #$0E
	sta color3
	DLINEW dli9 1 1 1

dli9
	sta regA
	stx regX
	sty regY

x8	lda #$30
x9	ldx #$38
x10	ldy #$C0
	sta wsync		;line=200
	sta hposp0
	stx hposp1
	sty hposp2
x11	lda #$C8
	sta hposp3
c21	lda #$2C
	sta colpm0
	sta colpm1
c22	lda #$08
	sta colpm2
c23	lda #$0E
	sta colpm3
	DLINEW dli10 1 1 1

dli10
	sta regA
	stx regX
	sty regY

c24	lda #$18
	sta wsync		;line=208
	sta colpm0
	sta colpm1
c25	lda #$28
	sta wsync		;line=209
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c26	lda #$38
	sta wsync		;line=210
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c27	lda #$48
	sta wsync		;line=211
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c28	lda #$58
	sta wsync		;line=212
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c29	lda #$68
	sta wsync		;line=213
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c30	lda #$78
	sta wsync		;line=214
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c31	lda #$88
	sta wsync		;line=215
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c32	lda #$98
	sta wsync		;line=216
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c33	lda #$A8
	sta wsync		;line=217
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c34	lda #$B8
	sta wsync		;line=218
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c35	lda #$C8
	sta wsync		;line=219
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c36	lda #$D8
	sta wsync		;line=220
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c37	lda #$E8
	sta wsync		;line=221
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3
c38	lda #$F8
c39	ldx #$08
c40	ldy #$0E
	sta wsync		;line=222
	sta colpm0
	sta colpm1
	stx colpm2
	sty colpm3
c41	lda #$2C
	sta wsync		;line=223
	sta colpm0
	sta colpm1

	lda regA
	ldx regX
	ldy regY
	rti

.endl

; ---

CHANGES = 1
FADECHR	= 0

SCHR	= 127

; ---

.proc	NMI

	bit nmist
	bpl VBL

	jmp DLI.dli_start
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
c0	lda #$00
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
	sta sizep0
	sta sizep1
	sta sizep2
	sta sizep3
x0	lda #$84
	sta hposp0
x1	lda #$83
	sta hposp1
x2	lda #$8C
	sta hposp2
x3	lda #$8B
	sta hposp3
x4	lda #$94
	sta hposm0
x5	lda #$82
	sta hposm1
x6	lda #$94
	sta hposm2
x7	lda #$96
	sta hposm3
c5	lda #$04
	sta colpm0
c6	lda #$02
	sta colpm1
c7	lda #$04
	sta colpm2
c8	lda #$02
	sta colpm3
s0	lda #$00
	sta sizem

	mwa #DLI.dli_start dliv	;set the first address of DLI interrupt

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
	.he 00 00 00 00 00 20 20 20 20 20 20 20 20 00 00 00
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
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00
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
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 01 01 01
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
	.he 00 00 00 00 01 03 0F 1F 3F 7F FF CF 9F DF FF FF
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
	.he 00 00 00 00 01 06 18 30 60 40 80 98 B0 90 00 80
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

