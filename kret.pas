{ $librarypath '../blibs/'}
uses atari;

const
{$i memory.inc}
{$i const.inc}
{$r resources.rc}
{$i asm/dli.pas}
{$i asm/sfx.pas}
{$i asm/block.pas}
{$i types.inc}
{$i helpers.pas}
{$i scroll.inc}

var
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
	SFX_Init();
// Keyboard
	KRPDEL:=0;KEYREP:=0;
end;

{$i title.inc}
{$i game.inc}
{$i history.inc}
{$i bests.inc}
{$i menu.inc}

begin
	init();

	repeat
		titleInScreen();
		menuLoop();

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
