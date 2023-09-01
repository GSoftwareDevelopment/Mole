fr0L		= $70;
fr0H		= $71;

moleX		= $72;
moleY		= $73;
XW			= $74; // block X postion+Width
YH			= $75; // block Y postion+Height
bm			= $76; // number of landslide blocks. 0 means that no blocks have fallen
tb			= $77; // total blocks on screen
Xpos		= $78;
Ypos		= $79;
Block		= $7a;
Color		= $7b;
BlockW	= $7c;
BlockH	= $7d;
CMask		= $7e;

scrvec	= $60; // 2 Bytes
defvec	= $62; // 2 Bytes
lstvec	= $64; // 2 Bytes
tmpadr	= $66; // 2 Bytes

_RAND = $d20a;

;
;
;

drawBlock							; rusuj blok
		  jsr _calc_adr

; ustal maske koloru
      ldy Color
      lda mask,y
      sta CMask

; rysowanie

      ldx BlockH

DrawStrt ldy #0
DrawNxt  lda (tmpadr),y
      beq DrawSkip  ; jezeli 0,pomin

      ora CMask
      sta (scrvec),y

DrawSkip iny
      cpy BlockW
      bne DrawNxt

      jsr _incadr

; zmniejsz i sprawdz, czy BlockH=0
      dex
      ; cpx #0
      bne DrawStrt ; jezeli nie, rysuj

      rts

;
;
;

testBlock								; Kolizja bloku
		  jsr _calc_adr

      lda #0
      sta fr0H

; Sprawdzanie kolizji

      ldx BlockH
      txa
      clc
      adc YPos
      cmp #13
      bcs colision

TestStrt
      ldy #0
TestNxt
      lda (tmpadr),y
      beq TestSkip ; jezeli 0,pomin

      lda (scrvec),y
      beq TestSkip

; wystepuje kolizja! zakoncz
colision
      lda #1
      jmp TestEnd

TestSkip iny
      cpy BlockW
      bne TestNxt

      jsr _incadr

; zmniejsz licznik wysokości bloku i sprawdz, czy =0

      dex
      ; cpx #0
      bne TestStrt ; jezeli nie, sprawdzaj dalej

; nie ma kolizji
      cld
      lda #0
TestEnd
      sta fr0L

      rts



clearBlock								; kasuj blok
		  jsr _calc_adr

      ldx BlockH

ClrStrt
      ldy #0
ClrNxt
      lda (tmpadr),y
      beq ClrSkip ; jezeli 0,pomin

      lda #0
      sta (scrvec),y

ClrSkip
      iny
      cpy BlockW
      bne ClrNxt

      jsr _incadr

; zmniejsz i sprawdz, czy BlockH=0
      dex
      ; cpx #0
      bne ClrStrt    ; jezeli nie, rysuj

      rts



; opusc bloki o jeden wiersz jezeli moga spasc
dropBlocks
      lda #0
      sta BM

; pobierz ilosc blokow

      lda TB
      beq EndDrop

      asl @      ;razy 4, aby uzyskać offset na liście bloków
      asl @

      sec
      sbc #4     ;zmniejsz o 4, aby offset wskazywał na ostatni blok na liście

DropLoop sta TB     ;zapisz TB
      tay

; pobierz dane bloku
; (x,y,Block,Color)

      lda (lstvec),y
      sta Xpos
      iny
      lda (lstvec),y
      sta Ypos
      iny
      lda (lstvec),y
      sta Block
      iny
      lda (lstvec),y
      sta Color

      jsr clearBlock
      inc Ypos
      jsr testBlock
      dec Ypos
      cmp #1
      beq NoDrop

      inc BM

      clc
      lda Ypos	; TODO: zamienić na ldy Ypos, iny, sty Ypos
      adc #1		; pamiętaj o korekcie adresów skoków w pliku block.pas
      sta Ypos ;
      ldy TB
      iny
      sta (lstvec),y

NoDrop   jsr drawBlock

      sec
      lda TB
      sbc #4
      bcs DropLoop

EndDrop
      lda #0
      sta fr0H
      lda BM
      sta fr0L

      rts


pointTest										; testowanie pozycji na liscie blokow
      lda #0
      sta fr0H
      lda #$ff
      sta fr0L

; pobierz ilosc blokow

      lda TB
      beq EndPtTst	; jeżeli równa 0 (zero) zakończ test

_TB
      asl @      ;razy 4
      asl @

      sec
      sbc #4     ;zmniejsz o 4

PtTstLoop
		  sta TB     ; zapisz TB
      tay

; pobierz dane bloku
; (x,y,Block,Color)

      lda (lstvec),y
      sta Xpos
      iny
      lda (lstvec),y
      sta Ypos
      iny
      lda (lstvec),y
      sta Block
      iny
      lda (lstvec),y
      sta Color

; oblicz adres definicji bloku

      lda defvec+1
      sta tmpadr+1
      jsr _calc_dadr

; oblicz XW i YH bloku

      lda Xpos
      adc BlockW
      sta XW ; Xpos+BlockW

      lda Ypos
      adc BlockH
      sta YH ; Ypos+BlockH

; sprawdz, czy:
; Xpos>=moleX>=XW oraz
; Ypos>=moleY>=YH

; moleX>=Xpos? (MX>=X)

      lda moleX
      cmp Xpos
      bmi NxtPtTst ; moleX<Xpos?

; moleX<XW (MX<=XW-1)
      cmp XW
      bpl NxtPtTst ; moleX<XW?

; moleY>=Ypos? (MY>=Y)

      lda moleY
      cmp Ypos
      bmi NxtPtTst ; moleY<Ypos?

; moleY<YH (MY<=YH-1)
      cmp YH
      bpl NxtPtTst ; moleY<YH?

; punkt znajduje sie w obszarze bloku
; wyliczenie adresu wew. bloku
      sec
      lda moleY
      sbc Ypos
      tay
      clc
      beq _nomul ; moleY-Ypos=0?

; tmpadr=tmpadr+BlockW;(moleY-Ypos)

      lda tmpadr
_mul
      adc BlockW
      dey
      bne _mul
      sta tmpadr

_nomul
      lda moleX
      sec
      sbc Xpos
      clc
      adc tmpadr
      sta tmpadr

; sprawdź, czy wartość spod adresu tmpadr jest równa 0
      lda (tmpadr),y
      beq NxtPtTst
      lda TB
      lsr @
      lsr @
      sta fr0L
      jmp clearBlock

NxtPtTst
      sec
      lda TB
      sbc #4
      bcs PtTstLoop

EndPtTst
      rts


shuffleBlock								; losuj linie blokow
; pobierz index TB
      lda TB
      asl @
      asl @
      sta TB

; pobierz nr linii ekranu
;         lda _Ypos
;         sta Ypos

      lda #0
      sta BM

      lda #1
      sta Xpos

; losuj blok...
shufLoop
      cmp #18
      beq EndShuffle

      sec
      lda _rand
      and #31
      cmp #18
      bmi _nosbc
      sbc #18
; ...i kolor
_nosbc
      sta Block
      lda _rand
      and #%00000011
      sta Color

      jsr testBlock
      bne nxtShuf
      jsr drawBlock

; zapisz na liscie blokow

      ldy TB
      lda Xpos
      sta (lstvec),y
      iny
      lda Ypos
      sta (lstvec),y
      iny
      lda Block
      sta (lstvec),y
      iny
      lda Color
      sta (lstvec),y
      iny

      sty TB

      inc BM
nxtShuf
      inc Xpos
      lda Xpos
      jmp shufLoop

endShuffle
      lda #0
      sta fr0H
      lda BM
      sta fr0L

      rts

;
;
;

randomBottomBlock								; losuje jeden blok znajdujacy sie na samym dole
      lda #0
      sta fr0H

      lda TB
      beq endRndBttmBlk_noBlocksFound
; oblicz offset
      asl @
      asl @
      sta TB

      ldx #0									; usaw ilość znalezionych bloków na 0 (zero)

; wyszukaj bloki przylegające do dolnej krawędzi pola gry
findNext
      sec
      lda TB
      sbc #4
      bcc endFind

      sta TB
      tay

; pobierz dane bloku
      lda (lstvec),y
      sta Xpos
      iny
      lda (lstvec),y
      sta Ypos
      iny
      lda (lstvec),y
;				.print "break at ",*
	cmp #17				; wybieraj TYLKO bloki, nie "coinsy"!
      beq findNext

      sta Block
      asl @
      asl @
      asl @
      tay
      iny
      clc
      lda (defvec),y
      adc Ypos

; sprawdz, czy blok przylega do dolnej krawedzi
      cmp #11
      bne findNext

; zapisz offset bloku w tablicy bttmBlks
      lda TB
      sta bttmBlks,x
      inx
      jmp findNext
; koniec wyszukiwania
; sprwdzenie, czy został znaleziony jakikolwiek block
endFind
      stx BM
      cpx #0
      bne randOne
; jeżeli nie, zwróć $FF
endRndBttmBlk_noBlocksFound
      ldx #$ff
      stx fr0L
      rts

; losowanie z listy jednego bloku
randOne
      lda _rand
      and #15
tooBig
      cmp BM
      bmi inRange
      sec
      sbc BM
      jmp tooBig

inRange
      tax
; pobranie offsetu wylosowanego bloku
      lda bttmBlks,x

; koniec procedury, zwrócenie offsetu bloku
endDelOne
		  sta fr0L
      lda #0
      sta fr0H

      rts

;
;	PROCEDURY POMOCNICZE
;


_calc_adr 												; oblicz adres ekranu
		  lda 88
      sta scrvec
      lda 89
      sta scrvec+1

; offset dla Ypos z tablicy vadr

      clc
      ldx Ypos
      lda MAIN.ADR.ROWOFS,x
      adc scrvec
      sta scrvec

; dodaj Xpos do scrvec

      clc
      lda Xpos
      adc scrvec
      sta scrvec

      lda defvec+1
      sta tmpadr+1


_calc_dadr										; Wylicz adres definicji klocka
		  lda Block
      asl @
      asl @
      asl @

      clc
      adc defvec
      sta tmpadr

; pobierz wymiary bloku
      ldy #0
      lda (tmpadr),y
      sta BlockW
      iny
      lda (tmpadr),y
      sta BlockH

; zwieksz adres tymczasowy o 2 bajty
      clc
      lda tmpadr
      adc #2
      sta tmpadr

end_calc
      rts


_incadr														; zwieksz adres bloku o jego szer.
		  clc
      lda tmpadr
      adc BlockW
      sta tmpadr

; zwieksz adres ekranu o jego szer.

      clc
      lda scrvec
      adc #20      ; szer. ekr.
      sta scrvec

end_upadr
      rts

; vadr	 dta $00,$14,$28,$3c,$50,$64,$78,$8c,$a0,$b4,$c8,$dc
mask	 dta %00000000, %01000000, %10000000, %11000000
; tablica dla znalezionych bloków
bttmBlks
    dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
