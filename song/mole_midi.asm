sfx2channel
  .by $02 ; #1  Key Clean Long
  .by $02 ; #2  Key Clean Echo
  .by $02 ; #3  0c Long
  .by $02 ; #5  Key Oct Long
  .by $04 ; #7  C-major
  .by $04 ; #8  C-minor

  .by $09 ; #9  Kick
  .by $09 ; #10 Snare

  .by $06 ; #16 Bass1

  .by $ff $ff $ff $ff $ff $ff $ff
  .by $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff
  .by $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff
  .by $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff

sfx2instr
  .by 83
  .by 83
  .by 12  ; MArimba
  .by 23  ; Bandeoneon
  .by 51  ; Strings
  .by 51  ; Strings

  .by 036 ; kick  - percusion note
  .by 038 ; $26 snare - percusion note

  .by 34 ;  Picked Bass

  .by $ff $ff $ff $ff $ff $ff $ff
  .by $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff
  .by $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff
  .by $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff

sfx2octave_shift
  .by 4*12 ; #1  Key Clean Long
  .by 4*12 ; #2  Key Clean Echo
  .by 5*12 ; #3  0c Long
  .by 4*12 ; #5  Key Oct Long
  .by 4*12 ; #7  C-major
  .by 4*12 ; #8  C-minor
  .by $ff  ; #9  Kick
  .by $ff  ; #10 Snare
  .by 1*12 ; #16 Bass1
  .by $ff $ff $ff $ff $ff $ff $ff
  .by $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff
  .by $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff
  .by $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff

sfx2velocity
  .by 100
  .by 100
  .by 127  ; MArimba
  .by 127 ; Bandeoneon
  .by 80  ; Strings
  .by 80  ; Strings

  .by 100 ; kick  - percusion note
  .by 100 ; $26 snare - percusion note

  .by 80 ;  Picked Bass

  .by $ff $ff $ff $ff $ff $ff $ff
  .by $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff
  .by $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff
  .by $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff