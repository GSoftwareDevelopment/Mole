strings_pointers
			dta a(strings_menu)
			dta a(strings_bests)
			dta a(strings_history_page0)
			dta a(strings_history_page1)
			dta a(strings_history_page2)
			dta a(strings_ready)
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
			dta d'NATURA SPRAWILA,',$FF;
			dta d'ZE URODZILES SIE',$FF
			dta $FF,d'KRETEM'*,$FF,$FF
			dta d'ZATECHLA PIWNICA',$FF
			dta d'STAREGO PALACU',$FF
			dta d'JEST TWOIM DOMEM',$FF
			dta $ff

strings_history_page1
			dta d'WLASCICIEL-SADYSTA',$FF
			dta d'ZRZUCA CI NA GLOWE',$FF
			dta d'GRUZ, NIE WIEDZAC,',$FF
			dta d'ZE JEST ON TWOIM',$FF
			dta d'JEDYNYM POZYWIENIEM.',$FF
			dta $ff

strings_history_page2
			dta d'JEDNAK UWAZAJ'*,$FF
			dta $FF
			dta d'KAZDA CEGLA MOZE',$FF
			dta d'CIE PRZYGNIESC,',$FF
			dta d'SKRACAJAC TWOJ',$FF
			dta d'KRECI ZYWOT',$FF
			dta $ff

strings_ready
			dta d'SZYKUJ SIE',$FF
			dta d'KRECIE',$FF
			dta $ff

strings_top_status
			dta d'PUNKTY',$FF
			dta d'POZIOM',$FF

		.print "STRINGS SIZE: ", *-strings_pointers

