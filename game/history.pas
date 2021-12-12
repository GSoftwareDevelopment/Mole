var
	blinkState:boolean;
	blinkTime:byte;

procedure blinkIcon(x,y,icon:byte);
begin
	if (blinkState) then
		move(@icons[icon],@scr[x+leftBound[y]],2)
	else
		move(@icons[icon_blank],@scr[x+leftBound[y]],2);
end;

procedure updateHistoryPage(page,startY,lines:byte);
var
	ln,sln:byte;

begin
	fillchar(@scr[80],SCREEN_HISTORY_SIZE-180,$00);
	for ln:=0 to lines do
	begin
		sln:=stringDCLen(string_history[page],ln) shr 1;
		putDCString(20-sln,startY+ln,string_history[page],ln,false);
	end;
end;

procedure historyScreen();
var
	key:TKeys;
	i:byte;
	ofs:word;

	procedure wait4controller();
	begin
		kbcode:=255;
		repeat
			joy2key();
			if (_timer-blinkTime>=10) then
			begin
				blinkTime:=_timer;
				blinkIcon(37,11,icon_right);
				blinkState:=not blinkState;
			end;
			scroll_tick();
		until kbcode<>255;
		SFX_Freq(plyChn,50,sfx_selectDn);
		// SFX_Play(3,50,2);
	end;

begin
	setDL(DLIST_HISTORY_ADDR,@dli_bests);
// set character
	CHBAS:=CHARSET1_PAGE;
	fillchar(@scr,SCREEN_HISTORY_SIZE,$00);
	fillchar(@scr,80,$3a);
	ofs:=0;
	for i:=0 to 19 do	begin	scr[ofs]:=$34; ofs:=ofs+1; scr[ofs]:=$35; ofs:=ofs+1;	end;
	for i:=0 to 19 do	begin	scr[ofs]:=$38; ofs:=ofs+1; scr[ofs]:=$39; ofs:=ofs+1;	end;
	fillchar(@scr[SCREEN_HISTORY_SIZE-100],80,$3a);
	ofs:=SCREEN_HISTORY_SIZE-60;
	for i:=0 to 19 do	begin	scr[ofs]:=$36; ofs:=ofs+1; scr[ofs]:=$37; ofs:=ofs+1;	end;
	setScroll(scroll_history);
	onVideo();

	for i:=0 to 3 do
	begin
		case i of
			0: updateHistoryPage(0,3,6);
			1: updateHistoryPage(1,5,3);
			2: updateHistoryPage(2,5,3);
			3: updateHistoryPage(3,2,9);
		end;
		wait4controller();
		key:=TKeys(kbcode); kbcode:=255;
		case key of
			key_Left, key_ESC: break;
		end;
	end;
	kbcode:=255;

	titleScreen();
end;
