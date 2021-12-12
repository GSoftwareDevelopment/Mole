// {$DEFINE SFX_SWITCH_ROM}         // Enables RAM under ROM for SFX engine (on interrupt)
{$DEFINE SFX_previewChannels}    // Enables live viewing of data in channels
{$DEFINE SFX_SYNCAUDIOOUT}       // Enables audio output buffering for better audio synchronization

{$DEFINE USE_MODULATORS}         // Enables the use of modulators
{$DEFINE DFD_MOD}                // Direct Frequency Divider modulator
{$DEFINE LFD_NLM_MOD}            // Low Frequency Divider & Note Level Modulation
{$DEFINE MFD_MOD}                // Middle Frequency Divider modulator
{$DEFINE HFD_MOD}                // High Frequency Divider modulator
// {$DEFINE USE_ALL_MODULATORS}

{$DEFINE SFX_PLAYBACK}           // Enable SONG/TAB playback support

AUDIO_BUFFER_ADDR = $600;
SFX_REGISTERS     = $f0;

SFX_CHANNELS_ADDR = $6C0;

SFX_ORG = $7000;

NOTE_TABLE_PAGE   = hi(SFX_ORG);		// $80
NOTE_TABLE_ADDR		= SFX_ORG;				// $8000

SFX_MODE_SET_ADDR	= SFX_ORG+$100;		// $8100
SFX_NOTE_SET_ADDR = SFX_ORG+$113;		// $8113

SFX_TABLE_ADDR    = SFX_ORG+$126;		// $8126
TAB_TABLE_ADDR    = SFX_ORG+$14c;		// $814c

SONG_ADDR					= SFX_ORG+$18a;		// $818a
SFX_DATA_ADDR			= SFX_ORG+$28a;		// $828a

// SONG_ADDR         = $CB00;                // table of SONG definition
// SFX_MODE_SET_ADDR = $CC00;                // table of SFX modes
// SFX_NOTE_SET_ADDR = $CC80;                // table of SFX note table presets

// NOTE_TABLE_PAGE   = $CD;
// NOTE_TABLE_ADDR   = NOTE_TABLE_PAGE*$100; // = NOTE_TABLE_ADDR                      ; predefined table of note frequency

// SFX_TABLE_ADDR    = $CE00;                // list for SFX definitions
// TAB_TABLE_ADDR    = SFX_TABLE_ADDR+$0080; // list for TAB definitions

// SFX_DATA_ADDR			= $d800;
