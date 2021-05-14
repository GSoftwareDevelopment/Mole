{ $librarypath '../blibs/'}
uses atari;

const
{$i memory.inc}
{$i const.inc}
{$r resources.rc}
{$i asm/dli.pas}
{$i asm/sfx.pas}
{$i asm/block.pas}
{$i helpers.pas}
{$i types.inc}

var
	scr:Array[0..759] of byte absolute SCREEN_ADDR;
	buffer:Array[0..239] of byte absolute SCREEN_BUFFER_ADDR;
	sprites:array[0..319] of byte absolute PM_DATA_ADDR;

	totalBlocks:byte;
	moleX,moleY,				// mole position on screen (in characters)
	mX,mY,							// mole position on screen (in pixels)
	omY,								// old mole Y position (in pixels)
	moleOfs,						// mole offset in buffer
	moleSprite:byte;		// mole sprite number
	moleState,					// mole current state
	oMoleState,					//
	blockState:byte;		// block fall speed in frames
	newBlocks,					// indicate, how many new block is created after blocks fallen
	blocksFallen:byte;	// indicate, haw many block have fallen
	vanishingBlockOfs:byte; //

	status:^TStatus;		// in game status
	gameOver,						// indicate for Game Over
	breakGame:boolean;	// indicate for break game (press ESC key in main game)

// timers
	globalTime,					// all timer must be sync with this timer
	moleTime,						// mole animation timer
	moleFallenTime,			// The time after which the mole falls lower
	vanishTime,					// vanish block timer
	vanishBreakTime,		//
	blocksTime:longint;	// blocks drop timer

procedure initGame();
begin
// turn off video
	SDMCTL:=0;
// blocks vectors initialize
	defvec:=BLOCKS_DEF_ADDR; lstvec:=BLOCKS_LIST_ADDR;
// save old DL Interrupt
  GetIntVec(iDLI, oldDLI);
// set video address to screen buffer
	scradr:=SCREEN_BUFFER_ADDR;
// SFX Lib initialize
	SFX_Init();
// Keyboard
	KRPDEL:=0;KEYREP:=0;
end;

procedure TitleScreen();
var
	title:byte absolute SCR_TITLE_ADDR;
	menu:byte absolute SCR_MENU_ADDR;
	footer:byte absolute SCR_TFOOT_ADDR;

begin
	offPMG();
	setDL(DLIST_TITLE_ADDR,@dli_title);
// set character
	CHBAS:=CHARSET1_PAGE;

	move(@title,@scr,SCR_TITLE_SIZE);
	move(@menu,@scr[SCR_TITLE_SIZE],SCR_MENU_SIZE);
	move(@footer,@scr[SCR_TITLE_SIZE+SCR_MENU_SIZE],SCR_TFOOT_SIZE);

	onVideo();
end;

procedure ReadyScreen();
var
	i:byte;
	ready:byte absolute SCR_READY_ADDR;

begin
	resetDL();
// set character
	CHBAS:=CHARSET1_PAGE;

	colpf[0]:=$24;
	fillchar(@scr,240,$00);
	move(@ready,@scr[60],SCR_READY_SIZE); // show "GET REDY MOLE"

	offPMG();
	onVideo();

// prepare playfield buffer
	fillchar(@buffer,240,$00); // wall character
	for i:=0 to 11 do	begin buffer[i*20]:=$3b; buffer[i*20+19]:=$3c; end;
	buffer[220]:=$3f; buffer[239]:=$3f;
	fillchar(@buffer[221],18,$3d);
end;

procedure updateTopStatus;
var
  temp,out:String[6];
  i:byte;

begin
	// score
	str(status.score,temp);
	out:=concat(StringOfChar('0',6-length(temp)),temp);
	for i:=1 to 6 do scr[i+21]:=byte(out[i])+32;
	// level
	str(status.level,temp);
	out:=concat(StringOfChar('0',2-length(temp)),temp);
	for i:=1 to 2 do scr[i+33]:=byte(out[i])+32;
end;

procedure updateBottomStatus;
var a,b,i:byte;
		ofs1,ofs2:word;
		clev:integer;

begin
	clev:=trunc(((status.blocks-status.oldNextLevel)/status.nextLevel)*34);
	ofs1:=SCREEN_GAME_SIZE-SCR_GFOOT_SIZE+2;
	ofs2:=SCREEN_GAME_SIZE-SCR_GFOOT_SIZE+42;
	for i:=0 to 32 do
	begin
		a:=scr[ofs1] and $fe; b:=scr[ofs2] and $fe;
		if (i<clev) then begin	a:=a or $01; b:=b or $01;	end;
		scr[ofs1]:=a; scr[ofs2]:=b;
		inc(ofs1); inc(ofs2);
	end;
end;

{$i game.inc}

procedure GameScreen();
var
	i:word;
	footer:byte absolute SCR_GFOOT_ADDR;
  out:string[6];

begin
	setDL(DLIST_GAME_ADDR,@dli_game);
// set character
	CHBAS:=CHARSET2_PAGE;

// prepare screen
	fillchar(@scr,280,0);
	move(@footer,@scr[SCREEN_GAME_SIZE-SCR_GFOOT_SIZE],SCR_GFOOT_SIZE);
	move(@buffer,@scr[40],240);

	out:='PUNKTY'; for i:=1 to 6 do scr[i+1]:=byte(out[i])-32;
	out:='POZIOM'; for i:=1 to 6 do scr[i+11]:=byte(out[i])-32;
	UpdateTopStatus();
	UpdateBottomStatus();

// PMG Initialize
	initPMG();
	setMoleSprite(9);
	updateMolePosition();

// turn on video with PMG
	onVideo();

// set timers
	globalTime:=getTime;
	moleTime:=globalTime;
	moleFallenTime:=globalTime;
	blocksTime:=globalTime;
	vanishTime:=globalTime;
end;

begin
	InitGame();

	repeat
		TitleScreen();
		_wait4key();

// ready screen for player
		ReadyScreen();
		initNewGame();

		delay(50);

// prepare game
		GameScreen();

		gameLoop();

		resetDL();
	until false;
end.
