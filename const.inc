	stateStop		= %00000000;	// mole do nothing
	stateEat		= %10000000;	// mole eat block
	stateFallen = %01000000;	// mole fallen low
	stateJump		= %00100000;	// mole is jump
	stateMove		= %00010000;	// mole in move

	dirLeft			= %00000000;	// 0-left
	dirRight		= %00001000;	// 1-right

	maskState		= %01110000;	// state mask
  maskDir			= %00001000;	// mole direction mask:
	maskPhase		= %00000111;  // phase mask

	moleSpritePhases:array[0..3,0..3] of byte = (
		(9,3,255,255),	// %00000phs do nothing phases (for left and right)
		(6,7,8,7),			// %00110phs moving right phases
		(0,1,2,1),			// %00100phs moving left phases
		(10,11,4,5)			// %01100phs jump phases (for left and right)
	);

	stateDropBlocks	= %00000001;	//
	stateNewBlocks	= %00000010;	//
	stateVanishBlock= %00000100;	//

	leftBound:array[0..13] of word = ($000,$028,$050,$078,$0a0,$0c8,$0f0,$118,$140,$168,$190,$1b8,$1e0,$208);
	rightBound:array[0..13] of word = ($027,$04f,$077,$09f,$0c7,$0ef,$117,$13f,$167,$18f,$1b7,$1df,$207,$22f);

	icon_blank 	= 0;
	icon_cursor	= 2;
	icon_left		= 4;
	icon_right	= 6;
	icon_up			= 8;
	icon_down		= 10;
	icon_mode		= 12;
	icon_modesel= 18;

	icons:array[0..23] of byte = (
	0,0,			// blank
	30,31,		// cursor
	62,62,		// left
	63,63,		// right
	124,125,	// up
	60,61,		// down
	118,119,	// ram
	120,121,	// disc
	122,123,	// net
	246,247,	// ram+invers
	248,249,	// disc+invers
	250,251		// net+invers
	);

	scroll_title		= 0;
	scroll_history	= 1;
	scroll_bestsList= 2;
	scroll_bestsMode= 3;

	scrollSizes:array[0..3] of smallint=(
		$207,
		$32,
		$3B,
		$37
	);

	scrollScreenOfs:array[0..3] of word =(
		SCREEN_TITLE_SIZE-20,
		SCREEN_HISTORY_SIZE-20,
		SCREEN_BESTS_SIZE-20,
		SCREEN_BESTS_SIZE-20
	);

	string_menu			= 0;
	string_bests		= 1;
	string_history	: array[0..2] of byte = (2,3,4);
	string_ready		= 5;
	string_topstatus= 6;
