// {$librarypath '~/Atari/MadPascal/blibs/'}
{$librarypath './sfx_engine/'}
{$librarypath './song/'}
// {$DEFINE ROMOFF}
uses cio, SFX_API, atari; //, hsc_util;

// {$define no-title-music}
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
	totalBlocks:Byte;
	moleX,moleY,			// mole position on screen (in characters)
	mX,mY,					// mole position on screen (in pixels)
	omY,					// old mole Y position (in pixels)
	moleOfs,				// mole offset in buffer
	moleSprite:Byte;		// mole sprite number
	moleState,				// mole current state
	oMoleState,				//
	blockState:Byte;		// block fall speed in frames
	newBlocks,				// indicate, how many new block is created after blocks fallen
	blocksFallen:Byte;		// indicate, haw many block have fallen
	vanishingBlockOfs:Byte; //

	status:^TStatus;		// in game status
	gameOver,				// indicate for Game Over
	breakGame:Boolean;		// indicate for break game (press ESC key in main game)

// timers
	o_timer:Byte;
	moleTime:Byte;			// mole animation timer
	moleFallenTime:Byte;	// The time after which the mole falls lower
	blocksTime:Byte;		// blocks drop timer

	vanishTime:Word;		// vanish block timer
	vanishBreakTime:Byte;	// block break timer
	key:TKeys;

procedure myVBL(); Assembler; Interrupt;
asm
xitvbl      = $e462
sysvbv      = $e45c
portb       = $d301
vdli				= $0200

    phr

    sec
    jsr $2009

		lda curDLIPtr+1
		sta vdli+1
		lda curDLIPtr
		sta vdli

		jsr MAIN.SFX_API.INIT_SFXEngine.SFX_MAIN_TICK

    clc
    jsr $2009

		plr
		jmp xitvbl
end;

procedure Exit_Game();
begin
	offVideo();
	SFX_Off();
	asm
		sec
		jsr $200c
	end;
	NMIEN:=%00000000;
	SetIntVec(iVBL, oldVBL);
	SetIntVec(iDLI, oldDLI);
	NMIEN:=%01000000;
	SDMCTL:=%00101010;
	PMCTL:=0;// GPRIOR:=%00100001;
	halt(1);
end;

{$i game/title.pas}
{$i game/game.pas}
{$i game/history.pas}
{$i game/bests.pas}
{$i game/menu.pas}

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
	fillbyte(pointer(MIDI_CHANNELS_ADDR),48,$ff);
	INIT_SFXEngine();
	NMIEN:=%00000000;
	GetIntVec(iVBL, oldVBL);
	SetIntVec(iVBL, @myVBL);
	NMIEN:=%01000000;
	createBests();

// Initialize MIDI Driver
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

	until false;
end.
