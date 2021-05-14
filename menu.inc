var
	menuOpt:byte = 0;

procedure updateMenu();
const
	sofs:array[0..2] of word = (586,606,626);

var
	i:byte;

begin
	for i:=0 to 2 do
	begin
		if (i=menuOpt) then
			putSCString(sofs[i],string_menu,i,1)
		else
			putSCString(sofs[i],string_menu,i,0);
	end;
end;

procedure menuControl();
var
	kb:TKeys;

begin
	joy2key();
	if (kbcode<>$ff) then
	begin
		kb:=TKeys(kbcode);
		case kb of
			key_Up:
			begin
				SFX_Play(3,50,1);
				if (menuOpt>0) then dec(menuOpt) else menuOpt:=2;
			end;
			key_Down:
			begin
				SFX_Play(3,40,2);
				if (menuOpt<2) then inc(menuOpt) else menuOpt:=0;
			end;
			key_Right,key_RETURN:
			begin
				SFX_Play(3,40,0);
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
