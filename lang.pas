uses Atari,zx5;

const
{$I 'memory-lang.inc'}
{$R 'lang.rc'}

  TOP_SELECTOR: Array[0..13] of byte = (
    $8C, $8D, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8F, $90
  );
  BTM_SELECTOR: Array[0..13] of byte = (
    $A2, $A3, $A4, $A4, $A4, $A4, $A4, $A4, $A4, $A4, $A4, $A4, $A5, $A6
  );
  DLIST_LINE_ADDR:Array[0..7] of word = (
    DLIST_ADDR+14+0*3,
    DLIST_ADDR+14+1*3,
    DLIST_ADDR+14+2*3,
    DLIST_ADDR+14+3*3,
    DLIST_ADDR+14+4*3,
    DLIST_ADDR+14+5*3,
    DLIST_ADDR+14+6*3,
    DLIST_ADDR+14+7*3
  );

var
  VDL:pointer absolute $230;
  VCH:byte absolute 756;
  SCREEN_FLAG_LINE_ADDR:Array[0..7] of word = (
    FLAGS_BEGIN_ADDR+0*FLAGS_LINE_WIDTH,
    FLAGS_BEGIN_ADDR+1*FLAGS_LINE_WIDTH,
    FLAGS_BEGIN_ADDR+2*FLAGS_LINE_WIDTH,
    FLAGS_BEGIN_ADDR+3*FLAGS_LINE_WIDTH,
    FLAGS_BEGIN_ADDR+4*FLAGS_LINE_WIDTH,
    FLAGS_BEGIN_ADDR+5*FLAGS_LINE_WIDTH,
    FLAGS_BEGIN_ADDR+6*FLAGS_LINE_WIDTH,
    FLAGS_BEGIN_ADDR+7*FLAGS_LINE_WIDTH
  );
  scrOfs,
  nscrOfs,
  scrDx:shortint;
  sel:shortint;
  i,j:byte;
  dptr:pointer;
  oldDLVec:pointer;
  oldScrVec:pointer;
  oCol:Array[0..4] of byte;

  tm:Byte absolute $14;
  otm:Byte;
  Fire:byte absolute $284;
  joy:Byte absolute $278;
  oJoy:Byte;
  key:Byte absolute 764;
  oKey:Byte;
  dir:byte;

  adr1,adr2:word;

{$I 'asm/sfx.pas'}

procedure delay(ticks:Byte); Assembler;
asm
	lda ticks
	beq endDelay
loopDelay:
	lda $14
	cmp $14
	beq *-2
	dec ticks
	bne loopDelay
endDelay:
end;

procedure init;
begin
  oldDLVec:=pointer(VDL);
  SFX_Init;
  VDL:=pointer(DLIST_ADDR);
  VCH:=CHARSET1_PAGE;
  for i:=0 to 4 do oCol[i]:=peek(708+i);
  poke(708,$26);
  poke(709,$0e);
  poke(710,$72);
  poke(711,$ea);
  poke(712,$00);
  fillchar(pointer(SCREEN_ADDR),SCREEN_SIZE,$B3);
end;

procedure drawSelector(x:byte);
begin
  move(@TOP_SELECTOR,pointer(TOP_SELECTOR_ADDR+x),14);
  move(@BTM_SELECTOR,pointer(BTM_SELECTOR_ADDR+x),14);
  adr2:=FLAGS_BEGIN_ADDR+FLAGS_LINE_WIDTH+x;
  for j:=0 to 5 do
  begin
    poke(adr2,$91);
    inc(adr2,13);
    poke(adr2,$91);
    inc(adr2,FLAGS_LINE_WIDTH-13);
  end;
end;

procedure drawFlags();
begin
  fillchar(pointer(TOP_SELECTOR_ADDR),FLAGS_LINE_WIDTH,$B3);
  fillchar(pointer(BTM_SELECTOR_ADDR),FLAGS_LINE_WIDTH,$B3);
  for i:=0 to 3 do
  begin
    adr1:=FLAGS_ADDR+i*FLAG_SIZE;
    adr2:=FLAGS_BEGIN_ADDR+FLAGS_LINE_WIDTH+(i+1)*13+1;
    for j:=0 to 5 do
    begin
      poke(adr2-1,$b3);
      poke(adr2+12,$b3);
      move(pointer(adr1),pointer(adr2),12);
      inc(adr1,12);
      inc(adr2,FLAGS_LINE_WIDTH);
    end;
  end;
  drawSelector(sel*13);
end;

procedure scrollFlags;
begin
  for i:=0 to 7 do
    dpoke(DLIST_LINE_ADDR[i],SCREEN_FLAG_LINE_ADDR[i]+scrOfs);
end;

begin
  init;
  sel:=1;
  drawFlags;
  scrOfs:=$0;
  nscrOfs:=$0;
  scrollFlags;

  otm:=tm;
  repeat
    if (joy<>oJoy) or (key<>oKey) or (Fire=0) then
    begin
      if Fire=0 then key:=12;
      if (joy<>15) or (key<>255) then
      begin
        dir:=0;
        if (joy=11) or (key=6) then dir:=1;
        if (joy= 7) or (key=7) then dir:=2;
        if dir<>0 then SFX_Play(0,50,3-dir);
        case dir of
          1: begin
                dec(sel); if sel<1 then sel:=4;
                dec(nscrOfs,13);
                if nscrOfs<0 then inc(nscrOfs,13*4);
                drawFlags;
              end;
          2: begin
                inc(sel); if sel>4 then sel:=1;
                inc(nscrOfs,13);
                if nscrOfs>13*4-1 then dec(nscrOfs,13*4);
                drawFlags;
              end;
        end;
      end;
      oJoy:=joy; oKey:=key; key:=255;
    end;
    if (byte(tm-otm)>0) then
    begin
      otm:=tm;
      if nscrOfs<>scrOfs then
      begin
        if nscrOfs<scrOfs then
        begin
          dec(scrOfs,1);
          if scrOfs<0 then scrOfs:=13*4-1;
        end;
        if nscrOfs>scrOfs then
        begin
          inc(scrOfs,1);
          if scrOfs>13*4-1 then scrOfs:=0;
        end;
        scrollFlags;
      end;
    end;
  until (oKey=28) or (oKey=12);
  tm:=0;
  if oKey=12 then
  begin
    poke(559,0);
    SFX_Play(0,50,0);
    case sel of
      2:  begin // cz
            GetResourceHandle(dptr,'letters_cz');
            unZX5(dptr,pointer(LETTERS));
            GetResourceHandle(dptr,'title_b_cz');
            unZX5(dptr,pointer(TITLE_B));
            GetResourceHandle(dptr,'scl_cz');
            unZX5(dptr,pointer(SCROLLS));
            GetResourceHandle(dptr,'STR_cz');
            unZX5(dptr,pointer(STRINGS));
          end;
      1:  begin // pl
            GetResourceHandle(dptr,'letters_plen');
            unZX5(dptr,pointer(LETTERS));
            GetResourceHandle(dptr,'title_b_plen');
            unZX5(dptr,pointer(TITLE_B));
            GetResourceHandle(dptr,'scl_pl');
            unZX5(dptr,pointer(SCROLLS));
            GetResourceHandle(dptr,'STR_pl');
            unZX5(dptr,pointer(STRINGS));
          end;
      3:  begin // en
            GetResourceHandle(dptr,'letters_plen');
            unZX5(dptr,pointer(LETTERS));
            GetResourceHandle(dptr,'title_b_plen');
            unZX5(dptr,pointer(TITLE_B));
            GetResourceHandle(dptr,'scl_en');
            unZX5(dptr,pointer(SCROLLS));
            GetResourceHandle(dptr,'STR_en');
            unZX5(dptr,pointer(STRINGS));
          end;
      4:  begin // de
            GetResourceHandle(dptr,'letters_de');
            unZX5(dptr,pointer(LETTERS));
            GetResourceHandle(dptr,'title_b_de');
            unZX5(dptr,pointer(TITLE_B));
            GetResourceHandle(dptr,'scl_de');
            unZX5(dptr,pointer(SCROLLS));
            GetResourceHandle(dptr,'STR_de');
            unZX5(dptr,pointer(STRINGS));
          end;
    end;
  end;
  repeat until tm>25;
  SFX_Done;
  if oKey=28 then
  begin
    VCH:=$e0;
    for i:=0 to 4 do poke(708+i,oCol[i]);
    VDL:=pointer(oldDLVec);
    asm
      jmp (dosvec)
    end;
  end;
end.