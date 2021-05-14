procedure updateTopStatus;
var
  temp:String[6];

begin
	// score
	str(status.score,temp);
	putSCText(22,concat(StringOfChar('0',6-length(temp)),temp),1);
	// level
	str(status.level,temp);
	putSCText(34,concat(StringOfChar('0',2-length(temp)),temp),1);
end;

procedure updateBottomStatus;
var a,b,i:byte;
		ofs1,ofs2:word;
		clev:integer;

begin
	clev:=trunc(((status.blocks-status.oldNextLevel)/status.nextLevel)*34);
	ofs1:=SCREEN_GAME_SIZE-SCR_STATUSBAR_SIZE+2;
	ofs2:=SCREEN_GAME_SIZE-SCR_STATUSBAR_SIZE+42;
	for i:=0 to 32 do
	begin
		a:=scr[ofs1] and $fe; b:=scr[ofs2] and $fe;
		if (i<clev) then begin	a:=a or $01; b:=b or $01;	end;
		scr[ofs1]:=a; scr[ofs2]:=b;
		inc(ofs1); inc(ofs2);
	end;
end;

procedure updateMolePosition();
var
	yOfs:byte;
	sprOfs:word;

begin
	if (mY<>omY) then
	begin
		sprOfs:=moleSprite shl 4;
		yOfs:=16+mY;

		fillchar(@pmg,256,0);
//		fillchar(@pmg,yOfs,0);
		move(@sprites[sprOfs],@pmg[yOfs],16);
//		fillchar(@pmg[16+yOfs],240-yOfs,0);

		fillchar(@pmg[256],256,0);
//		fillchar(@pmg[256],yOfs,0);
		move(@sprites[sprOfs+$120],@pmg[256+yOfs],16);
//		fillchar(@pmg[272+yOfs],240-yOfs,0);

		omY:=mY;
	end;

	HPOSP[0]:=49+mX; HPOSP[1]:=49+mX;
end;

procedure setMoleSprite(sprNo:byte);
var
	sprOfs:word;
	yOfs:byte;

begin
	if (sprNo=moleSprite) then exit;
	moleSprite:=sprNo;
	sprOfs:=sprNo shl 4;
	yOfs:=16+omY;
	move(@sprites[sprOfs],@pmg[yOfs],16);
	move(@sprites[sprOfs+$120],@pmg[$100+yOfs],16);
end;

//
//

procedure initNewGame();
var
	i,newBlocks:byte;
	dx:shortint;

begin
	CHBAS:=CHARSET1_PAGE;

// prepare playfield buffer
	fillchar(@buffer,240,$00); // wall character
	for i:=0 to 11 do	begin buffer[i*20]:=$3b; buffer[i*20+19]:=$3c; end;
	buffer[220]:=$3f; buffer[239]:=$3f;
	fillchar(@buffer[221],18,$3d);

// generate blocks
	totalBlocks:=0;
	for i:=0 to 10 do
	begin
		newBlocks:=ShuffleBlocks(i,totalBlocks);
		totalBlocks:=totalBlocks+newBlocks;
	end;
// fall down and make new, if possible
	repeat
		i:=DropBlocks(totalBlocks);
		newBlocks:=ShuffleBlocks(0,totalBlocks);
		if (newBlocks>0) then
		Begin
			move(@blocksList,@blocksList[newBlocks*4],(totalBlocks+newBlocks)*4);
			move(@blocksList[(totalBlocks+newBlocks)*4],@blocksList,newBlocks*4);
			totalBlocks:=totalBlocks+newBlocks;
		End;
	until i=0;
// reset set block state
	blockState:=stateStop;

// find mole start position
	moleX:=1+RAND mod 18; moleY:=10; dx:=-1+(RAND mod 2)*2;
	moleOfs:=rowOfs[moley]+moleX;
	while buffer[moleOfs]<>0 do
	Begin
		if (moleX+dx<1) or (moleX+dx>18) then dx:=-dx;
		moleX:=moleX+dx; moleOfs:=moleOfs+dx;
	End;

// set mole start state & position (in pixels)
	moleState:=stateStop; oMoleState:=$ff;
	mX:=moleX shl 3; mY:=moleY shl 4;
	omY:=0; // reset old Y position (in pixels)

// initialize status
	status.score:=0; status.blocks:=0; status.level:=0;
	status.nextLevel:=25; status.oldNextLevel:=0;
	status.blockFallSpeed:=75;
	status.blockVanishingTime:=500;
	status.vanishWarning:=200;
	status.breakSpeed:=50;
	gameOver:=false; breakGame:=false;
end;

//
//

procedure moleMove();
var
	state,
	newState,
	moleDir,
	phase,dir:byte;

begin
	if (moleState and maskState=stateStop) and (moleY<10) and (globalTime-moleFallenTime>=50) then
	Begin
		ch:=buffer[rowOfs[moleY+1]+moleX];
		if (ch=0) then
		begin
			moleState:=stateFallen+(moleState and maskDir);
		end;
	End;

	if (globalTime-moleTime>=3) and (oMoleState<>moleState) then
	begin
		newState:=$ff;
		state:=moleState and maskState;
		phase:=moleState and maskPhase;
		moleDir:=moleState and maskDir;
		dir:=moleDir shr 3;
		if (state=stateMove) then
		begin
			if (moleDir=dirLeft) then
			begin
				if (phase<4) then
				begin
					mX:=mX-2;
					setMoleSprite(moleSpritePhases[1][phase]);
					updateMolePosition();
					inc(phase); if (phase and 3=2) then SFX_Play(0,50,4);
				end
				else
				begin
					updateMolePosition();
					setMoleSprite(moleSpritePhases[0][dir]);
					phase:=0;
					newState:=stateStop;
				end;
			end;
			if (moleDir=dirRight) then
			begin
				if (phase<4) then
				begin
					mX:=mX+2;
					setMoleSprite(moleSpritePhases[2][phase]);
					updateMolePosition();
					inc(phase); if (phase and 3=2) then SFX_Play(0,50,4);
				end
				else
				begin
					updateMolePosition();
					setMoleSprite(moleSpritePhases[0][dir]);
					phase:=0;
					newState:=stateStop;
				end;
			end;
			moleFallenTime:=globalTime;
		end;

		if (state=stateJump) then
		begin
			if (phase<5) then
			begin
				if (phase<4) then
				begin
					mY:=mY-4;
					if (phase=0) then SFX_Play(0,100,6);
					setMoleSprite(moleSpritePhases[3][dir shl 1]);
				end
				else
				begin
					SFX_Play(0,50,4);
					setMoleSprite(moleSpritePhases[3][dir shl 1+1]);
				end;
				updateMolePosition();
				inc(phase);
			end
			else
			begin
				setMoleSprite(moleSpritePhases[0][dir]);
				updateMolePosition();
				phase:=0;
				newState:=stateStop;
			end;
			moleFallenTime:=globalTime;
		end;

		if (state=stateFallen) then
		begin
			if (phase<5) then
			begin
				if (phase<4) then
				begin
					mY:=mY+4;
					setMoleSprite(moleSpritePhases[3][dir shl 1+1]);
				end
				else
				begin
					SFX_Play(0,50,4);
					setMoleSprite(moleSpritePhases[3][dir shl 1]);
				end;
				updateMolePosition();
				inc(phase);
			end
			else
			begin
				setMoleSprite(moleSpritePhases[0][dir]);
				updateMolePosition();
				phase:=0;
				newState:=stateStop;
				moleFallenTime:=globalTime;
				moleY:=moleY+1;
			end;
		end;

		oMoleState:=moleState; 					// save old mole state
		if (newState<>$ff) then
			moleState:=newState+moleDir+phase	// set NEW mole state
		else
			moleState:=(moleState and (maskState+maskDir))+phase;	// update mole state

		moleTime:=globalTime;						// reset mole timer
	end;
end;

procedure moleControl();
var
	kb:TKeys;
	phase,moleDir:byte;

begin
	phase:=moleState and maskPhase;
	moleDir:=moleState and maskDir;
	JOY2KEY();
	if (kbcode<>$ff) and ((phase=0) or (phase=4)) then
	begin
    kb:=TKeys(kbcode);
    case kb of
			key_Left: if (moleX>1) then moleState:=stateMove+dirLeft;
			key_Right: if (moleX<18) then moleState:=stateMove+dirRight;
			key_Up: if (moleY>2) and (moleState and maskState=stateStop) then moleState:=stateJump+moleDir;
			key_ESC: breakGame:=true;
		end;
		kbcode:=255;
	end;
end;

//
procedure moleEatBlock(blockIndex:byte);
var
	blockOfs:byte;
	points:longint;

begin
	points:=0;
	//	remove block from blocks list
	totalBlocks:=totalBlocks-1;
	blockOfs:=blockIndex shl 2;
	if (blockState and stateVanishBlock=stateVanishBlock) then
		if (blockOfs=vanishingBlockOfs) then // mole eat vanishing block (extra points!)
		begin
			Block:=blocksList[vanishingBlockOfs+2];
			removeBlockDef(Block);
			vanishingBlockOfs:=$ff;
			vanishTime:=globalTime;
			blockState:=blockState and (not stateVanishBlock);
			points:=10;
		end
		else
			if (blockOfs<vanishingBlockOfs) then
				vanishingBlockOfs:=vanishingBlockOfs-4;

	move(@blocksList[blockOfs+4],@blocksList[blockOfs],252-blockOfs);
	//
	SFX_Play(1,20,5);
	move(@buffer,@scr[40],240);

	if (points=0) then points:=1;
	points:=points*(12-moleY);
	inc(Status.score,points);
	inc(Status.blocks,1);
	updateTopStatus();
	updateBottomStatus();

	moleState:=moleState+stateEat;
	blockState:=(blockState and stateVanishBlock)+stateDropBlocks+stateNewBlocks;

	if (globalTime-blocksTime>Status.blockFallSpeed) then blocksTime:=globalTime+10;
end;

//
procedure moleTest();
var
	ch:byte;

begin
	moleX:=mx shr 3; moleY:=my shr 4;

	if (moleState and (maskState+maskDir)=(stateMove+dirRight)) then moleX:=moleX+1;
	ch:=buffer[rowOfs[moleY]+moleX];
	if (ch<>0) then
	begin
		block:=pointTest(moleX,moleY,totalBlocks);
		if (block<$ff) then moleEatBlock(block);
	end;
end;

procedure moleDie();
var i,y,w:byte;
	dieTime,anmTime:longint;
const
	sprofs:array[0..3] of word = ($0f0,$100,$110,$100);

begin
	SFX_Play(0,10,7);
	i:=12; dieTime:=getTime; anmTime:=dieTime;
	PCOL[2]:=15; HPOSP[2]:=49+mx; y:=28+my; w:=0;
	kbcode:=255;
	repeat
		if (getTime-anmTime>=4) then
		begin
			setMoleSprite(i);
			if (w<=48) then
			begin
				w:=w+1;
				if (w<17) then
					move(@sprites[sprofs[w and %11]],@pmg[$200+y],w)
				else
					if (w<32) then
						move(@sprites[sprofs[w and %11]],@pmg[$200+y],16)
					else
						if (w<48) then
							move(@sprites[sprofs[w and %11]+(w-32)],@pmg[$200+y],(48-w));
				if (w<32) then y:=y-1;
				if (w>32) and (w<48) then PCOL[2]:=48-w;
			end;
			i:=i+1; if (i>14) then i:=12;
			anmTime:=getTime;
		end;
	until getTime-dieTime>250;
	gameOver:=true;
	kbcode:=255;
end;

procedure blockTest();
var
	ofs:byte;

begin
	if (blockState and stateNewBlocks=stateNewBlocks) then
	begin
		newBlocks:=ShuffleBlocks(0,totalBlocks);
		if (newBlocks=0) then
			blockState:=blockState and (not stateNewBlocks)
		else
		Begin
			totalBlocks:=totalBlocks+newBlocks;
			ofs:=newBlocks shl 2;
			move(blocksList[0],blocksList[ofs],totalBlocks shl 2);
			move(blocksList[totalBlocks shl 2],blocksList[0],newBlocks shl 2);
			if (blockState and stateVanishBlock=stateVanishBlock) then
				vanishingBlockOfs:=vanishingBlockOfs+ofs;
			blockState:=blockState or stateDropBlocks;
		End;
	end;

//		poke(712,globalTime-blocksTime);
	if (globalTime-blocksTime>=Status.blockFallSpeed) then
	begin
		if (blockState and stateDropBlocks=stateDropBlocks) then
		begin
			blocksFallen:=DropBlocks(totalBlocks);
			if (blocksFallen=0) then
				blockState:=blockState and (not stateDropBlocks)
			else
				move(@buffer,@scr[40],240);

			if (buffer[rowOfs[moleY]+moleX]<>0) then moleDie();
		end;
		blocksTime:=globalTime;
	end;
end;

procedure blockVanishTest();
var
	ofs:byte;

begin
	if (blockState and stateVanishBlock=0) and
		 (globalTime-vanishTime>=status.blockVanishingTime-status.vanishWarning) then // Warning of block disappearance
	begin
		ofs:=RandomBottomBlock(totalBlocks);
		if (ofs<>$ff) then
		begin
			blockState:=blockState+stateVanishBlock;
			vanishingBlockOfs:=ofs;
			vanishBreakTime:=0; // instantly break vanishing block
		end
		else
			vanishTime:=globalTime;
	end;

	if (blockState and stateVanishBlock<>0) then
	begin
		Xpos:=blocksList[vanishingBlockOfs];
		Ypos:=blocksList[vanishingBlockOfs+1];
		Block:=blocksList[vanishingBlockOfs+2];
		Color:=blocksList[vanishingBlockOfs+3];
		if (globalTime-vanishTime>=status.blockVanishingTime) then // vanish block
		begin
			SFX_Play(1,200,8);
			ClearBlock(Xpos,Ypos,Block);
			removeBlockDef(Block);

			move(@buffer,@scr[40],240);
			move(@blocksList[vanishingBlockOfs+4],@blocksList[vanishingBlockOfs],(totalBlocks shl 2)-vanishingBlockOfs);
			totalBlocks:=totalBlocks-1;
			blockState:=stateDropBlocks+stateNewBlocks;
			vanishTime:=globalTime;
			vanishingBlockOfs:=$ff;
			if (globalTime-blocksTime>Status.blockFallSpeed) then
				blocksTime:=globalTime;
		end
		else
		begin
			if (globalTime-vanishBreakTime>=Status.breakSpeed) then
			Begin
				SFX_Play(1,200,9);
				BreakBlock(vanishingBlockOfs shr 2);
				vanishBreakTime:=globalTime;
				DrawBlock(Xpos,Ypos,Block,Color);
				move(@buffer,@scr[40],240);
			End;
		end;
	end;
end;

procedure gameLoop();
begin
		repeat
			globalTime:=getTime;
			moleControl();
			moleMove();
			if (moleState and stateEat=0) and
				 (moleState and maskPhase=2) then moleTest();
			if (blockState and (stateDropBlocks+stateNewBlocks)<>0) then blockTest();
			blockVanishTest();
		until gameOver or breakGame;
end;

procedure ReadyScreen();
var i,len:byte;

begin
	resetDL();
// set character
	CHBAS:=CHARSET1_PAGE;

	colpf[0]:=$24;

	fillchar(@scr,240,$00);

	for i:=0 to 1 do
	begin
		len:=stringLen(string_ready,i);
		putSCString(90-len shr 1+i*20,string_ready,i,0)
	end;
	// TODO: READU SCREEN
//	move(@ready,@scr[60],SCR_READY_SIZE); // show "GET REDY MOLE"

	offPMG();
	onVideo();
end;

procedure GameScreen();
begin
	setDL(DLIST_GAME_ADDR,@dli_game);

// prepare screen
	fillchar(@scr,280,0);
	move(@statusbar,@scr[SCREEN_GAME_SIZE-SCR_STATUSBAR_SIZE],SCR_STATUSBAR_SIZE);
	move(@buffer,@scr[40],240);

	putSCString(2,string_topstatus,0,0);
	putSCString(12,string_topstatus,1,0);

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
