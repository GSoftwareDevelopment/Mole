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
			d' LOGIC ARCADE GAME ', \
			_star, _star, _star, d' AN ORIGINAL IDEA '*, _diamond, \
			d' ANDRZEJ BAKA ', _diamond, \
			d' MARIUSZ BURAS '
		dta _star, _star, _star, \
			d' atari VERSION '*, _diamond, \
			d' CODE '*,d'PAWE& pebe BANA) ', _diamond, \
			d' MUSIC '*,d'PIOTR tatqoo )WIERSZCZ '
		dta _star, _star, _star, \
			d' 2021 gsd '*, \
			_star, _star, _star
		.print "TITLE SCROLL : ", *-titleScroll

historyScroll
		dta d'fire/key NEXT PAGE ', _diamond, \
            d' left/esc BACK'
		.print "HISTORY SCROLL : ", *-historyScroll

bestsListScroll
		dta d'up/down CHANGE PAGE ', _diamond, \
			d' right SETTINGS ', _diamond, d' left/esc BACK'
		.print "BESTS-LIST SCROLL : ", *-bestsListScroll

bestsModeScroll
		dta d'up/down CHANGE MEDIUM ', _diamond, \
			d' fire/enter CHOICE ', _diamond, \
            d' left BACK'
		.print "BESTS-MODE SCROLL : ", *-bestsModeScroll

		.print "SCROLLS SIZE: ", *-scrolls_pointers

