const
	DefinedBlocks = 18;

	rowOfs:array[0..11] of Byte=($00,$14,$28,$3c,$50,$64,$78,$8c,$a0,$b4,$c8,$dc);
	_RAND = $d20a;

var
	fr0			:Word absolute $70;
	testX		:Byte absolute $72;
	testY		:Byte absolute $73;
	tb			:Byte absolute $77; // total blocks on screen
	Xpos		:Byte absolute $78;
	Ypos		:Byte absolute $79;
	Block		:Byte absolute $7a;
	Color		:Byte absolute $7b;

	defvec		:Word absolute $62; // 2 Bytes
	lstvec		:Word absolute $64; // 2 Bytes

	blocksList	:array[0..255] of Byte absolute BLOCKS_LIST_ADDR;
	blocksDef	:array[0..255] of Byte absolute BLOCKS_DEF_ADDR;

	lastDefinedBlock:Byte = DefinedBlocks;

// Rysuj blok
procedure DrawBlock(_Xpos,_Ypos,_Block,_Color:Byte);
begin
	Xpos:=_Xpos;
	Ypos:=_Ypos;
	Block:=_Block;
	Color:=_Color;
	asm {
		jsr RESOURCE.RESOURCE.RCASM5.RESOURCE._BLOCK_ASM_ADDR.DRAWBLOCK // BLOCK_ASM_ADDR+$000e
	};
end;

// function TestBlock(_Xpos,_Ypos,_Block:Byte):Boolean;
// begin
// 	Xpos:=_Xpos;
// 	Ypos:=_Ypos;
// 	Block:=_Block;
// 	asm {
// 		jsr RESOURCE.RESOURCE.RCASM5.RESOURCE._BLOCK_ASM_ADDR.TESTBLOCK // BLOCK_ASM_ADDR+$0032
// 	};
// 	result:=Boolean(fr0); // zwrot, prawda, jeżeli testowany blok koliduje
// end;

procedure ClearBlock(_Xpos,_Ypos,_Block:Byte);
begin
	Xpos:=_Xpos;
	Ypos:=_Ypos;
	Block:=_Block;
	asm {
		jsr RESOURCE.RESOURCE.RCASM5.RESOURCE._BLOCK_ASM_ADDR.CLEARBLOCK // BLOCK_ASM_ADDR+$0065
	};
end;

function DropBlocks(_totalBlocks:Byte):Byte;
begin
	tb:=_totalBlocks;
	asm {
		jsr RESOURCE.RESOURCE.RCASM5.RESOURCE._BLOCK_ASM_ADDR.DROPBLOCKS // BLOCK_ASM_ADDR+$0082
	};
	result:=Byte(fr0); // zwrot, ilość osuniętych bloków
end;

function PointTest(_X,_Y,_totalBlocks:Byte):Byte;
begin
	testX:=_X;
	testY:=_Y;
	tb:=_totalBlocks;
	asm {
		jsr RESOURCE.RESOURCE.RCASM5.RESOURCE._BLOCK_ASM_ADDR.POINTTEST // BLOCK_ASM_ADDR+$00d4
	};
	result:=Byte(fr0); // zwrot, numer bloku spełniającego test
end;

function ShuffleBlocks(_Ypos,_totalBlocks:Byte):Byte;
begin
	Ypos:=_Ypos;
	tb:=_totalBlocks;
	asm {
		jsr RESOURCE.RESOURCE.RCASM5.RESOURCE._BLOCK_ASM_ADDR.SHUFFLEBLOCK // BLOCK_ASM_ADDR+$0153
	};
	result:=Byte(fr0); // zwrot, ilość nowych bloków
end;

function RandomBottomBlock(_totalBlocks:Byte):Byte;
begin
	tb:=_totalBlocks;
	asm {
		jsr RESOURCE.RESOURCE.RCASM5.RESOURCE._BLOCK_ASM_ADDR.RANDOMBOTTOMBLOCK // BLOCK_ASM_ADDR+$01ac
	};
	result:=Byte(fr0); // zwrot, offset wylosowanego bloku, lub $ff, jeżeli takiego bloku nie ma
end;

function cloneBlockDef(_block:Byte):Byte;
begin
	move(@blocksDef[_block shl 3],@blocksDef[lastDefinedBlock shl 3],8);
	result:=lastDefinedBlock;
	inc(lastDefinedBlock);
end;

procedure removeBlockDef(_block:Byte);
var
	defOfs:Byte;

begin
	if (_block>=DefinedBlocks) then
	begin
		defOfs:=_block shl 3;
		move(@blocksDef[defOfs+8],@blocksDef[defOfs],247-defOfs);
		dec(lastDefinedBlock);
	end;
end;

function BreakBlock(_blockIndex:Byte):Boolean;
var
	i,defOfs,el:Byte;
	els:array[0..5] of Byte;

begin
	Block:=blocksList[(_blockIndex shl 2)+2]; // pobierz index definicji bloku
	// jeżeli jest to podstawowy blok...
	if (Block<DefinedBlocks) then Block:=cloneBlockDef(Block); // ...sklonuj definicje bloku

	defOfs:=Block shl 3; // oblicz offset

	// zbierz informacje o "całych" elementach bloku
	el:=0;
	for i:=(defOfs+2) to (defOfs+7) do
		if (blocksDef[i]<>0) and (blocksDef[i]<6) then
		begin
			els[el]:=i; // zapisz offset elementu (by było szybciej (chyba) :P)
			el:=el+1;
		end;

	// jeżeli są jakieś "całe" elementy...
	if (el>0) then
	begin
		// ...wylosuj jeden
		el:=_RAND mod el;
		i:=els[el];
		// zamień na uszkodzony blok
		blocksDef[i]:=blocksDef[i]+6;
		// uaktualnij index bloku na liście bloków
		blocksList[(_blockIndex shl 2)+2]:=Block;
		// zakończ z wynikiem true
		result:=true;
	end
	else
		// ...nie ma, zakończ z wynikiem false
		result:=false;
end;
