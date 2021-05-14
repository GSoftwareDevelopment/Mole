; It's always useful to include you program global constants here
		icl 'memory.inc'
		icl 'dlist-const.inc'

; game screen display list

dl_game
		dta DL_BLANK8
    dta DL_BLANK8 + DL_DLI
    dta DL_MODE_20x24T5 + DL_LMS, a(SCREEN_ADDR)		; game status bar (score,blocks,level)
    dta DL_MODE_20X24T5
    dta DL_BLANK4 + DL_DLI
    dta DL_MODE_20x12T5 + DL_LMS, a(SCREEN_ADDR+80) ; 10 lines of game filed (2 lines are hidden)
    :9 dta DL_MODE_20x12T5
    dta DL_BLANK4
    dta DL_BLANK4 + DL_DLI
    :2 dta DL_MODE_40x24T5													; 2 lines of level progress
    dta DL_JVB, a(dl_game) ; jump to start

		end
