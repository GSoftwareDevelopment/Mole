var
	scrollSizes:array[0..3] of Byte absolute SCROLL_DATA_ADDR;
	scrollTexts:array[0..0] of Word absolute SCROLL_DATA_ADDR + 4;
	scroll:Word;
	HSCROLL:Byte absolute $d404;
	cFineScroll:shortint = 0;
	cScrollPos:smallint = 0;
	scrollTime:Byte absolute TIMER2;
	scrollScrOfs:Word;
	scrollLn:shortint;
	scrollScrShift:shortint;
	scrollShift:Byte;
	scrollSize:Byte;

procedure resetScroll;
begin
	cFineScroll:=0;
	cScrollPos:=0;
	scrollLn:=0;
	scrollShift:=0;
	scrollScrShift:=18;
	scrollTime:=0;
	fillchar(Pointer(scrollScrOfs),18,0);
end;

procedure setScroll(id:Byte);
begin
	scroll:=scrollTexts[id];
	scrollSize:=scrollSizes[id];
	scrollScrOfs:=scrollScreenOfs[id];
	scrollTime:=0;
end;

procedure scroll_tick();
begin
	if (scrollTime=0) then
	begin
		scrollTime:=1;
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
					fillchar(Pointer(scrollScrOfs+scrollLn),18-scrollLn,0)
				else
					resetScroll;
			end;
			if (scrollLn>0) then
			begin
				move(Pointer(scroll+scrollShift),Pointer(scrollScrOfs+scrollScrShift),scrollLn);
			end;
		end;

		HSCROLL:=cFineScroll;
	end;
end;
