procedure initNewGame();
var
	newBlocks:Byte;
	dx:shortint;
	waitTm:Byte absolute TIMER4;

begin
	waitTm:=75;
// prepare playfield buffer
	fillchar(pointer(SCREEN_BUFFER_ADDR),240,$00); // wall character
	for i:=0 to 11 do
	begin
		poke(SCREEN_BUFFER_ADDR+i*20,$3b);
		poke(SCREEN_BUFFER_ADDR+i*20+19,$3c);
		// buffer[i*20]:=$3b; buffer[i*20+19]:=$3c;
	end;
	poke(SCREEN_BUFFER_ADDR+220,$3f);
	poke(SCREEN_BUFFER_ADDR+239,$3f);
	// buffer[220]:=$3f; buffer[239]:=$3f;
	fillchar(pointer(SCREEN_BUFFER_ADDR+221),18,$3d);

// generate blocks
	lastDefinedBlock:=DefinedBlocks;
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
	while peek(SCREEN_BUFFER_ADDR+moleOfs)<>0 do
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
	status.blockFallSpeed:=20;
	status.blockVanishingTime:=250;
	status.vanishWarning:=100;
	status.breakSpeed:=25;
	gameOver:=false; breakGame:=false;

	SFX_PlaySONG(20*4);
// delay
	repeat until waitTm=0;

// set timers
	// globalTime:=getTime;
	moleTime:=0; // globalTime;
	moleFallenTime:=0; //globalTime;
	blocksTime:=status.blockFallSpeed; // globalTime;
	vanishTime:=status.blockVanishingTime; // globalTime;
end;

(*
* level	nextLevel		blockFallSpeed	blockVanishingTime	vanishWarning		breakSpeed
* 	0			50							75						500									200							50
*)
//
//

procedure moleMove();
var
	state,
	newState,
	moleDir,
	phase,dir:Byte;

begin
	if (moleState and maskState=stateStop) and (moleY<10) and (moleFallenTime=0) then
	Begin
		ch:=peek(SCREEN_BUFFER_ADDR+rowOfs[moleY+1]+moleX);
		if (ch=0) then
		begin
			moleState:=stateFallen+(moleState and maskDir);
		end;
	End;

	if (moleTime=0) and (oMoleState<>moleState) then
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
					inc(phase);
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
					inc(phase);
				end
				else
				begin
					updateMolePosition();
					setMoleSprite(moleSpritePhases[0][dir]);
					phase:=0;
					newState:=stateStop;
				end;
			end;
			if (phase and 3=2) then SFX_Freq(plyChn+1,50,sfx_moleMove);
			moleFallenTime:=50; // globalTime;
		end;

		if (state=stateJump) then
		begin
			if (phase<5) then
			begin
				if (phase<4) then
				begin
					mY:=mY-4;
					if (phase=0) then SFX_Freq(plyChn,100,sfx_moleJump);
					setMoleSprite(moleSpritePhases[3][dir shl 1]);
				end
				else
				begin
					SFX_Freq(plyChn+1,50,sfx_moleMove);
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
			moleFallenTime:=50;
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
					SFX_Freq(plyChn+1,50,sfx_moleMove);
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
				moleFallenTime:=50;
				moleY:=moleY+1;
			end;
		end;

		oMoleState:=moleState; 					// save old mole state
		if (newState<>$ff) then
			moleState:=newState+moleDir+phase	// set NEW mole state
		else
			moleState:=(moleState and (maskState+maskDir))+phase;	// update mole state

		moleTime:=3; // reset mole timer
	end;
end;

procedure moleControl();
var
	phase,moleDir:Byte;

begin
	phase:=moleState and maskPhase;
	moleDir:=moleState and maskDir;
	joy2key();
	if (joy<>0) and (phase and 3=0{(phase=0) or (phase=4)}) then
	begin
    case joy of
			joy_Left: if (moleX>1) then moleState:=stateMove+dirLeft;
			joy_Right: if (moleX<18) then moleState:=stateMove+dirRight;
			joy_Up: if (moleY>2) and (moleState and maskState=stateStop) then moleState:=stateJump+moleDir;
			// key_ESC: breakGame:=true;
		end;
	end;
end;

//
procedure moleEatBlock(blockIndex:Byte);
var
	blockOfs:Byte;
	points:longint;

begin
	points:=0;
	//	remove block from blocks list
	totalBlocks:=totalBlocks-1;
	blockOfs:=blockIndex shl 2;
	Block:=blocksList[blockOfs+2];
	if (blockState and stateVanishBlock=stateVanishBlock) then
		if (blockOfs=vanishingBlockOfs) then // mole eat vanishing block (extra points!)
		begin
			Block:=blocksList[vanishingBlockOfs+2];
			removeBlockDef(Block);
			vanishingBlockOfs:=$ff;
			vanishTime:=status.blockVanishingTime; // globalTime;
			blockState:=blockState and (not stateVanishBlock);
			points:=10;
		end
		else
			if (blockOfs<vanishingBlockOfs) then
				vanishingBlockOfs:=vanishingBlockOfs-4;

	move(@blocksList[blockOfs+4],@blocksList[blockOfs],252-blockOfs);
	putBlocksOnScreen;
	//

	if Block<>17 then
	begin	// mole eat block
		points:=(12-moleY);
		SFX_Freq(plyChn+1,20,sfx_moleEat);
		inc(Status.blocks,1);
	end
	else // mole eat coin
	begin
		points:=25;
		SFX_Freq(plyChn+1,40,sfx_choice);
	end;
	if points>0 then
	begin
		inc(Status.score,points);
		updateTopStatus();
		if Block<>17 then updateBottomStatus();
	end;
	moleState:=moleState+stateEat;
	blockState:=(blockState and stateVanishBlock)+stateDropBlocks+stateNewBlocks;

//	inc(blocksTime,10);
end;

//
procedure moleTest();
begin
	moleX:=mx shr 3; moleY:=my shr 4;

	if (moleState and (maskState+maskDir)=(stateMove+dirRight)) then moleX:=moleX+1;
	ch:=peek(SCREEN_BUFFER_ADDR+rowOfs[moleY]+moleX);
	if (ch<>0) then
	begin
		block:=pointTest(moleX,moleY,totalBlocks);
		if (block<$ff) then moleEatBlock(block);
	end;
end;

procedure blockTest();
var
	ofs,_tb:Byte;

begin
	if (blockState and stateNewBlocks=stateNewBlocks) then
	begin
		newBlocks:=ShuffleBlocks(0,totalBlocks);
		if (newBlocks=0) then
			blockState:=blockState and (not stateNewBlocks)
		else
		Begin
			totalBlocks:=totalBlocks+newBlocks;
			ofs:=newBlocks shl 2; _tb:=totalBlocks shl 2;
			move(blocksList[0],blocksList[ofs],_tb);
			move(blocksList[_tb],blocksList[0],ofs(*newBlocks shl 2*));
			if (blockState and stateVanishBlock=stateVanishBlock) then
				vanishingBlockOfs:=vanishingBlockOfs+ofs;
			blockState:=blockState or stateDropBlocks;
		End;
	end;

	if blocksTime=0 then
	begin
		if (blockState and stateDropBlocks=stateDropBlocks) then
		begin
			blocksFallen:=DropBlocks(totalBlocks);
			if (blocksFallen=0) then
				blockState:=blockState and (not stateDropBlocks)
			else
			begin
				putBlocksOnScreen;
				blocksTime:=Status.blockFallSpeed;
			end;

			if (peek(SCREEN_BUFFER_ADDR+rowOfs[moleY]+moleX)<>0) then
			begin
				block:=pointTest(moleX,moleY,totalBlocks);
				block:=blocksList[block*4+2];
				if block<>17 then
					gameover:=true
				else
				begin
				end;
			end;
		end;
	end;
end;

procedure blockVanishTest();
var
	ofs:Byte;

begin
	if (blockState and stateVanishBlock=0) then
	begin
		if (vanishTime=status.vanishWarning)
			(*(globalTime-vanishTime>=status.blockVanishingTime-status.vanishWarning)*) then // Warning of block disappearance
		begin
			ofs:=RandomBottomBlock(totalBlocks);
			if (ofs<>$ff) then
			begin
				blockState:=blockState+stateVanishBlock;
				vanishingBlockOfs:=ofs;
				vanishBreakTime:=0; // instantly break vanishing block
			end
			else
				vanishTime:=status.blockVanishingTime; // globalTime;
		end
		else if vanishTime=0 then
		begin
			vanishTime:=status.blockVanishingTime;
			vanishingBlockOfs:=$ff;
		end;
	end;

	if (blockState and stateVanishBlock<>0) then
	begin
		// copy block information to registers (Xpos,Ypos,Block,Color)
		//	Xpos:=blocksList[vanishingBlockOfs];
		//	Ypos:=blocksList[vanishingBlockOfs+1];
		//	Block:=blocksList[vanishingBlockOfs+2];
		//	Color:=blocksList[vanishingBlockOfs+3];
		move(@blocksList[vanishingBlockOfs],@Xpos,4);
		if vanishTime=0 then // vanish block
		begin
			SFX_Freq(plyChn,200,sfx_blockBrk);

			ClearBlock(Xpos,Ypos,Block);
			removeBlockDef(Block);

			putBlocksOnScreen;
			move(@blocksList[vanishingBlockOfs+4],@blocksList[vanishingBlockOfs],(totalBlocks shl 2)-vanishingBlockOfs);
			totalBlocks:=totalBlocks-1;
			blockState:=stateDropBlocks+stateNewBlocks;
			vanishTime:=status.blockVanishingTime;
			vanishingBlockOfs:=$ff;
		end
		else
		begin
			if vanishBreakTime=0 then
			Begin
				SFX_Freq(plyChn,200,sfx_blockVsh);

				BreakBlock(vanishingBlockOfs shr 2);
				vanishBreakTime:=Status.breakSpeed;
				DrawBlock(Xpos,Ypos,Block,Color);
				putBlocksOnScreen;
			End;
		end;
	end;
end;

procedure gameLoop();
begin
	repeat
		moleControl();
		moleMove();
		if (moleState and stateEat=0) and
			(moleState and maskPhase=2) then moleTest();
		if (blockState and (stateDropBlocks+stateNewBlocks)<>0) then blockTest();
		blockVanishTest();
	until gameOver or breakGame;
end;

