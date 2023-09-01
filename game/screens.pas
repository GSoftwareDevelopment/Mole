procedure setLogos();
const LOGOS_YPOS = 221;
begin
	asm
		ldy #15
	setLoop:
		lda LOGOS_DATA_ADDR+0 ,y
		sta PMG_ADDR+$00+LOGOS_YPOS,y
		lda LOGOS_DATA_ADDR+16,y
		sta PMG_ADDR+$100+LOGOS_YPOS,y
		lda LOGOS_DATA_ADDR+32,y
		sta PMG_ADDR+$200+LOGOS_YPOS,y
		lda LOGOS_DATA_ADDR+48,y
		sta PMG_ADDR+$300+LOGOS_YPOS,y
		dey
		bpl setLoop
	end;
	// move(pointer(LOGOS_DATA_ADDR+0), pointer(PMG_ADDR+$000+LOGOS_YPOS),16);
	// move(pointer(LOGOS_DATA_ADDR+16),pointer(PMG_ADDR+$100+LOGOS_YPOS),16);
	// move(pointer(LOGOS_DATA_ADDR+32),pointer(PMG_ADDR+$200+LOGOS_YPOS),16);
	// move(pointer(LOGOS_DATA_ADDR+48),pointer(PMG_ADDR+$300+LOGOS_YPOS),16);
end;

procedure clearTitlePMG();
begin
	// fillchar(pointer(PMG_ADDR-$100),256,0);
	asm
		lda #0
		ldy #0
	clearPageLoop:
		sta PMG_ADDR-$100,y
		iny
		bne clearPageLoop

		ldy #63
	clearLoop:
		sta PMG_ADDR+$00+48,y
		sta PMG_ADDR+$100+48,y
		sta PMG_ADDR+$200+48,y
		sta PMG_ADDR+$300+48,y
		dey
		bpl clearLoop
	end;
	// fillchar(pointer(PMG_ADDR+$000+48),64,0);
	// fillchar(pointer(PMG_ADDR+$100+48),64,0);
	// fillchar(pointer(PMG_ADDR+$200+48),64,0);
	// fillchar(pointer(PMG_ADDR+$300+48),64,0);
end;

procedure clearScreen();
begin
	fillchar(@scr,SCREEN_TITLE_SIZE,0);
end;

procedure titleScreen();
begin
	initPMG();
	setDL(DLIST_TITLE_ADDR,@dli_title);
// set character
	CHBAS:=CHARSET1_PAGE;
	clearScreen(); // fillchar(@scr,SCREEN_TITLE_SIZE,0);

	move(pointer(SCR_TITLE_ADDR),@scr,SCR_TITLE_SIZE);
	clearTitlePMG();
	asm
		ldy #63
	copyLoop:
		lda G2F_TITLE_PMG+0*64,y
		sta PMG_ADDR-$100+48,y
		lda G2F_TITLE_PMG+1*64,y
		sta PMG_ADDR+$000+48,y
		lda G2F_TITLE_PMG+2*64,y
		sta PMG_ADDR+$100+48,y
		lda G2F_TITLE_PMG+3*64,y
		sta PMG_ADDR+$200+48,y
		lda G2F_TITLE_PMG+4*64,y
		sta PMG_ADDR+$300+48,y
		dey
		bpl copyLoop
	end;
	// move(pointer(G2F_TITLE_PMG+0*64),pointer(PMG_ADDR-$100+48),64);
	// move(pointer(G2F_TITLE_PMG+1*64),pointer(PMG_ADDR+$000+48),64);
	// move(pointer(G2F_TITLE_PMG+2*64),pointer(PMG_ADDR+$100+48),64);
	// move(pointer(G2F_TITLE_PMG+3*64),pointer(PMG_ADDR+$200+48),64);
	// move(pointer(G2F_TITLE_PMG+4*64),pointer(PMG_ADDR+$300+48),64);


	onVideo();
	setLogos();
	setScroll(scroll_title);
	gameOver:=true;
end;

procedure HistoryScreen();
begin
	setDL(DLIST_HISTORY_ADDR,@dli_bests);
// set character
	CHBAS:=CHARSET1_PAGE;
	clearTitlePMG();
	clearScreen(); // fillchar(@scr,SCREEN_HISTORY_SIZE,$00);
	scrofs:=0;
	for i:=0 to 19 do	begin	scr[scrofs]:=$34; scrofs:=scrofs+1; scr[scrofs]:=$35; scrofs:=scrofs+1;	end;
	for i:=0 to 19 do	begin	scr[scrofs]:=$38; scrofs:=scrofs+1; scr[scrofs]:=$39; scrofs:=scrofs+1;	end;
	fillchar(@scr[SCREEN_HISTORY_SIZE-100],80,$3a);
	scrofs:=SCREEN_HISTORY_SIZE-60;
	for i:=0 to 19 do	begin	scr[scrofs]:=$36; scrofs:=scrofs+1; scr[scrofs]:=$37; scrofs:=scrofs+1;	end;
	onVideo();
end;

procedure BestsScreen();
begin
	HistoryScreen();
// 	setDL(DLIST_BESTS_ADDR,@dli_bests);
// // set character
// 	CHBAS:=CHARSET1_PAGE;
// 	clearTitlePMG();
// 	fillchar(@scr,SCREEN_BESTS_SIZE,$00);
// 	scrofs:=0;
// 	for i:=0 to 19 do	begin	scr[scrofs]:=$34; scrofs:=scrofs+1; scr[scrofs]:=$35; scrofs:=scrofs+1;	end;
// 	for i:=0 to 19 do	begin	scr[scrofs]:=$38; scrofs:=scrofs+1; scr[scrofs]:=$39; scrofs:=scrofs+1;	end;
// 	fillchar(@scr[SCREEN_BESTS_SIZE-100],80,$3a);
// 	scrofs:=SCREEN_BESTS_SIZE-60;
// 	for i:=0 to 19 do	begin	scr[scrofs]:=$36; scrofs:=scrofs+1; scr[scrofs]:=$37; scrofs:=scrofs+1;	end;
// 	onVideo();
end;

procedure ReadyScreen();
begin
	setDL(DLIST_READY_ADDR,@dli_ready);
	initPMG();

	COLPF[0]:=$04; COLPF[1]:=$02; COLPF[2]:=$08; COLPF[3]:=$3A; COLPF[4]:=$00;
	HPOSP[0]:=128+12; PCOL[0]:=$C0;

// set character
	CHBAS:=CHARSET4_PAGE;

	clearScreen(); // fillchar(@scr,256+32,$00);
	fillchar(pointer(SCREEN_BUFFER_ADDR),512,0);
	move(Pointer(G2F_SCREEN),@scr[11],32*8-11);
	move(Pointer(G2F_PMG),pointer(PMG_ADDR+48+32+35),12);

	for i:=0 to 1 do
	begin
		j:=stringLen(string_ready,i);
		putSCString(264-j shr 1+i*16,string_ready,i,0)
	end;

	SDMCTL:=%00111001; // narrow screen (256 pixels width)
end;

procedure GameScreen();
begin
	setDL(DLIST_GAME_ADDR,@dli_game);
// prepare screen
	clearScreen(); // fillchar(@scr,280,0);
	move(pointer(SCR_STATUSBAR_ADDR),@scr[SCREEN_GAME_SIZE-SCR_STATUSBAR_SIZE],SCR_STATUSBAR_SIZE);
	putBlocksOnScreen;

	putSCString(2,string_topstatus,0,0);
	putSCString(12,string_topstatus,1,0);

	UpdateTopStatus();
	UpdateBottomStatus();

// PMG Initialize
	initPMG();
	PCOL[0]:=$f4; PCOL[1]:=$f8; PCOL[2]:=$00;

	setMoleSprite(9);
	updateMolePosition();

// turn on video with PMG
	onVideo();
end;

procedure GameOverScreen();
begin
	setDL(DLIST_GAMEOVER_ADDR,@dli_gameover);
	initPMG();

	COLPF[0]:=$04; COLPF[1]:=$02; COLPF[2]:=$D6; COLPF[3]:=$2C; COLPF[4]:=$00;
	HPOSP[0]:=128+15; PCOL[0]:=$D0; GPRIOR:=%00100000;

// set character
	CHBAS:=CHARSET4_PAGE;

	clearScreen(); // fillchar(@scr,256+32,$00);
	move(Pointer(G2F_SCREEN+256),@scr[10],32*4-11);
	move(Pointer(G2F_PMG+12),pointer(PMG_ADDR+40+32+34),13);

	for i:=0 to 1 do
	begin
		j:=stringLen(string_gameover,i);
		putSCString(136-j shr 1+i*16,string_gameover,i,0)
	end;

	SDMCTL:=%00111001; // narrow screen (256 pixels width)
end;

procedure IntroScreen();
var
	adr1,adr2:word;

begin
	setDL(DLIST_INTRO_ADDR,nil);
	CHBAS:=CHARSET3_PAGE;
	COLPF[0]:=$24; COLPF[1]:=$c4; COLPF[2]:=$0e; COLPF[3]:=$84; COLPF[4]:=$00;
	SDMCTL:=%00111001; // narrow screen (256 pixels width)
end;