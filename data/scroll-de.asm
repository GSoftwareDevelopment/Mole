.ifdef LANG
		opt h-
		org $7E58
.endif

_star = $DB
_diamond = $DC

scroll_sizes
		dta $B9, $2C, $48, $44

scrolls_Pointers
		dta a(titleScroll)
		dta a(historyScroll)
		dta a(bestsListScroll);
		dta a(bestsModeScroll);

scrolls_list
titleScroll
		dta _star, _star, _star, \
			d' maulwurf ', \
			_star, _star, _star, \
			d' EIN ARCADE- UND LOGIKSPIEL ', \
			_star, _star, _star, d' ORIGINALIDEE VON '*, _diamond, \
			d' ANDRZEJ BAKA ', _diamond, \
			d' MARIUSZ BURAS '
		dta _star, _star, _star, \
			d' atari-VERSION '*, _diamond, \
			d' CODE '*,d'PAWEL pebe BANAS ', _diamond, \
			d' MUSIK '*,d'PIOTR tatqoo SWIERSZCZ '
		dta _star, _star, _star, \
			d' 2021 gsd '*, \
			_star, _star, _star
		.print "TITLE SCROLL : ", *-titleScroll

historyScroll
		dta d'schuss/tase N#CHSTE SEITE ', _diamond, \
        d' links/esc ZUR&CK'
		.print "HISTORY SCROLL : ", *-historyScroll

bestsListScroll
		dta d'nach oben/unten SEITE WECHSELN ', _diamond, \
			  d' rechts EINSTELLUNGEN ', _diamond, \
        d' links/esc ZUR&CK'
		.print "BESTS-LIST SCROLL : ", *-bestsListScroll

bestsModeScroll
		dta d'nach oben/unten MEDIENWECHSEL ', _diamond, \
			  d' schuss/return AUSWAHL ', _diamond, \
        d' links ZUR&CK'
		.print "BESTS-MODE SCROLL : ", *-bestsModeScroll

		.print "SCROLLS SIZE: ", *-scrolls_Pointers

