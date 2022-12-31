// {$DEFINE SFX_SWITCH_ROM} // uncomment this line if you want use RAM under ROM for data
// {$DEFINE SFX_SYNCAUDIOOUT} // this switch turn on buffer for POKEY data. Buffer is flush after processing all channels.
{$DEFINE USE_MODULATORS}
{$DEFINE LFD_NLM_MOD}
{$DEFINE HFD_MOD}
{$DEFINE SFX_PLAYBACK} // if you want use song player, leave this definition uncomment

// AUDIO_BUFFER_ADDR = $0000;
SFX_REGISTERS     = $F0;
SFX_CHANNELS_ADDR = $06C0;
SFX_ORG           = $7000;
NOTE_TABLE_ADDR   = SFX_ORG + $0000;
NOTE_TABLE_PAGE   = hi(NOTE_TABLE_ADDR);
SONG_ADDR         = SFX_ORG + $0100;
SFX_MODE_SET_ADDR = SFX_ORG + $0200;
SFX_NOTE_SET_ADDR = SFX_ORG + $0213;
SFX_TABLE_ADDR    = SFX_ORG + $0226;
TAB_TABLE_ADDR    = SFX_ORG + $024C;
SFX_DATA_ADDR     = SFX_ORG + $028A;
