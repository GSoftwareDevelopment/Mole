var
	title:array[0..SCR_TITLE_SIZE-1] of byte absolute SCR_TITLE_ADDR;
	titleSh:array[0..SCR_TITLESHADOW_SIZE-1] of byte absolute SCR_TITLESHADOW_ADDR;

procedure moveZero(src,dst:pointer; size:byte);
var
	srcptr:word absolute $e8;
	dstptr:word absolute $ea;
	count:byte absolute $e7;

begin
	if size=0 then exit;
	srcptr:=word(src); dstptr:=word(dst); count:=size;
	asm {
			ldy #00
		lp:
			lda (srcptr),y
			beq nxt
			sta (dstptr),y
		nxt:
			iny
			cpy count
			bne lp
	};
end;

procedure SlideLeft(y:byte; ln:word; ofs:byte);
var
	txtofs,scrofs:word;

begin
	scrofs:=leftBound[y]; //y shl 5+y shl 3; // oblicz linię ekranu
	txtofs:=ln shl 6; // oblicz linię tekstu
	if (ofs<=32) then
	begin
		txtofs:=txtofs+(32-ofs); // offset tekstu
		movezero(@title[txtofs],@buffer[scrofs],ofs);
		txtofs:=txtofs+32; scrofs:=scrofs+40; // następna linia (tekstu i ekranu)
		movezero(@title[txtofs],@buffer[scrofs],ofs);
	end
	else
	begin
		scrofs:=scrofs+(ofs-32);
		movezero(@title[txtofs],@buffer[scrofs],30);
		txtofs:=txtofs+32; scrofs:=scrofs+40; // następna linia (tekstu i ekranu)
		movezero(@title[txtofs],@buffer[scrofs],30);
	end;
end;

procedure SlideRight(y:byte; ln:word; ofs:byte);
var
	txtofs,scrofs:word;

begin
	// y:=y+1;
	scrofs:=rightBound[y]-ofs;// y shl 5+y shl 3-ofs; // oblicz linię ekranu
	txtofs:=ln shl 6; // oblicz linię tekstu
	if (ofs<=32) then
	begin
		movezero(@title[txtofs],@buffer[scrofs],ofs);
		txtofs:=txtofs+32; scrofs:=scrofs+40; // następna linia (tekstu i ekranu)
		movezero(@title[txtofs],@buffer[scrofs],ofs);
	end
	else
	begin
		movezero(@title[txtofs],@buffer[scrofs],30);
		txtofs:=txtofs+32; scrofs:=scrofs+40; // następna linia (tekstu i ekranu)
		movezero(@title[txtofs],@buffer[scrofs],30);
	end;
end;

procedure TitleIn();
var
	x,j,i:byte;
	ofs,outofs:word;

begin
	for i:=1 to 36 do
	begin
		slideLeft(0,0,i);
		slideRight(2,1,i-1);
		slideLeft(4,2,i);
		slideRight(6,3,i-1);
		slideLeft(8,4,i);
		move(@buffer,@scr[81],440);
		wait4screen();
		fillchar(@buffer,480,0);
	end;
	for x:=0 to 20 do
	begin
		outofs:=0;
		for i:=0 to 13 do
		begin
			ofs:=leftBound[i];
			move(@titleSh[ofs],@scr[outofs],x);
			j:=40-x;
			outofs:=outofs+j;
			ofs:=ofs+j;
			move(@titleSh[ofs],@scr[outofs],x);
			ofs:=ofs+x;
			outofs:=outofs+x;
		end;
		wait4screen();
	end;
end;

procedure setLogos();
const LOGOS_YPOS = 221;
begin
	HPOSP[0]:=48; HPOSP[1]:=56; // ATARI Logo positions
	PCOL[0]:=15; PCOL[1]:=15; PCOL[2]:=15; PCOL[3]:=15;
	HPOSP[2]:=192; HPOSP[3]:=200; // GSD Logo positions
	move(@logos,@pmg[$000+LOGOS_YPOS],16);
	move(@logos[16],@pmg[$100+LOGOS_YPOS],16);
	move(@logos[32],@pmg[$200+LOGOS_YPOS],16);
	move(@logos[48],@pmg[$300+LOGOS_YPOS],16);
end;

procedure titleInScreen();
begin
	initPMG();
	setDL(DLIST_TITLE_ADDR,@dli_title);
// set character
	CHBAS:=CHARSET1_PAGE;
	fillchar(@scr,SCREEN_TITLE_SIZE,0);
	fillchar(@buffer,512,0);

	setScroll(scroll_title);

	onVideo();
	setLogos();
	TitleIn();

	gameOver:=true;
end;

procedure titleScreen();
begin
	initPMG();
	setDL(DLIST_TITLE_ADDR,@dli_title);
// set character
	CHBAS:=CHARSET1_PAGE;
	fillchar(@scr,SCREEN_TITLE_SIZE,0);
	fillchar(@buffer,512,0);
	move(@titlesh,@scr,SCR_TITLESHADOW_SIZE);

	setScroll(scroll_title);

	onVideo();
	setLogos();
	gameOver:=true;
end;
