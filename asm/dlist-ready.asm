; It's always useful to include you program global constants here
		icl 'memory.inc'
		icl 'dlist-const.inc'

; title screen display list

dl_ready_die
		:7 dta DL_BLANK8

    dta DL_MODE_40x24T5 + DL_LMS, a(SCREEN_ADDR)
    dta DL_MODE_40x24T5
    :5 dta DL_MODE_40x24T5 + DL_DLI
    dta DL_MODE_40x24T5 + DL_DLI

		:2 dta DL_MODE_20x12T5

    dta DL_JVB, a(dl_ready_die) ; jump to start

		end

