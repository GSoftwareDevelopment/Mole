// strings
const
	_color:array[0..3] of Byte = ($00,$40,$80,$c0);

var
	txtofs,scrofs:Word;
  otxtofs:Word;
	ch:Byte;
	i,j:Byte;
	txtCol:Byte;

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

procedure putSCString(scrofs:Word; sId,subSId:Byte; txtCol:Byte);
begin
	txtCol:=txtCol shl 7;
	subStringSelect(sId,subSId);
	// string put to screen;
	while strings_data[txtofs]<>$ff do
	begin
		ch:=strings_data[txtofs]; txtofs:=txtofs+1;
		scr[scrofs]:=ch or txtCol; scrofs:=scrofs+1;
	end;
end;

function stringDCLen():Byte;
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
begin
	scrofs:=leftBound[y]+x;
	if (inv) then txtCol:=$80 else txtCol:=$00;

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
			scr[scrofs]:=ch or txtCol; scrofs:=scrofs+1; ch:=ch+1;
		end;
		scr[scrofs]:=ch or txtCol;
		inc(scrofs);
	end;
	inc(txtofs);
end;

procedure putSCText(scrofs:Word; s:string; txtCol:Byte);
begin
	txtCol:=_color[txtCol];
	// string put to screen;
	i:=1;
	while i<=length(s) do
	begin
		ch:=Byte(s[i])-32; i:=i+1;
		scr[scrofs]:=ch or txtCol; scrofs:=scrofs+1;
	end;
end;

procedure putDCText(x,y:Byte; s:string; inv:Boolean);
begin
	scrofs:=leftBound[y]+x;
	if (inv) then txtCol:=$80 else txtCol:=$00;
	// string put to screen;
	i:=1;
	while i<=length(s) do
	begin
		ch:=Byte(s[i])-32; i:=i+1;
		ch:=ch shl 1+ch and $80;
		scr[scrofs]:=ch or txtCol; scrofs:=scrofs+1; ch:=ch+1;
		scr[scrofs]:=ch or txtCol; scrofs:=scrofs+1;
	end;
end;
