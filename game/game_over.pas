procedure moleDie();
var w,_w:Byte;
	y:Word;
	dieTime:Word absolute TIMER5;
	anmTime:Byte absolute TIMER1;
	sprAdr:Word;

const
	sprofs:array[0..3] of Word = (
		SPRITES1_ADDR+$0f0,
		SPRITES1_ADDR+$100,
		SPRITES1_ADDR+$110,
		SPRITES1_ADDR+$100
	);

begin
	SFX_PlaySONG(23*4); SFX_Freq(plyChn+1,10,sfx_moleDie);
	i:=12; dieTime:=60*4; anmTime:=4; // o_timer:=_timer;
	PCOL[2]:=15; HPOSP[2]:=49+mx; y:=PMG_ADDR+$200+26+my; w:=0;
	kbcode:=255;
	repeat
		if anmTime=0 then
		begin
			anmTime:=4;
			setMoleSprite(i);
			if (w<=48) then
			begin
				w:=w+1; _w:=w and %11;
				sprAdr:=sprofs[_w];
				if (w<17) then
					_w:=w
				else if (w<32) then
					_w:=16
				else if (w<48) then
				begin
					inc(sprAdr,w-32); _w:=48-w;
				end;
				move(pointer(sprAdr),pointer(y),_w);
				if (w<32) then dec(y);
				if (w>32) and (w<48) then PCOL[2]:=48-w;
			end;
			i:=i+1; if (i>14) then i:=12;
		end;
	until dieTime=0;

	GameOverScreen();
	repeat
		joy2key();
	until joy<>0;
	SFX_OFF();
	gameOver:=true;
end;