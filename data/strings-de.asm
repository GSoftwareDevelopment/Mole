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
		dta 2, 2 ,9
		dta 3, 6 ,3
		dta 4, 4 ,6
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
			dta d'NEUES SPIEL',_EOL
			dta d'BESTE',_EOL
			dta	d'GESCHICHTE',_EOL
			dta _EOL

strings_bests
			dta d'BESTE'*,_EOL
			dta d'EINSTELLUNGEN'*,_EOL
			dta d'SPEICHER',_EOL
			dta d'DISKETTE',_EOL
			dta d'INTERNET',_EOL

strings_history
strings_history_page0
;           01234567890123456789
			dta d'MAULWURF ',d'STEFAN'*,_EOL
			dta d'IST EIN BISSCHEN',_EOL
			dta d'TOLLPATSCHIG.',_EOL
			dta _EOL
			dta d'ER IST IN EIN LEGER-',_EOL
			dta d'HAUS VOLLER PAKETE',_EOL
			dta d'GELAUDEN UND HAT',_EOL
			dta d'SIE VERSEHENTLICH',_EOL
			dta d'ALLE UMGEWORFEN.',_EOL
			dta _EOL

strings_history_page1
			dta d'SEINE UNGESCHICK-',_EOL
			dta d'LICHKEIT L"&T',_EOL
			dta d'ALLES AUF IHN FALLEN.',_EOL
			dta _EOL

strings_history_page2
			dta d'ER MUSS DIE PAKETE',_EOL
			dta d'EINSEMMELN UND VER-',_EOL
			dta d'MEIDEN ZERQUETSCHT',_EOL
			dta d'ZU WERDEN, UM AUS',_EOL
			dta d'DER FALLE',_EOL
			dta d'HERAUSZUGINDEN.',_EOL
			dta _EOL

strings_controls_page3
; Ą - #  Ć - $  Ę - %  Ł - &  Ń - '  Ó - (  Ś - )  Ż - *  Ź - +
;           01234567890123456789
			dta d'DEN MAULWURF BEWEGEN'*,_EOL
			dta _EOL
			dta d'STEUERKN%PPEL',_EOL
			dta d'LINKS'*,d'/',d'RECHTS'*,d' GEHEN',_EOL
			dta d'NACH OBEN'*,d' SPRINGEN',_EOL
			dta _EOL
			dta d'TASTATUR',_EOL
			dta d'PFEILE BENUTZEN'*,_EOL
			dta d'ESC'*,d' ENDE DAS SPIELS',_EOL
			dta _EOL

strings_ready
			dta d'MACH DICH BEREIT',_EOL
			dta d'STEFAN',_EOL
			dta _EOL

string_gameover
			dta d'STEFAN',_EOL
			dta d'IST GEFALLEN',_EOL

strings_top_status
			dta d'PUNKTE',_EOL
			dta d'STUFE',_EOL

		.print "STRINGS SIZE: ", *-strings_Pointers
