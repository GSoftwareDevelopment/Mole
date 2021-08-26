var
	bestsMode:byte=mode_local; // default best mode: local

procedure updateBestsScreen(pg:byte);
var i:byte;

begin
	for i:=0 to 7 do
	begin
		// TODO: UPDATE BESTS SCREEN
		putDCText(2,4+i,'-- -------- ------',false);
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

procedure bestsLoop();
var section:byte;
		totalcurrentPages,currentPage:shortint;
		key:TKeys;

begin
	section:=0; totalcurrentPages:=5; currentPage:=0;
	kbcode:=255; updateBestsScreen(currentPage);
	setScroll(scroll_bestsList);
	repeat
		scroll_tick();
		if (section and $80=$00) then // best list
		begin
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
					key_left,key_ESC: exit;
					key_right: begin
						// SFX_Play(3,50,2);
						fillchar(@scr[80],SCREEN_BESTS_SIZE-180,$00);
						putDCString(11,2,string_bests,1,false);
						updateBestsMode(true);
						section:=section or $80;
						setScroll(scroll_bestsMode);
					end;
				end;
			end;
		end
		else
		begin // bests mode
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
					key_ESC: exit;
					key_up: begin
						// SFX_Play(3,50,2);
						if (bestsMode>0) then bestsMode:=bestsMode-1;
						updateBestsMode(true);
					end;
					key_down: begin
						// SFX_Play(3,50,2);
						if (bestsMode<2) then bestsMode:=bestsMode+1;
						updateBestsMode(true);
					end;
					key_left: begin
						// SFX_Play(3,50,2);
						fillchar(@scr[80],SCREEN_BESTS_SIZE-180,$00);
						putDCString(12,2,string_bests,0,false);
						section:=section and $7f;
						updateBestsScreen(currentPage);
						setScroll(scroll_bestsList);
					end;
				end;
			end;
		end;
	until false;
	kbcode:=255;
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
