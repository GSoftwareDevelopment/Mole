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
			dta d'NEW GAME',_EOL
			dta d'HALL OF FAME',_EOL
			dta	d'MOLE STORY',_EOL
			dta _EOL

strings_bests
			dta d'HALL OF FAME'*,_EOL
			dta d'SETTINGS'*,_EOL
			dta d'MEMORY',_EOL
			dta d'DISKIETTE',_EOL
			dta d'INTERNET',_EOL

strings_history
strings_history_page0
;                 01234567890123456789
			dta d'MOLE stefan IS A',_EOL
			dta d'LITTLE CLUMSY GUY.',_EOL
			dta _EOL
			dta d'HE WALKED INTO A',_EOL
			dta d'WAREHAOUSE FULL OF',_EOL
			dta d'PACKS AND FOOLISHLY',_EOL
			dta d'KNOCKS THEM ALL OVER.',_EOL
			dta _EOL

strings_history_page1
;                 01234567890123456789
			dta d'HIS clumsiness',_EOL
			dta d'CAUSES EVERYTHING',_EOL
			dta d'TO FALL ON HIM.',_EOL
			dta _EOL

strings_history_page2
;                 01234567890123456789
			dta d'HE HAS TO',_EOL
			dta d'PICK UP THE packs',_EOL
            dta d'AND',_EOL
            dta d'avoid BEING CRUSHED',_EOL
            dta d'TO FIND HIS WAY OUT',_EOL
			dta d'OF THE TRAP.',_EOL
			dta _EOL

strings_controls_page3
; Ą - #  Ć - $  Ę - %  Ł - &  Ń - '  Ó - (  Ś - )  Ż - *  Ź - +
;           01234567890123456789
			dta d'CONTROLS'*,_EOL
			dta _EOL
			dta d'JOYSTICK',_EOL
			dta d'LEFT'*,d'/',d'RIGHT'*,d' WALKING',_EOL
			dta d'UP'*,d' JUMP',_EOL
			dta _EOL
			dta d'KEYBOARD',_EOL
			dta d'USE ARROWS'*,_EOL
			dta d'ESC'*,d' BREAK GAME',_EOL
			dta _EOL

strings_ready
			dta d'GET  READY',_EOL
			dta d'STEFAN',_EOL
			dta _EOL

string_gameover
			dta d'STEFAN',_EOL
			dta d'HAS FALLEN',_EOL

strings_top_status
			dta d'SCORE',_EOL
			dta d'LEVEL',_EOL

		.print "STRINGS SIZE: ", *-strings_Pointers
