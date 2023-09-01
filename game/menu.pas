var
	menuOpt:Byte = 0;

procedure updateMenu();
begin
	for i:=0 to 2 do
	begin
		omy:=stringLen(string_menu,i) shr 1;
		putSCString(550+i*20-omy,string_menu,i,Byte(i=menuOpt));
	end;
end;

procedure menuControl();
begin
	joy2key();
	if (joy<>0) then
	begin
		case joy of
			joy_Up:
			begin
				SFX_Freq(plyChn,50,sfx_selectUp);
				if (menuOpt>0) then dec(menuOpt) else menuOpt:=2;
			end;
			joy_Down:
			begin
				SFX_Freq(plyChn,40,sfx_selectDn);
				if (menuOpt<2) then inc(menuOpt) else menuOpt:=0;
			end;
			joy_Right,joy_Fire:
			begin
				SFX_Freq(plyChn,40,sfx_choice);

				case menuOpt of
					0: gameover:=false;
					1: bestsLoop();
					2: historyLoop();
				end;
			end;
			// key_CTRL_X: Exit_Game();
		end;
		updateMenu();
	end;
end;

procedure menuLoop();
begin
	updateMenu();
	repeat
		menuControl();
		scroll_tick();
	until not gameover;
end;
