// {$librarypath '~/Atari/MadPascal/blibs/'}
{$librarypath './sfx_engine/'}
{$librarypath './song/'}
// {$DEFINE ROMOFF}
{$DEFINE NOROMFONT}
uses cio, SFX_API, atari, hsc_util;

// {$define no-title-music}
// {$DEFINE INCLUDE_LANG}
{$r song/resource.rc}

const
{$i memory.inc}
{$i types.pas}
{$i const.pas}

{$IFDEF INCLUDE_LANG}
	{$DEFINE DEUTCH}
	{$IFDEF DEUTCH}
		{$r de.rc}
	{$ENDIF}
	{$IFDEF ENGLISH}
		{$r en.rc}
	{$ENDIF}
	{$IFDEF CZECH}
		{$r cz.rc}
	{$ENDIF}
	{$IFDEF POLISH}
		{$r pl.rc}
	{$ENDIF}
{$ENDIF}

{$r resources.rc}
{$i asm/dli.pas}
{$i include/vbli.pas}
{$i include/helpers.pas}
{$i include/strings.pas}
{$i asm/block.pas}
{$i include/scroll.pas}

var
	totalBlocks:Byte;
	moleX,moleY,						// mole position on screen (in characters)
	mX,mY,									// mole position on screen (in pixels)
	omY,										// old mole Y position (in pixels)
	moleOfs,								// mole offset in buffer
	moleSprite:Byte;				// mole sprite number
	moleState,							// mole current state
	oMoleState,							//
	blockState:Byte;				// block fall speed in frames
	newBlocks,							// indicate, how many new block is created after blocks fallen
	blocksFallen:Byte;			// indicate, haw many block have fallen
	vanishingBlockOfs:Byte; //

	status:^TStatus;				// in game status
	gameOver,								// indicate for Game Over
	breakGame:Boolean;			// indicate for break game (press ESC key in main game)

// timers
	moleTime:Byte 				absolute TIMER1;	// mole animation timer
	moleFallenTime:Byte		absolute TIMER2;	// The time after which the mole falls lower
	blocksTime:Byte				absolute TIMER3;	// blocks drop timer
	vanishBreakTime:Byte	absolute TIMER4;	// block break timer
	vanishTime:Word				absolute TIMER5;	// vanish block timer

  tmpStr:String[6];

procedure Exit_Game();
begin
	offVideo();
	SFX_Off();
	if isMIDIDrv then
	asm
		sec
		jsr $200c
	end;
	delay(5);
	NMIEN:=%00000000;
	SetIntVec(iVBL, oldVBL);
	SetIntVec(iDLI, oldDLI);
	NMIEN:=%01000000;
	SDMCTL:=%00101010;
	PMCTL:=0;// GPRIOR:=%00100001;
	halt(1);
end;

{$i include/sprite.pas}
{$i game/game_status.pas}
{$i game/screens.pas}
{$i game/title.pas}
{$i game/game_over.pas}
{$i game/game.pas}
{$i game/history.pas}
{$i game/bests.pas}
{$i game/menu.pas}

procedure init();
begin
	fillchar(pointer(TIMER1),6,0);
// turn off video
	SDMCTL:=0;
// blocks vectors initialize
	defvec:=BLOCKS_DEF_ADDR; lstvec:=BLOCKS_LIST_ADDR;
// save old DL Interrupt
	GetIntVec(iDLI, oldDLI);
// set video address to screen buffer
	scradr:=SCREEN_BUFFER_ADDR;
// SFX Lib initialize
	fillbyte(pointer(MIDI_CHANNELS_ADDR),48,$ff);
	INIT_SFXEngine();
	NMIEN:=%00000000;
	GetIntVec(iVBL, oldVBL);
	SetIntVec(iVBL, @myVBL);
	NMIEN:=%01000000;
	createBests();

// check MIDI Driver
	asm
    ldy #15
driverTestLoop:
    lda $2000,y
    cmp #$4c        ; $4c=jmp
    beq next

		ldx #0
    beq endDriverTest

next:
    dey
    dey
    dey
    bpl driverTestLoop
		ldx #1

endDriverTest:
		stx MAIN.SFX_API.isMIDIDrv
	end;

// Initialize MIDI Driver
	if isMIDIDrv then
	asm
		jsr $2003
	end;

// Keyboard
	KRPDEL:=0; KEYREP:=0;
end;

begin
	init();

	repeat
		titleInScreen();
		menuLoop();

// ready screen for player
		ReadyScreen();
		initNewGame();

// prepare game
		GameScreen();

		gameLoop();
		if gameover then moleDie();
	until false;
end.
