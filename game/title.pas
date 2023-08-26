procedure setLogos();
const LOGOS_YPOS = 221;
begin
	move(@logos,@pmg[$000+LOGOS_YPOS],16);
	move(@logos[16],@pmg[$100+LOGOS_YPOS],16);
	move(@logos[32],@pmg[$200+LOGOS_YPOS],16);
	move(@logos[48],@pmg[$300+LOGOS_YPOS],16);
end;

procedure clearTitlePMG();
begin
	fillchar(pointer(PMG_ADDR-$100),256,0);
	fillchar(@pmg[$000+48],64,0);
	fillchar(@pmg[$100+48],64,0);
	fillchar(@pmg[$200+48],64,0);
	fillchar(@pmg[$300+48],64,0);
end;

procedure titleScreen();
begin
	initPMG();
	setDL(DLIST_TITLE_ADDR,@dli_title);
	move(colors_title,COLPF,5);
// set character
	CHBAS:=CHARSET1_PAGE;
	fillchar(@scr,SCREEN_TITLE_SIZE,0);
	fillchar(@buffer,512,0);

	move(pointer(SCR_TITLE_ADDR),@scr,SCR_TITLE_SIZE);
	clearTitlePMG();
	move(pointer(G2F_TITLE_PMG+0*64),pointer(PMG_ADDR-$100+48),64);
	move(pointer(G2F_TITLE_PMG+1*64),@pmg[$000+48],64);
	move(pointer(G2F_TITLE_PMG+2*64),@pmg[$100+48],64);
	move(pointer(G2F_TITLE_PMG+3*64),@pmg[$200+48],64);
	move(pointer(G2F_TITLE_PMG+4*64),@pmg[$300+48],64);

	setScroll(scroll_title);

	onVideo();
	setLogos();
	gameOver:=true;
end;


procedure titleInScreen();
begin
	if FirstRun then
	begin
		FirstRun:=false;
		Intro;
{$ifndef no-title-music}
		SFX_PlaySONG(26*4);
{$endif}
		repeat
		until SONG_Ofs=$04;
	end
	else
		SFX_PlaySONG(0);
	titleScreen();
end;
