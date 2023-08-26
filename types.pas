type
	TStatus = Record
		score,
		blocks:Word;
		level:Byte;
		nextLevel:Word;
		oldNextLevel:Word;
		blockFallSpeed:shortint;
		blockVanishingTime:Word;	// Time after which the block disappears
		vanishWarning:Word;			// Time after which thw Warning block flash
		breakSpeed:Word;			// speed of block break before vanish
	end;

// 	PBestEntry=^TBestEntry;
 	TBestEntry=record
 		nick:string[8];
 		score:string[6];
 		_score:cardinal;
 	end;

	THistoryPage=record
		nStr:Byte;
		startY:Byte;
		lines:Byte;
	end;

	TKeys = (
		key_Left = 6,
		key_Right = 7,
		key_RETURN = 12,
		key_Up = 14,
		key_Down = 15
		key_ESC = 28,
		key_SPACE = 33,
//		key_Left = 134,
//		key_Right = 135,
//		key_Up = 142,
//		key_Down = 143
		key_CTRL_X = 22+128
	);

	TMenu = (
		menu_newgame = 0,
		menu_bests = 1,
		menu_history = 2
	);

	TBestsMode = (
		mode_local = 0,
		mode_disc = 1,
		mode_net = 2,
	);

	THistoryPages = record
		start:Byte;
		YStart:Byte;
		lines:Byte;
	end;
