_star = $DB
_diamond = $DC

scrolls_pointers
		dta a(titleScroll)
		dta a(historyScroll)
		dta a(bestsListScroll);
		dta a(bestsModeScroll);

scrolls_list
titleScroll
		dta _star, _star, _star, \
			d' kret ', \
			_star, _star, _star, \
			d' GRA ZR%CZNO)CIOWO-LOGICZNA ', \
			_star, _star, _star, d' ORYGINALNY POMYS& '*, _diamond, \
			d' ANDRZEJ BAKA ', _diamond, \
			d' MARIUSZ BURAS '
;		dta _star, _star, _star, d' zasady  '
;		dta d'PRZEMIESZCZAJ SI% KRETEM I ZJADAJ CEG&Y,JEDNOCZE)NIE,UNIKAJ ZGNIECENIA PRZEZ NIE '*
;		dta _star, _star, _star, d' punktacja  '
;		dta d'IM WY*EJ ZJADASZ,TYM WI%KSZA ILO)$ PUNKT(W '*
;		dta _diamond,d' P%KAJ#CE CEG&Y S# CENNIEJSZE '
;		dta _diamond,d' JE)LI PASEK POST%PU -NA DOLE EKRANU- SI%GNIE ETYKIETY '*,d'level',d', ZWIEKSZA SI% POZIOM TRUDNO)CI '*
;		dta _star, _star, _star, d' ',d'sterowanie '
;		dta d' KLAWIATURA',d' STRZA&KI '*,d'ORAZ',d' RETURN '*,_diamond,d' JOYSTICK',d' PODPI%TY DO PORTU 1 '*
		dta _star, _star, _star, \
			d' WERSJA atari '*, _diamond, \
			d' KOD '*,d'PAWE& pebe BANA) ', _diamond, \
			d' MUZYKA '*,d'PIOTR tatqoo )WIERSZCZ '
		dta _star, _star, _star, \
			d' 2021 gsd '*, \
			_star, _star, _star
		.print "TITLE SCROLL : ", *-titleScroll

historyScroll
		dta d'fire LUB klawisz NAST%PNA STRONA ', _diamond, d' lewo/esc POWR(T'
		.print "HISTORY SCROLL : ", *-historyScroll

bestsListScroll
		dta d'g',$48,d'ra/d',$48,$46, d' ZMIANA STRONY ', _diamond, \
			d' prawo USTAWIENIA ', _diamond, d' lewo/esc POWR(T'
		.print "BESTS-LIST SCROLL : ", *-bestsListScroll

bestsModeScroll
		dta d'g',$48,d'ra/d',$48,$46, d' ZMIANA NO)NIKA ', _diamond, \
			d' fire/enter WYB(R ', _diamond, d' lewo LISTA'
		.print "BESTS-MODE SCROLL : ", *-bestsModeScroll

		.print "SCROLLS SIZE: ", *-scrolls_pointers

