var
	blinkState:Boolean;
	blinkTime:Byte absolute TIMER1;

procedure blinkIcon(x,y,icon:Byte);
begin
	if (blinkState) then
		move(@icons[icon],@scr[x+leftBound[y]],2)
	else
		move(@icons[icon_blank],@scr[x+leftBound[y]],2);
end;

procedure updateHistoryPage(page:Byte);
var startY,lines:Byte;
	x:smallint;

begin
	fillchar(@scr[80],SCREEN_HISTORY_SIZE-180,$00);
	subStringSelect(string_history[page][0],0);
	startY:=string_history[page][1];
	lines:=string_history[page][2];
	while lines>0 do
	begin
		page:=stringDCLen shr 1;
		x:=20-page; if x<0 then x:=0;
		putDCString(x,startY,false);
		inc(startY); dec(lines);
	end;
end;

procedure historyLoop();

	procedure wait4controller();
	begin
		repeat
			joy2key();
			if blinkTime=0 then
			begin
				blinkTime:=10;
				blinkIcon(37,11,icon_right);
				blinkState:=not blinkState;
			end;
			scroll_tick();
		until joy<>0;
		SFX_Freq(plyChn,50,sfx_selectDn);
		// SFX_Play(3,50,2);
	end;

begin
	HistoryScreen();
	setScroll(scroll_history);
	for i:=0 to 3 do
	begin
		updateHistoryPage(i);
		wait4controller();
		case joy of
			joy_Left: break;
		end;
	end;
	titleScreen();
end;
