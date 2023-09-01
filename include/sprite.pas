var
	yOfs:Byte;
	sprOfs:Word;

procedure copySpriteMole;
begin
  sprOfs:=moleSprite shl 4;
  yOfs:=12+mY;
  move(pointer(SPRITES1_ADDR+sprOfs),pointer(PMG_ADDR+yOfs),16);
  move(pointer(SPRITES2_ADDR+sprOfs),pointer(PMG_ADDR+$0100+yOfs),16);
end;

procedure updateMolePosition();
begin
	if (mY<>omY) then
	begin
    yOfs:=12+omY;
    asm
      ldx yOfs
      ldy #16
      lda #0
    clearLoop:
      sta PMG_ADDR,x
      sta PMG_ADDR+$100,x
      inx
      dey
      bne clearLoop
    end;
    copySpriteMole;
		omY:=mY;
	end;

	HPOSP[0]:=49+mX; HPOSP[1]:=49+mX;
end;

procedure setMoleSprite(nSpr:Byte);
begin
	if (nSpr=moleSprite) then exit;
	moleSprite:=nSpr;
  copySpriteMole;
end;
