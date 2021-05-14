; It's always useful to include you program global constants here
		icl 'memory.inc'
		icl 'dlist-const.inc'

; title screen display list

dl_title
		dta DL_BLANK8
    dta DL_BLANK4 + DL_DLI
    dta DL_MODE_40x24T5 + DL_LMS, a(SCREEN_ADDR)
    :13 dta DL_MODE_40x24T5
    dta DL_BLANK4 + DL_DLI
    :5 dta DL_MODE_20x12T5
    dta DL_BLANK4 + DL_DLI
    dta DL_MODE_20x12T5 + DL_HSCROLL
    dta DL_JVB, a(dl_title) ; jump to start

		end
