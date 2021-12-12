procedure dli_title(); Assembler; Interrupt;
asm {
vdli		= $200;
wsync		= $d40a;
chbase	= $d409;
dmactl	= $d400;

; Register backup for DLI interrupt
_regA 	= $fd;
_regX 	= $fe;
_regY 	= $ff;

dli1_title
				 sta _regA

				 lda #>dli1_menu
				 sta vdli+1
         lda #<dli1_menu
         sta vdli

         lda #$82
         sta wsync
         sta $d016
         lda #$84
         sta $d017
         lda #$26
         sta $d018
         lda #$2a
         sta $d019

				 lda _regA
         rti

dli1_menu
				 sta _regA

				 lda #>dli1_ftr
				 sta vdli+1
         lda #<dli1_ftr
         sta vdli

				 lda #$08
         sta wsync
         sta $d016

         lda #$0f
         sta $d017
         lda #$9a
         sta $d018
         lda #$4a
         sta $d019

         lda _regA
         rti

dli1_ftr
				 sta _regA
				 sty _regY

				 lda #>dli1_title
				 sta vdli+1
         lda #<dli1_title
         sta vdli

         lda #%00111001
         sta wsync
         sta dmactl
         lda #$26
         sta $d016
         lda #$ca
         sta $d017
         lda #$94
         sta $d018

         ldy #15
l1       lda RAINBOW_ADDR,y
         sta wsync
         sta $d012
         sta $d013
         sta $d014
         sta $d015
         sta $d019
         dey
         bne l1

         lda _regA
				 ldy _regY
         rti

; rainbow	 dta $08, $18, $28, $38, $48, $58, $68, $78, $88, $98, $a8, $b8, $c8, $d8, $e8, $f8
};
end;

procedure dli_ready(); Assembler; Interrupt;
asm {
vdli		= $200;
wsync		= $d40a;
chbase	= $d409;
dmactl	= $d400;

; Register backup for DLI interrupt
_regA 	= $fd;
_regX 	= $fe;
_regY 	= $ff;

dli_ready_image_0
				sta _regA
				stx _regX
				sty	_regY

c6			lda #$16
c7			ldx #$04
c8			ldy #$02
				sta wsync		;line=24
				sta $D016
				stx $D017
				sty $D018
c9			lda #$2C
				sta $D019

				lda #>dli_ready_image_1
				sta vdli+1
				lda #<dli_ready_image_1
				sta vdli

				lda _regA
				ldx _regX
				ldy _regY

				rti

dli_ready_image_1
				sta _regA
				stx _regX
				sty	_regY

c10	lda #$14
c11	ldx #$12
c12	ldy #$28
	sta wsync		;line=32
	sta $D017
	stx $D018
	sty $D019

				lda #>dli_ready_image_2
				sta vdli+1
				lda #<dli_ready_image_2
				sta vdli

				lda _regA
				ldx _regX
				ldy _regY

				rti

dli_ready_image_2
				sta _regA
				stx _regX
				sty	_regY

c13	lda #$02
c14	ldx #$14
c15	ldy #$04
	sta wsync		;line=40
	sta $D017
	stx $D018
	sty $D019

				lda #>dli_ready_image_3
				sta vdli+1
				lda #<dli_ready_image_3
				sta vdli

				lda _regA
				ldx _regX
				ldy _regY

				rti

dli_ready_image_3
				sta _regA
				stx _regX
				sty	_regY

c16	lda #$14
c17	ldx #$12
c18	ldy #$14
	sta wsync		;line=48
	sta $D017
	stx $D018
	sty $D019
	sta wsync		;line=49
	sta wsync		;line=50
	lda #$00
	sta wsync		;line=51
	sta $D01B

				lda #>dli_ready_image_4
				sta vdli+1
				lda #<dli_ready_image_4
				sta vdli

				lda _regA
				ldx _regX
				ldy _regY

				rti

dli_ready_image_4
				sta _regA
				stx _regX

c19	lda #$04
c20	ldx #$02
	sta wsync		;line=56
	sta $D017
	stx $D018

				lda #>dli_ready_footer
				sta vdli+1
				lda #<dli_ready_footer
				sta vdli

				lda _regA
				ldx _regX

				rti

dli_ready_footer
				sta _regA
				stx _regX

c21			lda #CHARSET1_PAGE
c22			ldx #$0E
				sta wsync		;line=64
				sta chbase
				stx $D016

				lda #>dli_ready_image_0
				sta vdli+1
				lda #<dli_ready_image_0
				sta vdli

				lda _regA
				ldx _regX

				rti
};
end;

procedure dli_gameover(); Assembler; Interrupt;
asm {
vdli		= $200;
wsync		= $d40a;
chbase	= $d409;
dmactl	= $d400;

; Register backup for DLI interrupt
_regA 	= $fd;
_regX 	= $fe;
_regY 	= $ff;

dli_gameover_footer
				sta _regA
				stx _regX

c23			lda #CHARSET1_PAGE
c24			ldx #$0E
				sta wsync		;line=64
				sta chbase
				stx $D016

				lda _regA
				ldx _regX

				rti
};
end;

procedure dli_game(); Assembler; Interrupt;
asm {
vdli		= $200;
wsync		= $d40a;
chbase	= $d409;
dmactl	= $d400;

; Register backup for DLI interrupt
_regA 	= $fd;
_regX 	= $fe;
_regY 	= $ff;

dli_status_top
				 sta _regA

				 lda #>dli_playfield
				 sta vdli+1
         lda #<dli_playfield
         sta vdli

         lda #CHARSET1_PAGE
         sta wsync
         sta chbase
         lda #$24
         sta $d016
         lda #$Ca
         sta $d017
         lda #$96
         sta $d018
         lda #$46
         sta $d019

         lda _regA
         rti

dli_playfield
				 sta _regA
				 sty _regY

				 lda #>dli_status_bottom
				 sta vdli+1
         lda #<dli_status_bottom
         sta vdli

         lda #$24
         ldy #CHARSET3_PAGE
         sta wsync
         sty chbase
         sta $d016
         lda #$C6
         sta $d017
         lda #$96
         sta $d018
         lda #$46
         sta $d019

         lda _regA
         ldy _regY
         rti

dli_status_bottom
				 sta _regA

				 lda #>dli_status_top
				 sta vdli+1
         lda #<dli_status_top
         sta vdli

				 lda #CHARSET1_PAGE
         sta wsync
         sta chbase
         lda #$e6
         sta $d016
         lda #$e8
         sta $d017
         lda #$ea
         sta $d018

         lda _regA
         rti
};
end;

procedure dli_bests(); Assembler; Interrupt;
asm {
vdli		= $200;
wsync		= $d40a;
chbase	= $d409;

; Register backup for DLI interrupt
_regA 	= $fd;
_regX 	= $fe;
_regY 	= $ff;

dli_bests
				 sta _regA

				 lda #>dli_bests_ftr
				 sta vdli+1
         lda #<dli_bests_ftr
         sta vdli

         lda #CHARSET2_PAGE
         sta wsync
         sta chbase
         lda #$82
         sta $d016
         lda #$84
         sta $d017

         lda #$0a
         sta $d018
         lda #$0f
         sta $d019

         lda _regA
         rti

dli_bests_ftr
				 sta _regA
				 sty _regY

				 lda #>dli_bests
				 sta vdli+1
         lda #<dli_bests
         sta vdli

         lda #CHARSET1_PAGE
         ldy #%00111001
         sta wsync
         sty dmactl
         sta chbase
         lda #$26
         sta $d016
         lda #$ca
         sta $d017
         lda #$94
         sta $d018

         ldy #15
l1       lda RAINBOW_ADDR,y
         sta wsync
         sta $d012
         sta $d013
         sta $d014
         sta $d015
         dey
         bne l1

         lda _regA
				 ldy _regY
         rti

; rainbow	 dta $08, $18, $28, $38, $48, $58, $68, $78, $88, $98, $a8, $b8, $c8, $d8, $e8, $f8
};
end;
