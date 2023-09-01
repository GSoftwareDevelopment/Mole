procedure titleInScreen();
begin
	if FirstRun then
	begin
		FirstRun:=false;
		IntroScreen;
		// Intro;
{$ifndef no-title-music}
		SFX_PlaySONG(26*4);
{$endif}
		repeat
		until SONG_Ofs=$04;
	end;
{$ifndef no-title-music}
	if (SONG_Tick and $80<>0) then
		SFX_PlaySONG(0);
{$endif}
	titleScreen();
end;
