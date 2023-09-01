; It's always useful to include you program global constants here
		icl 'memory.inc'
		icl 'dlist-const.inc'

; game screen display list

dl_logo
		:9 dta DL_BLANK8
    dta DL_MODE_40x24T5 + DL_LMS, a(LOGO_ADDR)
    :10 dta DL_MODE_40x24T5
    dta DL_JVB, a(dl_logo) ; jump to start

		end
