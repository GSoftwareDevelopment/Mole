const
	stick_up		= 14;
	stick_down	= 13;
	stick_left	= 11;
	stick_right	= 7;

	joy_left		= %01000;
	joy_right		= %00100;
	joy_up			= %00010;
	joy_down		= %00001;
	joy_fire		= %10000;

var
	firstRun:boolean = True;
	scr:Array[0..839] of Byte absolute SCREEN_ADDR;
	string_history	:array[0..3,0..2] of Byte absolute STRINGS_PointerS_ADDR;
	strings_Pointers:array[0..6] of Word absolute STRINGS_PointerS_ADDR+12;
	strings_data:array[0..0] of Byte absolute STRINGS_DATA_ADDR;

	kbcode:Byte absolute 764;
	scradr:Word absolute 88;
	curDLIPtr,oldDLI,oldVBL:Pointer;
	DList:Word absolute $230;
	RAND:Byte absolute $d20a;
	colpf:array[0..4] of Byte absolute $2c4;

	GPRIOR:Byte absolute $26f;
	PMCTL:Byte absolute $d01d;
	HPOSP:array[0..3] of Byte absolute $d000;
	PCOL:array[0..3] of Byte absolute 704;
	KRPDEL:Byte absolute $2d9;
	KEYREP:Byte absolute $2da;
	VCOUNT:Byte absolute $d40b;

	joy:byte;
	key:TKeys;

	isPMG:Boolean = false;

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

procedure delay(ticks:Byte); Assembler;
asm
	lda ticks
	beq endDelay
loopDelay:
	lda $14
	cmp $14
	beq *-2
	dec ticks
	bne loopDelay
endDelay:
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
var
	ATRACT:Byte absolute $4d;
	STICK:Byte absolute $278;
	STRIG:Byte absolute $284;
	oldSTICK:Byte = 15;
	oldSTRIG:Byte = 1;

begin
	ATRACT:=0;
			joy:=0;
	if (STRIG<>oldSTRIG) then
	begin
		if (oldSTRIG=1) then joy:=joy or joy_fire;
		oldSTRIG:=STRIG;
		exit;
	end;
	if (STICK<>oldSTICK) then
	begin
		if oldStick=15 then
			case STICK of
				stick_left: joy:=joy or joy_left;
				stick_right: joy:=joy or joy_right;
				stick_up: joy:=joy or joy_up;
				stick_down: joy:=joy or joy_down;
			end;
		// if oldSTICK=15 then kbcode:=255;
		oldSTICK:=STICK;
	end;
end;

