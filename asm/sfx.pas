var
	channels:array[0..15] of byte absolute SFX_CHANNELS_ADDR;
//	sfxPtr:word absolute $f7;
//	chnOfs:byte absolute $F9;
//	chnFreq:byte absolute $Fa;
//	chnMod:byte absolute $Fb;
//	chnCtrl:byte absolute $Fc;
	sfx:array[0..127] of word absolute SFX_DATA_ADDR;

	audctl:byte absolute $D208;
	skctl:byte absolute $D20F;

	oldVBL:pointer;

procedure SFX_tick(); Assembler; Interrupt;
asm
{
xitvbl   = $e462;
sysvbv   = $e45c;
audf     = $d200;
audc     = $d201;

sfxPtr	= $f7; // SFX - Current channel SFX Pointer (2 bytes)
chnOfs	= $f9; // SFX - Current channel Offset in SFX definition
chnFreq	= $fa; // SFX - Current channel Frequency
chnMod	= $fb; // SFX - Current channel Modulator
chnCtrl	= $fc; // SFX - Current changel Control

				 phr

         lda 20  ; delay
         and #1  ; 1 tick by 2 frames= 25 ticks/s
         bne tick_start
         plr
         jmp xitvbl
         rts

tick_start
				 ldx #0  ; channel ; channels data offset

* pobieranie danych kanalu
* pobierz wskaznik SFXa
chnset   lda SFX_CHANNELS_ADDR,x
         sta sfxPtr
         lda SFX_CHANNELS_ADDR+1,x
         sta sfxPtr+1

* pobierz offset SFXa
         lda SFX_CHANNELS_ADDR+2,x
         sta chnOfs

* pobierz freq SFXa
         lda SFX_CHANNELS_ADDR+3,x
         sta chnFreq

* pobierz dane SFXa
* sprawdz offset
         ldy chnOfs
         cpy #$ff ; ff=no SFX
         beq noSFX
* wartosc modulatora
         lda (sfxPtr),y
         cmp #$80 ; 80=end SFX data
         beq sfxend
         sta chnMod
         iny
* znieksztalcenia+glosnosc
         lda (sfxPtr),y
         sta chnCtrl

* obsluga modulatora
* slide freq up/down
* 0 no slide, <$80 up, >$80 down
         lda chnMod
         beq setPokey
         jsr modulators

; tu gra
setPokey txa
         lsr @
         tax
         lda chnFreq
         sta audf,x
         lda chnCtrl
         sta audc,x
         txa
         asl @
         tax

nextchn  clc
         lda chnOfs
         adc #2
         sta SFX_CHANNELS_ADDR+2,x
savFreq  lda chnFreq
         sta SFX_CHANNELS_ADDR+3,x
noSFX    inx
         inx
         inx
         inx
         cpx #$10
         bne chnset
         jmp endtick

sfxend   txa
         lsr @
         tax
         lda #0
         sta audf,x
         sta audc,x
         txa
         asl @
         tax
         lda #$ff
         sta SFX_CHANNELS_ADDR+2,x
         jmp savFreq

endtick  plr
         jmp xitvbl
         rts

;
modulators
         clc
         adc chnFreq
         sta chnFreq

         rts
};
end;

procedure SFX_Init();
var
	i:byte;

begin
  for i:=0 to 15 do
  begin
		if (i mod 4=2) then
			channels[i]:=$ff
		else
			channels[i]:=$00;
  end;

	audctl:=%00000000;
	skctl:=%00;
	skctl:=%11;
	GetIntVec(iVBL, oldVBL);
  SetIntVec(iVBL, @SFX_tick);
  nmien := $40;
end;

procedure SFX_Play(chn,freq:byte; sfxID:word);
begin
	chn:=chn shl 2;
	channels[chn+0]:=lo(sfx[sfxID]);
	channels[chn+1]:=hi(sfx[sfxID]);
	channels[chn+2]:=0;
	channels[chn+3]:=freq;
end;
