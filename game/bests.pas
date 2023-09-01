const
	maxBests = 8;
	maxBestsOnScreen = 8;

var
	bestsMode:Byte=mode_local; // default best mode: local
	bests:array[0..maxBests*sizeOf(TBestEntry)] of Byte;
	bestEntry:TBestEntry;
	bestsSection:Byte;
	bestsTotalPages,
	bestsCurrentPage:shortint;

procedure createBests();
begin
	bestEntry.nick:='';
	bestEntry.score:='000000';
	bestEntry._score:=0;
	for i:=0 to maxBests-1 do
	begin
		move(@bestEntry,@bests[i*sizeOf(TBestEntry)],sizeOf(TBestEntry));
	end;
end;

procedure updateBestsScreen();
var y:Byte;

begin
	for j:=0 to maxBestsOnScreen-1 do
	begin
		move(@bests[j*sizeOf(TBestEntry)],@bestEntry,sizeOf(TBestEntry));
		y:=4+j;
		if (bestEntry._score=0) then
		begin
			putDCText(2,y,'-- -------- ------',false);
		end
		else
		begin
			str(j+1,tmpStr);
			putDCText(2,y,tmpStr,false);
			putDCText(8,y,bestEntry.nick,false);
			putDCText(26,y,bestEntry.score,false);
		end;
	end;
end;

procedure updateBestsMode(active:Boolean);
const
	modePos:array[0..2] of Word = (4,6,9);

begin
	subStringSelect(string_bests,2);
	for j:=0 to 2 do
	begin
		if (j=bestsMode) and (active) then
		begin
			move(@icons[icon_modesel+j*2],@scr[2+leftBound[modePos[j]]],2);
			putDCString(5,modePos[j],true);
		end
		else
		begin
			move(@icons[icon_mode+j*2],@scr[2+leftBound[modePos[j]]],2);
			putDCString(5,modePos[j],false);
		end;
	end;
end;

procedure updateScreen2Bests();
begin
	fillchar(@scr[80],SCREEN_BESTS_SIZE-180,$00);
	subStringSelect(string_bests,0);
	omy:=20-stringDCLen shr 1;
	putDCString(omy,2,false);
	updateBestsScreen();
	setScroll(scroll_bestsList);
end;

procedure updateScreen2Options();
begin
	fillchar(@scr[80],SCREEN_BESTS_SIZE-180,$00);
	subStringSelect(string_bests,1);
	omy:=20-stringDCLen shr 1;
	putDCString(omy,2,false);
	updateBestsMode(true);
	setScroll(scroll_bestsMode);
end;

procedure bests_list();
begin
	if blinkTime=0 then
	begin
		blinkTime:=10;
		blinkIcon(2,2,icon_left);
		blinkIcon(36,2,icon_right);
		blinkIcon(38,4,icon_up);
		blinkIcon(38,11,icon_down);
		blinkState:=not blinkState;
	end;

	joy2key(); if (joy<>0) then
	begin
		case joy of
			joy_left{,key_ESC}: begin SFX_Freq(plyChn,50,sfx_selectDn); bestsSection:=0; exit; end;
			joy_right: begin
				SFX_Freq(plyChn,50,sfx_selectDn);
				updateScreen2Options();
				bestsSection:=2;
			end;
		end;
	end;
end;

procedure bests_settings();
begin
	if blinkTime=0 then
	begin
		blinkTime:=10;
		blinkIcon(2,3,icon_up);
		blinkIcon(2,11,icon_down);
		blinkIcon(2,2,icon_left);
		blinkState:=not blinkState;
	end;

	joy2key(); if (joy<>0) then
	begin
		case joy of
			// key_ESC: begin SFX_Freq(plyChn,50,sfx_selectDn); bestsSection:=0; exit; end;
			joy_up: begin
				SFX_Freq(plyChn,50,sfx_selectUp);
				if (bestsMode>0) then bestsMode:=bestsMode-1;
				updateBestsMode(true);
			end;
			joy_down: begin
				SFX_Freq(plyChn,40,sfx_selectDn);
				if (bestsMode<2) then bestsMode:=bestsMode+1;
				updateBestsMode(true);
			end;
			joy_left: begin
				SFX_Freq(plyChn,50,sfx_selectDn);
				bestsSection:=1;
				updateScreen2Bests();
			end;
		end;
	end;
end;

procedure bestsLoop();
begin
	BestsScreen();
	updateScreen2Bests();
	bestsSection:=1; bestsTotalPages:=5; bestsCurrentPage:=0;
	repeat
		scroll_tick();
		if (bestsSection=1) then
			bests_list()
		else if (bestsSection=2) then
			bests_settings();
	until bestsSection=0;
	titleScreen();
end;

