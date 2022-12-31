var
	scrollTexts:array[0..0] of word absolute SCROLL_DATA_ADDR;
	scroll:word;
	HSCROLL:byte absolute $d404;
	cFineScroll:shortint = 0;
	cScrollPos:smallint = 0;
	scrollTime:byte;
	scrollScrOfs:word;
	scrollLn:shortint;
	scrollScrShift:shortint;
	scrollShift:byte;
	scrollSize:byte;

procedure resetScroll;
begin
	cFineScroll:=0;
	cScrollPos:=0;
	scrollLn:=0;
	scrollShift:=0;
	scrollScrShift:=18;
	fillchar(pointer(scrollScrOfs),18,0);
end;

procedure setScroll(id:byte);
begin
	scroll:=scrollTexts[id];
	scrollSize:=scrollSizes[id];
	scrollScrOfs:=scrollScreenOfs[id];
end;

procedure scroll_tick();
begin
	if (_timer-scrollTime>0) then
	begin
		scrollTime:=_timer;
		cFineScroll:=cFineScroll-1;
		if (cFineScroll<0) then
		begin
			cFineScroll:=cFineScroll+16;
			cScrollPos:=cScrollPos+2;
			if (cScrollPos<18) then
			begin
				scrollShift:=0; scrollScrShift:=18-cScrollPos; scrollLn:=cScrollPos;
			end
			else
			begin
				scrollShift:=cScrollPos-18; scrollScrShift:=0; scrollLn:=18;
			end;
			if (scrollShift+18>scrollSize) then
			begin
				scrollLn:=scrollSize-scrollShift;
				if (scrollLn>0) then
					fillchar(pointer(scrollScrOfs+scrollLn),18-scrollLn,0)
				else
					resetScroll;
			end;
			if (scrollLn>0) then
			begin
				move(pointer(scroll+scrollShift),pointer(scrollScrOfs+scrollScrShift),scrollLn);
			end;
		end;

		HSCROLL:=cFineScroll;
	end;
end;
