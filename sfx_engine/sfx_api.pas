unit SFX_API;

interface
type
  ByteArray=array[0..0] of Byte;
  WordArray=array[0..0] of Word;

const
{$i sfx_engine.conf.inc} // import SFX-Engine configuration

// SFX-Engine Constants

{$i sfx_engine/sfx_engine_const.inc}

var
  SONGData:ByteArray absolute SONG_ADDR;              // table for SONG data
  SFXModMode:ByteArray absolute SFX_MODE_SET_ADDR;    // indicates the type of modulation used in the SFX.
  SFXNoteSetOfs:ByteArray absolute SFX_NOTE_SET_ADDR; //
  SFXPtr:WordArray absolute SFX_TABLE_ADDR;           // heap Pointers to SFX definitions
  TABPtr:WordArray absolute TAB_TABLE_ADDR;           // heap Pointera to TAB definitions

  SONG_Tempo:Byte absolute SFX_REGISTERS+$00;
  SONG_Tick:Byte absolute SFX_REGISTERS+$01;
  SONG_Ofs:Byte absolute SFX_REGISTERS+$02;
  SONG_RepCount:Byte absolute SFX_REGISTERS+$03;

  channels:array[0..0] of Byte absolute SFX_CHANNELS_ADDR;

procedure INIT_SFXEngine(); Assembler;
procedure SFX_StartDLI();
procedure SFX_StartVBL();
procedure SFX_ChannelOff(channel:Byte); Assembler;
procedure SFX_Off(); Assembler;
procedure SFX_Note(channel,note,SFXId:Byte); Assembler;
procedure SFX_Freq(channel,freq,SFXId:Byte); Assembler;
procedure SFX_PlayTAB(channel,TABId:Byte); Assembler;
procedure SFX_PlaySONG(startPos:Byte); Assembler;
procedure SFX_End();

implementation
var
  NMIEN:Byte absolute $D40E;
  oldIntVec:Pointer;
  IntMode:Byte;

procedure INIT_SFXEngine; Assembler;
asm
sfx_engine_start

 .print "SFX-ENGINE START: ", *

  icl 'sfx_engine/sfx_engine.asm'

 .print "SFX-ENGINE SIZE: ", *-sfx_engine_start
end;

procedure SFX_tick_VBL(); Assembler; Interrupt;
asm
xitvbl      = $e462
sysvbv      = $e45c
portb       = $d301

      phr

.ifdef MAIN.@DEFINES.SFX_SWITCH_ROM
.ifdef MAIN.@DEFINES.ROMOFF
      lda portb
      pha
      lda #$FE
      sta portb
.endif
.endif

      jsr INIT_SFXEngine.SFX_MAIN_TICK

.ifdef MAIN.@DEFINES.SFX_SWITCH_ROM
.ifdef MAIN.@DEFINES.ROMOFF
      pla
      sta portb
.endif
.endif

      plr
      jmp xitvbl
end;

procedure SFX_tick_DLI(); Assembler; Interrupt;
asm
portb       = $d301

      phr

.ifdef MAIN.@DEFINES.SFX_SWITCH_ROM
.ifdef MAIN.@DEFINES.ROMOFF
      lda portb
      pha
      lda #$FE
      sta portb
.endif
.endif

      jsr INIT_SFXEngine.SFX_MAIN_TICK

.ifdef MAIN.@DEFINES.SFX_SWITCH_ROM
.ifdef MAIN.@DEFINES.ROMOFF
      pla
      sta portb
.endif
.endif

      plr
      rti
end;

procedure SFX_StartDLI;
begin
	INIT_SFXEngine();
	NMIEN:=%00000000;
	IntMode:=iDLI;
	GetIntVec(iDLI, oldIntVec);
	SetIntVec(iDLI, @SFX_tick_DLI);
	NMIEN:=%11000000;
end;

procedure SFX_StartVBL;
begin
	INIT_SFXEngine();
	NMIEN:=%00000000;
	IntMode:=iVBL;
	GetIntVec(iVBL, oldIntVec);
	SetIntVec(iVBL, @SFX_tick_VBL);
	NMIEN:=%01000000;
end;

procedure SFX_ChannelOff; Assembler;
asm
			asl @
			asl @
			asl @
			asl @
			tax
			clc
			jsr INIT_SFXEngine.SFX_OFF_CHANNEL
end;

procedure SFX_Off; Assembler;
asm
			jsr INIT_SFXEngine.SFX_OFF_ALL
end;

procedure SFX_Note; Assembler;
asm
			lda channel
			asl @
			asl @
			asl @
			asl @
			tax
			ldy SFXId
			lda note
			clc         ; accu has note index
			jsr INIT_SFXEngine.SFX_PLAY_NOTE
end;

procedure SFX_Freq; Assembler;
asm
			lda channel
			asl @
			asl @
			asl @
			asl @
			tax
			ldy SFXId
			lda freq
			sec         ; accu has frequency value
			jsr INIT_SFXEngine.SFX_PLAY_NOTE
end;

procedure SFX_PlayTab; Assembler;
asm
			lda #$FF
			sta SONG_Tick

			lda channel
			asl @
			asl @
			asl @
			asl @
			tax
			lda TABId

			jsr INIT_SFXEngine.SFX_PLAY_TAB

			lda #$00
			sta SONG_Tick
end;

procedure SFX_PlaySONG; Assembler;
asm
			tay
			jsr INIT_SFXEngine.SFX_PLAY_SONG
end;

procedure SFX_End;
begin
	SFX_Off();
	if oldIntVec<>nil then
	begin
		NMIEN:=%00000000;
		Case IntMode of
			iDLI: SetIntVec(iDLI, oldIntVec);
			iVBL: SetIntVec(iVBL, oldIntVec);
		end;
		NMIEN:=%01000000;
		oldIntVec:=nil;
	end;
end;

end.
