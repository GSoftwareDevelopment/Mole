SFX_END	 = $80;

; tablica wskaznikow definicji SFX
sfxlst
				 dta a(sfx_choice)			;0
         dta a(sfx_up)					;1
         dta a(sfx_dn)					;2
        ;  dta a(sfx_anykey)			;3
        ;  dta a(sfx_move)				;4
        ;  dta a(sfx_eat)					;5
        ;  dta a(sfx_hop)					;6
        ;  dta a(sfx_die)					;7
				;  dta a(sfx_blockVanish)	;8
				;  dta a(sfx_break)				;9
; SFX definition

sfx_choice
         dta $00,$a5
         dta $00,$a4
         dta $f5,$a5
         dta $00,$a4
         dta $00,$a3
         dta $00,$a2
         dta $00,$a1
         dta SFX_END
sfx_up
         dta $00,$a5
         dta $f5,$a5
         dta SFX_END
sfx_dn
         dta $00,$a5
         dta $0a,$a5
         dta SFX_END
; sfx_anykey
;          dta $00,$a5
;          dta $04,$a5
;          dta SFX_END
; sfx_move
;          dta $00,$81
;          dta $8a,$83
;          dta SFX_END
; sfx_eat
;          dta $00,$41
;          dta $00,$44
;          dta $00,$47
;          dta SFX_END
; sfx_hop
;          dta $00,$aa
;          dta $00,$a8
;          dta $fe,$a6
;          dta $00,$a4
;          dta $fe,$a2
;          dta $00,$a1
;          dta SFX_END
; sfx_die
;          dta $02,$2a
;          dta $02,$2a
;          dta $02,$29
;          dta $02,$29
;          dta $02,$28
;          dta $02,$28
;          dta $02,$27
;          dta $02,$27
;          dta $02,$26
;          dta $02,$26
;          dta $02,$25
;          dta $02,$24
;          dta $02,$23
;          dta $02,$22
;          dta $02,$21
;          dta SFX_END
; sfx_blockVanish
; 				 dta $02,$88
; 				 dta $02,$87
; 				 dta $02,$86
; 				 dta $02,$85
; 				 dta $02,$84
; 				 dta $02,$83
; 				 dta $02,$82
; 				 dta $02,$81
; 				 dta SFX_END
; sfx_break
; 				 dta $00,$84
; 				 dta $00,$83
; 				 dta $00,$82
; 				 dta $00,$81
; 				 dta SFX_END
