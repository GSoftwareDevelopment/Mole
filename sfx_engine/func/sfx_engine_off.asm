; disable all playback (SFX/TAB/SONG)
;
; no input

	lda #$FF
	sta SONG_Ofs            ;  prevent SONG processing
	lda #$80
	sta SONG_TICK_COUNTER   ;  prevent playback processing
;
;
;
; subroutine for reset all tracks

reset_all_tracks

; MIDI Reset
	tya:pha
	lda #$FF
	jsr $2006
	pla:tay

	ldx #48
	lda #0
clear_MIDI_CHANNELS:
	sta MIDI_CHANNELS_ADDR-1,X
	dex
	bpl clear_MIDI_CHANNELS

; POKEY Reset
	ldx #$30

reset_TRACKS
	sec
	jsr SFX_OFF_CHANNEL

	txa                                 ; change current channel
	sec
	sbc #$10
	tax
	bpl reset_TRACKS

	rts
