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
			dta d'NOV" HRA',_EOL
			dta d'NAJLEP)&',_EOL
			dta	d'HISTORIE',_EOL
			dta _EOL

strings_bests
			dta d'NAJLEP)&'*,_EOL
			dta d'NASTAVENI'*,_EOL
			dta d'PAMI$T',_EOL
			dta d'DYSKETA',_EOL
			dta d'INTERNET',_EOL

strings_history
strings_history_page0
;           01234567890123456789
			dta d'KRTEK STEFAN',_EOL
			dta d'JE TROCHU NEOGRABAN+.',_EOL
			dta _EOL
			dta d'VSTOUPIL DO SKLADU',_EOL
			dta d'PLN%HO BAL&K*',_EOL
			dta d'A NECHT$N$ JE',_EOL
			dta d'V)ECHNY P(EVR"TIL.',_EOL
			dta _EOL

strings_history_page1
			dta d'D&KY SV% NE)IKOVNOSTI',_EOL
			dta d'ZP*SOB&, @E NA N$J',_EOL
			dta d'V)ECHNO SPADNE.',_EOL
			dta _EOL

strings_history_page2
			dta d'ABY NA)EL CESTU VEN',_EOL
			dta d'Z PASTI, MUS& BAL&KY',_EOL
			dta d'POSB&RAT A VYHNOUT',_EOL
			dta d'SE JEJICH ROZDRCEM&.',_EOL
			dta _EOL

strings_controls_page3
; Á - "  Č - #  Ě - $  É - %  Í - &  Ó - '  Ř - (  Š - )  Ů - *  Ý - +  Ž - @
;           01234567890123456789

			dta d'ST$HOV"N& KRTKA'*,_EOL
			dta _EOL
			dta d'JOYSTICK',_EOL
			dta d'CH*ZE VLEVO/VPRAVO',_EOL
			dta d'SKOK NAHORU',_EOL
			dta _EOL
			dta d'KL"VESNICE',_EOL
			dta d'POU@IT& )IPEK'*,_EOL
			dta d'ESC'*,d' UKON#& HRU',_EOL
			dta _EOL

strings_ready
			dta d'P(IPRAVTE SE',_EOL
			dta d'STEFAN',_EOL
			dta _EOL

string_gameover
			dta d'STEFAN',_EOL
			dta d'PADL',_EOL

strings_top_status
			dta d'BODY',_EOL
			dta d'*ROVEN',_EOL

		.print "STRINGS SIZE: ", *-strings_Pointers
