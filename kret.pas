// {$librarypath '~/Atari/MadPascal/blibs/'}
{$librarypath './sfx_engine/'}
{$librarypath './song/'}
{$DEFINE ROMOFF}
uses SFX_API, atari; //,hsc_utils;

{$define no-title-music}
{$define POLISH}

{$r song/resource.rc}

const
{$i memory.inc}
{$i types.pas}
{$i const.pas}
{$r resources.rc}
{$i asm/dli.pas}
{$i asm/block.pas}
{$i include/helpers.pas}
{$i include/scroll.pas}

var
	totalBlocks:byte;
	moleX,moleY,			// mole position on screen (in characters)
	mX,mY,					// mole position on screen (in pixels)
	omY,					// old mole Y position (in pixels)
	moleOfs,				// mole offset in buffer
	moleSprite:byte;		// mole sprite number
	moleState,				// mole current state
	oMoleState,				//
	blockState:byte;		// block fall speed in frames
	newBlocks,				// indicate, how many new block is created after blocks fallen
	blocksFallen:byte;		// indicate, haw many block have fallen
	vanishingBlockOfs:byte; //

	status:^TStatus;		// in game status
	gameOver,				// indicate for Game Over
	breakGame:boolean;		// indicate for break game (press ESC key in main game)

// timers
	o_timer:byte;
	moleTime:byte;			// mole animation timer
	moleFallenTime:byte;	// The time after which the mole falls lower
	blocksTime:byte;		// blocks drop timer

	vanishTime:word;		// vanish block timer
	vanishBreakTime:byte;	// block break timer
	key:TKeys;

procedure init();
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
  	SFX_StartVBL();

// Keyboard
	KRPDEL:=0;KEYREP:=0;
end;

{$i game/title.pas}
{$i game/game.pas}
{$i game/history.pas}
{$i game/bests.pas}
{$i game/menu.pas}

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

//		resetDL();
	until false;
end.
