scrolls_pointers
		dta a(titleScroll)
		dta a(historyScroll)
		dta a(bestsListScroll);
		dta a(bestsModeScroll);

scrolls_list
titleScroll
		dta d'GRA ZR%CZNO)CIOWO-LOGICZNA.ORYGINALNIE NAPISANA NA KOMPUTER PC W 1991 ROKU.JEJ TW(RCAMI S# '*
		dta d'andrzej baka',d' I '*,d'mariusz buras '
		dta $DB, $DB, $DB, d' zasady  '
		dta d'PRZEMIESZCZAJ SI% KRETEM I ZJADAJ CEG&Y,JEDNOCZE)NIE,UNIKAJ ZGNIECENIA PRZEZ NIE '*
		dta $DB, $DB, $DB, d' punktacja  '
		dta d'IM WY*EJ ZJADASZ,TYM WI%KSZA ILO)$ PUNKT(W '*
		dta $DC,d' P%KAJ#CE CEG&Y S# CENNIEJSZE '
		dta $DC,d' JE)LI PASEK POST%PU -NA DOLE EKRANU- SI%GNIE ETYKIETY '*,d'bonus',d', PRZEJDZIESZ DO RUNDY BONUSOWEJ '*
		dta $DB, $DB, $DB, d' ',d'sterowanie '
		dta d' KLAWIATURA',d' STRZA&KI '*,d'ORAZ',d' RETURN '*,$DC,d' JOYSTICK',d' PODPI%TY DO PORTU 1 '*
		dta $DB, $DB, $DB, d' WERSJA atari  '*,D'PAWE& pebe BANA)  '
		dta d'2021 gsd'
		.print "TITLE SCROLL : ", *-titleScroll

historyScroll
		dta d'fire LUB klawisz NAST%PNA STRONA ',$DC,d' lewo/esc POWR(T'
		.print "HISTORY SCROLL : ", *-historyScroll

bestsListScroll
		dta d'g',$48,d'ra/d',$48,$46,d' ZMIANA STRONY ',$DC,d' prawo USTAWIENIA ',$DC,d' lewo/esc POWR(T'
		.print "BESTS-LIST SCROLL : ", *-bestsListScroll

bestsModeScroll
		dta d'g',$48,d'ra/d',$48,$46,d' ZMIANA NO)NIKA ',$DC,d' fire/enter WYB(R ',$DC,d' lewo LISTA'
		.print "BESTS-MODE SCROLL : ", *-bestsModeScroll

		.print "SCROLLS SIZE: ", *-scrolls_pointers

