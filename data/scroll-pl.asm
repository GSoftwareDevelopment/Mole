.ifdef LANG
		opt h-
		org $7E58
.endif

_star = $DB
_diamond = $DC

scroll_sizes
		dta $B5, $32, $3B, $37

scrolls_Pointers
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

		.print "SCROLLS SIZE: ", *-scrolls_Pointers

