var
	scr:Array[0..839] of byte absolute SCREEN_ADDR;
	buffer:Array[0..511] of byte absolute SCREEN_BUFFER_ADDR;
	sprites:array[0..319] of byte absolute PM_DATA_ADDR;
	logos:array[0..63] of byte absolute LOGOS_DATA_ADDR;
	statusbar:byte absolute SCR_STATUSBAR_ADDR;
	strings_pointers:array[0..6] of word absolute STRINGS_POINTERS_ADDR;
	strings_data:array[0..0] of byte absolute STRINGS_DATA_ADDR;

	kbcode:byte absolute 764;
	_timer:byte absolute $14;
	scradr:word absolute 88;
	oldDLI:pointer;
	DList:word absolute $230;
	RAND:byte absolute $d20a;
	colpf:array[0..4] of byte absolute $2c4;

	GPRIOR:byte absolute $26f;
	PMCTL:byte absolute $d01d;
	HPOSP:array[0..3] of byte absolute $d000;
	pmg:array[0..1023] of byte absolute PMG_ADDR;
	PCOL:array[0..3] of byte absolute 704;
	KRPDEL:byte absolute $2d9;
	KEYREP:byte absolute $2da;
	VCOUNT:byte absolute $d40b;

	isPMG:boolean = false;
	STICK : byte absolute $278;
	STRIG : byte absolute $284;
	oldSTICK:byte = 15;
	oldSTRIG:BYTE = 1;

// procedure _wait4key();
// begin
// 	kbcode:=255; repeat until kbcode<>255; kbcode:=255;
// end;

procedure delay(ticks:byte);
var
	oTM:byte;

begin
	oTM:=_timer;
	repeat until _timer-oTM>=ticks;
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

procedure setDL(dl_set:word; dliPtr:pointer);
begin
	offVideo();
	delay(5);
	NMIEN:=%01000000; // turn off DLI
	if dliPtr<>nil then
	begin
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
	fillchar(@pmg,1024,0);
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
	ATRACT:byte absolute $4d;
begin
	ATRACT:=0;

	if (STICK<>oldSTICK) or (STRIG<>oldSTRIG) then
	begin
		oldSTICK:=STICK; oldSTRIG:=STRIG;
		case STICK of
			joy_left: kbcode:=byte(key_Left);
			joy_right: kbcode:=byte(key_Right);
			joy_up: kbcode:=byte(key_Up);
			joy_down: kbcode:=byte(key_Down);
		end;
		if (STRIG=0) then kbcode:=byte(key_RETURN);
//		if STICK=15 then kbcode:=255;
	end;
end;

// strings

var
	txtofs,scrofs:word;
	ch:byte;
	i,j:byte;

procedure subStringSelect(sID,subSId:Byte);
begin
	txtofs:=strings_pointers[sId]-STRINGS_DATA_ADDR;
	// substring seek
	while subSId>0 do
	begin
		while strings_data[txtofs]<>$ff do txtofs:=txtofs+1;
		subSId:=subSId-1; txtofs:=txtofs+1;
	end;
end;

function stringLen(sId,subSId:byte):byte;
begin
	result:=0;
	subStringSelect(sId,subSId);

	// counting length
	while strings_data[txtofs]<>$ff do
	begin
		result:=result+1; txtofs:=txtofs+1;
	end;
end;

procedure putSCString(scrofs:word; sId,subSId:byte; color:byte);
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

function stringDCLen():byte;
var
  otxtofs:word;

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

procedure putDCString(x,y:byte; inv:boolean);
var
	color:byte;

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

procedure putSCText(scrofs:word; s:string; color:byte);
const
	_color:array[0..3] of byte = ($00,$40,$80,$c0);

begin
	color:=_color[color];
	// string put to screen;
	i:=1;
	while i<=length(s) do
	begin
		ch:=byte(s[i])-32; i:=i+1;
		scr[scrofs]:=ch or color; scrofs:=scrofs+1;
	end;
end;

procedure putDCText(x,y:byte; s:string; inv:boolean);
var
	color:byte;

begin
	scrofs:=leftBound[y]+x;
	if (inv) then color:=$80 else color:=$00;
	// string put to screen;
	i:=1;
	while i<=length(s) do
	begin
		ch:=byte(s[i])-32; i:=i+1;
		ch:=ch shl 1+ch and $80;
		scr[scrofs]:=ch or color; scrofs:=scrofs+1; ch:=ch+1;
		scr[scrofs]:=ch or color; scrofs:=scrofs+1;
	end;
end;
