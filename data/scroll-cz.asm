.ifdef LANG
		opt h-
		org $7E58
.endif

_star = $DB
_diamond = $DC

scroll_sizes
		dta $B0, $28, $3d, $40

scrolls_Pointers
		dta a(titleScroll)
		dta a(historyScroll)
		dta a(bestsListScroll);
		dta a(bestsModeScroll);

scrolls_list
titleScroll
		dta _star, _star, _star, \
			d' KRTEK ', \
			_star, _star, _star, \
			d' ARK"DOV" A LOGICK" HRA ', \
			_star, _star, _star, d' P+VODN& N"PAD '*, _diamond, \
			d' ANDRZEJ BAKA ', _diamond, \
			d' MARIUSZ BURAS '
		dta _star, _star, _star, \
			d' VERZE PRO atari '*, _diamond, \
			d' K'*,b($87),d'D '*,d'PAWEL pebe BANAS ', _diamond, \
			d' HUDBA '*,d'PIOTR tatqoo SWIERSZCZ '
		dta _star, _star, _star, \
			d' 2021 gsd '*, \
			_star, _star, _star
		.print "TITLE SCROLL : ", *-titleScroll

historyScroll
		dta d'ohe',$5d,d'/kli',$43,d' DAL)& STR"NKA ', _diamond, \
		    d' vlevo/esc ZP$T'
		.print "HISTORY SCROLL : ", *-historyScroll

bestsListScroll
		dta d'nahoru/dol',$4a,d' ZM$NIT STR"NKU ', _diamond, \
			  d' prav',$45,d' NASTAVEN& ', _diamond, \
				d' vlevo/esc ZP$R'
		.print "BESTS-LIST SCROLL : ", *-bestsListScroll

bestsModeScroll
		dta d'nahoru/dol',$4a,d' ZM$NA M%DIA ', _diamond, \
		    d' ohe',$5d,d'/return V+B$R ', _diamond, \
			  d' vlevo HORN& SEZNAM'
		.print "BESTS-MODE SCROLL : ", *-bestsModeScroll

		.print "SCROLLS SIZE: ", *-scrolls_Pointers

