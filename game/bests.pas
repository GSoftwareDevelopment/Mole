const
 	maxBests = 8;
 	maxBestsOnScreen = 8;

var
	bestsMode:byte=mode_local; // default best mode: local
 	bests:array[0..maxBests*sizeOf(TBestEntry)] of byte;
	bestEntry:TBestEntry;
	bestsSection:byte;
	bestsTotalPages,
	bestsCurrentPage:shortint;

procedure createBests();
var
	i:byte;

begin
	bestEntry.nick:='';
	bestEntry.score:='000000';
	bestEntry._score:=1;
	for i:=0 to maxBests-1 do
	begin
		move(@bestEntry,@bests[i*sizeOf(TBestEntry)],sizeOf(TBestEntry));
	end;
end;

procedure updateBestsScreen();
var i,y:byte;
		place:string[2];

begin
	createBests();
	for i:=0 to maxBestsOnScreen-1 do
	begin
		move(@bests[i*sizeOf(TBestEntry)],@bestEntry,sizeOf(TBestEntry));
		y:=4+i;
		if (bestEntry._score=0) then
		begin
			putDCText(2,y,'-- -------- ------',false);
		end
		else
		begin
			str(i+1,place);
			putDCText(2,y,place,false);
			putDCText(8,y,bestEntry.nick,false);
			putDCText(26,y,bestEntry.score,false);
		end;
	end;
end;

procedure updateBestsMode(active:boolean);
const
	modePos:array[0..2] of word = (4,6,9);

var i:byte;

begin
	for i:=0 to 2 do
	begin
		if (i=bestsMode) and (active) then
		begin
			move(@icons[icon_modesel+i*2],@scr[2+leftBound[modePos[i]]],2);
			putDCString(5,modePos[i],string_bests,2+i,true);
		end
		else
		begin
			move(@icons[icon_mode+i*2],@scr[2+leftBound[modePos[i]]],2);
			putDCString(5,modePos[i],string_bests,2+i,false);
		end;
	end;
end;

function bests_list():boolean;
begin
	result:=false;
	if (_timer-blinkTime>=10) then
	begin
		blinkTime:=_timer;
		blinkIcon(9,2,icon_left);
		blinkIcon(29,2,icon_right);
		blinkIcon(38,4,icon_up);
		blinkIcon(38,11,icon_down);
		blinkState:=not blinkState;
	end;

	joy2key(); if (kbcode<>255) then
	begin
		key:=TKeys(kbcode); kbcode:=255;
		case key of
			key_left,key_ESC: exit(true);
			key_right: begin
				SFX_Freq(plyChn,50,sfx_selectDn);
				fillchar(@scr[80],SCREEN_BESTS_SIZE-180,$00);
				putDCString(11,2,string_bests,1,false);
				updateBestsMode(true);
				bestsSection:=1;
				setScroll(scroll_bestsMode);
				key:=TKeys(255);
			end;
		end;
	end;
end;

function bests_mode():boolean;
begin
	result:=false;
	if (_timer-blinkTime>=10) then
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
			key_ESC: exit(true);
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
				fillchar(@scr[80],SCREEN_BESTS_SIZE-180,$00);
				putDCString(12,2,string_bests,0,false);
				bestsSection:=0;
				updateBestsScreen();
				setScroll(scroll_bestsList);
				key:=TKeys(255);
			end;
		end;
	end;
end;

procedure bestsLoop();
var
	leaveBests:boolean;

begin
	bestsSection:=0; bestsTotalPages:=5; bestsCurrentPage:=0;
	kbcode:=255; updateBestsScreen();
	setScroll(scroll_bestsList);
	repeat
		scroll_tick();
		if (bestsSection=0) then
			leaveBests:=bests_list()
		else
			leaveBests:=bests_mode();
	until leaveBests;
end;

procedure bestsScreen();
var
	i:byte;
	ofs:word;

begin
	setDL(DLIST_BESTS_ADDR,@dli_bests);
// set character
	CHBAS:=CHARSET1_PAGE;
	ofs:=0;
	fillchar(@scr,SCREEN_BESTS_SIZE,$00);
	for i:=0 to 19 do	begin	scr[ofs]:=$34; ofs:=ofs+1; scr[ofs]:=$35; ofs:=ofs+1;	end;
	for i:=0 to 19 do	begin	scr[ofs]:=$38; ofs:=ofs+1; scr[ofs]:=$39; ofs:=ofs+1;	end;
	fillchar(@scr[SCREEN_BESTS_SIZE-100],80,$3a);
	ofs:=SCREEN_BESTS_SIZE-60;
	for i:=0 to 19 do	begin	scr[ofs]:=$36; ofs:=ofs+1; scr[ofs]:=$37; ofs:=ofs+1;	end;
	setScroll(scroll_bestsList);

	onVideo();

	putDCString(12,2,string_bests,0,false);

	bestsLoop();

	titleScreen();
end;
