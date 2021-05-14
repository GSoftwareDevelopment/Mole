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
