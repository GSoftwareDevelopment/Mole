procedure updateTopStatus;
begin
	// score
	str(status.score,tmpStr);
	putSCText(22,concat(StringOfChar('0',6-length(tmpStr)),tmpStr),1);
	// level
	str(status.level,tmpStr);
	putSCText(34,concat(StringOfChar('0',2-length(tmpStr)),tmpStr),1);
end;

procedure updateBottomStatus;
var a,b:Byte;
	ofs1,ofs2:Word;
	clev:integer;

begin
	clev:=trunc(((status.blocks-status.oldNextLevel)/status.nextLevel)*34);
	ofs1:=SCREEN_GAME_SIZE-SCR_STATUSBAR_SIZE+2;
	ofs2:=SCREEN_GAME_SIZE-SCR_STATUSBAR_SIZE+42;
	for i:=0 to 32 do
	begin
		a:=scr[ofs1] and $fe; b:=scr[ofs2] and $fe;
		if (i<clev) then begin	a:=a or $01; b:=b or $01;	end;
		scr[ofs1]:=a; scr[ofs2]:=b;
		inc(ofs1); inc(ofs2);
	end;
end;