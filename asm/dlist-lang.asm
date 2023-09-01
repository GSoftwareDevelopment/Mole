; It's always useful to include you program global constants here
		icl 'memory-lang.inc'
		icl 'dlist-const.inc'

; title screen display list

dl_title
		:3 dta DL_BLANK8
    dta DL_MODE_40x24T5 + DL_LMS, a(SCREEN_ADDR)
    :7  dta DL_MODE_40x24T5
    :8  dta DL_MODE_40x24T5 + DL_LMS, a(FLAGS_BEGIN_ADDR+#*FLAGS_LINE_WIDTH)
    dta DL_MODE_40x24T5 + DL_LMS, a(FLAGS_BEGIN_ADDR+8*FLAGS_LINE_WIDTH)
    :7  dta DL_MODE_40x24T5
    dta DL_JVB, a(dl_title) ; jump to start

		end
