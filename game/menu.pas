var
	menuOpt:byte = 0;

procedure updateMenu();
const
{$IFDEF ENGLISH}
	sofs:array[0..2] of word = (586,604,625);
{$ENDIF}
{$IFDEF POLISH}
	sofs:array[0..2] of word = (586,606,626);
{$ENDIF}

begin
	for i:=0 to 2 do
	begin
		putSCString(sofs[i],string_menu,i,byte(i=menuOpt));
	end;
end;

procedure menuControl();
begin
	joy2key();
	if (kbcode<>$ff) then
	begin
		key:=TKeys(kbcode);
		case key of
			key_Up:
			begin
				SFX_Freq(plyChn,50,sfx_selectUp);
				if (menuOpt>0) then dec(menuOpt) else menuOpt:=2;
			end;
			key_Down:
			begin
				SFX_Freq(plyChn,40,sfx_selectDn);
				if (menuOpt<2) then inc(menuOpt) else menuOpt:=0;
			end;
			key_Right,key_RETURN:
			begin
				SFX_Freq(plyChn,40,sfx_choice);

				case menuOpt of
					0: gameover:=false;
					1: bestsScreen();
					2: historyScreen();
				end;
			end;
		end;
		updateMenu();
		kbcode:=$ff;
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
