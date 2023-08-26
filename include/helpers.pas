var
	firstRun:boolean = True;
	scr:Array[0..839] of Byte absolute SCREEN_ADDR;
	buffer:Array[0..511] of Byte absolute SCREEN_BUFFER_ADDR;
	sprites:array[0..319] of Byte absolute SPRITES_ADDR;
	logos:array[0..63] of Byte absolute LOGOS_DATA_ADDR;
	statusbar:Byte absolute SCR_STATUSBAR_ADDR;
	strings_Pointers:array[0..6] of Word absolute STRINGS_PointerS_ADDR;
	strings_data:array[0..0] of Byte absolute STRINGS_DATA_ADDR;

	kbcode:Byte absolute 764;
	_timer:Byte absolute $14;
	scradr:Word absolute 88;
	curDLIPtr,oldDLI,oldVBL:Pointer;
	DList:Word absolute $230;
	RAND:Byte absolute $d20a;
	colpf:array[0..4] of Byte absolute $2c4;

	GPRIOR:Byte absolute $26f;
	PMCTL:Byte absolute $d01d;
	HPOSP:array[0..3] of Byte absolute $d000;
	pmg:array[0..1023] of Byte absolute PMG_ADDR;
	PCOL:array[0..3] of Byte absolute 704;
	KRPDEL:Byte absolute $2d9;
	KEYREP:Byte absolute $2da;
	VCOUNT:Byte absolute $d40b;

	isPMG:Boolean = false;
	STICK : Byte absolute $278;
	STRIG : Byte absolute $284;
	oldSTICK:Byte = 15;
	oldSTRIG:Byte = 1;

// procedure moveZero(src,dst:Pointer; size:Byte); register;
// begin
// 	asm {
// 			ldy size
// 			beq ext
// 		lp:
// 			dey
// 			bmi ext
// 			lda (src),y
// 			beq lp
// 			sta (dst),y
// 		nxt:
// 			bne lp
// 		ext:
// 	};
// end;

// procedure _wait4key();
// begin
// 	kbcode:=255; repeat until kbcode<>255; kbcode:=255;
// end;

procedure delay(ticks:Byte);
var
	oTM:Byte;

begin
	oTM:=_timer;
	repeat until byte(_timer-oTM)>=ticks;
end;

procedure wait4screen();
begin
	repeat until VCOUNT=0;
end;

procedure onVideo();
begin
	if (isPMG) then
		SDMCTL:=%00111010
	else
		SDMCTL:=%00101010;
end;

procedure offVideo();
begin
	SDMCTL:=%00000000;
	wait4screen();
end;

procedure setDL(dl_set:Word; dliPtr:Pointer);
begin
	offVideo();
	delay(5);
	NMIEN:=%01000000; // turn off DLI
	if dliPtr<>nil then
	begin
		curDLIPtr:=dliPtr;
		SetIntVec(iDLI, dliPtr);
		NMIEN:=%11000000; // turn on DLI
	end
	else
	begin
		SetIntVec(iDLI, oldDLI);
	end;
	DList:=dl_set;
end;

(*
procedure resetDL();
begin
	offVideo();
	NMIEN:=%01000000; // turn off DLI
	SetIntVec(iDLI,oldDLI);
	DList:=DLIST_READIE_ADDR;
end;
*)

procedure initPMG();
begin
	PMBASE:=PMG_BASE; PMCTL:=3; GPRIOR:=%00100001;
	fillchar(pointer(PMG_ADDR-$100),1024+256,0);
	isPMG:=true;
end;

(*
procedure offPMG();
begin
	PMCTL:=0; GPRIOR:=%00000000;
	isPMG:=false;
end;
*)

procedure joy2key();
const
	joy_up		= 14;
	joy_down	= 13;
	joy_left	= 11;
	joy_right	= 7;

var
	ATRACT:Byte absolute $4d;
begin
	ATRACT:=0;

	if (STICK<>oldSTICK) or (STRIG<>oldSTRIG) then
	begin
		oldSTICK:=STICK; oldSTRIG:=STRIG;
		case STICK of
			joy_left: kbcode:=Byte(key_Left);
			joy_right: kbcode:=Byte(key_Right);
			joy_up: kbcode:=Byte(key_Up);
			joy_down: kbcode:=Byte(key_Down);
		end;
		if (STRIG=0) then kbcode:=Byte(key_RETURN);
//		if STICK=15 then kbcode:=255;
	end;
end;

// strings

var
	txtofs,scrofs:Word;
	ch:Byte;
	i,j:Byte;

procedure subStringSelect(sID,subSId:Byte);
begin
	txtofs:=strings_Pointers[sId]-STRINGS_DATA_ADDR;
	// substring seek
	while subSId>0 do
	begin
		while strings_data[txtofs]<>$ff do txtofs:=txtofs+1;
		subSId:=subSId-1; txtofs:=txtofs+1;
	end;
end;

function stringLen(sId,subSId:Byte):Byte;
begin
	result:=0;
	subStringSelect(sId,subSId);

	// counting length
	while strings_data[txtofs]<>$ff do
	begin
		result:=result+1; txtofs:=txtofs+1;
	end;
end;

procedure putSCString(scrofs:Word; sId,subSId:Byte; color:Byte);
begin
	color:=color shl 7;
	subStringSelect(sId,subSId);
	// string put to screen;
	while strings_data[txtofs]<>$ff do
	begin
		ch:=strings_data[txtofs]; txtofs:=txtofs+1;
		scr[scrofs]:=ch or color; scrofs:=scrofs+1;
	end;
end;

function stringDCLen():Byte;
var
  otxtofs:Word;

begin
	result:=0; otxtofs:=txtofs;
	while strings_data[txtofs]<>$ff do
	begin
		ch:=strings_data[txtofs];
		if (ch<>$00) and (ch<>$0e) and (ch<>$0f) and (ch<>$1a) then
			inc(result);
		inc(result); inc(txtofs);
	end;
	txtofs:=otxtofs;
end;

procedure putDCString(x,y:Byte; inv:Boolean);
var
	color:Byte;

begin
	scrofs:=leftBound[y]+x;
	if (inv) then color:=$80 else color:=$00;

	// string put to screen;
	while strings_data[txtofs]<>$ff do
	begin
		ch:=strings_data[txtofs]; inc(txtofs);
		if (ch=$00) or (ch=$0e) or (ch=$0f) or (ch=$1a) then
		begin
			if (ch=$00) then ch:=$00; // space
			if (ch=$0e) then ch:=$1c; // dot '.'
			if (ch=$0f) then ch:=$1e; // slash '/'
			if (ch=$1a) then ch:=$1d; // colon ':'
		end
		else
		begin
			ch:=ch shl 1+ch and $80;
			scr[scrofs]:=ch or color; scrofs:=scrofs+1; ch:=ch+1;
		end;
		scr[scrofs]:=ch or color;
		inc(scrofs);
	end;
	inc(txtofs);
end;

procedure putSCText(scrofs:Word; s:string; color:Byte);
const
	_color:array[0..3] of Byte = ($00,$40,$80,$c0);

begin
	color:=_color[color];
	// string put to screen;
	i:=1;
	while i<=length(s) do
	begin
		ch:=Byte(s[i])-32; i:=i+1;
		scr[scrofs]:=ch or color; scrofs:=scrofs+1;
	end;
end;

procedure putDCText(x,y:Byte; s:string; inv:Boolean);
var
	color:Byte;

begin
	scrofs:=leftBound[y]+x;
	if (inv) then color:=$80 else color:=$00;
	// string put to screen;
	i:=1;
	while i<=length(s) do
	begin
		ch:=Byte(s[i])-32; i:=i+1;
		ch:=ch shl 1+ch and $80;
		scr[scrofs]:=ch or color; scrofs:=scrofs+1; ch:=ch+1;
		scr[scrofs]:=ch or color; scrofs:=scrofs+1;
	end;
end;
