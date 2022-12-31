;	org $7000	; ----------------------------------------

; block address: $7000 length: $0100

note_tables
	.by $F3 $E6 $D9 $CC $C1 $B5 $AD $A2 $99 $90 $88 $80 $79 $72 $6C $66 
	.by $60 $5B $55 $51 $4C $48 $44 $40 $3C $39 $35 $32 $2F $2D $2A $28 
	.by $25 $23 $21 $1F $1D $1C $1A $18 $17 $16 $14 $13 $12 $11 $10 $0F 
	.by $0E $0D $0C $0B $0A $09 $08 $07 $06 $05 $04 $03 $02 $01 $00 $00 
	.by $BF $B6 $AA $A1 $98 $8F $89 $80 $F2 $E6 $DA $CE $BF $B6 $AA $A1 
	.by $98 $8F $89 $80 $7A $71 $6B $65 $5F $5C $56 $50 $4D $47 $44 $3E 
	.by $3C $38 $35 $32 $2F $2D $2A $28 $25 $23 $21 $1F $1D $1C $1A $18 
	.by $17 $16 $14 $13 $12 $11 $10 $0F $0E $0D $0C $0B $0A $09 $08 $07 
	.by $FF $F1 $E4 $D8 $CA $C0 $B5 $AB $A2 $99 $8E $87 $7F $79 $73 $70 
	.by $66 $61 $5A $55 $52 $4B $48 $43 $3F $3C $39 $37 $33 $30 $2D $2A 
	.by $28 $25 $24 $21 $1F $1E $1C $1B $19 $17 $16 $15 $13 $12 $11 $10 
	.by $0F $0E $0D $0C $0B $0A $09 $08 $07 $06 $05 $04 $03 $02 $01 $00 
	.by $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
	.by $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
	.by $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
	.by $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 

;	org $7100	; ----------------------------------------

; block address: $7100 length: $0100

song
	.by $80 $05 $40 $40 $00 $7F $08 $11 $04 $40 $08 $12 $03 $40 $08 $13 
	.by $06 $40 $15 $14 $00 $09 $08 $11 $04 $0A $08 $12 $03 $0B $08 $13 
	.by $06 $0C $15 $14 $00 $0D $08 $11 $04 $0E $08 $12 $03 $0F $08 $13 
	.by $06 $10 $15 $14 $84 $01 $05 $40 $00 $01 $08 $11 $04 $02 $08 $12 
	.by $03 $05 $08 $13 $06 $07 $15 $14 $84 $01 $0E $40 $82 $05 $40 $40 
	.by $80 $04 $40 $40 $16 $17 $1A $40 $FF $40 $40 $40 $80 $06 $40 $40 
	.by $18 $19 $40 $40 $FF $40 $40 $40 $80 $05 $40 $40 $1B $1C $1D $40 
	.by $82 $00 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 
	.by $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 
	.by $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 
	.by $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 
	.by $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 
	.by $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 
	.by $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 
	.by $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 
	.by $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $40 $1E $40 $40 $40 

;	org $7200	; ----------------------------------------

; block address: $7200 length: $0013

sfx_modes
	.by $02 $02 $02 $02 $02 $02 $02 $02 $02 $00 $00 $00 $00 $00 $00 $00 
	.by $00 $00 $00 

;	org $7213	; ----------------------------------------

; block address: $7213 length: $0013

sfx_note
	.by $00 $00 $00 $00 $00 $00 $00 $00 $80 $00 $00 $00 $00 $00 $00 $00 
	.by $00 $00 $00 

;	org $7226	; ----------------------------------------

; block address: $7226 length: $0013

sfxptr
	dta a(data_sfx_0) ; offset in data 0000 optimized 1=>0
	dta a(data_sfx_1) ; offset in data 0014 optimized 2=>1
	dta a(data_sfx_2) ; offset in data 0022 optimized 3=>2
	dta a(data_sfx_3) ; offset in data 0062 optimized 5=>3
	dta a(data_sfx_4) ; offset in data 00A0 optimized 7=>4
	dta a(data_sfx_5) ; offset in data 00C4 optimized 8=>5
	dta a(data_sfx_6) ; offset in data 00E8 optimized 9=>6
	dta a(data_sfx_7) ; offset in data 00FE optimized 10=>7
	dta a(data_sfx_8) ; offset in data 0120 optimized 16=>8
	dta a(data_sfx_9) ; offset in data 0140 optimized 54=>9
	dta a(data_sfx_10) ; offset in data 014C optimized 55=>10
	dta a(data_sfx_11) ; offset in data 015C optimized 56=>11
	dta a(data_sfx_12) ; offset in data 0178 optimized 57=>12
	dta a(data_sfx_13) ; offset in data 01CC optimized 58=>13
	dta a(data_sfx_14) ; offset in data 01F0 optimized 59=>14
	dta a(data_sfx_15) ; offset in data 0204 optimized 60=>15
	dta a(data_sfx_16) ; offset in data 0224 optimized 61=>16
	dta a(data_sfx_17) ; offset in data 0230 optimized 62=>17
	dta a(data_sfx_18) ; offset in data 023C optimized 63=>18

;	org $724C	; ----------------------------------------

; block address: $724C length: $001F

tabptr
	dta a(data_tab_0) ; offset in data 0248 optimized 1=>0
	dta a(data_tab_1) ; offset in data 026A optimized 2=>1
	dta a(data_tab_2) ; offset in data 028C optimized 3=>2
	dta a(data_tab_3) ; offset in data 02AE optimized 4=>3
	dta a(data_tab_4) ; offset in data 02D0 optimized 5=>4
	dta a(data_tab_5) ; offset in data 02F2 optimized 6=>5
	dta a(data_tab_6) ; offset in data 0314 optimized 7=>6
	dta a(data_tab_7) ; offset in data 0336 optimized 8=>7
	dta a(data_tab_8) ; offset in data 0358 optimized 10=>8
	dta a(data_tab_9) ; offset in data 037A optimized 11=>9
	dta a(data_tab_10) ; offset in data 039C optimized 12=>10
	dta a(data_tab_11) ; offset in data 03BE optimized 13=>11
	dta a(data_tab_12) ; offset in data 03E0 optimized 14=>12
	dta a(data_tab_13) ; offset in data 0402 optimized 15=>13
	dta a(data_tab_14) ; offset in data 0424 optimized 16=>14
	dta a(data_tab_15) ; offset in data 0446 optimized 17=>15
	dta a(data_tab_16) ; offset in data 0468 optimized 18=>16
	dta a(data_tab_17) ; offset in data 048A optimized 21=>17
	dta a(data_tab_18) ; offset in data 04AC optimized 22=>18
	dta a(data_tab_19) ; offset in data 04CE optimized 23=>19
	dta a(data_tab_20) ; offset in data 04F0 optimized 24=>20
	dta a(data_tab_21) ; offset in data 0512 optimized 30=>21
	dta a(data_tab_22) ; offset in data 0534 optimized 31=>22
	dta a(data_tab_23) ; offset in data 0586 optimized 32=>23
	dta a(data_tab_24) ; offset in data 05D8 optimized 33=>24
	dta a(data_tab_25) ; offset in data 062A optimized 34=>25
	dta a(data_tab_26) ; offset in data 067C optimized 35=>26
	dta a(data_tab_27) ; offset in data 06CE optimized 37=>27
	dta a(data_tab_28) ; offset in data 0700 optimized 38=>28
	dta a(data_tab_29) ; offset in data 0732 optimized 39=>29
	dta a(data_tab_30) ; offset in data 075C optimized 63=>30

;	org $728A	; ----------------------------------------

; block address: $728A length: $0772

data

; address: $728A (offset: $0000)
data_sfx_0 ; KEY CLEAN LONG
	.by $7C $A6 $00 $A5 $00 $A4 $01 $A3 $00 $A3 $00 $A3 $3F $A3 $00 $A3 
	.by $00 $A3 $83 $00 

; address: $729E (offset: $0014)
data_sfx_1 ; KEY CLEAN ECHO
	.by $7C $A6 $00 $A5 $00 $A4 $00 $A3 $00 $A2 $00 $A1 $80 $00 

; address: $72AC (offset: $0022)
data_sfx_2 ; 0C LONG
	.by $7C $AC $00 $AA $4C $A8 $00 $A6 $74 $A5 $00 $A4 $4C $A4 $00 $A4 
	.by $74 $A4 $00 $A4 $4C $A4 $00 $A4 $74 $A4 $00 $A4 $4C $A4 $00 $A4 
	.by $74 $A3 $00 $A3 $4C $A3 $00 $A3 $74 $A3 $00 $A3 $4C $A3 $00 $A3 
	.by $74 $A2 $00 $A2 $4C $A2 $00 $A2 $74 $A2 $00 $A2 $00 $00 $80 $00 

; address: $72EC (offset: $0062)
data_sfx_3 ; KEY OCT LONG
	.by $48 $AC $74 $AA $00 $A8 $00 $A6 $00 $A5 $00 $A4 $00 $A4 $00 $A4 
	.by $00 $A4 $00 $A4 $00 $A3 $00 $A3 $00 $A3 $00 $A3 $00 $A3 $00 $A3 
	.by $00 $A2 $00 $A2 $00 $A2 $00 $A2 $00 $A2 $00 $A2 $01 $A2 $00 $A2 
	.by $00 $A2 $3F $A2 $00 $A2 $00 $A2 $00 $A2 $00 $A2 $95 $00 

; address: $732A (offset: $00A0)
data_sfx_4 ; C-MAJOR
	.by $7C $A9 $44 $A8 $43 $A7 $79 $A6 $44 $A5 $43 $A4 $79 $A3 $44 $A3 
	.by $43 $A3 $79 $A3 $44 $A3 $43 $A3 $79 $A3 $44 $A2 $43 $A2 $79 $A2 
	.by $00 $00 $80 $00 

; address: $734E (offset: $00C4)
data_sfx_5 ; C-MINOR
	.by $7C $A9 $43 $A8 $44 $A7 $79 $A6 $43 $A5 $44 $A4 $79 $A3 $43 $A3 
	.by $44 $A3 $79 $A3 $43 $A3 $44 $A3 $79 $A3 $43 $A2 $44 $A2 $79 $A2 
	.by $00 $00 $80 $00 

; address: $7372 (offset: $00E8)
data_sfx_6 ; KICK
	.by $00 $18 $D0 $9A $E0 $97 $E0 $97 $F0 $94 $F0 $13 $03 $12 $03 $11 
	.by $03 $11 $00 $00 $80 $00 

; address: $7388 (offset: $00FE)
data_sfx_7 ; SNARE
	.by $00 $18 $90 $BB $A0 $BB $01 $98 $E0 $B9 $01 $97 $01 $96 $01 $95 
	.by $01 $94 $00 $94 $00 $92 $00 $92 $00 $92 $00 $92 $00 $11 $00 $00 
	.by $80 $00 

; address: $73AA (offset: $0120)
data_sfx_8 ; BASS1
	.by $7C $C4 $00 $C3 $00 $C3 $00 $C3 $00 $C3 $00 $C3 $00 $C3 $00 $C3 
	.by $00 $C2 $00 $C2 $00 $C1 $00 $C1 $00 $C1 $00 $C1 $00 $C1 $80 $00 

; address: $73CA (offset: $0140)
data_sfx_9 ; MOLE MOVE
	.by $00 $81 $00 $81 $00 $82 $00 $83 $00 $00 $80 $00 

; address: $73D6 (offset: $014C)
data_sfx_10 ; MOLE EAT BLOCK
	.by $00 $41 $00 $41 $00 $44 $00 $44 $00 $47 $00 $47 $00 $00 $80 $00 

; address: $73E6 (offset: $015C)
data_sfx_11 ; MOLE HOP
	.by $00 $AA $00 $AA $FE $A8 $00 $A8 $FE $A6 $00 $A6 $FE $A4 $00 $A4 
	.by $FE $A2 $00 $A2 $FE $A1 $00 $A1 $00 $00 $80 $00 

; address: $7402 (offset: $0178)
data_sfx_12 ; MOLE DIE
	.by $02 $2A $00 $2A $02 $2A $00 $2A $02 $29 $00 $29 $02 $29 $00 $29 
	.by $02 $28 $00 $28 $02 $28 $00 $28 $02 $27 $00 $27 $02 $27 $00 $27 
	.by $02 $26 $00 $26 $02 $26 $00 $26 $02 $25 $00 $25 $02 $25 $00 $25 
	.by $02 $24 $00 $24 $02 $24 $00 $24 $02 $23 $00 $23 $02 $23 $00 $23 
	.by $02 $22 $00 $22 $02 $22 $00 $22 $02 $21 $00 $21 $02 $21 $00 $21 
	.by $00 $00 $80 $00 

; address: $7456 (offset: $01CC)
data_sfx_13 ; BLOCK VANISH
	.by $02 $88 $00 $88 $02 $87 $00 $87 $02 $86 $00 $86 $02 $85 $00 $85 
	.by $02 $84 $00 $84 $02 $83 $00 $83 $02 $82 $00 $82 $02 $81 $00 $81 
	.by $00 $00 $80 $00 

; address: $747A (offset: $01F0)
data_sfx_14 ; BLOCK BREAK
	.by $00 $84 $00 $84 $00 $83 $00 $83 $00 $82 $00 $82 $00 $81 $00 $81 
	.by $00 $00 $80 $00 

; address: $748E (offset: $0204)
data_sfx_15 ; CHOICE
	.by $00 $A5 $00 $A5 $00 $A4 $00 $A4 $F5 $A5 $00 $A5 $00 $A4 $00 $A4 
	.by $00 $A3 $00 $A3 $00 $A2 $00 $A2 $00 $A1 $00 $A1 $00 $00 $80 $00 

; address: $74AE (offset: $0224)
data_sfx_16 ; SELECT UP
	.by $00 $A5 $00 $A5 $F5 $A5 $00 $A5 $00 $00 $80 $00 

; address: $74BA (offset: $0230)
data_sfx_17 ; SELECT DOWN
	.by $00 $A5 $00 $A5 $0B $A5 $00 $A5 $00 $00 $80 $00 

; address: $74C6 (offset: $023C)
data_sfx_18 ; ANY KEY
	.by $00 $A5 $00 $A5 $05 $A5 $00 $A5 $00 $00 $80 $00 

; address: $74D2 (offset: $0248)
data_tab_0 ; - FREE -
	.by $13 $04 $00 $C0 $00 $C0 $00 $C0 $13 $04 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $13 $04 $00 $C0 $00 $C0 $13 $04 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $74F4 (offset: $026A)
data_tab_1 ; - FREE -
	.by $1A $03 $00 $C0 $00 $C0 $00 $C0 $1F $03 $00 $C0 $1F $03 $00 $C0 
	.by $1A $03 $00 $C0 $00 $C0 $00 $C0 $1F $03 $00 $C0 $1C $03 $00 $C0 
	.by $FF $FF 

; address: $7516 (offset: $028C)
data_tab_2 ; - FREE -
	.by $00 $C0 $00 $C0 $1F $03 $00 $C0 $00 $C0 $00 $C0 $1F $03 $00 $C0 
	.by $23 $03 $00 $C0 $21 $03 $00 $C0 $1F $03 $00 $C0 $1E $03 $00 $C0 
	.by $FF $FF 

; address: $7538 (offset: $02AE)
data_tab_3 ; - FREE -
	.by $18 $04 $00 $C0 $00 $C0 $00 $C0 $18 $04 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $18 $04 $00 $C0 $00 $C0 $18 $04 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $755A (offset: $02D0)
data_tab_4 ; - FREE -
	.by $10 $05 $00 $C0 $00 $C0 $00 $C0 $10 $05 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $10 $05 $00 $C0 $00 $C0 $10 $05 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $757C (offset: $02F2)
data_tab_5 ; - FREE -
	.by $1C $03 $00 $C0 $00 $C0 $00 $C0 $1F $03 $00 $C0 $1F $03 $00 $C0 
	.by $1C $03 $00 $C0 $00 $C0 $00 $C0 $23 $03 $00 $C0 $23 $03 $00 $C0 
	.by $FF $FF 

; address: $759E (offset: $0314)
data_tab_6 ; - FREE -
	.by $1A $04 $00 $C0 $00 $C0 $00 $C0 $1A $04 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $1A $04 $00 $C0 $00 $C0 $1A $04 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $75C0 (offset: $0336)
data_tab_7 ; - FREE -
	.by $00 $C0 $00 $C0 $21 $03 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $75E2 (offset: $0358)
data_tab_8 ; - FREE -
	.by $02 $06 $00 $C0 $00 $C0 $00 $C0 $02 $07 $00 $C0 $00 $C0 $00 $C0 
	.by $02 $06 $00 $C0 $00 $06 $00 $C0 $02 $07 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $7604 (offset: $037A)
data_tab_9 ; - FREE -
	.by $0E $02 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $00 $C0 $00 $C0 $00 $C0 $0E $02 $00 $C0 $0E $02 $00 $C0 
	.by $FF $FF 

; address: $7626 (offset: $039C)
data_tab_10 ; - FREE -
	.by $00 $C0 $00 $C0 $10 $02 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $7648 (offset: $03BE)
data_tab_11 ; - FREE -
	.by $17 $02 $00 $C0 $00 $C0 $00 $C0 $15 $02 $00 $C0 $00 $C0 $00 $C0 
	.by $13 $02 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $15 $02 $00 $C0 
	.by $FF $FF 

; address: $766A (offset: $03E0)
data_tab_12 ; - FREE -
	.by $0E $02 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $768C (offset: $0402)
data_tab_13 ; - FREE -
	.by $17 $02 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $17 $02 $00 $C0 $17 $02 $00 $C0 $17 $02 $00 $C0 $17 $02 $00 $C0 
	.by $FF $FF 

; address: $76AE (offset: $0424)
data_tab_14 ; - FREE -
	.by $00 $C0 $00 $C0 $13 $02 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $13 $02 $00 $C0 
	.by $FF $FF 

; address: $76D0 (offset: $0446)
data_tab_15 ; - FREE -
	.by $18 $02 $00 $C0 $00 $C0 $00 $C0 $17 $02 $00 $C0 $00 $C0 $00 $C0 
	.by $15 $02 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $17 $02 $00 $C0 
	.by $FF $FF 

; address: $76F2 (offset: $0468)
data_tab_16 ; - FREE -
	.by $15 $02 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $7714 (offset: $048A)
data_tab_17 ; - FREE -
	.by $13 $08 $00 $C0 $13 $08 $1F $08 $13 $08 $00 $C0 $1F $08 $00 $C0 
	.by $13 $08 $00 $C0 $1F $08 $00 $C0 $13 $08 $00 $C0 $1F $08 $00 $C0 
	.by $FF $FF 

; address: $7736 (offset: $04AC)
data_tab_18 ; - FREE -
	.by $10 $08 $00 $C0 $10 $08 $1C $08 $10 $08 $00 $C0 $1C $08 $00 $C0 
	.by $10 $08 $00 $C0 $1C $08 $00 $C0 $10 $08 $00 $C0 $10 $08 $1C $08 
	.by $FF $FF 

; address: $7758 (offset: $04CE)
data_tab_19 ; - FREE -
	.by $18 $08 $00 $C0 $18 $08 $24 $08 $18 $08 $00 $C0 $24 $08 $00 $C0 
	.by $18 $08 $00 $C0 $24 $08 $00 $C0 $18 $08 $00 $C0 $24 $08 $00 $C0 
	.by $FF $FF 

; address: $777A (offset: $04F0)
data_tab_20 ; - FREE -
	.by $1A $08 $00 $C0 $1A $08 $26 $08 $1A $08 $00 $C0 $26 $08 $00 $C0 
	.by $1A $08 $00 $C0 $26 $08 $00 $C0 $1A $08 $00 $C0 $1A $08 $26 $08 
	.by $FF $FF 

; address: $779C (offset: $0512)
data_tab_21 ; - FREE -
	.by $0C $06 $00 $C0 $00 $C0 $00 $C0 $02 $07 $00 $C0 $00 $C0 $00 $C0 
	.by $0C $06 $00 $C0 $0E $06 $00 $C0 $02 $07 $00 $C0 $02 $07 $02 $07 
	.by $FF $FF 

; address: $77BE (offset: $0534)
data_tab_22 ; - FREE -
	.by $18 $00 $00 $C0 $1A $00 $00 $C0 $1C $00 $00 $C0 $1D $00 $00 $C0 
	.by $1F $00 $00 $C0 $80 $C0 $00 $C0 $1D $00 $00 $C0 $1F $00 $00 $C0 
	.by $1C $00 $00 $C0 $1F $00 $00 $C0 $1A $00 $00 $C0 $1F $00 $00 $C0 
	.by $18 $00 $00 $C0 $80 $C0 $00 $C0 $0C $02 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $7810 (offset: $0586)
data_tab_23 ; - FREE -
	.by $18 $08 $00 $C0 $18 $08 $00 $C0 $24 $08 $00 $C0 $18 $08 $00 $C0 
	.by $1F $08 $00 $C0 $1F $08 $00 $C0 $2B $08 $00 $C0 $1F $08 $00 $C0 
	.by $1C $08 $00 $C0 $1C $08 $00 $C0 $28 $08 $00 $C0 $1C $08 $00 $C0 
	.by $18 $08 $00 $C0 $18 $08 $00 $C0 $18 $08 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $00 $C0 $80 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $7862 (offset: $05D8)
data_tab_24 ; - FREE -
	.by $18 $01 $00 $C0 $00 $C0 $00 $C0 $18 $01 $00 $C0 $00 $C0 $18 $01 
	.by $18 $01 $00 $C0 $00 $C0 $00 $C0 $1B $01 $00 $C0 $00 $C0 $1A $01 
	.by $1A $01 $00 $C0 $18 $01 $00 $C0 $18 $01 $00 $C0 $17 $01 $00 $C0 
	.by $18 $01 $00 $C0 $00 $C0 $00 $C0 $24 $08 $00 $C0 $00 $C0 $00 $C0 
	.by $80 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $78B4 (offset: $062A)
data_tab_25 ; - FREE -
	.by $18 $08 $24 $08 $18 $08 $24 $08 $13 $08 $1F $08 $13 $08 $1F $08 
	.by $18 $08 $24 $08 $18 $08 $24 $08 $17 $08 $23 $08 $17 $08 $23 $08 
	.by $18 $08 $24 $08 $18 $08 $24 $08 $13 $08 $1F $08 $13 $08 $1F $08 
	.by $18 $08 $24 $08 $17 $08 $23 $08 $18 $08 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $7906 (offset: $067C)
data_tab_26 ; - FREE -
	.by $0C $06 $00 $C0 $00 $C0 $00 $C0 $0C $07 $00 $C0 $00 $C0 $00 $C0 
	.by $0C $06 $00 $C0 $00 $C0 $00 $C0 $0C $07 $00 $C0 $00 $C0 $00 $C0 
	.by $0C $06 $00 $C0 $00 $C0 $00 $C0 $0C $07 $00 $C0 $00 $C0 $00 $C0 
	.by $0C $06 $00 $C0 $0C $07 $0C $07 $0C $07 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $7958 (offset: $06CE)
data_tab_27 ; - FREE -
	.by $07 $00 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $80 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $798A (offset: $0700)
data_tab_28 ; - FREE -
	.by $00 $C0 $00 $C0 $00 $C0 $00 $C0 $11 $00 $00 $C0 $00 $C0 $00 $C0 
	.by $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $80 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $FF $FF 

; address: $79BC (offset: $0732)
data_tab_29 ; - FREE -
	.by $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 
	.by $13 $00 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $00 $C0 $0C $06 $0C $06 
	.by $0C $07 $00 $C0 $00 $C0 $00 $C0 $FF $FF 

; address: $79E6 (offset: $075C)
data_tab_30 ; - FREE -
	.by $18 $09 $1A $0A $1C $0B $1D $0C $1F $0D $21 $0E $23 $0F $24 $10 
	.by $26 $11 $28 $12 $FF $FF 
