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
		place:string[2];

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
			str(j+1,place);
			putDCText(2,y,place,false);
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
{$IFDEF ENGLISH}
	putDCString(8,2,false);
{$ENDIF}
{$IFDEF POLISH}
	putDCString(12,2,false);
{$ENDIF}
	updateBestsScreen();
	setScroll(scroll_bestsList);
end;

procedure updateScreen2Options();
begin
	fillchar(@scr[80],SCREEN_BESTS_SIZE-180,$00);
	subStringSelect(string_bests,1);
	putDCString(11,2,false);
	updateBestsMode(true);
	setScroll(scroll_bestsMode);
end;

procedure bests_list();
begin
	if (byte(_timer-blinkTime)>=10) then
	begin
		blinkTime:=_timer;
{$IFDEF ENGLISH}
		blinkIcon(5,2,icon_left);
		blinkIcon(33,2,icon_right);
{$ENDIF}
{$IFDEF POLISH}
		blinkIcon(9,2,icon_left);
		blinkIcon(29,2,icon_right);
{$ENDIF}
		blinkIcon(38,4,icon_up);
		blinkIcon(38,11,icon_down);
		blinkState:=not blinkState;
	end;

	joy2key(); if (kbcode<>255) then
	begin
		key:=TKeys(kbcode); kbcode:=255;
		case key of
			key_left,key_ESC: begin SFX_Freq(plyChn,50,sfx_selectDn); bestsSection:=0; exit; end;
			key_right: begin
				SFX_Freq(plyChn,50,sfx_selectDn);
				updateScreen2Options();
				bestsSection:=2;
			end;
		end;
	end;
end;

procedure bests_mode();
begin
	if (byte(_timer-blinkTime)>=10) then
	begin
		blinkTime:=_timer;
		blinkIcon(2,3,icon_up);
		blinkIcon(2,11,icon_down);
		blinkIcon(7,2,icon_left);
		blinkState:=not blinkState;
	end;

	joy2key(); if (kbcode<>255) then
	begin
		key:=TKeys(kbcode); kbcode:=255;
		case key of
			key_ESC: begin SFX_Freq(plyChn,50,sfx_selectDn); bestsSection:=0; exit; end;
			key_up: begin
				SFX_Freq(plyChn,50,sfx_selectUp);
				if (bestsMode>0) then bestsMode:=bestsMode-1;
				updateBestsMode(true);
			end;
			key_down: begin
				SFX_Freq(plyChn,40,sfx_selectDn);
				if (bestsMode<2) then bestsMode:=bestsMode+1;
				updateBestsMode(true);
			end;
			key_left: begin
				SFX_Freq(plyChn,50,sfx_selectDn);
				bestsSection:=1;
				updateScreen2Bests();
			end;
		end;
	end;
end;

procedure bestsLoop();
// var
//	leaveBests:Boolean;

begin
	bestsSection:=1; bestsTotalPages:=5; bestsCurrentPage:=0;
	kbcode:=255;
	repeat
		scroll_tick();
		if (bestsSection=1) then
			bests_list()
		else if (bestsSection=2) then
			bests_mode();
	until bestsSection=0;
end;

procedure bestsScreen();
begin
	setDL(DLIST_BESTS_ADDR,@dli_bests);
// set character
	CHBAS:=CHARSET1_PAGE;
	scrofs:=0;
	clearTitlePMG();
	fillchar(@scr,SCREEN_BESTS_SIZE,$00);
	for i:=0 to 19 do	begin	scr[scrofs]:=$34; scrofs:=scrofs+1; scr[scrofs]:=$35; scrofs:=scrofs+1;	end;
	for i:=0 to 19 do	begin	scr[scrofs]:=$38; scrofs:=scrofs+1; scr[scrofs]:=$39; scrofs:=scrofs+1;	end;
	fillchar(@scr[SCREEN_BESTS_SIZE-100],80,$3a);
	scrofs:=SCREEN_BESTS_SIZE-60;
	for i:=0 to 19 do	begin	scr[scrofs]:=$36; scrofs:=scrofs+1; scr[scrofs]:=$37; scrofs:=scrofs+1;	end;
	updateScreen2Bests();

	onVideo();

	bestsLoop();

	titleScreen();
end;
