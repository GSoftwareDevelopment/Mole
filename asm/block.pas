const
	DefinedBlocks = 17;

	rowOfs:array[0..11] of byte=($00,$14,$28,$3c,$50,$64,$78,$8c,$a0,$b4,$c8,$dc);
	_RAND = $d20a;

var
	testX		:byte absolute $e2;
	testY		:byte absolute $e3;
//	bm			:byte absolute $e6; // number of landslide blocks. 0 means that no blocks have fallen
	tb			:byte absolute $e7; // total blocks on screen
	Xpos		:byte absolute $e8;
	Ypos		:byte absolute $e9;
	Block		:byte absolute $ea;
	Color		:byte absolute $eb;
//	BlockW	:byte absolute $ec;
//	BlockH	:byte absolute $ed;

	defvec	:word absolute $f1; // 2 bytes
	lstvec	:word absolute $f3; // 2 bytes

	fr0:word absolute $e0;
	blocksList:array[0..255] of byte absolute BLOCKS_LIST_ADDR;
	blocksDef:array[0..255] of byte absolute BLOCKS_DEF_ADDR;

	lastDefinedBlock:byte = DefinedBlocks;

// Rysuj blok
procedure DrawBlock(_Xpos,_Ypos,_Block,_Color:Byte);
begin
	Xpos:=_Xpos;
	Ypos:=_Ypos;
	Block:=_Block;
	Color:=_Color;
	asm {
		jsr BLOCK_ASM_ADDR+$000e
	};
end;

// function TestBlock(_Xpos,_Ypos,_Block:Byte):boolean;
// begin
// 	Xpos:=_Xpos;
// 	Ypos:=_Ypos;
// 	Block:=_Block;
// 	asm {
// 		jsr BLOCK_ASM_ADDR+$0032
// 	};
// 	result:=boolean(fr0); // zwrot, prawda, jeżeli testowany blok koliduje
// end;

procedure ClearBlock(_Xpos,_Ypos,_Block:Byte);
begin
	Xpos:=_Xpos;
	Ypos:=_Ypos;
	Block:=_Block;
	asm {
		jsr BLOCK_ASM_ADDR+$0065
	};
end;

function DropBlocks(_totalBlocks:Byte):Byte;
begin
	tb:=_totalBlocks;
	asm {
		jsr BLOCK_ASM_ADDR+$0082
	};
	result:=byte(fr0); // zwrot, ilość osuniętych bloków
end;

function PointTest(_X,_Y,_totalBlocks:Byte):byte;
begin
	testX:=_X;
	testY:=_Y;
	tb:=_totalBlocks;
	asm {
		jsr BLOCK_ASM_ADDR+$00d4
	};
	result:=byte(fr0); // zwrot, numer bloku spełniającego test
end;

function ShuffleBlocks(_Ypos,_totalBlocks:Byte):byte;
begin
	Ypos:=_Ypos;
	tb:=_totalBlocks;
	asm {
		jsr BLOCK_ASM_ADDR+$0153
	};
	result:=byte(fr0); // zwrot, ilość nowych bloków
end;

function RandomBottomBlock(_totalBlocks:Byte):byte;
begin
	tb:=_totalBlocks;
	asm {
		jsr BLOCK_ASM_ADDR+$01ac
	};
	result:=byte(fr0); // zwrot, offset wylosowanego bloku, lub $ff, jeżeli takiego bloku nie ma
end;

function cloneBlockDef(_block:byte):byte;
begin
	move(@blocksDef[_block shl 3],@blocksDef[lastDefinedBlock shl 3],8);
	result:=lastDefinedBlock;
	inc(lastDefinedBlock);
end;

procedure removeBlockDef(_block:byte);
var
	defOfs:byte;

begin
	if (_block>=DefinedBlocks) then
	begin
		defOfs:=_block shl 3;
		move(@blocksDef[defOfs+8],@blocksDef[defOfs],255-defOfs);
		dec(lastDefinedBlock);
	end;
end;

function BreakBlock(_blockIndex:byte):boolean;
var
	i,defOfs,el:byte;
	els:array[0..5] of byte;

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
		// zamień na uszkodzony blok
		blocksDef[els[el]]:=blocksDef[els[el]]+6;
		// uaktualnij index bloku na liście bloków
		blocksList[(_blockIndex shl 2)+2]:=Block;
		// zakończ z wynikiem true
		result:=true;
	end
	else
		// ...nie ma, zakończ z wynikiem false
		result:=false;
end;
