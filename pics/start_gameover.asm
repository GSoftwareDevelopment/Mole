/***************************************/
/*  Use MADS http://mads.atari8.info/  */
/*  Mode: DLI (char mode)              */
/***************************************/

	icl "start_gameover.h"

	org $f0

fcnt	.ds 2
fadr	.ds 2
fhlp	.ds 2
cloc	.ds 1
regA	.ds 1
regX	.ds 1
regY	.ds 1

WIDTH	= 32
HEIGHT	= 30

; ---	BASIC switch OFF
	org $2000\ mva #$ff $D301\ rts\ ini $2000

; ---	MAIN PROGRAM
	org $2000
ant	dta $44,a(scr)
	dta $04,$84,$84,$84,$84,$84,$84,$84,$84,$84,$04,$84,$84,$04,$04,$04
	dta $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04
	dta $41,a(ant)

scr	ins "start_gameover.scr"

	.ds 0*40

	.ALIGN $0400
fnt	ins "start_gameover.fnt"

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
	mva >pmg $D407		;missiles and players data address
	mva #$03 $D01D		;enable players and missiles
	eif

	lda:cmp:req $14		;wait 1 frame

	sei			;stop IRQ interrupts
	mva #$00 $D40E		;stop NMI interrupts
	sta $D400
	mva #$fe $D301		;switch off ROM to get 16k more ram

	mwa #NMI $fffa		;new NMI handler

	mva #$c0 $D40E		;switch on NMI+DLI again

	ift CHANGES		;if label CHANGES defined

_lp	lda $D010		; FIRE #0
	beq stop

	lda $D011		; FIRE #1
	beq stop

	lda $D01F		; START
	and #1
	beq stop

	lda $D20F
	and #$04
	bne _lp			;wait to press any key; here you can put any own routine

	els

null	jmp DLI.dli1		;CPU is busy here, so no more routines allowed

	eif


stop
	mva #$00 $D01D		;PMG disabled
	tax
	sta:rne $D000,x+

	mva #$ff $D301		;ROM switch on
	mva #$40 $D40E		;only NMI interrupts, DLI disabled
	cli			;IRQ enabled

	rts			;return to ... DOS

; ---	DLI PROGRAM

.local	DLI

	?old_dli = *

	ift !CHANGES

dli1	lda $D010		; FIRE #0
	beq stop

	lda $D011		; FIRE #1
	beq stop

	lda $D01F		; START
	and #1
	beq stop

	lda $D20F
	and #$04
	beq stop

	lda $D40B
	cmp #$02
	bne dli1

	:3 sta $D40A

	DLINEW dli4

	eif

dli_start

dli4
	sta regA
	stx regX
	sty regY

c6	lda #$16
c7	ldx #$04
c8	ldy #$02
	sta $D40A		;line=24
	sta $D016
	stx $D017
	sty $D018
c9	lda #$2C
	sta $D019
	DLINEW dli5 1 1 1

dli5
	sta regA
	stx regX
	sty regY

c10	lda #$14
c11	ldx #$12
c12	ldy #$28
	sta $D40A		;line=32
	sta $D017
	stx $D018
	sty $D019
	DLINEW dli6 1 1 1

dli6
	sta regA
	stx regX
	sty regY

c13	lda #$02
c14	ldx #$14
c15	ldy #$04
	sta $D40A		;line=40
	sta $D017
	stx $D018
	sty $D019
	DLINEW dli7 1 1 1

dli7
	sta regA
	stx regX
	sty regY

c16	lda #$14
c17	ldx #$12
c18	ldy #$14
	sta $D40A		;line=48
	sta $D017
	stx $D018
	sty $D019
	sta $D40A		;line=49
	sta $D40A		;line=50
	lda #$00
	sta $D40A		;line=51
	sta $D01B
	DLINEW dli8 1 1 1

dli8
	sta regA
	stx regX

c19	lda #$04
c20	ldx #$02
	sta $D40A		;line=56
	sta $D017
	stx $D018
	DLINEW dli9 1 1 0

dli9
	sta regA
	stx regX
	sty regY

c21	lda #$00
c22	ldx #$0E
c23	ldy #$00
	sta $D40A		;line=64
	sta $D016
	sta $D017
	stx $D018
	sty $D019
	DLINEW dli10 1 1 1

dli10
	sta regA
	stx regX
	sty regY

c24	lda #$04
c25	ldx #$02
c26	ldy #$D6
	sta $D40A		;line=72
	sta $D016
	stx $D017
	sty $D018
c27	lda #$2C
	sta $D019
	DLINEW dli11 1 1 1

dli11
	sta regA

	lda #$01
	sta $D40A		;line=80
	sta $D01B
	DLINEW dli12 1 0 0

dli12
	sta regA
	stx regX
	sty regY

	lda #$00
x2	ldx #$67
c28	ldy #$D0
	sta $D40A		;line=88
	sta $D01B
	stx $D000
	sty $D012
	DLINEW dli13 1 1 1

dli13
	sta regA
	stx regX
	sty regY

c29	lda #$00
c30	ldx #$0E
c31	ldy #$00
	sta $D40A		;line=104
	sta $D016
	sta $D017
	stx $D018
	sty $D019
	lda #$01
	sta $D01B
	DLINEW dli14 1 1 1

dli14
	sta regA

c32	lda #$00
	sta $D40A		;line=112
	sta $D018

	lda regA
	rti


.endl

; ---

CHANGES = 1
FADECHR	= 0

SCHR	= 127

; ---

.proc	NMI

	bit $D40F
	bpl VBL

	jmp DLI.dli_start
dliv	equ *-2

VBL
	sta regA
	stx regX
	sty regY

	sta $D40F		;reset NMI flag

	mwa #ant $D402		;ANTIC address program

	mva #$39 $D400	;set new screen width

	inc cloc		;little timer

; Initial values

	lda >fnt+$400*$00
	sta $D409
c0	lda #$00
	sta $D01A
c1	lda #$04
	sta $D016
c2	lda #$02
	sta $D017
c3	lda #$08
	sta $D018
c4	lda #$3A
	sta $D019
	lda #$02
	sta $D401
	lda #$01
	sta $D01B
s0	lda #$00
	sta $D008
x0	lda #$60
	sta $D000
c5	lda #$C0
	sta $D012
x1	lda #$00
	sta $D001
	sta $D002
	sta $D003
	sta $D004
	sta $D005
	sta $D006
	sta $D007
	sta $D009
	sta $D00A
	sta $D00B
	sta $D00C
	sta $D013
	sta $D014
	sta $D015

	mwa #DLI.dli_start dliv	;set the first address of DLI interrupt

;this area is for yours routines

quit
	lda regA
	ldx regX
	ldy regY
	rti

.endp

; ---
	run main
; ---

	opt l-

.MACRO	SPRITES
missiles
	.ds $100
player0
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 20 22 22 36 36
	.he 36 BE FF FF 7F 7E 2C 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 38 6C 4E 1F 5F 5B D5 E0 E0 E0 E0 C0 80 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.he 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
player1
	.ds $100
player2
	.ds $100
player3
	.ds $100
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

