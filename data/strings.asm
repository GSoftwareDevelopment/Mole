strings_pointers
			dta a(strings_menu)
			dta a(strings_bests)
			dta a(strings_history_page0)
			dta a(strings_history_page1)
			dta a(strings_history_page2)
			dta a(strings_controls_page3);
			dta a(strings_ready)
			dta a(string_gameover)
			dta a(strings_top_status)
			.print "STRINGS POINTERS SIZE: ", *-strings_pointers

strings_list
strings_menu
			dta d'NOWA GRA',$FF
			dta d'NAJLEPSI',$FF
			dta	d'HISTORIA',$FF
			dta $ff

strings_bests
			dta d'NAJLEPSI'*,$FF
			dta d'USTAWENIA'*,$FF
			dta d'PAMI%$',$FF
			dta d'DYSKIETKA',$FF
			dta d'INTERNET',$FF

strings_history
strings_history_page0
;           01234567890123456789
			dta d'KRET ',d'STEFAN'*,$FF
			dta d'JEST MA&# NIEZDAR#.',$FF
			dta $FF
			dta d'WSZED& DO MAGAZYNU',$FF
			dta d'PE&NEGO PACZEK',$FF
			dta d'I NIEOPATRZNIE',$FF
			dta d'WSZYSTKIE WYWR(CI&.',$FF
			dta $ff

strings_history_page1
			dta d'SWOJ#  NIEZDARNO)CI#',$FF
			dta d'SPRAWIA,*E  WSZYSTKO',$FF
			dta d'NA NIEGO SPADA.',$FF
			dta $ff

strings_history_page2
			dta d'MUSI ZBIERA$ PACZKI',$ff
			dta d'I UNIKA$ ZGNIECENIA'*,$FF
			dta d'BY ODNALE+$ WYJ)CIE',$FF
			dta d'Z PU&APKI.',$FF
			dta $ff

strings_controls_page3
; Ą - #  Ć - $  Ę - %  Ł - &  Ń - '  Ó - (  Ś - )  Ż - *  Ź - +
;           01234567890123456789
			dta d'PORUSZANIE KRETEM'*,$ff
			dta $ff
			dta d'JOYSTICK',$ff
			dta d'LEWO'*,d'/',d'PRAWO'*,d' CHODZENIE',$ff
			dta d'G(RA'*,d' SKOK',$ff
			dta $ff
			dta d'KLAWIATURA',$ff
			dta d'U*YJ STRZA&EK'*,$ff
			dta d'ESC'*,d' KO''CZY GR%',$ff
			dta $ff

strings_ready
			dta d'SZYKUJ SI%',$FF
			dta d'STEFAN',$FF
			dta $ff

string_gameover
			dta d'STEFAN',$FF
			dta d'PAD&',$FF

strings_top_status
			dta d'PUNKTY',$FF
			dta d'POZIOM',$FF

		.print "STRINGS SIZE: ", *-strings_pointers
