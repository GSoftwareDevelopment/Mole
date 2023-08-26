;; --- Start MIDI Module
; MIDI plays only for NOTES!

_temp = $dc
_regA =	$dd
_regX = $de
_regY = $df

	sta _regA	; note_index
	stx _regX	; player channel offset

	tya			; restore SFX number
	lsr @
	tay
	sty _regY

	lda	MIDI_SFX2CHANNEL_ADDR,y		; get MIDI channel for SFX#
	bpl make_midi
  clc
  jmp MIDI_end

make_midi:
	tax	; x = SFX MIDI Channel

; !!! before play new note, turn off old!
; send MIDI Event NOTE OFF on channel X
; $80+X ...
  stx _temp
  lda MIDI_CHANNELS_ADDR+32,x
  spl:jmp new_note
  tax
  lda	MIDI_SFX2CHANNEL_ADDR,x
	add #$80
	jsr $2006

; send note
; {note} ...
  ldx _temp
	lda MIDI_CHANNELS_ADDR+16,x
	jsr $2006

; send velocity
; {velocity}
	lda #$00
	jsr $2006

new_note:
	ldy _regY
	cpx #9
	beq MIDIInstrNoChange

	lda MIDI_SFX2INSTR_ADDR,y
	cmp MIDI_CHANNELS_ADDR,x		// change MIDI Instrument?
	beq MIDIInstrNoChange
	sta MIDI_CHANNELS_ADDR,x		// stroe new MIDI Instrument for new MIDI channel
  sta _temp
  tya
  sta MIDI_CHANNELS_ADDR+32,x // store new SFX# for new MIDI channel

; send MIDI Event only when channel (X) is not equal 10 (Percusion channel)
; $B0+X $20 {LSB_bank}  - LSB bank select for channel X
	txa
	add #$B0
	jsr $2006
	lda #$20
	jsr $2006
	lda #$00
	jsr $2006

; $B0+X $00 {MSB_bank}	- MSB bank select for channel X
	txa
	add #$B0
	jsr $2006
	lda #$00
	jsr $2006
	jsr $2006

; $C0+X {program}				- Program change for channel X
	txa
	add #$C0
	jsr $2006
	lda _temp
	jsr $2006

MIDIInstrNoChange:
; send MIDI Event NOTE ON on channel X
; $90+X ...
	txa
	add #$90
	jsr $2006

; send note
	ldy _regY
; get SFX octave shift
	cpx #9 ; percusion channel!
	beq MIDI_get_note_for_percusion_on
	lda _regA
	clc
	adc MIDI_SFX2OCTAVESH_ADDR,y
	sta MIDI_CHANNELS_ADDR+16,x
	bcc MIDI_send_note_on

MIDI_get_note_for_percusion_on:
	lda MIDI_SFX2INSTR_ADDR,y
	sta MIDI_CHANNELS_ADDR+16,x

MIDI_send_note_on:
	jsr $2006

; send velocity
	ldy _regY
	lda MIDI_SFX2VELOCITY_ADDR,y
	jsr $2006

  sec
MIDI_end:
	lda _regA
	ldx _regX

;; --- end MIDI Module
