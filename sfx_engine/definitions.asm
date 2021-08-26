audf        = $d200
audc        = $d201
audctl      = $D208
skctl       = $D20F

; CONSTANTS - offsets in channels registers table

            icl 'sfx_engine_const.inc'

; VARIABLES - PAGE ZERO
.ifdef MAIN.@DEFINES.SFX_SYNCAUDIOOUT
AUDIOBUF          = AUDIO_BUFFER_ADDR      ; 8 bytes audio buffer for sync output
.endif

SONG_TEMPO        = SFX_REGISTERS+$0      ; SONG Tempo
SONG_TICK_COUNTER = SFX_REGISTERS+$1      ; SONG tick counter
SONG_Ofs          = SFX_REGISTERS+$2      ;
SONG_Rep          = SFX_REGISTERS+$3      ;

dataPtr           = SFX_REGISTERS+$4      ; SFX or TAB data pointer (2 bytes)

TABOrder          = SFX_REGISTERS+$7      ; TAB Order
TABParam          = SFX_REGISTERS+$8      ; TAB Parameter (Note/Freq/Position)

sfxNoteOfs        = SFX_REGISTERS+$6      ; SFX Note Table offset (1 byte)
chnNote           = SFX_REGISTERS+$7      ; SFX Note
chnFreq           = SFX_REGISTERS+$8      ; SFX Frequency

chnMode           = SFX_REGISTERS+$9      ; SFX Modulation Mode
chnModVal         = SFX_REGISTERS+$A      ; SFX Modulator
chnCtrl           = SFX_REGISTERS+$B      ; SFX Control (distortion & volume)

_regTemp          = SFX_REGISTERS+$C


; CONSTANTS

SFX_OFF           = $FF
TAB_OFF           = $FF

FN_NOTE_FREQ      = $40

MODFN_SFX_STOP    = $80
MODFN_LFD_FREQ    = $20
MODFN_NLM_NOTE    = $40
MODFN_MFD_FREQ    = $40

MODMODE_DFD       = 3
MODMODE_LFD_NVM   = 2
MODMODE_MFD       = 1
MODMODE_HFD       = 0
MODMODE_RELATIVE  = %1000

trkBlank          = %01000000 // blank (No operation)
trkOff            = %01111111
trkOrd_SetTempo   = %10000000
trkOrd_JumpTo     = %10000010
trkOrd_Repeat     = %10000100
trkOrd_EndSong    = %11111111
