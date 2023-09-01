.ifdef LANG
		opt h-
		org $8000
.endif

_ou = '#'
_ci = '$'
_eu = '%'
_uy = '&'
_ni = ''''
_uu = '('
_si = ')'
_rz = '*'
_rzi= '+'

_EOL = $FF

history_array
		dta 2, 3 ,7
		dta 3, 5 ,3
		dta 4, 5 ,4
		dta 5, 2 ,9

strings_Pointers
			dta a(strings_menu)
			dta a(strings_bests)
			dta a(strings_history_page0)
			dta a(strings_history_page1)
			dta a(strings_history_page2)
			dta a(strings_controls_page3);
			dta a(strings_ready)
			dta a(string_gameover)
			dta a(strings_top_status)
			.print "STRINGS PointerS SIZE: ", *-strings_Pointers

strings_list
strings_menu
			dta d'NOWA GRA',_EOL
			dta d'NAJLEPSI',_EOL
			dta	d'HISTORIA',_EOL
			dta _EOL

strings_bests
			dta d'NAJLEPSI'*,_EOL
			dta d'USTAWENIA'*,_EOL
			dta d'PAMI%$',_EOL
			dta d'DYSKIETKA',_EOL
			dta d'INTERNET',_EOL

strings_history
strings_history_page0
;           01234567890123456789
			dta d'KRET ',d'STEFAN'*,_EOL
			dta d'JEST MA&# NIEZDAR#.',_EOL
			dta _EOL
			dta d'WSZED& DO MAGAZYNU',_EOL
			dta d'PE&NEGO PACZEK',_EOL
			dta d'I NIEOPATRZNIE',_EOL
			dta d'WSZYSTKIE WYWR(CI&.',_EOL
			dta _EOL

strings_history_page1
			dta d'SWOJ#  NIEZDARNO)CI#',_EOL
			dta d'SPRAWIA,*E  WSZYSTKO',_EOL
			dta d'NA NIEGO SPADA.',_EOL
			dta _EOL

strings_history_page2
			dta d'MUSI ZBIERA$ PACZKI',_EOL
			dta d'I UNIKA$ ZGNIECENIA'*,_EOL
			dta d'BY ODNALE+$ WYJ)CIE',_EOL
			dta d'Z PU&APKI.',_EOL
			dta _EOL

strings_controls_page3
; Ą - #  Ć - $  Ę - %  Ł - &  Ń - '  Ó - (  Ś - )  Ż - *  Ź - +
;           01234567890123456789
			dta d'PORUSZANIE KRETEM'*,_EOL
			dta _EOL
			dta d'JOYSTICK',_EOL
			dta d'LEWO'*,d'/',d'PRAWO'*,d' CHODZENIE',_EOL
			dta d'G(RA'*,d' SKOK',_EOL
			dta _EOL
			dta d'KLAWIATURA',_EOL
			dta d'U*YJ STRZA&EK'*,_EOL
			dta d'ESC'*,d' KO''CZY GR%',_EOL
			dta _EOL

strings_ready
			dta d'SZYKUJ SI%',_EOL
			dta d'STEFAN',_EOL
			dta _EOL

string_gameover
			dta d'STEFAN',_EOL
			dta d'PAD&',_EOL

strings_top_status
			dta d'PUNKTY',_EOL
			dta d'POZIOM',_EOL

		.print "STRINGS SIZE: ", *-strings_Pointers
